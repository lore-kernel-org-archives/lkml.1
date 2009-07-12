Return-Path: <linux-kernel-owner+w=401wt.eu-S1753959AbZGLHod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959AbZGLHod (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 03:44:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752463AbZGLHoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 03:44:16 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:46756 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753656AbZGLHoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 03:44:15 -0400
Date: Sun, 12 Jul 2009 09:43:52 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: dahlmann.thomas@arcor.de, linux-geode@lists.infradead.org, gregkh@suse.de,
       jirislaby@gmail.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 3/3] drivers/usb/gadget: Drop NULL test on list_entry result
Message-ID: <Pine.LNX.4.64.0907120943230.17416@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

list_entry, which is an alias for container_of, cannot return NULL, as
there is no way to add a NULL value to a doubly linked list.

A simplified version of the semantic match that findds this problem is as
follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r@
expression x,E;
statement S1,S2;
position p,p1;
@@

*x = list_entry@p(...)
... when != x = E
*if@p1 (x == NULL) S1 else S2
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/usb/gadget/amd5536udc.c     |   56 +++++++++-----------
 1 files changed, 25 insertions(+), 31 deletions(-)

diff --git a/drivers/usb/gadget/amd5536udc.c b/drivers/usb/gadget/amd5536udc.c
index 826f3ad..85f7aa9 100644
--- a/drivers/usb/gadget/amd5536udc.c
+++ b/drivers/usb/gadget/amd5536udc.c
@@ -2379,40 +2379,34 @@ static irqreturn_t udc_data_in_isr(struct udc *dev, int ep_ix)
 		if (!ep->cancel_transfer && !list_empty(&ep->queue)) {
 			req = list_entry(ep->queue.next,
 					struct udc_request, queue);
-			if (req) {
-				/*
-				 * length bytes transfered
-				 * check dma done of last desc. in PPBDU mode
-				 */
-				if (use_dma_ppb_du) {
-					td = udc_get_last_dma_desc(req);
-					if (td) {
-						dma_done =
-							AMD_GETBITS(td->status,
-							UDC_DMA_IN_STS_BS);
-						/* don't care DMA done */
-						req->req.actual =
-							req->req.length;
-					}
-				} else {
-					/* assume all bytes transferred */
+			/*
+			 * length bytes transfered
+			 * check dma done of last desc. in PPBDU mode
+			 */
+			if (use_dma_ppb_du) {
+				td = udc_get_last_dma_desc(req);
+				if (td) {
+					dma_done =
+						AMD_GETBITS(td->status,
+						UDC_DMA_IN_STS_BS);
+					/* don't care DMA done */
 					req->req.actual = req->req.length;
 				}
+			} else {
+				/* assume all bytes transferred */
+				req->req.actual = req->req.length;
+			}
 
-				if (req->req.actual == req->req.length) {
-					/* complete req */
-					complete_req(ep, req, 0);
-					req->dma_going = 0;
-					/* further request available ? */
-					if (list_empty(&ep->queue)) {
-						/* disable interrupt */
-						tmp = readl(
-							&dev->regs->ep_irqmsk);
-						tmp |= AMD_BIT(ep->num);
-						writel(tmp,
-							&dev->regs->ep_irqmsk);
-					}
-
+			if (req->req.actual == req->req.length) {
+				/* complete req */
+				complete_req(ep, req, 0);
+				req->dma_going = 0;
+				/* further request available ? */
+				if (list_empty(&ep->queue)) {
+					/* disable interrupt */
+					tmp = readl(&dev->regs->ep_irqmsk);
+					tmp |= AMD_BIT(ep->num);
+					writel(tmp, &dev->regs->ep_irqmsk);
 				}
 			}
 		}
