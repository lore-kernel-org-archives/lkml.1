Return-Path: <linux-kernel-owner+w=401wt.eu-S1756684AbYJQPhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684AbYJQPhX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 11:37:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754654AbYJQPhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 11:37:07 -0400
Received: from willie.n0ano.com ([64.66.241.76]:50722 "EHLO xolotl.n0ano.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755343AbYJQPhG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 11:37:06 -0400
From: n0ano@n0ano.com
Date: Fri, 17 Oct 2008 09:36:52 -0600
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: n0ano@n0ano.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       donald.d.dugger@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Enable console on PCI serial devices
Message-ID: <20081017153652.GH14490@xolotl.n0ano.com>
References: <200810142231.m9EMV95O002974@los-vmm.sc.intel.com> <20081017102858.1f1d77f7@lxorguk.ukuu.org.uk> <20081017141102.GG14490@xolotl.n0ano.com> <200810170846.41032.bjorn.helgaas@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810170846.41032.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2008 at 08:46:40AM -0600, Bjorn Helgaas wrote:
>... 
> this text is a little confusing.  Since you multiply by 16 below, the
> number specified by the user isn't really the crystal frequency, is it?

Can't argue with that.  How about this patch which describes the
parameter more acurately as a multiplier.

Signed-off-by: Don Dugger <donald.d.dugger@intel.com>

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 82c561f..6e5334d 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -505,12 +505,15 @@ and is between 256 and 4096 characters. It is defined in the file
 			Documentation/networking/netconsole.txt for an
 			alternative.
 
-		uart[8250],io,<addr>[,options]
-		uart[8250],mmio,<addr>[,options]
+		uart[8250],io,<addr>[,options[,mult]]
+		uart[8250],mmio,<addr>[,options[,mult]]
 			Start an early, polled-mode console on the 8250/16550
 			UART at the specified I/O port or MMIO address,
 			switching to the matching ttyS device later.  The
-			options are the same as for ttyS, above.
+			"options" are the same as for ttyS, above.  "mult"
+			is a multiplier defining the crystal frequency which
+			defaults to 115200 (typically the fastest baud rate
+			supported by the uart).
 
                 If the device connected to the port is not a TTY but a braille
                 device, prepend "brl," before the device type, for instance
@@ -518,8 +521,8 @@ and is between 256 and 4096 characters. It is defined in the file
 		For now, only VisioBraille is supported.
 
 	earlycon=	[KNL] Output early console device and options.
-		uart[8250],io,<addr>[,options]
-		uart[8250],mmio,<addr>[,options]
+		uart[8250],io,<addr>[,options,[mult]]
+		uart[8250],mmio,<addr>[,options,[mult]]
 			Start an early, polled-mode console on the 8250/16550
 			UART at the specified I/O port or MMIO address.
 			The options are the same as for ttyS, above.
diff --git a/drivers/serial/8250_early.c b/drivers/serial/8250_early.c
index f279745..edd5803 100644
--- a/drivers/serial/8250_early.c
+++ b/drivers/serial/8250_early.c
@@ -180,6 +180,11 @@ static int __init parse_options(struct early_serial8250_device *device,
 		snprintf(device->options, sizeof(device->options), "%u",
 			device->baud);
 	}
+	options = strchr(options, ',');
+	if (options) {
+		options++;
+		port->uartclk = simple_strtoul(options, NULL, 0) * 16;
+	}
 
 	printk(KERN_INFO "Early serial console at %s 0x%llx (options '%s')\n",
 		mmio ? "MMIO" : "I/O port",
