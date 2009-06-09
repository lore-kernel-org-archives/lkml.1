Return-Path: <linux-kernel-owner+w=401wt.eu-S1759950AbZFIKXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759950AbZFIKXG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:23:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760596AbZFIKSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:18:53 -0400
Received: from kroah.org ([198.145.64.141]:54658 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760605AbZFIKSw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:18:52 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 02:40:58 2009
Message-Id: <20090609094058.539735772@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 02:39:16 -0700
From: Greg KH <gregkh@suse.de>
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
       "John W. Linville" <linville@tuxdriver.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 28/87] cfg80211: fix race between core hint and drivers custom apply
References: <20090609093848.204935043@blue.kroah.org>
Content-Disposition: inline; filename=cfg80211-fix-race-between-core-hint-and-driver-s-custom-apply.patch
In-Reply-To: <20090609094451.GA26439@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Luis R. Rodriguez <lrodriguez@atheros.com>

commit 5078b2e32ad4b1f753b1c837c15892202f753c97 upstream.

Its possible for cfg80211 to have scheduled the work and for
the global workqueue to not have kicked in prior to a cfg80211
driver's regulatory hint or wiphy_apply_custom_regulatory().

Although this is very unlikely its possible and should fix
this race. When this race would happen you are expected to have
hit a null pointer dereference panic.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Tested-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/wireless/reg.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1497,6 +1497,13 @@ int regulatory_init(void)
 		       "using static definition\n");
 #endif
 
+	/*
+	 * This ensures last_request is populated once modules
+	 * come swinging in and calling regulatory hints and
+	 * wiphy_apply_custom_regulatory().
+	 */
+	flush_scheduled_work();
+
 	return 0;
 }
 


