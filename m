Return-Path: <linux-kernel-owner+w=401wt.eu-S1767739AbXDFPUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767739AbXDFPUG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 11:20:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767736AbXDFPUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 11:20:06 -0400
Received: from mail.faust.net.ua ([195.68.202.98]:38580 "EHLO
	mail.faust.net.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767735AbXDFPUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 11:20:04 -0400
X-Greylist: delayed 500 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Apr 2007 11:20:04 EDT
Message-ID: <46166329.3060508@faust.net.ua>
Date: Fri, 06 Apr 2007 18:11:37 +0300
From: Mikhail Zolotaryov <lebon@faust.net.ua>
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: mporter@kernel.crashing.org, linux-serial@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] PPC4xx UART0 (8250) problem
Content-Type: text/plain; charset=KOI8-U
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On PPC4xx embedded we often have UART0 on IRQ0 but 8250 UART driver uses
IRQ0 as "no irq" hack.
It's suggested that platforms with UART on IRQ0 will redefine
is_real_interrupt(irq) macro but 8250 code anyway overrides that.
As the result, serial line on UART0 works on polling-way and we have
character loss on high baud rates.

In patch I've added check if UART0 is on IRQ0, if so we define
is_real_interrupt macro to be 1 (true).
Also, check if is_real_interrupt macro is already defined added to 8250
UART driver.

--- linux-2.6.20.5.orig/include/asm-ppc/ibm4xx.h        2007-03-23
21:52:51.000000000 +0200
+++ linux-2.6.20.5/include/asm-ppc/ibm4xx.h     2007-04-06
17:37:22.000000000 +0300
@@ -54,6 +54,12 @@
 #include <platforms/4xx/xilinx_ml403.h>
 #endif
 
+#ifdef UART0_INT
+#if (UART0_INT == 0)
+#define is_real_interrupt(irq)  (1)
+#endif
+#endif
+
 #ifndef __ASSEMBLY__
 
 #ifdef CONFIG_40x
--- linux-2.6.20.5.orig/drivers/serial/8250.c   2007-03-23
21:52:51.000000000 +0200
+++ linux-2.6.20.5/drivers/serial/8250.c        2007-04-06
16:44:32.000000000 +0300
@@ -77,7 +77,10 @@
  * machine types want others as well - they're free
  * to redefine this in their header file.
  */
+
+#ifndef is_real_interrupt(irq)
 #define is_real_interrupt(irq) ((irq) != 0)
+#endif
 
 #ifdef CONFIG_SERIAL_8250_DETECT_IRQ
 #define CONFIG_SERIAL_DETECT_IRQ 1

