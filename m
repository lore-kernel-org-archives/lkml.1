Return-Path: <linux-kernel-owner+w=401wt.eu-S1755582Ab0AEUNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582Ab0AEUNl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 15:13:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755501Ab0AEUMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 15:12:39 -0500
Received: from kroah.org ([198.145.64.141]:49947 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755461Ab0AEUGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 15:06:11 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan  5 12:03:01 2010
Message-Id: <20100105200301.058773322@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 05 Jan 2010 12:02:12 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>, Anand Gadiyar <gadiyar@ti.com>,
       Felipe Balbi <felipe.balbi@nokia.com>
Subject: [16/39] USB: musb: gadget_ep0: avoid SetupEnd interrupt
In-Reply-To: <20100105195007.GA23952@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sergei Shtylyov <sshtylyov@ru.mvista.com>

commit 17be5c5f5ef99c94374e07f71effa78e93a20eda upstream.

Gadget stalling a zero-length SETUP request results in this error message:

SetupEnd came in a wrong ep0stage idle

In order to avoid it, always set the CSR0.DataEnd bit after detecting a zero-
length request.  Add the missing '\n' to the error message itself as well...

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Acked-by: Anand Gadiyar <gadiyar@ti.com>
Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/musb/musb_gadget_ep0.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/usb/musb/musb_gadget_ep0.c
+++ b/drivers/usb/musb/musb_gadget_ep0.c
@@ -646,7 +646,7 @@ irqreturn_t musb_g_ep0_irq(struct musb *
 			musb->ep0_state = MUSB_EP0_STAGE_STATUSIN;
 			break;
 		default:
-			ERR("SetupEnd came in a wrong ep0stage %s",
+			ERR("SetupEnd came in a wrong ep0stage %s\n",
 			    decode_ep0stage(musb->ep0_state));
 		}
 		csr = musb_readw(regs, MUSB_CSR0);
@@ -769,12 +769,18 @@ setup:
 				handled = service_zero_data_request(
 						musb, &setup);
 
+				/*
+				 * We're expecting no data in any case, so
+				 * always set the DATAEND bit -- doing this
+				 * here helps avoid SetupEnd interrupt coming
+				 * in the idle stage when we're stalling...
+				 */
+				musb->ackpend |= MUSB_CSR0_P_DATAEND;
+
 				/* status stage might be immediate */
-				if (handled > 0) {
-					musb->ackpend |= MUSB_CSR0_P_DATAEND;
+				if (handled > 0)
 					musb->ep0_state =
 						MUSB_EP0_STAGE_STATUSIN;
-				}
 				break;
 
 			/* sequence #1 (IN to host), includes GET_STATUS


