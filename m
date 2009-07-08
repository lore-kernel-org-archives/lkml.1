Return-Path: <linux-kernel-owner+w=401wt.eu-S1755577AbZGHNdC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577AbZGHNdC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 09:33:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753409AbZGHNcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 09:32:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:40069 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886AbZGHNcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 09:32:53 -0400
Date: Wed, 08 Jul 2009 08:33:02 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: chunkeey@web.de, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, rjw@sisk.pl, davem@davemloft.net
Subject: [PATCH] p54: Fix for Bugzilla #13725 - tx refused but queue
 active
Message-ID: <4a54a00e.f/eBx8U+poa0aDtQ%Larry.Finger@lwfinger.net>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the mainline kernel, p54usb will fail because the TX queue length can
become < 0. This problem has been reported as Bugzilla #13725. The failure
is expressed by the following message in the logs:

WARNING: at net/mac80211/tx.c:1325 ieee80211_tx+0x23c/0x298 [mac80211]()
Hardware name: HP Pavilion dv2700 Notebook PC
tx refused but queue active

This problem has been recently observed in the wireless-testing tree, where
a full solution is being tested. That fix is too invasive for 2.6.31-rcX,
but the simple change supplied here will prevent the failure.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This patch should be sent to mainline. As stated above, it should not be
applied to wireless-testing.

Thanks,

Larry
---

Index: linux-2.6/drivers/net/wireless/p54/p54common.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/p54/p54common.c
+++ linux-2.6/drivers/net/wireless/p54/p54common.c
@@ -912,13 +912,14 @@ static void p54_rx_frame_sent(struct iee
 		}
 
 		__skb_unlink(entry, &priv->tx_queue);
-		spin_unlock_irqrestore(&priv->tx_queue.lock, flags);
 
 		frame_len = entry->len;
 		entry_hdr = (struct p54_hdr *) entry->data;
 		entry_data = (struct p54_tx_data *) entry_hdr->data;
-		priv->tx_stats[entry_data->hw_queue].len--;
+		if (priv->tx_stats[entry_data->hw_queue].len)
+			priv->tx_stats[entry_data->hw_queue].len--;
 		priv->stats.dot11ACKFailureCount += payload->tries - 1;
+		spin_unlock_irqrestore(&priv->tx_queue.lock, flags);
 
 		/*
 		 * Frames in P54_QUEUE_FWSCAN and P54_QUEUE_BEACON are

---
