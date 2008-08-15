Return-Path: <linux-kernel-owner+w=401wt.eu-S1761334AbYHOWNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761334AbYHOWNX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 18:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751307AbYHOWNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 18:13:15 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:40610 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795AbYHOWNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 18:13:14 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 16 Aug 2008 00:12:52 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [RFC patch 2/3] ieee1394: raw1394: narrow down the state_mutex
 protected region
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.0df9cff587ba5fed@s5r6.in-berlin.de>
Message-ID: <tkrat.39c930f50f011685@s5r6.in-berlin.de>
References: <tkrat.0df9cff587ba5fed@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refactor the ioctl dispatcher in order to move a fraction of it out of
the section which is serialized by fi->state_mutex.  This is not so much
about performance but more about self-documentation:  The mutex_lock()/
mutex_unlock() calls are now closer to the data accesses which the mutex
protects, i.e. to the iso_state switch.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/raw1394.c |  207 +++++++++++++++++++------------------
 1 file changed, 108 insertions(+), 99 deletions(-)

Index: linux/drivers/ieee1394/raw1394.c
===================================================================
--- linux.orig/drivers/ieee1394/raw1394.c
+++ linux/drivers/ieee1394/raw1394.c
@@ -2556,102 +2556,106 @@ static int raw1394_mmap(struct file *fil
 	return ret;
 }
 
-/* ioctl is only used for rawiso operations */
-static long do_raw1394_ioctl(struct file *file, unsigned int cmd,
-							unsigned long arg)
+static long raw1394_ioctl_inactive(struct file_info *fi, unsigned int cmd,
+				   void __user *argp)
+{
+	switch (cmd) {
+	case RAW1394_IOC_ISO_XMIT_INIT:
+		return raw1394_iso_xmit_init(fi, argp);
+	case RAW1394_IOC_ISO_RECV_INIT:
+		return raw1394_iso_recv_init(fi, argp);
+	default:
+		return -EINVAL;
+	}
+}
+
+static long raw1394_ioctl_recv(struct file_info *fi, unsigned int cmd,
+			       unsigned long arg)
 {
-	struct file_info *fi = file->private_data;
 	void __user *argp = (void __user *)arg;
 
-	switch (fi->iso_state) {
-	case RAW1394_ISO_INACTIVE:
-		switch (cmd) {
-		case RAW1394_IOC_ISO_XMIT_INIT:
-			return raw1394_iso_xmit_init(fi, argp);
-		case RAW1394_IOC_ISO_RECV_INIT:
-			return raw1394_iso_recv_init(fi, argp);
-		default:
-			break;
+	switch (cmd) {
+	case RAW1394_IOC_ISO_RECV_START:{
+			int args[3];
+
+			if (copy_from_user(&args[0], argp, sizeof(args)))
+				return -EFAULT;
+			return hpsb_iso_recv_start(fi->iso_handle,
+						   args[0], args[1], args[2]);
 		}
-		break;
-	case RAW1394_ISO_RECV:
-		switch (cmd) {
-		case RAW1394_IOC_ISO_RECV_START:{
-				/* copy args from user-space */
-				int args[3];
-				if (copy_from_user
-				    (&args[0], argp, sizeof(args)))
-					return -EFAULT;
-				return hpsb_iso_recv_start(fi->iso_handle,
-							   args[0], args[1],
-							   args[2]);
-			}
-		case RAW1394_IOC_ISO_XMIT_RECV_STOP:
-			hpsb_iso_stop(fi->iso_handle);
-			return 0;
-		case RAW1394_IOC_ISO_RECV_LISTEN_CHANNEL:
-			return hpsb_iso_recv_listen_channel(fi->iso_handle,
-							    arg);
-		case RAW1394_IOC_ISO_RECV_UNLISTEN_CHANNEL:
-			return hpsb_iso_recv_unlisten_channel(fi->iso_handle,
-							      arg);
-		case RAW1394_IOC_ISO_RECV_SET_CHANNEL_MASK:{
-				/* copy the u64 from user-space */
-				u64 mask;
-				if (copy_from_user(&mask, argp, sizeof(mask)))
-					return -EFAULT;
-				return hpsb_iso_recv_set_channel_mask(fi->
-								      iso_handle,
-								      mask);
-			}
-		case RAW1394_IOC_ISO_GET_STATUS:
-			return raw1394_iso_get_status(fi, argp);
-		case RAW1394_IOC_ISO_RECV_PACKETS:
-			return raw1394_iso_recv_packets(fi, argp);
-		case RAW1394_IOC_ISO_RECV_RELEASE_PACKETS:
-			return hpsb_iso_recv_release_packets(fi->iso_handle,
-							     arg);
-		case RAW1394_IOC_ISO_RECV_FLUSH:
-			return hpsb_iso_recv_flush(fi->iso_handle);
-		case RAW1394_IOC_ISO_SHUTDOWN:
-			raw1394_iso_shutdown(fi);
-			return 0;
-		case RAW1394_IOC_ISO_QUEUE_ACTIVITY:
-			queue_rawiso_event(fi);
-			return 0;
+	case RAW1394_IOC_ISO_XMIT_RECV_STOP:
+		hpsb_iso_stop(fi->iso_handle);
+		return 0;
+	case RAW1394_IOC_ISO_RECV_LISTEN_CHANNEL:
+		return hpsb_iso_recv_listen_channel(fi->iso_handle, arg);
+	case RAW1394_IOC_ISO_RECV_UNLISTEN_CHANNEL:
+		return hpsb_iso_recv_unlisten_channel(fi->iso_handle, arg);
+	case RAW1394_IOC_ISO_RECV_SET_CHANNEL_MASK:{
+			u64 mask;
+
+			if (copy_from_user(&mask, argp, sizeof(mask)))
+				return -EFAULT;
+			return hpsb_iso_recv_set_channel_mask(fi->iso_handle,
+							      mask);
 		}
-		break;
-	case RAW1394_ISO_XMIT:
-		switch (cmd) {
-		case RAW1394_IOC_ISO_XMIT_START:{
-				/* copy two ints from user-space */
-				int args[2];
-				if (copy_from_user
-				    (&args[0], argp, sizeof(args)))
-					return -EFAULT;
-				return hpsb_iso_xmit_start(fi->iso_handle,
-							   args[0], args[1]);
-			}
-		case RAW1394_IOC_ISO_XMIT_SYNC:
-			return hpsb_iso_xmit_sync(fi->iso_handle);
-		case RAW1394_IOC_ISO_XMIT_RECV_STOP:
-			hpsb_iso_stop(fi->iso_handle);
-			return 0;
-		case RAW1394_IOC_ISO_GET_STATUS:
-			return raw1394_iso_get_status(fi, argp);
-		case RAW1394_IOC_ISO_XMIT_PACKETS:
-			return raw1394_iso_send_packets(fi, argp);
-		case RAW1394_IOC_ISO_SHUTDOWN:
-			raw1394_iso_shutdown(fi);
-			return 0;
-		case RAW1394_IOC_ISO_QUEUE_ACTIVITY:
-			queue_rawiso_event(fi);
-			return 0;
+	case RAW1394_IOC_ISO_GET_STATUS:
+		return raw1394_iso_get_status(fi, argp);
+	case RAW1394_IOC_ISO_RECV_PACKETS:
+		return raw1394_iso_recv_packets(fi, argp);
+	case RAW1394_IOC_ISO_RECV_RELEASE_PACKETS:
+		return hpsb_iso_recv_release_packets(fi->iso_handle, arg);
+	case RAW1394_IOC_ISO_RECV_FLUSH:
+		return hpsb_iso_recv_flush(fi->iso_handle);
+	case RAW1394_IOC_ISO_SHUTDOWN:
+		raw1394_iso_shutdown(fi);
+		return 0;
+	case RAW1394_IOC_ISO_QUEUE_ACTIVITY:
+		queue_rawiso_event(fi);
+		return 0;
+	default:
+		return -EINVAL;
+	}
+}
+
+static long raw1394_ioctl_xmit(struct file_info *fi, unsigned int cmd,
+			       void __user *argp)
+{
+	switch (cmd) {
+	case RAW1394_IOC_ISO_XMIT_START:{
+			int args[2];
+
+			if (copy_from_user(&args[0], argp, sizeof(args)))
+				return -EFAULT;
+			return hpsb_iso_xmit_start(fi->iso_handle,
+						   args[0], args[1]);
 		}
-		break;
+	case RAW1394_IOC_ISO_XMIT_SYNC:
+		return hpsb_iso_xmit_sync(fi->iso_handle);
+	case RAW1394_IOC_ISO_XMIT_RECV_STOP:
+		hpsb_iso_stop(fi->iso_handle);
+		return 0;
+	case RAW1394_IOC_ISO_GET_STATUS:
+		return raw1394_iso_get_status(fi, argp);
+	case RAW1394_IOC_ISO_XMIT_PACKETS:
+		return raw1394_iso_send_packets(fi, argp);
+	case RAW1394_IOC_ISO_SHUTDOWN:
+		raw1394_iso_shutdown(fi);
+		return 0;
+	case RAW1394_IOC_ISO_QUEUE_ACTIVITY:
+		queue_rawiso_event(fi);
+		return 0;
 	default:
-		break;
+		return -EINVAL;
 	}
+}
+
+/* ioctl is only used for rawiso operations */
+static long raw1394_ioctl(struct file *file, unsigned int cmd,
+			  unsigned long arg)
+{
+	struct file_info *fi = file->private_data;
+	void __user *argp = (void __user *)arg;
+	long ret;
 
 	/* state-independent commands */
 	switch(cmd) {
@@ -2661,18 +2665,25 @@ static long do_raw1394_ioctl(struct file
 		break;
 	}
 
-	return -EINVAL;
-}
+	mutex_lock(&fi->state_mutex);
 
-static long raw1394_ioctl(struct file *file, unsigned int cmd,
-							unsigned long arg)
-{
-	struct file_info *fi = file->private_data;
-	long ret;
+	switch (fi->iso_state) {
+	case RAW1394_ISO_INACTIVE:
+		ret = raw1394_ioctl_inactive(fi, cmd, argp);
+		break;
+	case RAW1394_ISO_RECV:
+		ret = raw1394_ioctl_recv(fi, cmd, arg);
+		break;
+	case RAW1394_ISO_XMIT:
+		ret = raw1394_ioctl_xmit(fi, cmd, argp);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
 
-	mutex_lock(&fi->state_mutex);
-	ret = do_raw1394_ioctl(file, cmd, arg);
 	mutex_unlock(&fi->state_mutex);
+
 	return ret;
 }
 
@@ -2734,7 +2745,6 @@ static long raw1394_compat_ioctl(struct 
 	void __user *argp = (void __user *)arg;
 	long err;
 
-	mutex_lock(&fi->state_mutex);
 	switch (cmd) {
 	/* These requests have same format as long as 'int' has same size. */
 	case RAW1394_IOC_ISO_RECV_INIT:
@@ -2767,7 +2777,6 @@ static long raw1394_compat_ioctl(struct 
 		err = -EINVAL;
 		break;
 	}
-	mutex_unlock(&fi->state_mutex);
 
 	return err;
 }

-- 
Stefan Richter
-=====-==--- =--- =----
http://arcgraph.de/sr/

