Return-Path: <linux-kernel-owner+w=401wt.eu-S1756325AbYHYJN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325AbYHYJN5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 05:13:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754057AbYHYJNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 05:13:34 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:13209 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753976AbYHYJNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 05:13:32 -0400
X-IronPort-AV: E=Sophos;i="4.32,264,1217822400"; 
   d="scan'208";a="58495743"
From: Bryan Wu <cooloney@kernel.org>
To: felipe.balbi@nokia.com, linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/2] usb: musb: fix bug - don't mess up count number and CSR0 register value
Date: Mon, 25 Aug 2008 17:13:40 +0800
Message-Id: <1219655621-18510-2-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1219655621-18510-1-git-send-email-cooloney@kernel.org>
References: <1219655621-18510-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/usb/musb/musb_gadget_ep0.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/musb/musb_gadget_ep0.c b/drivers/usb/musb/musb_gadget_ep0.c
index a57652f..3f5e30d 100644
--- a/drivers/usb/musb/musb_gadget_ep0.c
+++ b/drivers/usb/musb/musb_gadget_ep0.c
@@ -437,7 +437,7 @@ static void ep0_rxstate(struct musb *musb)
 {
 	void __iomem		*regs = musb->control_ep->regs;
 	struct usb_request	*req;
-	u16			tmp;
+	u16			count, csr;
 
 	req = next_ep0_request(musb);
 
@@ -449,35 +449,35 @@ static void ep0_rxstate(struct musb *musb)
 		unsigned	len = req->length - req->actual;
 
 		/* read the buffer */
-		tmp = musb_readb(regs, MUSB_COUNT0);
-		if (tmp > len) {
+		count = musb_readb(regs, MUSB_COUNT0);
+		if (count > len) {
 			req->status = -EOVERFLOW;
-			tmp = len;
+			count = len;
 		}
-		musb_read_fifo(&musb->endpoints[0], tmp, buf);
-		req->actual += tmp;
-		tmp = MUSB_CSR0_P_SVDRXPKTRDY;
-		if (tmp < 64 || req->actual == req->length) {
+		musb_read_fifo(&musb->endpoints[0], count, buf);
+		req->actual += count;
+		csr = MUSB_CSR0_P_SVDRXPKTRDY;
+		if (count < 64 || req->actual == req->length) {
 			musb->ep0_state = MUSB_EP0_STAGE_STATUSIN;
-			tmp |= MUSB_CSR0_P_DATAEND;
+			csr |= MUSB_CSR0_P_DATAEND;
 		} else
 			req = NULL;
 	} else
-		tmp = MUSB_CSR0_P_SVDRXPKTRDY | MUSB_CSR0_P_SENDSTALL;
+		csr = MUSB_CSR0_P_SVDRXPKTRDY | MUSB_CSR0_P_SENDSTALL;
 
 
 	/* Completion handler may choose to stall, e.g. because the
 	 * message just received holds invalid data.
 	 */
 	if (req) {
-		musb->ackpend = tmp;
+		musb->ackpend = csr;
 		musb_g_ep0_giveback(musb, req);
 		if (!musb->ackpend)
 			return;
 		musb->ackpend = 0;
 	}
 	musb_ep_select(musb->mregs, 0);
-	musb_writew(regs, MUSB_CSR0, tmp);
+	musb_writew(regs, MUSB_CSR0, csr);
 }
 
 /*
-- 
1.5.6
