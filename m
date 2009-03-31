Return-Path: <linux-kernel-owner+w=401wt.eu-S932085AbZCaX15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085AbZCaX15 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 19:27:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763354AbZCaXUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 19:20:46 -0400
Received: from sous-sol.org ([216.99.217.87]:33191 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756878AbZCaXUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 19:20:44 -0400
Message-Id: <20090331231558.942323600@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Tue, 31 Mar 2009 16:11:08 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       John W Linville <linville@tuxdriver.com>
Subject: [patch 23/45] cfg80211: force last_request to be set for OLD_REG if regdom is EU
References: <20090331231045.719396245@sous-sol.org>
Content-Disposition: inline; filename=cfg80211-force-last_request-to-be-set-for-old_reg-if-regdom-is-eu.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Luis R. Rodriguez <lrodriguez@atheros.com>

upstream commit: 2e097dc65673ed421bbc2e49f52c125aa43a8ee6

Although EU is a bogus alpha2 we need to process the send request
as our code depends on last_request being set.

Cc: stable@kernel.org
Reported-by: Quentin Armitage <Quentin@armitage.org.uk>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
[chrisw: backport to 2.6.29]
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Port-acked-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

 net/wireless/reg.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1469,13 +1469,20 @@ int regulatory_init(void)
 
 	printk(KERN_INFO "cfg80211: Using static regulatory domain info\n");
 	print_regdomain_info(cfg80211_regdomain);
-	/* The old code still requests for a new regdomain and if
+	/*
+	 * The old code still requests for a new regdomain and if
 	 * you have CRDA you get it updated, otherwise you get
 	 * stuck with the static values. We ignore "EU" code as
-	 * that is not a valid ISO / IEC 3166 alpha2 */
-	if (ieee80211_regdom[0] != 'E' || ieee80211_regdom[1] != 'U')
-		err = __regulatory_hint(NULL, REGDOM_SET_BY_CORE,
-					ieee80211_regdom, 0, ENVIRON_ANY);
+	 * that is not a valid ISO / IEC 3166 alpha2
+	 * stuck with the static values. Since "EU" is not a valid
+	 * ISO / IEC 3166 alpha2 code we can't expect userpace to
+	 * give us a regulatory domain for it. We need last_request
+	 * iniitalized though so lets just send a request which we
+	 * know will be ignored... this crap will be removed once
+	 * OLD_REG dies.
+	 */
+	err = __regulatory_hint(NULL, REGDOM_SET_BY_CORE,
+				ieee80211_regdom, 0, ENVIRON_ANY);
 #else
 	cfg80211_regdomain = cfg80211_world_regdom;
 

