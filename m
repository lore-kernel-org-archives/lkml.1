Return-Path: <linux-kernel-owner+w=401wt.eu-S1752498AbYAWLx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498AbYAWLx5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 06:53:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751009AbYAWLxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 06:53:48 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:56826 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750855AbYAWLxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 06:53:47 -0500
Date: Wed, 23 Jan 2008 12:53:00 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Marc Pignat <marc.pignat@hevs.ch>
Cc: Andrew Victor <linux@maxim.org.za>, kernel@avr32linux.org,
       linux-kernel@vger.kernel.org, Remy Bohmer <linux@bohmer.net>,
       Chip Coldwell <coldwell@redhat.com>
Subject: Re: [PATCH 6/6] atmel_serial: Add DMA support
Message-ID: <20080123125300.5d8d7006@dhcp-252-066.norway.atmel.com>
In-Reply-To: <200801221752.43830.marc.pignat@hevs.ch>
References: <1201013444-30370-1-git-send-email-hskinnemoen@atmel.com>
	<1201013444-30370-6-git-send-email-hskinnemoen@atmel.com>
	<1201013444-30370-7-git-send-email-hskinnemoen@atmel.com>
	<200801221752.43830.marc.pignat@hevs.ch>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jan 2008 17:52:43 +0100
Marc Pignat <marc.pignat@hevs.ch> wrote:

> Hi!
> 
> I removed linux-arm-kernel@lists.arm.linux.org.uk from cc, it is a
> subscriber-only list.

Right. Does that mean I shouldn't Cc it on patches?

> On Tuesday 22 January 2008, Haavard Skinnemoen wrote:
> > From: Chip Coldwell <coldwell@redhat.com>
> ...
> > @@ -47,6 +50,11 @@
> >  
> >  #include "atmel_serial.h"
> >  
> > +#define SUPPORT_PDC
> > +#define PDC_BUFFER_SIZE		(L1_CACHE_BYTES << 3)
> > +#warning "Revisit"
> why add this warning?

Dunno. I suppose the PDC_BUFFER_SIZE and/or PDC_RX_TIMEOUT definitions
needs to be revisited? Chip?

I don't really understand why the buffer size depends on the cache line
size either. Why don't we just set it to something nice and large, like
512 (actually 1024 since there are two buffers), and be done with it?

And while we're at it, might as well move the SUPPORT_PDC definition
into Kconfig where it belongs...

> ...
> > @@ -1090,7 +1434,7 @@ static int atmel_serial_suspend(struct platform_device *pdev,
> >  	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
> >  
> >  	if (device_may_wakeup(&pdev->dev)
> > -	    && !at91_suspend_entering_slow_clock())
> > +		&& !clk_must_disable(atmel_port->clk))
> 1. this has nothing to do with dma
> 2. clk_must_disable isn't in mainline (2.6.24-rc8) for at91 (not verified for avr32).

Ok, I don't think this code is actually compiled on avr32 so I didn't
see the breakage. But I agree it has nothing to do with DMA, so I'll
remove it. If anything here needs fixing, it should be done as a
separate patch.

> CONFIG_MAGIC_SYSRQ isn't working with this pach, (CONFIG_MAGIC_SYSRQ has never
> worked with atmel_serial dma patches).

Yeah, I know. It's a bit difficult to fix. But this DMA patch has been
out of tree for so long that I think it's actually more important to
get it into mainline at this point, without necessarily having to fix
up problems that have been there forever.

And even with this patch, DMA support is entirely optional on a
per-port basis, so if it turns out to be (too) broken, we can simply
turn it off on the boards where it actually matters.

> For me breaking CONFIG_MAGIC_SYSRQ is not a critical regression and can be
> fixed later, but the "clk_must_disable" problem breaks compilation.

Right. The below patch should take care of this. If you're fine with
it, I'll fold it into the DMA patch in the next round.

Haavard

diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
index d7e1996..67bfbb0 100644
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -380,6 +380,21 @@ config SERIAL_ATMEL_CONSOLE
 	  console is the device which receives all kernel messages and
 	  warnings and which allows logins in single user mode).
 
+config SERIAL_ATMEL_PDC
+	bool "Support DMA transfers on AT91 / AT32 serial port"
+	depends on SERIAL_ATMEL
+	default y
+	help
+	  Say Y here if you wish to use the PDC to do DMA transfers to
+	  and from the Atmel AT91 / AT32 serial port. In order to
+	  actually use DMA transfers, make sure that the use_dma_tx
+	  and use_dma_rx members in the atmel_uart_data struct is set
+	  appropriately for each port.
+
+	  Note that break and error handling currently doesn't work
+	  properly when DMA is enabled. Make sure that ports where
+	  this matters don't use DMA.
+
 config SERIAL_ATMEL_TTYAT
 	bool "Install as device ttyATn instead of ttySn"
 	depends on SERIAL_ATMEL=y
diff --git a/drivers/serial/atmel_serial.c b/drivers/serial/atmel_serial.c
index cb70cc5..f4ef1df 100644
--- a/drivers/serial/atmel_serial.c
+++ b/drivers/serial/atmel_serial.c
@@ -50,9 +50,8 @@
 
 #include "atmel_serial.h"
 
-#define SUPPORT_PDC
-#define PDC_BUFFER_SIZE		(L1_CACHE_BYTES << 3)
-#warning "Revisit"
+#define PDC_BUFFER_SIZE		512
+/* Revisit: We should calculate this based on the actual port settings */
 #define PDC_RX_TIMEOUT		(3 * 10)		/* 3 bytes */
 
 #if defined(CONFIG_SERIAL_ATMEL_CONSOLE) && defined(CONFIG_MAGIC_SYSRQ)
@@ -162,7 +161,7 @@ static struct atmel_uart_port atmel_ports[ATMEL_MAX_UART];
 static struct console atmel_console;
 #endif
 
-#ifdef SUPPORT_PDC
+#ifdef CONFIG_SERIAL_ATMEL_PDC
 static bool atmel_use_dma_rx(struct uart_port *port)
 {
 	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
@@ -1434,7 +1433,7 @@ static int atmel_serial_suspend(struct platform_device *pdev,
 	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
 
 	if (device_may_wakeup(&pdev->dev)
-		&& !clk_must_disable(atmel_port->clk))
+	    && !at91_suspend_entering_slow_clock())
 		enable_irq_wake(port->irq);
 	else {
 		uart_suspend_port(&atmel_uart, port);
