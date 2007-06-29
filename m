Return-Path: <linux-kernel-owner+w=401wt.eu-S933746AbXF2REU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933746AbXF2REU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 13:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754364AbXF2REL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 13:04:11 -0400
Received: from straum.hexapodia.org ([64.81.70.185]:28203 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715AbXF2REJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 13:04:09 -0400
Date: Fri, 29 Jun 2007 10:04:07 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] PXA27x UDC driver.
Message-ID: <20070629170407.GC16986@hexapodia.org>
References: <20070628103619.GW13886@enneenne.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070628103619.GW13886@enneenne.com>
User-Agent: Mutt/1.4.2.2i
X-PGP-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-PGP-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for taking the lead on this!  I can't wait to have a sane PXA27x
gadget driver in mainline.

On Thu, Jun 28, 2007 at 12:36:20PM +0200, Rodolfo Giometti wrote:
> +config USB_GADGET_PXA27X
> +	boolean "PXA 27x"
> +	depends on ARCH_PXA && PXA27x
> +	help
> +	   Intel's PXA 27x series XScale processors include an integrated

XScale is a Marvell product now, not Intel.  How about

    XScale PXA 27x processors (from Marvell, formerly Intel) include ...

> +	   Say "y" to link the driver statically, or "m" to build a
> +	   dynamically linked module called "pxa2xx_udc" and force all
> +	   gadget drivers to also be dynamically linked.

Please copy the boilerplate on this:

          To compile this driver as a module, choose M here: the
          module will be called pxa27x_udc.

(Note the fixed module name, too.)

> +	if (!_ep || !ep->desc) {
> +		DMSG("%s, %s not enabled\n", __FUNCTION__,
> +		     _ep ? ep->ep.name : NULL);

I wouldn't pass NULL to a printf-format-string-using function, and ':'
would be a more traditional separator than ','.  (Many instances of the
latter.)

> +	if (dcsr & DCSR_BUSERR) {
> +		DCSR(dmach) = DCSR_BUSERR;
> +		printk(KERN_ERR " Buss Error\n");

Extra space after ", and Bus is misspelled.  This printk should include
as much information about the error as reasonable.

> +static int pxa27x_ep_fifo_status(struct usb_ep *_ep)
> +{
> +	struct pxa27x_ep *ep;
> +
> +	ep = container_of(_ep, struct pxa27x_ep, ep);

No reason not to write
	struct pxa27x_ep *ep = container_of(_ep, struct pxa27x_ep, ep);

> +		while (((*ep->reg_udccsr) & UDCCSR_BNE) != 0)
> +			(void)*ep->reg_udcdr;

That looks funky.  On x86 I think you'd want a cpu_relax() in the loop
body, but I don't know if that's necessary on ARM.  At the very least,
there's no reason to waste every other volatile read, so you should
remove the ->reg_udcdr read outside of the condition.  Instead, the
standard seems to be

		while (((*ep->reg_udccsr) & UDCCSR_BNE) != 0)
			;

> +	*ep->reg_udccsr = UDCCSR_PC | UDCCSR_FST | UDCCSR_TRN
> +	    | (ep->ep_type == USB_ENDPOINT_XFER_ISOC)
> +	    ? 0 : UDCCSR_SST;

More parentheses and/or indentation to make it clear how the ?: nests
with |.

> +#define NAME_SIZE 18

If this code isn't killed by David Brownell's comments, please either
make this a local variable or move the define to the top of the file
(and give it a name that describes what name it's the size of).

> +	DMSG("udccsr=0x%8x, udcbcr=0x%8x, udcdr=0x%8x,"
> +	     "udccr0=0x%8x\n",
> +	     (unsigned)pxa_ep->reg_udccsr,
> +	     (unsigned)pxa_ep->reg_udcbcr,
> +	     (unsigned)pxa_ep->reg_udcdr, (unsigned)pxa_ep->reg_udccr);

Print pointers using %p.

> +#if 0
> +	tmp |= (pxa_ep->interface << UDCCONR_IN_S) & UDCCONR_IN;
> +	tmp |= (pxa_ep->aisn << UDCCONR_AISN_S) & UDCCONR_AISN;
> +#else
> +	tmp |= (0 << UDCCONR_IN_S) & UDCCONR_IN;
> +	tmp |= (0 << UDCCONR_AISN_S) & UDCCONR_AISN;
> +#endif

This stuff is wierd.  It would be slightly more sane to just have the
code commented out, with a comment explaining why.

> +	name = kmalloc(NAME_SIZE, GFP_KERNEL);
> +	if (!name) {
> +		printk(KERN_ERR "%s: Error\n", __FUNCTION__);

Useless printk.  Should probably propagate ERR_PTR(-ENOMEM) back up the
call tree instead.  (Several instances.)

> +udc_proc_read(char *page, char **start, off_t off, int count,
> +	      int *eof, void *_dev)
> +{
[snip]
> +	t = scnprintf(next, size,
> +		      "uicr %02X.%02X, usir %02X.%02x, ufnr %02X\n",
> +		      UDCICR1, UDCICR0, UDCISR1, UDCISR0, UDCFNR);
> +	size -= t;
> +	next += t;

This code will get a lot simpler if you use seq_printf instead.

> +#define create_proc_files() \
> +	create_proc_read_entry(proc_node_name, 0, NULL, udc_proc_read, dev)
> +#define remove_proc_files() \
> +	remove_proc_entry(proc_node_name, NULL)
> +#else				/* !UDC_PROC_FILE */
> +#define create_proc_files() do {} while (0)
> +#define remove_proc_files() do {} while (0)
> +#endif				/* UDC_PROC_FILE */

The create_proc_files()/remove_proc_files() macros are nasty, and will
become unnecessary if you move the proc stuff to a separate file and use
Kconfig to optionally build it.

> +static DEVICE_ATTR(function, S_IRUGO, show_function, NULL);

Huh?  This isn't used AFAICS.

> +static void udc_reinit(struct pxa27x_udc *dev)
> +{
> +	u32 i;

No reason for this to be u32, use int.  (Unless there's a significant
benefit in the generated code on ARM, perhaps.)

> +	if (UDCCR & UDCCR_EMCE) {
> +		printk(KERN_ERR
> +		       ": There are error in configuration, udc disabled\n");

Add the device name or some other identifier here.  And there's probably
a missing return or goto.

> +#define CP15R0_VENDOR_MASK	0xffffe000
> +
> +#define CP15R0_XSCALE_VALUE	0x69054000	/* intel/arm/xscale */

These belong in a header file.

> +struct pxa27x_udc {
> +	struct usb_gadget			gadget;
> +	struct usb_gadget_driver		*driver;
> +
> +	enum ep0_state				ep0state;
> +	struct udc_stats			stats;
> +	unsigned				got_irq : 1,
> +						got_disc : 1,
> +						has_cfr : 1,
> +						req_pending : 1,
> +						req_std : 1,
> +						req_config : 1;
> +
> +#define start_watchdog(dev) mod_timer(&dev->timer, jiffies + (HZ/200))

This define definitely doesn't belong here, and I don't think it belongs
in this header file at all -- or if it does, it needs a less generic
name.

> +	struct timer_list			timer;
> +
> +	struct device				*dev;
> +	struct pxa2xx_udc_mach_info		*mach;
> +	u64					dma_mask;
> +	struct pxa27x_ep			ep [UDC_EP_NUM];
No space                                          ^ here.

-andy
