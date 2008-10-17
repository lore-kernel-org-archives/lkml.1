Return-Path: <linux-kernel-owner+w=401wt.eu-S1756147AbYJQQkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147AbYJQQkY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 12:40:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755066AbYJQQkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 12:40:12 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:30693 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754402AbYJQQkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 12:40:10 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: n0ano@n0ano.com
Subject: Re: [PATCH] Enable console on PCI serial devices
Date: Fri, 17 Oct 2008 10:39:52 -0600
User-Agent: KMail/1.9.9
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, donald.d.dugger@intel.com,
       linux-kernel@vger.kernel.org
References: <200810142231.m9EMV95O002974@los-vmm.sc.intel.com> <200810170846.41032.bjorn.helgaas@hp.com> <20081017153652.GH14490@xolotl.n0ano.com>
In-Reply-To: <20081017153652.GH14490@xolotl.n0ano.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810171039.53395.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 October 2008 09:36:52 am n0ano@n0ano.com wrote:
> On Fri, Oct 17, 2008 at 08:46:40AM -0600, Bjorn Helgaas wrote:
> >... 
> > this text is a little confusing.  Since you multiply by 16 below, the
> > number specified by the user isn't really the crystal frequency, is it?
> 
> Can't argue with that.  How about this patch which describes the
> parameter more acurately as a multiplier.

Here's another possibility, maybe too wordy, but maybe more straightforward:

+		uart[8250],mmio,<addr>[,options[,clock]]

+			"clock" is the frequency of the crystal driving
+			the UART clock (typically sixteen times the
+			fastest baud rate supported by the UART).

+		port->uartclk = simple_strtoul(options, NULL, 0);

> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 82c561f..6e5334d 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -505,12 +505,15 @@ and is between 256 and 4096 characters. It is defined in the file
>  			Documentation/networking/netconsole.txt for an
>  			alternative.
>  
> -		uart[8250],io,<addr>[,options]
> -		uart[8250],mmio,<addr>[,options]
> +		uart[8250],io,<addr>[,options[,mult]]
> +		uart[8250],mmio,<addr>[,options[,mult]]
>  			Start an early, polled-mode console on the 8250/16550
>  			UART at the specified I/O port or MMIO address,
>  			switching to the matching ttyS device later.  The
> -			options are the same as for ttyS, above.
> +			"options" are the same as for ttyS, above.  "mult"
> +			is a multiplier defining the crystal frequency which
> +			defaults to 115200 (typically the fastest baud rate
> +			supported by the uart).
>  
>                  If the device connected to the port is not a TTY but a braille
>                  device, prepend "brl," before the device type, for instance
> @@ -518,8 +521,8 @@ and is between 256 and 4096 characters. It is defined in the file
>  		For now, only VisioBraille is supported.
>  
>  	earlycon=	[KNL] Output early console device and options.
> -		uart[8250],io,<addr>[,options]
> -		uart[8250],mmio,<addr>[,options]
> +		uart[8250],io,<addr>[,options,[mult]]
> +		uart[8250],mmio,<addr>[,options,[mult]]
>  			Start an early, polled-mode console on the 8250/16550
>  			UART at the specified I/O port or MMIO address.
>  			The options are the same as for ttyS, above.
> diff --git a/drivers/serial/8250_early.c b/drivers/serial/8250_early.c
> index f279745..edd5803 100644
> --- a/drivers/serial/8250_early.c
> +++ b/drivers/serial/8250_early.c
> @@ -180,6 +180,11 @@ static int __init parse_options(struct early_serial8250_device *device,
>  		snprintf(device->options, sizeof(device->options), "%u",
>  			device->baud);
>  	}
> +	options = strchr(options, ',');
> +	if (options) {
> +		options++;
> +		port->uartclk = simple_strtoul(options, NULL, 0) * 16;
> +	}
>  
>  	printk(KERN_INFO "Early serial console at %s 0x%llx (options '%s')\n",
>  		mmio ? "MMIO" : "I/O port",
> 


