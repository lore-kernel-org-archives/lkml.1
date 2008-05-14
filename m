Return-Path: <linux-kernel-owner+w=401wt.eu-S1757990AbYENK3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757990AbYENK3z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 06:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753612AbYENK3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 06:29:44 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:18126 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062AbYENK3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 06:29:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=NgvPEyVocP86nc7HOMx48U+wz3/jzAOMshKwC2D/3AY6t8IDOBpEd4Ld5HlqM6DLs/ZlXZtbeIhYNebO703kIj2HP0PdTSCBH4x8PM2sr050yza5SNrdDffbTX9GzmccNfo/J6e3SeD1yIscqeRI78418iKQ2BwDrhFLVxzFdiQ=
Message-ID: <482ABF15.8090006@gmail.com>
Date: Wed, 14 May 2008 12:29:41 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: rjarzmik@free.fr, dbrownell@users.sourceforge.net
CC: linux-usb@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH ?] usb/gadget/pxa27x_udc: test ep0state == IN_DATA_STAGE rather
 than non-bool USB_DIR_IN
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below was not tested!
#------------------------------------------------------------------------------#
drivers/usb/gadget/pxa27x_udc.c uses USB_DIR_IN as if boolean in functions
inc_ep_stats_{reqs,bytes}, lines 763, 795, 933, 985, 1037 and 1074, but
USB_DIR_IN is defined 0x80.

handle_ep0_ctrl_req() tests USB_DIR_IN bitwise and pxa_udc's ep0_state is set
IN_DATA_STAGE or OUT_DATA_STAGE. so ep->dev->ep0state == IN_DATA_STAGE should be
tested rather than USB_DIR_IN

I am uncertain whether this fix is correct and sufficient, feedback appreciated.
- Maybe more tests are required: is ep->dev == NULL or similar
- Maybe I should test ep->dev->ep0state == OUT_DATA_STAGE rather than 
  ep->dev->ep0state != IN_DATA_STAGE (instead of !USB_DIR_IN)

---
USB_DIR_IN is not boolean, test ep0state == IN_DATA_STAGE instead.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/usb/gadget/pxa27x_udc.c b/drivers/usb/gadget/pxa27x_udc.c
index 75eba20..ea18995 100644
--- a/drivers/usb/gadget/pxa27x_udc.c
+++ b/drivers/usb/gadget/pxa27x_udc.c
@@ -760,7 +760,7 @@ static void req_done(struct pxa_ep *ep, struct pxa27x_request *req, int status)
  */
 static void ep_end_out_req(struct pxa_ep *ep, struct pxa27x_request *req)
 {
-	inc_ep_stats_reqs(ep, !USB_DIR_IN);
+	inc_ep_stats_reqs(ep, ep->dev->ep0state != IN_DATA_STAGE);
 	req_done(ep, req, 0);
 }
 
@@ -792,7 +792,7 @@ static void ep0_end_out_req(struct pxa_ep *ep, struct pxa27x_request *req)
  */
 static void ep_end_in_req(struct pxa_ep *ep, struct pxa27x_request *req)
 {
-	inc_ep_stats_reqs(ep, USB_DIR_IN);
+	inc_ep_stats_reqs(ep, ep->dev->ep0state == IN_DATA_STAGE);
 	req_done(ep, req, 0);
 }
 
@@ -930,7 +930,8 @@ static int read_fifo(struct pxa_ep *ep, struct pxa27x_request *req)
 
 	while (epout_has_pkt(ep)) {
 		count = read_packet(ep, req);
-		inc_ep_stats_bytes(ep, count, !USB_DIR_IN);
+		inc_ep_stats_bytes(ep, count,
+				ep->dev->ep0state != IN_DATA_STAGE);
 
 		is_short = (count < ep->fifo_size);
 		ep_dbg(ep, "read udccsr:%03x, count:%d bytes%s req %p %d/%d\n",
@@ -982,7 +983,8 @@ static int write_fifo(struct pxa_ep *ep, struct pxa27x_request *req)
 		}
 
 		count = write_packet(ep, req, max);
-		inc_ep_stats_bytes(ep, count, USB_DIR_IN);
+		inc_ep_stats_bytes(ep, count,
+				ep->dev->ep0state == IN_DATA_STAGE);
 		totcount += count;
 
 		/* last packet is usually short (or a zlp) */
@@ -1034,7 +1036,8 @@ static int read_ep0_fifo(struct pxa_ep *ep, struct pxa27x_request *req)
 	while (epout_has_pkt(ep)) {
 		count = read_packet(ep, req);
 		udc_ep_writel(ep, UDCCSR, UDCCSR0_OPC);
-		inc_ep_stats_bytes(ep, count, !USB_DIR_IN);
+		inc_ep_stats_bytes(ep, count,
+				ep->dev->ep0state != IN_DATA_STAGE);
 
 		is_short = (count < ep->fifo_size);
 		ep_dbg(ep, "read udccsr:%03x, count:%d bytes%s req %p %d/%d\n",
