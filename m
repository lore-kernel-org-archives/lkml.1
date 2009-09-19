Return-Path: <linux-kernel-owner+w=401wt.eu-S1752679AbZISV2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679AbZISV2B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 17:28:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751318AbZISV2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 17:28:00 -0400
Received: from [65.98.92.6] ([65.98.92.6]:1765 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750791AbZISV17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 17:27:59 -0400
From: Kevin Cernekee <cernekee@gmail.com>
To: <netdev@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
       Oliver Neukum <oliver@neukum.org>, Greg Kroah-Hartman <gregkh@suse.de>
Date: Sat, 19 Sep 2009 14:18:21 -0700
Subject: [PATCH RESEND] kaweth: Fix memory leak in kaweth_control()
Message-Id: <3317a2830541b564fef54730a60f85dc@localhost>
User-Agent: vim 7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kaweth_control() never frees the buffer that it allocates for the USB
control message.  Test case:

while :; do ifconfig eth2 down ; ifconfig eth2 up ; done

This is a tiny buffer so it is a slow leak.  If you want to speed up the
process, you can change the allocation size to e.g. 16384 bytes, and it
will consume several megabytes within a few minutes.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
Acked-by: Oliver Neukum <oliver@neukum.org>
---
 drivers/net/usb/kaweth.c |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/usb/kaweth.c b/drivers/net/usb/kaweth.c
index e2a39b9..e391ef9 100644
--- a/drivers/net/usb/kaweth.c
+++ b/drivers/net/usb/kaweth.c
@@ -263,6 +263,7 @@ static int kaweth_control(struct kaweth_device *kaweth,
 			  int timeout)
 {
 	struct usb_ctrlrequest *dr;
+	int retval;
 
 	dbg("kaweth_control()");
 
@@ -278,18 +279,21 @@ static int kaweth_control(struct kaweth_device *kaweth,
 		return -ENOMEM;
 	}
 
-	dr->bRequestType= requesttype;
+	dr->bRequestType = requesttype;
 	dr->bRequest = request;
 	dr->wValue = cpu_to_le16(value);
 	dr->wIndex = cpu_to_le16(index);
 	dr->wLength = cpu_to_le16(size);
 
-	return kaweth_internal_control_msg(kaweth->dev,
-					pipe,
-					dr,
-					data,
-					size,
-					timeout);
+	retval = kaweth_internal_control_msg(kaweth->dev,
+					     pipe,
+					     dr,
+					     data,
+					     size,
+					     timeout);
+
+	kfree(dr);
+	return retval;
 }
 
 /****************************************************************
-- 
1.6.3.1

