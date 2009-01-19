Return-Path: <linux-kernel-owner+w=401wt.eu-S1759047AbZASKE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759047AbZASKE0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 05:04:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755769AbZASKEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 05:04:13 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46829 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754399AbZASKEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 05:04:11 -0500
Date: Mon, 19 Jan 2009 11:03:42 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Jaya Kumar <jayakumar.lkml@gmail.com>
Cc: David Brownell <david-b@pacbell.net>, Eric Miao <eric.miao@marvell.com>,
       Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org
Subject: Re: [RFC 2.6.28 1/2] gpiolib: add set/get batch v4
Message-ID: <20090119100342.GA16400@pengutronix.de>
References: <12321862383405-git-send-email-jayakumar.lkml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <12321862383405-git-send-email-jayakumar.lkml@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaya,

On Sat, Jan 17, 2009 at 05:57:17PM +0800, Jaya Kumar wrote:
> Hi friends,
> 
> This is v4 of batch support for gpiolib. Thanks to David Brownell, Eric Miao,
> David Hylands, Robin, Ben, Jamie and others for prior feedback. The post for
> v3 summarized the previous discussion. Since then the changes I've made are:
> - split the patches into generic and arch specific
IMHO this should be three patches: "gpiolib", "pxa" and "am300epd".
Well, ...

> +[OPTIONAL] Spinlock-Safe GPIO Batch access
Is it really spinlock safe in general?  Or only if gpio_cansleep(gpio)
if false for each gpio to get or set?

> +static int __generic_gpio_set_batch(struct gpio_chip *chip, unsigned offset,
> +					u32 values, u32 bitmask, int width)
IMHO a better name is __gpio_set_batch_generic (or
__gpiolib_set_batch_generic?), YMMV.

> +int __gpio_set_batch(unsigned gpio, u32 values, u32 bitmask, int bitwidth)
Sometimes your width parameter is called bitwidth, sometimes width.  I'd
like to have that consistant.

While talking about this parameter.  I don't really like it, because you
can calculate it from bitmask.  In an earlier mail you write:

	bitwidth (needed to iterate and map to chip ngpios) could be
	calculated from bitmask, but that involves iteratively counting
	bits from the mask, so we would have to do 800*600 bit counts.
	Unless, we do ugly things like cache the previous bitwidth/mask
	and compare against the current caller arguments. Given that the
	bitwidth would typically be a fixed value, I believe it is more
	intuitive for the caller to provide it, ...

I think it's easier than that.  bitwidth is just fls(bitmask) which
should be efficient enough not to bother the programmer.  If bitmask is
constant it's even the compiler that does the work here.

BTW, I wonder why the argument to fls has type int and not unsigned.

Best regards,
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
Peiner Strasse 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686              | Fax:   +49-5121-206917-5555 |
