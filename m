Return-Path: <linux-kernel-owner+w=401wt.eu-S932607AbXIIVgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932607AbXIIVgm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 17:36:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756829AbXIIVga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 17:36:30 -0400
Received: from www.osadl.org ([213.239.205.134]:45120 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753628AbXIIVg3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 17:36:29 -0400
From: =?iso-8859-1?q?Hans-J=FCrgen_Koch?= <hjk@linutronix.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH resend] Fix a lock problem in generic phy code
Date: Sun, 9 Sep 2007 23:36:25 +0200
User-Agent: KMail/1.9.6
Cc: netdev@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       afleming@freescale.com
References: <200708311430.09590.hjk@linutronix.de>
In-Reply-To: <200708311430.09590.hjk@linutronix.de>
Organization: Linutronix
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200709092336.25634.hjk@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I already sent this patch on August, 31. I never got an answer, so here it
is again. 

Lock debugging finds a problem in phy.c and phy_device.c:

[    3.420000] =================================
[    3.420000] [ INFO: inconsistent lock state ]
[    3.420000] 2.6.23-rc3-mm1 #21
[    3.420000] ---------------------------------
[    3.420000] inconsistent {softirq-on-W} -> {in-softirq-W} usage.
[    3.420000] swapper/1 [HC0[0]:SC1[1]:HE1:SE0] takes:
[    3.420000]  (&dev->lock){-+..}, at: [<c017da1c>] phy_timer+0x1c/0x4c8
[    3.420000] {softirq-on-W} state was registered at:
[    3.420000]   [<c006021c>] lock_acquire+0x94/0xac
[    3.420000]   [<c026423c>] _spin_lock+0x40/0x50
[    3.420000]   [<c017e2b4>] phy_probe+0x40/0x88
[    3.420000]   [<c017e60c>] phy_attach+0xc8/0xfc
[    3.420000]   [<c017e6c4>] phy_connect+0x1c/0x58
[    3.420000]   [<c017fc44>] macb_probe+0x4fc/0x5bc
[    3.420000]   [<c0177b44>] platform_drv_probe+0x20/0x24
[    3.420000]   [<c0176210>] driver_probe_device+0xb0/0x1bc
[    3.420000]   [<c01764dc>] __driver_attach+0xe4/0xe8
[    3.420000]   [<c017550c>] bus_for_each_dev+0x54/0x80
[    3.420000]   [<c0176074>] driver_attach+0x20/0x28
[    3.420000]   [<c01758d4>] bus_add_driver+0x84/0x1e0
[    3.420000]   [<c0176708>] driver_register+0x54/0x90
[    3.420000]   [<c0177de0>] platform_driver_register+0x6c/0x88
[    3.420000]   [<c00167ec>] macb_init+0x14/0x1c
[    3.420000]   [<c00087e4>] kernel_init+0x9c/0x2b4
[    3.420000]   [<c0040338>] do_exit+0x0/0x8e8
[    3.420000] irq event stamp: 115025
[    3.420000] hardirqs last  enabled at (115025): [<c0264958>] _spin_unlock_irq+0x30/0x60
[    3.420000] hardirqs last disabled at (115024): [<c02642c8>] _spin_lock_irq+0x28/0x60
[    3.420000] softirqs last  enabled at (114999): [<c0042910>] __do_softirq+0xfc/0x12c
[    3.420000] softirqs last disabled at (115022): [<c0042ee8>] irq_exit+0x68/0x7c
[    3.420000]
[    3.420000] other info that might help us debug this:
[    3.420000] no locks held by swapper/1.
[    3.420000]
[    3.420000] stack backtrace:
[    3.420000] [<c0028af4>] (dump_stack+0x0/0x14) from [<c005d8e4>] (print_usage_bug+0x120/0x150)
[    3.420000] [<c005d7c4>] (print_usage_bug+0x0/0x150) from [<c005e5e8>] (mark_lock+0x574/0x6bc)
[    3.420000] [<c005e074>] (mark_lock+0x0/0x6bc) from [<c005f4c0>] (__lock_acquire+0x4d0/0x1198)
[    3.420000] [<c005eff0>] (__lock_acquire+0x0/0x1198) from [<c006021c>] (lock_acquire+0x94/0xac)
[    3.420000] [<c0060188>] (lock_acquire+0x0/0xac) from [<c026423c>] (_spin_lock+0x40/0x50)
[    3.420000] [<c02641fc>] (_spin_lock+0x0/0x50) from [<c017da1c>] (phy_timer+0x1c/0x4c8)
[    3.420000]  r5:c098a800 r4:00000104
[    3.420000] [<c017da00>] (phy_timer+0x0/0x4c8) from [<c0046ee4>] (run_timer_softirq+0x1a0/0x218)
[    3.420000]  r7:c081ddd0 r6:c0331e80 r5:c098aa50 r4:00000104
[    3.420000] [<c0046d44>] (run_timer_softirq+0x0/0x218) from [<c00428a8>] (__do_softirq+0x94/0x12c)
[    3.420000] [<c0042814>] (__do_softirq+0x0/0x12c) from [<c0042ee8>] (irq_exit+0x68/0x7c)
[    3.420000] [<c0042e80>] (irq_exit+0x0/0x7c) from [<c0023060>] (__exception_text_start+0x60/0x74)
[    3.420000]  r4:00000001
[    3.420000] [<c0023000>] (__exception_text_start+0x0/0x74) from [<c0023b28>] (__irq_svc+0x48/0x74)
[    3.420000] Exception stack(0xc081de70 to 0xc081deb8)
[    3.420000] de60:                                     c030b2a8 c081a800 60000013 c081c000
[    3.420000] de80: c032db40 c081dee0 c032d758 c081dece 00000012 c030b398 00000034 c081df2c
[    3.420000] dea0: c081deb8 c081deb8 c003d6f0 c003d6f8 60000013 ffffffff
[    3.420000]  r7:00000003 r6:00000001 r5:fefff000 r4:ffffffff
[    3.420000] [<c003d494>] (vprintk+0x0/0x474) from [<c003d930>] (printk+0x28/0x30)
[    3.420000] [<c003d908>] (printk+0x0/0x30) from [<c01d3558>] (sock_register+0x64/0x84)
[    3.420000]  r3:00000001 r2:00000002 r1:00000001 r0:c02e4c88
[    3.420000] [<c01d34f4>] (sock_register+0x0/0x84) from [<c001b7bc>] (af_unix_init+0x40/0x88)
[    3.420000]  r5:00000000 r4:00000000
[    3.420000] [<c001b77c>] (af_unix_init+0x0/0x88) from [<c00087e4>] (kernel_init+0x9c/0x2b4)
[    3.420000]  r4:00000000
[    3.420000] [<c0008748>] (kernel_init+0x0/0x2b4) from [<c0040338>] (do_exit+0x0/0x8e8)

The following patch fixes it. Tested on an AT91SAM9263-EK board, kernel 2.6.23-rc4 and -rc3-mm1.

Signed-off-by: Hans J. Koch <hjk@linutronix.de>
---
Index: linux-2.6.23-rc/drivers/net/phy/phy_device.c
===================================================================
--- linux-2.6.23-rc.orig/drivers/net/phy/phy_device.c	2007-08-31 14:07:47.000000000 +0200
+++ linux-2.6.23-rc/drivers/net/phy/phy_device.c	2007-08-31 14:08:22.000000000 +0200
@@ -644,7 +644,7 @@
 	if (!(phydrv->flags & PHY_HAS_INTERRUPT))
 		phydev->irq = PHY_POLL;
 
-	spin_lock(&phydev->lock);
+	spin_lock_bh(&phydev->lock);
 
 	/* Start out supporting everything. Eventually,
 	 * a controller will attach, and may modify one
@@ -658,7 +658,7 @@
 	if (phydev->drv->probe)
 		err = phydev->drv->probe(phydev);
 
-	spin_unlock(&phydev->lock);
+	spin_unlock_bh(&phydev->lock);
 
 	return err;
 
Index: linux-2.6.23-rc/drivers/net/phy/phy.c
===================================================================
--- linux-2.6.23-rc.orig/drivers/net/phy/phy.c	2007-08-31 14:15:20.000000000 +0200
+++ linux-2.6.23-rc/drivers/net/phy/phy.c	2007-08-31 14:15:43.000000000 +0200
@@ -755,7 +755,7 @@
  */
 void phy_start(struct phy_device *phydev)
 {
-	spin_lock(&phydev->lock);
+	spin_lock_bh(&phydev->lock);
 
 	switch (phydev->state) {
 		case PHY_STARTING:
@@ -769,7 +769,7 @@
 		default:
 			break;
 	}
-	spin_unlock(&phydev->lock);
+	spin_unlock_bh(&phydev->lock);
 }
 EXPORT_SYMBOL(phy_stop);
 EXPORT_SYMBOL(phy_start);
