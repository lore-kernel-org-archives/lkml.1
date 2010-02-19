Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018Ab0BSRRa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:17:30 -0500
Received: from kroah.org ([198.145.64.141]:57400 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754419Ab0BSRAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:00:15 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:34 2010
Message-Id: <20100219163234.520082133@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:29:10 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Paul Mundt <lethal@linux-sh.org>,
       Yoshihiro Shimoda <shimoda.yoshihiro@renesas.com>
Subject: [17/93] usb: r8a66597-hcd: Flush the D-cache for the pipe-in transfer buffers.
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Paul Mundt <lethal@linux-sh.org>

commit 2717568e7c44fe7dc3f4f52ea823811cfeede2b5 upstream.

This implements the same D-cache flushing logic for r8a66597-hcd as
Catalin's isp1760 (http://patchwork.kernel.org/patch/76391/) change,
with the same note applying here as well:

    When the HDC driver writes the data to the transfer buffers it
    pollutes the D-cache (unlike DMA drivers where the device writes
    the data). If the corresponding pages get mapped into user space,
    there are no additional cache flushing operations performed and
    this causes random user space faults on architectures with
    separate I and D caches (Harvard) or those with aliasing D-cache.

This fixes up crashes during USB boot on SH7724 and others:

	http://marc.info/?l=linux-sh&m=126439837308912&w=2

Reported-by: Goda Yusuke <goda.yusuke@renesas.com>
Tested-by: Goda Yusuke <goda.yusuke@renesas.com>
Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Acked-by: Yoshihiro Shimoda <shimoda.yoshihiro@renesas.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/r8a66597-hcd.c |   39 ++++++++++++++++++++++++++-------------
 1 file changed, 26 insertions(+), 13 deletions(-)

--- a/drivers/usb/host/r8a66597-hcd.c
+++ b/drivers/usb/host/r8a66597-hcd.c
@@ -35,7 +35,9 @@
 #include <linux/usb.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
+#include <linux/mm.h>
 #include <linux/irq.h>
+#include <asm/cacheflush.h>
 
 #include "../core/hcd.h"
 #include "r8a66597.h"
@@ -820,6 +822,26 @@ static void enable_r8a66597_pipe(struct
 	enable_r8a66597_pipe_dma(r8a66597, dev, pipe, urb);
 }
 
+static void r8a66597_urb_done(struct r8a66597 *r8a66597, struct urb *urb,
+			      int status)
+__releases(r8a66597->lock)
+__acquires(r8a66597->lock)
+{
+	if (usb_pipein(urb->pipe) && usb_pipetype(urb->pipe) != PIPE_CONTROL) {
+		void *ptr;
+
+		for (ptr = urb->transfer_buffer;
+		     ptr < urb->transfer_buffer + urb->transfer_buffer_length;
+		     ptr += PAGE_SIZE)
+			flush_dcache_page(virt_to_page(ptr));
+	}
+
+	usb_hcd_unlink_urb_from_ep(r8a66597_to_hcd(r8a66597), urb);
+	spin_unlock(&r8a66597->lock);
+	usb_hcd_giveback_urb(r8a66597_to_hcd(r8a66597), urb, status);
+	spin_lock(&r8a66597->lock);
+}
+
 /* this function must be called with interrupt disabled */
 static void force_dequeue(struct r8a66597 *r8a66597, u16 pipenum, u16 address)
 {
@@ -840,15 +862,9 @@ static void force_dequeue(struct r8a6659
 		list_del(&td->queue);
 		kfree(td);
 
-		if (urb) {
-			usb_hcd_unlink_urb_from_ep(r8a66597_to_hcd(r8a66597),
-					urb);
-
-			spin_unlock(&r8a66597->lock);
-			usb_hcd_giveback_urb(r8a66597_to_hcd(r8a66597), urb,
-					-ENODEV);
-			spin_lock(&r8a66597->lock);
-		}
+		if (urb)
+			r8a66597_urb_done(r8a66597, urb, -ENODEV);
+
 		break;
 	}
 }
@@ -1285,10 +1301,7 @@ __releases(r8a66597->lock) __acquires(r8
 		if (usb_pipeisoc(urb->pipe))
 			urb->start_frame = r8a66597_get_frame(hcd);
 
-		usb_hcd_unlink_urb_from_ep(r8a66597_to_hcd(r8a66597), urb);
-		spin_unlock(&r8a66597->lock);
-		usb_hcd_giveback_urb(hcd, urb, status);
-		spin_lock(&r8a66597->lock);
+		r8a66597_urb_done(r8a66597, urb, status);
 	}
 
 	if (restart) {


