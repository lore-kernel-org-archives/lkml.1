Return-Path: <linux-kernel-owner+w=401wt.eu-S1761536AbYHOWM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761536AbYHOWM1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 18:12:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752001AbYHOWMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 18:12:13 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:40605 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756040AbYHOWML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 18:12:11 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 16 Aug 2008 00:11:48 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [RFC patch 1/3] ieee1394: raw1394: replace BKL by local mutex, make
 ioctl() and mmap() thread-safe
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.0df9cff587ba5fed@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes the last usage of the Big Kernel Lock from the ieee1394
stack, i.e. from raw1394's (unlocked_)ioctl and compat_ioctl.

The ioctl()s don't need to take the BKL, but they need to be serialized
per struct file *.  In particular, accesses to ->iso_state need to be
serial.  We simply use a blocking mutex for this purpose because
libraw1394 does not use O_NONBLOCK.  In practice, there is no lock
contention anyway because most if not all libraw1394 clients use a
libraw1394 handle only in a single thread.

mmap() also accesses ->iso_state.  Until now this was unprotected
against concurrent changes by ioctls.  Fix this bug while we are at it.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/raw1394-private.h |    1 +
 drivers/ieee1394/raw1394.c         |   23 +++++++++++++++++------
 2 files changed, 18 insertions(+), 6 deletions(-)

Index: linux/drivers/ieee1394/raw1394-private.h
===================================================================
--- linux.orig/drivers/ieee1394/raw1394-private.h
+++ linux/drivers/ieee1394/raw1394-private.h
@@ -22,6 +22,7 @@ enum raw1394_iso_state { RAW1394_ISO_INA
 struct file_info {
         struct list_head list;
 
+	struct mutex state_mutex;
         enum { opened, initialized, connected } state;
         unsigned int protocol_version;
 
Index: linux/drivers/ieee1394/raw1394.c
===================================================================
--- linux.orig/drivers/ieee1394/raw1394.c
+++ linux/drivers/ieee1394/raw1394.c
@@ -34,6 +34,7 @@
 #include <linux/fs.h>
 #include <linux/poll.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/vmalloc.h>
@@ -2541,11 +2542,18 @@ static int raw1394_read_cycle_timer(stru
 static int raw1394_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct file_info *fi = file->private_data;
+	int ret;
+
+	mutex_lock(&fi->state_mutex);
 
 	if (fi->iso_state == RAW1394_ISO_INACTIVE)
-		return -EINVAL;
+		ret = -EINVAL;
+	else
+		ret = dma_region_mmap(&fi->iso_handle->data_buf, file, vma);
+
+	mutex_unlock(&fi->state_mutex);
 
-	return dma_region_mmap(&fi->iso_handle->data_buf, file, vma);
+	return ret;
 }
 
 /* ioctl is only used for rawiso operations */
@@ -2659,10 +2667,12 @@ static long do_raw1394_ioctl(struct file
 static long raw1394_ioctl(struct file *file, unsigned int cmd,
 							unsigned long arg)
 {
+	struct file_info *fi = file->private_data;
 	long ret;
-	lock_kernel();
+
+	mutex_lock(&fi->state_mutex);
 	ret = do_raw1394_ioctl(file, cmd, arg);
-	unlock_kernel();
+	mutex_unlock(&fi->state_mutex);
 	return ret;
 }
 
@@ -2724,7 +2734,7 @@ static long raw1394_compat_ioctl(struct 
 	void __user *argp = (void __user *)arg;
 	long err;
 
-	lock_kernel();
+	mutex_lock(&fi->state_mutex);
 	switch (cmd) {
 	/* These requests have same format as long as 'int' has same size. */
 	case RAW1394_IOC_ISO_RECV_INIT:
@@ -2757,7 +2767,7 @@ static long raw1394_compat_ioctl(struct 
 		err = -EINVAL;
 		break;
 	}
-	unlock_kernel();
+	mutex_unlock(&fi->state_mutex);
 
 	return err;
 }
@@ -2791,6 +2801,7 @@ static int raw1394_open(struct inode *in
 	fi->notification = (u8) RAW1394_NOTIFY_ON;	/* busreset notification */
 
 	INIT_LIST_HEAD(&fi->list);
+	mutex_init(&fi->state_mutex);
 	fi->state = opened;
 	INIT_LIST_HEAD(&fi->req_pending);
 	INIT_LIST_HEAD(&fi->req_complete);

-- 
Stefan Richter
-=====-==--- =--- =----
http://arcgraph.de/sr/

