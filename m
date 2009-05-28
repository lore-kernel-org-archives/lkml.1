Return-Path: <linux-kernel-owner+w=401wt.eu-S1755035AbZE1LA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035AbZE1LA2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 07:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752214AbZE1LAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 07:00:17 -0400
Received: from mx1.emlix.com ([193.175.82.87]:49329 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753546AbZE1LAQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 07:00:16 -0400
From: =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
To: Darius Augulis <augulis.darius@gmail.com>,
       David Brownell <dbrownell@users.sourceforge.net>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
Subject: [PATCH] imx_udc: don't queue more data when zlp is to be sent
Date: Thu, 28 May 2009 13:00:14 +0200
Message-Id: <1243508414-18084-1-git-send-email-dg@emlix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Organization: emlix gmbh, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a zero-length packet has been requested and another packet is
written into the fifo, the MX1 tends to send the first byte of the
previous packet instead of the first byte of the current packet.
The CRC is adjusted accordingly so that this packet is _not_
discarded by the host.

Waiting for the ZLPS bit to clear avoids these bad packets.

Signed-off-by: Daniel Glöckner <dg@emlix.com>
---
 drivers/usb/gadget/imx_udc.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/gadget/imx_udc.c b/drivers/usb/gadget/imx_udc.c
index ff7658e..642cceb 100644
--- a/drivers/usb/gadget/imx_udc.c
+++ b/drivers/usb/gadget/imx_udc.c
@@ -415,6 +415,13 @@ static int write_packet(struct imx_ep_struct *imx_ep, struct imx_request *req)
 	u8	*buf;
 	int	length, count, temp;
 
+	if (unlikely(__raw_readl(imx_ep->imx_usb->base +
+				 USB_EP_STAT(EP_NO(imx_ep))) & EPSTAT_ZLPS)) {
+		D_TRX(imx_ep->imx_usb->dev, "<%s> zlp still queued in EP %s\n",
+			__func__, imx_ep->ep.name);
+		return -1;
+	}
+
 	buf = req->req.buf + req->req.actual;
 	prefetch(buf);
 
-- 
1.6.1.3

