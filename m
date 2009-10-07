Return-Path: <linux-kernel-owner+w=401wt.eu-S1756000AbZJGWlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000AbZJGWlo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 18:41:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755427AbZJGWln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 18:41:43 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:44046 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060AbZJGWlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 18:41:42 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 8 Oct 2009 00:40:38 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 3/8] firewire: cdev: reduce stack usage by ioctl_dispatch
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.27888275592fd267@s5r6.in-berlin.de>
Message-ID: <tkrat.af1058f9e26f4dba@s5r6.in-berlin.de>
References: <tkrat.27888275592fd267@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shrink the stack-allocated ioctl argument buffer from 256 to 40 bytes.
This is the maximum of what we currently need for all ioctls.

Also, turn runtime checks of the buffer size into compile-time checks.
This involves a few more lines of code but they are all taken care of by
the compiler's dead code elimination, and this way the buffer size
should actually be a little easier to update when new ioctls are added.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-cdev.c |   41 ++++++++++++++++++++++++++---------
 1 file changed, 30 insertions(+), 11 deletions(-)

Index: linux-2.6.31/drivers/firewire/core-cdev.c
===================================================================
--- linux-2.6.31.orig/drivers/firewire/core-cdev.c
+++ linux-2.6.31/drivers/firewire/core-cdev.c
@@ -1299,28 +1299,47 @@ static int (* const ioctl_handlers[])(st
 static int dispatch_ioctl(struct client *client,
 			  unsigned int cmd, void __user *arg)
 {
-	char buffer[256];
+	char buffer[40];
 	int ret;
 
+#define check_ioctl_size(x) BUILD_BUG_ON(_IOC_SIZE(x) > sizeof(buffer))
+
+	check_ioctl_size(FW_CDEV_IOC_GET_INFO);
+	check_ioctl_size(FW_CDEV_IOC_SEND_REQUEST);
+	check_ioctl_size(FW_CDEV_IOC_ALLOCATE);
+	check_ioctl_size(FW_CDEV_IOC_DEALLOCATE);
+	check_ioctl_size(FW_CDEV_IOC_SEND_RESPONSE);
+	check_ioctl_size(FW_CDEV_IOC_INITIATE_BUS_RESET);
+	check_ioctl_size(FW_CDEV_IOC_ADD_DESCRIPTOR);
+	check_ioctl_size(FW_CDEV_IOC_REMOVE_DESCRIPTOR);
+	check_ioctl_size(FW_CDEV_IOC_CREATE_ISO_CONTEXT);
+	check_ioctl_size(FW_CDEV_IOC_QUEUE_ISO);
+	check_ioctl_size(FW_CDEV_IOC_START_ISO);
+	check_ioctl_size(FW_CDEV_IOC_STOP_ISO);
+	check_ioctl_size(FW_CDEV_IOC_GET_CYCLE_TIMER);
+	check_ioctl_size(FW_CDEV_IOC_ALLOCATE_ISO_RESOURCE);
+	check_ioctl_size(FW_CDEV_IOC_DEALLOCATE_ISO_RESOURCE);
+	check_ioctl_size(FW_CDEV_IOC_ALLOCATE_ISO_RESOURCE_ONCE);
+	check_ioctl_size(FW_CDEV_IOC_DEALLOCATE_ISO_RESOURCE_ONCE);
+	check_ioctl_size(FW_CDEV_IOC_GET_SPEED);
+	check_ioctl_size(FW_CDEV_IOC_SEND_BROADCAST_REQUEST);
+	check_ioctl_size(FW_CDEV_IOC_SEND_STREAM_PACKET);
+
 	if (_IOC_TYPE(cmd) != '#' ||
 	    _IOC_NR(cmd) >= ARRAY_SIZE(ioctl_handlers))
 		return -EINVAL;
 
-	if (_IOC_DIR(cmd) & _IOC_WRITE) {
-		if (_IOC_SIZE(cmd) > sizeof(buffer) ||
-		    copy_from_user(buffer, arg, _IOC_SIZE(cmd)))
-			return -EFAULT;
-	}
+	if (_IOC_DIR(cmd) & _IOC_WRITE &&
+	    copy_from_user(buffer, arg, _IOC_SIZE(cmd)))
+		return -EFAULT;
 
 	ret = ioctl_handlers[_IOC_NR(cmd)](client, buffer);
 	if (ret < 0)
 		return ret;
 
-	if (_IOC_DIR(cmd) & _IOC_READ) {
-		if (_IOC_SIZE(cmd) > sizeof(buffer) ||
-		    copy_to_user(arg, buffer, _IOC_SIZE(cmd)))
-			return -EFAULT;
-	}
+	if (_IOC_DIR(cmd) & _IOC_READ &&
+	    copy_to_user(arg, buffer, _IOC_SIZE(cmd)))
+		return -EFAULT;
 
 	return ret;
 }

-- 
Stefan Richter
-=====-==--= =-=- -=---
http://arcgraph.de/sr/

