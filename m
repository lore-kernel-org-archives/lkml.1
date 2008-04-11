Return-Path: <linux-kernel-owner+w=401wt.eu-S1760042AbYDKJR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760042AbYDKJR6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 05:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759922AbYDKJRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 05:17:48 -0400
Received: from mail4.zarcrom.net ([209.236.236.162]:38877 "EHLO
	mail4.zarcrom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758642AbYDKJRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 05:17:47 -0400
X-Greylist: delayed 1150 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Apr 2008 05:17:47 EDT
Subject: [RFC][PATCH] HPET: register additional counter-only char device
From: Dimitri Gorokhovik <dimitri.gorokhovik@leacom.fr>
To: tglx@linutronix.de
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 11 Apr 2008 10:58:27 +0200
Message-Id: <1207904307.13216.15.camel@laphroaig>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
X-Originating-IP: 83.206.44.221
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I need to have many processes all reading from userspace the counter register
of the (same) HPET hardware. Just reading counter values, not handling timers, 
enabling/disabling interrupts etc. `/dev/hpet' doesn't allow for this, as the 
number of times it can be opened is limited by the number of timers available. 

What would be the right way to implement such a support? For now, I simply
register a new misc device, '/dev/hpetctr', along with '/dev/hpet', for the same
ACPI device and on the same occasion.

Tested on 2.6.24-86_64-rt4 and on 2.6.25-rc8-git8.

---

Register a device `/dev/hpetctr' (10:229) giving access to the counter   
of a HPET hw module. The available operations are: `open', `close' and
a read-only `mmap'. Contrary to `dev/hpet' it can be opened an unlimited 
number of times. `read' not provided because of the cost of the system
call making the operation pointless.

Signed-off-by: Dimitri Gorokhovik <dimitri.gorokhovik@free.fr>
---
 drivers/char/hpet.c        |   71 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/miscdevice.h |    1 
 2 files changed, 72 insertions(+)

diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index 1399971..d94c3ce 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -218,6 +218,24 @@ static int hpet_open(struct inode *inode, struct file *file)
 	return 0;
 }
 
+static int hpetctr_open(struct inode *inode, struct file *file)
+{
+	if (file->f_mode & FMODE_WRITE)
+		return -EINVAL;
+
+	spin_lock_irq(&hpet_lock);
+
+	if (hpets == NULL) {
+		spin_unlock_irq(&hpet_lock);
+		return -ENOSYS;
+	}
+
+	file->private_data = (void *)hpets->hp_hpet_phys;
+	spin_unlock_irq(&hpet_lock);
+
+	return 0;
+}
+
 static ssize_t
 hpet_read(struct file *file, char __user *buf, size_t count, loff_t * ppos)
 {
@@ -318,6 +336,34 @@ static int hpet_mmap(struct file *file, struct vm_area_struct *vma)
 #endif
 }
 
+
+static int hpetctr_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	unsigned long addr;
+
+	if (((vma->vm_end - vma->vm_start) != PAGE_SIZE) || vma->vm_pgoff)
+		return -EINVAL;
+
+	if (pgprot_val(vma->vm_page_prot) != pgprot_val(PAGE_READONLY))
+		return -EPERM;
+
+	addr = (unsigned long)file->private_data;
+	if (addr & (PAGE_SIZE - 1))
+		return -ENOSYS;
+
+	vma->vm_flags |= VM_IO;
+	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+
+	if (io_remap_pfn_range(vma, vma->vm_start, addr >> PAGE_SHIFT,
+					PAGE_SIZE, vma->vm_page_prot)) {
+		printk(KERN_ERR "%s: io_remap_pfn_range failed\n",
+			__FUNCTION__);
+		return -EAGAIN;
+	}
+
+	return 0;
+}
+
 static int hpet_fasync(int fd, struct file *file, int on)
 {
 	struct hpet_dev *devp;
@@ -371,6 +417,13 @@ static int hpet_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
+static int hpetctr_release(struct inode *inode, struct file *file)
+{
+	file->private_data = NULL;
+	return 0;
+}
+
+
 static int hpet_ioctl_common(struct hpet_dev *, int, unsigned long, int);
 
 static int
@@ -589,6 +642,14 @@ static const struct file_operations hpet_fops = {
 	.mmap = hpet_mmap,
 };
 
+static const struct file_operations hpetctr_fops = {
+	.owner = THIS_MODULE,
+	.llseek = no_llseek,
+	.open = hpetctr_open,
+	.release = hpetctr_release,
+	.mmap = hpetctr_mmap,
+};
+
 static int hpet_is_known(struct hpet_data *hdp)
 {
 	struct hpets *hpetp;
@@ -954,6 +1015,9 @@ static struct acpi_driver hpet_acpi_driver = {
 };
 
 static struct miscdevice hpet_misc = { HPET_MINOR, "hpet", &hpet_fops };
+static struct miscdevice hpetctr_misc = {
+	HPETCTR_MINOR, "hpetctr", &hpetctr_fops
+};
 
 static int __init hpet_init(void)
 {
@@ -973,11 +1037,18 @@ static int __init hpet_init(void)
 		return result;
 	}
 
+	result = misc_register(&hpetctr_misc);
+	if (result < 0)
+		printk(KERN_ERR "%s: failed to register '/dev/hpetctr'\n",
+			__FUNCTION__);
+
 	return 0;
 }
 
 static void __exit hpet_exit(void)
 {
+	misc_deregister(&hpetctr_misc);
+
 	acpi_bus_unregister_driver(&hpet_acpi_driver);
 
 	if (sysctl_header)
diff --git a/include/linux/miscdevice.h b/include/linux/miscdevice.h
index 24b30b9..76c9b76 100644
--- a/include/linux/miscdevice.h
+++ b/include/linux/miscdevice.h
@@ -29,6 +29,7 @@
 
 #define TUN_MINOR	     200
 #define	HPET_MINOR	     228
+#define HPETCTR_MINOR	     229
 #define KVM_MINOR            232
 
 struct device;

