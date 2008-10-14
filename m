Return-Path: <linux-kernel-owner+w=401wt.eu-S1755486AbYJNXaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486AbYJNXaz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 19:30:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752585AbYJNXar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 19:30:47 -0400
Received: from willie.n0ano.com ([64.66.241.76]:41075 "EHLO xolotl.n0ano.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752454AbYJNXaq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 19:30:46 -0400
From: n0ano@n0ano.com
Date: Tue, 14 Oct 2008 17:30:31 -0600
To: Yinghai Lu <yinghai@kernel.org>
Cc: donald.d.dugger@intel.com, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Enable console on PCI serial devices
Message-ID: <20081014233031.GB14490@xolotl.n0ano.com>
References: <200810142231.m9EMV95O002974@los-vmm.sc.intel.com> <86802c440810141539x97ceaa4meaab109fae3d9d4c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440810141539x97ceaa4meaab109fae3d9d4c@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2008 at 03:39:44PM -0700, Yinghai Lu wrote:
> ...
> Did you check
> 
> console=uart8250,io,0xe880,115200n8
> 
> hope you can expand that to support CCC
> 
> YH

Good suggestion.  Here is a much simpler patch that just expands
the early printk to add a clock frequency parameter, e.g. I use:

console=uart8250,io,0xe880,115200,921600

Signed-off-by: Don Dugger <donald.d.dugger@intel.com>

 Documentation/kernel-parameters.txt |    9 ++++++---
 drivers/serial/8250_early.c         |    5 +++++
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 2443f5b..95ab44f 100644
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
+			is the crystal frequency which defaults to 1843200
+			(115200 * 16) but some hardware uses different
+			crystal.
 
                 If the device connected to the port is not a TTY but a braille
                 device, prepend "brl," before the device type, for instance
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
