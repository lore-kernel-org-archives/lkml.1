Return-Path: <linux-kernel-owner+w=401wt.eu-S1760624AbYGOP04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760624AbYGOP04 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 11:26:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755285AbYGOPZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 11:25:07 -0400
Received: from multi.imgtec.com ([194.200.65.239]:63831 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754442AbYGOPY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 11:24:59 -0400
From: Will Newton <will.newton@imgtec.com>
To: linux-kernel@vger.kernel.org
Cc: linux-usb@vger.kernel.org, leoli@freescale.com, tanya.jiang@freescale.com,
       gregkh@suse.de, Will Newton <will.newton@gmail.com>
Subject: [PATCH 09/11] fsl_usb2_udc: Make fsl_queue_td return type void.
Date: Tue, 15 Jul 2008 16:24:48 +0100
Message-Id: <1216135490-21656-10-git-send-email-will.newton@imgtec.com>
X-Mailer: git-send-email 1.5.5.2
In-Reply-To: <1216135490-21656-9-git-send-email-will.newton@imgtec.com>
References: <1216135490-21656-1-git-send-email-will.newton@imgtec.com>
 <1216135490-21656-2-git-send-email-will.newton@imgtec.com>
 <1216135490-21656-3-git-send-email-will.newton@imgtec.com>
 <1216135490-21656-4-git-send-email-will.newton@imgtec.com>
 <1216135490-21656-5-git-send-email-will.newton@imgtec.com>
 <1216135490-21656-6-git-send-email-will.newton@imgtec.com>
 <1216135490-21656-7-git-send-email-will.newton@imgtec.com>
 <1216135490-21656-8-git-send-email-will.newton@imgtec.com>
 <1216135490-21656-9-git-send-email-will.newton@imgtec.com>
X-OriginalArrivalTime: 15 Jul 2008 15:24:53.0402 (UTC) FILETIME=[EE12E7A0:01C8E68E]
X-SEF-Processed: 6_0_1_111__2008_07_15_16_24_56
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Will Newton <will.newton@gmail.com>

fsl_queue_td always returns 0. Make it void and remove checks for non-zero
return in callers.

Signed-off-by: Will Newton <will.newton@gmail.com>
---
 drivers/usb/gadget/fsl_usb2_udc.c |   19 +++++--------------
 1 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/usb/gadget/fsl_usb2_udc.c b/drivers/usb/gadget/fsl_usb2_udc.c
index a6757c9..81cba99 100644
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

