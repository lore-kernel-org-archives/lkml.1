Return-Path: <linux-kernel-owner+w=401wt.eu-S1758862AbYFBJ76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758862AbYFBJ76 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 05:59:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752890AbYFBJ7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 05:59:08 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:32957 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbYFBJ7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 05:59:04 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] cdc-wdm endianness fixes
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Message-Id: <E1K36og-0007Yz-Hn@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Mon, 02 Jun 2008 10:59:02 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* wMaxPacketSize is le16; copying it to a field of local structure and then
  using that field as host-endian (size of object to be allocated) is broken.
* bMaxPacketSize0 is 8-bit; feeding it to le16_to_cpu() is bogus and since the
  result is used as host-endian, it's not even misspelled cpu_to_le16().

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/drivers/usb/class/cdc-wdm.c b/drivers/usb/class/cdc-wdm.c
index 107666d..731db05 100644
--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -611,8 +611,8 @@ next_desc:
 		goto err;
 	}
 
-	desc->wMaxPacketSize = ep->wMaxPacketSize;
-	desc->bMaxPacketSize0 = cpu_to_le16(udev->descriptor.bMaxPacketSize0);
+	desc->wMaxPacketSize = le16_to_cpu(ep->wMaxPacketSize);
+	desc->bMaxPacketSize0 = udev->descriptor.bMaxPacketSize0;
 
 	desc->orq = kmalloc(sizeof(struct usb_ctrlrequest), GFP_KERNEL);
 	if (!desc->orq)
