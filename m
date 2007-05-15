Return-Path: <linux-kernel-owner+w=401wt.eu-S1760256AbXEOXCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760256AbXEOXCv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 19:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757507AbXEOXCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 19:02:45 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:49712 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756462AbXEOXCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 19:02:44 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 16 May 2007 01:02:35 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 3/3] ieee1394: raw1394: Add ioctl() for 32bit userland on
 64bit kernel
To: Petr Vandrovec <petr@vandrovec.name>
cc: dan@dennedy.org, linux1394-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.35349e18fd1db577@s5r6.in-berlin.de>
Message-ID: <tkrat.32fb8eba4555daaa@s5r6.in-berlin.de>
References: <20070507021447.GA22197@vana.vc.cvut.cz>
 <tkrat.a2f16b56bae46a1e@s5r6.in-berlin.de>
 <tkrat.0e3c053d4bae6087@s5r6.in-berlin.de>
 <tkrat.35349e18fd1db577@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Date: Mon, 7 May 2007 04:14:47 +0200
From: Petr Vandrovec <petr@vandrovec.name>

Add compat_ioctl.  Although all structures are more or less same,
raw1394_iso_packets got pointer inside, and raw1394_cycle_timer got unwanted
padding in the middle.  I did not add any translation for ioctls passing array
of integers around as integers seem to have same size (32 bits) on all 
architectures supported by Linux.

Signed-off-by: Petr Vandrovec <petr@vandrovec.name>
Acked-by: Dan Dennedy <dan@dennedy.org>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de> (split into 3 patches)
---
 drivers/ieee1394/raw1394.c |   97 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 96 insertions(+), 1 deletion(-)

patch update: omitted trailing whitespace

Index: linux-2.6.22-rc1/drivers/ieee1394/raw1394.c
===================================================================
--- linux-2.6.22-rc1.orig/drivers/ieee1394/raw1394.c
+++ linux-2.6.22-rc1/drivers/ieee1394/raw1394.c
@@ -2803,6 +2803,99 @@ static int raw1394_ioctl(struct inode *i
 	return -EINVAL;
 }
 
+#ifdef CONFIG_COMPAT
+struct raw1394_iso_packets32 {
+        __u32 n_packets;
+        compat_uptr_t infos;
+} __attribute__((packed));
+
+struct raw1394_cycle_timer32 {
+        __u32 cycle_timer;
+        __u64 local_time;
+} __attribute__((packed));
+
+#define RAW1394_IOC_ISO_RECV_PACKETS32          \
+        _IOW ('#', 0x25, struct raw1394_iso_packets32)
+#define RAW1394_IOC_ISO_XMIT_PACKETS32          \
+        _IOW ('#', 0x27, struct raw1394_iso_packets32)
+#define RAW1394_IOC_GET_CYCLE_TIMER32           \
+        _IOR ('#', 0x30, struct raw1394_cycle_timer32)
+
+static long raw1394_iso_xmit_recv_packets32(struct file *file, unsigned int cmd,
+                                          struct raw1394_iso_packets32 __user *arg)
+{
+	compat_uptr_t infos32;
+	void *infos;
+	long err = -EFAULT;
+	struct raw1394_iso_packets __user *dst = compat_alloc_user_space(sizeof(struct raw1394_iso_packets));
+
+	if (!copy_in_user(&dst->n_packets, &arg->n_packets, sizeof arg->n_packets) &&
+	    !copy_from_user(&infos32, &arg->infos, sizeof infos32)) {
+		infos = compat_ptr(infos32);
+		if (!copy_to_user(&dst->infos, &infos, sizeof infos))
+			err = raw1394_ioctl(NULL, file, cmd, (unsigned long)dst);
+	}
+	return err;
+}
+
+static long raw1394_read_cycle_timer32(struct file_info *fi, void __user * uaddr)
+{
+	struct raw1394_cycle_timer32 ct;
+	int err;
+
+	err = hpsb_read_cycle_timer(fi->host, &ct.cycle_timer, &ct.local_time);
+	if (!err)
+		if (copy_to_user(uaddr, &ct, sizeof(ct)))
+			err = -EFAULT;
+	return err;
+}
+
+static long raw1394_compat_ioctl(struct file *file,
+				 unsigned int cmd, unsigned long arg)
+{
+	struct file_info *fi = file->private_data;
+	void __user *argp = (void __user *)arg;
+	long err;
+
+	lock_kernel();
+	switch (cmd) {
+	/* These requests have same format as long as 'int' has same size. */
+	case RAW1394_IOC_ISO_RECV_INIT:
+	case RAW1394_IOC_ISO_RECV_START:
+	case RAW1394_IOC_ISO_RECV_LISTEN_CHANNEL:
+	case RAW1394_IOC_ISO_RECV_UNLISTEN_CHANNEL:
+	case RAW1394_IOC_ISO_RECV_SET_CHANNEL_MASK:
+	case RAW1394_IOC_ISO_RECV_RELEASE_PACKETS:
+	case RAW1394_IOC_ISO_RECV_FLUSH:
+	case RAW1394_IOC_ISO_XMIT_RECV_STOP:
+	case RAW1394_IOC_ISO_XMIT_INIT:
+	case RAW1394_IOC_ISO_XMIT_START:
+	case RAW1394_IOC_ISO_XMIT_SYNC:
+	case RAW1394_IOC_ISO_GET_STATUS:
+	case RAW1394_IOC_ISO_SHUTDOWN:
+	case RAW1394_IOC_ISO_QUEUE_ACTIVITY:
+		err = raw1394_ioctl(NULL, file, cmd, arg);
+		break;
+	/* These request have different format. */
+	case RAW1394_IOC_ISO_RECV_PACKETS32:
+		err = raw1394_iso_xmit_recv_packets32(file, RAW1394_IOC_ISO_RECV_PACKETS, argp);
+		break;
+	case RAW1394_IOC_ISO_XMIT_PACKETS32:
+		err = raw1394_iso_xmit_recv_packets32(file, RAW1394_IOC_ISO_XMIT_PACKETS, argp);
+		break;
+	case RAW1394_IOC_GET_CYCLE_TIMER32:
+		err = raw1394_read_cycle_timer32(fi, argp);
+		break;
+	default:
+		err = -EINVAL;
+		break;
+	}
+	unlock_kernel();
+
+	return err;
+}
+#endif
+
 static unsigned int raw1394_poll(struct file *file, poll_table * pt)
 {
 	struct file_info *fi = file->private_data;
@@ -3042,7 +3135,9 @@ static const struct file_operations raw1
 	.write = raw1394_write,
 	.mmap = raw1394_mmap,
 	.ioctl = raw1394_ioctl,
-	// .compat_ioctl = ... someone needs to do this
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = raw1394_compat_ioctl,
+#endif
 	.poll = raw1394_poll,
 	.open = raw1394_open,
 	.release = raw1394_release,

-- 
Stefan Richter
-=====-=-=== -=-= =----
http://arcgraph.de/sr/

