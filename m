Return-Path: <linux-kernel-owner+w=401wt.eu-S1762739AbXFEFeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762739AbXFEFeR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 01:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752806AbXFEFeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 01:34:05 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:43779 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694AbXFEFeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 01:34:02 -0400
Date: Tue, 5 Jun 2007 07:35:02 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Meelis Roos <mroos@linux.ee>, rth@twiddle.net, ink@jurassic.park.msu.ru
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: alpha modpost warnings
Message-ID: <20070605053502.GB21745@uranus.ravnborg.org>
References: <Pine.SOC.4.64.0706041308560.7370@math>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.SOC.4.64.0706041308560.7370@math>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2007 at 01:11:07PM +0300, Meelis Roos wrote:
> I am building current 2.6.22-rc3+git for my alpha (Eiger) and get these.
> 
>   MODPOST vmlinux
> WARNING: "saved_config" [arch/alpha/kernel/built-in] is COMMON symbol
> WARNING: arch/alpha/kernel/built-in.o(.text+0x7d2c): Section mismatch: reference to .init.text:init_rtc_irq (between 'common_init_rtc' and 'timer_interrupt')
> WARNING: arch/alpha/kernel/built-in.o(.text+0x7d30): Section mismatch: reference to .init.text:init_rtc_irq (between 'common_init_rtc' and 'timer_interrupt')
> WARNING: arch/alpha/kernel/built-in.o(.data.rel+0x990): Section mismatch: reference to .init.text:tsunami_init_arch (between 'eiger_mv' and 'i8259a_irq_type')
> WARNING: arch/alpha/kernel/built-in.o(.data.rel+0x998): Section mismatch: reference to .init.text:eiger_init_irq (between 'eiger_mv' and 'i8259a_irq_type')
> WARNING: arch/alpha/kernel/built-in.o(.data.rel+0x9a8): Section mismatch: reference to .init.text:common_init_pci (between 'eiger_mv' and 'i8259a_irq_type')
> WARNING: arch/alpha/kernel/built-in.o(.data.rel+0x9b8): Section mismatch: reference to .init.text:eiger_swizzle (between 'eiger_mv' and 'i8259a_irq_type')
> WARNING: arch/alpha/kernel/built-in.o(.data.rel+0x9c0): Section mismatch: reference to .init.text:eiger_map_irq (between 'eiger_mv' and 'i8259a_irq_type')
> WARNING: arch/alpha/kernel/built-in.o(.data.rel.local+0x1060): Section mismatch: reference to .init.text:srm_console_setup (between 'srmcons' and 'tsunami_pci_ops')
> WARNING: drivers/built-in.o(.data.rel+0x1a80): Section mismatch: reference to .init.text:serial8250_console_setup (between 'serial8250_console' and '__param_arr_probe_rsa')


A few of the above was easy to fix. See patch below.
But alpha plays strange tricks with WEAK and ALIAS and __initdata for alpha_mv (and the cousins *_mv).
This is the reasons for most of the warnings - and I did not look deep enough to really understand
the logic (and thereby to come up with a fix).
Maybe the ALPHA maintainers can help?

	Sam

Subject: fix section mismatch warings in alpha build

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
diff --git a/arch/alpha/kernel/setup.c b/arch/alpha/kernel/setup.c
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
diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index c84dab0..6916cb2 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -2515,7 +2515,10 @@ static int __init serial8250_console_setup(struct console *co, char *options)
 }
 
 static struct uart_driver serial8250_reg;
-static struct console serial8250_console = {
+
+/* Mark __init_refok so modpost do not warn about reference to
+ * function marked __init (serial8250_console_Setup() */
+static struct console __initdata_refok serial8250_console = {
 	.name		= "ttyS",
 	.write		= serial8250_console_write,
 	.device		= uart_console_device,
