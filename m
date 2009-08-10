Return-Path: <linux-kernel-owner+w=401wt.eu-S932169AbZHJQ3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932169AbZHJQ3K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 12:29:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932137AbZHJQ3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 12:29:09 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:64648 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932111AbZHJQ3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 12:29:04 -0400
From: Lothar Wassmann <LW@KARO-electronics.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <cooloney@kernel.org>, Mike Frysinger <vapier@gentoo.org>,
       Lothar Wassmann <LW@KARO-electronics.de>,
       Lothar Wassmann <lothar@ipc1.ka-ro>
Subject: [PATCH] Fix compiler warnings and remove debug messages
Date: Mon, 10 Aug 2009 18:28:56 +0200
Message-Id: <1249921736508-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <20090810193653.f228cf06.sfr@canb.auug.org.au>
References: <20090810193653.f228cf06.sfr@canb.auug.org.au>
In-Reply-To: <<20090810193653.f228cf06.sfr@canb.auug.org.au>>
References: <<20090810193653.f228cf06.sfr@canb.auug.org.au>>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the reported compiler warnings and removes excessive debug messages.
Compile tested only!

Signed-off-by: Lothar Wassmann <lothar@ipc1.ka-ro>
---
 drivers/usb/host/isp1362-hcd.c |  430 ++++++++++------------------------------
 drivers/usb/host/isp1362.h     |   14 +-
 2 files changed, 114 insertions(+), 330 deletions(-)

diff --git a/drivers/usb/host/isp1362-hcd.c b/drivers/usb/host/isp1362-hcd.c
index 5819e10..a35a23a 100644
--- a/drivers/usb/host/isp1362-hcd.c
+++ b/drivers/usb/host/isp1362-hcd.c
@@ -149,9 +149,7 @@ static inline struct isp1362_ep_queue *get_ptd_queue(struct isp1362_hcd *isp1362
 		   isp1362_hcd->atl_queue.buf_size)
 		epq = &isp1362_hcd->atl_queue;
 
-	if (epq)
-		DBG(1, "%s: PTD $%04x is on %s queue\n", __func__, offset, epq->name);
-	else
+	if (!epq)
 		pr_warning("%s: invalid PTD $%04x\n", __func__, offset);
 
 	return epq;
@@ -167,7 +165,6 @@ static inline int get_ptd_offset(struct isp1362_ep_queue *epq, u8 index)
 		return -EINVAL;
 	}
 	offset = epq->buf_start + index * epq->blk_size;
-	DBG(3, "%s: %s PTD[%02x] # %04x\n", __func__, epq->name, index, offset);
 
 	return offset;
 }
@@ -221,8 +218,6 @@ static int claim_ptd_buffers(struct isp1362_ep_queue *epq,
 	if (found < 0)
 		return -EOVERFLOW;
 
-	DBG(1, "%s: Found %d PTDs[%d] for %d/%d byte\n", __func__,
-	    num_ptds, found, len, (int)(epq->blk_size - PTD_HEADER_SIZE));
 	ptd_offset = get_ptd_offset(epq, found);
 	WARN_ON(ptd_offset < 0);
 	ep->ptd_offset = ptd_offset;
@@ -232,9 +227,6 @@ static int claim_ptd_buffers(struct isp1362_ep_queue *epq,
 	ep->ptd_index = found;
 	for (index = found; index < last; index++)
 		__set_bit(index, &epq->buf_map);
-	DBG(1, "%s: Done %s PTD[%d] $%04x, avail %d count %d claimed %d %08lx:%08lx\n",
-	    __func__, epq->name, ep->ptd_index, ep->ptd_offset,
-	    epq->buf_avail, epq->buf_count, num_ptds, epq->buf_map, epq->skip_map);
 
 	return found;
 }
@@ -261,12 +253,6 @@ static inline void release_ptd_buffers(struct isp1362_ep_queue *epq, struct isp1
 	BUG_ON(epq->buf_avail > epq->buf_count);
 	BUG_ON(epq->ptd_count > epq->buf_count);
 
-	DBG(1, "%s: Done %s PTDs $%04x released %d avail %d count %d\n",
-	    __func__, epq->name,
-	    ep->ptd_offset, ep->num_ptds, epq->buf_avail, epq->buf_count);
-	DBG(1, "%s: buf_map %08lx skip_map %08lx\n", __func__,
-	    epq->buf_map, epq->skip_map);
-
 	ep->num_ptds = 0;
 	ep->ptd_offset = -EINVAL;
 	ep->ptd_index = -EINVAL;
@@ -287,8 +273,6 @@ static void prepare_ptd(struct isp1362_hcd *isp1362_hcd, struct urb *urb,
 	u16 len;
 	size_t buf_len = urb->transfer_buffer_length - urb->actual_length;
 
-	DBG(3, "%s: %s ep %p\n", __func__, epq->name, ep);
-
 	ptd = &ep->ptd;
 
 	ep->data = (unsigned char *)urb->transfer_buffer + urb->actual_length;
@@ -304,8 +288,6 @@ static void prepare_ptd(struct isp1362_hcd *isp1362_hcd, struct urb *urb,
 			ep->data = urb->transfer_buffer + urb->iso_frame_desc[fno].offset;
 		} else
 			len = max_transfer_size(epq, buf_len, ep->maxpacket);
-		DBG(1, "%s: IN    len %d/%d/%d from URB\n", __func__, len, ep->maxpacket,
-		    (int)buf_len);
 		break;
 	case USB_PID_OUT:
 		toggle = usb_gettoggle(urb->dev, ep->epnum, 1);
@@ -319,14 +301,11 @@ static void prepare_ptd(struct isp1362_hcd *isp1362_hcd, struct urb *urb,
 		if (len == 0)
 			pr_info("%s: Sending ZERO packet: %d\n", __func__,
 			     urb->transfer_flags & URB_ZERO_PACKET);
-		DBG(1, "%s: OUT   len %d/%d/%d from URB\n", __func__, len, ep->maxpacket,
-		    (int)buf_len);
 		break;
 	case USB_PID_SETUP:
 		toggle = 0;
 		dir = PTD_DIR_SETUP;
 		len = sizeof(struct usb_ctrlrequest);
-		DBG(1, "%s: SETUP len %d\n", __func__, len);
 		ep->data = urb->setup_packet;
 		break;
 	case USB_PID_ACK:
@@ -334,7 +313,6 @@ static void prepare_ptd(struct isp1362_hcd *isp1362_hcd, struct urb *urb,
 		len = 0;
 		dir = (urb->transfer_buffer_length && usb_pipein(urb->pipe)) ?
 			PTD_DIR_OUT : PTD_DIR_IN;
-		DBG(1, "%s: ACK   len %d\n", __func__, len);
 		break;
 	default:
 		toggle = dir = len = 0;
@@ -358,8 +336,6 @@ static void prepare_ptd(struct isp1362_hcd *isp1362_hcd, struct urb *urb,
 	}
 	if (usb_pipeisoc(urb->pipe))
 		ptd->faddr |= PTD_SF_ISO(fno);
-
-	DBG(1, "%s: Finished\n", __func__);
 }
 
 static void isp1362_write_ptd(struct isp1362_hcd *isp1362_hcd, struct isp1362_ep *ep,
@@ -390,7 +366,6 @@ static void isp1362_read_ptd(struct isp1362_hcd *isp1362_hcd, struct isp1362_ep
 	BUG_ON(ep->ptd_offset < 0);
 
 	list_del_init(&ep->active);
-	DBG(1, "%s: ep %p removed from active list %p\n", __func__, ep, &epq->active);
 
 	prefetchw(ptd);
 	isp1362_read_buffer(isp1362_hcd, ptd, ep->ptd_offset, PTD_HEADER_SIZE);
@@ -423,7 +398,6 @@ static void remove_ptd(struct isp1362_hcd *isp1362_hcd, struct isp1362_ep *ep)
 	int index;
 	struct isp1362_ep_queue *epq;
 
-	DBG(1, "%s: ep %p PTD[%d] $%04x\n", __func__, ep, ep->ptd_index, ep->ptd_offset);
 	BUG_ON(ep->ptd_offset < 0);
 
 	epq = get_ptd_queue(isp1362_hcd, ep->ptd_offset);
@@ -440,20 +414,13 @@ static void remove_ptd(struct isp1362_hcd *isp1362_hcd, struct isp1362_ep *ep)
 		/* ISO queues don't have SKIP registers */
 		return;
 
-	DBG(1, "%s: Disabling PTD[%02x] $%04x %08lx|%08x\n", __func__,
-	    index, ep->ptd_offset, epq->skip_map, 1 << index);
-
 	/* prevent further processing of PTD (will be effective after next SOF) */
 	epq->skip_map |= 1 << index;
 	if (epq == &isp1362_hcd->atl_queue) {
-		DBG(2, "%s: ATLSKIP = %08x -> %08lx\n", __func__,
-		    isp1362_read_reg32(isp1362_hcd, HCATLSKIP), epq->skip_map);
 		isp1362_write_reg32(isp1362_hcd, HCATLSKIP, epq->skip_map);
 		if (~epq->skip_map == 0)
 			isp1362_clr_mask16(isp1362_hcd, HCBUFSTAT, HCBUFSTAT_ATL_ACTIVE);
 	} else if (epq == &isp1362_hcd->intl_queue) {
-		DBG(2, "%s: INTLSKIP = %08x -> %08lx\n", __func__,
-		    isp1362_read_reg32(isp1362_hcd, HCINTLSKIP), epq->skip_map);
 		isp1362_write_reg32(isp1362_hcd, HCINTLSKIP, epq->skip_map);
 		if (~epq->skip_map == 0)
 			isp1362_clr_mask16(isp1362_hcd, HCBUFSTAT, HCBUFSTAT_INTL_ACTIVE);
@@ -506,10 +473,6 @@ static void finish_request(struct isp1362_hcd *isp1362_hcd, struct isp1362_ep *e
 
 	if (ep->interval) {
 		/* periodic deschedule */
-		DBG(1, "deschedule qh%d/%p branch %d load %d bandwidth %d -> %d\n", ep->interval,
-		    ep, ep->branch, ep->load,
-		    isp1362_hcd->load[ep->branch],
-		    isp1362_hcd->load[ep->branch] - ep->load);
 		isp1362_hcd->load[ep->branch] -= ep->load;
 		ep->branch = PERIODIC_SIZE;
 	}
@@ -528,14 +491,12 @@ static void postproc_ep(struct isp1362_hcd *isp1362_hcd, struct isp1362_ep *ep)
 	int urbstat = -EINPROGRESS;
 	u8 cc;
 
-	DBG(2, "%s: ep %p req %d\n", __func__, ep, ep->num_req);
-
 	udev = urb->dev;
 	ptd = &ep->ptd;
 	cc = PTD_GET_CC(ptd);
 	if (cc == PTD_NOTACCESSED) {
-		pr_err("%s: req %d PTD %p Untouched by ISP1362\n", __func__,
-		    ep->num_req, ptd);
+		dev_err(&udev->dev, "%s: req %d PTD %p Untouched by ISP1362\n", __func__,
+			ep->num_req, ptd);
 		cc = PTD_DEVNOTRESP;
 	}
 
@@ -550,17 +511,15 @@ static void postproc_ep(struct isp1362_hcd *isp1362_hcd, struct isp1362_ep *ep)
 	*/
 	if (cc == PTD_DATAUNDERRUN) {
 		if (short_ok) {
-			DBG(1, "%s: req %d Allowed data underrun short_%sok %d/%d/%d byte\n",
-			    __func__, ep->num_req, short_ok ? "" : "not_",
-			    PTD_GET_COUNT(ptd), ep->maxpacket, len);
 			cc = PTD_CC_NOERROR;
 			urbstat = 0;
 		} else {
-			DBG(1, "%s: req %d Data Underrun %s nextpid %02x short_%sok %d/%d/%d byte\n",
-			    __func__, ep->num_req,
-			    usb_pipein(urb->pipe) ? "IN" : "OUT", ep->nextpid,
-			    short_ok ? "" : "not_",
-			    PTD_GET_COUNT(ptd), ep->maxpacket, len);
+			dev_warn(&udev->dev,
+				 "req %d Data Underrun %s nextpid %02x short_%sok %d/%d/%d byte\n",
+				 ep->num_req,
+				 usb_pipein(urb->pipe) ? "IN" : "OUT",
+				 ep->nextpid, short_ok ? "" : "not_",
+				 PTD_GET_COUNT(ptd), ep->maxpacket, len);
 			if (usb_pipecontrol(urb->pipe)) {
 				ep->nextpid = USB_PID_ACK;
 				/* save the data underrun error code for later and
@@ -583,8 +542,9 @@ static void postproc_ep(struct isp1362_hcd *isp1362_hcd, struct isp1362_ep *ep)
 	if (cc != PTD_CC_NOERROR) {
 		if (++ep->error_count >= 3 || cc == PTD_CC_STALL || cc == PTD_DATAOVERRUN) {
 			urbstat = cc_to_error[cc];
-			DBG(1, "%s: req %d nextpid %02x, status %d, error %d, error_count %d\n",
-			    __func__, ep->num_req, ep->nextpid, urbstat, cc,
+			dev_dbg(&udev->dev,
+				"req %d nextpid %02x, status %d, error %d, error_count %d\n",
+				ep->num_req, ep->nextpid, urbstat, cc,
 			    ep->error_count);
 		}
 		goto out;
@@ -600,22 +560,11 @@ static void postproc_ep(struct isp1362_hcd *isp1362_hcd, struct isp1362_ep *ep)
 		BUG_ON(urb->actual_length > urb->transfer_buffer_length);
 		usb_settoggle(udev, ep->epnum, 1, PTD_GET_TOGGLE(ptd));
 		if (urb->actual_length == urb->transfer_buffer_length) {
-			DBG(3, "%s: req %d xfer complete %d/%d status %d -> 0\n", __func__,
-			    ep->num_req, len, ep->maxpacket, urbstat);
-			if (usb_pipecontrol(urb->pipe)) {
-				DBG(3, "%s: req %d %s Wait for ACK\n", __func__,
-				    ep->num_req,
-				    usb_pipein(urb->pipe) ? "IN" : "OUT");
+			if (usb_pipecontrol(urb->pipe))
 				ep->nextpid = USB_PID_ACK;
-			} else {
-				if (len % ep->maxpacket ||
-				    !(urb->transfer_flags & URB_ZERO_PACKET)) {
-					urbstat = 0;
-					DBG(3, "%s: req %d URB %s status %d count %d/%d/%d\n",
-					    __func__, ep->num_req, usb_pipein(urb->pipe) ? "IN" : "OUT",
-					    urbstat, len, ep->maxpacket, urb->actual_length);
-				}
-			}
+			else if (len % ep->maxpacket ||
+				 !(urb->transfer_flags & URB_ZERO_PACKET))
+				urbstat = 0;
 		}
 		break;
 	case USB_PID_IN:
@@ -627,19 +576,10 @@ static void postproc_ep(struct isp1362_hcd *isp1362_hcd, struct isp1362_ep *ep)
 		/* if transfer completed or (allowed) data underrun */
 		if ((urb->transfer_buffer_length == urb->actual_length) ||
 		    len % ep->maxpacket) {
-			DBG(3, "%s: req %d xfer complete %d/%d status %d -> 0\n", __func__,
-			    ep->num_req, len, ep->maxpacket, urbstat);
-			if (usb_pipecontrol(urb->pipe)) {
-				DBG(3, "%s: req %d %s Wait for ACK\n", __func__,
-				    ep->num_req,
-				    usb_pipein(urb->pipe) ? "IN" : "OUT");
+			if (usb_pipecontrol(urb->pipe))
 				ep->nextpid = USB_PID_ACK;
-			} else {
+			else
 				urbstat = 0;
-				DBG(3, "%s: req %d URB %s status %d count %d/%d/%d\n",
-				    __func__, ep->num_req, usb_pipein(urb->pipe) ? "IN" : "OUT",
-				    urbstat, len, ep->maxpacket, urb->actual_length);
-			}
 		}
 		break;
 	case USB_PID_SETUP:
@@ -654,22 +594,17 @@ static void postproc_ep(struct isp1362_hcd *isp1362_hcd, struct isp1362_ep *ep)
 		}
 		break;
 	case USB_PID_ACK:
-		DBG(3, "%s: req %d got ACK %d -> 0\n", __func__, ep->num_req,
-		    urbstat);
 		WARN_ON(urbstat != -EINPROGRESS);
 		urbstat = 0;
 		ep->nextpid = 0;
 		break;
 	default:
-		BUG_ON(1);
+		BUG();
 	}
 
  out:
-	if (urbstat != -EINPROGRESS) {
-		DBG(2, "%s: Finishing ep %p req %d urb %p status %d\n", __func__,
-		    ep, ep->num_req, urb, urbstat);
+	if (urbstat != -EINPROGRESS)
 		finish_request(isp1362_hcd, ep, urb, urbstat);
-	}
 }
 
 static void finish_unlinks(struct isp1362_hcd *isp1362_hcd)
@@ -684,26 +619,19 @@ static void finish_unlinks(struct isp1362_hcd *isp1362_hcd)
 
 		BUG_ON(epq == NULL);
 		if (index >= 0) {
-			DBG(1, "%s: remove PTD[%d] $%04x\n", __func__, index, ep->ptd_offset);
 			BUG_ON(ep->num_ptds == 0);
 			release_ptd_buffers(epq, ep);
 		}
 		if (!list_empty(&ep->hep->urb_list)) {
 			struct urb *urb = get_urb(ep);
 
-			DBG(1, "%s: Finishing req %d ep %p from remove_list\n", __func__,
-			    ep->num_req, ep);
 			finish_request(isp1362_hcd, ep, urb, -ESHUTDOWN);
 		}
 		WARN_ON(list_empty(&ep->active));
-		if (!list_empty(&ep->active)) {
+		if (!list_empty(&ep->active))
 			list_del_init(&ep->active);
-			DBG(1, "%s: ep %p removed from active list\n", __func__, ep);
-		}
 		list_del_init(&ep->remove_list);
-		DBG(1, "%s: ep %p removed from remove_list\n", __func__, ep);
 	}
-	DBG(1, "%s: Done\n", __func__);
 }
 
 static inline void enable_atl_transfers(struct isp1362_hcd *isp1362_hcd, int count)
@@ -736,25 +664,25 @@ static int submit_req(struct isp1362_hcd *isp1362_hcd, struct urb *urb,
 		      struct isp1362_ep *ep, struct isp1362_ep_queue *epq)
 {
 	int index = epq->free_ptd;
+	struct usb_device *udev = urb->dev;
 
 	prepare_ptd(isp1362_hcd, urb, ep, epq, 0);
 	index = claim_ptd_buffers(epq, ep, ep->length);
 	if (index == -ENOMEM) {
-		DBG(1, "%s: req %d No free %s PTD available: %d, %08lx:%08lx\n", __func__,
-		    ep->num_req, epq->name, ep->num_ptds, epq->buf_map, epq->skip_map);
+		dev_err(&udev->dev,
+			"req %d: no free %s PTD available: %d, %08lx:%08lx\n",
+			ep->num_req, epq->name, ep->num_ptds,
+			epq->buf_map, epq->skip_map);
 		return index;
 	} else if (index == -EOVERFLOW) {
-		DBG(1, "%s: req %d Not enough space for %d byte %s PTD %d %08lx:%08lx\n",
-		    __func__, ep->num_req, ep->length, epq->name, ep->num_ptds,
-		    epq->buf_map, epq->skip_map);
+		dev_err(&udev->dev,
+			"req %d: not enough space for %d byte %s PTD %d %08lx:%08lx\n",
+			ep->num_req, ep->length, epq->name, ep->num_ptds,
+			epq->buf_map, epq->skip_map);
 		return index;
 	} else
 		BUG_ON(index < 0);
 	list_add_tail(&ep->active, &epq->active);
-	DBG(1, "%s: ep %p req %d len %d added to active list %p\n", __func__,
-	    ep, ep->num_req, ep->length, &epq->active);
-	DBG(1, "%s: Submitting %s PTD $%04x for ep %p req %d\n", __func__, epq->name,
-	    ep->ptd_offset, ep, ep->num_req);
 	isp1362_write_ptd(isp1362_hcd, ep, epq);
 	__clear_bit(ep->ptd_index, &epq->skip_map);
 
@@ -769,7 +697,7 @@ static void start_atl_transfers(struct isp1362_hcd *isp1362_hcd)
 	int defer = 0;
 
 	if (atomic_read(&epq->finishing)) {
-		DBG(1, "%s: finish_transfers is active for %s\n", __func__, epq->name);
+		pr_warning("finish_transfers is active for %s\n", epq->name);
 		return;
 	}
 
@@ -778,13 +706,9 @@ static void start_atl_transfers(struct isp1362_hcd *isp1362_hcd)
 		int ret;
 
 		if (!list_empty(&ep->active)) {
-			DBG(2, "%s: Skipping active %s ep %p\n", __func__, epq->name, ep);
 			continue;
 		}
 
-		DBG(1, "%s: Processing %s ep %p req %d\n", __func__, epq->name,
-		    ep, ep->num_req);
-
 		ret = submit_req(isp1362_hcd, urb, ep, epq);
 		if (ret == -ENOMEM) {
 			defer = 1;
@@ -800,18 +724,15 @@ static void start_atl_transfers(struct isp1362_hcd *isp1362_hcd)
 	}
 
 	/* Avoid starving of endpoints */
-	if (isp1362_hcd->async.next != isp1362_hcd->async.prev) {
-		DBG(2, "%s: Cycling ASYNC schedule %d\n", __func__, ptd_count);
+	if (isp1362_hcd->async.next != isp1362_hcd->async.prev)
 		list_move(&isp1362_hcd->async, isp1362_hcd->async.next);
-	}
+
 	if (ptd_count || defer)
 		enable_atl_transfers(isp1362_hcd, defer ? 0 : ptd_count);
 
 	epq->ptd_count += ptd_count;
-	if (epq->ptd_count > epq->stat_maxptds) {
+	if (epq->ptd_count > epq->stat_maxptds)
 		epq->stat_maxptds = epq->ptd_count;
-		DBG(0, "%s: max_ptds: %d\n", __func__, epq->stat_maxptds);
-	}
 }
 
 static void start_intl_transfers(struct isp1362_hcd *isp1362_hcd)
@@ -821,7 +742,7 @@ static void start_intl_transfers(struct isp1362_hcd *isp1362_hcd)
 	struct isp1362_ep *ep;
 
 	if (atomic_read(&epq->finishing)) {
-		DBG(1, "%s: finish_transfers is active for %s\n", __func__, epq->name);
+		pr_warning("finish_transfers is active for %s\n", epq->name);
 		return;
 	}
 
@@ -829,14 +750,9 @@ static void start_intl_transfers(struct isp1362_hcd *isp1362_hcd)
 		struct urb *urb = get_urb(ep);
 		int ret;
 
-		if (!list_empty(&ep->active)) {
-			DBG(1, "%s: Skipping active %s ep %p\n", __func__,
-			    epq->name, ep);
+		if (!list_empty(&ep->active))
 			continue;
-		}
 
-		DBG(1, "%s: Processing %s ep %p req %d\n", __func__,
-		    epq->name, ep, ep->num_req);
 		ret = submit_req(isp1362_hcd, urb, ep, epq);
 		if (ret == -ENOMEM)
 			break;
@@ -848,10 +764,9 @@ static void start_intl_transfers(struct isp1362_hcd *isp1362_hcd)
 	if (ptd_count) {
 		static int last_count;
 
-		if (ptd_count != last_count) {
-			DBG(0, "%s: ptd_count: %d\n", __func__, ptd_count);
+		if (ptd_count != last_count)
 			last_count = ptd_count;
-		}
+
 		enable_intl_transfers(isp1362_hcd);
 	}
 
@@ -865,9 +780,6 @@ static inline int next_ptd(struct isp1362_ep_queue *epq, struct isp1362_ep *ep)
 	u16 ptd_offset = ep->ptd_offset;
 	int num_ptds = (ep->length + PTD_HEADER_SIZE + (epq->blk_size - 1)) / epq->blk_size;
 
-	DBG(2, "%s: PTD offset $%04x + %04x => %d * %04x -> $%04x\n", __func__, ptd_offset,
-	    ep->length, num_ptds, epq->blk_size, ptd_offset + num_ptds * epq->blk_size);
-
 	ptd_offset += num_ptds * epq->blk_size;
 	if (ptd_offset < epq->buf_start + epq->buf_size)
 		return ptd_offset;
@@ -888,7 +800,7 @@ static void start_iso_transfers(struct isp1362_hcd *isp1362_hcd)
  fill2:
 	epq = &isp1362_hcd->istl_queue[flip];
 	if (atomic_read(&epq->finishing)) {
-		DBG(1, "%s: finish_transfers is active for %s\n", __func__, epq->name);
+		pr_warning("finish_transfers is active for %s\n", epq->name);
 		return;
 	}
 
@@ -898,9 +810,9 @@ static void start_iso_transfers(struct isp1362_hcd *isp1362_hcd)
 	ptd_offset = epq->buf_start;
 	list_for_each_entry_safe(ep, tmp, &isp1362_hcd->isoc, schedule) {
 		struct urb *urb = get_urb(ep);
-		s16 diff = fno - (u16)urb->start_frame;
+		struct usb_device *udev = urb->dev;
 
-		DBG(1, "%s: Processing %s ep %p\n", __func__, epq->name, ep);
+		s16 diff = fno - (u16)urb->start_frame;
 
 		if (diff > urb->number_of_packets) {
 			/* time frame for this URB has elapsed */
@@ -917,8 +829,9 @@ static void start_iso_transfers(struct isp1362_hcd *isp1362_hcd)
 			prepare_ptd(isp1362_hcd, urb, ep, epq, fno);
 			if (ptd_offset + PTD_HEADER_SIZE + ep->length >
 			    epq->buf_start + epq->buf_size) {
-				pr_err("%s: Not enough ISO buffer space for %d byte PTD\n",
-				    __func__, ep->length);
+				dev_err(&udev->dev,
+					"Not enough ISO buffer space for %d byte PTD\n",
+					ep->length);
 				continue;
 			}
 			ep->ptd_offset = ptd_offset;
@@ -962,20 +875,13 @@ static void finish_transfers(struct isp1362_hcd *isp1362_hcd, unsigned long done
 	struct isp1362_ep *ep;
 	struct isp1362_ep *tmp;
 
-	if (list_empty(&epq->active)) {
-		DBG(1, "%s: Nothing to do for %s queue\n", __func__, epq->name);
+	if (list_empty(&epq->active))
 		return;
-	}
-
-	DBG(1, "%s: Finishing %s transfers %08lx\n", __func__, epq->name, done_map);
 
 	atomic_inc(&epq->finishing);
 	list_for_each_entry_safe(ep, tmp, &epq->active, active) {
 		int index = ep->ptd_index;
 
-		DBG(1, "%s: Checking %s PTD[%02x] $%04x\n", __func__, epq->name,
-		    index, ep->ptd_offset);
-
 		BUG_ON(index < 0);
 		if (__test_and_clear_bit(index, &done_map)) {
 			isp1362_read_ptd(isp1362_hcd, ep, epq);
@@ -983,14 +889,9 @@ static void finish_transfers(struct isp1362_hcd *isp1362_hcd, unsigned long done
 			BUG_ON(ep->num_ptds == 0);
 			release_ptd_buffers(epq, ep);
 
-			DBG(1, "%s: ep %p req %d removed from active list\n", __func__,
-			    ep, ep->num_req);
-			if (!list_empty(&ep->remove_list)) {
+			if (!list_empty(&ep->remove_list))
 				list_del_init(&ep->remove_list);
-				DBG(1, "%s: ep %p removed from remove list\n", __func__, ep);
-			}
-			DBG(1, "%s: Postprocessing %s ep %p req %d\n", __func__, epq->name,
-			    ep, ep->num_req);
+
 			postproc_ep(isp1362_hcd, ep);
 		}
 		if (!done_map)
@@ -1007,19 +908,12 @@ static void finish_iso_transfers(struct isp1362_hcd *isp1362_hcd, struct isp1362
 	struct isp1362_ep *ep;
 	struct isp1362_ep *tmp;
 
-	if (list_empty(&epq->active)) {
-		DBG(1, "%s: Nothing to do for %s queue\n", __func__, epq->name);
+	if (list_empty(&epq->active))
 		return;
-	}
-
-	DBG(1, "%s: Finishing %s transfers\n", __func__, epq->name);
 
 	atomic_inc(&epq->finishing);
 	list_for_each_entry_safe(ep, tmp, &epq->active, active) {
-		DBG(1, "%s: Checking PTD $%04x\n", __func__, ep->ptd_offset);
-
 		isp1362_read_ptd(isp1362_hcd, ep, epq);
-		DBG(1, "%s: Postprocessing %s ep %p\n", __func__, epq->name, ep);
 		postproc_ep(isp1362_hcd, ep);
 	}
 	WARN_ON(epq->blk_size != 0);
@@ -1040,7 +934,6 @@ static irqreturn_t isp1362_irq(struct usb_hcd *hcd)
 	isp1362_write_reg16(isp1362_hcd, HCuPINTENB, 0);
 
 	irqstat = isp1362_read_reg16(isp1362_hcd, HCuPINT);
-	DBG(3, "%s: got IRQ %04x:%04x\n", __func__, irqstat, isp1362_hcd->irqenb);
 
 	/* only handle interrupts that are currently enabled */
 	irqstat &= isp1362_hcd->irqenb;
@@ -1052,7 +945,6 @@ static irqreturn_t isp1362_irq(struct usb_hcd *hcd)
 		isp1362_hcd->irq_stat[ISP1362_INT_SOF]++;
 		handled = 1;
 		svc_mask &= ~HCuPINT_SOF;
-		DBG(3, "%s: SOF\n", __func__);
 		isp1362_hcd->fmindex = isp1362_read_reg32(isp1362_hcd, HCFMNUM);
 		if (!list_empty(&isp1362_hcd->remove_list))
 			finish_unlinks(isp1362_hcd);
@@ -1073,10 +965,9 @@ static irqreturn_t isp1362_irq(struct usb_hcd *hcd)
 		handled = 1;
 		svc_mask &= ~HCuPINT_ISTL0;
 		isp1362_clr_mask16(isp1362_hcd, HCBUFSTAT, HCBUFSTAT_ISTL0_FULL);
-		DBG(1, "%s: ISTL0\n", __func__);
 		WARN_ON((int)!!isp1362_hcd->istl_flip);
 		WARN_ON(isp1362_read_reg16(isp1362_hcd, HCBUFSTAT) & HCBUFSTAT_ISTL0_ACTIVE);
-		WARN_ON(!isp1362_read_reg16(isp1362_hcd, HCBUFSTAT) & HCBUFSTAT_ISTL0_DONE);
+		WARN_ON(!(isp1362_read_reg16(isp1362_hcd, HCBUFSTAT) & HCBUFSTAT_ISTL0_DONE));
 		isp1362_hcd->irqenb &= ~HCuPINT_ISTL0;
 	}
 
@@ -1085,10 +976,9 @@ static irqreturn_t isp1362_irq(struct usb_hcd *hcd)
 		handled = 1;
 		svc_mask &= ~HCuPINT_ISTL1;
 		isp1362_clr_mask16(isp1362_hcd, HCBUFSTAT, HCBUFSTAT_ISTL1_FULL);
-		DBG(1, "%s: ISTL1\n", __func__);
 		WARN_ON(!(int)isp1362_hcd->istl_flip);
 		WARN_ON(isp1362_read_reg16(isp1362_hcd, HCBUFSTAT) & HCBUFSTAT_ISTL1_ACTIVE);
-		WARN_ON(!isp1362_read_reg16(isp1362_hcd, HCBUFSTAT) & HCBUFSTAT_ISTL1_DONE);
+		WARN_ON(!(isp1362_read_reg16(isp1362_hcd, HCBUFSTAT) & HCBUFSTAT_ISTL1_DONE));
 		isp1362_hcd->irqenb &= ~HCuPINT_ISTL1;
 	}
 
@@ -1106,8 +996,6 @@ static irqreturn_t isp1362_irq(struct usb_hcd *hcd)
 		u32 skip_map = isp1362_read_reg32(isp1362_hcd, HCINTLSKIP);
 		isp1362_hcd->irq_stat[ISP1362_INT_INTL]++;
 
-		DBG(2, "%s: INTL\n", __func__);
-
 		svc_mask &= ~HCuPINT_INTL;
 
 		isp1362_write_reg32(isp1362_hcd, HCINTLSKIP, skip_map | done_map);
@@ -1118,7 +1006,6 @@ static irqreturn_t isp1362_irq(struct usb_hcd *hcd)
 		handled = 1;
 		WARN_ON(!done_map);
 		if (done_map) {
-			DBG(3, "%s: INTL done_map %08x\n", __func__, done_map);
 			finish_transfers(isp1362_hcd, done_map, &isp1362_hcd->intl_queue);
 			start_intl_transfers(isp1362_hcd);
 		}
@@ -1129,15 +1016,12 @@ static irqreturn_t isp1362_irq(struct usb_hcd *hcd)
 		u32 skip_map = isp1362_read_reg32(isp1362_hcd, HCATLSKIP);
 		isp1362_hcd->irq_stat[ISP1362_INT_ATL]++;
 
-		DBG(2, "%s: ATL\n", __func__);
-
 		svc_mask &= ~HCuPINT_ATL;
 
 		isp1362_write_reg32(isp1362_hcd, HCATLSKIP, skip_map | done_map);
 		if (~(done_map | skip_map) == 0)
 			isp1362_clr_mask16(isp1362_hcd, HCBUFSTAT, HCBUFSTAT_ATL_ACTIVE);
 		if (done_map) {
-			DBG(3, "%s: ATL done_map %08x\n", __func__, done_map);
 			finish_transfers(isp1362_hcd, done_map, &isp1362_hcd->atl_queue);
 			start_atl_transfers(isp1362_hcd);
 		}
@@ -1149,10 +1033,9 @@ static irqreturn_t isp1362_irq(struct usb_hcd *hcd)
 		isp1362_hcd->irq_stat[ISP1362_INT_OPR]++;
 
 		svc_mask &= ~HCuPINT_OPR;
-		DBG(2, "%s: OPR %08x:%08x\n", __func__, intstat, isp1362_hcd->intenb);
 		intstat &= isp1362_hcd->intenb;
 		if (intstat & OHCI_INTR_UE) {
-			pr_err("Unrecoverable error\n");
+			pr_err("%s: Unrecoverable error\n", __func__);
 			/* FIXME: do here reset or cleanup or whatever */
 		}
 		if (intstat & OHCI_INTR_RHSC) {
@@ -1161,7 +1044,7 @@ static irqreturn_t isp1362_irq(struct usb_hcd *hcd)
 			isp1362_hcd->rhport[1] = isp1362_read_reg32(isp1362_hcd, HCRHPORT2);
 		}
 		if (intstat & OHCI_INTR_RD) {
-			pr_info("%s: RESUME DETECTED\n", __func__);
+			pr_debug("%s: RESUME DETECTED\n", __func__);
 			isp1362_show_reg(isp1362_hcd, HCCONTROL);
 			usb_hcd_resume_root_hub(hcd);
 		}
@@ -1175,7 +1058,7 @@ static irqreturn_t isp1362_irq(struct usb_hcd *hcd)
 		handled = 1;
 		svc_mask &= ~HCuPINT_SUSP;
 
-		pr_info("%s: SUSPEND IRQ\n", __func__);
+		pr_debug("%s: SUSPEND IRQ\n", __func__);
 	}
 
 	if (irqstat & HCuPINT_CLKRDY) {
@@ -1246,8 +1129,6 @@ static int isp1362_urb_enqueue(struct usb_hcd *hcd,
 	unsigned long flags;
 	int retval = 0;
 
-	DBG(3, "%s: urb %p\n", __func__, urb);
-
 	if (type == PIPE_ISOCHRONOUS) {
 		pr_err("Isochronous transfers not supported\n");
 		return -ENOSPC;
@@ -1329,11 +1210,8 @@ static int isp1362_urb_enqueue(struct usb_hcd *hcd,
 	switch (type) {
 	case PIPE_CONTROL:
 	case PIPE_BULK:
-		if (list_empty(&ep->schedule)) {
-			DBG(1, "%s: Adding ep %p req %d to async schedule\n",
-				__func__, ep, ep->num_req);
+		if (list_empty(&ep->schedule))
 			list_add_tail(&ep->schedule, &isp1362_hcd->async);
-		}
 		break;
 	case PIPE_ISOCHRONOUS:
 	case PIPE_INTERRUPT:
@@ -1351,11 +1229,6 @@ static int isp1362_urb_enqueue(struct usb_hcd *hcd,
 		ep->branch = retval;
 		retval = 0;
 		isp1362_hcd->fmindex = isp1362_read_reg32(isp1362_hcd, HCFMNUM);
-		DBG(1, "%s: Current frame %04x branch %02x start_frame %04x(%04x)\n",
-		    __func__, isp1362_hcd->fmindex, ep->branch,
-		    ((isp1362_hcd->fmindex + PERIODIC_SIZE - 1) &
-		     ~(PERIODIC_SIZE - 1)) + ep->branch,
-		    (isp1362_hcd->fmindex & (PERIODIC_SIZE - 1)) + ep->branch);
 
 		if (list_empty(&ep->schedule)) {
 			if (type == PIPE_ISOCHRONOUS) {
@@ -1368,18 +1241,15 @@ static int isp1362_urb_enqueue(struct usb_hcd *hcd,
 					frame += ep->interval;
 				urb->start_frame = frame;
 
-				DBG(1, "%s: Adding ep %p to isoc schedule\n", __func__, ep);
 				list_add_tail(&ep->schedule, &isp1362_hcd->isoc);
-			} else {
-				DBG(1, "%s: Adding ep %p to periodic schedule\n", __func__, ep);
+			} else
 				list_add_tail(&ep->schedule, &isp1362_hcd->periodic);
-			}
 		} else
-			DBG(1, "%s: ep %p already scheduled\n", __func__, ep);
+			dev_dbg(&udev->dev, "ep %p already scheduled\n", ep);
 
-		DBG(2, "%s: load %d bandwidth %d -> %d\n", __func__,
-		    ep->load / ep->interval, isp1362_hcd->load[ep->branch],
-		    isp1362_hcd->load[ep->branch] + ep->load);
+		dev_dbg(&udev->dev, "load %d bandwidth %d -> %d\n",
+			ep->load / ep->interval, isp1362_hcd->load[ep->branch],
+			isp1362_hcd->load[ep->branch] + ep->load);
 		isp1362_hcd->load[ep->branch] += ep->load;
 	}
 
@@ -1407,8 +1277,6 @@ static int isp1362_urb_enqueue(struct usb_hcd *hcd,
 
  fail_not_linked:
 	spin_unlock_irqrestore(&isp1362_hcd->lock, flags);
-	if (retval)
-		DBG(0, "%s: urb %p failed with %d\n", __func__, urb, retval);
 	return retval;
 }
 
@@ -1420,18 +1288,15 @@ static int isp1362_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status)
 	struct isp1362_ep *ep;
 	int retval = 0;
 
-	DBG(3, "%s: urb %p\n", __func__, urb);
-
 	spin_lock_irqsave(&isp1362_hcd->lock, flags);
 	retval = usb_hcd_check_unlink_urb(hcd, urb, status);
 	if (retval)
 		goto done;
 
 	hep = urb->hcpriv;
-
 	if (!hep) {
-		spin_unlock_irqrestore(&isp1362_hcd->lock, flags);
-		return -EIDRM;
+		retval = -EIDRM;
+		goto done;
 	}
 
 	ep = hep->hcpriv;
@@ -1439,28 +1304,21 @@ static int isp1362_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status)
 		/* In front of queue? */
 		if (ep->hep->urb_list.next == &urb->urb_list) {
 			if (!list_empty(&ep->active)) {
-				DBG(1, "%s: urb %p ep %p req %d active PTD[%d] $%04x\n", __func__,
-				    urb, ep, ep->num_req, ep->ptd_index, ep->ptd_offset);
 				/* disable processing and queue PTD for removal */
 				remove_ptd(isp1362_hcd, ep);
 				urb = NULL;
 			}
 		}
-		if (urb) {
-			DBG(1, "%s: Finishing ep %p req %d\n", __func__, ep,
-			    ep->num_req);
+		if (urb)
 			finish_request(isp1362_hcd, ep, urb, status);
-		} else
-			DBG(1, "%s: urb %p active; wait4irq\n", __func__, urb);
 	} else {
-		pr_warning("%s: No EP in URB %p\n", __func__, urb);
+		struct usb_device *udev = urb->dev;
+
+		dev_warn(&udev->dev, "No EP in URB %p\n", urb);
 		retval = -EINVAL;
 	}
 done:
 	spin_unlock_irqrestore(&isp1362_hcd->lock, flags);
-
-	DBG(3, "%s: exit\n", __func__);
-
 	return retval;
 }
 
@@ -1470,16 +1328,14 @@ static void isp1362_endpoint_disable(struct usb_hcd *hcd, struct usb_host_endpoi
 	struct isp1362_hcd *isp1362_hcd = hcd_to_isp1362_hcd(hcd);
 	unsigned long flags;
 
-	DBG(1, "%s: ep %p\n", __func__, ep);
 	if (!ep)
 		return;
 	spin_lock_irqsave(&isp1362_hcd->lock, flags);
 	if (!list_empty(&hep->urb_list)) {
 		if (!list_empty(&ep->active) && list_empty(&ep->remove_list)) {
-			DBG(1, "%s: Removing ep %p req %d PTD[%d] $%04x\n", __func__,
-			    ep, ep->num_req, ep->ptd_index, ep->ptd_offset);
 			remove_ptd(isp1362_hcd, ep);
-			pr_info("%s: Waiting for Interrupt to clean up\n", __func__);
+			dev_dbg(&ep->udev->dev,
+				"Waiting for interrupt to clean up\n");
 		}
 	}
 	spin_unlock_irqrestore(&isp1362_hcd->lock, flags);
@@ -1487,8 +1343,6 @@ static void isp1362_endpoint_disable(struct usb_hcd *hcd, struct usb_host_endpoi
 	while (!list_empty(&ep->active))
 		msleep(1);
 
-	DBG(1, "%s: Freeing EP %p\n", __func__, ep);
-
 	usb_put_dev(ep->udev);
 	kfree(ep);
 	hep->hcpriv = NULL;
@@ -1556,21 +1410,16 @@ static void isp1362_hub_descriptor(struct isp1362_hcd *isp1362_hcd,
 {
 	u32 reg = isp1362_hcd->rhdesca;
 
-	DBG(3, "%s: enter\n", __func__);
-
 	desc->bDescriptorType = 0x29;
 	desc->bDescLength = 9;
 	desc->bHubContrCurrent = 0;
 	desc->bNbrPorts = reg & 0x3;
 	/* Power switching, device type, overcurrent. */
 	desc->wHubCharacteristics = cpu_to_le16((reg >> 8) & 0x1f);
-	DBG(0, "%s: hubcharacteristics = %02x\n", __func__, cpu_to_le16((reg >> 8) & 0x1f));
 	desc->bPwrOn2PwrGood = (reg >> 24) & 0xff;
 	/* two bitmaps:  ports removable, and legacy PortPwrCtrlMask */
 	desc->bitmap[0] = desc->bNbrPorts == 1 ? 1 << 1 : 3 << 1;
 	desc->bitmap[1] = ~0;
-
-	DBG(3, "%s: exit\n", __func__);
 }
 
 /* Adapted from ohci-hub.c */
@@ -1586,86 +1435,66 @@ static int isp1362_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 
 	switch (typeReq) {
 	case ClearHubFeature:
-		DBG(0, "ClearHubFeature: ");
 		switch (wValue) {
 		case C_HUB_OVER_CURRENT:
-			_DBG(0, "C_HUB_OVER_CURRENT\n");
 			spin_lock_irqsave(&isp1362_hcd->lock, flags);
 			isp1362_write_reg32(isp1362_hcd, HCRHSTATUS, RH_HS_OCIC);
 			spin_unlock_irqrestore(&isp1362_hcd->lock, flags);
 		case C_HUB_LOCAL_POWER:
-			_DBG(0, "C_HUB_LOCAL_POWER\n");
 			break;
 		default:
 			goto error;
 		}
 		break;
 	case SetHubFeature:
-		DBG(0, "SetHubFeature: ");
 		switch (wValue) {
 		case C_HUB_OVER_CURRENT:
 		case C_HUB_LOCAL_POWER:
-			_DBG(0, "C_HUB_OVER_CURRENT or C_HUB_LOCAL_POWER\n");
 			break;
 		default:
 			goto error;
 		}
 		break;
 	case GetHubDescriptor:
-		DBG(0, "GetHubDescriptor\n");
 		isp1362_hub_descriptor(isp1362_hcd, (struct usb_hub_descriptor *)buf);
 		break;
 	case GetHubStatus:
-		DBG(0, "GetHubStatus\n");
 		put_unaligned(cpu_to_le32(0), (__le32 *) buf);
 		break;
 	case GetPortStatus:
-#ifndef VERBOSE
-		DBG(0, "GetPortStatus\n");
-#endif
 		if (!wIndex || wIndex > ports)
 			goto error;
 		tmp = isp1362_hcd->rhport[--wIndex];
 		put_unaligned(cpu_to_le32(tmp), (__le32 *) buf);
 		break;
 	case ClearPortFeature:
-		DBG(0, "ClearPortFeature: ");
 		if (!wIndex || wIndex > ports)
 			goto error;
 		wIndex--;
 
 		switch (wValue) {
 		case USB_PORT_FEAT_ENABLE:
-			_DBG(0, "USB_PORT_FEAT_ENABLE\n");
 			tmp = RH_PS_CCS;
 			break;
 		case USB_PORT_FEAT_C_ENABLE:
-			_DBG(0, "USB_PORT_FEAT_C_ENABLE\n");
 			tmp = RH_PS_PESC;
 			break;
 		case USB_PORT_FEAT_SUSPEND:
-			_DBG(0, "USB_PORT_FEAT_SUSPEND\n");
 			tmp = RH_PS_POCI;
 			break;
 		case USB_PORT_FEAT_C_SUSPEND:
-			_DBG(0, "USB_PORT_FEAT_C_SUSPEND\n");
 			tmp = RH_PS_PSSC;
 			break;
 		case USB_PORT_FEAT_POWER:
-			_DBG(0, "USB_PORT_FEAT_POWER\n");
 			tmp = RH_PS_LSDA;
-
 			break;
 		case USB_PORT_FEAT_C_CONNECTION:
-			_DBG(0, "USB_PORT_FEAT_C_CONNECTION\n");
 			tmp = RH_PS_CSC;
 			break;
 		case USB_PORT_FEAT_C_OVER_CURRENT:
-			_DBG(0, "USB_PORT_FEAT_C_OVER_CURRENT\n");
 			tmp = RH_PS_OCIC;
 			break;
 		case USB_PORT_FEAT_C_RESET:
-			_DBG(0, "USB_PORT_FEAT_C_RESET\n");
 			tmp = RH_PS_PRSC;
 			break;
 		default:
@@ -1679,13 +1508,11 @@ static int isp1362_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 		spin_unlock_irqrestore(&isp1362_hcd->lock, flags);
 		break;
 	case SetPortFeature:
-		DBG(0, "SetPortFeature: ");
 		if (!wIndex || wIndex > ports)
 			goto error;
 		wIndex--;
 		switch (wValue) {
 		case USB_PORT_FEAT_SUSPEND:
-			_DBG(0, "USB_PORT_FEAT_SUSPEND\n");
 #ifdef	CONFIG_USB_OTG
 			if (ohci->hcd.self.otg_port == (wIndex + 1) &&
 			    ohci->hcd.self.b_hnp_enable) {
@@ -1700,7 +1527,6 @@ static int isp1362_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 			spin_unlock_irqrestore(&isp1362_hcd->lock, flags);
 			break;
 		case USB_PORT_FEAT_POWER:
-			_DBG(0, "USB_PORT_FEAT_POWER\n");
 			spin_lock_irqsave(&isp1362_hcd->lock, flags);
 			isp1362_write_reg32(isp1362_hcd, HCRHPORT1 + wIndex, RH_PS_PPS);
 			isp1362_hcd->rhport[wIndex] =
@@ -1708,7 +1534,6 @@ static int isp1362_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 			spin_unlock_irqrestore(&isp1362_hcd->lock, flags);
 			break;
 		case USB_PORT_FEAT_RESET:
-			_DBG(0, "USB_PORT_FEAT_RESET\n");
 			spin_lock_irqsave(&isp1362_hcd->lock, flags);
 
 			t1 = jiffies + msecs_to_jiffies(USB_RESET_WIDTH);
@@ -1742,7 +1567,6 @@ static int isp1362_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 	default:
  error:
 		/* "protocol stall" on error */
-		_DBG(0, "PROTOCOL STALL\n");
 		retval = -EPIPE;
 	}
 
@@ -1764,7 +1588,6 @@ static int isp1362_bus_suspend(struct usb_hcd *hcd)
 	isp1362_hcd->hc_control = isp1362_read_reg32(isp1362_hcd, HCCONTROL);
 	switch (isp1362_hcd->hc_control & OHCI_CTRL_HCFS) {
 	case OHCI_USB_RESUME:
-		DBG(0, "%s: resume/suspend?\n", __func__);
 		isp1362_hcd->hc_control &= ~OHCI_CTRL_HCFS;
 		isp1362_hcd->hc_control |= OHCI_USB_RESET;
 		isp1362_write_reg32(isp1362_hcd, HCCONTROL, isp1362_hcd->hc_control);
@@ -1777,7 +1600,6 @@ static int isp1362_bus_suspend(struct usb_hcd *hcd)
 		pr_warning("%s: already suspended?\n", __func__);
 		goto done;
 	}
-	DBG(0, "%s: suspend root hub\n", __func__);
 
 	/* First stop any processing */
 	hcd->state = HC_STATE_QUIESCING;
@@ -1793,7 +1615,6 @@ static int isp1362_bus_suspend(struct usb_hcd *hcd)
 		isp1362_write_reg16(isp1362_hcd, HCuPINTENB, 0);
 		isp1362_write_reg32(isp1362_hcd, HCINTSTAT, OHCI_INTR_SF);
 
-		DBG(0, "%s: stopping schedules ...\n", __func__);
 		limit = 2000;
 		while (limit > 0) {
 			udelay(250);
@@ -1815,8 +1636,7 @@ static int isp1362_bus_suspend(struct usb_hcd *hcd)
 		if (isp1362_read_reg16(isp1362_hcd, HCuPINT) & HCuPINT_ISTL1)
 			finish_iso_transfers(isp1362_hcd, &isp1362_hcd->istl_queue[1]);
 	}
-	DBG(0, "%s: HCINTSTAT: %08x\n", __func__,
-		    isp1362_read_reg32(isp1362_hcd, HCINTSTAT));
+
 	isp1362_write_reg32(isp1362_hcd, HCINTSTAT,
 			    isp1362_read_reg32(isp1362_hcd, HCINTSTAT));
 
@@ -1839,11 +1659,9 @@ static int isp1362_bus_suspend(struct usb_hcd *hcd)
 		isp1362_hcd->next_statechange = jiffies + msecs_to_jiffies(5);
 	}
 done:
-	if (status == 0) {
+	if (status == 0)
 		hcd->state = HC_STATE_SUSPENDED;
-		DBG(0, "%s: HCD suspended: %08x\n", __func__,
-		    isp1362_read_reg32(isp1362_hcd, HCCONTROL));
-	}
+
 	spin_unlock_irqrestore(&isp1362_hcd->lock, flags);
 	return status;
 }
@@ -1867,27 +1685,23 @@ static int isp1362_bus_resume(struct usb_hcd *hcd)
 	} else
 		switch (isp1362_hcd->hc_control & OHCI_CTRL_HCFS) {
 		case OHCI_USB_SUSPEND:
-			DBG(0, "%s: resume root hub\n", __func__);
 			isp1362_hcd->hc_control &= ~OHCI_CTRL_HCFS;
 			isp1362_hcd->hc_control |= OHCI_USB_RESUME;
 			isp1362_write_reg32(isp1362_hcd, HCCONTROL, isp1362_hcd->hc_control);
 			break;
 		case OHCI_USB_RESUME:
 			/* HCFS changes sometime after INTR_RD */
-			DBG(0, "%s: remote wakeup\n", __func__);
 			break;
 		case OHCI_USB_OPER:
-			DBG(0, "%s: odd resume\n", __func__);
+			pr_warning("%s: odd resume\n", __func__);
 			status = 0;
 			hcd->self.root_hub->dev.power.power_state = PMSG_ON;
 			break;
 		default:		/* RESET, we lost power */
-			DBG(0, "%s: root hub hardware reset\n", __func__);
 			status = -EBUSY;
 		}
 	spin_unlock_irqrestore(&isp1362_hcd->lock, flags);
 	if (status == -EBUSY) {
-		DBG(0, "%s: Restarting HC\n", __func__);
 		isp1362_hc_stop(hcd);
 		return isp1362_hc_start(hcd);
 	}
@@ -1899,11 +1713,9 @@ static int isp1362_bus_resume(struct usb_hcd *hcd)
 		u32 stat = isp1362_read_reg32(isp1362_hcd, HCRHPORT1 + port);
 
 		/* force global, not selective, resume */
-		if (!(stat & RH_PS_PSS)) {
-			DBG(0, "%s: Not Resuming RH port %d\n", __func__, port);
+		if (!(stat & RH_PS_PSS))
 			continue;
-		}
-		DBG(0, "%s: Resuming RH port %d\n", __func__, port);
+
 		isp1362_write_reg32(isp1362_hcd, HCRHPORT1 + port, RH_PS_POCI);
 	}
 	spin_unlock_irqrestore(&isp1362_hcd->lock, flags);
@@ -2256,6 +2068,7 @@ static void isp1362_sw_reset(struct isp1362_hcd *isp1362_hcd)
 static int isp1362_mem_config(struct usb_hcd *hcd)
 {
 	struct isp1362_hcd *isp1362_hcd = hcd_to_isp1362_hcd(hcd);
+	struct device *dev = hcd->self.controller;
 	unsigned long flags;
 	u32 total;
 	u16 istl_size = ISP1362_ISTL_BUFSIZE;
@@ -2277,21 +2090,21 @@ static int isp1362_mem_config(struct usb_hcd *hcd)
 		atl_buffers = 32;
 	atl_size = atl_buffers * atl_blksize;
 	total = atl_size + intl_size + istl_size;
-	dev_info(hcd->self.controller, "ISP1362 Memory usage:\n");
-	dev_info(hcd->self.controller, "  ISTL:    2 * %4d:     %4d @ $%04x:$%04x\n",
+	dev_info(dev, "ISP1362 Memory usage:\n");
+	dev_info(dev, "  ISTL:    2 * %4d:     %4d @ $%04x:$%04x\n",
 		 istl_size / 2, istl_size, 0, istl_size / 2);
-	dev_info(hcd->self.controller, "  INTL: %4d * (%3u+8):  %4d @ $%04x\n",
+	dev_info(dev, "  INTL: %4d * (%3u+8):  %4d @ $%04x\n",
 		 ISP1362_INTL_BUFFERS, intl_blksize - PTD_HEADER_SIZE,
 		 intl_size, istl_size);
-	dev_info(hcd->self.controller, "  ATL : %4d * (%3u+8):  %4d @ $%04x\n",
+	dev_info(dev, "  ATL : %4d * (%3u+8):  %4d @ $%04x\n",
 		 atl_buffers, atl_blksize - PTD_HEADER_SIZE,
 		 atl_size, istl_size + intl_size);
-	dev_info(hcd->self.controller, "  USED/FREE:   %4d      %4d\n", total,
+	dev_info(dev, "  USED/FREE:   %4d      %4d\n", total,
 		 ISP1362_BUF_SIZE - total);
 
 	if (total > ISP1362_BUF_SIZE) {
-		dev_err(hcd->self.controller, "%s: Memory requested: %d, available %d\n",
-			__func__, total, ISP1362_BUF_SIZE);
+		dev_err(dev, "Memory requested: %d, available %d\n",
+			total, ISP1362_BUF_SIZE);
 		return -ENOMEM;
 	}
 
@@ -2305,10 +2118,10 @@ static int isp1362_mem_config(struct usb_hcd *hcd)
 		INIT_LIST_HEAD(&isp1362_hcd->istl_queue[i].active);
 		snprintf(isp1362_hcd->istl_queue[i].name,
 			 sizeof(isp1362_hcd->istl_queue[i].name), "ISTL%d", i);
-		DBG(3, "%s: %5s buf $%04x %d\n", __func__,
-		     isp1362_hcd->istl_queue[i].name,
-		     isp1362_hcd->istl_queue[i].buf_start,
-		     isp1362_hcd->istl_queue[i].buf_size);
+		dev_dbg(dev, "%s: %5s buf $%04x %d\n", __func__,
+			isp1362_hcd->istl_queue[i].name,
+			isp1362_hcd->istl_queue[i].buf_start,
+			isp1362_hcd->istl_queue[i].buf_size);
 	}
 	isp1362_write_reg16(isp1362_hcd, HCISTLBUFSZ, istl_size / 2);
 
@@ -2348,16 +2161,16 @@ static int isp1362_mem_config(struct usb_hcd *hcd)
 		 sizeof(isp1362_hcd->atl_queue.name), "ATL");
 	snprintf(isp1362_hcd->intl_queue.name,
 		 sizeof(isp1362_hcd->intl_queue.name), "INTL");
-	DBG(3, "%s: %5s buf $%04x %2d * %4d = %4d\n", __func__,
-	     isp1362_hcd->intl_queue.name,
-	     isp1362_hcd->intl_queue.buf_start,
-	     ISP1362_INTL_BUFFERS, isp1362_hcd->intl_queue.blk_size,
-	     isp1362_hcd->intl_queue.buf_size);
-	DBG(3, "%s: %5s buf $%04x %2d * %4d = %4d\n", __func__,
-	     isp1362_hcd->atl_queue.name,
-	     isp1362_hcd->atl_queue.buf_start,
-	     atl_buffers, isp1362_hcd->atl_queue.blk_size,
-	     isp1362_hcd->atl_queue.buf_size);
+	dev_dbg(dev, "%s: %5s buf $%04x %2d * %4d = %4d\n", __func__,
+		isp1362_hcd->intl_queue.name,
+		isp1362_hcd->intl_queue.buf_start,
+		ISP1362_INTL_BUFFERS, isp1362_hcd->intl_queue.blk_size,
+		isp1362_hcd->intl_queue.buf_size);
+	dev_dbg(dev, "%s: %5s buf $%04x %2d * %4d = %4d\n", __func__,
+		isp1362_hcd->atl_queue.name,
+		isp1362_hcd->atl_queue.buf_start,
+		atl_buffers, isp1362_hcd->atl_queue.blk_size,
+		isp1362_hcd->atl_queue.buf_size);
 
 	spin_unlock_irqrestore(&isp1362_hcd->lock, flags);
 
@@ -2368,6 +2181,7 @@ static int isp1362_hc_reset(struct usb_hcd *hcd)
 {
 	int ret = 0;
 	struct isp1362_hcd *isp1362_hcd = hcd_to_isp1362_hcd(hcd);
+	struct device *dev = hcd->self.controller;
 	unsigned long t;
 	unsigned long timeout = 100;
 	unsigned long flags;
@@ -2376,11 +2190,11 @@ static int isp1362_hc_reset(struct usb_hcd *hcd)
 	pr_info("%s:\n", __func__);
 
 	if (isp1362_hcd->board && isp1362_hcd->board->reset) {
-		isp1362_hcd->board->reset(hcd->self.controller, 1);
+		isp1362_hcd->board->reset(dev, 1);
 		msleep(20);
 		if (isp1362_hcd->board->clock)
-			isp1362_hcd->board->clock(hcd->self.controller, 1);
-		isp1362_hcd->board->reset(hcd->self.controller, 0);
+			isp1362_hcd->board->clock(dev, 1);
+		isp1362_hcd->board->reset(dev, 0);
 	} else
 		isp1362_sw_reset(isp1362_hcd);
 
@@ -2407,6 +2221,7 @@ static int isp1362_hc_reset(struct usb_hcd *hcd)
 static void isp1362_hc_stop(struct usb_hcd *hcd)
 {
 	struct isp1362_hcd *isp1362_hcd = hcd_to_isp1362_hcd(hcd);
+	struct device *dev = hcd->self.controller;
 	unsigned long flags;
 	u32 tmp;
 
@@ -2426,12 +2241,12 @@ static void isp1362_hc_stop(struct usb_hcd *hcd)
 
 	/* Reset the chip */
 	if (isp1362_hcd->board && isp1362_hcd->board->reset)
-		isp1362_hcd->board->reset(hcd->self.controller, 1);
+		isp1362_hcd->board->reset(dev, 1);
 	else
 		isp1362_sw_reset(isp1362_hcd);
 
 	if (isp1362_hcd->board && isp1362_hcd->board->clock)
-		isp1362_hcd->board->clock(hcd->self.controller, 0);
+		isp1362_hcd->board->clock(dev, 0);
 
 	spin_unlock_irqrestore(&isp1362_hcd->lock, flags);
 }
@@ -2670,31 +2485,19 @@ static int __devexit isp1362_remove(struct platform_device *pdev)
 	struct resource *res;
 
 	remove_debug_file(isp1362_hcd);
-	DBG(0, "%s: Removing HCD\n", __func__);
 	usb_remove_hcd(hcd);
 
-	DBG(0, "%s: Unmapping data_reg @ %08x\n", __func__,
-	    (u32)isp1362_hcd->data_reg);
 	iounmap(isp1362_hcd->data_reg);
-
-	DBG(0, "%s: Unmapping addr_reg @ %08x\n", __func__,
-	    (u32)isp1362_hcd->addr_reg);
 	iounmap(isp1362_hcd->addr_reg);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-	DBG(0, "%s: release mem_region: %08lx\n", __func__, (long unsigned int)res->start);
-	if (res)
-		release_mem_region(res->start, resource_len(res));
-
+	BUG_ON(!res);
+	release_mem_region(res->start, resource_len(res));
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	DBG(0, "%s: release mem_region: %08lx\n", __func__, (long unsigned int)res->start);
-	if (res)
-		release_mem_region(res->start, resource_len(res));
+	BUG_ON(!res);
+	release_mem_region(res->start, resource_len(res));
 
-	DBG(0, "%s: put_hcd\n", __func__);
 	usb_put_hcd(hcd);
-	DBG(0, "%s: Done\n", __func__);
-
 	return 0;
 }
 
@@ -2737,14 +2540,7 @@ static int __init isp1362_probe(struct platform_device *pdev)
 		isp1362_hcd->data_dma = dma_res->start;
 		isp1362_hcd->max_dma_size = resource_len(dma_res);
 	}
-#else
-	if (pdev->dev.dma_mask) {
-		DBG(1, "won't do DMA");
-		retval = -ENODEV;
-		goto err1;
-	}
 #endif
-
 	if (!request_mem_region(addr->start, resource_len(addr), hcd_name)) {
 		retval = -EBUSY;
 		goto err1;
@@ -2785,7 +2581,7 @@ static int __init isp1362_probe(struct platform_device *pdev)
 	isp1362_hcd->board = pdev->dev.platform_data;
 #if USE_PLATFORM_DELAY
 	if (!isp1362_hcd->board->delay) {
-		dev_err(hcd->self.controller, "No platform delay function given\n");
+		dev_err(dev, "No platform delay function given\n");
 		retval = -ENODEV;
 		goto err6;
 	}
@@ -2806,19 +2602,14 @@ static int __init isp1362_probe(struct platform_device *pdev)
 	return 0;
 
  err6:
-	DBG(0, "%s: Freeing dev %08x\n", __func__, (u32)isp1362_hcd);
 	usb_put_hcd(hcd);
  err5:
-	DBG(0, "%s: Unmapping data_reg @ %08x\n", __func__, (u32)data_reg);
 	iounmap(data_reg);
  err4:
-	DBG(0, "%s: Releasing mem region %08lx\n", __func__, (long unsigned int)data->start);
 	release_mem_region(data->start, resource_len(data));
  err3:
-	DBG(0, "%s: Unmapping addr_reg @ %08x\n", __func__, (u32)addr_reg);
 	iounmap(addr_reg);
  err2:
-	DBG(0, "%s: Releasing mem region %08lx\n", __func__, (long unsigned int)addr->start);
 	release_mem_region(addr->start, resource_len(addr));
  err1:
 	pr_err("%s: init error, %d\n", __func__, retval);
@@ -2834,13 +2625,9 @@ static int isp1362_suspend(struct platform_device *pdev, pm_message_t state)
 	unsigned long flags;
 	int retval = 0;
 
-	DBG(0, "%s: Suspending device\n", __func__);
-
 	if (state.event == PM_EVENT_FREEZE) {
-		DBG(0, "%s: Suspending root hub\n", __func__);
 		retval = isp1362_bus_suspend(hcd);
 	} else {
-		DBG(0, "%s: Suspending RH ports\n", __func__);
 		spin_lock_irqsave(&isp1362_hcd->lock, flags);
 		isp1362_write_reg32(isp1362_hcd, HCRHSTATUS, RH_HS_LPS);
 		spin_unlock_irqrestore(&isp1362_hcd->lock, flags);
@@ -2856,10 +2643,7 @@ static int isp1362_resume(struct platform_device *pdev)
 	struct isp1362_hcd *isp1362_hcd = hcd_to_isp1362_hcd(hcd);
 	unsigned long flags;
 
-	DBG(0, "%s: Resuming\n", __func__);
-
 	if (pdev->dev.power.power_state.event == PM_EVENT_SUSPEND) {
-		DBG(0, "%s: Resume RH ports\n", __func__);
 		spin_lock_irqsave(&isp1362_hcd->lock, flags);
 		isp1362_write_reg32(isp1362_hcd, HCRHSTATUS, RH_HS_LPSC);
 		spin_unlock_irqrestore(&isp1362_hcd->lock, flags);
diff --git a/drivers/usb/host/isp1362.h b/drivers/usb/host/isp1362.h
index 26e44fc..5ba1ea6 100644
--- a/drivers/usb/host/isp1362.h
+++ b/drivers/usb/host/isp1362.h
@@ -295,7 +295,7 @@ struct ptd {
 #define PTD_SF_INT_MSK	(0x1f << 8)
 #define PTD_PR_MSK	(0x07 << 13)
 } __attribute__ ((packed, aligned(2)));
-#define PTD_HEADER_SIZE sizeof(struct ptd)
+#define PTD_HEADER_SIZE ((unsigned int)sizeof(struct ptd))
 
 /* ------------------------------------------------------------------------- */
 /* Copied from ohci.h: */
@@ -580,7 +580,7 @@ static inline const char *ISP1362_INT_NAME(int n)
 
 static inline void ALIGNSTAT(struct isp1362_hcd *isp1362_hcd, void *ptr)
 {
-	unsigned p = (unsigned)ptr;
+	unsigned long p = (unsigned long)ptr;
 	if (!(p & 0xf))
 		isp1362_hcd->stat16++;
 	else if (!(p & 0x7))
@@ -770,7 +770,7 @@ static void isp1362_write_fifo(struct isp1362_hcd *isp1362_hcd, void *buf, u16 l
 	if (!len)
 		return;
 
-	if ((unsigned)dp & 0x1) {
+	if ((unsigned long)dp & 0x1) {
 		/* not aligned */
 		for (; len > 1; len -= 2) {
 			data = *dp++;
@@ -962,8 +962,8 @@ static void isp1362_read_buffer(struct isp1362_hcd *isp1362_hcd, void *buf, u16
 
 	isp1362_write_diraddr(isp1362_hcd, offset, len);
 
-	DBG(3, "%s: Reading %d byte from buffer @%04x to memory @ %08x\n", __func__,
-	    len, offset, (u32)buf);
+	DBG(3, "%s: Reading %d byte from buffer @%04x to memory @ %p\n", __func__,
+	    len, offset, buf);
 
 	isp1362_write_reg16(isp1362_hcd, HCuPINT, HCuPINT_EOT);
 	_WARN_ON((isp1362_read_reg16(isp1362_hcd, HCuPINT) & HCuPINT_EOT));
@@ -982,8 +982,8 @@ static void isp1362_write_buffer(struct isp1362_hcd *isp1362_hcd, void *buf, u16
 
 	isp1362_write_diraddr(isp1362_hcd, offset, len);
 
-	DBG(3, "%s: Writing %d byte to buffer @%04x from memory @ %08x\n", __func__,
-	    len, offset, (u32)buf);
+	DBG(3, "%s: Writing %d byte to buffer @%04x from memory @ %p\n", __func__,
+	    len, offset, buf);
 
 	isp1362_write_reg16(isp1362_hcd, HCuPINT, HCuPINT_EOT);
 	_WARN_ON((isp1362_read_reg16(isp1362_hcd, HCuPINT) & HCuPINT_EOT));
-- 
1.4.4.4

