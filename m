Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936347Ab0CMBTA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:19:00 -0500
Received: from kroah.org ([198.145.64.141]:60966 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934978Ab0CMAUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:20:40 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:12 2010
Message-Id: <20100313001512.067454511@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:12:57 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Felix Fietkau <nbd@openwrt.org>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 079/123] mac80211: do not transmit frames on unconfigured 4-addr vlan interfaces
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Felix Fietkau <nbd@openwrt.org>

commit 3f0e0b220f80075ce15483b20458192c0ac27426 upstream.

If frames are transmitted on 4-addr ap vlan interfaces with no station,
they end up being transmitted unencrypted, even if the ap interface
uses WPA. This patch add some sanity checking to make sure that this
does not happen.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/tx.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1052,8 +1052,11 @@ ieee80211_tx_prepare(struct ieee80211_su
 
 	hdr = (struct ieee80211_hdr *) skb->data;
 
-	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN) {
 		tx->sta = rcu_dereference(sdata->u.vlan.sta);
+		if (!tx->sta && sdata->dev->ieee80211_ptr->use_4addr)
+			return TX_DROP;
+	}
 	if (!tx->sta)
 		tx->sta = sta_info_get(local, hdr->addr1);
 


