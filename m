Return-Path: <linux-kernel-owner+w=401wt.eu-S1757749AbZISCUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757749AbZISCUQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 22:20:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757564AbZISCUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 22:20:15 -0400
Received: from [65.98.92.6] ([65.98.92.6]:1689 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754952AbZISCUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 22:20:14 -0400
From: Kevin Cernekee <cernekee@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Date: Fri, 18 Sep 2009 18:43:30 -0700
Subject: [PATCH] kaweth: Fix memory leak in kaweth_control()
Message-Id: <6a1f935a6229adafb68d0e1ca7bc71fa@localhost>
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

