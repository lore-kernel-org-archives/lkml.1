Return-Path: <linux-kernel-owner+w=401wt.eu-S1767514AbXCITaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767514AbXCITaR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 14:30:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767510AbXCITaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 14:30:17 -0500
Received: from smtp103.sbc.mail.mud.yahoo.com ([68.142.198.202]:34145 "HELO
	smtp103.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1767514AbXCITaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 14:30:15 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=i0gqnF+0Y6y/HikNIuXsMGamuPXI1IUteAUbioPhDAVrEz1MI9F4dgy2Etp6WcDXx1YtDPMkCKHjPCy6W9Nkf0e8LkTYkKTd4wRCwdyIGFFR7rdia9IfYKeC+Y237fBDQld/9jUibtKOrKR8qF4voy75uwSWPe6NZK2i+YQK10Q=  ;
X-YMail-OSG: nYyHwqwVM1lqGpjIPjty1D4NpFYbUi3rMFXhNZoQoS.Yp1V8BjTyJvQBsmxM02A93smhj0dgNG5us2k4lWLnkeIpf4WpqTeKaWcZkfv8q8ujUa3r6wGPoWw5ghqdyHZIgGIR2pzE.XOwxY8-
From: David Brownell <david-b@pacbell.net>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: [PATCH] Bitbanging i2c bus driver using the GPIO API
Date: Fri, 9 Mar 2007 11:30:12 -0800
User-Agent: KMail/1.7.1
Cc: Jean Delvare <khali@linux-fr.org>, Bryan Wu <bryan.wu@analog.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Deepak Saxena <dsaxena@plexity.net>, linux-kernel@vger.kernel.org
References: <200703090945.38880.david-b@pacbell.net> <11734661281633-git-send-email-hskinnemoen@atmel.com>
In-Reply-To: <11734661281633-git-send-email-hskinnemoen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703091130.13547.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 March 2007 10:48 am, Haavard Skinnemoen wrote:
> This is a very simple bitbanging i2c bus driver utilizing the new
> arch-neutral GPIO API. Useful for chips that don't have a built-in
> i2c controller, additional i2c busses, or testing purposes.

That's the right idea!  But remember that not all GPIOs support
reading back the actual value on SCL (it's an OUT pin, so lacking
multidrive capability the values "should" be what you wrote), so
getscl() support should depend on a flag in platform data.  In
the same vein, if SCL is an output-only pin, you won't be able
to change its direction ... but then, I'm not sure why you were
changing its direction in setscl() rather than just its value.

I2C has another interesting special case.  at91_set_multi_drive()
would be appropriate (yes?) for ARCH_AT91 to use on SCL, to best
support both clock stretching and multi-master configurations.


> +	gpio_direction_input(pdata->sda_pin);
> +	gpio_direction_input(pdata->scl_pin);
> +	gpio_set_value(pdata->sda_pin, 0);
> +	gpio_set_value(pdata->scl_pin, 0);

Surely you mean "output" in both cases.  So you can set the
value.  Setting the value on an input pin is undefined.  ;)


> +	printk(KERN_INFO "i2c-gpio: using pins 0x%x (sda) 0x%x (scl)\n",
> +	       pdata->sda_pin, pdata->scl_pin);

Please, no hex there.  I think dev_info() would be better; and it
might be nice to report whether clock stretching is supported.


> --- a/include/linux/i2c-id.h
> +++ b/include/linux/i2c-id.h
> @@ -194,6 +194,7 @@
>  #define I2C_HW_B_EM28XX		0x01001f /* em28xx video capture cards */
>  #define I2C_HW_B_CX2341X	0x010020 /* Conexant CX2341X MPEG encoder cards */
>  #define I2C_HW_B_INTELFB	0x010021 /* intel framebuffer driver */
> +#define I2C_HW_B_GPIO		0x010022 /* Generic GPIO-based driver */

It'd be nice to completely abolish those IDs, starting by not
adding new ones.  Especially, not adding unused ones!

- Dave
