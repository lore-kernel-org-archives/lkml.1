Return-Path: <linux-kernel-owner+w=401wt.eu-S1760256AbYEWWts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760256AbYEWWts (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 18:49:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757337AbYEWWtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 18:49:39 -0400
Received: from www.tglx.de ([62.245.132.106]:45283 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753510AbYEWWth convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 18:49:37 -0400
Date: Sat, 24 May 2008 00:49:17 +0200
From: =?UTF-8?B?SGFucy1Kw7xyZ2Vu?= Koch <hjk@linutronix.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= <Uwe.Kleine-Koenig@digi.com>,
       <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Jan Altenberg <jan.altenberg@linutronix.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH 1/1] UIO: Add a write() function to enable/disable
 interrupts
Message-ID: <20080524004917.6a226e96@dilbert.local>
In-Reply-To: <20080523113650.2467f2ee.randy.dunlap@oracle.com>
References: <20080522192252.GB3226@local>
	<20080522192637.GC3226@local>
	<20080523055527.GA28963@digi.com>
	<20080523104454.4e2af6ec@bluebox.local>
	<20080523091009.GA22821@digi.com>
	<20080523120308.7bec1e1c@bluebox.local>
	<20080523105604.GA23800@digi.com>
	<20080523135557.27fe4855@bluebox.local>
	<20080523113650.2467f2ee.randy.dunlap@oracle.com>
Organization: Linutronix
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Fri, 23 May 2008 11:36:50 -0700
schrieb Randy Dunlap <randy.dunlap@oracle.com>:

>
> > +	For some hardware that has more than one interrupt source internally,
> > +	but not seperate IRQ mask and status registers, there might be
> 
> 	        separate
> 
> > +	situations where userspace cannot determine what the interrupt source
> > +	was if the kernel handler disables them by writing to the chip's IRQ
> > +	register. In such a case, the kernel has to disable the IRQ completely
> > +	to leave the chip's register untouched. Now the userspace part can
> > +	determine the cause of the interrupt, but it cannot re-enable
> > +	interrupts. Another cornercase are chips where re-enabling interrupts
> 
> 	                               is
> 
> > +	is a read-modify-write operation to a combined IRQ status/acknowledge
> > +	register. This would be racy if a new interrupt occured
> 
> 	                                                occurred
> 
> > +	simultaneously.
> > +	</para>
> > +	<para>
> > +	To address these problems, UIO also implements a write() function. It
> > +	is normally not used and can be ignored for hardware that has only a
> > +	single interrupt source or has seperate IRQ mask and status registers.
> 
> 	                               separate
> ["There's <a rat> in separate."]

I'll certainly remember that one :-)

> 
> > +	If you need it, however, a write to <filename>/dev/uioX</filename>
> > +	will call the <function>irqcontrol()</function> function implemented
> > +	by the driver. You have to write a 32-bit value that is usually either
> > +	0 or 1 do disable or enable interrupts. If a driver does not implement
> 
> 	       to
> 
> > +	<function>irqcontrol()</function>, <function>write()</function> will
> > +	return with <varname>-ENOSYS</varname>.
> > +	</para>
> 
> ---
> ~Randy

Thanks a lot for reviewing this! Corrected patch below.

Hans

From: Hans J. Koch <hjk@linutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
	Jan Altenberg <jan.altenberg@linutronix.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>,
	Magnus Damm <magnus.damm@gmail.com>
Subject: UIO: Add write function to allow irq masking
Date: Thu, Fri, 23 May 2008 13:50:14 +0200

Sometimes it is necessary to enable/disable the interrupt of a UIO device
from the userspace part of the driver. With this patch, the UIO kernel driver
can implement an "irqcontrol()" function that does this. Userspace can write
an s32 value to /dev/uioX (usually 0 or 1 to turn the irq off or on). The
UIO core will then call the driver's irqcontrol function.

Signed-off-by: Hans J. Koch <hjk@linutronix.de>
---
 Documentation/DocBook/uio-howto.tmpl |   40 ++++++++++++++++++++++++++++++++++-
 drivers/uio/uio.c                    |   26 ++++++++++++++++++++++
 include/linux/uio_driver.h           |    2 +
 3 files changed, 67 insertions(+), 1 deletion(-)

Index: linux-2.6.26-rc/include/linux/uio_driver.h
===================================================================
--- linux-2.6.26-rc.orig/include/linux/uio_driver.h	2008-05-22 20:22:57.000000000 +0200
+++ linux-2.6.26-rc/include/linux/uio_driver.h	2008-05-22 20:23:12.000000000 +0200
@@ -53,6 +53,7 @@
  * @mmap:		mmap operation for this uio device
  * @open:		open operation for this uio device
  * @release:		release operation for this uio device
+ * @irqcontrol:		disable/enable irqs when 0/1 is written to /dev/uioX
  */
 struct uio_info {
 	struct uio_device	*uio_dev;
@@ -66,6 +67,7 @@
 	int (*mmap)(struct uio_info *info, struct vm_area_struct *vma);
 	int (*open)(struct uio_info *info, struct inode *inode);
 	int (*release)(struct uio_info *info, struct inode *inode);
+	int (*irqcontrol)(struct uio_info *info, s32 irq_on);
 };
 
 extern int __must_check
Index: linux-2.6.26-rc/drivers/uio/uio.c
===================================================================
--- linux-2.6.26-rc.orig/drivers/uio/uio.c	2008-05-22 20:23:07.000000000 +0200
+++ linux-2.6.26-rc/drivers/uio/uio.c	2008-05-23 13:49:40.000000000 +0200
@@ -420,6 +420,31 @@
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
@@ -539,6 +564,7 @@
 	.open		= uio_open,
 	.release	= uio_release,
 	.read		= uio_read,
+	.write		= uio_write,
 	.mmap		= uio_mmap,
 	.poll		= uio_poll,
 	.fasync		= uio_fasync,
Index: linux-2.6.26-rc/Documentation/DocBook/uio-howto.tmpl
===================================================================
--- linux-2.6.26-rc.orig/Documentation/DocBook/uio-howto.tmpl	2008-05-22 20:22:57.000000000 +0200
+++ linux-2.6.26-rc/Documentation/DocBook/uio-howto.tmpl	2008-05-24 00:33:48.000000000 +0200
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
@@ -189,6 +195,30 @@
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
@@ -362,6 +392,14 @@
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

