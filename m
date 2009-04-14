Return-Path: <linux-kernel-owner+w=401wt.eu-S1755680AbZDNM7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755680AbZDNM7Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 08:59:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754327AbZDNM66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 08:58:58 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:32938 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751835AbZDNM65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 08:58:57 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 2/4] tty: Fix leak in ti-usb
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Tue, 14 Apr 2009 14:58:11 +0100
Message-ID: <20090414135741.13935.99227.stgit@t61.ukuu.org.uk>
In-Reply-To: <20090414135501.13935.13500.stgit@t61.ukuu.org.uk>
References: <20090414135501.13935.13500.stgit@t61.ukuu.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the ti-usb adapter returns an zero data length frame (which happens) then
we leak a kref. Found by Christoph Mair <christoph.mair@gmail.com> who proposed
a patch. The patch here is different as Christoph's patch didn't work
for the case where tty = NULL and data arrived but Christoph did all the
hard work chasing it down.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/usb/serial/ti_usb_3410_5052.c |   26 ++++++++++++++------------
 1 files changed, 14 insertions(+), 12 deletions(-)


diff --git a/drivers/usb/serial/ti_usb_3410_5052.c b/drivers/usb/serial/ti_usb_3410_5052.c
index 2620bf6..9c4c700 100644
--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -1215,20 +1215,22 @@ static void ti_bulk_in_callback(struct urb *urb)
 	}
 
 	tty = tty_port_tty_get(&port->port);
-	if (tty && urb->actual_length) {
-		usb_serial_debug_data(debug, dev, __func__,
-			urb->actual_length, urb->transfer_buffer);
-
-		if (!tport->tp_is_open)
-			dbg("%s - port closed, dropping data", __func__);
-		else
-			ti_recv(&urb->dev->dev, tty,
+	if (tty) {
+		if (urb->actual_length) {
+			usb_serial_debug_data(debug, dev, __func__,
+				urb->actual_length, urb->transfer_buffer);
+
+			if (!tport->tp_is_open)
+				dbg("%s - port closed, dropping data",
+					__func__);
+			else
+				ti_recv(&urb->dev->dev, tty,
 						urb->transfer_buffer,
 						urb->actual_length);
-
-		spin_lock(&tport->tp_lock);
-		tport->tp_icount.rx += urb->actual_length;
-		spin_unlock(&tport->tp_lock);
+			spin_lock(&tport->tp_lock);
+			tport->tp_icount.rx += urb->actual_length;
+			spin_unlock(&tport->tp_lock);
+		}
 		tty_kref_put(tty);
 	}
 

