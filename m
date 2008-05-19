Return-Path: <linux-kernel-owner+w=401wt.eu-S1764718AbYESXqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764718AbYESXqA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 19:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763943AbYESXpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 19:45:39 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:64463 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763433AbYESXpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 19:45:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 1/3, RFC] misc char dev BKL pushdown
Date: Tue, 20 May 2008 01:26:28 +0200
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org
References: <13762.1211142411@vena.lwn.net> <200805200107.51659.arnd@arndb.de>
In-Reply-To: <200805200107.51659.arnd@arndb.de>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?iso-8859-15?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60?=
 =?iso-8859-15?q?Y=2Ea=5E3zb?=)
 =?iso-8859-15?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5C?=
 =?iso-8859-15?q?wg=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200805200126.29738.arnd@arndb.de>
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX186QBoeshTD09WHTJPxZzqqDlyDmK7CWvpsBgJ
 spOPskuHk1iqHnpO69W7Fwil4nOZ9S5Yqs0R6hE6MRDtiox3Qy
 hekQCDHqtxc8jS7nT2h7g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Big Kernel Lock has been pushed down from chardev_open
to misc_open, this change moves it to the individual misc
driver open functions.

As before, the change was purely mechanical, most drivers
should actually not need the BKL. In particular, we still
hold the misc_mtx() while calling the open() function
The patch should probably be split into one changeset
per driver.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

---
Index: linux-2.6/arch/arm/common/rtctime.c
===================================================================
--- linux-2.6.orig/arch/arm/common/rtctime.c
+++ linux-2.6/arch/arm/common/rtctime.c
@@ -16,6 +16,7 @@
 #include <linux/poll.h>
 #include <linux/proc_fs.h>
 #include <linux/miscdevice.h>
+#include <linux/smp_lock.h>
 #include <linux/spinlock.h>
 #include <linux/capability.h>
 #include <linux/device.h>
@@ -282,6 +283,7 @@ static int rtc_open(struct inode *inode,
 {
 	int ret;
 
+	lock_kernel();
 	mutex_lock(&rtc_mutex);
 
 	if (rtc_inuse) {
@@ -301,6 +303,7 @@ static int rtc_open(struct inode *inode,
 		}
 	}
 	mutex_unlock(&rtc_mutex);
+	unlock_kernel();
 
 	return ret;
 }
Index: linux-2.6/arch/blackfin/mach-bf561/coreb.c
===================================================================
--- linux-2.6.orig/arch/blackfin/mach-bf561/coreb.c
+++ linux-2.6/arch/blackfin/mach-bf561/coreb.c
@@ -32,6 +32,7 @@
 #include <linux/device.h>
 #include <linux/ioport.h>
 #include <linux/module.h>
+#include <linux/smp_lock.h>
 #include <linux/uaccess.h>
 #include <linux/fs.h>
 #include <asm/dma.h>
@@ -196,6 +197,7 @@ static loff_t coreb_lseek(struct file *f
 
 static int coreb_open(struct inode *inode, struct file *file)
 {
+	lock_kernel();
 	spin_lock_irq(&coreb_lock);
 
 	if (coreb_status & COREB_IS_OPEN)
@@ -204,10 +206,12 @@ static int coreb_open(struct inode *inod
 	coreb_status |= COREB_IS_OPEN;
 
 	spin_unlock_irq(&coreb_lock);
+	unlock_kernel();
 	return 0;
 
  out_busy:
 	spin_unlock_irq(&coreb_lock);
+	unlock_kernel();
 	return -EBUSY;
 }
 
Index: linux-2.6/arch/m68k/bvme6000/rtc.c
===================================================================
--- linux-2.6.orig/arch/m68k/bvme6000/rtc.c
+++ linux-2.6/arch/m68k/bvme6000/rtc.c
@@ -10,6 +10,7 @@
 #include <linux/errno.h>
 #include <linux/miscdevice.h>
 #include <linux/slab.h>
+#include <linux/smp_lock.h>
 #include <linux/ioport.h>
 #include <linux/capability.h>
 #include <linux/fcntl.h>
@@ -140,10 +141,14 @@ static int rtc_ioctl(struct inode *inode
 
 static int rtc_open(struct inode *inode, struct file *file)
 {
-	if(rtc_status)
+	lock_kernel();
+	if(rtc_status) {
+		unlock_kernel();
 		return -EBUSY;
+	}
 
 	rtc_status = 1;
+	unlock_kernel();
 	return 0;
 }
 
Index: linux-2.6/arch/m68k/mvme16x/rtc.c
===================================================================
--- linux-2.6.orig/arch/m68k/mvme16x/rtc.c
+++ linux-2.6/arch/m68k/mvme16x/rtc.c
@@ -10,6 +10,7 @@
 #include <linux/errno.h>
 #include <linux/miscdevice.h>
 #include <linux/slab.h>
+#include <linux/smp_lock.h>
 #include <linux/ioport.h>
 #include <linux/capability.h>
 #include <linux/fcntl.h>
@@ -127,11 +128,14 @@ static int rtc_ioctl(struct inode *inode
 
 static int rtc_open(struct inode *inode, struct file *file)
 {
+	lock_kernel();
 	if( !atomic_dec_and_test(&rtc_ready) )
 	{
 		atomic_inc( &rtc_ready );
+		unlock_kernel();
 		return -EBUSY;
 	}
+	unlock_kernel();
 
 	return 0;
 }
Index: linux-2.6/arch/mips/basler/excite/excite_iodev.c
===================================================================
--- linux-2.6.orig/arch/mips/basler/excite/excite_iodev.c
+++ linux-2.6/arch/mips/basler/excite/excite_iodev.c
@@ -26,6 +26,7 @@
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
 #include <linux/miscdevice.h>
+#include <linux/smp_lock.h>
 
 #include "excite_iodev.h"
 
@@ -110,8 +111,14 @@ static int __exit iodev_remove(struct de
 
 static int iodev_open(struct inode *i, struct file *f)
 {
-	return request_irq(iodev_irq, iodev_irqhdl, IRQF_DISABLED,
+	int ret;
+
+	lock_kernel();
+	ret = request_irq(iodev_irq, iodev_irqhdl, IRQF_DISABLED,
 			   iodev_name, &miscdev);
+	unlock_kernel();
+
+	return ret;
 }
 
 static int iodev_release(struct inode *i, struct file *f)
Index: linux-2.6/arch/parisc/kernel/perf.c
===================================================================
--- linux-2.6.orig/arch/parisc/kernel/perf.c
+++ linux-2.6/arch/parisc/kernel/perf.c
@@ -46,6 +46,7 @@
 #include <linux/init.h>
 #include <linux/proc_fs.h>
 #include <linux/miscdevice.h>
+#include <linux/smp_lock.h>
 #include <linux/spinlock.h>
 
 #include <asm/uaccess.h>
@@ -260,13 +261,16 @@ printk("Preparing to start counters\n");
  */
 static int perf_open(struct inode *inode, struct file *file)
 {
+	lock_kernel();
 	spin_lock(&perf_lock);
 	if (perf_enabled) {
 		spin_unlock(&perf_lock);
+		unlock_kernel();
 		return -EBUSY;
 	}
 	perf_enabled = 1;
  	spin_unlock(&perf_lock);
+	unlock_kernel();
 
 	return 0;
 }
Index: linux-2.6/arch/s390/crypto/prng.c
===================================================================
--- linux-2.6.orig/arch/s390/crypto/prng.c
+++ linux-2.6/arch/s390/crypto/prng.c
@@ -6,6 +6,7 @@
 #include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
+#include <linux/smp_lock.h>
 #include <linux/miscdevice.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
@@ -48,6 +49,7 @@ static unsigned char parm_block[32] = {
 
 static int prng_open(struct inode *inode, struct file *file)
 {
+	cycle_kernel_lock();
 	return nonseekable_open(inode, file);
 }
 
Index: linux-2.6/arch/sparc/kernel/apc.c
===================================================================
--- linux-2.6.orig/arch/sparc/kernel/apc.c
+++ linux-2.6/arch/sparc/kernel/apc.c
@@ -10,6 +10,7 @@
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/miscdevice.h>
+#include <linux/smp_lock.h>
 #include <linux/pm.h>
 
 #include <asm/io.h>
@@ -75,6 +76,7 @@ static inline void apc_free(void)
 
 static int apc_open(struct inode *inode, struct file *f)
 {
+	cycle_kernel_lock();
 	return 0;
 }
 
Index: linux-2.6/arch/sparc64/kernel/time.c
===================================================================
--- linux-2.6.orig/arch/sparc64/kernel/time.c
+++ linux-2.6/arch/sparc64/kernel/time.c
@@ -11,6 +11,7 @@
 #include <linux/errno.h>
 #include <linux/module.h>
 #include <linux/sched.h>
+#include <linux/smp_lock.h>
 #include <linux/kernel.h>
 #include <linux/param.h>
 #include <linux/string.h>
@@ -1659,10 +1660,14 @@ static int mini_rtc_ioctl(struct inode *
 
 static int mini_rtc_open(struct inode *inode, struct file *file)
 {
-	if (mini_rtc_status & RTC_IS_OPEN)
+	lock_kernel();
+	if (mini_rtc_status & RTC_IS_OPEN) {
+		unlock_kernel();
 		return -EBUSY;
+	}
 
 	mini_rtc_status |= RTC_IS_OPEN;
+	unlock_kernel();
 
 	return 0;
 }
Index: linux-2.6/arch/um/drivers/harddog_kern.c
===================================================================
--- linux-2.6.orig/arch/um/drivers/harddog_kern.c
+++ linux-2.6/arch/um/drivers/harddog_kern.c
@@ -66,6 +66,7 @@ static int harddog_open(struct inode *in
 	int err = -EBUSY;
 	char *sock = NULL;
 
+	lock_kernel();
 	spin_lock(&lock);
 	if(timer_alive)
 		goto err;
@@ -82,9 +83,11 @@ static int harddog_open(struct inode *in
 
 	timer_alive = 1;
 	spin_unlock(&lock);
+	unlock_kernel();
 	return nonseekable_open(inode, file);
 err:
 	spin_unlock(&lock);
+	unlock_kernel();
 	return err;
 }
 
Index: linux-2.6/arch/um/drivers/mmapper_kern.c
===================================================================
--- linux-2.6.orig/arch/um/drivers/mmapper_kern.c
+++ linux-2.6/arch/um/drivers/mmapper_kern.c
@@ -16,6 +16,7 @@
 #include <linux/miscdevice.h>
 #include <linux/module.h>
 #include <linux/mm.h>
+#include <linux/smp_lock.h>
 #include <asm/uaccess.h>
 #include "mem_user.h"
 
@@ -77,6 +78,7 @@ out:
 
 static int mmapper_open(struct inode *inode, struct file *file)
 {
+	cycle_kernel_lock();
 	return 0;
 }
 
Index: linux-2.6/arch/um/drivers/random.c
===================================================================
--- linux-2.6.orig/arch/um/drivers/random.c
+++ linux-2.6/arch/um/drivers/random.c
@@ -7,6 +7,7 @@
  * of the GNU General Public License, incorporated herein by reference.
  */
 #include <linux/sched.h>
+#include <linux/smp_lock.h>
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/interrupt.h>
@@ -33,6 +34,8 @@ static DECLARE_WAIT_QUEUE_HEAD(host_read
 
 static int rng_dev_open (struct inode *inode, struct file *filp)
 {
+	cycle_kernel_lock();
+
 	/* enforce read-only access to this chrdev */
 	if ((filp->f_mode & FMODE_READ) == 0)
 		return -EINVAL;
Index: linux-2.6/arch/x86/kernel/apm_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apm_32.c
+++ linux-2.6/arch/x86/kernel/apm_32.c
@@ -204,6 +204,7 @@
 #include <linux/module.h>
 
 #include <linux/poll.h>
+#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/stddef.h>
 #include <linux/timer.h>
@@ -1544,10 +1545,12 @@ static int do_open(struct inode *inode, 
 {
 	struct apm_user *as;
 
+	lock_kernel();
 	as = kmalloc(sizeof(*as), GFP_KERNEL);
 	if (as == NULL) {
 		printk(KERN_ERR "apm: cannot allocate struct of size %d bytes\n",
 		       sizeof(*as));
+		       unlock_kernel();
 		return -ENOMEM;
 	}
 	as->magic = APM_BIOS_MAGIC;
@@ -1569,6 +1572,7 @@ static int do_open(struct inode *inode, 
 	user_list = as;
 	spin_unlock(&user_list_lock);
 	filp->private_data = as;
+	unlock_kernel();
 	return 0;
 }
 
Index: linux-2.6/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ linux-2.6/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -9,6 +9,7 @@
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
+#include <linux/smp_lock.h>
 #include <linux/string.h>
 #include <linux/rcupdate.h>
 #include <linux/kallsyms.h>
@@ -527,10 +528,12 @@ static int open_exclu;	/* already open e
 
 static int mce_open(struct inode *inode, struct file *file)
 {
+	lock_kernel();
 	spin_lock(&mce_state_lock);
 
 	if (open_exclu || (open_count && (file->f_flags & O_EXCL))) {
 		spin_unlock(&mce_state_lock);
+		unlock_kernel();
 		return -EBUSY;
 	}
 
@@ -539,6 +542,7 @@ static int mce_open(struct inode *inode,
 	open_count++;
 
 	spin_unlock(&mce_state_lock);
+	unlock_kernel();
 
 	return nonseekable_open(inode, file);
 }
Index: linux-2.6/arch/x86/kernel/microcode.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/microcode.c
+++ linux-2.6/arch/x86/kernel/microcode.c
@@ -75,6 +75,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/sched.h>
+#include <linux/smp_lock.h>
 #include <linux/cpumask.h>
 #include <linux/module.h>
 #include <linux/slab.h>
@@ -422,6 +423,7 @@ out:
 
 static int microcode_open (struct inode *unused1, struct file *unused2)
 {
+	cycle_kernel_lock();
 	return capable(CAP_SYS_RAWIO) ? 0 : -EPERM;
 }
 
Index: linux-2.6/drivers/bluetooth/hci_vhci.c
===================================================================
--- linux-2.6.orig/drivers/bluetooth/hci_vhci.c
+++ linux-2.6/drivers/bluetooth/hci_vhci.c
@@ -28,6 +28,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/slab.h>
+#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/sched.h>
@@ -263,9 +264,11 @@ static int vhci_open(struct inode *inode
 	skb_queue_head_init(&data->readq);
 	init_waitqueue_head(&data->read_wait);
 
+	lock_kernel();
 	hdev = hci_alloc_dev();
 	if (!hdev) {
 		kfree(data);
+		unlock_kernel();
 		return -ENOMEM;
 	}
 
@@ -286,10 +289,12 @@ static int vhci_open(struct inode *inode
 		BT_ERR("Can't register HCI device");
 		kfree(data);
 		hci_free_dev(hdev);
+		unlock_kernel();
 		return -EBUSY;
 	}
 
 	file->private_data = data;
+	unlock_kernel();
 
 	return nonseekable_open(inode, file);
 }
Index: linux-2.6/drivers/char/agp/frontend.c
===================================================================
--- linux-2.6.orig/drivers/char/agp/frontend.c
+++ linux-2.6/drivers/char/agp/frontend.c
@@ -39,6 +39,7 @@
 #include <linux/mm.h>
 #include <linux/fs.h>
 #include <linux/sched.h>
+#include <linux/smp_lock.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 #include "agp.h"
@@ -677,6 +678,7 @@ static int agp_open(struct inode *inode,
 	struct agp_client *client;
 	int rc = -ENXIO;
 
+	lock_kernel();
 	mutex_lock(&(agp_fe.agp_mutex));
 
 	if (minor != AGPGART_MINOR)
@@ -703,12 +705,14 @@ static int agp_open(struct inode *inode,
 	agp_insert_file_private(priv);
 	DBG("private=%p, client=%p", priv, client);
 	mutex_unlock(&(agp_fe.agp_mutex));
+	unlock_kernel();
 	return 0;
 
 err_out_nomem:
 	rc = -ENOMEM;
 err_out:
 	mutex_unlock(&(agp_fe.agp_mutex));
+	unlock_kernel();
 	return rc;
 }
 
Index: linux-2.6/drivers/char/apm-emulation.c
===================================================================
--- linux-2.6.orig/drivers/char/apm-emulation.c
+++ linux-2.6/drivers/char/apm-emulation.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/poll.h>
 #include <linux/slab.h>
+#include <linux/smp_lock.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/miscdevice.h>
@@ -416,6 +417,7 @@ static int apm_open(struct inode * inode
 {
 	struct apm_user *as;
 
+	lock_kernel();
 	as = kzalloc(sizeof(*as), GFP_KERNEL);
 	if (as) {
 		/*
@@ -435,6 +437,7 @@ static int apm_open(struct inode * inode
 
 		filp->private_data = as;
 	}
+	unlock_kernel();
 
 	return as ? 0 : -ENOMEM;
 }
Index: linux-2.6/drivers/char/briq_panel.c
===================================================================
--- linux-2.6.orig/drivers/char/briq_panel.c
+++ linux-2.6/drivers/char/briq_panel.c
@@ -6,6 +6,7 @@
 
 #include <linux/module.h>
 
+#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/tty.h>
@@ -67,11 +68,15 @@ static void set_led(char state)
 
 static int briq_panel_open(struct inode *ino, struct file *filep)
 {
-	/* enforce single access */
-	if (vfd_is_open)
+	lock_kernel();
+	/* enforce single access, vfd_is_open is protected by BKL */
+	if (vfd_is_open) {
+		unlock_kernel();
 		return -EBUSY;
+	}
 	vfd_is_open = 1;
 
+	unlock_kernel();
 	return 0;
 }
 
Index: linux-2.6/drivers/char/ds1286.c
===================================================================
--- linux-2.6.orig/drivers/char/ds1286.c
+++ linux-2.6/drivers/char/ds1286.c
@@ -27,6 +27,7 @@
  * option) any later version.
  */
 #include <linux/ds1286.h>
+#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/miscdevice.h>
@@ -252,6 +253,7 @@ static int ds1286_ioctl(struct inode *in
 
 static int ds1286_open(struct inode *inode, struct file *file)
 {
+	lock_kernel();
 	spin_lock_irq(&ds1286_lock);
 
 	if (ds1286_status & RTC_IS_OPEN)
@@ -260,10 +262,12 @@ static int ds1286_open(struct inode *ino
 	ds1286_status |= RTC_IS_OPEN;
 
 	spin_unlock_irq(&ds1286_lock);
+	unlock_kernel();
 	return 0;
 
 out_busy:
 	spin_lock_irq(&ds1286_lock);
+	unlock_kernel();
 	return -EBUSY;
 }
 
Index: linux-2.6/drivers/char/ds1620.c
===================================================================
--- linux-2.6.orig/drivers/char/ds1620.c
+++ linux-2.6/drivers/char/ds1620.c
@@ -8,6 +8,7 @@
 #include <linux/proc_fs.h>
 #include <linux/capability.h>
 #include <linux/init.h>
+#include <linux/smp_lock.h>
 
 #include <asm/hardware.h>
 #include <asm/mach-types.h>
@@ -208,6 +209,12 @@ static void ds1620_read_state(struct the
 	therm->hi = cvt_9_to_int(ds1620_in(THERM_READ_TH, 9));
 }
 
+static int ds1620_open(struct inode *inode, struct file *file)
+{
+	cycle_kernel_lock();
+	return nonseekable_open(inode, file);
+}
+
 static ssize_t
 ds1620_read(struct file *file, char __user *buf, size_t count, loff_t *ptr)
 {
@@ -336,7 +343,7 @@ static struct proc_dir_entry *proc_therm
 
 static const struct file_operations ds1620_fops = {
 	.owner		= THIS_MODULE,
-	.open		= nonseekable_open,
+	.open		= ds1620_open,
 	.read		= ds1620_read,
 	.ioctl		= ds1620_ioctl,
 };
Index: linux-2.6/drivers/char/efirtc.c
===================================================================
--- linux-2.6.orig/drivers/char/efirtc.c
+++ linux-2.6/drivers/char/efirtc.c
@@ -28,6 +28,7 @@
  */
 
 
+#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/miscdevice.h>
@@ -272,6 +273,7 @@ efi_rtc_open(struct inode *inode, struct
 	 * We do accept multiple open files at the same time as we
 	 * synchronize on the per call operation.
 	 */
+	cycle_kernel_lock();
 	return 0;
 }
 
Index: linux-2.6/drivers/char/genrtc.c
===================================================================
--- linux-2.6.orig/drivers/char/genrtc.c
+++ linux-2.6/drivers/char/genrtc.c
@@ -51,6 +51,7 @@
 #include <linux/init.h>
 #include <linux/poll.h>
 #include <linux/proc_fs.h>
+#include <linux/smp_lock.h>
 #include <linux/workqueue.h>
 
 #include <asm/uaccess.h>
@@ -338,12 +339,16 @@ static int gen_rtc_ioctl(struct inode *i
 
 static int gen_rtc_open(struct inode *inode, struct file *file)
 {
-	if (gen_rtc_status & RTC_IS_OPEN)
+	lock_kernel();
+	if (gen_rtc_status & RTC_IS_OPEN) {
+		unlock_kernel();
 		return -EBUSY;
+	}
 
 	gen_rtc_status |= RTC_IS_OPEN;
 	gen_rtc_irq_data = 0;
 	irq_active = 0;
+	unlock_kernel();
 
 	return 0;
 }
Index: linux-2.6/drivers/char/hpet.c
===================================================================
--- linux-2.6.orig/drivers/char/hpet.c
+++ linux-2.6/drivers/char/hpet.c
@@ -14,6 +14,7 @@
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/miscdevice.h>
 #include <linux/major.h>
@@ -193,6 +194,7 @@ static int hpet_open(struct inode *inode
 	if (file->f_mode & FMODE_WRITE)
 		return -EINVAL;
 
+	lock_kernel();
 	spin_lock_irq(&hpet_lock);
 
 	for (devp = NULL, hpetp = hpets; hpetp && !devp; hpetp = hpetp->hp_next)
@@ -207,6 +209,7 @@ static int hpet_open(struct inode *inode
 
 	if (!devp) {
 		spin_unlock_irq(&hpet_lock);
+		unlock_kernel();
 		return -EBUSY;
 	}
 
@@ -214,6 +217,7 @@ static int hpet_open(struct inode *inode
 	devp->hd_irqdata = 0;
 	devp->hd_flags |= HPET_OPEN;
 	spin_unlock_irq(&hpet_lock);
+	unlock_kernel();
 
 	return 0;
 }
Index: linux-2.6/drivers/char/hw_random/core.c
===================================================================
--- linux-2.6.orig/drivers/char/hw_random/core.c
+++ linux-2.6/drivers/char/hw_random/core.c
@@ -37,6 +37,7 @@
 #include <linux/kernel.h>
 #include <linux/fs.h>
 #include <linux/sched.h>
+#include <linux/smp_lock.h>
 #include <linux/init.h>
 #include <linux/miscdevice.h>
 #include <linux/delay.h>
@@ -86,6 +87,7 @@ static int rng_dev_open(struct inode *in
 		return -EINVAL;
 	if (filp->f_mode & FMODE_WRITE)
 		return -EINVAL;
+	cycle_kernel_lock();
 	return 0;
 }
 
Index: linux-2.6/drivers/char/ip27-rtc.c
===================================================================
--- linux-2.6.orig/drivers/char/ip27-rtc.c
+++ linux-2.6/drivers/char/ip27-rtc.c
@@ -27,6 +27,7 @@
 #include <linux/bcd.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/miscdevice.h>
 #include <linux/ioport.h>
@@ -163,15 +164,18 @@ static long rtc_ioctl(struct file *filp,
 
 static int rtc_open(struct inode *inode, struct file *file)
 {
+	lock_kernel();
 	spin_lock_irq(&rtc_lock);
 
 	if (rtc_status & RTC_IS_OPEN) {
 		spin_unlock_irq(&rtc_lock);
+		unlock_kernel();
 		return -EBUSY;
 	}
 
 	rtc_status |= RTC_IS_OPEN;
 	spin_unlock_irq(&rtc_lock);
+	unlock_kernel();
 
 	return 0;
 }
Index: linux-2.6/drivers/char/ipmi/ipmi_watchdog.c
===================================================================
--- linux-2.6.orig/drivers/char/ipmi/ipmi_watchdog.c
+++ linux-2.6/drivers/char/ipmi/ipmi_watchdog.c
@@ -35,6 +35,7 @@
 #include <linux/moduleparam.h>
 #include <linux/ipmi.h>
 #include <linux/ipmi_smi.h>
+#include <linux/smp_lock.h>
 #include <linux/watchdog.h>
 #include <linux/miscdevice.h>
 #include <linux/init.h>
@@ -819,6 +820,8 @@ static int ipmi_open(struct inode *ino, 
 		if (test_and_set_bit(0, &ipmi_wdog_open))
 			return -EBUSY;
 
+		cycle_kernel_lock();
+
 		/*
 		 * Don't start the timer now, let it start on the
 		 * first heartbeat.
Index: linux-2.6/drivers/char/lcd.c
===================================================================
--- linux-2.6.orig/drivers/char/lcd.c
+++ linux-2.6/drivers/char/lcd.c
@@ -20,6 +20,7 @@
 #include <linux/mc146818rtc.h>
 #include <linux/netdevice.h>
 #include <linux/sched.h>
+#include <linux/smp_lock.h>
 #include <linux/delay.h>
 
 #include <asm/io.h>
@@ -414,6 +415,8 @@ static int lcd_ioctl(struct inode *inode
 
 static int lcd_open(struct inode *inode, struct file *file)
 {
+	cycle_kernel_lock();
+
 	if (!lcd_present)
 		return -ENXIO;
 	else
Index: linux-2.6/drivers/char/mwave/mwavedd.c
===================================================================
--- linux-2.6.orig/drivers/char/mwave/mwavedd.c
+++ linux-2.6/drivers/char/mwave/mwavedd.c
@@ -56,6 +56,7 @@
 #include <linux/serial.h>
 #include <linux/sched.h>
 #include <linux/spinlock.h>
+#include <linux/smp_lock.h>
 #include <linux/delay.h>
 #include <linux/serial_8250.h>
 #include "smapi.h"
@@ -100,6 +101,7 @@ static int mwave_open(struct inode *inod
 	PRINTK_2(TRACE_MWAVE,
 		"mwavedd::mwave_open, exit return retval %x\n", retval);
 
+	cycle_kernel_lock();
 	return retval;
 }
 
Index: linux-2.6/drivers/char/nvram.c
===================================================================
--- linux-2.6.orig/drivers/char/nvram.c
+++ linux-2.6/drivers/char/nvram.c
@@ -107,6 +107,7 @@
 #include <linux/init.h>
 #include <linux/proc_fs.h>
 #include <linux/spinlock.h>
+#include <linux/smp_lock.h>
 
 #include <asm/io.h>
 #include <asm/uaccess.h>
@@ -333,12 +334,14 @@ nvram_ioctl(struct inode *inode, struct 
 static int
 nvram_open(struct inode *inode, struct file *file)
 {
+	lock_kernel();
 	spin_lock(&nvram_state_lock);
 
 	if ((nvram_open_cnt && (file->f_flags & O_EXCL)) ||
 	    (nvram_open_mode & NVRAM_EXCL) ||
 	    ((file->f_mode & 2) && (nvram_open_mode & NVRAM_WRITE))) {
 		spin_unlock(&nvram_state_lock);
+		unlock_kernel();
 		return -EBUSY;
 	}
 
@@ -349,6 +352,7 @@ nvram_open(struct inode *inode, struct f
 	nvram_open_cnt++;
 
 	spin_unlock(&nvram_state_lock);
+	unlock_kernel();
 
 	return 0;
 }
Index: linux-2.6/drivers/char/rtc.c
===================================================================
--- linux-2.6.orig/drivers/char/rtc.c
+++ linux-2.6/drivers/char/rtc.c
@@ -73,6 +73,7 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/spinlock.h>
+#include <linux/smp_lock.h>
 #include <linux/sysctl.h>
 #include <linux/wait.h>
 #include <linux/bcd.h>
@@ -733,6 +734,7 @@ static int rtc_ioctl(struct inode *inode
  * needed here. Or anywhere else in this driver. */
 static int rtc_open(struct inode *inode, struct file *file)
 {
+	lock_kernel();
 	spin_lock_irq(&rtc_lock);
 
 	if (rtc_status & RTC_IS_OPEN)
@@ -742,10 +744,12 @@ static int rtc_open(struct inode *inode,
 
 	rtc_irq_data = 0;
 	spin_unlock_irq(&rtc_lock);
+	unlock_kernel();
 	return 0;
 
 out_busy:
 	spin_unlock_irq(&rtc_lock);
+	unlock_kernel();
 	return -EBUSY;
 }
 
Index: linux-2.6/drivers/char/sonypi.c
===================================================================
--- linux-2.6.orig/drivers/char/sonypi.c
+++ linux-2.6/drivers/char/sonypi.c
@@ -49,6 +49,7 @@
 #include <linux/err.h>
 #include <linux/kfifo.h>
 #include <linux/platform_device.h>
+#include <linux/smp_lock.h>
 
 #include <asm/uaccess.h>
 #include <asm/io.h>
@@ -906,12 +907,14 @@ static int sonypi_misc_release(struct in
 
 static int sonypi_misc_open(struct inode *inode, struct file *file)
 {
+	lock_kernel();
 	mutex_lock(&sonypi_device.lock);
 	/* Flush input queue on first open */
 	if (!sonypi_device.open_count)
 		kfifo_reset(sonypi_device.fifo);
 	sonypi_device.open_count++;
 	mutex_unlock(&sonypi_device.lock);
+	unlock_kernel();
 	return 0;
 }
 
Index: linux-2.6/drivers/char/tpm/tpm.c
===================================================================
--- linux-2.6.orig/drivers/char/tpm/tpm.c
+++ linux-2.6/drivers/char/tpm/tpm.c
@@ -26,6 +26,7 @@
 #include <linux/poll.h>
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
+#include <linux/smp_lock.h>
 
 #include "tpm.h"
 
@@ -897,6 +898,7 @@ int tpm_open(struct inode *inode, struct
 	int rc = 0, minor = iminor(inode);
 	struct tpm_chip *chip = NULL, *pos;
 
+	lock_kernel();
 	spin_lock(&driver_lock);
 
 	list_for_each_entry(pos, &tpm_chip_list, list) {
@@ -926,16 +928,19 @@ int tpm_open(struct inode *inode, struct
 	if (chip->data_buffer == NULL) {
 		chip->num_opens--;
 		put_device(chip->dev);
+		unlock_kernel();
 		return -ENOMEM;
 	}
 
 	atomic_set(&chip->data_pending, 0);
 
 	file->private_data = chip;
+	unlock_kernel();
 	return 0;
 
 err_out:
 	spin_unlock(&driver_lock);
+	unlock_kernel();
 	return rc;
 }
 EXPORT_SYMBOL_GPL(tpm_open);
Index: linux-2.6/drivers/infiniband/core/ucma.c
===================================================================
--- linux-2.6.orig/drivers/infiniband/core/ucma.c
+++ linux-2.6/drivers/infiniband/core/ucma.c
@@ -38,6 +38,7 @@
 #include <linux/in.h>
 #include <linux/in6.h>
 #include <linux/miscdevice.h>
+#include <linux/smp_lock.h>
 
 #include <rdma/rdma_user_cm.h>
 #include <rdma/ib_marshall.h>
@@ -1156,6 +1157,7 @@ static int ucma_open(struct inode *inode
 	if (!file)
 		return -ENOMEM;
 
+	lock_kernel();
 	INIT_LIST_HEAD(&file->event_list);
 	INIT_LIST_HEAD(&file->ctx_list);
 	init_waitqueue_head(&file->poll_wait);
@@ -1163,6 +1165,7 @@ static int ucma_open(struct inode *inode
 
 	filp->private_data = file;
 	file->filp = filp;
+	unlock_kernel();
 	return 0;
 }
 
Index: linux-2.6/drivers/input/misc/hp_sdc_rtc.c
===================================================================
--- linux-2.6.orig/drivers/input/misc/hp_sdc_rtc.c
+++ linux-2.6/drivers/input/misc/hp_sdc_rtc.c
@@ -35,6 +35,7 @@
 
 #include <linux/hp_sdc.h>
 #include <linux/errno.h>
+#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/init.h>
 #include <linux/module.h>
@@ -408,6 +409,7 @@ static unsigned int hp_sdc_rtc_poll(stru
 
 static int hp_sdc_rtc_open(struct inode *inode, struct file *file)
 {
+	cycle_kernel_lock();
         return 0;
 }
 
Index: linux-2.6/drivers/input/misc/uinput.c
===================================================================
--- linux-2.6.orig/drivers/input/misc/uinput.c
+++ linux-2.6/drivers/input/misc/uinput.c
@@ -37,6 +37,7 @@
 #include <linux/fs.h>
 #include <linux/miscdevice.h>
 #include <linux/uinput.h>
+#include <linux/smp_lock.h>
 
 static int uinput_dev_event(struct input_dev *dev, unsigned int type, unsigned int code, int value)
 {
@@ -222,6 +223,7 @@ static int uinput_open(struct inode *ino
 	if (!newdev)
 		return -ENOMEM;
 
+	lock_kernel();
 	mutex_init(&newdev->mutex);
 	spin_lock_init(&newdev->requests_lock);
 	init_waitqueue_head(&newdev->requests_waitq);
@@ -229,6 +231,7 @@ static int uinput_open(struct inode *ino
 	newdev->state = UIST_NEW_DEVICE;
 
 	file->private_data = newdev;
+	unlock_kernel();
 
 	return 0;
 }
Index: linux-2.6/drivers/input/mousedev.c
===================================================================
--- linux-2.6.orig/drivers/input/mousedev.c
+++ linux-2.6/drivers/input/mousedev.c
@@ -14,6 +14,7 @@
 #define MOUSEDEV_MIX		31
 
 #include <linux/slab.h>
+#include <linux/smp_lock.h>
 #include <linux/poll.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -545,16 +546,21 @@ static int mousedev_open(struct inode *i
 	if (i >= MOUSEDEV_MINORS)
 		return -ENODEV;
 
+	lock_kernel();
 	error = mutex_lock_interruptible(&mousedev_table_mutex);
-	if (error)
+	if (error) {
+		unlock_kernel();
 		return error;
+	}
 	mousedev = mousedev_table[i];
 	if (mousedev)
 		get_device(&mousedev->dev);
 	mutex_unlock(&mousedev_table_mutex);
 
-	if (!mousedev)
+	if (!mousedev) {
+		unlock_kernel();
 		return -ENODEV;
+	}
 
 	client = kzalloc(sizeof(struct mousedev_client), GFP_KERNEL);
 	if (!client) {
@@ -573,6 +579,7 @@ static int mousedev_open(struct inode *i
 		goto err_free_client;
 
 	file->private_data = client;
+	unlock_kernel();
 	return 0;
 
  err_free_client:
@@ -580,6 +587,7 @@ static int mousedev_open(struct inode *i
 	kfree(client);
  err_put_mousedev:
 	put_device(&mousedev->dev);
+	unlock_kernel();
 	return error;
 }
 
Index: linux-2.6/drivers/input/serio/serio_raw.c
===================================================================
--- linux-2.6.orig/drivers/input/serio/serio_raw.c
+++ linux-2.6/drivers/input/serio/serio_raw.c
@@ -10,6 +10,7 @@
  */
 
 #include <linux/slab.h>
+#include <linux/smp_lock.h>
 #include <linux/poll.h>
 #include <linux/module.h>
 #include <linux/serio.h>
@@ -81,9 +82,10 @@ static int serio_raw_open(struct inode *
 	struct serio_raw_list *list;
 	int retval = 0;
 
+	lock_kernel();
 	retval = mutex_lock_interruptible(&serio_raw_mutex);
 	if (retval)
-		return retval;
+		goto out_bkl;
 
 	if (!(serio_raw = serio_raw_locate(iminor(inode)))) {
 		retval = -ENODEV;
@@ -108,6 +110,8 @@ static int serio_raw_open(struct inode *
 
 out:
 	mutex_unlock(&serio_raw_mutex);
+out_bkl:
+	unlock_kernel();
 	return retval;
 }
 
Index: linux-2.6/drivers/macintosh/ans-lcd.c
===================================================================
--- linux-2.6.orig/drivers/macintosh/ans-lcd.c
+++ linux-2.6/drivers/macintosh/ans-lcd.c
@@ -3,6 +3,7 @@
  */
 
 #include <linux/types.h>
+#include <linux/smp_lock.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/miscdevice.h>
@@ -119,6 +120,7 @@ anslcd_ioctl( struct inode * inode, stru
 static int
 anslcd_open( struct inode * inode, struct file * file )
 {
+	cycle_kernel_lock();
 	return 0;
 }
 
Index: linux-2.6/drivers/macintosh/smu.c
===================================================================
--- linux-2.6.orig/drivers/macintosh/smu.c
+++ linux-2.6/drivers/macintosh/smu.c
@@ -19,6 +19,7 @@
  *    the userland interface
  */
 
+#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/device.h>
@@ -1083,10 +1084,12 @@ static int smu_open(struct inode *inode,
 	pp->mode = smu_file_commands;
 	init_waitqueue_head(&pp->wait);
 
+	lock_kernel();
 	spin_lock_irqsave(&smu_clist_lock, flags);
 	list_add(&pp->list, &smu_clist);
 	spin_unlock_irqrestore(&smu_clist_lock, flags);
 	file->private_data = pp;
+	unlock_kernel();
 
 	return 0;
 }
Index: linux-2.6/drivers/macintosh/via-pmu.c
===================================================================
--- linux-2.6.orig/drivers/macintosh/via-pmu.c
+++ linux-2.6/drivers/macintosh/via-pmu.c
@@ -18,6 +18,7 @@
  *
  */
 #include <stdarg.h>
+#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
@@ -2047,6 +2048,7 @@ pmu_open(struct inode *inode, struct fil
 	pp->rb_get = pp->rb_put = 0;
 	spin_lock_init(&pp->lock);
 	init_waitqueue_head(&pp->wait);
+	lock_kernel();
 	spin_lock_irqsave(&all_pvt_lock, flags);
 #if defined(CONFIG_INPUT_ADBHID) && defined(CONFIG_PMAC_BACKLIGHT)
 	pp->backlight_locker = 0;
@@ -2054,6 +2056,7 @@ pmu_open(struct inode *inode, struct fil
 	list_add(&pp->list, &all_pmu_pvt);
 	spin_unlock_irqrestore(&all_pvt_lock, flags);
 	file->private_data = pp;
+	unlock_kernel();
 	return 0;
 }
 
Index: linux-2.6/drivers/media/radio/miropcm20-rds.c
===================================================================
--- linux-2.6.orig/drivers/media/radio/miropcm20-rds.c
+++ linux-2.6/drivers/media/radio/miropcm20-rds.c
@@ -12,6 +12,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
+#include <linux/smp_lock.h>
 #include <linux/fs.h>
 #include <linux/miscdevice.h>
 #include <linux/delay.h>
@@ -27,13 +28,16 @@ static int rds_f_open(struct inode *in, 
 	if (rds_users)
 		return -EBUSY;
 
+	lock_kernel();
 	rds_users++;
 	if ((text_buffer=kmalloc(66, GFP_KERNEL)) == 0) {
 		rds_users--;
 		printk(KERN_NOTICE "aci-rds: Out of memory by open()...\n");
+		unlock_kernel();
 		return -ENOMEM;
 	}
 
+	unlock_kernel();
 	return 0;
 }
 
Index: linux-2.6/drivers/message/i2o/i2o_config.c
===================================================================
--- linux-2.6.orig/drivers/message/i2o/i2o_config.c
+++ linux-2.6/drivers/message/i2o/i2o_config.c
@@ -1061,6 +1061,7 @@ static int cfg_open(struct inode *inode,
 	if (!tmp)
 		return -ENOMEM;
 
+	lock_kernel();
 	file->private_data = (void *)(i2o_cfg_info_id++);
 	tmp->fp = file;
 	tmp->fasync = NULL;
@@ -1074,6 +1075,7 @@ static int cfg_open(struct inode *inode,
 	spin_lock_irqsave(&i2o_config_lock, flags);
 	open_files = tmp;
 	spin_unlock_irqrestore(&i2o_config_lock, flags);
+	unlock_kernel();
 
 	return 0;
 }
Index: linux-2.6/drivers/misc/hdpuftrs/hdpu_cpustate.c
===================================================================
--- linux-2.6.orig/drivers/misc/hdpuftrs/hdpu_cpustate.c
+++ linux-2.6/drivers/misc/hdpuftrs/hdpu_cpustate.c
@@ -17,6 +17,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/spinlock.h>
+#include <linux/smp_lock.h>
 #include <linux/miscdevice.h>
 #include <linux/proc_fs.h>
 #include <linux/hdpu_features.h>
@@ -151,7 +152,13 @@ static ssize_t cpustate_write(struct fil
 
 static int cpustate_open(struct inode *inode, struct file *file)
 {
-	return cpustate_get_ref((file->f_flags & O_EXCL));
+	int ret;
+
+	lock_kernel();
+	ret = cpustate_get_ref((file->f_flags & O_EXCL));
+	unlock_kernel();
+
+	return ret;
 }
 
 static int cpustate_release(struct inode *inode, struct file *file)
Index: linux-2.6/drivers/misc/sony-laptop.c
===================================================================
--- linux-2.6.orig/drivers/misc/sony-laptop.c
+++ linux-2.6/drivers/misc/sony-laptop.c
@@ -46,6 +46,7 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/init.h>
+#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/backlight.h>
 #include <linux/platform_device.h>
@@ -1927,8 +1928,10 @@ static int sonypi_misc_release(struct in
 static int sonypi_misc_open(struct inode *inode, struct file *file)
 {
 	/* Flush input queue on first open */
+	lock_kernel();
 	if (atomic_inc_return(&sonypi_compat.open_count) == 1)
 		kfifo_reset(sonypi_compat.fifo);
+	unlock_kernel();
 	return 0;
 }
 
Index: linux-2.6/drivers/net/tun.c
===================================================================
--- linux-2.6.orig/drivers/net/tun.c
+++ linux-2.6/drivers/net/tun.c
@@ -48,6 +48,7 @@
 #include <linux/kernel.h>
 #include <linux/major.h>
 #include <linux/slab.h>
+#include <linux/smp_lock.h>
 #include <linux/poll.h>
 #include <linux/fcntl.h>
 #include <linux/init.h>
@@ -797,6 +798,7 @@ static int tun_chr_fasync(int fd, struct
 
 static int tun_chr_open(struct inode *inode, struct file * file)
 {
+	cycle_kernel_lock();
 	DBG1(KERN_INFO "tunX: tun_chr_open\n");
 	file->private_data = NULL;
 	return 0;
Index: linux-2.6/drivers/parisc/eisa_eeprom.c
===================================================================
--- linux-2.6.orig/drivers/parisc/eisa_eeprom.c
+++ linux-2.6/drivers/parisc/eisa_eeprom.c
@@ -24,6 +24,7 @@
 #include <linux/kernel.h>
 #include <linux/miscdevice.h>
 #include <linux/slab.h>
+#include <linux/smp_lock.h>
 #include <linux/fs.h>
 #include <asm/io.h>
 #include <asm/uaccess.h>
@@ -83,6 +84,8 @@ static int eisa_eeprom_ioctl(struct inod
 
 static int eisa_eeprom_open(struct inode *inode, struct file *file)
 {
+	cycle_kernel_lock();
+
 	if (file->f_mode & 2)
 		return -EINVAL;
    
Index: linux-2.6/drivers/rtc/rtc-m41t80.c
===================================================================
--- linux-2.6.orig/drivers/rtc/rtc-m41t80.c
+++ linux-2.6/drivers/rtc/rtc-m41t80.c
@@ -17,6 +17,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
+#include <linux/smp_lock.h>
 #include <linux/string.h>
 #include <linux/i2c.h>
 #include <linux/rtc.h>
@@ -655,12 +656,16 @@ static int wdt_ioctl(struct inode *inode
 static int wdt_open(struct inode *inode, struct file *file)
 {
 	if (MINOR(inode->i_rdev) == WATCHDOG_MINOR) {
-		if (test_and_set_bit(0, &wdt_is_open))
+		lock_kernel();
+		if (test_and_set_bit(0, &wdt_is_open)) {
+			unlock_kernel();
 			return -EBUSY;
+		}
 		/*
 		 *	Activate
 		 */
 		wdt_is_open = 1;
+		unlock_kernel();
 		return 0;
 	}
 	return -ENODEV;
Index: linux-2.6/drivers/s390/block/dasd_eer.c
===================================================================
--- linux-2.6.orig/drivers/s390/block/dasd_eer.c
+++ linux-2.6/drivers/s390/block/dasd_eer.c
@@ -15,6 +15,7 @@
 #include <linux/device.h>
 #include <linux/poll.h>
 #include <linux/mutex.h>
+#include <linux/smp_lock.h>
 
 #include <asm/uaccess.h>
 #include <asm/atomic.h>
@@ -525,6 +526,7 @@ static int dasd_eer_open(struct inode *i
 	eerb = kzalloc(sizeof(struct eerbuffer), GFP_KERNEL);
 	if (!eerb)
 		return -ENOMEM;
+	lock_kernel();
 	eerb->buffer_page_count = eer_pages;
 	if (eerb->buffer_page_count < 1 ||
 	    eerb->buffer_page_count > INT_MAX / PAGE_SIZE) {
@@ -532,6 +534,7 @@ static int dasd_eer_open(struct inode *i
 		MESSAGE(KERN_WARNING, "can't open device since module "
 			"parameter eer_pages is smaller then 1 or"
 			" bigger then %d", (int)(INT_MAX / PAGE_SIZE));
+		unlock_kernel();
 		return -EINVAL;
 	}
 	eerb->buffersize = eerb->buffer_page_count * PAGE_SIZE;
@@ -539,12 +542,14 @@ static int dasd_eer_open(struct inode *i
 			       GFP_KERNEL);
         if (!eerb->buffer) {
 		kfree(eerb);
+		unlock_kernel();
                 return -ENOMEM;
 	}
 	if (dasd_eer_allocate_buffer_pages(eerb->buffer,
 					   eerb->buffer_page_count)) {
 		kfree(eerb->buffer);
 		kfree(eerb);
+		unlock_kernel();
 		return -ENOMEM;
 	}
 	filp->private_data = eerb;
@@ -552,6 +557,7 @@ static int dasd_eer_open(struct inode *i
 	list_add(&eerb->list, &bufferlist);
 	spin_unlock_irqrestore(&bufferlock, flags);
 
+	unlock_kernel();
 	return nonseekable_open(inp,filp);
 }
 
Index: linux-2.6/drivers/s390/char/monreader.c
===================================================================
--- linux-2.6.orig/drivers/s390/char/monreader.c
+++ linux-2.6/drivers/s390/char/monreader.c
@@ -340,6 +340,7 @@ static int mon_open(struct inode *inode,
 	/*
 	 * only one user allowed
 	 */
+	lock_kernel();
 	rc = -EBUSY;
 	if (test_and_set_bit(MON_IN_USE, &mon_in_use))
 		goto out;
@@ -377,6 +378,7 @@ static int mon_open(struct inode *inode,
 	}
 	P_INFO("open, established connection to *MONITOR service\n\n");
 	filp->private_data = monpriv;
+	unlock_kernel();
 	return nonseekable_open(inode, filp);
 
 out_path:
@@ -386,6 +388,7 @@ out_priv:
 out_use:
 	clear_bit(MON_IN_USE, &mon_in_use);
 out:
+	unlock_kernel();
 	return rc;
 }
 
Index: linux-2.6/drivers/s390/char/monwriter.c
===================================================================
--- linux-2.6.orig/drivers/s390/char/monwriter.c
+++ linux-2.6/drivers/s390/char/monwriter.c
@@ -12,6 +12,7 @@
 #include <linux/moduleparam.h>
 #include <linux/init.h>
 #include <linux/errno.h>
+#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/miscdevice.h>
@@ -179,10 +180,12 @@ static int monwrite_open(struct inode *i
 	monpriv = kzalloc(sizeof(struct mon_private), GFP_KERNEL);
 	if (!monpriv)
 		return -ENOMEM;
+	lock_kernel();
 	INIT_LIST_HEAD(&monpriv->list);
 	monpriv->hdr_to_read = sizeof(monpriv->hdr);
 	mutex_init(&monpriv->thread_mutex);
 	filp->private_data = monpriv;
+	unlock_kernel();
 	return nonseekable_open(inode, filp);
 }
 
Index: linux-2.6/drivers/s390/char/vmcp.c
===================================================================
--- linux-2.6.orig/drivers/s390/char/vmcp.c
+++ linux-2.6/drivers/s390/char/vmcp.c
@@ -16,6 +16,7 @@
 #include <linux/kernel.h>
 #include <linux/miscdevice.h>
 #include <linux/module.h>
+#include <linux/smp_lock.h>
 #include <asm/cpcmd.h>
 #include <asm/debug.h>
 #include <asm/uaccess.h>
@@ -39,11 +40,14 @@ static int vmcp_open(struct inode *inode
 	session = kmalloc(sizeof(*session), GFP_KERNEL);
 	if (!session)
 		return -ENOMEM;
+
+	lock_kernel();
 	session->bufsize = PAGE_SIZE;
 	session->response = NULL;
 	session->resp_size = 0;
 	mutex_init(&session->mutex);
 	file->private_data = session;
+	unlock_kernel();
 	return nonseekable_open(inode, file);
 }
 
Index: linux-2.6/drivers/s390/char/vmwatchdog.c
===================================================================
--- linux-2.6.orig/drivers/s390/char/vmwatchdog.c
+++ linux-2.6/drivers/s390/char/vmwatchdog.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/watchdog.h>
+#include <linux/smp_lock.h>
 
 #include <asm/ebcdic.h>
 #include <asm/io.h>
@@ -131,11 +132,15 @@ static int __init vmwdt_probe(void)
 static int vmwdt_open(struct inode *i, struct file *f)
 {
 	int ret;
-	if (test_and_set_bit(0, &vmwdt_is_open))
+	lock_kernel();
+	if (test_and_set_bit(0, &vmwdt_is_open)) {
+		unlock_kernel();
 		return -EBUSY;
+	}
 	ret = vmwdt_keepalive();
 	if (ret)
 		clear_bit(0, &vmwdt_is_open);
+	unlock_kernel();
 	return ret ? ret : nonseekable_open(i, f);
 }
 
Index: linux-2.6/drivers/s390/crypto/zcrypt_api.c
===================================================================
--- linux-2.6.orig/drivers/s390/crypto/zcrypt_api.c
+++ linux-2.6/drivers/s390/crypto/zcrypt_api.c
@@ -34,6 +34,7 @@
 #include <linux/fs.h>
 #include <linux/proc_fs.h>
 #include <linux/compat.h>
+#include <linux/smp_lock.h>
 #include <asm/atomic.h>
 #include <asm/uaccess.h>
 #include <linux/hw_random.h>
@@ -300,7 +301,9 @@ static ssize_t zcrypt_write(struct file 
  */
 static int zcrypt_open(struct inode *inode, struct file *filp)
 {
+	lock_kernel();
 	atomic_inc(&zcrypt_open_count);
+	unlock_kernel();
 	return 0;
 }
 
Index: linux-2.6/drivers/sbus/char/cpwatchdog.c
===================================================================
--- linux-2.6.orig/drivers/sbus/char/cpwatchdog.c
+++ linux-2.6/drivers/sbus/char/cpwatchdog.c
@@ -279,6 +279,7 @@ static inline int wd_opt_timeout(void)
 
 static int wd_open(struct inode *inode, struct file *f)
 {
+	lock_kernel();
 	switch(iminor(inode))
 	{
 		case WD0_MINOR:
@@ -291,6 +292,7 @@ static int wd_open(struct inode *inode, 
 			f->private_data = &wd_dev.watchdog[WD2_ID];
 			break;
 		default:
+			unlock_kernel();
 			return(-ENODEV);
 	}
 
@@ -304,11 +306,13 @@ static int wd_open(struct inode *inode, 
 						(void *)wd_dev.regs)) {
 			printk("%s: Cannot register IRQ %d\n", 
 				WD_OBPNAME, wd_dev.irq);
+			unlock_kernel();
 			return(-EBUSY);
 		}
 		wd_dev.initialized = 1;
 	}
 
+	unlock_kernel();
 	return(nonseekable_open(inode, f));
 }
 
Index: linux-2.6/drivers/sbus/char/display7seg.c
===================================================================
--- linux-2.6.orig/drivers/sbus/char/display7seg.c
+++ linux-2.6/drivers/sbus/char/display7seg.c
@@ -94,6 +94,7 @@ static int d7s_open(struct inode *inode,
 {
 	if (D7S_MINOR != iminor(inode))
 		return -ENODEV;
+	cycle_kernel_lock();
 	atomic_inc(&d7s_users);
 	return 0;
 }
Index: linux-2.6/drivers/sbus/char/envctrl.c
===================================================================
--- linux-2.6.orig/drivers/sbus/char/envctrl.c
+++ linux-2.6/drivers/sbus/char/envctrl.c
@@ -27,6 +27,7 @@
 #include <linux/miscdevice.h>
 #include <linux/kmod.h>
 #include <linux/reboot.h>
+#include <linux/smp_lock.h>
 
 #include <asm/ebus.h>
 #include <asm/uaccess.h>
@@ -694,6 +695,7 @@ envctrl_ioctl(struct file *file, unsigne
 static int
 envctrl_open(struct inode *inode, struct file *file)
 {
+	cycle_kernel_lock();
 	file->private_data = NULL;
 	return 0;
 }
Index: linux-2.6/drivers/sbus/char/flash.c
===================================================================
--- linux-2.6.orig/drivers/sbus/char/flash.c
+++ linux-2.6/drivers/sbus/char/flash.c
@@ -127,9 +127,13 @@ flash_read(struct file * file, char __us
 static int
 flash_open(struct inode *inode, struct file *file)
 {
-	if (test_and_set_bit(0, (void *)&flash.busy) != 0)
+	lock_kernel();
+	if (test_and_set_bit(0, (void *)&flash.busy) != 0) {
+		unlock_kernel();
 		return -EBUSY;
+	}
 
+	unlock_kernel();
 	return 0;
 }
 
Index: linux-2.6/drivers/sbus/char/jsflash.c
===================================================================
--- linux-2.6.orig/drivers/sbus/char/jsflash.c
+++ linux-2.6/drivers/sbus/char/jsflash.c
@@ -27,6 +27,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/miscdevice.h>
@@ -417,11 +418,17 @@ static int jsf_mmap(struct file * file, 
 
 static int jsf_open(struct inode * inode, struct file * filp)
 {
-
-	if (jsf0.base == 0) return -ENXIO;
-	if (test_and_set_bit(0, (void *)&jsf0.busy) != 0)
+	lock_kernel();
+	if (jsf0.base == 0) {
+		unlock_kernel();
+		return -ENXIO;
+	}
+	if (test_and_set_bit(0, (void *)&jsf0.busy) != 0) {
+		unlock_kernel();
 		return -EBUSY;
+	}
 
+	unlock_kernel();
 	return 0;	/* XXX What security? */
 }
 
Index: linux-2.6/drivers/sbus/char/openprom.c
===================================================================
--- linux-2.6.orig/drivers/sbus/char/openprom.c
+++ linux-2.6/drivers/sbus/char/openprom.c
@@ -33,6 +33,7 @@
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
+#include <linux/smp_lock.h>
 #include <linux/string.h>
 #include <linux/miscdevice.h>
 #include <linux/init.h>
@@ -689,9 +690,11 @@ static int openprom_open(struct inode * 
 	if (!data)
 		return -ENOMEM;
 
+	lock_kernel();
 	data->current_node = of_find_node_by_path("/");
 	data->lastnode = data->current_node;
 	file->private_data = (void *) data;
+	unlock_kernel();
 
 	return 0;
 }
Index: linux-2.6/drivers/sbus/char/riowatchdog.c
===================================================================
--- linux-2.6.orig/drivers/sbus/char/riowatchdog.c
+++ linux-2.6/drivers/sbus/char/riowatchdog.c
@@ -11,6 +11,7 @@
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/miscdevice.h>
+#include <linux/smp_lock.h>
 
 #include <asm/io.h>
 #include <asm/ebus.h>
@@ -116,6 +117,7 @@ static void riowd_starttimer(void)
 
 static int riowd_open(struct inode *inode, struct file *filp)
 {
+	cycle_kernel_lock();
 	nonseekable_open(inode, filp);
 	return 0;
 }
Index: linux-2.6/drivers/sbus/char/rtc.c
===================================================================
--- linux-2.6.orig/drivers/sbus/char/rtc.c
+++ linux-2.6/drivers/sbus/char/rtc.c
@@ -12,6 +12,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/miscdevice.h>
@@ -213,6 +214,7 @@ static int rtc_open(struct inode *inode,
 {
 	int ret;
 
+	lock_kernel();
 	spin_lock_irq(&mostek_lock);
 	if (rtc_busy) {
 		ret = -EBUSY;
@@ -221,6 +223,7 @@ static int rtc_open(struct inode *inode,
 		ret = 0;
 	}
 	spin_unlock_irq(&mostek_lock);
+	unlock_kernel();
 
 	return ret;
 }
Index: linux-2.6/drivers/sbus/char/uctrl.c
===================================================================
--- linux-2.6.orig/drivers/sbus/char/uctrl.c
+++ linux-2.6/drivers/sbus/char/uctrl.c
@@ -9,6 +9,7 @@
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 #include <linux/slab.h>
+#include <linux/smp_lock.h>
 #include <linux/ioport.h>
 #include <linux/init.h>
 #include <linux/miscdevice.h>
@@ -211,8 +212,10 @@ uctrl_ioctl(struct inode *inode, struct 
 static int
 uctrl_open(struct inode *inode, struct file *file)
 {
+	lock_kernel();
 	uctrl_get_event_status();
 	uctrl_get_external_status();
+	unlock_kernel();
 	return 0;
 }
 
Index: linux-2.6/drivers/scsi/megaraid/megaraid_mm.c
===================================================================
--- linux-2.6.orig/drivers/scsi/megaraid/megaraid_mm.c
+++ linux-2.6/drivers/scsi/megaraid/megaraid_mm.c
@@ -15,6 +15,7 @@
  * Common management module
  */
 #include <linux/sched.h>
+#include <linux/smp_lock.h>
 #include "megaraid_mm.h"
 
 
@@ -96,6 +97,7 @@ mraid_mm_open(struct inode *inode, struc
 	 */
 	if (!capable(CAP_SYS_ADMIN)) return (-EACCES);
 
+	cycle_kernel_lock();
 	return 0;
 }
 
Index: linux-2.6/drivers/scsi/scsi_tgt_if.c
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi_tgt_if.c
+++ linux-2.6/drivers/scsi/scsi_tgt_if.c
@@ -21,6 +21,7 @@
  */
 #include <linux/miscdevice.h>
 #include <linux/file.h>
+#include <linux/smp_lock.h>
 #include <net/tcp.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -321,6 +322,7 @@ static int tgt_open(struct inode *inode,
 {
 	tx_ring.tr_idx = rx_ring.tr_idx = 0;
 
+	cycle_kernel_lock();
 	return 0;
 }
 
Index: linux-2.6/fs/dlm/user.c
===================================================================
--- linux-2.6.orig/fs/dlm/user.c
+++ linux-2.6/fs/dlm/user.c
@@ -15,6 +15,7 @@
 #include <linux/poll.h>
 #include <linux/signal.h>
 #include <linux/spinlock.h>
+#include <linux/smp_lock.h>
 #include <linux/dlm.h>
 #include <linux/dlm_device.h>
 
@@ -618,13 +619,17 @@ static int device_open(struct inode *ino
 	struct dlm_user_proc *proc;
 	struct dlm_ls *ls;
 
+	lock_kernel();
 	ls = dlm_find_lockspace_device(iminor(inode));
-	if (!ls)
+	if (!ls) {
+		unlock_kernel();
 		return -ENOENT;
+	}
 
 	proc = kzalloc(sizeof(struct dlm_user_proc), GFP_KERNEL);
 	if (!proc) {
 		dlm_put_lockspace(ls);
+		unlock_kernel();
 		return -ENOMEM;
 	}
 
@@ -636,6 +641,7 @@ static int device_open(struct inode *ino
 	spin_lock_init(&proc->locks_spin);
 	init_waitqueue_head(&proc->wait);
 	file->private_data = proc;
+	unlock_kernel();
 
 	return 0;
 }
@@ -870,6 +876,7 @@ static unsigned int device_poll(struct f
 
 static int ctl_device_open(struct inode *inode, struct file *file)
 {
+	cycle_kernel_lock();
 	file->private_data = NULL;
 	return 0;
 }
Index: linux-2.6/fs/ocfs2/stack_user.c
===================================================================
--- linux-2.6.orig/fs/ocfs2/stack_user.c
+++ linux-2.6/fs/ocfs2/stack_user.c
@@ -21,6 +21,7 @@
 #include <linux/fs.h>
 #include <linux/miscdevice.h>
 #include <linux/mutex.h>
+#include <linux/smp_lock.h>
 #include <linux/reboot.h>
 #include <asm/uaccess.h>
 
@@ -619,10 +620,12 @@ static int ocfs2_control_open(struct ino
 		return -ENOMEM;
 	p->op_this_node = -1;
 
+	lock_kernel();
 	mutex_lock(&ocfs2_control_lock);
 	file->private_data = p;
 	list_add(&p->op_list, &ocfs2_control_private_list);
 	mutex_unlock(&ocfs2_control_lock);
+	unlock_kernel();
 
 	return 0;
 }
Index: linux-2.6/kernel/pm_qos_params.c
===================================================================
--- linux-2.6.orig/kernel/pm_qos_params.c
+++ linux-2.6/kernel/pm_qos_params.c
@@ -358,15 +358,19 @@ static int pm_qos_power_open(struct inod
 	int ret;
 	long pm_qos_class;
 
+	lock_kernel();
 	pm_qos_class = find_pm_qos_object_by_minor(iminor(inode));
 	if (pm_qos_class >= 0) {
 		filp->private_data = (void *)pm_qos_class;
 		sprintf(name, "process_%d", current->pid);
 		ret = pm_qos_add_requirement(pm_qos_class, name,
 					PM_QOS_DEFAULT_VALUE);
-		if (ret >= 0)
+		if (ret >= 0) {
+			unlock_kernel();
 			return 0;
+		}
 	}
+	unlock_kernel();
 
 	return -EPERM;
 }
Index: linux-2.6/kernel/power/user.c
===================================================================
--- linux-2.6.orig/kernel/power/user.c
+++ linux-2.6/kernel/power/user.c
@@ -9,6 +9,7 @@
  *
  */
 
+#include <linux/smp_lock.h>
 #include <linux/suspend.h>
 #include <linux/syscalls.h>
 #include <linux/reboot.h>
@@ -69,15 +70,20 @@ static int snapshot_open(struct inode *i
 	struct snapshot_data *data;
 	int error;
 
-	if (!atomic_add_unless(&snapshot_device_available, -1, 0))
+	lock_kernel();
+	if (!atomic_add_unless(&snapshot_device_available, -1, 0)) {
+		unlock_kernel();
 		return -EBUSY;
+	}
 
 	if ((filp->f_flags & O_ACCMODE) == O_RDWR) {
 		atomic_inc(&snapshot_device_available);
+		unlock_kernel();
 		return -ENOSYS;
 	}
 	if(create_basic_memory_bitmaps()) {
 		atomic_inc(&snapshot_device_available);
+		unlock_kernel();
 		return -ENOMEM;
 	}
 	nonseekable_open(inode, filp);
@@ -100,11 +106,13 @@ static int snapshot_open(struct inode *i
 	}
 	if (error) {
 		atomic_inc(&snapshot_device_available);
+		unlock_kernel();
 		return error;
 	}
 	data->frozen = 0;
 	data->ready = 0;
 	data->platform_support = 0;
+	unlock_kernel();
 
 	return 0;
 }
Index: linux-2.6/net/irda/irnet/irnet.h
===================================================================
--- linux-2.6.orig/net/irda/irnet/irnet.h
+++ linux-2.6/net/irda/irnet/irnet.h
@@ -241,6 +241,7 @@
 #include <linux/module.h>
 
 #include <linux/kernel.h>
+#include <linux/smp_lock.h>
 #include <linux/skbuff.h>
 #include <linux/tty.h>
 #include <linux/proc_fs.h>
Index: linux-2.6/net/irda/irnet/irnet_ppp.c
===================================================================
--- linux-2.6.orig/net/irda/irnet/irnet_ppp.c
+++ linux-2.6/net/irda/irnet/irnet_ppp.c
@@ -479,6 +479,7 @@ dev_irnet_open(struct inode *	inode,
   ap = kzalloc(sizeof(*ap), GFP_KERNEL);
   DABORT(ap == NULL, -ENOMEM, FS_ERROR, "Can't allocate struct irnet...\n");
 
+  lock_kernel();
   /* initialize the irnet structure */
   ap->file = file;
 
@@ -500,6 +501,7 @@ dev_irnet_open(struct inode *	inode,
     {
       DERROR(FS_ERROR, "Can't setup IrDA link...\n");
       kfree(ap);
+      unlock_kernel();
       return err;
     }
 
@@ -510,6 +512,7 @@ dev_irnet_open(struct inode *	inode,
   file->private_data = ap;
 
   DEXIT(FS_TRACE, " - ap=0x%p\n", ap);
+  unlock_kernel();
   return 0;
 }
 

