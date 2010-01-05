Return-Path: <linux-kernel-owner+w=401wt.eu-S1754790Ab0AEAxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790Ab0AEAxl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:53:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754959Ab0AEAxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:53:10 -0500
Received: from kroah.org ([198.145.64.141]:34151 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754243Ab0AEAe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:34:56 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 23/97] USB: musb: gadget_ep0: avoid SetupEnd interrupt
Date: Mon,  4 Jan 2010 16:32:36 -0800
Message-Id: <1262651630-7354-23-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/musb/musb_gadget_ep0.c b/drivers/usb/musb/musb_gadget_ep0.c
index 1c44b97..067e5a9 100644
--- a/drivers/usb/musb/musb_gadget_ep0.c
+++ b/drivers/usb/musb/musb_gadget_ep0.c
@@ -647,7 +647,7 @@ irqreturn_t musb_g_ep0_irq(struct musb *musb)
 			musb->ep0_state = MUSB_EP0_STAGE_STATUSIN;
 			break;
 		default:
-			ERR("SetupEnd came in a wrong ep0stage %s",
+			ERR("SetupEnd came in a wrong ep0stage %s\n",
 			    decode_ep0stage(musb->ep0_state));
 		}
 		csr = musb_readw(regs, MUSB_CSR0);
@@ -770,12 +770,18 @@ setup:
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
-- 
1.6.6

