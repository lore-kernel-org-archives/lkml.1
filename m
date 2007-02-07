Return-Path: <linux-kernel-owner+w=401wt.eu-S1030652AbXBGT0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030652AbXBGT0w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 14:26:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030654AbXBGT0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 14:26:52 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:2544 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030652AbXBGT0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 14:26:51 -0500
Date: Wed, 7 Feb 2007 19:26:33 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: "Wu, Bryan" <bryan.wu@analog.com>
Cc: alan@lxorguk.ukuu.org.uk, aubreylee@gmail.com, akpm@linux-foundation.org,
       rdunlap@xenotime.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3, try #3] Blackfin: serial driver for Blackfinarchitecture against Linux kernel 2.6.20
Message-ID: <20070207192633.GA27194@flint.arm.linux.org.uk>
Mail-Followup-To: "Wu, Bryan" <bryan.wu@analog.com>,
	alan@lxorguk.ukuu.org.uk, aubreylee@gmail.com,
	akpm@linux-foundation.org, rdunlap@xenotime.net,
	linux-kernel@vger.kernel.org
References: <1170845398.5399.36.camel@roc-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1170845398.5399.36.camel@roc-desktop>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 07, 2007 at 06:49:58PM +0800, Wu, Bryan wrote:
> Thanks Russell's review, we update the serial core driver according to
> Russell's comments.  Here is the change log:
> 
> a) use "ttyBF" as blackfin serial name and use new serial major/minor number 
> b) can accept command line serial setting like "console=ttyBF0,115200", delete the baud rate setting macros
> c) termios can be changed on the fly

Since you're not implementing the ability to handle INPCK, BRKINT, PARMRK,
IGNPAR and IGNBRK, please arrange for your driver to reflect the real
settings in the termios.

In other words:

> +static void
> +bfin_serial_set_termios(struct uart_port *port, struct ktermios *termios,
> +		   struct ktermios *old)
> +{
> +	struct bfin_serial_port *uart = (struct bfin_serial_port *)port;
> +	unsigned long flags;
> +	unsigned int baud, quot;
> +	unsigned short val, ier, lcr = 0;
> +
> +	switch (termios->c_cflag & CSIZE) {
> +	case CS8:
> +		lcr = WLS(8);
> +		break;
> +	case CS7:
> +		lcr = WLS(7);
> +		break;
> +	case CS6:
> +		lcr = WLS(6);
> +		break;
> +	case CS5:
> +		lcr = WLS(5);
> +		break;
> +	default:
> +		printk(KERN_ERR "%s: word lengh not supported\n", 
> +			__FUNCTION__);
> +	}
> +	
> +	if (termios->c_cflag & CSTOPB);
> +		lcr |= STB;
> +	if (termios->c_cflag & PARENB) {
> +		lcr |= PEN;
> +		if (!(termios->c_cflag & PARODD))
> +			lcr |= EPS;
> +	}

Insert here:
	termios->c_iflag |= INPCK | BRKINT | PARMRK;
	termios->c_iflag &= ~(IGNPAR | IGNBRK);

This way applications will know that these controls are not implemented
for this port.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
