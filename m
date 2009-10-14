Return-Path: <linux-kernel-owner+w=401wt.eu-S1760379AbZJNVPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760379AbZJNVPR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 17:15:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760194AbZJNVPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 17:15:16 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:55667 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760265AbZJNVPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 17:15:15 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 14 Oct 2009 23:14:13 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH update] firewire: cdev: reduce stack usage by ioctl_dispatch
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.ec38f27900b7af20@s5r6.in-berlin.de>
Message-ID: <tkrat.fac844bd855a29ff@s5r6.in-berlin.de>
References: <tkrat.27888275592fd267@s5r6.in-berlin.de>
 <tkrat.af1058f9e26f4dba@s5r6.in-berlin.de>
 <tkrat.ec38f27900b7af20@s5r6.in-berlin.de>
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

At first I wanted to define this as
	 BUILD_BUG_ON(_IOC_SIZE(x) > sizeof(buffer))
but sparse spews "error: bad integer constant expression" then.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-cdev.c |   36 ++++++++++++++++++++++++-----------
 1 file changed, 25 insertions(+), 11 deletions(-)

Index: linux-2.6.32-rc1/drivers/firewire/core-cdev.c
===================================================================
--- linux-2.6.32-rc1.orig/drivers/firewire/core-cdev.c
+++ linux-2.6.32-rc1/drivers/firewire/core-cdev.c
@@ -1300,28 +1300,42 @@ static int (* const ioctl_handlers[])(st
 static int dispatch_ioctl(struct client *client,
 			  unsigned int cmd, void __user *arg)
 {
-	char buffer[256];
+	char buffer[40];
 	int ret;
 
+#define check_ioctl_size(x) BUILD_BUG_ON(sizeof(x) > sizeof(buffer))
+
+	check_ioctl_size(struct fw_cdev_get_info);
+	check_ioctl_size(struct fw_cdev_send_request);
+	check_ioctl_size(struct fw_cdev_allocate);
+	check_ioctl_size(struct fw_cdev_deallocate);
+	check_ioctl_size(struct fw_cdev_send_response);
+	check_ioctl_size(struct fw_cdev_initiate_bus_reset);
+	check_ioctl_size(struct fw_cdev_add_descriptor);
+	check_ioctl_size(struct fw_cdev_remove_descriptor);
+	check_ioctl_size(struct fw_cdev_create_iso_context);
+	check_ioctl_size(struct fw_cdev_queue_iso);
+	check_ioctl_size(struct fw_cdev_start_iso);
+	check_ioctl_size(struct fw_cdev_stop_iso);
+	check_ioctl_size(struct fw_cdev_get_cycle_timer);
+	check_ioctl_size(struct fw_cdev_allocate_iso_resource);
+	check_ioctl_size(struct fw_cdev_send_stream_packet);
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
-=====-==--= =-=- -===-
http://arcgraph.de/sr/

