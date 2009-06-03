Return-Path: <linux-kernel-owner+w=401wt.eu-S1758260AbZFCOYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758260AbZFCOYl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 10:24:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753407AbZFCOYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 10:24:34 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:33950 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbZFCOYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 10:24:33 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18982.34690.977909.654562@stoffel.org>
Date: Wed, 3 Jun 2009 10:24:02 -0400
From: "John Stoffel" <john@stoffel.org>
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: David <david@unsolicited.net>, "John Stoffel" <john@stoffel.org>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       <thomas@winischhofer.net>
Subject: Re: Patch to fix usbmon crash on Opteron
In-Reply-To: <20090602210932.b74fff08.zaitcev@redhat.com>
References: <20090602210932.b74fff08.zaitcev@redhat.com>
X-Mailer: VM 8.0.9 under Emacs 22.3.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Pete> Here's my proposal: forget the clever-by-half tricks and simply
Pete> use transfer_buffer. This should not only fix Opteron, but also
Pete> future IOMMUs that Intel and AMD promise. It may also make
Pete> usbmon useable on PPC at last.

My crash was seen on an AMD Athlon X2 5200+ processor, where tcpdump
would just completely hand the system.  I'll apply this patch and see
if I can replicate the error.

Pete> I think downsides are negligible. The ones I see are:
Pete>  - A driver may pass an address of one buffer down as transfer_buffer,
Pete>    and entirely different entity mapped for DMA, resulting in misleading
Pete>    output of usbmon.
Pete>  - Out of tree drivers may crash usbmon if they store garbage in
Pete>    transfer_buffer. I went over the tree with a comb and fixed obvious
Pete>    bugs, and clarified the documentation in comments.
Pete>  - Drivers that use get_user_pages will not be possible to monitor
Pete>  - Similar deal is with usb_storage transferring from highmem, but
Pete>    it works fine on 64-bit systems, so I think it's not a concern.

Pete> I'm adding a sign-off line in case, but in general this is a patch
Pete> for testing. In particular, sisusb is a concern.

Pete> David & John, I am quite certain that your Opterons will not
Pete> crash now, but please give it a try, and also you can use this
Pete> code to produce usbmon traces you needed for debugging of other
Pete> things.

Pete> Signed-off-by: Pete Zaitcev <zaitcev@redhat.com>

Pete> diff --git a/drivers/staging/rspiusb/rspiusb.c b/drivers/staging/rspiusb/rspiusb.c
Pete> index ecaffb5..fe97451 100644
Pete> --- a/drivers/staging/rspiusb/rspiusb.c
Pete> +++ b/drivers/staging/rspiusb/rspiusb.c
Pete> @@ -432,8 +432,7 @@ static void piusb_write_bulk_callback(struct urb *urb)
Pete>  			__func__, status);
 
pdx-> pendingWrite = 0;
Pete> -	usb_buffer_free(urb->dev, urb->transfer_buffer_length,
Pete> -			urb->transfer_buffer, urb->transfer_dma);
Pete> +	kfree(urb->transfer_buffer);
Pete>  }
 
Pete>  int piusb_output(struct ioctl_struct * io, unsigned char *uBuf, int len,
Pete> @@ -445,9 +444,7 @@ int piusb_output(struct ioctl_struct * io, unsigned char *uBuf, int len,
 
Pete>  	urb = usb_alloc_urb(0, GFP_KERNEL);
Pete>  	if (urb != NULL) {
Pete> -		kbuf =
Pete> -		    usb_buffer_alloc(pdx->udev, len, GFP_KERNEL,
Pete> -				     &urb->transfer_dma);
Pete> +		kbuf = kmalloc(len, GFP_KERNEL);
Pete>  		if (!kbuf) {
Pete>  			info("buffer_alloc failed\n");
Pete>  			return -ENOMEM;
Pete> @@ -455,7 +452,6 @@ int piusb_output(struct ioctl_struct * io, unsigned char *uBuf, int len,
Pete>  		memcpy(kbuf, uBuf, len);
Pete>  		usb_fill_bulk_urb(urb, pdx->udev, pdx->hEP[io->endpoint], kbuf,
Pete>  				  len, piusb_write_bulk_callback, pdx);
Pete> -		urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
Pete>  		err = usb_submit_urb(urb, GFP_KERNEL);
Pete>  		if (err) {
Pete>  			dev_err(&pdx->udev->dev,
Pete> @@ -617,7 +613,7 @@ static int MapUserBuffer(struct ioctl_struct *io, struct device_extension *pdx)
Pete>  	numPagesRequired =
Pete>  	    ((uaddr & ~PAGE_MASK) + count + ~PAGE_MASK) >> PAGE_SHIFT;
Pete>  	dbg("Number of pages needed = %d", numPagesRequired);
Pete> -	maplist_p = vmalloc(numPagesRequired * sizeof(struct page));	//, GFP_ATOMIC);
Pete> +	maplist_p = vmalloc(numPagesRequired * sizeof(struct page *));	//, GFP_ATOMIC);
Pete>  	if (!maplist_p) {
Pete>  		dbg("Can't Allocate Memory for maplist_p");
Pete>  		return -ENOMEM;
Pete> @@ -681,9 +677,7 @@ static int MapUserBuffer(struct ioctl_struct *io, struct device_extension *pdx)
Pete>  		usb_fill_bulk_urb(pdx->PixelUrb[frameInfo][i],
pdx-> udev,
Pete>  				  epAddr,
Pete> -				  (dma_addr_t *) sg_dma_address(&pdx->
Pete> -								sgl[frameInfo]
Pete> -								[i]),
Pete> +				  NULL, // non-DMA HC? buy a better hardware
Pete>  				  sg_dma_len(&pdx->sgl[frameInfo][i]),
Pete>  				  piusb_readPIXEL_callback, (void *)pdx);
pdx-> PixelUrb[frameInfo][i]->transfer_dma =
Pete> diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
Pete> index be86ae3..8fb176f 100644
Pete> --- a/drivers/usb/core/hub.c
Pete> +++ b/drivers/usb/core/hub.c
Pete> @@ -1070,7 +1070,7 @@ static int hub_configure(struct usb_hub *hub,
Pete>  		goto fail;
Pete>  	}
 
Pete> -	usb_fill_int_urb(hub->urb, hdev, pipe, *hub->buffer, maxp, hub_irq,
Pete> +	usb_fill_int_urb(hub->urb, hdev, pipe, hub->buffer, maxp, hub_irq,
Pete>  		hub, endpoint->bInterval);
hub-> urb->transfer_dma = hub->buffer_dma;
hub-> urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
Pete> diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
Pete> index b626283..f06d095 100644
Pete> --- a/drivers/usb/core/message.c
Pete> +++ b/drivers/usb/core/message.c
Pete> @@ -421,30 +421,18 @@ int usb_sg_init(struct usb_sg_request *io, struct usb_device *dev,
Pete>  		/*
Pete>  		 * Some systems need to revert to PIO when DMA is temporarily
Pete>  		 * unavailable.  For their sakes, both transfer_buffer and
Pete> -		 * transfer_dma are set when possible.  However this can only
Pete> -		 * work on systems without:
Pete> -		 *
Pete> -		 *  - HIGHMEM, since DMA buffers located in high memory are
Pete> -		 *    not directly addressable by the CPU for PIO;
Pete> -		 *
Pete> -		 *  - IOMMU, since dma_map_sg() is allowed to use an IOMMU to
Pete> -		 *    make virtually discontiguous buffers be "dma-contiguous"
Pete> -		 *    so that PIO and DMA need diferent numbers of URBs.
Pete> -		 *
Pete> -		 * So when HIGHMEM or IOMMU are in use, transfer_buffer is NULL
Pete> -		 * to prevent stale pointers and to help spot bugs.
Pete> +		 * transfer_dma are set when possible.
Pete>  		 */
Pete> +		if (PageHighMem(sg_page(sg))) {
Pete> +			io->urbs[i]->transfer_buffer = NULL;
Pete> +		} else {
Pete> +			io->urbs[i]->transfer_buffer = sg_virt(sg);
Pete> +		}
Pete>  		if (dma) {
io-> urbs[i]->transfer_dma = sg_dma_address(sg);
Pete>  			len = sg_dma_len(sg);
Pete> -#if defined(CONFIG_HIGHMEM) || defined(CONFIG_GART_IOMMU)
Pete> -			io->urbs[i]->transfer_buffer = NULL;
Pete> -#else
Pete> -			io->urbs[i]->transfer_buffer = sg_virt(sg);
Pete> -#endif
Pete>  		} else {
Pete>  			/* hc may use _only_ transfer_buffer */
Pete> -			io->urbs[i]->transfer_buffer = sg_virt(sg);
Pete>  			len = sg->length;
Pete>  		}
 
Pete> diff --git a/drivers/usb/misc/sisusbvga/sisusb.c b/drivers/usb/misc/sisusbvga/sisusb.c
Pete> index b4ec716..0025847 100644
Pete> --- a/drivers/usb/misc/sisusbvga/sisusb.c
Pete> +++ b/drivers/usb/misc/sisusbvga/sisusb.c
Pete> @@ -79,14 +79,12 @@ sisusb_free_buffers(struct sisusb_usb_data *sisusb)
 
Pete>  	for (i = 0; i < NUMOBUFS; i++) {
Pete>  		if (sisusb->obuf[i]) {
Pete> -			usb_buffer_free(sisusb->sisusb_dev, sisusb->obufsize,
Pete> -				sisusb->obuf[i], sisusb->transfer_dma_out[i]);
Pete> +			kfree(sisusb->obuf[i]);
sisusb-> obuf[i] = NULL;
Pete>  		}
Pete>  	}
Pete>  	if (sisusb->ibuf) {
Pete> -		usb_buffer_free(sisusb->sisusb_dev, sisusb->ibufsize,
Pete> -			sisusb->ibuf, sisusb->transfer_dma_in);
Pete> +		kfree(sisusb->ibuf);
sisusb-> ibuf = NULL;
Pete>  	}
Pete>  }
Pete> @@ -230,8 +228,7 @@ sisusb_bulk_completeout(struct urb *urb)
 
Pete>  static int
Pete>  sisusb_bulkout_msg(struct sisusb_usb_data *sisusb, int index, unsigned int pipe, void *data,
Pete> -		int len, int *actual_length, int timeout, unsigned int tflags,
Pete> -		dma_addr_t transfer_dma)
Pete> +		int len, int *actual_length, int timeout, unsigned int tflags)
Pete>  {
Pete>  	struct urb *urb = sisusb->sisurbout[index];
Pete>  	int retval, byteswritten = 0;
Pete> @@ -245,9 +242,6 @@ sisusb_bulkout_msg(struct sisusb_usb_data *sisusb, int index, unsigned int pipe,
urb-> transfer_flags |= tflags;
urb-> actual_length = 0;
 
Pete> -	if ((urb->transfer_dma = transfer_dma))
Pete> -		urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
Pete> -
Pete>  	/* Set up context */
sisusb-> urbout_context[index].actual_length = (timeout) ?
Pete>  						NULL : actual_length;
Pete> @@ -297,8 +291,8 @@ sisusb_bulk_completein(struct urb *urb)
Pete>  }
 
Pete>  static int
Pete> -sisusb_bulkin_msg(struct sisusb_usb_data *sisusb, unsigned int pipe, void *data, int len,
Pete> -		int *actual_length, int timeout, unsigned int tflags, dma_addr_t transfer_dma)
Pete> +sisusb_bulkin_msg(struct sisusb_usb_data *sisusb, unsigned int pipe, void *data,
Pete> +	int len, int *actual_length, int timeout, unsigned int tflags)
Pete>  {
Pete>  	struct urb *urb = sisusb->sisurbin;
Pete>  	int retval, readbytes = 0;
Pete> @@ -311,9 +305,6 @@ sisusb_bulkin_msg(struct sisusb_usb_data *sisusb, unsigned int pipe, void *data,
urb-> transfer_flags |= tflags;
urb-> actual_length = 0;
 
Pete> -	if ((urb->transfer_dma = transfer_dma))
Pete> -		urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
Pete> -
sisusb-> completein = 0;
Pete>  	retval = usb_submit_urb(urb, GFP_ATOMIC);
Pete>  	if (retval == 0) {
Pete> @@ -422,8 +413,7 @@ static int sisusb_send_bulk_msg(struct sisusb_usb_data *sisusb, int ep, int len,
Pete>  						thispass,
Pete>  						&transferred_len,
Pete>  						async ? 0 : 5 * HZ,
Pete> -						tflags,
Pete> -						sisusb->transfer_dma_out[index]);
Pete> +						tflags);
 
Pete>  			if (result == -ETIMEDOUT) {
 
Pete> @@ -432,29 +422,16 @@ static int sisusb_send_bulk_msg(struct sisusb_usb_data *sisusb, int ep, int len,
Pete>  					return -ETIME;
 
Pete>  				continue;
Pete> +			}
 
Pete> -			} else if ((result == 0) && !async && transferred_len) {
Pete> +			if ((result == 0) && !async && transferred_len) {
 
Pete>  				thispass -= transferred_len;
Pete> -				if (thispass) {
Pete> -					if (sisusb->transfer_dma_out) {
Pete> -						/* If DMA, copy remaining
Pete> -						 * to beginning of buffer
Pete> -						 */
Pete> -						memcpy(buffer,
Pete> -						       buffer + transferred_len,
Pete> -						       thispass);
Pete> -					} else {
Pete> -						/* If not DMA, simply increase
Pete> -						 * the pointer
Pete> -						 */
Pete> -						buffer += transferred_len;
Pete> -					}
Pete> -				}
Pete> +				buffer += transferred_len;
 
Pete>  			} else
Pete>  				break;
Pete> -		};
Pete> +		}
 
Pete>  		if (result)
Pete>  			return result;
Pete> @@ -530,8 +507,7 @@ static int sisusb_recv_bulk_msg(struct sisusb_usb_data *sisusb, int ep, int len,
Pete>  					   thispass,
Pete>  					   &transferred_len,
Pete>  					   5 * HZ,
Pete> -					   tflags,
Pete> -					   sisusb->transfer_dma_in);
Pete> +					   tflags);
 
Pete>  		if (transferred_len)
Pete>  			thispass = transferred_len;
Pete> @@ -3132,8 +3108,7 @@ static int sisusb_probe(struct usb_interface *intf,
 
Pete>  	/* Allocate buffers */
sisusb-> ibufsize = SISUSB_IBUF_SIZE;
Pete> -	if (!(sisusb->ibuf = usb_buffer_alloc(dev, SISUSB_IBUF_SIZE,
Pete> -					GFP_KERNEL, &sisusb->transfer_dma_in))) {
Pete> +	if (!(sisusb->ibuf = kmalloc(SISUSB_IBUF_SIZE, GFP_KERNEL))) {
Pete>  		dev_err(&sisusb->sisusb_dev->dev, "Failed to allocate memory for input buffer");
Pete>  		retval = -ENOMEM;
Pete>  		goto error_2;
Pete> @@ -3142,9 +3117,7 @@ static int sisusb_probe(struct usb_interface *intf,
sisusb-> numobufs = 0;
sisusb-> obufsize = SISUSB_OBUF_SIZE;
Pete>  	for (i = 0; i < NUMOBUFS; i++) {
Pete> -		if (!(sisusb->obuf[i] = usb_buffer_alloc(dev, SISUSB_OBUF_SIZE,
Pete> -					GFP_KERNEL,
Pete> -					&sisusb->transfer_dma_out[i]))) {
Pete> +		if (!(sisusb->obuf[i] = kmalloc(SISUSB_OBUF_SIZE, GFP_KERNEL))) {
Pete>  			if (i == 0) {
Pete>  				dev_err(&sisusb->sisusb_dev->dev, "Failed to allocate memory for output buffer\n");
Pete>  				retval = -ENOMEM;
Pete> diff --git a/drivers/usb/misc/sisusbvga/sisusb.h b/drivers/usb/misc/sisusbvga/sisusb.h
Pete> index cf0b4a5..55492a5 100644
Pete> --- a/drivers/usb/misc/sisusbvga/sisusb.h
Pete> +++ b/drivers/usb/misc/sisusbvga/sisusb.h
Pete> @@ -123,8 +123,6 @@ struct sisusb_usb_data {
Pete>  	int numobufs;		/* number of obufs = number of out urbs */
Pete>  	char *obuf[NUMOBUFS], *ibuf;	/* transfer buffers */
Pete>  	int obufsize, ibufsize;
Pete> -	dma_addr_t transfer_dma_out[NUMOBUFS];
Pete> -	dma_addr_t transfer_dma_in;
Pete>  	struct urb *sisurbout[NUMOBUFS];
Pete>  	struct urb *sisurbin;
Pete>  	unsigned char urbstatus[NUMOBUFS];
Pete> diff --git a/drivers/usb/mon/Makefile b/drivers/usb/mon/Makefile
Pete> index c6516b5..384b198 100644
Pete> --- a/drivers/usb/mon/Makefile
Pete> +++ b/drivers/usb/mon/Makefile
Pete> @@ -2,6 +2,6 @@
Pete>  # Makefile for USB monitor
Pete>  #
 
Pete> -usbmon-objs	:= mon_main.o mon_stat.o mon_text.o mon_bin.o mon_dma.o
Pete> +usbmon-objs	:= mon_main.o mon_stat.o mon_text.o mon_bin.o
 
Pete>  obj-$(CONFIG_USB_MON)	+= usbmon.o
Pete> diff --git a/drivers/usb/mon/mon_bin.c b/drivers/usb/mon/mon_bin.c
Pete> index 2efdf44..ef4b322 100644
Pete> --- a/drivers/usb/mon/mon_bin.c
Pete> +++ b/drivers/usb/mon/mon_bin.c
Pete> @@ -220,9 +220,8 @@ static void mon_free_buff(struct mon_pgmap *map, int npages);
 
Pete>  /*
Pete>   * This is a "chunked memcpy". It does not manipulate any counters.
Pete> - * But it returns the new offset for repeated application.
Pete>   */
Pete> -unsigned int mon_copy_to_buff(const struct mon_reader_bin *this,
Pete> +static void mon_copy_to_buff(const struct mon_reader_bin *this,
Pete>      unsigned int off, const unsigned char *from, unsigned int length)
Pete>  {
Pete>  	unsigned int step_len;
Pete> @@ -247,7 +246,6 @@ unsigned int mon_copy_to_buff(const struct mon_reader_bin *this,
Pete>  		from += step_len;
Pete>  		length -= step_len;
Pete>  	}
Pete> -	return off;
Pete>  }
 
Pete>  /*
Pete> @@ -400,15 +398,8 @@ static char mon_bin_get_data(const struct mon_reader_bin *rp,
Pete>      unsigned int offset, struct urb *urb, unsigned int length)
Pete>  {
 
Pete> -	if (urb->dev->bus->uses_dma &&
Pete> -	    (urb->transfer_flags & URB_NO_TRANSFER_DMA_MAP)) {
Pete> -		mon_dmapeek_vec(rp, offset, urb->transfer_dma, length);
Pete> -		return 0;
Pete> -	}
Pete> -
Pete>  	if (urb->transfer_buffer == NULL)
Pete>  		return 'Z';
Pete> -
Pete>  	mon_copy_to_buff(rp, offset, urb->transfer_buffer, length);
Pete>  	return 0;
Pete>  }
Pete> diff --git a/drivers/usb/mon/mon_dma.c b/drivers/usb/mon/mon_dma.c
Pete> deleted file mode 100644
Pete> index 140cc80..0000000
Pete> --- a/drivers/usb/mon/mon_dma.c
Pete> +++ /dev/null
Pete> @@ -1,95 +0,0 @@
Pete> -/*
Pete> - * The USB Monitor, inspired by Dave Harding's USBMon.
Pete> - *
Pete> - * mon_dma.c: Library which snoops on DMA areas.
Pete> - *
Pete> - * Copyright (C) 2005 Pete Zaitcev (zaitcev@redhat.com)
Pete> - */
Pete> -#include <linux/kernel.h>
Pete> -#include <linux/list.h>
Pete> -#include <linux/highmem.h>
Pete> -#include <asm/page.h>
Pete> -
Pete> -#include <linux/usb.h>	/* Only needed for declarations in usb_mon.h */
Pete> -#include "usb_mon.h"
Pete> -
Pete> -/*
Pete> - * PC-compatibles, are, fortunately, sufficiently cache-coherent for this.
Pete> - */
Pete> -#if defined(__i386__) || defined(__x86_64__) /* CONFIG_ARCH_I386 doesn't exit */
Pete> -#define MON_HAS_UNMAP 1
Pete> -
Pete> -#define phys_to_page(phys)	pfn_to_page((phys) >> PAGE_SHIFT)
Pete> -
Pete> -char mon_dmapeek(unsigned char *dst, dma_addr_t dma_addr, int len)
Pete> -{
Pete> -	struct page *pg;
Pete> -	unsigned long flags;
Pete> -	unsigned char *map;
Pete> -	unsigned char *ptr;
Pete> -
Pete> -	/*
Pete> -	 * On i386, a DMA handle is the "physical" address of a page.
Pete> -	 * In other words, the bus address is equal to physical address.
Pete> -	 * There is no IOMMU.
Pete> -	 */
Pete> -	pg = phys_to_page(dma_addr);
Pete> -
Pete> -	/*
Pete> -	 * We are called from hardware IRQs in case of callbacks.
Pete> -	 * But we can be called from softirq or process context in case
Pete> -	 * of submissions. In such case, we need to protect KM_IRQ0.
Pete> -	 */
Pete> -	local_irq_save(flags);
Pete> -	map = kmap_atomic(pg, KM_IRQ0);
Pete> -	ptr = map + (dma_addr & (PAGE_SIZE-1));
Pete> -	memcpy(dst, ptr, len);
Pete> -	kunmap_atomic(map, KM_IRQ0);
Pete> -	local_irq_restore(flags);
Pete> -	return 0;
Pete> -}
Pete> -
Pete> -void mon_dmapeek_vec(const struct mon_reader_bin *rp,
Pete> -    unsigned int offset, dma_addr_t dma_addr, unsigned int length)
Pete> -{
Pete> -	unsigned long flags;
Pete> -	unsigned int step_len;
Pete> -	struct page *pg;
Pete> -	unsigned char *map;
Pete> -	unsigned long page_off, page_len;
Pete> -
Pete> -	local_irq_save(flags);
Pete> -	while (length) {
Pete> -		/* compute number of bytes we are going to copy in this page */
Pete> -		step_len = length;
Pete> -		page_off = dma_addr & (PAGE_SIZE-1);
Pete> -		page_len = PAGE_SIZE - page_off;
Pete> -		if (page_len < step_len)
Pete> -			step_len = page_len;
Pete> -
Pete> -		/* copy data and advance pointers */
Pete> -		pg = phys_to_page(dma_addr);
Pete> -		map = kmap_atomic(pg, KM_IRQ0);
Pete> -		offset = mon_copy_to_buff(rp, offset, map + page_off, step_len);
Pete> -		kunmap_atomic(map, KM_IRQ0);
Pete> -		dma_addr += step_len;
Pete> -		length -= step_len;
Pete> -	}
Pete> -	local_irq_restore(flags);
Pete> -}
Pete> -
Pete> -#endif /* __i386__ */
Pete> -
Pete> -#ifndef MON_HAS_UNMAP
Pete> -char mon_dmapeek(unsigned char *dst, dma_addr_t dma_addr, int len)
Pete> -{
Pete> -	return 'D';
Pete> -}
Pete> -
Pete> -void mon_dmapeek_vec(const struct mon_reader_bin *rp,
Pete> -    unsigned int offset, dma_addr_t dma_addr, unsigned int length)
Pete> -{
Pete> -	;
Pete> -}
Pete> -
Pete> -#endif /* MON_HAS_UNMAP */
Pete> diff --git a/drivers/usb/mon/mon_text.c b/drivers/usb/mon/mon_text.c
Pete> index 1f71543..56bb62f 100644
Pete> --- a/drivers/usb/mon/mon_text.c
Pete> +++ b/drivers/usb/mon/mon_text.c
Pete> @@ -150,20 +150,6 @@ static inline char mon_text_get_data(struct mon_event_text *ep, struct urb *urb,
Pete>  			return '>';
Pete>  	}
 
Pete> -	/*
Pete> -	 * The check to see if it's safe to poke at data has an enormous
Pete> -	 * number of corner cases, but it seems that the following is
Pete> -	 * more or less safe.
Pete> -	 *
Pete> -	 * We do not even try to look at transfer_buffer, because it can
Pete> -	 * contain non-NULL garbage in case the upper level promised to
Pete> -	 * set DMA for the HCD.
Pete> -	 */
Pete> -	if (urb->dev->bus->uses_dma &&
Pete> -	    (urb->transfer_flags & URB_NO_TRANSFER_DMA_MAP)) {
Pete> -		return mon_dmapeek(ep->data, urb->transfer_dma, len);
Pete> -	}
Pete> -
Pete>  	if (urb->transfer_buffer == NULL)
Pete>  		return 'Z';	/* '0' would be not as pretty. */
 
Pete> diff --git a/drivers/usb/mon/usb_mon.h b/drivers/usb/mon/usb_mon.h
Pete> index f5d84ff..df9a4df 100644
Pete> --- a/drivers/usb/mon/usb_mon.h
Pete> +++ b/drivers/usb/mon/usb_mon.h
Pete> @@ -65,20 +65,6 @@ int __init mon_bin_init(void);
Pete>  void mon_bin_exit(void);
 
Pete>  /*
Pete> - * DMA interface.
Pete> - *
Pete> - * XXX The vectored side needs a serious re-thinking. Abstracting vectors,
Pete> - * like in Paolo's original patch, produces a double pkmap. We need an idea.
Pete> -*/
Pete> -extern char mon_dmapeek(unsigned char *dst, dma_addr_t dma_addr, int len);
Pete> -
Pete> -struct mon_reader_bin;
Pete> -extern void mon_dmapeek_vec(const struct mon_reader_bin *rp,
Pete> -    unsigned int offset, dma_addr_t dma_addr, unsigned int len);
Pete> -extern unsigned int mon_copy_to_buff(const struct mon_reader_bin *rp,
Pete> -    unsigned int offset, const unsigned char *from, unsigned int len);
Pete> -
Pete> -/*
Pete>   */
Pete>  extern struct mutex mon_lock;
 
Pete> diff --git a/include/linux/usb.h b/include/linux/usb.h
Pete> index 3aa2cd1..5b58d89 100644
Pete> --- a/include/linux/usb.h
Pete> +++ b/include/linux/usb.h
Pete> @@ -1014,9 +1014,10 @@ typedef void (*usb_complete_t)(struct urb *);
Pete>   * @transfer_flags: A variety of flags may be used to affect how URB
Pete>   *	submission, unlinking, or operation are handled.  Different
Pete>   *	kinds of URB can use different flags.
Pete> - * @transfer_buffer:  This identifies the buffer to (or from) which
Pete> - * 	the I/O request will be performed (unless URB_NO_TRANSFER_DMA_MAP
Pete> - *	is set).  This buffer must be suitable for DMA; allocate it with
Pete> + * @transfer_buffer:  This identifies the buffer to (or from) which the I/O
Pete> + *	request will be performed unless URB_NO_TRANSFER_DMA_MAP is set
Pete> + *	(however, do not leave garbage in transfer_buffer even then).
Pete> + *	This buffer must be suitable for DMA; allocate it with
Pete>   *	kmalloc() or equivalent.  For transfers to "in" endpoints, contents
Pete>   *	of this buffer will be modified.  This buffer is used for the data
Pete>   *	stage of control transfers.
Pete> @@ -1078,9 +1079,15 @@ typedef void (*usb_complete_t)(struct urb *);
Pete>   * allocate a DMA buffer with usb_buffer_alloc() or call usb_buffer_map().
Pete>   * When these transfer flags are provided, host controller drivers will
Pete>   * attempt to use the dma addresses found in the transfer_dma and/or
Pete> - * setup_dma fields rather than determining a dma address themselves.  (Note
Pete> - * that transfer_buffer and setup_packet must still be set because not all
Pete> - * host controllers use DMA, nor do virtual root hubs).
Pete> + * setup_dma fields rather than determining a dma address themselves.
Pete> + *
Pete> + * Note that transfer_buffer must still be set if the controller 
Pete> + * does not support DMA (as indicated by bus.uses_dma) and when talking
Pete> + * to root hub. If you have to trasfer between highmem zone and the device
Pete> + * on such controller, create a bounce buffer or bail out with an error.
Pete> + * If transfer_buffer cannot be set (is in highmem) and the controller is DMA
Pete> + * capable, assign NULL to it, so that usbmon knows not to use the value.
Pete> + * The setup_packet must always be set, so it cannot be located in highmem.
Pete>   *
Pete>   * Initialization:
Pete>   *

Pete> -- Pete
