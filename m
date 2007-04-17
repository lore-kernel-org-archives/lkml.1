Return-Path: <linux-kernel-owner+w=401wt.eu-S1753831AbXDQEzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831AbXDQEzJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 00:55:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753888AbXDQEzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 00:55:09 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:24679 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031084AbXDQEzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 00:55:06 -0400
X-IronPort-AV: i="4.14,417,1170651600"; 
   d="scan'208"; a="35272178:sNHT25575704"
Subject: Re: [PATCH] Blackfin: blackfin on-chip SPI controller driver
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: David Brownell <david-b@pacbell.net>
Cc: bryan.wu@analog.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
In-Reply-To: <200704161931.36065.david-b@pacbell.net>
References: <1173091280.5264.201.camel@roc-desktop>
	 <200704161931.36065.david-b@pacbell.net>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Tue, 17 Apr 2007 12:52:13 +0800
Message-Id: <1176785533.11515.18.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-16 at 18:31 -0800, David Brownell wrote:
> Cleaning out some of my pending-reviews queue ... after you address
> these comments I think what I'd like to do is sign off on one clean
> patch, rather than initial-plus-cleanups.
> 
> 

Thanks a lot, David. We will try to cleanup the code and most issues
pointed out in your review.

> On Monday 05 March 2007 2:41 am, Wu, Bryan wrote:
> 
> > --- linux-2.6.orig/drivers/spi/Kconfig	2007-03-01 11:33:07.000000000 +0800
> > +++ linux-2.6/drivers/spi/Kconfig	2007-03-01 11:40:22.000000000 +0800
> 
> I'm adjusting this to address the later patches you sent.
> 
> One global comment I'll make, just in case -- please make
> sure all your line-start indents only include tabs, and
> there's no space-at-end-of-line stuff going on, or lines
> wrapping past column 80.
> 
> I did this review in KMail, which doesn't highlight such
> minor errors; and I suspect you're mostly OK, but for a
> new driver there's no reason not to be 100% OK in those
> particular respects!  (And I *did* notice one of your
> cleanup patches clearly adding tabs-then-spaces indents.)
> 

Yes, I sent out a coding style incremental patch appending in -mm tree.
Should I send out a new patch including the coding style clean up and
code updated according to this review, or still submit incremental
patches to Andrew?

> 
> > @@ -156,7 +156,11 @@
> >  #
> >  # Add new SPI protocol masters in alphabetical order above this line
> >  #
> > -
> > +config SPI_BFIN
> > +	tristate "SPI controller driver for ADI Blackfin5xx"
> > +	depends on SPI_MASTER && BFIN
> > +	help
> > +	  This is the SPI controller master driver for Blackfin 5xx processor.
> 
> Please put this in Kconfig up with the other SPI controller drivers, in
> alphabetical order.  Just like the comment says.
> 
> Likewise, please add it to the Makefile in alphabetical order.
> 

Got it, it should be followed.

> 
> > --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> > +++ linux-2.6/drivers/spi/spi_bfin5xx.c	2007-03-01 11:40:22.000000000 +0800
> 
> > +#ifdef DEBUG
> > +#define ASSERT(expr) \
> > +	if (!(expr)) { \
> > +		printk(KERN_DEBUG "assertion failed! %s[%d]: %s\n", \
> > +		       __FUNCTION__, __LINE__, #expr); \
> > +		panic(KERN_DEBUG "%s", __FUNCTION__); \
> 
> Seems like either WARN_ON(expr) or BUG_ON(expr) will be better.
> The general rule of BUG variants is: don't, unless the system
> really can't continue operating.  (I see a later patch removed
> this entirely, good.
> 
> 
Yes, we are trying to use kernel generic BUG_ON and WARN_ON to replace
our own assert function. I fixed this in other code and obviously it was
missed in this driver patch. 

> > +	}
> > +#else
> > +#define ASSERT(expr)
> > +#endif
> > +
> > +#define IS_DMA_ALIGNED(x) (((u32)(x)&0x07)==0)
> > +
> > +#define DEFINE_SPI_REG(reg, off) \
> > +static inline u16 read_##reg(void) \
> > +            { return *(volatile unsigned short*)(SPI0_REGBASE + off); } \
> > +static inline void write_##reg(u16 v) \
> > +            {*(volatile unsigned short*)(SPI0_REGBASE + off) = v;\
> > +             SSYNC();}
> 
> These should be readw() and writew() or similar... also, I can't tell
> what SSYNC() does, but it sure looks like something that shouldn't be
> hidden like that.  I/O memory should be mapped such that writes don't
> get re-ordered.  And flushing any write buffer should not be forced in
> such low-level accessors ... if it's needed, it should be done at the
> relevant points in the driver.  (Which you seem to do in a few places
> below.  The duplication is undesirable.)
> 
> 
> > +
> > +DEFINE_SPI_REG(CTRL, 0x00)
> 
> ... this particular style of register accessor is not generally used in Linux.
> The typical style is
> 
> 	u16 value = __raw_readw(SPI0_REGBASE + SPI_CTRL)
> 	__raw_writew(SPI0_REGBASE + SPI_CTRL, value);
> 
> or wrapped in macros so spi_readw(CTRL) and spi_writew(CTRL, value) work.
> 
> Of course, SPI1/SPI2/etc should be supported too ... so it's common to have
> those take a pointer to some controller struct with a "void __iomem *regs"
> pointer to the rgisters for that instance.  spi_readw(master, CTRL) etc.
>  
> 
> > +#define START_STATE ((void*)0)
> > +#define RUNNING_STATE ((void*)1)
> > +#define DONE_STATE ((void*)2)
> > +#define ERROR_STATE ((void*)-1)
> 
> Normally states would be represented by enum values, which among other
> things supports "switch (state) { ... }" state machine code.  This driver
> is full of uncommon idioms, which will make it harder for most kernel
> developers to dive in and help.
> 
> Even if you have a style guide internal to Analog which says to do things
> this way ... don't.
> 
> 

Apparently, the driver author Luke wrote this driver based on
drivers/spi/pxa2xx_spi.c. These things are all from pxa2xx_spi.c driver.
I will update our driver according to your comments.

> > +
> > +#define QUEUE_RUNNING 0
> > +#define QUEUE_STOPPED 1
> > +
> > +int dma_requested;
> > +char chip_select_flag;
> 
> These should probably be members of the per-controller state struct,
> and otherwise should certainly be static.  This driver exports a LOT
> of stuff that should be static ...
> 

You are right. It should be fixed up

> 
> > +
> > +struct driver_data {
> 
> Not the most explanatory of names.  Could you do better?
> 
> 

Copy that from pxa2xx_spi.c, sorry.
And your comments are very valuable, we will update this driver ASAP.
Thanks again
Best Regards,
-Bryan Wu
