Return-Path: <linux-kernel-owner+w=401wt.eu-S1757509AbXGAPBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757509AbXGAPBg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 11:01:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755104AbXGAPB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 11:01:29 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:45731 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755411AbXGAPB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 11:01:28 -0400
Date: Sun, 1 Jul 2007 16:00:36 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PXA27x UDC driver.
Message-ID: <20070701150036.GA20518@flint.arm.linux.org.uk>
References: <20070628103619.GW13886@enneenne.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070628103619.GW13886@enneenne.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2007 at 12:36:20PM +0200, Rodolfo Giometti wrote:
> attached you can find new version of my patch for PXA27x UDC driver
> support against kernel 2.6.22-rc3 (but it applies also ro rc6).
> 
> I'd like to know what I have to do in order to prepare this patch for
> kernel inclusion. It's time PXA27x has its UDC driver into linux! :)

We're moving the PXA kernel towards being able to be built to support
both PXA25x and PXA27x at the same time.

> diff --git a/arch/arm/mach-pxa/generic.c b/arch/arm/mach-pxa/generic.c
> index 64b08b7..7f390fd 100644
> --- a/arch/arm/mach-pxa/generic.c
> +++ b/arch/arm/mach-pxa/generic.c
> @@ -282,7 +282,11 @@ static struct resource pxa2xx_udc_resources[] = {
>  static u64 udc_dma_mask = ~(u32)0;
>  
>  static struct platform_device udc_device = {
> +#ifdef CONFIG_PXA27x
> +	.name		= "pxa27x-udc",
> +#else
>  	.name		= "pxa2xx-udc",
> +#endif

This precludes that aim.

> diff --git a/drivers/usb/gadget/ether.c b/drivers/usb/gadget/ether.c
> index 325bf7c..d4f5870 100644
> --- a/drivers/usb/gadget/ether.c
> +++ b/drivers/usb/gadget/ether.c
> @@ -257,10 +257,6 @@ MODULE_PARM_DESC(host_addr, "Host Ethernet Address");
>  #define	DEV_CONFIG_CDC
>  #endif
>  
> -#ifdef CONFIG_USB_GADGET_PXA27X
> -#define DEV_CONFIG_CDC
> -#endif
> -

Good.

>  #ifdef CONFIG_USB_GADGET_S3C2410
>  #define DEV_CONFIG_CDC
>  #endif
> @@ -292,6 +288,10 @@ MODULE_PARM_DESC(host_addr, "Host Ethernet Address");
>  #define	DEV_CONFIG_SUBSET
>  #endif
>  
> +#ifdef CONFIG_USB_GADGET_PXA27X
> +#define DEV_CONFIG_SUBSET
> +#endif
> +

Bad - can we not make this runtime dependent?

> +#ifdef CONFIG_EMBEDDED
> +/* few strings, and little code to use them */
> +#undef	DEBUG

Very very silly.  So, if you want to turn on debugging, and also select
some features which are only accessible with EMBEDDED enabled, you have
to edit this file.  No.  Get rid of this.  If people want to get rid of
the space used by debugging, they can just turn debugging off.  No need
to make it any harder than that.

> +/* PXA cache needs flushing with DMA I/O (it's dma-incoherent), but there's
> + * no device-affinity and the heap works perfectly well for i/o buffers.
> + * It wastes much less memory than dma_alloc_coherent() would, and even
> + * prevents cacheline (32 bytes wide) sharing problems.
> + */
> +static void *pxa27x_ep_alloc_buffer(struct usb_ep *_ep, unsigned bytes,
> +				    dma_addr_t * dma, unsigned int gfp_flags)
> +{
> +	char *retval;
> +
> +	retval = kmalloc(bytes, gfp_flags & ~(__GFP_DMA | __GFP_HIGHMEM));
> +	if (retval)
> +#ifdef USE_DMA
> +		*dma = virt_to_bus(retval);
> +#else
> +		*dma = (dma_addr_t) ~0;
> +#endif

Err, no.  There's a perfectly good replacement.  DMA pools.  Please use
the provided infrastructure instead of inventing your own solution.

> +      create_file_error:
> +	driver->unbind(&dev->gadget);
> +
> +      device_bind_error:
> +	device_del(&dev->gadget.dev);
> +
> +      device_add_error:
> +	dev->driver = 0;
> +	dev->gadget.dev.driver = 0;

Pointers which are cleared are set to NULL not zero.  Zero is an integer.
NULL is a pointer.  Don't confuse the two.

> +	/* insist on Intel/ARM/XScale */
> +      asm("mrc%? p15, 0, %0, c0, c0":"=r"(chiprev));
> +	if ((chiprev & CP15R0_VENDOR_MASK) != CP15R0_XSCALE_VALUE) {
> +		printk(KERN_ERR "%s: not XScale!\n", driver_name);
> +		return -ENODEV;
> +	}

Please use:

	if ((processor_id & CP15R0_VENDOR_MASK) != CP15R0_XSCALE_VALUE)

it's already in a variable which is exported, so there's no point not
using it.  Alternatively, use:

	chiprev = read_cpuid(CPUID_ID);

> +#ifdef DEBUG
> +
> +static const char *state_name[] = {
> +	"EP0_IDLE",
> +	"EP0_IN_DATA_PHASE", "EP0_OUT_DATA_PHASE",
> +	"EP0_END_XFER", "EP0_STALL"
> +};
> +
> +#define DMSG(stuff...) printk(KERN_ERR "udc: " stuff)

Is pr_debug() buggy?

> +
> +#ifdef VERBOSE
> +#    define UDC_DEBUG DBG_VERBOSE
> +#else
> +#    define UDC_DEBUG DBG_NORMAL
> +#endif
> +
> +static void __attribute__ ((__unused__))
> +dump_udccr(const char *label)
> +{
> +	u32	udccr = UDCCR;
> +	DMSG("%s 0x%08x =%s%s%s%s%s%s%s%s%s%s, con=%d,inter=%d,altinter=%d\n",
> +		label, udccr,
> +		(udccr & UDCCR_OEN) ? " oen":"",
> +		(udccr & UDCCR_AALTHNP) ? " aalthnp":"",
> +		(udccr & UDCCR_AHNP) ? " rem" : "",
> +		(udccr & UDCCR_BHNP) ? " rstir" : "",
> +		(udccr & UDCCR_DWRE) ? " dwre" : "",
> +		(udccr & UDCCR_SMAC) ? " smac" : "",
> +		(udccr & UDCCR_EMCE) ? " emce" : "",
> +		(udccr & UDCCR_UDR) ? " udr" : "",
> +		(udccr & UDCCR_UDA) ? " uda" : "",
> +		(udccr & UDCCR_UDE) ? " ude" : "",
> +		(udccr & UDCCR_ACN) >> UDCCR_ACN_S,
> +		(udccr & UDCCR_AIN) >> UDCCR_AIN_S,
> +		(udccr & UDCCR_AAISN)>> UDCCR_AAISN_S );
> +}
> +
> +static void __attribute__ ((__unused__))
> +dump_udccsr0(const char *label)
> +{
> +	u32		udccsr0 = UDCCSR0;
> +
> +	DMSG("%s %s 0x%08x =%s%s%s%s%s%s%s\n",
> +		label, state_name[the_controller->ep0state], udccsr0,
> +		(udccsr0 & UDCCSR0_SA) ? " sa" : "",
> +		(udccsr0 & UDCCSR0_RNE) ? " rne" : "",
> +		(udccsr0 & UDCCSR0_FST) ? " fst" : "",
> +		(udccsr0 & UDCCSR0_SST) ? " sst" : "",
> +		(udccsr0 & UDCCSR0_DME) ? " dme" : "",
> +		(udccsr0 & UDCCSR0_IPR) ? " ipr" : "",
> +		(udccsr0 & UDCCSR0_OPC) ? " opr" : "");
> +}
> +
> +static void __attribute__ ((__unused__))
> +dump_state(struct pxa27x_udc *dev)
> +{
> +	unsigned	i;
> +
> +	DMSG("%s, udcicr %02X.%02X, udcsir %02X.%02x, udcfnr %02X\n",
> +		state_name[dev->ep0state],
> +		UDCICR1, UDCICR0, UDCISR1, UDCISR0, UDCFNR);
> +	dump_udccr("udccr");
> +
> +	if (!dev->driver) {
> +		DMSG("no gadget driver bound\n");
> +		return;
> +	} else
> +		DMSG("ep0 driver '%s'\n", dev->driver->driver.name);
> +
> +	
> +	dump_udccsr0 ("udccsr0");
> +	DMSG("ep0 IN %lu/%lu, OUT %lu/%lu\n",
> +		dev->stats.write.bytes, dev->stats.write.ops,
> +		dev->stats.read.bytes, dev->stats.read.ops);
> +
> +	for (i = 1; i < UDC_EP_NUM; i++) {
> +		if (dev->ep [i].desc == 0)
> +			continue;
> +		DMSG ("udccs%d = %02x\n", i, *dev->ep->reg_udccsr);
> +	}
> +}
> +
> +#if 0
> +static void dump_regs(u8 ep)
> +{
> +	DMSG("EP:%d UDCCSR:0x%08x UDCBCR:0x%08x\n UDCCR:0x%08x\n",
> +		ep,UDCCSN(ep), UDCBCN(ep), UDCCN(ep));
> +}
> +static void dump_req (struct pxa27x_request *req)
> +{
> +	struct usb_request *r = &req->req;
> +
> +	DMSG("%s: buf:0x%08x length:%d dma:0x%08x actual:%d\n",
> +			__FUNCTION__, (unsigned)r->buf, r->length, 
> +			r->dma,	r->actual);
> +}
> +#endif
> +
> +#else
> +
> +#define DMSG(stuff...)		do{}while(0)
> +
> +#define	dump_udccr(x)	do{}while(0)
> +#define	dump_udccsr0(x)	do{}while(0)
> +#define	dump_state(x)	do{}while(0)
> +
> +#define UDC_DEBUG ((unsigned)0)
> +
> +#endif
> +
> +#define DBG(lvl, stuff...) do{if ((lvl) <= UDC_DEBUG) DMSG(stuff);}while(0)
> +
> +#define WARN(stuff...) printk(KERN_WARNING "udc: " stuff)
> +#define INFO(stuff...) printk(KERN_INFO "udc: " stuff)

pr_info() ?

> +
> +
> +#endif /* __LINUX_USB_GADGET_PXA27X_H */
