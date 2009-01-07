Return-Path: <linux-kernel-owner+w=401wt.eu-S1759985AbZAGQVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759985AbZAGQVa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 11:21:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756049AbZAGQUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 11:20:43 -0500
Received: from rv-out-0506.google.com ([209.85.198.232]:46461 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755247AbZAGQUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 11:20:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=vX1Z+FBiikhyWk5fZxiuG1+eYWY8THGyXAl7RRhvpJbnXHdkp0wvWGxtho7nbtc3q6
         D82O4RB0pE9Irhx6HKrYqfBON7DVFBSsUJyM4T6grBaGZsyZz7orqjKY3lKxnbqsmEa5
         PRCXgOBB0ENeHcFYaupUhCL6voLKDUimKRGgY=
From: Bryan Wu <cooloney@kernel.org>
To: gregkh@suse.de
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 2/2] usb: composite: Fix bug: low byte of w_index is the usb interface number not the whole 2 bytes of w_index
Date: Thu,  8 Jan 2009 00:21:19 +0800
Message-Id: <1231345279-26618-3-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1231345279-26618-1-git-send-email-cooloney@kernel.org>
References: <1231345279-26618-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In some usb gadget driver, for example usb audio class device, the high
byte of w_index is the entity id and low byte is the interface number.
If we use the 2 bytes of w_index as the array number, we will get a
wrong pointer or NULL pointer.

This patch fixes this issue.

Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/usb/gadget/composite.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index 363951e..5d11c29 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -683,6 +683,7 @@ composite_setup(struct usb_gadget *gadget, const struct usb_ctrlrequest *ctrl)
 	struct usb_request		*req = cdev->req;
 	int				value = -EOPNOTSUPP;
 	u16				w_index = le16_to_cpu(ctrl->wIndex);
+	u8				intf = w_index & 0xFF;
 	u16				w_value = le16_to_cpu(ctrl->wValue);
 	u16				w_length = le16_to_cpu(ctrl->wLength);
 	struct usb_function		*f = NULL;
@@ -769,7 +770,7 @@ composite_setup(struct usb_gadget *gadget, const struct usb_ctrlrequest *ctrl)
 			goto unknown;
 		if (!cdev->config || w_index >= MAX_CONFIG_INTERFACES)
 			break;
-		f = cdev->config->interface[w_index];
+		f = cdev->config->interface[intf];
 		if (!f)
 			break;
 		if (w_value && !f->set_alt)
@@ -781,7 +782,7 @@ composite_setup(struct usb_gadget *gadget, const struct usb_ctrlrequest *ctrl)
 			goto unknown;
 		if (!cdev->config || w_index >= MAX_CONFIG_INTERFACES)
 			break;
-		f = cdev->config->interface[w_index];
+		f = cdev->config->interface[intf];
 		if (!f)
 			break;
 		/* lots of interfaces only need altsetting zero... */
@@ -808,7 +809,7 @@ unknown:
 		 */
 		if ((ctrl->bRequestType & USB_RECIP_MASK)
 				== USB_RECIP_INTERFACE) {
-			f = cdev->config->interface[w_index];
+			f = cdev->config->interface[intf];
 			if (f && f->setup)
 				value = f->setup(f, ctrl);
 			else
-- 
1.5.6

