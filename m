Return-Path: <linux-kernel-owner+w=401wt.eu-S1757349AbZLFR5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349AbZLFR5i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 12:57:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757131AbZLFR5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 12:57:35 -0500
Received: from www.tglx.de ([62.245.132.106]:58365 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756948AbZLFR5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 12:57:34 -0500
Date: Sun, 6 Dec 2009 18:57:26 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [GIT pull] BKL removal in drivers for 2.6.33
Message-ID: <alpine.LFD.2.00.0912061856100.3089@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest bkl-drivers-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git bkl-drivers-for-linus

Thanks,

	tglx

------------------>
Frederic Weisbecker (3):
      mem_class: Drop the bkl from memory_open()
      nvram: Drop the bkl from nvram_llseek()
      nvram: Drop the bkl from non-generic nvram_llseek()

John Kacur (1):
      agp: Remove the BKL from agp_open

Thomas Gleixner (12):
      drivers: Remove BKL from misc_open
      drivers: Remove BKL from cs5535_gpio
      spi: Remove BKL from spidev_open
      macintosh: Remove BKL from ans-lcd
      hw_random: Remove BKL from core
      input: Remove BKL from hp_sdc_rtc
      rtc: Remove BKL from efirtc
      parisc: Remove BKL from eisa_eeprom
      drivers: Remove BKL from pc8736x_gpio
      drivers: Remove BKL from scx200_gpio
      mips: Remove BKL from tb0219
      inifiband: Remove BKL from ipath_open()


 drivers/char/agp/frontend.c                  |   28 ++++++----------
 drivers/char/cs5535_gpio.c                   |    3 +-
 drivers/char/efirtc.c                        |   12 +------
 drivers/char/generic_nvram.c                 |    9 ++---
 drivers/char/hw_random/core.c                |    1 -
 drivers/char/mem.c                           |   17 +++-------
 drivers/char/misc.c                          |    5 +--
 drivers/char/nvram.c                         |    4 +--
 drivers/char/pc8736x_gpio.c                  |    2 -
 drivers/char/scx200_gpio.c                   |    2 -
 drivers/char/tb0219.c                        |    6 +---
 drivers/infiniband/hw/ipath/ipath_file_ops.c |    1 -
 drivers/input/misc/hp_sdc_rtc.c              |    2 -
 drivers/macintosh/ans-lcd.c                  |   45 ++++++++++++++++----------
 drivers/parisc/eisa_eeprom.c                 |   10 ------
 drivers/spi/spidev.c                         |    3 --
 16 files changed, 52 insertions(+), 98 deletions(-)

diff --git a/drivers/char/agp/frontend.c b/drivers/char/agp/frontend.c
index a96f319..43412c0 100644
--- a/drivers/char/agp/frontend.c
+++ b/drivers/char/agp/frontend.c
@@ -676,25 +676,25 @@ static int agp_open(struct inode *inode, struct file *file)
 	int minor = iminor(inode);
 	struct agp_file_private *priv;
 	struct agp_client *client;
-	int rc = -ENXIO;
-
-	lock_kernel();
-	mutex_lock(&(agp_fe.agp_mutex));
 
 	if (minor != AGPGART_MINOR)
-		goto err_out;
+		return -ENXIO;
+
+	mutex_lock(&(agp_fe.agp_mutex));
 
 	priv = kzalloc(sizeof(struct agp_file_private), GFP_KERNEL);
-	if (priv == NULL)
-		goto err_out_nomem;
+	if (priv == NULL) {
+		mutex_unlock(&(agp_fe.agp_mutex));
+		return -ENOMEM;
+	}
 
 	set_bit(AGP_FF_ALLOW_CLIENT, &priv->access_flags);
 	priv->my_pid = current->pid;
 
-	if (capable(CAP_SYS_RAWIO)) {
+	if (capable(CAP_SYS_RAWIO))
 		/* Root priv, can be controller */
 		set_bit(AGP_FF_ALLOW_CONTROLLER, &priv->access_flags);
-	}
+
 	client = agp_find_client_by_pid(current->pid);
 
 	if (client != NULL) {
@@ -704,16 +704,10 @@ static int agp_open(struct inode *inode, struct file *file)
 	file->private_data = (void *) priv;
 	agp_insert_file_private(priv);
 	DBG("private=%p, client=%p", priv, client);
-	mutex_unlock(&(agp_fe.agp_mutex));
-	unlock_kernel();
-	return 0;
 
-err_out_nomem:
-	rc = -ENOMEM;
-err_out:
 	mutex_unlock(&(agp_fe.agp_mutex));
-	unlock_kernel();
-	return rc;
+
+	return 0;
 }
 
 
diff --git a/drivers/char/cs5535_gpio.c b/drivers/char/cs5535_gpio.c
index 04ba906..4d830dc 100644
--- a/drivers/char/cs5535_gpio.c
+++ b/drivers/char/cs5535_gpio.c
@@ -17,7 +17,7 @@
 #include <linux/cdev.h>
 #include <linux/ioport.h>
 #include <linux/pci.h>
-#include <linux/smp_lock.h>
+
 #include <asm/uaccess.h>
 #include <asm/io.h>
 
@@ -158,7 +158,6 @@ static int cs5535_gpio_open(struct inode *inode, struct file *file)
 {
 	u32 m = iminor(inode);
 
-	cycle_kernel_lock();
 	/* the mask says which pins are usable by this driver */
 	if ((mask & (1 << m)) == 0)
 		return -EINVAL;
diff --git a/drivers/char/efirtc.c b/drivers/char/efirtc.c
index 34d15d5..26a47dc 100644
--- a/drivers/char/efirtc.c
+++ b/drivers/char/efirtc.c
@@ -27,8 +27,6 @@
  * 	- Add module support
  */
 
-
-#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/miscdevice.h>
@@ -174,13 +172,12 @@ static long efi_rtc_ioctl(struct file *file, unsigned int cmd,
 			return -EINVAL;
 
 		case RTC_RD_TIME:
-			lock_kernel();
 			spin_lock_irqsave(&efi_rtc_lock, flags);
 
 			status = efi.get_time(&eft, &cap);
 
 			spin_unlock_irqrestore(&efi_rtc_lock,flags);
-			unlock_kernel();
+
 			if (status != EFI_SUCCESS) {
 				/* should never happen */
 				printk(KERN_ERR "efitime: can't read time\n");
@@ -202,13 +199,11 @@ static long efi_rtc_ioctl(struct file *file, unsigned int cmd,
 
 			convert_to_efi_time(&wtime, &eft);
 
-			lock_kernel();
 			spin_lock_irqsave(&efi_rtc_lock, flags);
 
 			status = efi.set_time(&eft);
 
 			spin_unlock_irqrestore(&efi_rtc_lock,flags);
-			unlock_kernel();
 
 			return status == EFI_SUCCESS ? 0 : -EINVAL;
 
@@ -224,7 +219,6 @@ static long efi_rtc_ioctl(struct file *file, unsigned int cmd,
 
 			convert_to_efi_time(&wtime, &eft);
 
-			lock_kernel();
 			spin_lock_irqsave(&efi_rtc_lock, flags);
 			/*
 			 * XXX Fixme:
@@ -235,19 +229,16 @@ static long efi_rtc_ioctl(struct file *file, unsigned int cmd,
 			status = efi.set_wakeup_time((efi_bool_t)enabled, &eft);
 
 			spin_unlock_irqrestore(&efi_rtc_lock,flags);
-			unlock_kernel();
 
 			return status == EFI_SUCCESS ? 0 : -EINVAL;
 
 		case RTC_WKALM_RD:
 
-			lock_kernel();
 			spin_lock_irqsave(&efi_rtc_lock, flags);
 
 			status = efi.get_wakeup_time((efi_bool_t *)&enabled, (efi_bool_t *)&pending, &eft);
 
 			spin_unlock_irqrestore(&efi_rtc_lock,flags);
-			unlock_kernel();
 
 			if (status != EFI_SUCCESS) return -EINVAL;
 
@@ -277,7 +268,6 @@ static int efi_rtc_open(struct inode *inode, struct file *file)
 	 * We do accept multiple open files at the same time as we
 	 * synchronize on the per call operation.
 	 */
-	cycle_kernel_lock();
 	return 0;
 }
 
diff --git a/drivers/char/generic_nvram.c b/drivers/char/generic_nvram.c
index ef31738..fda4181 100644
--- a/drivers/char/generic_nvram.c
+++ b/drivers/char/generic_nvram.c
@@ -19,7 +19,6 @@
 #include <linux/miscdevice.h>
 #include <linux/fcntl.h>
 #include <linux/init.h>
-#include <linux/smp_lock.h>
 #include <asm/uaccess.h>
 #include <asm/nvram.h>
 #ifdef CONFIG_PPC_PMAC
@@ -32,7 +31,6 @@ static ssize_t nvram_len;
 
 static loff_t nvram_llseek(struct file *file, loff_t offset, int origin)
 {
-	lock_kernel();
 	switch (origin) {
 	case 1:
 		offset += file->f_pos;
@@ -41,12 +39,11 @@ static loff_t nvram_llseek(struct file *file, loff_t offset, int origin)
 		offset += nvram_len;
 		break;
 	}
-	if (offset < 0) {
-		unlock_kernel();
+	if (offset < 0)
 		return -EINVAL;
-	}
+
 	file->f_pos = offset;
-	unlock_kernel();
+
 	return file->f_pos;
 }
 
diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 1573aeb..75fb859 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -87,7 +87,6 @@ static int rng_dev_open(struct inode *inode, struct file *filp)
 		return -EINVAL;
 	if (filp->f_mode & FMODE_WRITE)
 		return -EINVAL;
-	cycle_kernel_lock();
 	return 0;
 }
 
diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index a074fce..ad82ec9 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -26,7 +26,6 @@
 #include <linux/bootmem.h>
 #include <linux/splice.h>
 #include <linux/pfn.h>
-#include <linux/smp_lock.h>
 
 #include <asm/uaccess.h>
 #include <asm/io.h>
@@ -892,29 +891,23 @@ static int memory_open(struct inode *inode, struct file *filp)
 {
 	int minor;
 	const struct memdev *dev;
-	int ret = -ENXIO;
-
-	lock_kernel();
 
 	minor = iminor(inode);
 	if (minor >= ARRAY_SIZE(devlist))
-		goto out;
+		return -ENXIO;
 
 	dev = &devlist[minor];
 	if (!dev->fops)
-		goto out;
+		return -ENXIO;
 
 	filp->f_op = dev->fops;
 	if (dev->dev_info)
 		filp->f_mapping->backing_dev_info = dev->dev_info;
 
 	if (dev->fops->open)
-		ret = dev->fops->open(inode, filp);
-	else
-		ret = 0;
-out:
-	unlock_kernel();
-	return ret;
+		return dev->fops->open(inode, filp);
+
+	return 0;
 }
 
 static const struct file_operations memory_fops = {
diff --git a/drivers/char/misc.c b/drivers/char/misc.c
index 07fa612..96f1cd0 100644
--- a/drivers/char/misc.c
+++ b/drivers/char/misc.c
@@ -49,7 +49,6 @@
 #include <linux/device.h>
 #include <linux/tty.h>
 #include <linux/kmod.h>
-#include <linux/smp_lock.h>
 
 /*
  * Head entry for the doubly linked miscdevice list
@@ -118,8 +117,7 @@ static int misc_open(struct inode * inode, struct file * file)
 	struct miscdevice *c;
 	int err = -ENODEV;
 	const struct file_operations *old_fops, *new_fops = NULL;
-	
-	lock_kernel();
+
 	mutex_lock(&misc_mtx);
 	
 	list_for_each_entry(c, &misc_list, list) {
@@ -157,7 +155,6 @@ static int misc_open(struct inode * inode, struct file * file)
 	fops_put(old_fops);
 fail:
 	mutex_unlock(&misc_mtx);
-	unlock_kernel();
 	return err;
 }
 
diff --git a/drivers/char/nvram.c b/drivers/char/nvram.c
index 88cee40..2100a8f 100644
--- a/drivers/char/nvram.c
+++ b/drivers/char/nvram.c
@@ -38,7 +38,6 @@
 #define NVRAM_VERSION	"1.3"
 
 #include <linux/module.h>
-#include <linux/smp_lock.h>
 #include <linux/nvram.h>
 
 #define PC		1
@@ -214,7 +213,6 @@ void nvram_set_checksum(void)
 
 static loff_t nvram_llseek(struct file *file, loff_t offset, int origin)
 {
-	lock_kernel();
 	switch (origin) {
 	case 0:
 		/* nothing to do */
@@ -226,7 +224,7 @@ static loff_t nvram_llseek(struct file *file, loff_t offset, int origin)
 		offset += NVRAM_BYTES;
 		break;
 	}
-	unlock_kernel();
+
 	return (offset >= 0) ? (file->f_pos = offset) : -EINVAL;
 }
 
diff --git a/drivers/char/pc8736x_gpio.c b/drivers/char/pc8736x_gpio.c
index 3f7da8c..8ecbcc1 100644
--- a/drivers/char/pc8736x_gpio.c
+++ b/drivers/char/pc8736x_gpio.c
@@ -20,7 +20,6 @@
 #include <linux/mutex.h>
 #include <linux/nsc_gpio.h>
 #include <linux/platform_device.h>
-#include <linux/smp_lock.h>
 #include <asm/uaccess.h>
 
 #define DEVNAME "pc8736x_gpio"
@@ -223,7 +222,6 @@ static int pc8736x_gpio_open(struct inode *inode, struct file *file)
 	unsigned m = iminor(inode);
 	file->private_data = &pc8736x_gpio_ops;
 
-	cycle_kernel_lock();
 	dev_dbg(&pdev->dev, "open %d\n", m);
 
 	if (m >= PC8736X_GPIO_CT)
diff --git a/drivers/char/scx200_gpio.c b/drivers/char/scx200_gpio.c
index 1d91005..99e5272 100644
--- a/drivers/char/scx200_gpio.c
+++ b/drivers/char/scx200_gpio.c
@@ -12,7 +12,6 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
-#include <linux/smp_lock.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
 
@@ -52,7 +51,6 @@ static int scx200_gpio_open(struct inode *inode, struct file *file)
 	unsigned m = iminor(inode);
 	file->private_data = &scx200_gpio_ops;
 
-	cycle_kernel_lock();
 	if (m >= MAX_PINS)
 		return -EINVAL;
 	return nonseekable_open(inode, file);
diff --git a/drivers/char/tb0219.c b/drivers/char/tb0219.c
index b3ec9b1..cad4eb6 100644
--- a/drivers/char/tb0219.c
+++ b/drivers/char/tb0219.c
@@ -21,7 +21,6 @@
 #include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/module.h>
-#include <linux/smp_lock.h>
 
 #include <asm/io.h>
 #include <asm/reboot.h>
@@ -38,7 +37,7 @@ MODULE_PARM_DESC(major, "Major device number");
 
 static void (*old_machine_restart)(char *command);
 static void __iomem *tb0219_base;
-static spinlock_t tb0219_lock;
+static DEFINE_SPINLOCK(tb0219_lock);
 
 #define tb0219_read(offset)		readw(tb0219_base + (offset))
 #define tb0219_write(offset, value)	writew((value), tb0219_base + (offset))
@@ -237,7 +236,6 @@ static int tanbac_tb0219_open(struct inode *inode, struct file *file)
 {
 	unsigned int minor;
 
-	cycle_kernel_lock();
 	minor = iminor(inode);
 	switch (minor) {
 	case 0:
@@ -306,8 +304,6 @@ static int __devinit tb0219_probe(struct platform_device *dev)
 		return retval;
 	}
 
-	spin_lock_init(&tb0219_lock);
-
 	old_machine_restart = _machine_restart;
 	_machine_restart = tb0219_restart;
 
diff --git a/drivers/infiniband/hw/ipath/ipath_file_ops.c b/drivers/infiniband/hw/ipath/ipath_file_ops.c
index 40dbe54..73933a4 100644
--- a/drivers/infiniband/hw/ipath/ipath_file_ops.c
+++ b/drivers/infiniband/hw/ipath/ipath_file_ops.c
@@ -1821,7 +1821,6 @@ done:
 static int ipath_open(struct inode *in, struct file *fp)
 {
 	/* The real work is performed later in ipath_assign_port() */
-	cycle_kernel_lock();
 	fp->private_data = kzalloc(sizeof(struct ipath_filedata), GFP_KERNEL);
 	return fp->private_data ? 0 : -ENOMEM;
 }
diff --git a/drivers/input/misc/hp_sdc_rtc.c b/drivers/input/misc/hp_sdc_rtc.c
index 216a559..4d1aa9a 100644
--- a/drivers/input/misc/hp_sdc_rtc.c
+++ b/drivers/input/misc/hp_sdc_rtc.c
@@ -35,7 +35,6 @@
 
 #include <linux/hp_sdc.h>
 #include <linux/errno.h>
-#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/init.h>
 #include <linux/module.h>
@@ -409,7 +408,6 @@ static unsigned int hp_sdc_rtc_poll(struct file *file, poll_table *wait)
 
 static int hp_sdc_rtc_open(struct inode *inode, struct file *file)
 {
-	cycle_kernel_lock();
         return 0;
 }
 
diff --git a/drivers/macintosh/ans-lcd.c b/drivers/macintosh/ans-lcd.c
index 6a82218..a3d25da 100644
--- a/drivers/macintosh/ans-lcd.c
+++ b/drivers/macintosh/ans-lcd.c
@@ -3,7 +3,6 @@
  */
 
 #include <linux/types.h>
-#include <linux/smp_lock.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/miscdevice.h>
@@ -26,6 +25,7 @@
 static unsigned long anslcd_short_delay = 80;
 static unsigned long anslcd_long_delay = 3280;
 static volatile unsigned char __iomem *anslcd_ptr;
+static DEFINE_MUTEX(anslcd_mutex);
 
 #undef DEBUG
 
@@ -65,26 +65,31 @@ anslcd_write( struct file * file, const char __user * buf,
 
 	if (!access_ok(VERIFY_READ, buf, count))
 		return -EFAULT;
+
+	mutex_lock(&anslcd_mutex);
 	for ( i = *ppos; count > 0; ++i, ++p, --count ) 
 	{
 		char c;
 		__get_user(c, p);
 		anslcd_write_byte_data( c );
 	}
+	mutex_unlock(&anslcd_mutex);
 	*ppos = i;
 	return p - buf;
 }
 
-static int
-anslcd_ioctl( struct inode * inode, struct file * file,
-				unsigned int cmd, unsigned long arg )
+static long
+anslcd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	char ch, __user *temp;
+	long ret = 0;
 
 #ifdef DEBUG
 	printk(KERN_DEBUG "LCD: ioctl(%d,%d)\n",cmd,arg);
 #endif
 
+	mutex_lock(&anslcd_mutex);
+
 	switch ( cmd )
 	{
 	case ANSLCD_CLEAR:
@@ -93,7 +98,7 @@ anslcd_ioctl( struct inode * inode, struct file * file,
 		anslcd_write_byte_ctrl ( 0x06 );
 		anslcd_write_byte_ctrl ( 0x01 );
 		anslcd_write_byte_ctrl ( 0x02 );
-		return 0;
+		break;
 	case ANSLCD_SENDCTRL:
 		temp = (char __user *) arg;
 		__get_user(ch, temp);
@@ -101,33 +106,37 @@ anslcd_ioctl( struct inode * inode, struct file * file,
 			anslcd_write_byte_ctrl ( ch );
 			__get_user(ch, temp);
 		}
-		return 0;
+		break;
 	case ANSLCD_SETSHORTDELAY:
 		if (!capable(CAP_SYS_ADMIN))
-			return -EACCES;
-		anslcd_short_delay=arg;
-		return 0;
+			ret =-EACCES;
+		else
+			anslcd_short_delay=arg;
+		break;
 	case ANSLCD_SETLONGDELAY:
 		if (!capable(CAP_SYS_ADMIN))
-			return -EACCES;
-		anslcd_long_delay=arg;
-		return 0;
+			ret = -EACCES;
+		else
+			anslcd_long_delay=arg;
+		break;
 	default:
-		return -EINVAL;
+		ret = -EINVAL;
 	}
+
+	mutex_unlock(&anslcd_mutex);
+	return ret;
 }
 
 static int
 anslcd_open( struct inode * inode, struct file * file )
 {
-	cycle_kernel_lock();
 	return 0;
 }
 
 const struct file_operations anslcd_fops = {
-	.write	= anslcd_write,
-	.ioctl	= anslcd_ioctl,
-	.open	= anslcd_open,
+	.write		= anslcd_write,
+	.unlocked_ioctl	= anslcd_ioctl,
+	.open		= anslcd_open,
 };
 
 static struct miscdevice anslcd_dev = {
@@ -168,6 +177,7 @@ anslcd_init(void)
 	printk(KERN_DEBUG "LCD: init\n");
 #endif
 
+	mutex_lock(&anslcd_mutex);
 	anslcd_write_byte_ctrl ( 0x38 );
 	anslcd_write_byte_ctrl ( 0x0c );
 	anslcd_write_byte_ctrl ( 0x06 );
@@ -176,6 +186,7 @@ anslcd_init(void)
 	for(a=0;a<80;a++) {
 		anslcd_write_byte_data(anslcd_logo[a]);
 	}
+	mutex_unlock(&anslcd_mutex);
 	return 0;
 }
 
diff --git a/drivers/parisc/eisa_eeprom.c b/drivers/parisc/eisa_eeprom.c
index 8c0b26e..cce00ed 100644
--- a/drivers/parisc/eisa_eeprom.c
+++ b/drivers/parisc/eisa_eeprom.c
@@ -75,17 +75,8 @@ static ssize_t eisa_eeprom_read(struct file * file,
 	return ret;
 }
 
-static int eisa_eeprom_ioctl(struct inode *inode, struct file *file, 
-			   unsigned int cmd,
-			   unsigned long arg)
-{
-	return -ENOTTY;
-}
-
 static int eisa_eeprom_open(struct inode *inode, struct file *file)
 {
-	cycle_kernel_lock();
-
 	if (file->f_mode & FMODE_WRITE)
 		return -EINVAL;
    
@@ -104,7 +95,6 @@ static const struct file_operations eisa_eeprom_fops = {
 	.owner =	THIS_MODULE,
 	.llseek =	eisa_eeprom_llseek,
 	.read =		eisa_eeprom_read,
-	.ioctl =	eisa_eeprom_ioctl,
 	.open =		eisa_eeprom_open,
 	.release =	eisa_eeprom_release,
 };
diff --git a/drivers/spi/spidev.c b/drivers/spi/spidev.c
index 5d23983..815a650 100644
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -30,7 +30,6 @@
 #include <linux/errno.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 
 #include <linux/spi/spi.h>
 #include <linux/spi/spidev.h>
@@ -477,7 +476,6 @@ static int spidev_open(struct inode *inode, struct file *filp)
 	struct spidev_data	*spidev;
 	int			status = -ENXIO;
 
-	lock_kernel();
 	mutex_lock(&device_list_lock);
 
 	list_for_each_entry(spidev, &device_list, device_entry) {
@@ -503,7 +501,6 @@ static int spidev_open(struct inode *inode, struct file *filp)
 		pr_debug("spidev: nothing for minor %d\n", iminor(inode));
 
 	mutex_unlock(&device_list_lock);
-	unlock_kernel();
 	return status;
 }
 
