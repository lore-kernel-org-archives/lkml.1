Return-Path: <linux-kernel-owner+w=401wt.eu-S936638AbXFGU22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936638AbXFGU22 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 16:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934770AbXFGU2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 16:28:09 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:47514 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936587AbXFGU2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 16:28:07 -0400
Date: Thu, 7 Jun 2007 22:29:07 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Meelis Roos <mroos@linux.ee>, rth@twiddle.net, ink@jurassic.park.msu.ru,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [PATCH] alpha: fix trivial section mismatch warnings
Message-ID: <20070607202907.GA16553@uranus.ravnborg.org>
References: <Pine.SOC.4.64.0706041308560.7370@math> <20070605053502.GB21745@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070605053502.GB21745@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following section mismatch warnings:
WARNING: arch/alpha/kernel/built-in.o(.text+0x7c78): Section mismatch: reference to .init.text:init_rtc_irq (between 'common_init_rtc' and 'timer_interrupt')
WARNING: arch/alpha/kernel/built-in.o(.text+0x7c7c): Section mismatch: reference to .init.text:init_rtc_irq (between 'common_init_rtc' and 'timer_interrupt')
WARNING: arch/alpha/kernel/built-in.o(.data+0x2c30): Section mismatch: reference to .init.text:srm_console_setup (between 'srmcons' and 'tsunami_pci_ops')

In all three cases functions marked __init was called outside __init context.
So the fix was to just drop the __init attribute.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
Andrew - these are trivial so I would like you to take these.
The alpha people (at least rth) are struggling with some glibc issues atm.

There are still a few section mismatch warnings pending for alpha but they
require more surgery than I am willing to look into.
Maybe we should just use __init_refok to ignore them,
but I will await until the alpha people has a few moments lefts.

	Sam

diff --git a/arch/alpha/kernel/srmcons.c b/arch/alpha/kernel/srmcons.c
index 930cedc..783f4e5 100644
--- a/arch/alpha/kernel/srmcons.c
+++ b/arch/alpha/kernel/srmcons.c
@@ -289,7 +289,7 @@ srm_console_device(struct console *co, int *index)
 	return srmcons_driver;
 }
 
-static int __init
+static int
 srm_console_setup(struct console *co, char *options)
 {
 	return 0;
diff --git a/arch/alpha/kernel/sys_marvel.c b/arch/alpha/kernel/sys_marvel.c
index e349f03..acc93ac 100644
--- a/arch/alpha/kernel/sys_marvel.c
+++ b/arch/alpha/kernel/sys_marvel.c
@@ -422,7 +422,7 @@ marvel_init_pci(void)
 		io7_clear_errors(io7);
 }
 
-static void
+static void __init
 marvel_init_rtc(void)
 {
 	init_rtc_irq();
diff --git a/arch/alpha/kernel/time.c b/arch/alpha/kernel/time.c
index 4748e14..1dd50d0 100644
--- a/arch/alpha/kernel/time.c
+++ b/arch/alpha/kernel/time.c
@@ -144,7 +144,7 @@ irqreturn_t timer_interrupt(int irq, void *dev)
 	return IRQ_HANDLED;
 }
 
-void
+void __init
 common_init_rtc(void)
 {
 	unsigned char x;
