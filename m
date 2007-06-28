Return-Path: <linux-kernel-owner+w=401wt.eu-S1765998AbXF1VcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765998AbXF1VcQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 17:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762156AbXF1VcB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 17:32:01 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47659 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762137AbXF1Vb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 17:31:58 -0400
Date: Thu, 28 Jun 2007 14:29:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: David Brownell <david-b@pacbell.net>,
       linux-usb-devel@lists.sourceforge.net,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       Li Yang-r58472 <LeoLi@freescale.com>
Subject: Re: [PATCH] PXA27x UDC driver.
Message-Id: <20070628142949.02ca9eab.akpm@linux-foundation.org>
In-Reply-To: <20070628141205.GA13886@enneenne.com>
References: <20070628103619.GW13886@enneenne.com>
	<989B956029373F45A0B8AF0297081890D834FA@zch01exm26.fsl.freescale.net>
	<20070628141205.GA13886@enneenne.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jun 2007 16:12:07 +0200
Rodolfo Giometti <giometti@enneenne.com> wrote:

> On Thu, Jun 28, 2007 at 07:15:06PM +0800, Li Yang-r58472 wrote:
> 
> > You should probably also cc: linux-usb-devel@lists.sourceforge.net and
> > David Brownell for UDC matters.
> 
> As suggest by Leo let me propose to you my new patch for PXA27x UDC
> support.
> 
> Please, let me know what I have to do for kernel inclusion. :)
> 

Please feed it through the current version of scripts/checkpatch.pl and
think about fixing the large amount of trivia spew which ensues.

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

This looks odd.  The same driver presents itself under a different name
according to a config option?

> @@ -0,0 +1,2395 @@
> +/*
> + * linux/drivers/usb/gadget/pxa27x_udc.c
> + * Intel PXA2xx and IXP4xx on-chip full speed USB device controllers
> + *
> + * Copyright (C) 2002 Intrinsyc, Inc. (Frank Becker)
> + * Copyright (C) 2003 Robert Schwebel, Pengutronix
> + * Copyright (C) 2003 Benedikt Spranger, Pengutronix
> + * Copyright (C) 2003 David Brownell
> + * Copyright (C) 2003 Joshua Wise
> + * Copyright (C) 2004 Intel Corporation
> + * Copyright (C) 2007 Rodolfo Giometti <giometti@linux.it> 
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> + *
> + */
> +
> +#undef DEBUG

Why?  -DDEBUG is normally provided on the command line.  If the user _did_
go and set DEBUG, he presumably wants DEBUG.

> +/* #define	VERBOSE	DBG_VERBOSE */
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/ioport.h>
> +#include <linux/types.h>
> +#include <linux/version.h>
> +#include <linux/errno.h>
> +#include <linux/delay.h>
> +#include <linux/sched.h>
> +#include <linux/slab.h>
> +#include <linux/init.h>
> +#include <linux/timer.h>
> +#include <linux/list.h>
> +#include <linux/interrupt.h>
> +#include <linux/proc_fs.h>
> +#include <linux/mm.h>
> +#include <linux/device.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/platform_device.h>
> +
> +#include <asm/byteorder.h>
> +#include <asm/dma.h>
> +#include <asm/io.h>
> +#include <asm/irq.h>
> +#include <asm/system.h>
> +#include <asm/mach-types.h>
> +#include <asm/unaligned.h>
> +#include <asm/hardware.h>
> +#include <asm/arch/pxa-regs.h>
> +
> +#include <linux/usb/ch9.h>
> +#include <linux/usb_gadget.h>
> +
> +#include <asm/arch/udc.h>
> +
> +/*
> + * This driver handles the USB Device Controller (UDC) in Intel's PXA 27x
> + * series processors.  
> + * Such controller drivers work with a gadget driver.  The gadget driver
> + * returns descriptors, implements configuration and data protocols used
> + * by the host to interact with this device, and allocates endpoints to
> + * the different protocol interfaces.  The controller driver virtualizes
> + * usb hardware so that the gadget drivers will be more portable.
> + * 
> + * This UDC hardware wants to implement a bit too much USB protocol, so
> + * it constrains the sorts of USB configuration change events that work.
> + * The errata for these chips are misleading; some "fixed" bugs from
> + * pxa250 a0/a1 b0/b1/b2 sure act like they're still there.
> + */
> +
> +#define	DRIVER_VERSION	"28-Jun-2007"
> +#define	DRIVER_DESC	"PXA 27x USB Device Controller driver"
> +
> +static const char driver_name[] = "pxa27x_udc";
> +
> +static const char ep0name[] = "ep0";
> +
> +#undef	USE_DMA

So DMA is busted?

> +#undef	DISABLE_TEST_MODE

enabling DISABLE_TEST_MODE seens to enable test mode.  Confused.

> +#ifdef CONFIG_PROC_FS
> +#define	UDC_PROC_FILE
> +#endif
> +
> +#include "pxa27x_udc.h"
> +
> +#ifdef CONFIG_EMBEDDED
> +/* few strings, and little code to use them */
> +#undef	DEBUG
> +#undef	UDC_PROC_FILE
> +#endif

gag, this looks like a mess.  Thise sort of logic should be implemented in
Kconfig, not in .c.

> +#ifdef	USE_DMA
> +static int use_dma = 1;
> +module_param(use_dma, bool, 0);
> +MODULE_PARM_DESC(use_dma, "true to use dma");
> +
> +static void dma_nodesc_handler(int dmach, void *_ep);
> +static void kick_dma(struct pxa27x_ep *ep, struct pxa27x_request *req);
> +
> +#define	DMASTR " (dma support)"
> +
> +#else				/* !USE_DMA */
> +#define	DMASTR " (pio only)"
> +#endif
> +
> +#ifdef	CONFIG_USB_PXA27X_SMALL
> +#define SIZE_STR	" (small)"
> +#else
> +#define SIZE_STR	""
> +#endif
> +
> +#ifdef DISABLE_TEST_MODE
> +/* (mode == 0) == no undocumented chip tweaks
> + * (mode & 1)  == double buffer bulk IN
> + * (mode & 2)  == double buffer bulk OUT
> + * ... so mode = 3 (or 7, 15, etc) does it for both
> + */
> +static ushort fifo_mode = 0;

Unneeded initialisation (checkpatch should catch this)

Use u16, not ushort.  Or just "int".

> +module_param(fifo_mode, ushort, 0);
> +MODULE_PARM_DESC(fifo_mode, "pxa27x udc fifo mode");
> +#endif
> +
> +#define UDCISR0_IR0	 0x3
> +#define UDCISR_INT_MASK	 (UDC_INT_FIFOERROR | UDC_INT_PACKETCMP)
> +#define UDCICR_INT_MASK	 UDCISR_INT_MASK
> +
> +#define UDCCSR_MASK	(UDCCSR_FST | UDCCSR_DME)
> +/* ---------------------------------------------------------------------------
> + * 	endpoint related parts of the api to the usb controller hardware,
> + *	used by gadget driver; and the inner talker-to-hardware core.
> + * ---------------------------------------------------------------------------
> + */

kernel comments normally look like

/*
 * endpoint related parts of the api to the usb controller hardware,
 * used by gadget driver; and the inner talker-to-hardware core.
 *
 */

> +
> +static void pxa27x_ep_fifo_flush(struct usb_ep *ep);
> +static void nuke(struct pxa27x_ep *, int status);
> +
> +/* one GPIO should control a D+ pullup, so host sees this device (or not) */
> +static void pullup_off(void)
> +{
> +	struct pxa2xx_udc_mach_info *mach = the_controller->mach;
> +
> +	if (mach->gpio_pullup)
> +		udc_gpio_set(mach->gpio_pullup, 0);
> +	else if (mach->udc_command)
> +		mach->udc_command(PXA2XX_UDC_CMD_DISCONNECT);
> +}
> +
> +static void pullup_on(void)
> +{
> +	struct pxa2xx_udc_mach_info *mach = the_controller->mach;
> +
> +	if (mach->gpio_pullup)
> +		udc_gpio_set(mach->gpio_pullup, 1);
> +	else if (mach->udc_command)
> +		mach->udc_command(PXA2XX_UDC_CMD_CONNECT);
> +}
> +
> +static void pio_irq_enable(int ep_num)
> +{
> +	if (ep_num < 16)
> +		UDCICR0 |= 3 << (ep_num * 2);
> +	else {
> +		ep_num -= 16;
> +		UDCICR1 |= 3 << (ep_num * 2);
> +	}
> +}

We'd normally put braces around the "if" clause if there are braces around
the "else" clause.  What you have there looks a bit funny.

> +static void pio_irq_disable(int ep_num)
> +{
> +	ep_num &= 0xf;
> +	if (ep_num < 16)
> +		UDCICR0 &= ~(3 << (ep_num * 2));
> +	else {
> +		ep_num -= 16;
> +		UDCICR1 &= ~(3 << (ep_num * 2));
> +	}
> +}

Ditto

> +	if (ep->ep_type != USB_ENDPOINT_XFER_BULK
> +	    && desc->bmAttributes != USB_ENDPOINT_XFER_INT) {

We'd normally lay this out as

	if (ep->ep_type != USB_ENDPOINT_XFER_BULK &&
	    desc->bmAttributes != USB_ENDPOINT_XFER_INT) {

but what you have there is pretty common.

> +		DMSG("%s, %s type mismatch\n", __FUNCTION__, _ep->name);
> +		return -EINVAL;
> +	}
> +
> +	/* hardware _could_ do smaller, but driver doesn't */
> +	if ((desc->bmAttributes == USB_ENDPOINT_XFER_BULK
> +	     && le16_to_cpu(desc->wMaxPacketSize)
> +	     != BULK_FIFO_SIZE)
> +	    || !desc->wMaxPacketSize) {

that expression is quite hard to read.

	/* hardware _could_ do smaller, but driver doesn't */
	if ((desc->bmAttributes == USB_ENDPOINT_XFER_BULK &&
		le16_to_cpu(desc->wMaxPacketSize) != BULK_FIFO_SIZE) ||
	    !desc->wMaxPacketSize) {

or something like that?

> +		DMSG("%s, bad %s maxpacket\n", __FUNCTION__, _ep->name);
> +		return -ERANGE;
> +	}
> +
> +	dev = ep->dev;
> +	if (!dev->driver || dev->gadget.speed == USB_SPEED_UNKNOWN) {
> +		DMSG("%s, bogus device state\n", __FUNCTION__);
> +		return -ESHUTDOWN;
> +	}
> +
> +	ep->desc = desc;
> +	ep->dma = -1;
> +	ep->stopped = 0;
> +	ep->pio_irqs = ep->dma_irqs = 0;
> +	ep->ep.maxpacket = le16_to_cpu(desc->wMaxPacketSize);
> +
> +	/* flush fifo (mostly for OUT buffers) */
> +	pxa27x_ep_fifo_flush(_ep);
> +
> +	/* ... reset halt state too, if we could ... */
> +
> +#ifdef USE_DMA
> +	/* for (some) bulk and ISO endpoints, try to get a DMA channel and
> +	 * bind it to the endpoint.  otherwise use PIO. 
> +	 */
> +	DMSG("%s: called attributes=%d\n", __FUNCTION__, ep->ep_type);
> +	switch (ep->ep_type) {
> +	case USB_ENDPOINT_XFER_ISOC:
> +		if (le16_to_cpu(desc->wMaxPacketSize) % 32)
> +			break;
> +		/* fall through */
> +	case USB_ENDPOINT_XFER_BULK:
> +		if (!use_dma || !ep->reg_drcmr)
> +			break;
> +		ep->dma = pxa_request_dma((char *)_ep->name,
> +				  (le16_to_cpu(desc->wMaxPacketSize) > 64)
> +					  ? DMA_PRIO_MEDIUM	/* some iso */
> +					  : DMA_PRIO_LOW,
> +					  dma_nodesc_handler, ep);
> +		if (ep->dma >= 0) {
> +			*ep->reg_drcmr = DRCMR_MAPVLD | ep->dma;
> +			DMSG("%s using dma%d\n", _ep->name, ep->dma);
> +		}
> +	default:
> +		break;
> +	}
> +#endif
> +	DBG(DBG_VERBOSE, "enabled %s\n", _ep->name);
> +	return 0;
> +}
> +
> +/*-------------------------------------------------------------------------*/
> +
> +/* for the pxa27x, these can just wrap kmalloc/kfree.  gadget drivers
> + * must still pass correctly initialized endpoints, since other controller
> + * drivers may care about how it's currently set up (dma issues etc).
> + */
> +
> +/*
> + * 	pxa27x_ep_alloc_request - allocate a request data structure
> + */
> +static struct usb_request *pxa27x_ep_alloc_request(struct usb_ep *_ep,
> +						   unsigned int gfp_flags)
> +{
> +	struct pxa27x_request *req;
> +
> +	req = kmalloc(sizeof *req, gfp_flags);
> +	if (!req)
> +		return 0;
> +
> +	memset(req, 0, sizeof *req);

use kzalloc()

> +	INIT_LIST_HEAD(&req->queue);
> +	return &req->req;
> +}
> +
>
>
> +
> +static int
> +write_packet(volatile u32 * uddr, struct pxa27x_request *req, unsigned max)

Please review Documentation/volatile-considered-harmful.txt

> +{
> +	u32 *buf;
> +	int length, count, remain;
> +
> +	buf = (u32 *) (req->req.buf + req->req.actual);
> +	prefetch(buf);
> +
> +	/* how big will this packet be? */
> +	length = min(req->req.length - req->req.actual, max);
> +	req->req.actual += length;
> +
> +	remain = length & 0x3;
> +	count = length & ~(0x3);
> +
> +	while (likely(count)) {
> +		*uddr = *buf++;
> +		count -= 4;
> +	}
> +
> +	if (remain) {
> +		volatile u8 *reg = (u8 *) uddr;
> +		char *rd = (u8 *) buf;
> +
> +		while (remain--) {
> +			*reg = *rd++;
> +		}
> +	}
> +
> +	return length;
> +}
> +
>
> ...
>
> +
> +static void dma_nodesc_handler(int dmach, void *_ep, struct pt_regs *r)
> +{
> +	struct pxa27x_ep *ep = _ep;
> +	struct pxa27x_request *req, *req_next;
> +	u32 dcsr, tmp, completed;
> +
> +	local_irq_disable();

this looks fishy.  local_irq_disable() only provides cpu-local protection. 
Is this code SMP-correct?  What's happening here?  A comment is needed
explaining this, at least.

> +static inline void validate_fifo_size(struct pxa27x_ep *pxa_ep, u8 bmAttributes)
> +{
> +	switch (bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) {
> +	case USB_ENDPOINT_XFER_CONTROL:
> +		pxa_ep->fifo_size = EP0_FIFO_SIZE;
> +		break;
> +	case USB_ENDPOINT_XFER_ISOC:
> +		pxa_ep->fifo_size = ISO_FIFO_SIZE;
> +		break;
> +	case USB_ENDPOINT_XFER_BULK:
> +		pxa_ep->fifo_size = BULK_FIFO_SIZE;
> +		break;
> +	case USB_ENDPOINT_XFER_INT:
> +		pxa_ep->fifo_size = INT_FIFO_SIZE;
> +		break;
> +	default:
> +		break;
> +	}
> +}

There's no point in inlining this.  With only one callsite the compiler
will inline it anyway.  If we grow a second callsite, this fucntion is too
large to inline.

This is general truth, so please generally avoid inline.

> +	ep->maxpacket = min((ushort) pxa_ep->fifo_size, desc->wMaxPacketSize);

Use min_t, not an open-coded cast.

Use u16.

> +#ifdef UDC_PROC_FILE
> +
> +static const char proc_node_name[] = "driver/udc";

/proc is for process-related things.  Driver-related things go in /sys

> +
> +#define create_proc_files() \
> +	create_proc_read_entry(proc_node_name, 0, NULL, udc_proc_read, dev)
> +#define remove_proc_files() \
> +	remove_proc_entry(proc_node_name, NULL)
> +
> +#else				/* !UDC_PROC_FILE */
> +#define create_proc_files() do {} while (0)
> +#define remove_proc_files() do {} while (0)

Please only use macros when you *must* use macros.  When for some reason
you cannot use C.  This is not such a case.  IOW, convert to static
inlines.

> +#endif				/* UDC_PROC_FILE */
> +
> +	DMSG("registered gadget driver '%s'\n", driver->driver.name);
> +	udc_enable(dev);
> +	dump_state(dev);
> +
> +	return 0;
> +
> +      create_file_error:
> +	driver->unbind(&dev->gadget);
> +
> +      device_bind_error:
> +	device_del(&dev->gadget.dev);
> +
> +      device_add_error:
> +	dev->driver = 0;
> +	dev->gadget.dev.driver = 0;
> +
> +	return retval;
> +}

We normally indent labels with zero or one spaces, not six.

> +}
> +
> +EXPORT_SYMBOL(usb_gadget_unregister_driver);

We normally leave zero blank lines between the } and the EXPORT_SYMBOL
(checkpatch should report this)

> +#ifndef	enable_disconnect_irq
> +#define	enable_disconnect_irq()		do {} while (0)
> +#define	disable_disconnect_irq()	do {} while (0)
> +#endif

hm, OK, I guess this is somewhere where a macro is appropriate.

> +/*-------------------------------------------------------------------------*/
> +
> +static inline void clear_ep_state(struct pxa27x_udc *dev)
> +{
> +	unsigned i;
> +
> +	/* hardware SET_{CONFIGURATION,INTERFACE} automagic resets endpoint
> +	 * fifos, and pending transactions mustn't be continued in any case.
> +	 */
> +	for (i = 1; i < UDC_EP_NUM; i++)
> +		nuke(&dev->ep[i], -ECONNABORTED);
> +}

Probably too big to inline.

Has no callers.

> +			if (i < 0) {
> +				/* hardware automagic preventing STALL... */
> +				if (dev->req_config) {
> +					/* hardware sometimes neglects to tell
> +					 * tell us about config change events,
> +					 * so later ones may fail...
> +					 */
> +					WARN("config change %02x fail %d?\n",
> +					     u.r.bRequest, i);
> +					return;
> +					/* TODO experiment:  if has_cfr,
> +					 * hardware didn't ACK; maybe we
> +					 * could actually STALL!
> +					 */
> +				}
> +				DBG(DBG_VERBOSE, "protocol STALL, "
> +				    "%02x err %d\n", UDCCSR0, i);
> +			      stall:

what's that label doing all the way over there.  It makes it rather hard to
find.

> +				/* the watchdog timer helps deal with cases
> +				 * where udc seems to clear FST wrongly, and
> +				 * then NAKs instead of STALLing.
> +				 */
> +				ep0start(dev, UDCCSR0_FST | UDCCSR0_FTF,
> +					 "stall");
> +				start_watchdog(dev);
> +				dev->ep0state = EP0_STALL;
> +				LED_EP0_OFF;
> +
> +				/* deferred i/o == no response yet */
> +			} else if (dev->req_pending) {
> +				if (likely(dev->ep0state == EP0_IN_DATA_PHASE
> +					   || dev->req_std || u.r.wLength))
> +					ep0start(dev, 0, "defer");
> +				else
> +					ep0start(dev, UDCCSR0_IPR, "defer/IPR");
> +			}
> +
> +			/* expect at least one data or status stage irq */
> +			return;

Burying returns deep inside large functions is unpopular: it can easily
lead to resource leaks and locking errors as the code evolves.  It makes
review and auditing harder.

> +		} else {
> +			/* some random early IRQ:
> +			 * - we acked FST
> +			 * - IPR cleared
> +			 * - OPC got set, without SA (likely status stage)
> +			 */
> +			UDCCSR0 = udccsr0 & (UDCCSR0_SA | UDCCSR0_OPC);
> +		}
> +		break;
> +	case EP0_IN_DATA_PHASE:	/* GET_DESCRIPTOR etc */
> +		if (udccsr0 & UDCCSR0_OPC) {
> +			UDCCSR0 = UDCCSR0_OPC | UDCCSR0_FTF;
> +			DBG(DBG_VERBOSE, "ep0in premature status\n");
> +			if (req)
> +				done(ep, req, 0);
> +			ep0_idle(dev);
> +		} else {	/* irq was IPR clearing */
> +
> +			if (req) {
> +				/* this IN packet might finish the request */
> +				(void)write_ep0_fifo(ep, req);
> +			}	/* else IN token before response was written */
> +		}
> +		break;
> +	case EP0_OUT_DATA_PHASE:	/* SET_DESCRIPTOR etc */
> +		if (udccsr0 & UDCCSR0_OPC) {
> +			if (req) {
> +				/* this OUT packet might finish the request */
> +				if (read_ep0_fifo(ep, req))
> +					done(ep, req, 0);
> +				/* else more OUT packets expected */
> +			}	/* else OUT token before read was issued */
> +		} else {	/* irq was IPR clearing */
> +
> +			DBG(DBG_VERBOSE, "ep0out premature status\n");
> +			if (req)
> +				done(ep, req, 0);
> +			ep0_idle(dev);
> +		}
> +		break;
> +	case EP0_STALL:
> +		UDCCSR0 = UDCCSR0_FST;
> +		break;
> +	}
> +	UDCISR0 = UDCISR_INT(0, UDCISR_INT_MASK);
> +}
> +
>
> ...
>
> +static void udc_init_ep(struct pxa27x_udc *dev)
> +{
> +	int i;
> +
> +	INIT_LIST_HEAD(&dev->gadget.ep_list);
> +	INIT_LIST_HEAD(&dev->gadget.ep0->ep_list);
> +
> +	for (i = 0; i < UDC_EP_NUM; i++) {
> +		struct pxa27x_ep *ep = &dev->ep[i];
> +
> +		ep->dma = -1;
> +		if (i != 0) {
> +			memset(ep, 0, sizeof(*ep));
> +		}

unneeded braces

> +		INIT_LIST_HEAD(&ep->queue);
> +	}
> +}
> +
> +/*-------------------------------------------------------------------------*/
> +
> +static void nop_release(struct device *dev)
> +{
> +	DMSG("%s %s\n", __FUNCTION__, dev->bus_id);
> +}
> +
> +/* this uses load-time allocation and initialization (instead of
> + * doing it at run-time) to save code, eliminate fault paths, and
> + * be more obviously correct.
> + */
> +static struct pxa27x_udc memory = {
> +	.gadget = {
> +		   .ops = &pxa27x_udc_ops,
> +		   .ep0 = &memory.ep[0].ep,
> +		   .name = driver_name,
> +		   .dev = {
> +			   .bus_id = "gadget",
> +			   .release = nop_release,
> +			   },
> +		   },
> +
> +	/* control endpoint */
> +	.ep[0] = {
> +		  .ep = {
> +			 .name = ep0name,
> +			 .ops = &pxa27x_ep_ops,
> +			 .maxpacket = EP0_FIFO_SIZE,
> +			 },
> +		  .dev = &memory,
> +		  .reg_udccsr = &UDCCSR0,
> +		  .reg_udcdr = &UDCDR0,

whitespace broke

> +		  }
> +};
> +
> +#define CP15R0_VENDOR_MASK	0xffffe000
> +
> +#define CP15R0_XSCALE_VALUE	0x69054000	/* intel/arm/xscale */
> +
> +/*
> + * 	probe - binds to the platform device
> + */
> +static int __init pxa27x_udc_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct pxa27x_udc *udc = &memory;
> +	int irq, retval;
> +	u32 chiprev;
> +
> +	/* insist on Intel/ARM/XScale */
> +      asm("mrc%? p15, 0, %0, c0, c0":"=r"(chiprev));

whitespace

> +	if ((chiprev & CP15R0_VENDOR_MASK) != CP15R0_XSCALE_VALUE) {
> +		printk(KERN_ERR "%s: not XScale!\n", driver_name);
> +		return -ENODEV;
> +	}
> +
> +	irq = platform_get_irq(pdev, 0);
> +	if (irq < 0)
> +		return -ENODEV;
> +	pr_debug("%s: IRQ %d\n", driver_name, irq);
> +
> +	/* other non-static parts of init */
> +	udc->dev = dev;
> +	udc->mach = dev->platform_data;
> +
> +	/* Disable irq, erase old events and disable the pull up on the bus */
> +	UDCICR0 = 0x00000000;
> +	UDCICR1 = 0x00000000;
> +	UDCISR0 = 0xffffffff;
> +	UDCISR1 = 0xffffffff;
> +	if (udc->mach->gpio_pullup)
> +		udc_gpio_init_pullup(udc->mach->gpio_pullup);
> +
> +	init_timer(&udc->timer);
> +	udc->timer.function = udc_watchdog;
> +	udc->timer.data = (unsigned long)udc;
> +
> +	device_initialize(&udc->gadget.dev);
> +	udc->gadget.dev.parent = dev;
> +	udc->gadget.dev.dma_mask = dev->dma_mask;
> +
> +	the_controller = udc;
> +	dev_set_drvdata(dev, udc);
> +
> +	udc_disable(udc);
> +	udc_init_ep(udc);
> +	udc_reinit(udc);
> +
> +	/* irq setup after old hardware state is cleaned up */
> +	retval = request_irq(irq, pxa27x_udc_irq, 0, driver_name, udc);
> +	if (retval != 0) {
> +		printk(KERN_ERR "%s: can't get irq %i, err %d\n",
> +		       driver_name, irq, retval);
> +		return -EBUSY;
> +	}
> +	udc->got_irq = 1;
> +
> +	create_proc_files();
> +
> +	return 0;
> +}
> +
>
> ...
>
> +	/* UDCCSR = UDC Control/Status Register for this EP
> +	 * UBCR = UDC Byte Count Remaining (contents of OUT fifo)
> +	 * UDCDR = UDC Endpoint Data Register (the fifo)
> +	 * UDCCR = UDC Endpoint Configuration Registers
> +	 * DRCM = DMA Request Channel Map
> +	 */
> +	volatile u32				*reg_udccsr;
> +	volatile u32				*reg_udcbcr;
> +	volatile u32				*reg_udcdr;
> +	volatile u32				*reg_udccr;

more volatiles

> +#ifdef USE_DMA
> +	volatile u32				*reg_drcmr;
> +#define	drcmr(n)  .reg_drcmr = & DRCMR ## n ,
> +#else
> +#define	drcmr(n)  
> +#endif
> +
> +#ifdef CONFIG_PM
> +	unsigned				udccsr_value;
> +	unsigned				udccr_value;
> +#endif
> +};
> +
>
> ...
>
> +
> +#define EP0_FIFO_SIZE	((unsigned)16)
> +#define BULK_FIFO_SIZE	((unsigned)64)
> +#define ISO_FIFO_SIZE	((unsigned)256)
> +#define INT_FIFO_SIZE	((unsigned)8)

#define INT_FIFO_SIZE	8U

would be nicer.

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

write it in C or, better, just open-code it at the callsite.

> +	struct timer_list			timer;
> +
> +	struct device				*dev;
> +	struct pxa2xx_udc_mach_info		*mach;
> +	u64					dma_mask;
> +	struct pxa27x_ep			ep [UDC_EP_NUM];
> +
> +	unsigned				configuration, 
> +						interface, 
> +						alternate;
> +#ifdef CONFIG_PM
> +	unsigned				udccsr0;
> +#endif
> +};
>
> ...
>
> +#define HEX_DISPLAY2(n)	do { \
> +	if (machine_is_mainstone()) \
> +		{ MST_LEDDAT2 = (n); } \
> +	} while(0)

See, this references "n"

> +
> +/* LEDs are only for debug */
> +#ifndef HEX_DISPLAY
> +#define HEX_DISPLAY(n)		do {} while(0)
> +#endif

but this doesn't.  So we risk getting unused-var warnings in callers
depending upon config options.  Writing this in C rather than cpp (the
general rule) will fix this, as well as lots of other stuff.

HEX_DISPLAY2 gets different treatment from HEX_DISPLAY here.

> +#ifndef LED_CONNECTED_ON
> +#define LED_CONNECTED_ON	do {} while(0)
> +#define LED_CONNECTED_OFF	do {} while(0)
> +#endif
> +#ifndef LED_EP0_ON
> +#define LED_EP0_ON		do {} while (0)
> +#define LED_EP0_OFF		do {} while (0)
> +#endif
> +
> +static struct pxa27x_udc *the_controller;

eep, you can't do that!  We'll get separate instances of the_controller in
each C file which includes this header.

> +/*-------------------------------------------------------------------------*/
> +
> +/*
> + * Debugging support vanishes in non-debug builds.  DBG_NORMAL should be
> + * mostly silent during normal use/testing, with no timing side-effects.
> + */
> +#define DBG_NORMAL	1	/* error paths, device state transitions */
> +#define DBG_VERBOSE	2	/* add some success path trace info */
> +#define DBG_NOISY	3	/* ... even more: request level */
> +#define DBG_VERY_NOISY	4	/* ... even more: packet level */
> +
> +#ifdef DEBUG
> +
> +static const char *state_name[] = {
> +	"EP0_IDLE",
> +	"EP0_IN_DATA_PHASE", "EP0_OUT_DATA_PHASE",
> +	"EP0_END_XFER", "EP0_STALL"
> +};
> +
> +#define DMSG(stuff...) printk(KERN_ERR "udc: " stuff)
> +
> +#ifdef VERBOSE
> +#    define UDC_DEBUG DBG_VERBOSE
> +#else
> +#    define UDC_DEBUG DBG_NORMAL
> +#endif
> +
> +static void __attribute__ ((__unused__))

Use __maybe_unused

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

ditto

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

ditto

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
>
> ..
> 
> +
> +#define WARN(stuff...) printk(KERN_WARNING "udc: " stuff)
> +#define INFO(stuff...) printk(KERN_INFO "udc: " stuff)

hrm.  Why does every driver in the tree need to invent its own boilerplate
infrastructure?

can we use dev_warn() here or something?


