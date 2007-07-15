Return-Path: <linux-kernel-owner+w=401wt.eu-S1754562AbXGOT7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562AbXGOT7a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 15:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751452AbXGOT7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 15:59:23 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39902 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbXGOT7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 15:59:23 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] minimal fixes for drivers/usb/gadget/m66592-udc.c
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
Message-Id: <E1IAAFW-00053E-0T@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sun, 15 Jul 2007 20:59:22 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


still looks racy (and definitely leaks)

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/usb/gadget/m66592-udc.c |   27 ++++-----------------------
 1 files changed, 4 insertions(+), 23 deletions(-)

diff --git a/drivers/usb/gadget/m66592-udc.c b/drivers/usb/gadget/m66592-udc.c
index c0a962b..0174a32 100644
--- a/drivers/usb/gadget/m66592-udc.c
+++ b/drivers/usb/gadget/m66592-udc.c
@@ -937,6 +937,7 @@ static void get_status(struct m66592 *m66592, struct usb_ctrlrequest *ctrl)
 	*m66592->ep0_buf = status;
 	m66592->ep0_req->buf = m66592->ep0_buf;
 	m66592->ep0_req->length = 2;
+	/* AV: what happens if we get called again before that gets through? */
 	m66592_queue(m66592->gadget.ep0, m66592->ep0_req, GFP_KERNEL);
 }
 
@@ -1254,24 +1255,6 @@ static void m66592_free_request(struct usb_ep *_ep, struct usb_request *_req)
 	kfree(req);
 }
 
-static void *m66592_alloc_buffer(struct usb_ep *_ep, unsigned bytes,
-				 dma_addr_t *dma, gfp_t gfp_flags)
-{
-	void *buf;
-
-	buf = kzalloc(bytes, gfp_flags);
-	if (dma)
-		*dma = virt_to_bus(buf);
-
-	return buf;
-}
-
-static void m66592_free_buffer(struct usb_ep *_ep, void *buf,
-			       dma_addr_t dma, unsigned bytes)
-{
-	kfree(buf);
-}
-
 static int m66592_queue(struct usb_ep *_ep, struct usb_request *_req,
 			gfp_t gfp_flags)
 {
@@ -1378,9 +1361,6 @@ static struct usb_ep_ops m66592_ep_ops = {
 	.alloc_request	= m66592_alloc_request,
 	.free_request	= m66592_free_request,
 
-	.alloc_buffer	= m66592_alloc_buffer,
-	.free_buffer	= m66592_free_buffer,
-
 	.queue		= m66592_queue,
 	.dequeue	= m66592_dequeue,
 
@@ -1603,11 +1583,12 @@ static int __init m66592_probe(struct platform_device *pdev)
 
 	the_controller = m66592;
 
+	/* AV: leaks */
 	m66592->ep0_req = m66592_alloc_request(&m66592->ep[0].ep, GFP_KERNEL);
 	if (m66592->ep0_req == NULL)
 		goto clean_up;
-	m66592->ep0_buf = m66592_alloc_buffer(&m66592->ep[0].ep, 2, NULL,
-					      GFP_KERNEL);
+	/* AV: leaks, and do we really need it separately allocated? */
+	m66592->ep0_buf = kzalloc(2, GFP_KERNEL);
 	if (m66592->ep0_buf == NULL)
 		goto clean_up;
 
-- 
1.5.3.GIT


