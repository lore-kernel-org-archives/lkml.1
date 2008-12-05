Return-Path: <linux-kernel-owner+w=401wt.eu-S1757513AbYLEVuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513AbYLEVuA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 16:50:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756032AbYLEVts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 16:49:48 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:40080 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755891AbYLEVtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 16:49:47 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 5 Dec 2008 22:44:42 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: cdev: tcodes input validation
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.274f4723192e1c26@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The behaviour of fw-transaction.c::fw_send_request is ill-defined for
any other tcodes than read/ write/ lock request tcodes.  Therefore
prevent requests with wrong tcodes from entering the transaction layer.

Maybe fw_send_request should check them itself, but I am not inclined to
change it and fw_fill_request from void-valued functions to ones which
return error codes and pass those up.  Besides, maybe fw_send_request is
going to support one more tcode than ioctl_send_request in the future
(TCODE_STREAM_DATA).

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-cdev.c |   27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

Index: linux/drivers/firewire/fw-cdev.c
===================================================================
--- linux.orig/drivers/firewire/fw-cdev.c
+++ linux/drivers/firewire/fw-cdev.c
@@ -398,6 +398,7 @@ static int ioctl_send_request(struct cli
 	struct fw_device *device = client->device;
 	struct fw_cdev_send_request *request = buffer;
 	struct response *response;
+	int ret;
 
 	/* What is the biggest size we'll accept, really? */
 	if (request->length > 4096)
@@ -414,8 +415,26 @@ static int ioctl_send_request(struct cli
 	if (request->data &&
 	    copy_from_user(response->response.data,
 			   u64_to_uptr(request->data), request->length)) {
-		kfree(response);
-		return -EFAULT;
+		ret = -EFAULT;
+		goto err;
+	}
+
+	switch (request->tcode) {
+	case TCODE_WRITE_QUADLET_REQUEST:
+	case TCODE_WRITE_BLOCK_REQUEST:
+	case TCODE_READ_QUADLET_REQUEST:
+	case TCODE_READ_BLOCK_REQUEST:
+	case TCODE_LOCK_MASK_SWAP:
+	case TCODE_LOCK_COMPARE_SWAP:
+	case TCODE_LOCK_FETCH_ADD:
+	case TCODE_LOCK_LITTLE_ADD:
+	case TCODE_LOCK_BOUNDED_ADD:
+	case TCODE_LOCK_WRAP_ADD:
+	case TCODE_LOCK_VENDOR_DEPENDENT:
+		break;
+	default:
+		ret = -EINVAL;
+		goto err;
 	}
 
 	response->resource.release = release_transaction;
@@ -434,6 +453,10 @@ static int ioctl_send_request(struct cli
 		return sizeof(request) + request->length;
 	else
 		return sizeof(request);
+ err:
+	kfree(response);
+
+	return ret;
 }
 
 struct address_handler {

-- 
Stefan Richter
-=====-==--- ==-- --=-=
http://arcgraph.de/sr/

