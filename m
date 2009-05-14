Return-Path: <linux-kernel-owner+w=401wt.eu-S1761117AbZENLuB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761117AbZENLuB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 07:50:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758359AbZENLtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 07:49:50 -0400
Received: from adelphi.physics.adelaide.edu.au ([129.127.102.1]:54369 "EHLO
	adelphi.physics.adelaide.edu.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758173AbZENLtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 07:49:49 -0400
From: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Message-Id: <200905141149.n4EBngvc017279@mercury.physics.adelaide.edu.au>
Subject: Re: Realtek 8168D: no active link (2.6.29.2)
To: romieu@fr.zoreil.com (Francois Romieu)
Date: Thu, 14 May 2009 21:19:42 +0930 (CST)
Cc: jwoithe@physics.adelaide.edu.au (Jonathan Woithe),
       linux-kernel@vger.kernel.org
In-Reply-To: <20090513220436.GD729@electric-eye.fr.zoreil.com> from "Francois Romieu" at May 14, 2009 12:04:36 AM
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi 

> [...]
> > I am currently testing a Gigabyte EX58-UD4P mainboard which is equipped with
> > an onboard Realtek RTL-8168D network controller.  The kernel version is
> > 2.6.29.2.  The r8169 module is loaded correctly, identifies the chip as an
> > 8168D and seemingly is happy.  However, after loading the module the link
> > remains dead.  The green and orange status LEDs remain off at all times.
> 
> Which XID does it display in dmesg when the module is inserted and which
> behavior do you experience with version 8.011.00 of Realtek's r8168 driver ?

Ok, FYI the machine concerned is now running 2.6.30-rc5.  As far as I can
tell there is no change with this kernel version (I will double-check in a
few moments time and follow up if there are changes).  On initialisation the
2.6.30-r5 r8169 driver gives

  r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
  r8169 0000:08:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
  r8169 0000:08:00.0: setting latency timer to 64
  r8169 0000:08:00.0: irq 33 for MSI/MSI-X
  eth1: RTL8168d/8111d at 0xf91be000, 00:24:1d:15:5d:a9, XID 281000c0 IRQ 33

I then downloaded Realtek's 8.012.00 driver, it being the latest release.
Some internal API changes in 2.6.30-rc mean that this doesn't compile, but
it was trivial to fix these (for the benefit of those trawling the archives
the diff is at the end of this email).  With this done I get this when the
module is inserted (having removed the previously loaded r8169 driver):

  r8168 0000:08:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
  r8168 0000:08:00.0: setting latency timer to 64
  r8168 0000:08:00.0: irq 33 for MSI/MSI-X
  eth1 (r8168): not using net_device_ops yet
  eth1: Identified chip type is 'RTL8168D/8111D'.
  eth1: RTL8168B/8111B at 0xfcb1e000, 00:24:1d:15:5d:a9, IRQ 33
  r8168: eth1: link down
  r8168: eth1: link up

The "link up" occurred as soon as I plugged a live network cable into the
card.  Under the kernel's r8169 driver I never saw any "link up" messages.

Regards
  jonathan

diff -ruP r8168-8.012.00-orig/src/r8168.h r8168-8.012.00-new/src/r8168.h
--- r8168-8.012.00-orig/src/r8168.h	2009-04-20 17:37:23.000000000 +0930
+++ r8168-8.012.00-new/src/r8168.h	2009-05-14 20:57:45.166102000 +0930
@@ -37,11 +37,13 @@
 #define CHECKSUM_PARTIAL CHECKSUM_HW
 #endif
 
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30)
 #ifndef IRQ_HANDLED
 #define irqreturn_t void
 #define IRQ_HANDLED
 #define IRQ_NONE
 #endif
+#endif
 
 #ifndef HAVE_FREE_NETDEV
 #define free_netdev(x)	kfree(x)
@@ -255,10 +257,14 @@
 	#define RTL_NETIF_RX_COMPLETE(dev, napi)		netif_rx_complete(dev, napi)
 	#define RTL_NETIF_RX_SCHEDULE_PREP(dev, napi)		netif_rx_schedule_prep(dev, napi)
 	#define __RTL_NETIF_RX_SCHEDULE(dev, napi)		__netif_rx_schedule(dev, napi)
- #else
+ #elif LINUX_VERSION_CODE == KERNEL_VERSION(2,6,29)
 	#define RTL_NETIF_RX_COMPLETE(dev, napi)		netif_rx_complete(napi)
 	#define RTL_NETIF_RX_SCHEDULE_PREP(dev, napi)		netif_rx_schedule_prep(napi)
 	#define __RTL_NETIF_RX_SCHEDULE(dev, napi)		__netif_rx_schedule(napi)
+ #else
+	#define RTL_NETIF_RX_COMPLETE(dev, napi)		napi_complete(napi)
+	#define RTL_NETIF_RX_SCHEDULE_PREP(dev, napi)		napi_schedule_prep(napi)
+	#define __RTL_NETIF_RX_SCHEDULE(dev, napi)		__napi_schedule(napi)
  #endif
 	#define RTL_NAPI_RETURN_VALUE work_done
 	#define RTL_NAPI_ENABLE(dev, napi)			napi_enable(napi)
