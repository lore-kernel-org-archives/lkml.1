Return-Path: <linux-kernel-owner+w=401wt.eu-S1754354AbZDWHsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354AbZDWHsq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756920AbZDWHcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:32:48 -0400
Received: from sous-sol.org ([216.99.217.87]:50793 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757051AbZDWHcr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:32:47 -0400
Message-Id: <20090423072758.106398728@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:21:26 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Alan Cox <alan@linux.intel.com>
Subject: [patch 066/100] tty: Fix leak in ti-usb
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=tty-fix-leak-in-ti-usb.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Alan Cox <alan@lxorguk.ukuu.org.uk>

upstream commit: cf5450930db0ae308584e5361f3345e0ff73e643

If the ti-usb adapter returns an zero data length frame (which happens)
then we leak a kref.  Found by Christoph Mair <christoph.mair@gmail.com>
who proposed a patch.  The patch here is different as Christoph's patch
didn't work for the case where tty = NULL and data arrived but Christoph
did all the hard work chasing it down.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/usb/serial/ti_usb_3410_5052.c |   26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -1215,20 +1215,22 @@ static void ti_bulk_in_callback(struct u
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
 

