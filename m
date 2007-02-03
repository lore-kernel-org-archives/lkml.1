Return-Path: <linux-kernel-owner+w=401wt.eu-S1946009AbXBCM6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946009AbXBCM6z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 07:58:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946022AbXBCM6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 07:58:55 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:51791 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946009AbXBCM6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 07:58:54 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 3 Feb 2007 13:58:07 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH update] ieee1394: cycle timer read extension for
 raw1394/libraw1394
To: Pieter Palmers <pieterp@joow.be>, Dan Dennedy <dan@dennedy.org>
cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <45BB4A33.4070206@s5r6.in-berlin.de>
Message-ID: <tkrat.e06f68103e99e517@s5r6.in-berlin.de>
References: <45BA5CFD.6070900@joow.be> <45BB27AF.7030007@s5r6.in-berlin.de>
 <45BB2D67.7030608@joow.be> <45BB4A33.4070206@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pieter Palmers <pieterp@joow.be>

This implements the simultaneous read of the isochronous cycle timer and
the system clock (in usecs).  This allows to express the exact receive
time of an ISO packet as a system time with microsecond accuracy.
http://bugzilla.kernel.org/show_bug.cgi?id=7773

The counterpart patch for libraw1394 can be found at
http://thread.gmane.org/gmane.linux.kernel.firewire.devel/8934

Patch update (Stefan R.):
  - Disable preemption and local interrupts.
  - Fix integer overflow.
  - Add paranoid error checks and kerneldoc to hpsb_read_cycle_timer.
    Move it to other ieee1394_core high-level API functions.
  - Rename userspace-exported struct _raw1394_cycle_timer to
    raw1394_cycle_timer.  Change comments in raw1394.
  - Adjust whitespace.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

Pieter, Dan, is this OK?  I only compile-tested.

 drivers/ieee1394/ieee1394-ioctl.h |    2 +
 drivers/ieee1394/ieee1394_core.c  |   43 ++++++++++++++++++++++++++++++
 drivers/ieee1394/ieee1394_core.h  |    3 ++
 drivers/ieee1394/raw1394.c        |   20 +++++++++++++
 drivers/ieee1394/raw1394.h        |   10 ++++++
 5 files changed, 78 insertions(+)

Index: linux/drivers/ieee1394/ieee1394-ioctl.h
===================================================================
--- linux.orig/drivers/ieee1394/ieee1394-ioctl.h	2007-01-01 01:53:20.000000000 +0100
+++ linux/drivers/ieee1394/ieee1394-ioctl.h	2007-02-03 13:47:33.000000000 +0100
@@ -100,5 +100,7 @@
 	_IO  ('#', 0x28)
 #define RAW1394_IOC_ISO_RECV_FLUSH		\
 	_IO  ('#', 0x29)
+#define RAW1394_IOC_GET_CYCLE_TIMER		\
+	_IOR ('#', 0x30, struct raw1394_cycle_timer)
 
 #endif /* __IEEE1394_IOCTL_H */
Index: linux/drivers/ieee1394/ieee1394_core.c
===================================================================
--- linux.orig/drivers/ieee1394/ieee1394_core.c	2007-01-27 14:07:00.000000000 +0100
+++ linux/drivers/ieee1394/ieee1394_core.c	2007-02-03 13:47:33.000000000 +0100
@@ -33,6 +33,9 @@
 #include <linux/skbuff.h>
 #include <linux/suspend.h>
 #include <linux/kthread.h>
+#include <linux/irqflags.h>
+#include <linux/preempt.h>
+#include <linux/time.h>
 
 #include <asm/byteorder.h>
 
@@ -186,6 +189,45 @@ int hpsb_reset_bus(struct hpsb_host *hos
 	}
 }
 
+/**
+ * hpsb_read_cycle_timer - read cycle timer register and system time
+ * @host: host whose isochronous cycle timer register is read
+ * @cycle_timer: address of bitfield to return the register contents
+ * @local_time: address to return the system time
+ *
+ * The format of * @cycle_timer, is described in OHCI 1.1 clause 5.13. This
+ * format is also read from non-OHCI controllers. * @local_time contains the
+ * system time in microseconds since the Epoch, read at the moment when the
+ * cycle timer was read.
+ *
+ * Return value: 0 for success or error number otherwise.
+ */
+int hpsb_read_cycle_timer(struct hpsb_host *host, u32 *cycle_timer,
+			  u64 *local_time)
+{
+	int ctr;
+	struct timeval tv;
+	unsigned long flags;
+
+	if (!host || !cycle_timer || !local_time)
+		return -EINVAL;
+
+	preempt_disable();
+	local_irq_save(flags);
+
+	ctr = host->driver->devctl(host, GET_CYCLE_COUNTER, 0);
+	if (ctr)
+		do_gettimeofday(&tv);
+
+	local_irq_restore(flags);
+	preempt_enable();
+
+	if (!ctr)
+		return -EIO;
+	*cycle_timer = ctr;
+	*local_time = tv.tv_sec * USEC_PER_SEC + tv.tv_usec;
+	return 0;
+}
 
 int hpsb_bus_reset(struct hpsb_host *host)
 {
@@ -1190,6 +1232,7 @@ EXPORT_SYMBOL(hpsb_alloc_packet);
 EXPORT_SYMBOL(hpsb_free_packet);
 EXPORT_SYMBOL(hpsb_send_packet);
 EXPORT_SYMBOL(hpsb_reset_bus);
+EXPORT_SYMBOL(hpsb_read_cycle_timer);
 EXPORT_SYMBOL(hpsb_bus_reset);
 EXPORT_SYMBOL(hpsb_selfid_received);
 EXPORT_SYMBOL(hpsb_selfid_complete);
Index: linux/drivers/ieee1394/ieee1394_core.h
===================================================================
--- linux.orig/drivers/ieee1394/ieee1394_core.h	2007-01-01 01:53:20.000000000 +0100
+++ linux/drivers/ieee1394/ieee1394_core.h	2007-02-03 13:47:33.000000000 +0100
@@ -127,6 +127,9 @@ int hpsb_send_packet_and_wait(struct hps
  * progress, 0 otherwise. */
 int hpsb_reset_bus(struct hpsb_host *host, int type);
 
+int hpsb_read_cycle_timer(struct hpsb_host *host, u32 *cycle_timer,
+			  u64 *local_time);
+
 /*
  * The following functions are exported for host driver module usage.  All of
  * them are safe to use in interrupt contexts, although some are quite
Index: linux/drivers/ieee1394/raw1394.c
===================================================================
--- linux.orig/drivers/ieee1394/raw1394.c	2007-01-27 14:07:00.000000000 +0100
+++ linux/drivers/ieee1394/raw1394.c	2007-02-03 13:47:34.000000000 +0100
@@ -2664,6 +2664,18 @@ static void raw1394_iso_shutdown(struct 
 	fi->iso_state = RAW1394_ISO_INACTIVE;
 }
 
+static int raw1394_read_cycle_timer(struct file_info *fi, void __user * uaddr)
+{
+	struct raw1394_cycle_timer ct;
+	int err;
+
+	err = hpsb_read_cycle_timer(fi->host, &ct.cycle_timer, &ct.local_time);
+	if (!err)
+		if (copy_to_user(uaddr, &ct, sizeof(ct)))
+			err = -EFAULT;
+	return err;
+}
+
 /* mmap the rawiso xmit/recv buffer */
 static int raw1394_mmap(struct file *file, struct vm_area_struct *vma)
 {
@@ -2772,6 +2784,14 @@ static int raw1394_ioctl(struct inode *i
 		break;
 	}
 
+	/* state-independent commands */
+	switch(cmd) {
+	case RAW1394_IOC_GET_CYCLE_TIMER:
+		return raw1394_read_cycle_timer(fi, argp);
+	default:
+		break;
+	}
+
 	return -EINVAL;
 }
 
Index: linux/drivers/ieee1394/raw1394.h
===================================================================
--- linux.orig/drivers/ieee1394/raw1394.h	2007-01-01 01:53:20.000000000 +0100
+++ linux/drivers/ieee1394/raw1394.h	2007-02-03 13:47:34.000000000 +0100
@@ -178,4 +178,14 @@ struct raw1394_iso_status {
 	__s16 xmit_cycle;
 };
 
+/* argument to RAW1394_IOC_GET_CYCLE_TIMER ioctl */
+struct raw1394_cycle_timer {
+	/* contents of Isochronous Cycle Timer register,
+	   as in OHCI 1.1 clause 5.13 (also with non-OHCI hosts) */
+	__u32 cycle_timer;
+
+	/* local time in microseconds since Epoch,
+	   simultaneously read with cycle timer */
+	__u64 local_time;
+};
 #endif /* IEEE1394_RAW1394_H */


-- 
Stefan Richter
-=====-=-=== --=- ---==
http://arcgraph.de/sr/

