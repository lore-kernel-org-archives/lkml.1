Return-Path: <linux-kernel-owner+w=401wt.eu-S1755532AbYHLOm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532AbYHLOm3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 10:42:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754170AbYHLOjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 10:39:36 -0400
Received: from multi.imgtec.com ([194.200.65.239]:19247 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752379AbYHLOjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 10:39:25 -0400
From: Will Newton <will.newton@imgtec.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       leoli@freescale.com, Will Newton <will.newton@gmail.com>
Subject: [PATCH 09/11] fsl_usb2_udc: Make fsl_queue_td return type void.
Date: Tue, 12 Aug 2008 15:39:15 +0100
Message-Id: <1218551957-17091-10-git-send-email-will.newton@imgtec.com>
X-Mailer: git-send-email 1.5.5.2
In-Reply-To: <1218551957-17091-9-git-send-email-will.newton@imgtec.com>
References: <1218551957-17091-1-git-send-email-will.newton@imgtec.com>
 <1218551957-17091-2-git-send-email-will.newton@imgtec.com>
 <1218551957-17091-3-git-send-email-will.newton@imgtec.com>
 <1218551957-17091-4-git-send-email-will.newton@imgtec.com>
 <1218551957-17091-5-git-send-email-will.newton@imgtec.com>
 <1218551957-17091-6-git-send-email-will.newton@imgtec.com>
 <1218551957-17091-7-git-send-email-will.newton@imgtec.com>
 <1218551957-17091-8-git-send-email-will.newton@imgtec.com>
 <1218551957-17091-9-git-send-email-will.newton@imgtec.com>
X-OriginalArrivalTime: 12 Aug 2008 14:39:18.0462 (UTC) FILETIME=[337D2DE0:01C8FC89]
X-SEF-Processed: 6_0_1_111__2008_08_12_15_39_21
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Will Newton <will.newton@gmail.com>

fsl_queue_td always returns 0. Make it void and remove checks for non-zero
return in callers.

Signed-off-by: Will Newton <will.newton@gmail.com>
Acked-by: Li Yang <leoli@freescale.com>
---
 drivers/usb/gadget/fsl_usb2_udc.c |   19 +++++--------------
 1 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/usb/gadget/fsl_usb2_udc.c b/drivers/usb/gadget/fsl_usb2_udc.c
index 45ae982..10fafbb 100644
--- a/drivers/usb/gadget/fsl_usb2_udc.c
+++ b/drivers/usb/gadget/fsl_usb2_udc.c
@@ -592,7 +592,7 @@ static void fsl_free_request(struct usb_ep *_ep, struct usb_request *_req)
 }
 
 /*-------------------------------------------------------------------------*/
-static int fsl_queue_td(struct fsl_ep *ep, struct fsl_req *req)
+static void fsl_queue_td(struct fsl_ep *ep, struct fsl_req *req)
 {
 	int i = ep_index(ep) * 2 + ep_is_in(ep);
 	u32 temp, bitmask, tmp_stat;
@@ -649,7 +649,7 @@ static int fsl_queue_td(struct fsl_ep *ep, struct fsl_req *req)
 		: (1 << (ep_index(ep)));
 	fsl_writel(temp, &dr_regs->endpointprime);
 out:
-	return 0;
+	return;
 }
 
 /* Fill in the dTD structure
@@ -1136,7 +1136,6 @@ static int ep0_prime_status(struct fsl_udc *udc, int direction)
 {
 	struct fsl_req *req = udc->status_req;
 	struct fsl_ep *ep;
-	int status = 0;
 
 	if (direction == EP_DIR_IN)
 		udc->ep0_dir = USB_DIR_IN;
@@ -1154,15 +1153,13 @@ static int ep0_prime_status(struct fsl_udc *udc, int direction)
 	req->dtd_count = 0;
 
 	if (fsl_req_to_dtd(req) == 0)
-		status = fsl_queue_td(ep, req);
+		fsl_queue_td(ep, req);
 	else
 		return -ENOMEM;
 
-	if (status)
-		ERR("Can't queue ep0 status request\n");
 	list_add_tail(&req->queue, &ep->queue);
 
-	return status;
+	return 0;
 }
 
 static void udc_reset_ep_queue(struct fsl_udc *udc, u8 pipe)
@@ -1194,10 +1191,8 @@ static void ch9getstatus(struct fsl_udc *udc, u8 request_type, u16 value,
 		u16 index, u16 length)
 {
 	u16 tmp = 0;		/* Status, cpu endian */
-
 	struct fsl_req *req;
 	struct fsl_ep *ep;
-	int status = 0;
 
 	ep = &udc->eps[0];
 
@@ -1236,14 +1231,10 @@ static void ch9getstatus(struct fsl_udc *udc, u8 request_type, u16 value,
 
 	/* prime the data phase */
 	if ((fsl_req_to_dtd(req) == 0))
-		status = fsl_queue_td(ep, req);
+		fsl_queue_td(ep, req);
 	else			/* no mem */
 		goto stall;
 
-	if (status) {
-		ERR("Can't respond to getstatus request\n");
-		goto stall;
-	}
 	list_add_tail(&req->queue, &ep->queue);
 	udc->ep0_state = DATA_STATE_XMIT;
 	return;
-- 
1.5.5.2

