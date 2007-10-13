Return-Path: <linux-kernel-owner+w=401wt.eu-S1761676AbXJMOop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761676AbXJMOop (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 10:44:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761466AbXJMOmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 10:42:14 -0400
Received: from 1wt.eu ([62.212.114.60]:2932 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760170AbXJMOmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 10:42:13 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20071013143452.%N@1wt.eu>
References: <20071013142822.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Sat, 13 Oct 2007 17:28:35 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [2.6.20.21 review 13/35] USB: allow retry on descriptor fetch errors
Content-Disposition: inline; filename=0046-USB-allow-retry-on-descriptor-fetch-errors.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch (as964) was suggested by Steffen Koepf.  It makes
usb_get_descriptor() retry on all errors other than ETIMEDOUT, instead
of only on EPIPE.  This helps with some devices.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/core/message.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

Index: 2.6/drivers/usb/core/message.c
===================================================================
--- 2.6.orig/drivers/usb/core/message.c
+++ 2.6/drivers/usb/core/message.c
@@ -608,12 +608,12 @@ int usb_get_descriptor(struct usb_device
 	memset(buf,0,size);	// Make sure we parse really received data
 
 	for (i = 0; i < 3; ++i) {
-		/* retry on length 0 or stall; some devices are flakey */
+		/* retry on length 0 or error; some devices are flakey */
 		result = usb_control_msg(dev, usb_rcvctrlpipe(dev, 0),
 				USB_REQ_GET_DESCRIPTOR, USB_DIR_IN,
 				(type << 8) + index, 0, buf, size,
 				USB_CTRL_GET_TIMEOUT);
-		if (result == 0 || result == -EPIPE)
+		if (result <= 0 && result != -ETIMEDOUT)
 			continue;
 		if (result > 1 && ((u8 *)buf)[1] != type) {
 			result = -EPROTO;

-- 
