Return-Path: <linux-kernel-owner+w=401wt.eu-S1754246Ab0AFCZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab0AFCZ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 21:25:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753256Ab0AFCZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 21:25:25 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:58236 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752382Ab0AFCZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 21:25:24 -0500
Date: Wed, 6 Jan 2010 13:25:20 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: linux-next: manual merge of the net tree with the wireless-current
 tree
Message-Id: <20100106132520.89e75a15.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta4 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the net tree got a conflict in
net/mac80211/iface.c between commit
cf0277e714a0db302a8f80e1b85fd61c32cf00b3 ("mac80211: fix skb buffering
issue") from the wireless-current tree and commit
47846c9b0c10808d9337d2e7d09361f3e0a0a71a ("mac80211: reduce reliance on
netdev") from the net tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc net/mac80211/iface.c
index c261cdb,00a1f4c..0000000
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@@ -659,35 -664,9 +672,35 @@@ static const struct net_device_ops ieee
  	.ndo_start_xmit		= ieee80211_subif_start_xmit,
  	.ndo_set_multicast_list = ieee80211_set_multicast_list,
  	.ndo_change_mtu 	= ieee80211_change_mtu,
- 	.ndo_set_mac_address 	= eth_mac_addr,
+ 	.ndo_set_mac_address 	= ieee80211_change_mac,
 +	.ndo_select_queue	= ieee80211_netdev_select_queue,
  };
  
 +static u16 ieee80211_monitor_select_queue(struct net_device *dev,
 +					  struct sk_buff *skb)
 +{
 +	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 +	struct ieee80211_local *local = sdata->local;
 +	struct ieee80211_hdr *hdr;
 +	struct ieee80211_radiotap_header *rtap = (void *)skb->data;
 +
 +	if (local->hw.queues < 4)
 +		return 0;
 +
 +	if (skb->len < 4 ||
 +	    skb->len < rtap->it_len + 2 /* frame control */)
 +		return 0; /* doesn't matter, frame will be dropped */
 +
 +	hdr = (void *)((u8 *)skb->data + rtap->it_len);
 +
 +	if (!ieee80211_is_data(hdr->frame_control)) {
 +		skb->priority = 7;
 +		return ieee802_1d_to_ac[skb->priority];
 +	}
 +
 +	return ieee80211_downgrade_queue(local, skb);
 +}
 +
  static const struct net_device_ops ieee80211_monitorif_ops = {
  	.ndo_open		= ieee80211_open,
  	.ndo_stop		= ieee80211_stop,
