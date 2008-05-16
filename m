Return-Path: <linux-kernel-owner+w=401wt.eu-S1760140AbYEPSYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760140AbYEPSYA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 14:24:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752569AbYEPSXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 14:23:52 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:56546 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbYEPSXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 14:23:51 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 16 May 2008 20:23:10 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: prevent userspace from accessing shut down devices
To: linux-kernel@vger.kernel.org
cc: linux1394-devel@lists.sourceforge.net, Jay Fenlason <fenlason@redhat.com>
In-Reply-To: <482DCF65.6060503@s5r6.in-berlin.de>
Message-ID: <tkrat.4d3a5a4fed86a318@s5r6.in-berlin.de>
References: <20080516151523.GA25026@redhat.com>
 <482DCF65.6060503@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I almost forgot that we generally Cc LKML on patches.  So here is an -rc
fix candidate for LKML to see:

Date: Fri, 16 May 2008 11:15:23 -0400
From: Jay Fenlason <fenlason@redhat.com>

If userspace ignores the POLLERR bit from poll(), and only attempts to
read() the device when POLLIN is set, it can still make ioctl() calls on
a device that has been removed from the system.  The node_id and
generation returned by GET_INFO will be outdated, but INITIATE_BUS_RESET
would still cause a bus reset, and GET_CYCLE_TIMER will return data.

We now immediately fail open, ioctl, compat_ioctl, and mmap against
shutdown devices.

Signed-off-by: Jay Fenlason <fenlason@redhat.com>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-cdev.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

Index: linux/drivers/firewire/fw-cdev.c
===================================================================
--- linux.orig/drivers/firewire/fw-cdev.c
+++ linux/drivers/firewire/fw-cdev.c
@@ -113,6 +113,11 @@ static int fw_device_op_open(struct inod
 	if (device == NULL)
 		return -ENODEV;
 
+	if (fw_device_is_shutdown(device)) {
+		fw_device_put(device);
+		return -ENODEV;
+	}
+
 	client = kzalloc(sizeof(*client), GFP_KERNEL);
 	if (client == NULL) {
 		fw_device_put(device);
@@ -901,6 +906,9 @@ fw_device_op_ioctl(struct file *file,
 {
 	struct client *client = file->private_data;
 
+	if (fw_device_is_shutdown(client->device))
+		return -ENODEV;
+
 	return dispatch_ioctl(client, cmd, (void __user *) arg);
 }
 
@@ -911,6 +919,9 @@ fw_device_op_compat_ioctl(struct file *f
 {
 	struct client *client = file->private_data;
 
+	if (fw_device_is_shutdown(client->device))
+		return -ENODEV;
+
 	return dispatch_ioctl(client, cmd, compat_ptr(arg));
 }
 #endif
@@ -922,6 +933,9 @@ static int fw_device_op_mmap(struct file
 	unsigned long size;
 	int page_count, retval;
 
+	if (fw_device_is_shutdown(client->device))
+		return -ENODEV;
+
 	/* FIXME: We could support multiple buffers, but we don't. */
 	if (client->buffer.pages != NULL)
 		return -EBUSY;


-- 
Stefan Richter
-=====-==--- -=-= =----
http://arcgraph.de/sr/

