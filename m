Return-Path: <linux-kernel-owner+w=401wt.eu-S1755734AbYKKITZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734AbYKKITZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 03:19:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751717AbYKKITN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 03:19:13 -0500
Received: from yw-out-2324.google.com ([74.125.46.28]:49530 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481AbYKKITM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 03:19:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=Nk48gaNO2y9/VE2Q7eMRWRjjpoP9GaKXKbrz80wkasb+lisQCwHy/zmtytbYM96Nes
         qYCubAvrIlV7hlBqRfNHTFnLTq3oR2eM0q8TbhNZqe8Lv58cvfRbzi2xOG/o7cYreaPg
         9u9fQZMkuewZCsO0pexT3D4BUEMjRmTvXmHG0=
Message-ID: <b0438a630811110019m7f91fde5k4ba9aedc2c5af116@mail.gmail.com>
Date: Tue, 11 Nov 2008 09:19:10 +0100
From: "=?ISO-8859-1?Q?Miguel_=C1ngel_=C1lvarez?=" <gotzoncabanes@gmail.com>
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] ixp4xx: SSP
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

With this patch I try to show the similarities between the SSP
subsystem in a PXA250 and an IXP4XX. The only difference is the lack
of the capability of using DMA for the SSP.
This patch should not be applied as it is... These files are places
insive arch/arm/mach-pxa2xx, so another question is where is it better
to place the files. (Inside arch/arm/common? inside drivers/spi?). Is
there a better way to solve the "#ifdef ARCH_PXA" I have added?

I would appreciate your comments very much.
---

diff -urN linux-2.6.27.4_clock/arch/arm/mach-pxa/include/mach/regs-ssp.h
linux-2.6.27.4_ssp/arch/arm/mach-pxa/include/mach/regs-ssp.h
--- linux-2.6.27.4_clock/arch/arm/mach-pxa/include/mach/regs-ssp.h	2008-11-10
13:07:31.000000000 +0100
+++ linux-2.6.27.4_ssp/arch/arm/mach-pxa/include/mach/regs-ssp.h	2008-11-11
09:13:25.000000000 +0100
@@ -34,7 +34,7 @@
 #define SSCR0_ECS	(1 << 6)	/* External clock select */
 #define SSCR0_SSE	(1 << 7)	/* Synchronous Serial Port Enable */

-#if defined(CONFIG_PXA25x)
+#if defined(CONFIG_PXA25x) || defined(CONFIG_ARCH_IXP4XX)
 #define SSCR0_SCR	(0x0000ff00)	/* Serial Clock Rate (mask) */
 #define SSCR0_SerClkDiv(x) ((((x) - 2)/2) << 8) /* Divisor [2..512] */

diff -urN linux-2.6.27.4_clock/arch/arm/mach-pxa/include/mach/ssp.h
linux-2.6.27.4_ssp/arch/arm/mach-pxa/include/mach/ssp.h
--- linux-2.6.27.4_clock/arch/arm/mach-pxa/include/mach/ssp.h	2008-11-10
13:07:31.000000000 +0100
+++ linux-2.6.27.4_ssp/arch/arm/mach-pxa/include/mach/ssp.h	2008-11-11
09:12:53.000000000 +0100
@@ -9,6 +9,7 @@
  *
  * This driver supports the following PXA CPU/SSP ports:-
  *
+ *       IXP4XX     SSP
  *       PXA250     SSP
  *       PXA255     SSP, NSSP
  *       PXA26x     SSP, NSSP, ASSP
@@ -23,7 +24,7 @@

 enum pxa_ssp_type {
 	SSP_UNDEFINED = 0,
-	PXA25x_SSP,  /* pxa 210, 250, 255, 26x */
+	PXA25x_SSP,  /* pxa 210, 250, 255, 26x, ixp4xx */
 	PXA25x_NSSP, /* pxa 255, 26x (including ASSP) */
 	PXA27x_SSP,
 };
diff -urN linux-2.6.27.4_clock/arch/arm/mach-pxa/ssp.c
linux-2.6.27.4_ssp/arch/arm/mach-pxa/ssp.c
--- linux-2.6.27.4_clock/arch/arm/mach-pxa/ssp.c	2008-11-10
13:07:31.000000000 +0100
+++ linux-2.6.27.4_ssp/arch/arm/mach-pxa/ssp.c	2008-11-11
09:10:38.000000000 +0100
@@ -33,7 +33,6 @@
 #include <asm/irq.h>
 #include <mach/hardware.h>
 #include <mach/ssp.h>
-#include <mach/pxa-regs.h>
 #include <mach/regs-ssp.h>

 #define TIMEOUT 100000
@@ -131,6 +130,7 @@
 	struct ssp_device *ssp = dev->ssp;
 	int timeout = TIMEOUT * 2;

+#ifdef ARCH_PXA
 	/* ensure TX FIFO is empty instead of not full */
 	if (cpu_is_pxa3xx()) {
 		while (__raw_readl(ssp->mmio_base + SSSR) & 0xf00) {
@@ -140,6 +140,7 @@
 		}
 		timeout = TIMEOUT * 2;
 	}
+#endif

 	do {
 		while (__raw_readl(ssp->mmio_base + SSSR) & SSSR_RNE) {
@@ -393,6 +394,7 @@
 		goto err_free_io;
 	}

+#ifdef ARCH_PXA
 	res = platform_get_resource(pdev, IORESOURCE_DMA, 0);
 	if (res == NULL) {
 		dev_err(&pdev->dev, "no SSP RX DRCMR defined\n");
@@ -408,6 +410,7 @@
 		goto err_free_io;
 	}
 	ssp->drcmr_tx = res->start;
+#endif

 	/* PXA2xx/3xx SSP ports starts from 1 and the internal pdev->id
 	 * starts from 0, do a translation here

Thanks

Miguel Ángel
