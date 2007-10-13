Return-Path: <linux-kernel-owner+w=401wt.eu-S1761260AbXJMOnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761260AbXJMOnU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 10:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755708AbXJMOmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 10:42:07 -0400
Received: from 1wt.eu ([62.212.114.60]:2905 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761481AbXJMOmC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 10:42:02 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20071013143437.%N@1wt.eu>
References: <20071013142822.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Sat, 13 Oct 2007 17:28:25 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Thomas M=FCller <thomas@mathtm.de>, Francois Romieu <romieu@fr.zoreil.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [2.6.20.21 review 03/35] r8169: avoid needless NAPI poll scheduling
Content-Disposition: inline; filename=0011-r8169-avoid-needless-NAPI-poll-scheduling.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Theory  : though needless, it should not have hurt.
Practice: it does not play nice with DEBUG_SHIRQ + LOCKDEP + UP
(see https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=3D242572).


The patch makes sense in itself but I should dig why it has an effect
on #242572 (assuming that NAPI do not change in a near future).

Patch in mainline as 313b0305b5a1e7e0fb39383befbf79558ce68a9c.
Backported to 2.6.22-stable by Thomas M=FCller.

Signed-off-by: Thomas M=FCller <thomas@mathtm.de>
Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/r8169.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

Index: 2.6/drivers/net/r8169.c
===================================================================
--- 2.6.orig/drivers/net/r8169.c
+++ 2.6/drivers/net/r8169.c
@@ -2646,14 +2646,16 @@ rtl8169_interrupt(int irq, void *dev_ins
 			rtl8169_check_link_status(dev, tp, ioaddr);
 
 #ifdef CONFIG_R8169_NAPI
-		RTL_W16(IntrMask, rtl8169_intr_mask & ~rtl8169_napi_event);
-		tp->intr_mask = ~rtl8169_napi_event;
+		if (status & rtl8169_napi_event) {
+			RTL_W16(IntrMask, rtl8169_intr_mask & ~rtl8169_napi_event);
+			tp->intr_mask = ~rtl8169_napi_event;
 
-		if (likely(netif_rx_schedule_prep(dev)))
-			__netif_rx_schedule(dev);
-		else if (netif_msg_intr(tp)) {
-			printk(KERN_INFO "%s: interrupt %04x taken in poll
",
-			       dev->name, status);
+			if (likely(netif_rx_schedule_prep(dev)))
+				__netif_rx_schedule(dev);
+			else if (netif_msg_intr(tp)) {
+				printk(KERN_INFO "%s: interrupt %04x in poll
",
+				       dev->name, status);
+			}
 		}
 		break;
 #else

-- 
