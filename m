Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935392Ab0CMAb2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:31:28 -0500
Received: from kroah.org ([198.145.64.141]:46632 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935326Ab0CMAai (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:30:38 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:06 2010
Message-Id: <20100313002706.179713931@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:25:44 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Daniel Halperin <dhalperi@cs.washington.edu>,
       Wey-Yi Guy <wey-yi.w.guy@intel.com>,
       Reinette Chatre <reinette.chatre@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [011/145] iwlwifi: set HT flags after channel in rxon
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
From: Dan Halperin <dhalperi@cs.washington.edu>

commit 5e2f75b8993a0d83d469388b50716dd5551f2eb4 upstream.

The HT extension channel settings require priv->staging_rxon.channel to be
accurate. However, iwl_set_rxon_ht was being called before iwl_set_rxon_channel
and thus HT40 could be broken unless another call to iwl_mac_config came in.

This problem was recently introduced by "iwlwifi: Fix to set correct ht
configuration"

The particular setting in which I noticed this was monitor mode:

	iwconfig wlan0 mode monitor
	ifconfig wlan0 up
	./iw wlan0 set channel 64 HT40-
	#./iw wlan0 set channel 64 HT40-
	tcpdump -i wlan0 -y IEEE802_11_RADIO

would only catch HT40 packets if I issued the IW command twice.

>From visual inspection, iwl_set_rxon_channel does not depend on
iwl_set_rxon_ht, so simply swapping them should be safe and fixes this problem.

Signed-off-by: Daniel Halperin <dhalperi@cs.washington.edu>
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2645,8 +2645,8 @@ int iwl_mac_config(struct ieee80211_hw *
 		if ((le16_to_cpu(priv->staging_rxon.channel) != ch))
 			priv->staging_rxon.flags = 0;
 
-		iwl_set_rxon_ht(priv, ht_conf);
 		iwl_set_rxon_channel(priv, conf->channel);
+		iwl_set_rxon_ht(priv, ht_conf);
 
 		iwl_set_flags_for_band(priv, conf->channel->band);
 		spin_unlock_irqrestore(&priv->lock, flags);


