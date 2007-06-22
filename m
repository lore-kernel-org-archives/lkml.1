Return-Path: <linux-kernel-owner+w=401wt.eu-S1755562AbXFVL7O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562AbXFVL7O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 07:59:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753232AbXFVL67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 07:58:59 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4743 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120AbXFVL67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 07:58:59 -0400
Message-ID: <467BB979.2000907@shadowen.org>
Date: Fri, 22 Jun 2007 12:58:49 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>, Alex Chiang <achiang@hp.com>,
       akpm@linux-foundation.org, ak@suse.de,
       Gerd Hoffmann <kraxel@redhat.com>, rmk@arm.linux.org.uk,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] serial : convert early_uart to earlycon for 8250 fix
 3 alias
References: <200706010002.l5102LN5031209@shell0.pdx.osdl.net> <466EC86C.6000601@sun.com> <200706120955.44097.yinghai.lu@sun.com> <200706211042.54917.yinghai.lu@sun.com>
In-Reply-To: <200706211042.54917.yinghai.lu@sun.com>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> [PATCH] serial : convert early_uart to earlycon for 8250 fix 3 alias
> 
> make the console=uart,io,0x3f8,9600n8 like console=uart8250,io,0x3f8,9600
> suggested by Andy Whitcroft.
>  
> Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
> 
> --- a/Documentation/kernel-parameters.txt	2007-06-21 10:12:48.000000000 -0700
> +++ b/Documentation/kernel-parameters.txt	2007-06-21 10:13:43.000000000 -0700
> @@ -467,16 +467,16 @@
>  			Documentation/networking/netconsole.txt for an
>  			alternative.
>  
> -		uart8250,io,<addr>[,options]
> -		uart8250,mmio,<addr>[,options]
> +		uart[8250],io,<addr>[,options]
> +		uart[8250],mmio,<addr>[,options]
>  			Start an early, polled-mode console on the 8250/16550
>  			UART at the specified I/O port or MMIO address,
>  			switching to the matching ttyS device later.  The
>  			options are the same as for ttyS, above.
>  
>  	earlycon=	[KNL] Output early console device and options.
> -		uart8250,io,<addr>[,options]
> -		uart8250,mmio,<addr>[,options]
> +		uart[8250],io,<addr>[,options]
> +		uart[8250],mmio,<addr>[,options]
>  			Start an early, polled-mode console on the 8250/16550
>  			UART at the specified I/O port or MMIO address.
>  			The options are the same as for ttyS, above.
> --- a/drivers/serial/8250_early.c	2007-06-21 10:04:25.000000000 -0700
> +++ b/drivers/serial/8250_early.c	2007-06-21 10:12:08.000000000 -0700
> @@ -210,8 +210,11 @@
>  	int err;
>  
>  	options = strstr(cmdline, "uart8250,");
> -	if (!options)
> -		return 0;
> +	if (!options) {
> +		options = strstr(cmdline, "uart,");
> +		if (!options)
> +			return 0;
> +	}

This could probabally be written as below and be a little clearer:

options = strstr(cmdline, "uart8250,");
if (!options)
	options = strstr(cmdline, "uart,");
if (!options)
	return 0;



>  
>  	options = strchr(cmdline, ',') + 1;
>  	if ((err = early_serial8250_setup(options)) < 0)
> @@ -227,6 +230,7 @@
>  	struct early_serial8250_device *device = &early_device;
>  	struct uart_port *port = &device->port;
>  	int line;
> +	int ret;
>  
>  	if (!device->port.membase && !device->port.iobase)
>  		return -ENODEV;
> @@ -235,8 +239,13 @@
>  	if (line < 0)
>  		return -ENODEV;
>  
> -	return update_console_cmdline("uart", 8250,
> +	ret = update_console_cmdline("uart", 8250,
> +			     "ttyS", line, device->options);
> +	if (ret < 0)
> +		ret = update_console_cmdline("uart", 0,
>  				     "ttyS", line, device->options);
> +
> +	return ret;
>  }
>  
>  early_param("earlycon", setup_early_serial8250_console);

Other than the little nit above I have tested this on the machine which
was all upset over the change and it works like a charm.

Acked-by: Andy Whitcroft <apw@shadowen.org>

-apw
