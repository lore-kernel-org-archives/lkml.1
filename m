Return-Path: <linux-kernel-owner+w=401wt.eu-S1754944AbYJOUuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944AbYJOUuQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 16:50:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbYJOUuD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 16:50:03 -0400
Received: from willie.n0ano.com ([64.66.241.76]:59937 "EHLO xolotl.n0ano.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750966AbYJOUuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 16:50:01 -0400
From: n0ano@n0ano.com
Date: Wed, 15 Oct 2008 14:48:51 -0600
To: Paul Bolle <pebolle@tiscali.nl>
Cc: n0ano@n0ano.com, Yinghai Lu <yinghai@kernel.org>,
       donald.d.dugger@intel.com, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Enable console on PCI serial devices
Message-ID: <20081015204850.GC14490@xolotl.n0ano.com>
References: <200810142231.m9EMV95O002974@los-vmm.sc.intel.com> <86802c440810141539x97ceaa4meaab109fae3d9d4c@mail.gmail.com> <20081014233031.GB14490@xolotl.n0ano.com> <1224061999.25929.7.camel@test.thuisdomein>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224061999.25929.7.camel@test.thuisdomein>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2008 at 11:13:19AM +0200, Paul Bolle wrote:
>... 
> Shouldn't the earlycon entry be updated for the "clk" stuff too?
> 
> 
> Paul Bolle

Indeed, I missed that.  Here is the final (?) version of the patch,
the only change is in the documentation.

As an aside, I would personally be in favor of removing the `earlycon'
kernel parameter entirely, it seems to be a strict subset of the
`console' parameter and anyone that wants `earlycon' probably wants
`console' anyway.  Is there a strong argument for keeping that
parameter that I'm missing?

-- 
Don Dugger
"Censeo Toto nos in Kansa esse decisse." - D. Gale
n0ano@n0ano.com
Ph: 303/443-3786

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
+		uart[8250],io,<addr>[,options,[clkd]]
+		uart[8250],mmio,<addr>[,options,[clkd]]
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
