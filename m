Return-Path: <linux-kernel-owner+w=401wt.eu-S1752424AbYIFEvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424AbYIFEvS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 00:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751280AbYIFEvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 00:51:11 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:34851 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbYIFEvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 00:51:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=UuxS8yb3Ivb4TjiJH3GW1SHrhTsf2OEuXG5lcT0zsz8QEHT0P4HbVCHlWlHMkBiJsI
         +oK5kF7uttL6gYiaT7IvdvQdsTZbVG93HI4bh48jk/T9HiU6z2GCaCfNmAiE6S2UwW8N
         /3VMIsRRTlNDOnDuj8V6MEIWPmrleosMM/Z+A=
Message-ID: <48C20C3E.20306@gmail.com>
Date: Sat, 06 Sep 2008 00:51:10 -0400
From: sangsu <sangsu@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: dbrownell@users.sourceforge.net, gregkh@suse.de, stern@rowland.harvard.edu,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] USB: g_file_storage: fix handling zero-length packet 
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to "CH 5.5.3. Control Transfer Packet Size Constraints",
Zero-length packet should be sent when the last data payload size
is equal to the endpoint's MaxPacketSize. This patch helps
g_file_storage send zero-length packet properly.

This is tested in s3c2440/s5c7329 architectures and works well.

Signed-off-by: SangSu Park<sangsu@gmail.com>
---
driver/usb/gadget/file_storage.c | 3++-
1 files changed, 2 insertion(+), 1 deletions(-)

--- a/drivers/usb/gadget/file_storage.c	2008-09-01 11:13:03.000000000 -0400
+++ b/drivers/usb/gadget/file_storage.c	2008-09-01 11:16:41.000000000 -0400
@@ -1463,7 +1463,8 @@
	if (rc >= 0 && rc != DELAYED_STATUS) {
		rc = min(rc, w_length);
		fsg->ep0req->length = rc;
-		fsg->ep0req->zero = rc < w_length;
+		fsg->ep0req->zero = rc < w_length
+			&& (rc % gadget->ep0->maxpacket) == 0;
		fsg->ep0req_name = (ctrl->bRequestType & USB_DIR_IN ?
				"ep0-in" : "ep0-out");
		rc = ep0_queue(fsg);
