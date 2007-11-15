Return-Path: <linux-kernel-owner+w=401wt.eu-S1762270AbXKOGbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762270AbXKOGbM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:31:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755994AbXKOGWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:22:33 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:46045 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764737AbXKOGWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:22:30 -0500
Date: Wed, 14 Nov 2007 22:21:01 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Johannes Berg <johannes@sipsolutions.net>,
       linux-wireless@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>,
       Michael Wu <flamingice@sourmilk.net>
Subject: [patch 18/23] mac80211: reorder association debug output
Message-ID: <20071115062100.GS8282@kroah.com>
References: <20071115055238.692814352@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="mac80211-reorder-association-debug-output.patch"
In-Reply-To: <20071115061806.GA8282@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Johannes Berg <johannes@sipsolutions.net>

patch 1dd84aa213d0f98a91a1ec9be2f750f5f48e75a0 in mainline.

There's no reason to warn about an invalid AID field when the
association was denied.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Acked-by: Michael Wu <flamingice@sourmilk.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/ieee80211_sta.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -1174,15 +1174,11 @@ static void ieee80211_rx_mgmt_assoc_resp
 	capab_info = le16_to_cpu(mgmt->u.assoc_resp.capab_info);
 	status_code = le16_to_cpu(mgmt->u.assoc_resp.status_code);
 	aid = le16_to_cpu(mgmt->u.assoc_resp.aid);
-	if ((aid & (BIT(15) | BIT(14))) != (BIT(15) | BIT(14)))
-		printk(KERN_DEBUG "%s: invalid aid value %d; bits 15:14 not "
-		       "set\n", dev->name, aid);
-	aid &= ~(BIT(15) | BIT(14));
 
 	printk(KERN_DEBUG "%s: RX %sssocResp from " MAC_FMT " (capab=0x%x "
 	       "status=%d aid=%d)\n",
 	       dev->name, reassoc ? "Rea" : "A", MAC_ARG(mgmt->sa),
-	       capab_info, status_code, aid);
+	       capab_info, status_code, aid & ~(BIT(15) | BIT(14)));
 
 	if (status_code != WLAN_STATUS_SUCCESS) {
 		printk(KERN_DEBUG "%s: AP denied association (code=%d)\n",
@@ -1192,6 +1188,11 @@ static void ieee80211_rx_mgmt_assoc_resp
 		return;
 	}
 
+	if ((aid & (BIT(15) | BIT(14))) != (BIT(15) | BIT(14)))
+		printk(KERN_DEBUG "%s: invalid aid value %d; bits 15:14 not "
+		       "set\n", dev->name, aid);
+	aid &= ~(BIT(15) | BIT(14));
+
 	pos = mgmt->u.assoc_resp.variable;
 	if (ieee802_11_parse_elems(pos, len - (pos - (u8 *) mgmt), &elems)
 	    == ParseFailed) {

-- 
