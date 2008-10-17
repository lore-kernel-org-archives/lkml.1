Return-Path: <linux-kernel-owner+w=401wt.eu-S1755477AbYJQOL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477AbYJQOL1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 10:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754403AbYJQOLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 10:11:16 -0400
Received: from willie.n0ano.com ([64.66.241.76]:59727 "EHLO xolotl.n0ano.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755269AbYJQOLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 10:11:15 -0400
From: n0ano@n0ano.com
Date: Fri, 17 Oct 2008 08:11:02 -0600
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: n0ano@n0ano.com, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       donald.d.dugger@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Enable console on PCI serial devices
Message-ID: <20081017141102.GG14490@xolotl.n0ano.com>
References: <200810142231.m9EMV95O002974@los-vmm.sc.intel.com> <200810161716.47620.bjorn.helgaas@hp.com> <20081017023912.GA9378@xolotl.n0ano.com> <20081017102858.1f1d77f7@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081017102858.1f1d77f7@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2008 at 10:28:58AM +0100, Alan Cox wrote:
> Different discussion and different patches. We can get patches in for the
> crystal frequency stuff and then debate the rest later

In that case, here is the crystal frequency patch (typos fixed and
proper sign off line).

Signed-off-by: Don Dugger <donald.d.dugger@intel.com>

 Documentation/kernel-parameters.txt |   13 ++++++++-----
 drivers/serial/8250_early.c         |    5 +++++
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 2443f5b..bf6dd6f 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -505,12 +505,15 @@ and is between 256 and 4096 characters. It is defined in the file
 			Documentation/networking/netconsole.txt for an
 			alternative.
 
-		uart[8250],io,<addr>[,options]
-		uart[8250],mmio,<addr>[,options]
+		uart[8250],io,<addr>[,options[,clk]]
+		uart[8250],mmio,<addr>[,options[,clk]]
 			Start an early, polled-mode console on the 8250/16550
 			UART at the specified I/O port or MMIO address,
 			switching to the matching ttyS device later.  The
-			options are the same as for ttyS, above.
+			"options" are the same as for ttyS, above.  "clk"
+			is the crystal frequency which defaults to 115200
+			(typically the fastest baud rate supported by the
+			uart) but some hardware use different crystals.
 
                 If the device connected to the port is not a TTY but a braille
                 device, prepend "brl," before the device type, for instance
@@ -518,8 +521,8 @@ and is between 256 and 4096 characters. It is defined in the file
 		For now, only VisioBraille is supported.
 
 	earlycon=	[KNL] Output early console device and options.
-		uart[8250],io,<addr>[,options]
-		uart[8250],mmio,<addr>[,options]
+		uart[8250],io,<addr>[,options,[clk]]
+		uart[8250],mmio,<addr>[,options,[clk]]
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
