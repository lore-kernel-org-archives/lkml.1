Return-Path: <linux-kernel-owner+w=401wt.eu-S965615AbXBGFJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965615AbXBGFJq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 00:09:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965639AbXBGFJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 00:09:46 -0500
Received: from smtp.osdl.org ([65.172.181.24]:34627 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965615AbXBGFJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 00:09:45 -0500
Date: Tue, 6 Feb 2007 21:09:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       Greg KH <greg@kroah.com>
Subject: Re: [PATCH] mfd: SM501 core driver
Message-Id: <20070206210930.fc814bf6.akpm@linux-foundation.org>
In-Reply-To: <20070206192628.GA13644@fluff.org.uk>
References: <20070206192628.GA13644@fluff.org.uk>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Feb 2007 19:26:28 +0000 Ben Dooks <ben-linux@fluff.org> wrote:

> This patch is an update patch, ready for merging
> for the Silicon Motion SM501 multi-function device
> core.
> 
> This driver handles the core function of the chip,
> including the clock, power control and allocation
> of resources for drivers. It also exports a series
> of platform devices for the function drivers to
> attach to.
> 
> This patch supports both platform and PCI bus
> attached devices.
> 
> Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Can we get Vincent's signoff here?

> +#ifdef CONFIG_DEBUG

This doesn't appear to be defined anywhere, and nor should it be. 
Something subsystem-specific should be used here?

> +static const unsigned int misc_div[] = {
> +	[0]		= 1,
> +	[1]		= 2,
> +	[2]		= 4,
> +	[3]		= 8,
> +	[4]		= 16,
> +	[5]		= 32,
> +	[6]		= 64,
> +	[7]		= 128,
> +	[8]		= 3,
> +	[9]		= 6,
> +	[10]		= 12,
> +	[11]		= 24,
> +	[12]		= 48,
> +	[13]		= 96,
> +	[14]		= 192,
> +	[15]		= 384,
> +};
> +
> +static const unsigned int px_div[] = {
> +	[0]		= 1,
> +	[1]		= 2,
> +	[2]		= 4,
> +	[3]		= 8,
> +	[4]		= 16,
> +	[5]		= 32,
> +	[6]		= 64,
> +	[7]		= 128,
> +	[8]		= 3,
> +	[9]		= 6,
> +	[10]	        = 12,
> +	[11]		= 24,
> +	[12]		= 48,
> +	[13]		= 96,
> +	[14]		= 192,
> +	[15]		= 384,
> +	[16]		= 5,
> +	[17]		= 10,
> +	[18]		= 20,
> +	[19]		= 40,
> +	[20]		= 80,
> +	[21]		= 160,
> +	[22]		= 320,
> +	[23]		= 604,
> +};
> +#endif
> +
> +#define decode_div(val, lshft, selbit, mask, dtab) \
> +	((((val) & (selbit)) ? pll2 : 288 * MHZ) / dtab[(((val) >> (lshft)) & (mask))])

A C function would be nicer here, if poss.

> +#define fmt_freq(x) ((x) / MHZ), ((x) % MHZ), (x)

eww.

> +		(void)readl(sm->regs);

Is there any benefit in all those casts?  Generally we prefer to avoid
them.

> +EXPORT_SYMBOL_GPL(sm501_misc_control);

The driver exports a lot of symbols.  Does it really need to?

> +	down(&sm->clock_lock);

Please convert to a mutex, if possible.

> +/* sm501_null_release
> + *
> + * A release function for the platform devices we create to keep the
> + * driver core happy, and stop any crashed when the devices are removed
> +*/
> +
> +static void sm501_null_release(struct device *dev)
> +{
> +}

Greg might have an opinion on that ;)

> +static void sm501_create_mem(struct sm501_devdata *sm,
> +			     struct resource *res,
> +			     unsigned long *offs,
> +			     unsigned long size)
> +{
> +	*offs -= size;		/* adjust memory size */
> +
> +	res->flags = IORESOURCE_MEM;
> +	res->parent = sm->mem_res;
> +	res->start = sm->mem_res->start + *offs;
> +	res->end = res->start + size - 1;
> +}

Please use resource_size_t throughout, test with CONFIG_RESOURCES_64BIT on
and off.

> +static inline void sm501_init_reg(struct sm501_devdata *sm,
> +				  unsigned long reg,
> +				  struct sm501_reg_init *r)
> +{
> +	unsigned long tmp;
> +
> +	tmp = readl(sm->regs + reg);
> +	tmp |= r->set;
> +	tmp &= ~r->mask;
> +	writel(tmp, sm->regs + reg);
> +}

This might be too large to inline.


