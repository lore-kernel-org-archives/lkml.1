Return-Path: <linux-kernel-owner+w=401wt.eu-S1758189AbYESBOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758189AbYESBOj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 21:14:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757501AbYESBLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 21:11:36 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:22513 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751417AbYESBLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 21:11:03 -0400
Date: Mon, 19 May 2008 10:09:28 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-sh <linux-sh@vger.kernel.org>, linux-input@vger.kernel.org
Subject: Re: [PATCH] input: add support for SEGA Dreamcast controller as joystick
Message-ID: <20080519010928.GA8797@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian McMenamin <adrian@newgolddream.dyndns.info>,
	LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-sh <linux-sh@vger.kernel.org>, linux-input@vger.kernel.org
References: <1211138322.6354.5.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1211138322.6354.5.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 18, 2008 at 08:18:42PM +0100, Adrian McMenamin wrote:
> +MODULE_AUTHOR("YAEGASHI Takeshi <t@keshi.org>");
> +MODULE_DESCRIPTION("SEGA Dreamcast controller driver");
> +MODULE_LICENSE("GPL");
> +
MODULE_AUTHOR() is a bit ambiguous here. As this is user-visible by way
of modinfo, it really doesn't make any sense to list someone who has
nothing to do with the driver in its present form here. Especially since
it's been 7 years since their last contribution or even basic list
activity, I think it's safe to say that you are going to be the only one
that users wish to contact about this.

In this case, the copyright should suffice. You may wish to add a bit of
a note there indicating where the driver came from, but there's not much
point in going beyond that.

Note that if you aren't comfortable with being in MODULE_AUTHOR(), you
can also make this more generic and attribute it to the LinuxDC or
Linux/SH teams respectively, as that's a bit more true to form as far as
all copyright holders are concerned, and gives people a pointer to a list
to go to with problems.

It's probably more reasonable to treat MODULE_AUTHOR() as
MODULE_MAINTAINER() rather than the literal original author, as the
latter is of zero interest or relevance to users that are looking at
this information on the other side of the fence.

> +struct dc_pad {
> +	struct input_dev *dev;
> +	struct maple_device *mdev;
> +};
> +
This is pretty ugly, you should really fix up your private device
pointer layering to get around having to use this structure at all.

> +static struct maple_driver dc_pad_driver = {
> +	.function =	MAPLE_FUNC_CONTROLLER,
> +	.connect =	dc_pad_connect,
> +	.disconnect =	dc_pad_disconnect,
> +	.drv = {
> +		.name = "Dreamcast_controller",

Is there some particular reason why the driver name can't reflect the
module name? There's no reason to have such sickeningly verbose driver
names.

> +		.probe = probe_maple_controller,
> +		.remove = remove_maple_controller,
> +	},
> +};
> +
These should be __devinit/__devexit at least, with the latter being
__devexit_p() wrapped..

> +static int __init dc_pad_init(void)
> +{
> +	return 	maple_driver_register(&dc_pad_driver.drv);
> +}
> +
> +static void __exit dc_pad_exit(void)
> +{
> +	driver_unregister(&dc_pad_driver.drv);
> +}
> +
If you don't have a maple_driver_unregister(), stub one in, even if it's
just a wrapper.
