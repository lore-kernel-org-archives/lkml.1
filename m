Return-Path: <linux-kernel-owner+w=401wt.eu-S1757477AbYBXRqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477AbYBXRqt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 12:46:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753178AbYBXRqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 12:46:30 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:54191 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752757AbYBXRq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 12:46:28 -0500
Date: Sun, 24 Feb 2008 18:45:54 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: David Brownell <david-b@pacbell.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, Andrew Victor <linux@maxim.org.za>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
Subject: Re: [patch 2.6.25-rc2-git 1/2] atmel_tc library
Message-ID: <20080224184554.2c863f63@siona>
In-Reply-To: <200802221723.24003.david-b@pacbell.net>
References: <200802221723.24003.david-b@pacbell.net>
Organization: Atmel
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Feb 2008 17:23:23 -0800
David Brownell <david-b@pacbell.net> wrote:

> Create <linux/atmel_tc.h> based on <asm-arm/arch-at91/at91-tc.h> and the
> at91sam9263 and at32ap7000 datasheets.  Most AT91 and AT32 SOCs have one
> or two of these TC blocks, which include three 16-bit timers that can be
> interconnected in various ways.
> 
> These TC blocks can be used for external interfacing (such as PWM and
> measurement), or used as somewhat quirky sixteen-bit timers.
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> ---

Sorry for the delay...some late comments coming up.

> Note that this won't be usable until the AT91 and AT32 platforms
> incorporate patches to configure the relevant platform devices.
> Those changes are probably 2.6.26 material.

Right...and there are a few funny dependencies we need to watch out
for. AVR32 currently uses one of the TC blocks as a system timer. That
code needs to be ripped out, but that will cause a fourfold increase in
the power consumption of the AP7000 CPU. So I want to keep the window
between ripping out the old code and using the new code as small as
possible.

I see the following possibilities:
  * I switch avr32 over to use the new code after it has been merged
    into mainline. This means the new code won't be tested on avr32
    until near the end of the next merge window -- not good.
  * I forward the patches that switch avr32 over to Andrew so that they
    can be included in -mm right after the tclib support. Not a bad
    option, but I'm planning to do more AVR32 PM work before 2.6.26, so
    there might be conflicts.
  * I take the whole thing through my avr32 git tree.
  * I (or someone else) set up a new git tree for tclib + AT91 and
    AVR32 platform support and ask Stephen to pull it into the -next
    tree. Or, once it's stable, rmk and I can both pull it into our
    respective trees. But that obviously means no rebasing and funny
    games from that point on...

I think the last option is the best one. What do you think?

> +#if defined(CONFIG_AVR32)
> +/* AVR32 has these divide PBB */
> +const u8 atmel_tc_divisors[5] = { 0, 4, 8, 16, 32, };
> +EXPORT_SYMBOL(atmel_tc_divisors);
> +
> +#elif defined(CONFIG_ARCH_AT91)
> +/* AT91 has these divide MCK */
> +const u8 atmel_tc_divisors[5] = { 2, 8, 32, 128, 0, };
> +EXPORT_SYMBOL(atmel_tc_divisors);
> +
> +#endif
> +
> +/* we "know" that there will be either one or two TC blocks */
> +static struct platform_device *blocks[2];

You seem to know more about future Atmel chips than I do :-P

I'm not a huge fan of such static limitations. Is there any way we can
turn it into a list? That probably means defining a struct atmel_tc
around each platform_device, but that might be nice to have for other
reasons too.

> +/**
> + * atmel_tc_alloc - allocate a specified TC block
> + * @block: which block to allocate
> + * @iomem: used to return its IO memory resource
> + *
> + * Caller allocates a block.  If it is available, its I/O space is requested
> + * and returned through the iomem pointer, and the device node for the block
> + * is returned.  When it is not available, NULL is returned.

Any reason why it can't ioremap() the registers as well? Most drivers
probably want that.

> + * On some platforms, each TC channel has its own clocks and IRQs.  Drivers
> + * should clk_get() and clk_enable() "t0_clk", "t1_clk, and "t2_clk".
> + * In the same vein, they should platform_get_irq() for irqs 0, 1, and 2.
> + * On other platforms, only irq 0 and "t0_clk" will be available; drivers
> + * should handle with both configurations.

Sounds complicated. I think it would be better if tclib did all the
clk_get() calls and stored each clock into the atmel_tc struct so that
the driver can simply clk_enable() each channel (which may point to the
same clock.)

> +struct platform_device *atmel_tc_alloc(unsigned block, struct resource **iomem)
> +{
> +	struct platform_device	*tc;
> +	struct resource		*r;
> +
> +	if (block >= ARRAY_SIZE(blocks) || !iomem)
> +		return NULL;
> +
> +	tc = blocks[block];
> +	if (tc) {
> +		r = platform_get_resource(tc, IORESOURCE_MEM, 0);
> +		if (r)
> +			r = request_mem_region(r->start, 256, NULL);

Shouldn't you use the real resource size instead of some magic number?

> +static struct platform_driver tc_driver = {
> +	.driver.name	= "atmel_tcb",

Wow, I didn't know that was possible...

> +#define ATMEL_TC_BMR	0xc4		/* TC Block Mode Register */
> +#define     ATMEL_TC_TC0XC0S	(3 << 0)	/* external clock 0 source */
> +#define        ATMEL_TC_TC0XC0S_TCLK0	(0 << 0)

Hmm. Indentation using spaces? I didn't know you were into that sort of
thing ;-)

Anyway, my main issue is that I think we should add a data structure
with information about each device, similar to struct ssc_device in the
atmel-ssc driver. How about something like this?

struct atmel_tc_block {
	void __iomem		*regs;	/* non-NULL when busy */
	struct platform_device	*pdev;
	struct clk		*clk[3];
	struct list_head	node;
};

Haavard
