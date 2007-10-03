Return-Path: <linux-kernel-owner+w=401wt.eu-S1756639AbXJCOVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639AbXJCOVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 10:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754635AbXJCOVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 10:21:07 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:52545 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754520AbXJCOVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 10:21:06 -0400
Date: Wed, 3 Oct 2007 17:21:04 +0300 (EEST)
From: Timo Jantunen <jeti@welho.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.23-rc9 and a heads-up for the 2.6.24 series..
In-Reply-To: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0710031708260.5847@limbo>
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Oct 2007, Linus Torvalds wrote:

> So there's a final -rc out there, and right now my plan is to make this 
> series really short, and release 2.6.23 in a few days. So please do give 
> it a last good testing, and holler about any issues you find!

The r8169 nic performance regression is still there.

2.6.22: send 82MB/s, receive 86MB/s
2.6.23-rc9: send 32MB/s, receive 98MB/s

I debugged this with Francois Romieu but haven't heard from him since 
testing his fixes.

I attached a patch from him which is a partial revert of commit 
6dccd16b7c2703e8bbf8bca62b5cf248332afbe2.

With this patch I get 93MB send and 97MB receive and I have been running it 
for a week but I don't know if the patch has any downsides on other 
systems.


//T

> 			Linus



>From 34875931ba2e473e2867d941980131edd609dbe4 Mon Sep 17 00:00:00 2001
From: Francois Romieu <romieu@fr.zoreil.com>
Date: Wed, 26 Sep 2007 23:44:03 +0200
Subject: [PATCH] r8169: more revert

Part of 6dccd16b7c2703e8bbf8bca62b5cf248332afbe2.

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
---
 drivers/net/r8169.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
index cb4c412..6d8611c 100644
--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -1905,7 +1905,11 @@ static void rtl_hw_start_8169(struct net_device *dev)
 
 	rtl_set_rx_max_size(ioaddr);
 
-	rtl_set_rx_tx_config_registers(tp);
+	if ((tp->mac_version == RTL_GIGA_MAC_VER_01) ||
+	    (tp->mac_version == RTL_GIGA_MAC_VER_02) ||
+	    (tp->mac_version == RTL_GIGA_MAC_VER_03) ||
+	    (tp->mac_version == RTL_GIGA_MAC_VER_04))
+		rtl_set_rx_tx_config_registers(tp);
 
 	tp->cp_cmd |= rtl_rw_cpluscmd(ioaddr) | PCIMulRW;
 
@@ -1926,6 +1930,14 @@ static void rtl_hw_start_8169(struct net_device *dev)
 
 	rtl_set_rx_tx_desc_registers(tp, ioaddr);
 
+	if ((tp->mac_version != RTL_GIGA_MAC_VER_01) &&
+	    (tp->mac_version != RTL_GIGA_MAC_VER_02) &&
+	    (tp->mac_version != RTL_GIGA_MAC_VER_03) &&
+	    (tp->mac_version != RTL_GIGA_MAC_VER_04)) {
+		RTL_W8(ChipCmd, CmdTxEnb | CmdRxEnb);
+		rtl_set_rx_tx_config_registers(tp);
+	}
+
 	RTL_W8(Cfg9346, Cfg9346_Lock);
 
 	/* Initially a 10 us delay. Turned it into a PCI commit. - FR */
@@ -1940,8 +1952,6 @@ static void rtl_hw_start_8169(struct net_device *dev)
 
 	/* Enable all known interrupts by setting the interrupt mask. */
 	RTL_W16(IntrMask, tp->intr_event);
-
-	RTL_W8(ChipCmd, CmdTxEnb | CmdRxEnb);
 }
 
 static void rtl_hw_start_8168(struct net_device *dev)
-- 
1.5.3.2


