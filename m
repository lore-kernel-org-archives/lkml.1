Return-Path: <linux-kernel-owner+w=401wt.eu-S1161382AbXBHBHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161382AbXBHBHs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 20:07:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161429AbXBHBHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 20:07:48 -0500
Received: from wr-out-0506.google.com ([64.233.184.226]:36860 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161382AbXBHBHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 20:07:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ngkZwRCZK3/5K4GmEo6aR15n8kE8chuvntw6DC2YXNu1U0RWDZp705wg9Hx6l4nedgrXVzvw+wtXKXBzH6P8p5dxxnRvr03z3d5D8z0d7DckSCuDOJnPz0WhHlvBLqmb/FuF8bgNatluIyS8WxeZJA3t8lJYLsGWUY9NgJCgfC0=
Message-ID: <6d6a94c50702071707w7422f911j8a8f8c4da5b3020a@mail.gmail.com>
Date: Thu, 8 Feb 2007 09:07:45 +0800
From: "Aubrey Li" <aubreylee@gmail.com>
To: "Wu, Bryan" <bryan.wu@analog.com>, alan@lxorguk.ukuu.org.uk,
       aubreylee@gmail.com, akpm@linux-foundation.org, rdunlap@xenotime.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3, try #3] Blackfin: serial driver for Blackfinarchitecture against Linux kernel 2.6.20
In-Reply-To: <20070207192633.GA27194@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1170845398.5399.36.camel@roc-desktop>
	 <20070207192633.GA27194@flint.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/8/07, Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> On Wed, Feb 07, 2007 at 06:49:58PM +0800, Wu, Bryan wrote:
> > Thanks Russell's review, we update the serial core driver according to
> > Russell's comments.  Here is the change log:
> >
> > a) use "ttyBF" as blackfin serial name and use new serial major/minor number
> > b) can accept command line serial setting like "console=ttyBF0,115200", delete the baud rate setting macros
> > c) termios can be changed on the fly
>
> Since you're not implementing the ability to handle INPCK, BRKINT, PARMRK,
> IGNPAR and IGNBRK, please arrange for your driver to reflect the real
> settings in the termios.
>
> In other words:
>
> > +static void
> > +bfin_serial_set_termios(struct uart_port *port, struct ktermios *termios,
> > +                struct ktermios *old)
> > +{
> > +     struct bfin_serial_port *uart = (struct bfin_serial_port *)port;
> > +     unsigned long flags;
> > +     unsigned int baud, quot;
> > +     unsigned short val, ier, lcr = 0;
> > +
> > +     switch (termios->c_cflag & CSIZE) {
> > +     case CS8:
> > +             lcr = WLS(8);
> > +             break;
> > +     case CS7:
> > +             lcr = WLS(7);
> > +             break;
> > +     case CS6:
> > +             lcr = WLS(6);
> > +             break;
> > +     case CS5:
> > +             lcr = WLS(5);
> > +             break;
> > +     default:
> > +             printk(KERN_ERR "%s: word lengh not supported\n",
> > +                     __FUNCTION__);
> > +     }
> > +
> > +     if (termios->c_cflag & CSTOPB);
> > +             lcr |= STB;
> > +     if (termios->c_cflag & PARENB) {
> > +             lcr |= PEN;
> > +             if (!(termios->c_cflag & PARODD))
> > +                     lcr |= EPS;
> > +     }
>
> Insert here:
>         termios->c_iflag |= INPCK | BRKINT | PARMRK;
>         termios->c_iflag &= ~(IGNPAR | IGNBRK);
>
> This way applications will know that these controls are not implemented
> for this port.

Thanks a lot to point it out. I'll fix this and re-send the patch.

Regards,
-Aubrey
