Return-Path: <linux-kernel-owner+w=401wt.eu-S1754374AbYJUUJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374AbYJUUJT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 16:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751174AbYJUUJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 16:09:06 -0400
Received: from willie.n0ano.com ([64.66.241.76]:45411 "EHLO xolotl.n0ano.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751056AbYJUUJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 16:09:05 -0400
From: n0ano@n0ano.com
Date: Tue, 21 Oct 2008 14:08:41 -0600
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: n0ano@n0ano.com, Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, donald.d.dugger@intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Enable console on PCI serial devices
Message-ID: <20081021200841.GL14490@xolotl.n0ano.com>
References: <200810142231.m9EMV95O002974@los-vmm.sc.intel.com> <200810201111.08703.bjorn.helgaas@hp.com> <20081020174351.GK14490@xolotl.n0ano.com> <200810201311.06602.bjorn.helgaas@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810201311.06602.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2008 at 01:11:05PM -0600, Bjorn Helgaas wrote:
>... 
> Ideally we could put something in Documentation/kernel-parameters.txt
> that's useful for people who can't or don't want to look at
> the source.

How about this.  I've modified the doc slightly to indicate that the
magic number is the base baud used to calculate the divsor used against
the crystal frequency.  This should be sufficient for most people and
the curious should now have enough info to research the matter further.

Signed-off-by: Don Dugger <donald.d.dugger@intel.com>

-- 
Don Dugger
"Censeo Toto nos in Kansa esse decisse." - D. Gale
n0ano@n0ano.com
Ph: 303/443-3786

 Documentation/kernel-parameters.txt |   14 +++++++++-----
 drivers/serial/8250_early.c         |    5 +++++
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 82c561f..f07e77c 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -505,12 +505,16 @@ and is between 256 and 4096 characters. It is defined in the file
 			Documentation/networking/netconsole.txt for an
 			alternative.
 
-		uart[8250],io,<addr>[,options]
-		uart[8250],mmio,<addr>[,options]
+		uart[8250],io,<addr>[,options[,base]]
+		uart[8250],mmio,<addr>[,options[,base]]
 			Start an early, polled-mode console on the 8250/16550
 			UART at the specified I/O port or MMIO address,
 			switching to the matching ttyS device later.  The
-			options are the same as for ttyS, above.
+			"options" are the same as for ttyS, above.  "base"
+			is base baud, defaults to 115200, which is used to
+			calculate the divisor for the crystal frequency
+			(typically this is the fastest baud rate supported
+			by the uart).
 
                 If the device connected to the port is not a TTY but a braille
                 device, prepend "brl," before the device type, for instance
@@ -518,8 +522,8 @@ and is between 256 and 4096 characters. It is defined in the file
 		For now, only VisioBraille is supported.
 
 	earlycon=	[KNL] Output early console device and options.
-		uart[8250],io,<addr>[,options]
-		uart[8250],mmio,<addr>[,options]
+		uart[8250],io,<addr>[,options,[base]]
+		uart[8250],mmio,<addr>[,options,[base]]
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
