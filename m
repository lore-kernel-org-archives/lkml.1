Return-Path: <linux-kernel-owner+w=401wt.eu-S1764902AbZCaXis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764902AbZCaXis (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 19:38:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764241AbZCaXWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 19:22:42 -0400
Received: from sous-sol.org ([216.99.217.87]:33364 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764284AbZCaXWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 19:22:40 -0400
Message-Id: <20090331231815.480074017@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Tue, 31 Mar 2009 16:11:29 -0700
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
Subject: [patch 44/45] cfg80211: fix incorrect assumption on last_request for 11d
References: <20090331231045.719396245@sous-sol.org>
Content-Disposition: inline; filename=cfg80211-fix-incorrect-assumption-on-last_request-for-11d.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Luis R. Rodriguez <lrodriguez@atheros.com>

upstream commit: cc0b6fe88e99096868bdbacbf486c97299533b5a

The incorrect assumption is the last regulatory request
(last_request) is always a country IE when processing
country IEs. Although this is true 99% of the time the
first time this happens this could not be true.

This fixes an oops in the branch check for the last_request
when accessing drv_last_ie. The access was done under the
assumption the struct won't be null.

Note to stable: to port to 29 replace as follows, only 29 has
country IE code:

s|NL80211_REGDOM_SET_BY_COUNTRY_IE|REGDOM_SET_BY_COUNTRY_IE

Cc: stable@kernel.org
Reported-by: Quentin Armitage <Quentin@armitage.org.uk>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
[chrisw: backport to 2.6.29]
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 net/wireless/reg.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1083,6 +1083,8 @@ EXPORT_SYMBOL(regulatory_hint);
 static bool reg_same_country_ie_hint(struct wiphy *wiphy,
 			u32 country_ie_checksum)
 {
+	if (unlikely(last_request->initiator != REGDOM_SET_BY_COUNTRY_IE))
+		return false;
 	if (!last_request->wiphy)
 		return false;
 	if (likely(last_request->wiphy != wiphy))
@@ -1133,7 +1135,9 @@ void regulatory_hint_11d(struct wiphy *w
 	/* We will run this for *every* beacon processed for the BSSID, so
 	 * we optimize an early check to exit out early if we don't have to
 	 * do anything */
-	if (likely(last_request->wiphy)) {
+	if (likely(last_request->initiator ==
+	    REGDOM_SET_BY_COUNTRY_IE &&
+	    likely(last_request->wiphy))) {
 		struct cfg80211_registered_device *drv_last_ie;
 
 		drv_last_ie = wiphy_to_dev(last_request->wiphy);

