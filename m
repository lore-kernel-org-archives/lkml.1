Return-Path: <linux-kernel-owner+w=401wt.eu-S1755135AbZFCDMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135AbZFCDMj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 23:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbZFCDMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 23:12:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57465 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751985AbZFCDM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 23:12:29 -0400
Date: Tue, 2 Jun 2009 21:09:32 -0600
From: Pete Zaitcev <zaitcev@redhat.com>
To: David <david@unsolicited.net>, "John Stoffel" <john@stoffel.org>
Cc: zaitcev@redhat.com, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, <thomas@winischhofer.net>
Subject: Patch to fix usbmon crash on Opteron
Message-Id: <20090602210932.b74fff08.zaitcev@redhat.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's my proposal: forget the clever-by-half tricks and simply use
transfer_buffer. This should not only fix Opteron, but also future IOMMUs
that Intel and AMD promise. It may also make usbmon useable on PPC at last.

I think downsides are negligible. The ones I see are:
 - A driver may pass an address of one buffer down as transfer_buffer,
   and entirely different entity mapped for DMA, resulting in misleading
   output of usbmon.
 - Out of tree drivers may crash usbmon if they store garbage in
   transfer_buffer. I went over the tree with a comb and fixed obvious
   bugs, and clarified the documentation in comments.
 - Drivers that use get_user_pages will not be possible to monitor
 - Similar deal is with usb_storage transferring from highmem, but
   it works fine on 64-bit systems, so I think it's not a concern.

I'm adding a sign-off line in case, but in general this is a patch
for testing. In particular, sisusb is a concern.

David & John, I am quite certain that your Opterons will not crash now,
but please give it a try, and also you can use this code to produce usbmon
traces you needed for debugging of other things.

Signed-off-by: Pete Zaitcev <zaitcev@redhat.com>

diff --git a/drivers/staging/rspiusb/rspiusb.c b/drivers/staging/rspiusb/rspiusb.c
index ecaffb5..fe97451 100644
--- a/drivers/staging/rspiusb/rspiusb.c
+++ b/drivers/staging/rspiusb/rspiusb.c
@@ -432,8 +432,7 @@ static void piusb_write_bulk_callback(struct urb *urb)
 			__func__, status);
 
 	pdx->pendingWrite = 0;
-	usb_buffer_free(urb->dev, urb->transfer_buffer_length,
-			urb->transfer_buffer, urb->transfer_dma);
+	kfree(urb->transfer_buffer);
 }
 
 int piusb_output(struct ioctl_struct * io, unsigned char *uBuf, int len,
@@ -445,9 +444,7 @@ int piusb_output(struct ioctl_struct * io, unsigned char *uBuf, int len,
 
 	urb = usb_alloc_urb(0, GFP_KERNEL);
 	if (urb != NULL) {
-		kbuf =
-		    usb_buffer_alloc(pdx->udev, len, GFP_KERNEL,
-				     &urb->transfer_dma);
+		kbuf = kmalloc(len, GFP_KERNEL);
 		if (!kbuf) {
 			info("buffer_alloc failed\n");
 			return -ENOMEM;
@@ -455,7 +452,6 @@ int piusb_output(struct ioctl_struct * io, unsigned char *uBuf, int len,
 		memcpy(kbuf, uBuf, len);
 		usb_fill_bulk_urb(urb, pdx->udev, pdx->hEP[io->endpoint], kbuf,
 				  len, piusb_write_bulk_callback, pdx);
-		urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
 		err = usb_submit_urb(urb, GFP_KERNEL);
 		if (err) {
 			dev_err(&pdx->udev->dev,
@@ -617,7 +613,7 @@ static int MapUserBuffer(struct ioctl_struct *io, struct device_extension *pdx)
 	numPagesRequired =
 	    ((uaddr & ~PAGE_MASK) + count + ~PAGE_MASK) >> PAGE_SHIFT;
 	dbg("Number of pages needed = %d", numPagesRequired);
-	maplist_p = vmalloc(numPagesRequired * sizeof(struct page));	//, GFP_ATOMIC);
+	maplist_p = vmalloc(numPagesRequired * sizeof(struct page *));	//, GFP_ATOMIC);
 	if (!maplist_p) {
 		dbg("Can't Allocate Memory for maplist_p");
 		return -ENOMEM;
@@ -681,9 +677,7 @@ static int MapUserBuffer(struct ioctl_struct *io, struct device_extension *pdx)
 		usb_fill_bulk_urb(pdx->PixelUrb[frameInfo][i],
 				  pdx->udev,
 				  epAddr,
-				  (dma_addr_t *) sg_dma_address(&pdx->
-								sgl[frameInfo]
-								[i]),
+				  NULL, // non-DMA HC? buy a better hardware
 				  sg_dma_len(&pdx->sgl[frameInfo][i]),
 				  piusb_readPIXEL_callback, (void *)pdx);
 		pdx->PixelUrb[frameInfo][i]->transfer_dma =
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index be86ae3..8fb176f 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1070,7 +1070,7 @@ static int hub_configure(struct usb_hub *hub,
 		goto fail;
 	}
 
-	usb_fill_int_urb(hub->urb, hdev, pipe, *hub->buffer, maxp, hub_irq,
+	usb_fill_int_urb(hub->urb, hdev, pipe, hub->buffer, maxp, hub_irq,
 		hub, endpoint->bInterval);
 	hub->urb->transfer_dma = hub->buffer_dma;
 	hub->urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
index b626283..f06d095 100644
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -421,30 +421,18 @@ int usb_sg_init(struct usb_sg_request *io, struct usb_device *dev,
 		/*
 		 * Some systems need to revert to PIO when DMA is temporarily
 		 * unavailable.  For their sakes, both transfer_buffer and
-		 * transfer_dma are set when possible.  However this can only
-		 * work on systems without:
-		 *
-		 *  - HIGHMEM, since DMA buffers located in high memory are
-		 *    not directly addressable by the CPU for PIO;
-		 *
-		 *  - IOMMU, since dma_map_sg() is allowed to use an IOMMU to
-		 *    make virtually discontiguous buffers be "dma-contiguous"
-		 *    so that PIO and DMA need diferent numbers of URBs.
-		 *
-		 * So when HIGHMEM or IOMMU are in use, transfer_buffer is NULL
-		 * to prevent stale pointers and to help spot bugs.
+		 * transfer_dma are set when possible.
 		 */
+		if (PageHighMem(sg_page(sg))) {
+			io->urbs[i]->transfer_buffer = NULL;
+		} else {
+			io->urbs[i]->transfer_buffer = sg_virt(sg);
+		}
 		if (dma) {
 			io->urbs[i]->transfer_dma = sg_dma_address(sg);
 			len = sg_dma_len(sg);
-#if defined(CONFIG_HIGHMEM) || defined(CONFIG_GART_IOMMU)
-			io->urbs[i]->transfer_buffer = NULL;
-#else
-			io->urbs[i]->transfer_buffer = sg_virt(sg);
-#endif
 		} else {
 			/* hc may use _only_ transfer_buffer */
-			io->urbs[i]->transfer_buffer = sg_virt(sg);
 			len = sg->length;
 		}
 
diff --git a/drivers/usb/misc/sisusbvga/sisusb.c b/drivers/usb/misc/sisusbvga/sisusb.c
index b4ec716..0025847 100644
--- a/drivers/usb/misc/sisusbvga/sisusb.c
+++ b/drivers/usb/misc/sisusbvga/sisusb.c
@@ -79,14 +79,12 @@ sisusb_free_buffers(struct sisusb_usb_data *sisusb)
 
 	for (i = 0; i < NUMOBUFS; i++) {
 		if (sisusb->obuf[i]) {
-			usb_buffer_free(sisusb->sisusb_dev, sisusb->obufsize,
-				sisusb->obuf[i], sisusb->transfer_dma_out[i]);
+			kfree(sisusb->obuf[i]);
 			sisusb->obuf[i] = NULL;
 		}
 	}
 	if (sisusb->ibuf) {
-		usb_buffer_free(sisusb->sisusb_dev, sisusb->ibufsize,
-			sisusb->ibuf, sisusb->transfer_dma_in);
+		kfree(sisusb->ibuf);
 		sisusb->ibuf = NULL;
 	}
 }
@@ -230,8 +228,7 @@ sisusb_bulk_completeout(struct urb *urb)
 
 static int
 sisusb_bulkout_msg(struct sisusb_usb_data *sisusb, int index, unsigned int pipe, void *data,
-		int len, int *actual_length, int timeout, unsigned int tflags,
-		dma_addr_t transfer_dma)
+		int len, int *actual_length, int timeout, unsigned int tflags)
 {
 	struct urb *urb = sisusb->sisurbout[index];
 	int retval, byteswritten = 0;
@@ -245,9 +242,6 @@ sisusb_bulkout_msg(struct sisusb_usb_data *sisusb, int index, unsigned int pipe,
 	urb->transfer_flags |= tflags;
 	urb->actual_length = 0;
 
-	if ((urb->transfer_dma = transfer_dma))
-		urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
-
 	/* Set up context */
 	sisusb->urbout_context[index].actual_length = (timeout) ?
 						NULL : actual_length;
@@ -297,8 +291,8 @@ sisusb_bulk_completein(struct urb *urb)
 }
 
 static int
-sisusb_bulkin_msg(struct sisusb_usb_data *sisusb, unsigned int pipe, void *data, int len,
-		int *actual_length, int timeout, unsigned int tflags, dma_addr_t transfer_dma)
+sisusb_bulkin_msg(struct sisusb_usb_data *sisusb, unsigned int pipe, void *data,
+	int len, int *actual_length, int timeout, unsigned int tflags)
 {
 	struct urb *urb = sisusb->sisurbin;
 	int retval, readbytes = 0;
@@ -311,9 +305,6 @@ sisusb_bulkin_msg(struct sisusb_usb_data *sisusb, unsigned int pipe, void *data,
 	urb->transfer_flags |= tflags;
 	urb->actual_length = 0;
 
-	if ((urb->transfer_dma = transfer_dma))
-		urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
-
 	sisusb->completein = 0;
 	retval = usb_submit_urb(urb, GFP_ATOMIC);
 	if (retval == 0) {
@@ -422,8 +413,7 @@ static int sisusb_send_bulk_msg(struct sisusb_usb_data *sisusb, int ep, int len,
 						thispass,
 						&transferred_len,
 						async ? 0 : 5 * HZ,
-						tflags,
-						sisusb->transfer_dma_out[index]);
+						tflags);
 
 			if (result == -ETIMEDOUT) {
 
@@ -432,29 +422,16 @@ static int sisusb_send_bulk_msg(struct sisusb_usb_data *sisusb, int ep, int len,
 					return -ETIME;
 
 				continue;
+			}
 
-			} else if ((result == 0) && !async && transferred_len) {
+			if ((result == 0) && !async && transferred_len) {
 
 				thispass -= transferred_len;
-				if (thispass) {
-					if (sisusb->transfer_dma_out) {
-						/* If DMA, copy remaining
-						 * to beginning of buffer
-						 */
-						memcpy(buffer,
-						       buffer + transferred_len,
-						       thispass);
-					} else {
-						/* If not DMA, simply increase
-						 * the pointer
-						 */
-						buffer += transferred_len;
-					}
-				}
+				buffer += transferred_len;
 
 			} else
 				break;
-		};
+		}
 
 		if (result)
 			return result;
@@ -530,8 +507,7 @@ static int sisusb_recv_bulk_msg(struct sisusb_usb_data *sisusb, int ep, int len,
 					   thispass,
 					   &transferred_len,
 					   5 * HZ,
-					   tflags,
-					   sisusb->transfer_dma_in);
+					   tflags);
 
 		if (transferred_len)
 			thispass = transferred_len;
@@ -3132,8 +3108,7 @@ static int sisusb_probe(struct usb_interface *intf,
 
 	/* Allocate buffers */
 	sisusb->ibufsize = SISUSB_IBUF_SIZE;
-	if (!(sisusb->ibuf = usb_buffer_alloc(dev, SISUSB_IBUF_SIZE,
-					GFP_KERNEL, &sisusb->transfer_dma_in))) {
+	if (!(sisusb->ibuf = kmalloc(SISUSB_IBUF_SIZE, GFP_KERNEL))) {
 		dev_err(&sisusb->sisusb_dev->dev, "Failed to allocate memory for input buffer");
 		retval = -ENOMEM;
 		goto error_2;
@@ -3142,9 +3117,7 @@ static int sisusb_probe(struct usb_interface *intf,
 	sisusb->numobufs = 0;
 	sisusb->obufsize = SISUSB_OBUF_SIZE;
 	for (i = 0; i < NUMOBUFS; i++) {
-		if (!(sisusb->obuf[i] = usb_buffer_alloc(dev, SISUSB_OBUF_SIZE,
-					GFP_KERNEL,
-					&sisusb->transfer_dma_out[i]))) {
+		if (!(sisusb->obuf[i] = kmalloc(SISUSB_OBUF_SIZE, GFP_KERNEL))) {
 			if (i == 0) {
 				dev_err(&sisusb->sisusb_dev->dev, "Failed to allocate memory for output buffer\n");
 				retval = -ENOMEM;
diff --git a/drivers/usb/misc/sisusbvga/sisusb.h b/drivers/usb/misc/sisusbvga/sisusb.h
index cf0b4a5..55492a5 100644
--- a/drivers/usb/misc/sisusbvga/sisusb.h
+++ b/drivers/usb/misc/sisusbvga/sisusb.h
@@ -123,8 +123,6 @@ struct sisusb_usb_data {
 	int numobufs;		/* number of obufs = number of out urbs */
 	char *obuf[NUMOBUFS], *ibuf;	/* transfer buffers */
 	int obufsize, ibufsize;
-	dma_addr_t transfer_dma_out[NUMOBUFS];
-	dma_addr_t transfer_dma_in;
 	struct urb *sisurbout[NUMOBUFS];
 	struct urb *sisurbin;
 	unsigned char urbstatus[NUMOBUFS];
diff --git a/drivers/usb/mon/Makefile b/drivers/usb/mon/Makefile
index c6516b5..384b198 100644
--- a/drivers/usb/mon/Makefile
+++ b/drivers/usb/mon/Makefile
@@ -2,6 +2,6 @@
 # Makefile for USB monitor
 #
 
-usbmon-objs	:= mon_main.o mon_stat.o mon_text.o mon_bin.o mon_dma.o
+usbmon-objs	:= mon_main.o mon_stat.o mon_text.o mon_bin.o
 
 obj-$(CONFIG_USB_MON)	+= usbmon.o
diff --git a/drivers/usb/mon/mon_bin.c b/drivers/usb/mon/mon_bin.c
index 2efdf44..ef4b322 100644
--- a/drivers/usb/mon/mon_bin.c
+++ b/drivers/usb/mon/mon_bin.c
@@ -220,9 +220,8 @@ static void mon_free_buff(struct mon_pgmap *map, int npages);
 
 /*
  * This is a "chunked memcpy". It does not manipulate any counters.
- * But it returns the new offset for repeated application.
  */
-unsigned int mon_copy_to_buff(const struct mon_reader_bin *this,
+static void mon_copy_to_buff(const struct mon_reader_bin *this,
     unsigned int off, const unsigned char *from, unsigned int length)
 {
 	unsigned int step_len;
@@ -247,7 +246,6 @@ unsigned int mon_copy_to_buff(const struct mon_reader_bin *this,
 		from += step_len;
 		length -= step_len;
 	}
-	return off;
 }
 
 /*
@@ -400,15 +398,8 @@ static char mon_bin_get_data(const struct mon_reader_bin *rp,
     unsigned int offset, struct urb *urb, unsigned int length)
 {
 
-	if (urb->dev->bus->uses_dma &&
-	    (urb->transfer_flags & URB_NO_TRANSFER_DMA_MAP)) {
-		mon_dmapeek_vec(rp, offset, urb->transfer_dma, length);
-		return 0;
-	}
-
 	if (urb->transfer_buffer == NULL)
 		return 'Z';
-
 	mon_copy_to_buff(rp, offset, urb->transfer_buffer, length);
 	return 0;
 }
diff --git a/drivers/usb/mon/mon_dma.c b/drivers/usb/mon/mon_dma.c
deleted file mode 100644
index 140cc80..0000000
--- a/drivers/usb/mon/mon_dma.c
+++ /dev/null
@@ -1,95 +0,0 @@
-/*
- * The USB Monitor, inspired by Dave Harding's USBMon.
- *
- * mon_dma.c: Library which snoops on DMA areas.
- *
- * Copyright (C) 2005 Pete Zaitcev (zaitcev@redhat.com)
- */
-#include <linux/kernel.h>
-#include <linux/list.h>
-#include <linux/highmem.h>
-#include <asm/page.h>
-
-#include <linux/usb.h>	/* Only needed for declarations in usb_mon.h */
-#include "usb_mon.h"
-
-/*
- * PC-compatibles, are, fortunately, sufficiently cache-coherent for this.
- */
-#if defined(__i386__) || defined(__x86_64__) /* CONFIG_ARCH_I386 doesn't exit */
-#define MON_HAS_UNMAP 1
-
-#define phys_to_page(phys)	pfn_to_page((phys) >> PAGE_SHIFT)
-
-char mon_dmapeek(unsigned char *dst, dma_addr_t dma_addr, int len)
-{
-	struct page *pg;
-	unsigned long flags;
-	unsigned char *map;
-	unsigned char *ptr;
-
-	/*
-	 * On i386, a DMA handle is the "physical" address of a page.
-	 * In other words, the bus address is equal to physical address.
-	 * There is no IOMMU.
-	 */
-	pg = phys_to_page(dma_addr);
-
-	/*
-	 * We are called from hardware IRQs in case of callbacks.
-	 * But we can be called from softirq or process context in case
-	 * of submissions. In such case, we need to protect KM_IRQ0.
-	 */
-	local_irq_save(flags);
-	map = kmap_atomic(pg, KM_IRQ0);
-	ptr = map + (dma_addr & (PAGE_SIZE-1));
-	memcpy(dst, ptr, len);
-	kunmap_atomic(map, KM_IRQ0);
-	local_irq_restore(flags);
-	return 0;
-}
-
-void mon_dmapeek_vec(const struct mon_reader_bin *rp,
-    unsigned int offset, dma_addr_t dma_addr, unsigned int length)
-{
-	unsigned long flags;
-	unsigned int step_len;
-	struct page *pg;
-	unsigned char *map;
-	unsigned long page_off, page_len;
-
-	local_irq_save(flags);
-	while (length) {
-		/* compute number of bytes we are going to copy in this page */
-		step_len = length;
-		page_off = dma_addr & (PAGE_SIZE-1);
-		page_len = PAGE_SIZE - page_off;
-		if (page_len < step_len)
-			step_len = page_len;
-
-		/* copy data and advance pointers */
-		pg = phys_to_page(dma_addr);
-		map = kmap_atomic(pg, KM_IRQ0);
-		offset = mon_copy_to_buff(rp, offset, map + page_off, step_len);
-		kunmap_atomic(map, KM_IRQ0);
-		dma_addr += step_len;
-		length -= step_len;
-	}
-	local_irq_restore(flags);
-}
-
-#endif /* __i386__ */
-
-#ifndef MON_HAS_UNMAP
-char mon_dmapeek(unsigned char *dst, dma_addr_t dma_addr, int len)
-{
-	return 'D';
-}
-
-void mon_dmapeek_vec(const struct mon_reader_bin *rp,
-    unsigned int offset, dma_addr_t dma_addr, unsigned int length)
-{
-	;
-}
-
-#endif /* MON_HAS_UNMAP */
diff --git a/drivers/usb/mon/mon_text.c b/drivers/usb/mon/mon_text.c
index 1f71543..56bb62f 100644
--- a/drivers/usb/mon/mon_text.c
+++ b/drivers/usb/mon/mon_text.c
@@ -150,20 +150,6 @@ static inline char mon_text_get_data(struct mon_event_text *ep, struct urb *urb,
 			return '>';
 	}
 
-	/*
-	 * The check to see if it's safe to poke at data has an enormous
-	 * number of corner cases, but it seems that the following is
-	 * more or less safe.
-	 *
-	 * We do not even try to look at transfer_buffer, because it can
-	 * contain non-NULL garbage in case the upper level promised to
-	 * set DMA for the HCD.
-	 */
-	if (urb->dev->bus->uses_dma &&
-	    (urb->transfer_flags & URB_NO_TRANSFER_DMA_MAP)) {
-		return mon_dmapeek(ep->data, urb->transfer_dma, len);
-	}
-
 	if (urb->transfer_buffer == NULL)
 		return 'Z';	/* '0' would be not as pretty. */
 
diff --git a/drivers/usb/mon/usb_mon.h b/drivers/usb/mon/usb_mon.h
index f5d84ff..df9a4df 100644
--- a/drivers/usb/mon/usb_mon.h
+++ b/drivers/usb/mon/usb_mon.h
@@ -65,20 +65,6 @@ int __init mon_bin_init(void);
 void mon_bin_exit(void);
 
 /*
- * DMA interface.
- *
- * XXX The vectored side needs a serious re-thinking. Abstracting vectors,
- * like in Paolo's original patch, produces a double pkmap. We need an idea.
-*/
-extern char mon_dmapeek(unsigned char *dst, dma_addr_t dma_addr, int len);
-
-struct mon_reader_bin;
-extern void mon_dmapeek_vec(const struct mon_reader_bin *rp,
-    unsigned int offset, dma_addr_t dma_addr, unsigned int len);
-extern unsigned int mon_copy_to_buff(const struct mon_reader_bin *rp,
-    unsigned int offset, const unsigned char *from, unsigned int len);
-
-/*
  */
 extern struct mutex mon_lock;
 
diff --git a/include/linux/usb.h b/include/linux/usb.h
index 3aa2cd1..5b58d89 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -1014,9 +1014,10 @@ typedef void (*usb_complete_t)(struct urb *);
  * @transfer_flags: A variety of flags may be used to affect how URB
  *	submission, unlinking, or operation are handled.  Different
  *	kinds of URB can use different flags.
- * @transfer_buffer:  This identifies the buffer to (or from) which
- * 	the I/O request will be performed (unless URB_NO_TRANSFER_DMA_MAP
- *	is set).  This buffer must be suitable for DMA; allocate it with
+ * @transfer_buffer:  This identifies the buffer to (or from) which the I/O
+ *	request will be performed unless URB_NO_TRANSFER_DMA_MAP is set
+ *	(however, do not leave garbage in transfer_buffer even then).
+ *	This buffer must be suitable for DMA; allocate it with
  *	kmalloc() or equivalent.  For transfers to "in" endpoints, contents
  *	of this buffer will be modified.  This buffer is used for the data
  *	stage of control transfers.
@@ -1078,9 +1079,15 @@ typedef void (*usb_complete_t)(struct urb *);
  * allocate a DMA buffer with usb_buffer_alloc() or call usb_buffer_map().
  * When these transfer flags are provided, host controller drivers will
  * attempt to use the dma addresses found in the transfer_dma and/or
- * setup_dma fields rather than determining a dma address themselves.  (Note
- * that transfer_buffer and setup_packet must still be set because not all
- * host controllers use DMA, nor do virtual root hubs).
+ * setup_dma fields rather than determining a dma address themselves.
+ *
+ * Note that transfer_buffer must still be set if the controller 
+ * does not support DMA (as indicated by bus.uses_dma) and when talking
+ * to root hub. If you have to trasfer between highmem zone and the device
+ * on such controller, create a bounce buffer or bail out with an error.
+ * If transfer_buffer cannot be set (is in highmem) and the controller is DMA
+ * capable, assign NULL to it, so that usbmon knows not to use the value.
+ * The setup_packet must always be set, so it cannot be located in highmem.
  *
  * Initialization:
  *

-- Pete
