Return-Path: <linux-kernel-owner+w=401wt.eu-S1753477AbYJ1Wl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477AbYJ1Wl4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 18:41:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752756AbYJ1Wls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 18:41:48 -0400
Received: from www.tglx.de ([62.245.132.106]:35927 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752812AbYJ1Wlr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 18:41:47 -0400
Date: Tue, 28 Oct 2008 23:41:37 +0100
From: Manuel Traut <manut@linutronix.de>
To: hjk@linutronix.de
Cc: b.spranger@linutronix.de, gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: UIO: don't check irq_enabled flag in uio_cif irq handler
Message-ID: <20081028224137.GA25357@www.tglx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below patch ignores INT1_ENABLED flag in the uio_cif irq handler.

On a Hilscher DeviceNet Slave card, the INT_ENABLE flag is (probably) reseted 
by the firmware. Without this patch, every interrupt produced by this card is
dropped.

This patch is tested and works with a DeviceNet Slave and a Profibus Slave card.

Signed-off-by: Manuel Traut <manut@linutronix.de>

--- linux-git/drivers/uio/uio_cif.c	2008-10-28 23:42:18.000000000 +0100
+++ uio/drivers/uio/uio_cif.c	2008-10-28 23:41:43.000000000 +0100
@@ -18,7 +18,6 @@
 #define PLX9030_INTCSR		0x4C
 #define INTSCR_INT1_ENABLE	0x01
 #define INTSCR_INT1_STATUS	0x04
-#define INT1_ENABLED_AND_ACTIVE	(INTSCR_INT1_ENABLE | INTSCR_INT1_STATUS)
 
 #define PCI_SUBVENDOR_ID_PEP	0x1518
 #define CIF_SUBDEVICE_PROFIBUS	0x430
@@ -30,8 +29,8 @@
 	void __iomem *plx_intscr = dev_info->mem[0].internal_addr
 					+ PLX9030_INTCSR;
 
-	if ((ioread8(plx_intscr) & INT1_ENABLED_AND_ACTIVE)
-	    != INT1_ENABLED_AND_ACTIVE)
+	if ((ioread8(plx_intscr) & INT1_STATUS)
+	    != INT1_STATUS)
 		return IRQ_NONE;
 
 	/* Disable interrupt */
