Return-Path: <linux-kernel-owner+w=401wt.eu-S1754526AbZGFTHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526AbZGFTHJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 15:07:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751806AbZGFTG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 15:06:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:49986 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbZGFTG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 15:06:57 -0400
Date: Mon, 06 Jul 2009 14:07:01 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: davem@davemloft.net
Cc: linux-wireless@vger.kernel.org, chunkeey@web.de,
       linux-kernel@vger.kernel.org
Subject: [PATCH] p54: Fix regression in 2.6.31-rcX since commit a1091aa -
 sleeping function called from invalid context
Message-ID: <4a524b55.wIWqgs5uHs2CpdJy%Larry.Finger@lwfinger.net>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Beginning with commit a1091aae19b1d9c85d91c86915a611387f67a26b entitled
"p54: Use SKB list handling helpers instead of by-hand code.", the following
appears in my logs whenever I try to use my p54usb wireless device:

BUG: sleeping function called from invalid context at arch/x86/mm/fault.c:1085
 in_atomic(): 0, irqs_disabled(): 1, pid: 8538, name: modprobe
 2 locks held by modprobe/8538:
  #0:  (&local->queue_stop_reason_lock){-.-...}, at: [<ffffffffa023b99f>]
        ieee80211_stop_queues_by_reason+0x28/0x5e [mac80211]
  #1:  (&mm->mmap_sem){++++++}, at: [<ffffffff80225a4f>] do_page_fault+0xd2/0x1fe
 irq event stamp: 25212
 hardirqs last  enabled at (25211): [<ffffffff80451f28>] _spin_unlock_irqrestore+0x3f/0x47
 hardirqs last disabled at (25212): [<ffffffff804520e3>] _spin_lock_irqsave+0x17/0x4b
 softirqs last  enabled at (24064): [<ffffffff803e9997>] sk_filter+0xba/0xc3
 softirqs last disabled at (24062): [<ffffffff803e98f3>] sk_filter+0x16/0xc3
 Pid: 8538, comm: modprobe Not tainted 2.6.30-rc6-Linus-00905-g46c3767-dirty #180
 Call Trace:
  [<ffffffff8025af90>] ? print_irqtrace_events+0xd0/0xd4
  [<ffffffff80233384>] __might_sleep+0xf4/0xf6
  [<ffffffff80225a99>] do_page_fault+0x11c/0x1fe
  [<ffffffff80451f28>] ? _spin_unlock_irqrestore+0x3f/0x47
  [<ffffffff804525cf>] page_fault+0x1f/0x30
  [<ffffffff80451f28>] ? _spin_unlock_irqrestore+0x3f/0x47
  [<ffffffffa023b99f>] ? ieee80211_stop_queues_by_reason+0x28/0x5e [mac80211]
  [<ffffffffa023b92b>] ? __ieee80211_stop_queue+0x36/0x82 [mac80211]
  [<ffffffff8045210b>] ? _spin_lock_irqsave+0x3f/0x4b
  [<ffffffffa023b9b3>] ieee80211_stop_queues_by_reason+0x3c/0x5e [mac80211]
  [<ffffffffa023b9e0>] ieee80211_stop_queues+0xb/0xd [mac80211]
  [<ffffffffa047c35c>] p54_assign_address+0x164/0x1ec [p54common]
  [<ffffffffa047c49a>] p54_alloc_skb+0xb6/0xd3 [p54common]
...

Reverting the hunk that affects p54_assign_address() fixes the problem. When I
tried to determine which change(s) caused the problem, the skb_peek_tail()
seemed to be the problem; however, the system would freeze. I was not able to
recover any log information.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

diff --git a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
index b618bd1..c5bc55a 100644
--- a/drivers/net/wireless/p54/p54common.c
+++ b/drivers/net/wireless/p54/p54common.c
@@ -1164,21 +1164,23 @@ static int p54_assign_address(struct ieee80211_hw *dev, struct sk_buff *skb,
 		}
 	}
 
-	skb_queue_walk(&priv->tx_queue, entry) {
+	entry = priv->tx_queue.next;
+	while (left--) {
 		u32 hole_size;
 		info = IEEE80211_SKB_CB(entry);
 		range = (void *)info->rate_driver_data;
 		hole_size = range->start_addr - last_addr;
 		if (!target_skb && hole_size >= len) {
-			target_skb = skb_queue_prev(&priv->tx_queue, entry);
+			target_skb = entry->prev;
 			hole_size -= len;
 			target_addr = last_addr;
 		}
 		largest_hole = max(largest_hole, hole_size);
 		last_addr = range->end_addr;
+		entry = entry->next;
 	}
 	if (!target_skb && priv->rx_end - last_addr >= len) {
-		target_skb = skb_peek_tail(&priv->tx_queue);
+		target_skb = priv->tx_queue.prev;
 		largest_hole = max(largest_hole, priv->rx_end - last_addr - len);
 		if (!skb_queue_empty(&priv->tx_queue)) {
 			info = IEEE80211_SKB_CB(target_skb);


