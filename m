Return-Path: <linux-kernel-owner+w=401wt.eu-S1760170AbYGVFku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760170AbYGVFku (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755351AbYGVFZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:25:33 -0400
Received: from cantor.suse.de ([195.135.220.2]:54041 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756883AbYGVFZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:25:31 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Hans J. Koch" <hjk@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 57/79] UIO: Add write function to allow irq masking
Date: Mon, 21 Jul 2008 22:19:21 -0700
Message-Id: <1216703983-21448-57-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans J. Koch <hjk@linutronix.de>

Sometimes it is necessary to enable/disable the interrupt of a UIO device
from the userspace part of the driver. With this patch, the UIO kernel driver
can implement an "irqcontrol()" function that does this. Userspace can write
an s32 value to /dev/uioX (usually 0 or 1 to turn the irq off or on). The
UIO core will then call the driver's irqcontrol function.

Signed-off-by: Hans J. Koch <hjk@linutronix.de>
Acked-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
Acked-by: Magnus Damm <damm@igel.co.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/DocBook/uio-howto.tmpl |   40 +++++++++++++++++++++++++++++++++-
 drivers/uio/uio.c                    |   26 ++++++++++++++++++++++
 include/linux/uio_driver.h           |    2 +
 3 files changed, 67 insertions(+), 1 deletions(-)

diff --git a/Documentation/DocBook/uio-howto.tmpl b/Documentation/DocBook/uio-howto.tmpl
index fdd7f4f..c4d1873 100644
--- a/Documentation/DocBook/uio-howto.tmpl
+++ b/Documentation/DocBook/uio-howto.tmpl
@@ -30,6 +30,12 @@
 
 <revhistory>
 	<revision>
+	<revnumber>0.5</revnumber>
+	<date>2008-05-22</date>
+	<authorinitials>hjk</authorinitials>
+	<revremark>Added description of write() function.</revremark>
+	</revision>
+	<revision>
 	<revnumber>0.4</revnumber>
 	<date>2007-11-26</date>
 	<authorinitials>hjk</authorinitials>
@@ -64,7 +70,7 @@
 <?dbhtml filename="copyright.html"?>
 <title>Copyright and License</title>
 <para>
-      Copyright (c) 2006 by Hans-Jürgen Koch.</para>
+      Copyright (c) 2006-2008 by Hans-Jürgen Koch.</para>
 <para>
 This documentation is Free Software licensed under the terms of the
 GPL version 2.
@@ -189,6 +195,30 @@ interested in translating it, please email me
 	represents the total interrupt count. You can use this number
 	to figure out if you missed some interrupts.
 	</para>
+	<para>
+	For some hardware that has more than one interrupt source internally,
+	but not separate IRQ mask and status registers, there might be
+	situations where userspace cannot determine what the interrupt source
+	was if the kernel handler disables them by writing to the chip's IRQ
+	register. In such a case, the kernel has to disable the IRQ completely
+	to leave the chip's register untouched. Now the userspace part can
+	determine the cause of the interrupt, but it cannot re-enable
+	interrupts. Another cornercase is chips where re-enabling interrupts
+	is a read-modify-write operation to a combined IRQ status/acknowledge
+	register. This would be racy if a new interrupt occurred
+	simultaneously.
+	</para>
+	<para>
+	To address these problems, UIO also implements a write() function. It
+	is normally not used and can be ignored for hardware that has only a
+	single interrupt source or has separate IRQ mask and status registers.
+	If you need it, however, a write to <filename>/dev/uioX</filename>
+	will call the <function>irqcontrol()</function> function implemented
+	by the driver. You have to write a 32-bit value that is usually either
+	0 or 1 to disable or enable interrupts. If a driver does not implement
+	<function>irqcontrol()</function>, <function>write()</function> will
+	return with <varname>-ENOSYS</varname>.
+	</para>
 
 	<para>
 	To handle interrupts properly, your custom kernel module can
@@ -362,6 +392,14 @@ device is actually used.
 <function>open()</function>, you will probably also want a custom
 <function>release()</function> function.
 </para></listitem>
+
+<listitem><para>
+<varname>int (*irqcontrol)(struct uio_info *info, s32 irq_on)
+</varname>: Optional. If you need to be able to enable or disable
+interrupts from userspace by writing to <filename>/dev/uioX</filename>,
+you can implement this function. The parameter <varname>irq_on</varname>
+will be 0 to disable interrupts and 1 to enable them.
+</para></listitem>
 </itemizedlist>
 
 <para>
diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index 5a7ca2e..3a6934b 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -427,6 +427,31 @@ static ssize_t uio_read(struct file *filep, char __user *buf,
 	return retval;
 }
 
+static ssize_t uio_write(struct file *filep, const char __user *buf,
+			size_t count, loff_t *ppos)
+{
+	struct uio_listener *listener = filep->private_data;
+	struct uio_device *idev = listener->dev;
+	ssize_t retval;
+	s32 irq_on;
+
+	if (idev->info->irq == UIO_IRQ_NONE)
+		return -EIO;
+
+	if (count != sizeof(s32))
+		return -EINVAL;
+
+	if (!idev->info->irqcontrol)
+		return -ENOSYS;
+
+	if (copy_from_user(&irq_on, buf, count))
+		return -EFAULT;
+
+	retval = idev->info->irqcontrol(idev->info, irq_on);
+
+	return retval ? retval : sizeof(s32);
+}
+
 static int uio_find_mem_index(struct vm_area_struct *vma)
 {
 	int mi;
@@ -546,6 +571,7 @@ static const struct file_operations uio_fops = {
 	.open		= uio_open,
 	.release	= uio_release,
 	.read		= uio_read,
+	.write		= uio_write,
 	.mmap		= uio_mmap,
 	.poll		= uio_poll,
 	.fasync		= uio_fasync,
diff --git a/include/linux/uio_driver.h b/include/linux/uio_driver.h
index 973386d..cf65e96 100644
--- a/include/linux/uio_driver.h
+++ b/include/linux/uio_driver.h
@@ -53,6 +53,7 @@ struct uio_device;
  * @mmap:		mmap operation for this uio device
  * @open:		open operation for this uio device
  * @release:		release operation for this uio device
+ * @irqcontrol:		disable/enable irqs when 0/1 is written to /dev/uioX
  */
 struct uio_info {
 	struct uio_device	*uio_dev;
@@ -66,6 +67,7 @@ struct uio_info {
 	int (*mmap)(struct uio_info *info, struct vm_area_struct *vma);
 	int (*open)(struct uio_info *info, struct inode *inode);
 	int (*release)(struct uio_info *info, struct inode *inode);
+	int (*irqcontrol)(struct uio_info *info, s32 irq_on);
 };
 
 extern int __must_check
-- 
1.5.6.3

