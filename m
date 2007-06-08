Return-Path: <linux-kernel-owner+w=401wt.eu-S939391AbXFHHtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939391AbXFHHtY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938405AbXFHHY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:24:57 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:55300 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938390AbXFHHYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:24:52 -0400
Message-Id: <20070608072220.735514000@sous-sol.org>
References: <20070608072127.352723000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 00:22:02 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 35/54] USB: set the correct Interrupt interval in usb_bulk_msg
Content-Disposition: inline; filename=usb-set-the-correct-interrupt-interval-in-usb_bulk_msg.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Alan Stern <stern@rowland.harvard.edu>

This patch (as902) fixes a mistake I introduced into usb_bulk_msg().
usb_fill_int_urb() already does the bit-shifting calculation for
high-speed Interrupt intervals; it shouldn't be done twice.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>

---
 drivers/usb/core/message.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- linux-2.6.21.4.orig/drivers/usb/core/message.c
+++ linux-2.6.21.4/drivers/usb/core/message.c
@@ -221,15 +221,10 @@ int usb_bulk_msg(struct usb_device *usb_
 
 	if ((ep->desc.bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) ==
 			USB_ENDPOINT_XFER_INT) {
-		int interval;
-
-		if (usb_dev->speed == USB_SPEED_HIGH)
-			interval = 1 << min(15, ep->desc.bInterval - 1);
-		else
-			interval = ep->desc.bInterval;
 		pipe = (pipe & ~(3 << 30)) | (PIPE_INTERRUPT << 30);
 		usb_fill_int_urb(urb, usb_dev, pipe, data, len,
-				usb_api_blocking_completion, NULL, interval);
+				usb_api_blocking_completion, NULL,
+				ep->desc.bInterval);
 	} else
 		usb_fill_bulk_urb(urb, usb_dev, pipe, data, len,
 				usb_api_blocking_completion, NULL);

-- 
