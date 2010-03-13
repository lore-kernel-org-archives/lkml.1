Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934819Ab0CMBey (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:34:54 -0500
Received: from kroah.org ([198.145.64.141]:60553 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934796Ab0CMATi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:19:38 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:06 2010
Message-Id: <20100313001506.065002368@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:11:48 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Vivek Natarajan <vnatarajan@atheros.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 010/123] mac80211: Reset dynamic ps timer in Rx path.
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Vivek Natarajan <vnatarajan@atheros.com>

commit e15276a4b220c54db665cf46a92bd9ceb9aeb052 upstream.

The current mac80211 implementation enables power save if there
is no Tx traffic for a specific timeout. Hence, PS is triggered
even if there is a continuous Rx only traffic(like UDP) going on.
This makes the drivers to wait on the tim bit in the next beacon
to awake which leads to redundant sleep-wake cycles.
Fix this by restarting the dynamic ps timer on receiving every
data packet.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/rx.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1788,6 +1788,7 @@ static ieee80211_rx_result debug_noinlin
 ieee80211_rx_h_data(struct ieee80211_rx_data *rx)
 {
 	struct ieee80211_sub_if_data *sdata = rx->sdata;
+	struct ieee80211_local *local = rx->local;
 	struct net_device *dev = sdata->dev;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
 	__le16 fc = hdr->frame_control;
@@ -1819,6 +1820,13 @@ ieee80211_rx_h_data(struct ieee80211_rx_
 	dev->stats.rx_packets++;
 	dev->stats.rx_bytes += rx->skb->len;
 
+	if (ieee80211_is_data(hdr->frame_control) &&
+	    !is_multicast_ether_addr(hdr->addr1) &&
+	    local->hw.conf.dynamic_ps_timeout > 0 && local->ps_sdata) {
+			mod_timer(&local->dynamic_ps_timer, jiffies +
+			 msecs_to_jiffies(local->hw.conf.dynamic_ps_timeout));
+	}
+
 	ieee80211_deliver_skb(rx);
 
 	return RX_QUEUED;


