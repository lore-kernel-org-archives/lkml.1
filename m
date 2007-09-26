Return-Path: <linux-kernel-owner+w=401wt.eu-S1761984AbXIZRLO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761984AbXIZRLO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 13:11:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761256AbXIZRKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 13:10:20 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:57511 "EHLO
	fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760170AbXIZRKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 13:10:18 -0400
Date: Wed, 26 Sep 2007 19:07:18 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Timo Jantunen <jeti@welho.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: commit 6dccd16b7c2703e8bbf8bca62b5cf248332afbe2 kills r8169 send performance
Message-ID: <20070926170718.GA4870@electric-eye.fr.zoreil.com>
References: <Pine.LNX.4.64.0709261853110.5869@limbo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709261853110.5869@limbo>
User-Agent: Mutt/1.4.2.1i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Timo Jantunen <jeti@welho.com> :
[...]
> Git bisect gave commit 6dccd16b7c2703e8bbf8bca62b5cf248332afbe2 as the 
> culprit, and reverting it from the 2.6.23-rc8 increases send speed back to 
> .22 level. (It didn't revert cleanly and the file needed some cleaning up 
> by hand.)

You are welcome but you are late.

The patch below is scheduled for inclusion before 2.6.23. Please try it and
see if it makes a difference on top of 2.6.23-rc8 (full dmesg will be welcome
too).

diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
index b85ab4a..c921ec3 100644
--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -1228,7 +1228,10 @@ static void rtl8169_hw_phy_config(struct net_device *dev)
 		return;
 	}
 
-	/* phy config for RTL8169s mac_version C chip */
+	if ((tp->mac_version != RTL_GIGA_MAC_VER_02) &&
+	    (tp->mac_version != RTL_GIGA_MAC_VER_03))
+		return;
+
 	mdio_write(ioaddr, 31, 0x0001);			//w 31 2 0 1
 	mdio_write(ioaddr, 21, 0x1000);			//w 21 15 0 1000
 	mdio_write(ioaddr, 24, 0x65c7);			//w 24 15 0 65c7
@@ -2567,6 +2570,15 @@ static void rtl8169_tx_interrupt(struct net_device *dev,
 		    (TX_BUFFS_AVAIL(tp) >= MAX_SKB_FRAGS)) {
 			netif_wake_queue(dev);
 		}
+		/*
+		 * 8168 hack: TxPoll requests are lost when the Tx packets are
+		 * too close. Let's kick an extra TxPoll request when a burst
+		 * of start_xmit activity is detected (if it is not detected,
+		 * it is slow enough). -- FR
+		 */
+		smp_rmb();
+		if (tp->cur_tx != dirty_tx)
+			RTL_W8(TxPoll, NPQ);
 	}
 }
 
-- 
Ueimor
