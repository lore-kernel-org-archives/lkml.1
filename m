Return-Path: <linux-kernel-owner+w=401wt.eu-S1755944AbYLJHdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944AbYLJHdT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 02:33:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754491AbYLJHdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 02:33:07 -0500
Received: from mga03.intel.com ([143.182.124.21]:29573 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754410AbYLJHdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 02:33:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,746,1220252400"; 
   d="scan'208";a="88502442"
Date: Wed, 10 Dec 2008 15:32:47 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org
Subject: [PATCH] USB: use stack allocation for struct usb_ctrlrequest
Message-ID: <20081210073247.GA18630@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sizeof(struct usb_ctrlrequest) = 8, which is as small as the *dt pointer
in a 64bit system.

Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 drivers/usb/core/message.c |   27 ++++++++-------------------
 1 file changed, 8 insertions(+), 19 deletions(-)

--- linux-2.6.orig/drivers/usb/core/message.c
+++ linux-2.6/drivers/usb/core/message.c
@@ -130,26 +130,15 @@ int usb_control_msg(struct usb_device *d
 		    __u8 requesttype, __u16 value, __u16 index, void *data,
 		    __u16 size, int timeout)
 {
-	struct usb_ctrlrequest *dr;
-	int ret;
-
-	dr = kmalloc(sizeof(struct usb_ctrlrequest), GFP_NOIO);
-	if (!dr)
-		return -ENOMEM;
-
-	dr->bRequestType = requesttype;
-	dr->bRequest = request;
-	dr->wValue = cpu_to_le16p(&value);
-	dr->wIndex = cpu_to_le16p(&index);
-	dr->wLength = cpu_to_le16p(&size);
+	struct usb_ctrlrequest dr = {
+		.bRequestType = requesttype,
+		.bRequest = request,
+		.wValue = cpu_to_le16p(&value),
+		.wIndex = cpu_to_le16p(&index),
+		.wLength = cpu_to_le16p(&size),
+	};
 
-	/* dbg("usb_control_msg"); */
-
-	ret = usb_internal_control_msg(dev, pipe, dr, data, size, timeout);
-
-	kfree(dr);
-
-	return ret;
+	return usb_internal_control_msg(dev, pipe, &dr, data, size, timeout);
 }
 EXPORT_SYMBOL_GPL(usb_control_msg);
 
