Return-Path: <linux-kernel-owner+w=401wt.eu-S1161226AbXBGLsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161226AbXBGLsr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 06:48:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161234AbXBGLsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 06:48:46 -0500
Received: from 87-194-8-8.bethere.co.uk ([87.194.8.8]:51124 "EHLO
	aeryn.fluff.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161230AbXBGLsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 06:48:45 -0500
Date: Wed, 7 Feb 2007 11:48:25 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] mfd: SM501 core driver
Message-ID: <20070207114825.GA21120@fluff.org.uk>
References: <20070206192628.GA13644@fluff.org.uk> <20070206210930.fc814bf6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070206210930.fc814bf6.akpm@linux-foundation.org>
X-Disclaimer: I speak for me, myself, and the other one of me.
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 06, 2007 at 09:09:30PM -0800, Andrew Morton wrote:
> On Tue, 6 Feb 2007 19:26:28 +0000 Ben Dooks <ben-linux@fluff.org> wrote:
> 
> > This patch is an update patch, ready for merging
> > for the Silicon Motion SM501 multi-function device
> > core.
> > 
> > This driver handles the core function of the chip,
> > including the clock, power control and allocation
> > of resources for drivers. It also exports a series
> > of platform devices for the function drivers to
> > attach to.
> > 
> > This patch supports both platform and PCI bus
> > attached devices.
> > 
> > Signed-off-by: Ben Dooks <ben-linux@fluff.org>
> 
> Can we get Vincent's signoff here?
> 
> > +#ifdef CONFIG_DEBUG
> 
> This doesn't appear to be defined anywhere, and nor should it be. 
> Something subsystem-specific should be used here?

This protects the code being used by dev_dbg() only from being
warned as not being used.
 
> > +static const unsigned int misc_div[] = {
> > +	[0]		= 1,
> > +	[1]		= 2,
> > +	[2]		= 4,
> > +	[3]		= 8,
> > +	[4]		= 16,
> > +	[5]		= 32,
> > +	[6]		= 64,
> > +	[7]		= 128,
> > +	[8]		= 3,
> > +	[9]		= 6,
> > +	[10]		= 12,
> > +	[11]		= 24,
> > +	[12]		= 48,
> > +	[13]		= 96,
> > +	[14]		= 192,
> > +	[15]		= 384,
> > +};
> > +
> > +static const unsigned int px_div[] = {
> > +	[0]		= 1,
> > +	[1]		= 2,
> > +	[2]		= 4,
> > +	[3]		= 8,
> > +	[4]		= 16,
> > +	[5]		= 32,
> > +	[6]		= 64,
> > +	[7]		= 128,
> > +	[8]		= 3,
> > +	[9]		= 6,
> > +	[10]	        = 12,
> > +	[11]		= 24,
> > +	[12]		= 48,
> > +	[13]		= 96,
> > +	[14]		= 192,
> > +	[15]		= 384,
> > +	[16]		= 5,
> > +	[17]		= 10,
> > +	[18]		= 20,
> > +	[19]		= 40,
> > +	[20]		= 80,
> > +	[21]		= 160,
> > +	[22]		= 320,
> > +	[23]		= 604,
> > +};
> > +#endif
> > +
> > +#define decode_div(val, lshft, selbit, mask, dtab) \
> > +	((((val) & (selbit)) ? pll2 : 288 * MHZ) / dtab[(((val) >> (lshft)) & (mask))])
> 
> A C function would be nicer here, if poss.
> 
> > +#define fmt_freq(x) ((x) / MHZ), ((x) % MHZ), (x)
> 
> eww.

Do you have a better way of printing a nice formatted MHz with
fractional parts? Is it going to be necessary to remove this?

> > +		(void)readl(sm->regs);
> 
> Is there any benefit in all those casts?  Generally we prefer to avoid
> them.

I thoguht they where necessary to stop the compiler optimising
away the readl() ?
 
> > +EXPORT_SYMBOL_GPL(sm501_misc_control);
> 
> The driver exports a lot of symbols.  Does it really need to?

Yes, these are used by the drivers for the specific function
blocks in the chip.
 
> > +	down(&sm->clock_lock);
> 
> Please convert to a mutex, if possible.

The current callers are the device initialisation and ioctl() calls
from the framebuffer layer. I expect all the other callers to be from
ioctl() calls (to update device parameters) or possibly from sysfs
file interaction, so I think that a mutex may be okay for this.
 
> > +/* sm501_null_release
> > + *
> > + * A release function for the platform devices we create to keep the
> > + * driver core happy, and stop any crashed when the devices are removed
> > +*/
> > +
> > +static void sm501_null_release(struct device *dev)
> > +{
> > +}
> 
> Greg might have an opinion on that ;)

Without this the system OOPses when the driver is removed.
 
> > +static void sm501_create_mem(struct sm501_devdata *sm,
> > +			     struct resource *res,
> > +			     unsigned long *offs,
> > +			     unsigned long size)
> > +{
> > +	*offs -= size;		/* adjust memory size */
> > +
> > +	res->flags = IORESOURCE_MEM;
> > +	res->parent = sm->mem_res;
> > +	res->start = sm->mem_res->start + *offs;
> > +	res->end = res->start + size - 1;
> > +}
> 
> Please use resource_size_t throughout, test with CONFIG_RESOURCES_64BIT on
> and off.

I will go and fix this.5~
 
> > +static inline void sm501_init_reg(struct sm501_devdata *sm,
> > +				  unsigned long reg,
> > +				  struct sm501_reg_init *r)
> > +{
> > +	unsigned long tmp;
> > +
> > +	tmp = readl(sm->regs + reg);
> > +	tmp |= r->set;
> > +	tmp &= ~r->mask;
> > +	writel(tmp, sm->regs + reg);
> > +}
> 
> This might be too large to inline.

possibly.

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
