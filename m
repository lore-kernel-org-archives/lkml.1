Return-Path: <linux-kernel-owner+w=401wt.eu-S1753841AbXDDOUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbXDDOUV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 10:20:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753876AbXDDOUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 10:20:21 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55939 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841AbXDDOUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 10:20:19 -0400
Subject: [PATCH v3] Stop pmac_zilog from abusing 8250's device numbers;
	optionally.
From: David Woodhouse <dwmw2@infradead.org>
To: Paul Mackerras <paulus@samba.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Brad Boyer <flar@allandria.com>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <17939.17962.248566.886449@cargo.ozlabs.ibm.com>
References: <1175610345.2665.15.camel@shinybook.infradead.org>
	 <17938.57292.870224.132415@cargo.ozlabs.ibm.com>
	 <1175642916.10567.24.camel@shinybook.infradead.org>
	 <20070403212928.GA12951@cynthia.pants.nu>
	 <20070404022544.59b022a6@the-village.bc.nu>
	 <17939.10130.687893.167511@cargo.ozlabs.ibm.com>
	 <1175663999.2932.8.camel@shinybook.infradead.org>
	 <17939.15726.114059.679277@cargo.ozlabs.ibm.com>
	 <1175666635.2932.17.camel@shinybook.infradead.org>
	 <17939.17962.248566.886449@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Wed, 04 Apr 2007 10:19:43 -0400
Message-Id: <1175696383.2774.24.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 (2.10.0-7.fc7.dwmw2.2) 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-04 at 16:31 +1000, Paul Mackerras wrote:
> It seems Debian has both 8250 and pmac_zilog built in; not sure which
> one wins.  Ubuntu has them both as modules and managed to get the
> right one (pmac_zilog) loaded on a colleague's powerbook. 

So if you insert a PCMCIA card with an 8250-compatible port in it --
like a Bluetooth card or modem -- you won't get it to work, right? 

>  You'd know better than me what FC does.

Fedora has 8250 built in, which means pmac_zilog can never get loaded.

> In any case there definitely are people using pmac_zilog successfully
> on powermacs and we need to come up with a way to avoid breaking their
> setups.  I'm prepared to accept that the Linux way is to be lame about
> serial port naming provided that we avoid breaking existing working
> setups. 

OK, how about a config option to preserve the old behaviour...

Signed-off-by: David Woodhouse <dwmw2@infradead.org>

diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
index ad9f321..09b2dd4 100644
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -753,6 +753,25 @@ config SERIAL_PMACZILOG
 	  PowerMac machines.
 	  Say Y or M if you want to be able to these serial ports.
 
+config SERIAL_PMACZILOG_TTYS
+	bool "Use ttySn device nodes for Zilog z85c30"
+	depends on SERIAL_PMACZILOG
+	help
+	  The z85C30 driver historically used the device nodes which 
+	  are registed to the 8250 serial port driver, which led to the
+	  two drivers being unable to coexist; you could not use both
+	  z85C30 and 8250 type ports at the same time.
+
+	  The z83C30 driver was fixed to prevent this abuse by default,
+	  but this configuration option remains in order to allow backward
+	  compatibility by reverting to the old misbehaviour.
+
+	  If you enable this option, any z85c30 ports in the system will
+	  be registered as ttyS0 onwards, and you will be unable to use
+	  the 8250 module for PCMCIA or other standard UARTs.
+
+	  Say N.
+
 config SERIAL_PMACZILOG_CONSOLE
 	bool "Console on PowerMac z85c30 serial port"
 	depends on SERIAL_PMACZILOG=y
diff --git a/drivers/serial/pmac_zilog.c b/drivers/serial/pmac_zilog.c
index 752ef07..28269bb 100644
--- a/drivers/serial/pmac_zilog.c
+++ b/drivers/serial/pmac_zilog.c
@@ -88,9 +88,19 @@ MODULE_LICENSE("GPL");
 
 #define PWRDBG(fmt, arg...)	printk(KERN_DEBUG fmt , ## arg)
 
+#ifdef CONFIG_SERIAL_PMACZILOG_TTYS
+#define PMACZILOG_MAJOR		TTY_MAJOR
+#define PMACZILOG_MINOR		64
+#define PMACZILOG_NAME		"ttyS"
+#else
+#define PMACZILOG_MAJOR		204
+#define PMACZILOG_MINOR		192
+#define PMACZILOG_NAME		"ttyPZ"
+#endif
+
 
 /*
- * For the sake of early serial console, we can do a pre-probe
+ * FOR the sake of early serial console, we can do a pre-probe
  * (optional) of the ports at rather early boot time.
  */
 static struct uart_pmac_port	pmz_ports[MAX_ZS_PORTS];
@@ -99,9 +109,10 @@ static DEFINE_MUTEX(pmz_irq_mutex);
 
 static struct uart_driver pmz_uart_reg = {
 	.owner		=	THIS_MODULE,
-	.driver_name	=	"ttyS",
-	.dev_name	=	"ttyS",
-	.major		=	TTY_MAJOR,
+	.driver_name	=	PMACZILOG_NAME,
+	.dev_name	=	PMACZILOG_NAME,
+	.major		=	PMACZILOG_MAJOR,
+	.minor		=	PMACZILOG_MINOR,
 };
 
 
@@ -1776,7 +1787,7 @@ static void pmz_console_write(struct console *con, const char *s, unsigned int c
 static int __init pmz_console_setup(struct console *co, char *options);
 
 static struct console pmz_console = {
-	.name	=	"ttyS",
+	.name	=	PMACZILOG_NAME,
 	.write	=	pmz_console_write,
 	.device	=	uart_console_device,
 	.setup	=	pmz_console_setup,
@@ -1800,7 +1811,6 @@ static int __init pmz_register(void)
 	
 	pmz_uart_reg.nr = pmz_ports_count;
 	pmz_uart_reg.cons = PMACZILOG_CONSOLE;
-	pmz_uart_reg.minor = 64;
 
 	/*
 	 * Register this driver with the serial core

-- 
dwmw2

