Return-Path: <linux-kernel-owner+w=401wt.eu-S1753692AbYIPHdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692AbYIPHdg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 03:33:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753137AbYIPHdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 03:33:20 -0400
Received: from zimbra-mta.cetrtapot.si ([89.212.80.172]:59297 "EHLO
	zimbra-mta.cetrtapot.si" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826AbYIPHdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 03:33:19 -0400
X-Spam-Flag: NO
X-Spam-Score: -3.946
Message-ID: <48CF610F.4050202@cetrtapot.si>
Date: Tue, 16 Sep 2008 09:32:31 +0200
From: Hinko Kocevar <hinko.kocevar@cetrtapot.si>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Kernelnewbies <kernelnewbies@nl.linux.org>
Subject: Cris USB host driver for 2.6.26
Content-Type: multipart/mixed;
 boundary="------------010002050004020002080005"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010002050004020002080005
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit

Hi,

I've 'ported' 2.6.19 cris architecture cris v10 USB host driver from 2.6.19 to 2.6.26. Could someone take a look at the diff attached. I'm experiencing some difficulties with interrupt driven traffic, while USB to serial converter and USB mass storage seem to work.

Thank you,
Hinko

-- 
ÈETRTA POT, d.o.o., Kranj
Planina 3
4000 Kranj
Slovenia, Europe
Tel. +386 (0) 4 280 66 03
E-mail: hinko.kocevar@cetrtapot.si
Http: www.cetrtapot.si


--------------010002050004020002080005
Content-Type: text/x-patch;
 name="cris_usb.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="cris_usb.diff"

--- hc-crisv10_2.6.19.c	2008-09-16 09:27:09.000000000 +0200
+++ hc-crisv10_2.6.26.c	2008-09-16 09:27:47.000000000 +0200
@@ -33,10 +33,9 @@
 /***************************************************************************/
 /***************************************************************************/
 
-#define VERSION			"1.00"
+#define VERSION			"1.00 hinko v2.6.26 (16 Sep 2008)"
 #define COPYRIGHT		"(c) 2005, 2006 Axis Communications AB"
 #define DESCRIPTION             "ETRAX 100LX USB Host Controller"
-#define CARNEOL_PATCH	"v0.2, 12 Jul 2007"
 
 #define ETRAX_USB_HC_IRQ USB_HC_IRQ_NBR
 #define ETRAX_USB_RX_IRQ USB_DMA_RX_IRQ_NBR
@@ -641,8 +640,8 @@
 #endif /* CONFIG_PM */
 static int crisv10_hcd_get_frame(struct usb_hcd *);
 
-static int  tc_urb_enqueue(struct usb_hcd *, struct usb_host_endpoint *ep, struct urb *, gfp_t mem_flags);
-static int  tc_urb_dequeue(struct usb_hcd *, struct urb *);
+static int  tc_urb_enqueue(struct usb_hcd *, struct urb *, gfp_t mem_flags);
+static int  tc_urb_dequeue(struct usb_hcd *, struct urb *, int status);
 static void tc_endpoint_disable(struct usb_hcd *, struct usb_host_endpoint *ep);
 
 static int rh_status_data_request(struct usb_hcd *, char *);
@@ -1506,13 +1505,13 @@
 static int zout_buffer[4] __attribute__ ((aligned (4)));
 
 /* Cache for allocating new EP and SB descriptors. */
-static kmem_cache_t *usb_desc_cache;
+static struct kmem_cache *usb_desc_cache;
 
 /* Cache for the data allocated in the isoc descr top half. */
-static kmem_cache_t *isoc_compl_cache;
+static struct kmem_cache *isoc_compl_cache;
 
 /* Cache for the data allocated when delayed finishing of URBs */
-static kmem_cache_t *later_data_cache;
+static struct kmem_cache *later_data_cache;
 
 
 /* Counter to keep track of how many Isoc EP we have sat up. Used to enable
@@ -1630,7 +1629,7 @@
      sizeof(struct USB_EP_Desc) == sizeof(struct USB_SB_Desc). */
   usb_desc_cache = kmem_cache_create("usb_desc_cache",
 				     sizeof(struct USB_EP_Desc), 0,
-				     SLAB_HWCACHE_ALIGN, 0, 0);
+				     SLAB_HWCACHE_ALIGN, 0);
   if(usb_desc_cache == NULL) {
     return -ENOMEM;
   }
@@ -1640,7 +1639,7 @@
   isoc_compl_cache =
     kmem_cache_create("isoc_compl_cache",
 		      sizeof(struct crisv10_isoc_complete_data),
-		      0, SLAB_HWCACHE_ALIGN, 0, 0);
+		      0, SLAB_HWCACHE_ALIGN, 0);
   if(isoc_compl_cache == NULL) {
     return -ENOMEM;
   }
@@ -1650,7 +1649,7 @@
   later_data_cache =
     kmem_cache_create("later_data_cache",
 		      sizeof(struct urb_later_data),
-		      0, SLAB_HWCACHE_ALIGN, 0, 0);
+		      0, SLAB_HWCACHE_ALIGN, 0);
   if(later_data_cache == NULL) {
     return -ENOMEM;
   }
@@ -1707,12 +1706,10 @@
 
 /* queue an URB with the transfer controller (called from hcd_driver) */
 static int tc_urb_enqueue(struct usb_hcd *hcd, 
-			  struct usb_host_endpoint *ep,
 			  struct urb *urb, 
 			  gfp_t mem_flags) {
   int epid;
   int retval;
-  int bustime = 0;
   int maxpacket;
   unsigned long flags;
   struct crisv10_urb_priv *urb_priv;
@@ -1739,21 +1736,9 @@
     return -EMSGSIZE;
   }
 
-  /* Check if there is enough bandwidth for periodic transfer  */
-  if(usb_pipeint(urb->pipe) || usb_pipeisoc(urb->pipe)) {
-    /* only check (and later claim) if not already claimed */
-    if (urb->bandwidth == 0) {
-      bustime = usb_check_bandwidth(urb->dev, urb);
-      if (bustime < 0) {
-	tc_err("Not enough periodic bandwidth\n");
-	return -ENOSPC;
-      }
-    }
-  }
-
   /* Check if there is a epid for URBs destination, if not this function
      set up one. */
-  epid = tc_setup_epid(ep, urb, mem_flags);
+  epid = tc_setup_epid(urb->ep, urb, mem_flags);
   if (epid < 0) {
     tc_err("Failed setup epid:%d for URB:0x%x\n", epid, (unsigned int)urb);
     DBFEXIT;
@@ -1812,11 +1797,6 @@
   /* Disable other access when inserting USB */
   local_irq_save(flags);
 
-  /* Claim bandwidth, if needed */
-  if(bustime) {
-    usb_claim_bandwidth(urb->dev, urb, bustime, 0);
-  }
-  
   /* Add URB to EP queue */
   urb_list_add(urb, epid, mem_flags);
 
@@ -1835,7 +1815,7 @@
 }
 
 /* remove an URB from the transfer controller queues (called from hcd_driver)*/
-static int tc_urb_dequeue(struct usb_hcd *hcd, struct urb *urb) {
+static int tc_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status) {
   struct crisv10_urb_priv *urb_priv;
   unsigned long flags;
   int epid;
@@ -2082,9 +2062,9 @@
   DBFEXIT;
 }
 
-static void tc_finish_urb_later_proc(void *data) {
+static void tc_finish_urb_later_proc(struct work_struct *work) {
   unsigned long flags;
-  struct urb_later_data* uld = (struct urb_later_data*)data;
+  struct urb_later_data* uld = container_of(work, struct urb_later_data, ws.work);
   local_irq_save(flags);
   if(uld->urb == NULL) {
     late_dbg("Later finish of URB = NULL (allready finished)\n");
@@ -2130,7 +2110,7 @@
     return;
   }
 
-  uld = kmem_cache_alloc(later_data_cache, SLAB_ATOMIC);
+  uld = kmem_cache_alloc(later_data_cache, GFP_ATOMIC);
   ASSERT(uld);
 
   uld->hcd = hcd;
@@ -2138,7 +2118,7 @@
   uld->urb_num = urb_priv->urb_num;
   uld->status = status;
 
-  INIT_WORK(&uld->ws, tc_finish_urb_later_proc, uld);
+  INIT_DELAYED_WORK(&uld->ws, tc_finish_urb_later_proc);
   urb_priv->later_data = uld;
 
   /* Schedule the finishing of the URB to happen later */
@@ -2230,10 +2210,6 @@
     tc_dma_unlink_intr_urb(urb);
   }
 
-  /* Release allocated bandwidth for periodic transfers */
-  if(usb_pipeint(urb->pipe) || usb_pipeisoc(urb->pipe))
-    usb_release_bandwidth(urb->dev, urb, 0);
-
   /* This URB is active on EP */
   if(urb == activeUrbList[epid]) {
     /* We need to fiddle with the toggle bits because the hardware doesn't do
@@ -2301,7 +2277,7 @@
 
   /*  Hand the URB from HCD to its USB device driver, using its completion
       functions */
-  usb_hcd_giveback_urb (hcd, urb);
+  usb_hcd_giveback_urb (hcd, urb, status);
 
   /* Check the queue once more if the URB returned with error, because we
      didn't do it before the completion function because the specification
@@ -2443,11 +2419,9 @@
   /* Free HC-private URB data*/
   urb_priv_free(hcd, urb);
 
-  usb_release_bandwidth(urb->dev, urb, 0);
-
   /*  Hand the URB from HCD to its USB device driver, using its completion
       functions */
-  usb_hcd_giveback_urb (hcd, urb);
+  usb_hcd_giveback_urb (hcd, urb, status);
 }
 
 static __u32 urb_num = 0;
@@ -3385,7 +3359,7 @@
 /* Handle processing of Bulk, Ctrl and Intr queues */
 static void tc_dma_process_queue(int epid) {
   struct urb *urb;
-  struct crisv10_urb_priv *urb_priv = urb->hcpriv;
+  struct crisv10_urb_priv *urb_priv;
   unsigned long flags;
   char toggle;
 
@@ -4001,8 +3975,8 @@
    are done. This functions completes all URBs earlier marked with
    isoc_out_done by fast interrupt routine check_finished_isoc_tx_epids() */
 
-static void complete_isoc_bottom_half(void *data) {
-  struct crisv10_isoc_complete_data *comp_data;
+static void complete_isoc_bottom_half(struct work_struct *work) {
+  struct crisv10_isoc_complete_data *comp_data = container_of(work, struct crisv10_isoc_complete_data, usb_bh);
   struct usb_iso_packet_descriptor *packet;
   struct crisv10_urb_priv * urb_priv;
   unsigned long flags;
@@ -4011,8 +3985,6 @@
   int epid;
   int i;
 
-  comp_data = (struct crisv10_isoc_complete_data*)data;
-
   local_irq_save(flags);
 
   for (epid = 0; epid < NBR_OF_EPIDS - 1; epid++) {
@@ -4161,11 +4133,11 @@
     /* Schedule bottom half of Out Isoc completion function. This function
        finishes the URBs marked with isoc_out_done */
     comp_data = (struct crisv10_isoc_complete_data*)
-      kmem_cache_alloc(isoc_compl_cache, SLAB_ATOMIC);
+      kmem_cache_alloc(isoc_compl_cache, GFP_ATOMIC);
     ASSERT(comp_data != NULL);
     comp_data ->hcd = hcd;
 
-    INIT_WORK(&comp_data->usb_bh, complete_isoc_bottom_half, comp_data);
+    INIT_WORK(&comp_data->usb_bh, complete_isoc_bottom_half);
     schedule_work(&comp_data->usb_bh);
   }
 
@@ -4424,6 +4396,7 @@
   struct usb_hcd *hcd;
   struct crisv10_hcd *crisv10_hcd;
   int retval;
+  int rev_maj, rev_min;
 
   /* Check DMA burst length */
   if(IO_EXTRACT(R_BUS_CONFIG, dma_burst, *R_BUS_CONFIG) !=
@@ -4448,8 +4421,8 @@
 	  ETRAX_USB_RX_IRQ, ETRAX_USB_TX_IRQ);
 
   /* Print out chip version read from registers */
-  int rev_maj = *R_USB_REVISION & IO_MASK(R_USB_REVISION, major);
-  int rev_min = *R_USB_REVISION & IO_MASK(R_USB_REVISION, minor);
+  rev_maj = *R_USB_REVISION & IO_MASK(R_USB_REVISION, major);
+  rev_min = *R_USB_REVISION & IO_MASK(R_USB_REVISION, minor);
   if(rev_min == 0) {
     devdrv_info("Etrax 100LX USB Revision %d v1,2\n", rev_maj);
   } else {

--------------010002050004020002080005--
