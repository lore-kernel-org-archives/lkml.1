Return-Path: <linux-kernel-owner+w=401wt.eu-S1945968AbXBPTIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945968AbXBPTIz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 14:08:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946225AbXBPTIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 14:08:55 -0500
Received: from smtp107.sbc.mail.mud.yahoo.com ([68.142.198.206]:41286 "HELO
	smtp107.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1945968AbXBPTIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 14:08:54 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=hResj2Mxekv/RNWjxalNxHs2p+U5ArHhgjQCBBnETxxjdT625S4PEb7WQ7wh4WL/AHlWk6pj5e+/XHb5AIHHK8CIsgPbRx8B/hUj6MevDN3hLT3Gpeqo/uQqQwyQUgjZAAtJpaiThihiSSN+ZgXxd5vZSdRU+YIz35ey9LcCiVU=  ;
X-YMail-OSG: 6NLrrkQVM1lMPoN80YUiuSwhjTJ3zTkO5ilb8yokgNa435wtJuEGmjnDVVHDDGZwJYkQbQYTg80EaYV0nIZdlB9TjdHNggk5x7mjIR1YYerTmoscdXZong--
From: David Brownell <david-b@pacbell.net>
To: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
Subject: Re: [PATCH] input/spi: add ads7843 support to ads7846 touchscreen driver
Date: Fri, 16 Feb 2007 11:08:50 -0800
User-Agent: KMail/1.7.1
Cc: Patrice Vilchez <patrice.vilchez@rfo.atmel.com>,
       linux-kernel@vger.kernel.org, Andrew Victor <andrew@sanpeople.com>
References: <20061222192536.A206A1F0CDB@adsl-69-226-248-13.dsl.pltn13.pacbell.net> <200612291226.46984.david-b@pacbell.net> <45D5EBC3.8090208@rfo.atmel.com>
In-Reply-To: <45D5EBC3.8090208@rfo.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702161108.51014.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 February 2007 9:37 am, Nicolas Ferre wrote:
> David Brownell :
> [..]
> > Thanks!  I'll be glad to see fewer versions of this driver floating around.
> > And to see the next version of the ads7843 patches ... :) 
> 
> Hi,
> 
> Here is the ads7843 support for the ads7846 touchscreen driver. It is 
> very little and takes great advantage of the previous rework.

Good!  But see below for one fix ... after that, please split out the
ads7846 update by itself, and submit that patch to the input subsystem
maintainer with your signed-off-by.

Did you find out what was causing the jerky behavior (draw a circle,
it looks like a square) before?


> Tested on Atmel at91sam926[13]ek board with atmel_spi underlying driver.

Which has now been merged; minor fixes needed, including a build
fix for AT91.  I expect those will merge by the time 2.6.21 is done.
Looks like that driver is going to get a fair amount of use.  :)

 
> I also put a use case based on the at91sam9263ek init code. This code is 
> just sent as an example, I will send those init patches trough AT91 
> maintainer.

Yeah, support for that board hasn't made it to kernel.org yet.
I hope you'll also update Atmel's other EK boards using this chip.


> Index: linux-2.6.20-at91/drivers/input/touchscreen/ads7846.c
> ===================================================================
> --- linux-2.6.20-at91.orig/drivers/input/touchscreen/ads7846.c
> +++ linux-2.6.20-at91/drivers/input/touchscreen/ads7846.c
> @@ -39,7 +39,8 @@
>  /*
>   * This code has been heavily tested on a Nokia 770, and lightly
>   * tested on other ads7846 devices (OSK/Mistral, Lubbock).
> - * Support for ads7843 and ads7845 has only been stubbed in.
> + * Support for ads7843 tested on Atmel at91sam926x-EK.
> + * Support for ads7845 has only been stubbed in.
>   *
>   * IRQ handling needs a workaround because of a shortcoming in handling
>   * edge triggered IRQs on some platforms like the OMAP1/2. These
> @@ -246,18 +247,15 @@ static int ads7846_read12_ser(struct dev
>  
>  	/* REVISIT:  take a few more samples, and compare ... */
>  
> -	/* maybe off internal vREF */
> -	if (use_internal) {

This part doesn't make sense.  Could you say what you're trying
to do?  The ads7846 requres an external vREF.  Is the issue that
maybe the REF_OFF command isn't just turning off the (non-existent)
internal voltage reference?  If so the comments need updating, and
maybe the name REF_OFF needs to change too...


> -		req->ref_off = REF_OFF;
> -		req->xfer[4].tx_buf = &req->ref_off;
> -		req->xfer[4].len = 1;
> -		spi_message_add_tail(&req->xfer[4], &req->msg);
> -
> -		req->xfer[5].rx_buf = &req->scratch;
> -		req->xfer[5].len = 2;
> -		CS_CHANGE(req->xfer[5]);
> -		spi_message_add_tail(&req->xfer[5], &req->msg);
> -	}
> +	req->ref_off = REF_OFF;
> +	req->xfer[4].tx_buf = &req->ref_off;
> +	req->xfer[4].len = 1;
> +	spi_message_add_tail(&req->xfer[4], &req->msg);
> +
> +	req->xfer[5].rx_buf = &req->scratch;
> +	req->xfer[5].len = 2;
> +	CS_CHANGE(req->xfer[5]);
> +	spi_message_add_tail(&req->xfer[5], &req->msg);
>  
>  	ts->irq_disabled = 1;
>  	disable_irq(spi->irq);
> @@ -536,6 +534,10 @@ static void ads7846_rx(void *ads)
>  	} else
>  		Rt = 0;
>  
> +	if (ts->model == 7843)
> +		Rt = ts->pressure_max / 2;
> +
> +

Heh.  Other than turning whatever-that-is off, this looks like the only
substantive change needed.  You're right, this isn't much at all ... the
ads7843 support has now become almost trivial!


>  	/* Sample found inconsistent by debouncing or pressure is beyond
>  	 * the maximum. Don't report it to user space, repeat at least
>  	 * once more the measurement
> 
> 
