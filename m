Return-Path: <linux-kernel-owner+w=401wt.eu-S964962AbXBLPH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964962AbXBLPH0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 10:07:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964961AbXBLPH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 10:07:26 -0500
Received: from mtagate1.de.ibm.com ([195.212.29.150]:30336 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964960AbXBLPHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 10:07:24 -0500
Date: Mon, 12 Feb 2007 16:07:29 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Please pull git390 'for-linus' branch
Message-ID: <20070212150729.GA7087@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from 'for-linus' branch of

	git://git390.osdl.marist.edu/pub/scm/linux-2.6.git for-linus

to receive the following updates:

 arch/s390/kernel/smp.c        |   15 +++++++++------
 drivers/s390/cio/device_id.c  |    3 ++-
 drivers/s390/cio/device_ops.c |   32 ++++++++++++++++++++++++++++++--
 drivers/s390/cio/qdio.c       |    2 +-
 include/asm-s390/ccwdev.h     |    2 ++
 include/asm-s390/io.h         |    6 +-----
 6 files changed, 45 insertions(+), 15 deletions(-)

Ahmed S. Darwish (1):
      [S390] cio: use ARRAY_SIZE in device_id.c

Cornelia Huck (1):
      [S390] cio: Fixup interface for setting options on ccw devices.

Heiko Carstens (1):
      [S390] smp_call_function/smp_call_function_on locking.

Martin Schwidefsky (1):
      [S390] remove __io_virt and mmiowb.

diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index 65b5232..83a4ea6 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -57,7 +57,7 @@ static void smp_ext_bitcall(int, ec_bit_sig);
 static void smp_ext_bitcall_others(ec_bit_sig);
 
 /*
-5B * Structure and data for smp_call_function(). This is designed to minimise
+ * Structure and data for smp_call_function(). This is designed to minimise
  * static memory requirements. It also looks cleaner.
  */
 static DEFINE_SPINLOCK(call_lock);
@@ -104,7 +104,7 @@ int smp_call_function (void (*func) (void *info), void *info, int nonatomic,
  * remote CPUs are nearly ready to execute <<func>> or are or have executed.
  *
  * You must not call this function with disabled interrupts or from a
- * hardware interrupt handler or from a bottom half handler.
+ * hardware interrupt handler.
  */
 {
 	struct call_data_struct data;
@@ -113,8 +113,8 @@ int smp_call_function (void (*func) (void *info), void *info, int nonatomic,
 	if (cpus <= 0)
 		return 0;
 
-	/* Can deadlock when called with interrupts disabled */
-	WARN_ON(irqs_disabled());
+	/* Can deadlock when interrupts are disabled or if in wrong context */
+	WARN_ON(irqs_disabled() || in_irq());
 
 	data.func = func;
 	data.info = info;
@@ -123,7 +123,7 @@ int smp_call_function (void (*func) (void *info), void *info, int nonatomic,
 	if (wait)
 		atomic_set(&data.finished, 0);
 
-	spin_lock(&call_lock);
+	spin_lock_bh(&call_lock);
 	call_data = &data;
 	/* Send a message to all other CPUs and wait for them to respond */
         smp_ext_bitcall_others(ec_call_function);
@@ -135,7 +135,7 @@ int smp_call_function (void (*func) (void *info), void *info, int nonatomic,
 	if (wait)
 		while (atomic_read(&data.finished) != cpus)
 			cpu_relax();
-	spin_unlock(&call_lock);
+	spin_unlock_bh(&call_lock);
 
 	return 0;
 }
@@ -159,6 +159,9 @@ int smp_call_function_on(void (*func) (void *info), void *info,
 	if (!cpu_online(cpu))
 		return -EINVAL;
 
+	/* Can deadlock when interrupts are disabled or if in wrong context */
+	WARN_ON(irqs_disabled() || in_irq());
+
 	/* disable preemption for local function call */
 	curr_cpu = get_cpu();
 
diff --git a/drivers/s390/cio/device_id.c b/drivers/s390/cio/device_id.c
index f172759..997f468 100644
--- a/drivers/s390/cio/device_id.c
+++ b/drivers/s390/cio/device_id.c
@@ -11,6 +11,7 @@
 
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/kernel.h>
 
 #include <asm/ccwdev.h>
 #include <asm/delay.h>
@@ -138,7 +139,7 @@ VM_virtual_device_info (__u16 devno, struct senseid *ps)
 		ps->cu_model = 0x60;
 		return;
 	}
-	for (i = 0; i < sizeof(vm_devices) / sizeof(vm_devices[0]); i++)
+	for (i = 0; i < ARRAY_SIZE(vm_devices); i++)
 		if (diag_data.vrdcvcla == vm_devices[i].vrdcvcla &&
 		    diag_data.vrdcvtyp == vm_devices[i].vrdcvtyp) {
 			ps->cu_type = vm_devices[i].cu_type;
diff --git a/drivers/s390/cio/device_ops.c b/drivers/s390/cio/device_ops.c
index d7b25b8..7c7775a 100644
--- a/drivers/s390/cio/device_ops.c
+++ b/drivers/s390/cio/device_ops.c
@@ -23,8 +23,7 @@
 #include "chsc.h"
 #include "device.h"
 
-int
-ccw_device_set_options(struct ccw_device *cdev, unsigned long flags)
+int ccw_device_set_options_mask(struct ccw_device *cdev, unsigned long flags)
 {
        /*
 	* The flag usage is mutal exclusive ...
@@ -39,6 +38,33 @@ ccw_device_set_options(struct ccw_device *cdev, unsigned long flags)
 	return 0;
 }
 
+int ccw_device_set_options(struct ccw_device *cdev, unsigned long flags)
+{
+       /*
+	* The flag usage is mutal exclusive ...
+	*/
+	if (((flags & CCWDEV_EARLY_NOTIFICATION) &&
+	    (flags & CCWDEV_REPORT_ALL)) ||
+	    ((flags & CCWDEV_EARLY_NOTIFICATION) &&
+	     cdev->private->options.repall) ||
+	    ((flags & CCWDEV_REPORT_ALL) &&
+	     cdev->private->options.fast))
+		return -EINVAL;
+	cdev->private->options.fast |= (flags & CCWDEV_EARLY_NOTIFICATION) != 0;
+	cdev->private->options.repall |= (flags & CCWDEV_REPORT_ALL) != 0;
+	cdev->private->options.pgroup |= (flags & CCWDEV_DO_PATHGROUP) != 0;
+	cdev->private->options.force |= (flags & CCWDEV_ALLOW_FORCE) != 0;
+	return 0;
+}
+
+void ccw_device_clear_options(struct ccw_device *cdev, unsigned long flags)
+{
+	cdev->private->options.fast &= (flags & CCWDEV_EARLY_NOTIFICATION) == 0;
+	cdev->private->options.repall &= (flags & CCWDEV_REPORT_ALL) == 0;
+	cdev->private->options.pgroup &= (flags & CCWDEV_DO_PATHGROUP) == 0;
+	cdev->private->options.force &= (flags & CCWDEV_ALLOW_FORCE) == 0;
+}
+
 int
 ccw_device_clear(struct ccw_device *cdev, unsigned long intparm)
 {
@@ -601,7 +627,9 @@ _ccw_device_get_device_number(struct ccw_device *cdev)
 
 
 MODULE_LICENSE("GPL");
+EXPORT_SYMBOL(ccw_device_set_options_mask);
 EXPORT_SYMBOL(ccw_device_set_options);
+EXPORT_SYMBOL(ccw_device_clear_options);
 EXPORT_SYMBOL(ccw_device_clear);
 EXPORT_SYMBOL(ccw_device_halt);
 EXPORT_SYMBOL(ccw_device_resume);
diff --git a/drivers/s390/cio/qdio.c b/drivers/s390/cio/qdio.c
index d726cd5..5b1e3ff 100644
--- a/drivers/s390/cio/qdio.c
+++ b/drivers/s390/cio/qdio.c
@@ -3194,7 +3194,7 @@ qdio_establish(struct qdio_initialize *init_data)
 
 	spin_lock_irqsave(get_ccwdev_lock(cdev),saveflags);
 
-	ccw_device_set_options(cdev, 0);
+	ccw_device_set_options_mask(cdev, 0);
 	result=ccw_device_start_timeout(cdev,&irq_ptr->ccw,
 					QDIO_DOING_ESTABLISH,0, 0,
 					QDIO_ESTABLISH_TIMEOUT);
diff --git a/include/asm-s390/ccwdev.h b/include/asm-s390/ccwdev.h
index 58c70ac..cfc8153 100644
--- a/include/asm-s390/ccwdev.h
+++ b/include/asm-s390/ccwdev.h
@@ -110,7 +110,9 @@ extern void ccw_driver_unregister (struct ccw_driver *driver);
 
 struct ccw1;
 
+extern int ccw_device_set_options_mask(struct ccw_device *, unsigned long);
 extern int ccw_device_set_options(struct ccw_device *, unsigned long);
+extern void ccw_device_clear_options(struct ccw_device *, unsigned long);
 
 /* Allow for i/o completion notification after primary interrupt status. */
 #define CCWDEV_EARLY_NOTIFICATION	0x0001
diff --git a/include/asm-s390/io.h b/include/asm-s390/io.h
index dca6a6c..b7ff6af 100644
--- a/include/asm-s390/io.h
+++ b/include/asm-s390/io.h
@@ -17,8 +17,6 @@
 
 #define IO_SPACE_LIMIT 0xffffffff
 
-#define __io_virt(x)            ((void *)(PAGE_OFFSET | (unsigned long)(x)))
-
 /*
  * Change virtual addresses to physical addresses and vv.
  * These are pretty trivial
@@ -37,11 +35,9 @@ static inline unsigned long virt_to_phys(volatile void * address)
 
 static inline void * phys_to_virt(unsigned long address)
 {
-        return __io_virt(address);
+	return (void *) address;
 }
 
-#define mmiowb()	do { } while (0)
-
 /*
  * Convert a physical pointer to a virtual kernel pointer for /dev/mem
  * access
