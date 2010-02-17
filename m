Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757220Ab0BQOmL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 09:42:11 -0500
Received: from www.tglx.de ([62.245.132.106]:34777 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753355Ab0BQOmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 09:42:08 -0500
Message-Id: <20100217144121.650660618@linutronix.de>
User-Agent: quilt/0.47-1
Date: Wed, 17 Feb 2010 14:41:59 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Robert Richter <robert.richter@amd.com>
Subject: [patch 1/1] oprofile: Convert oprofilefs_lock to raw_spinlock
Content-Disposition: inline; filename=0121.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

oprofilefs_lock needs to be a real spinlock on preempt-rt. Convert it
to a raw_spinlock. No change for !RT kernels.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Robert Richter <robert.richter@amd.com>
---
 arch/arm/oprofile/common.c      |    4 ++--
 arch/x86/oprofile/nmi_int.c     |    4 ++--
 drivers/oprofile/event_buffer.c |    4 ++--
 drivers/oprofile/oprofilefs.c   |    6 +++---
 include/linux/oprofile.h        |    2 +-
 5 files changed, 10 insertions(+), 10 deletions(-)

Index: linux-2.6-tip/arch/arm/oprofile/common.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/oprofile/common.c
+++ linux-2.6-tip/arch/arm/oprofile/common.c
@@ -48,9 +48,9 @@ static int op_arm_setup(void)
 {
 	int ret;
 
-	spin_lock(&oprofilefs_lock);
+	raw_spin_lock(&oprofilefs_lock);
 	ret = op_arm_model->setup_ctrs();
-	spin_unlock(&oprofilefs_lock);
+	raw_spin_unlock(&oprofilefs_lock);
 	return ret;
 }
 
Index: linux-2.6-tip/arch/x86/oprofile/nmi_int.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/oprofile/nmi_int.c
+++ linux-2.6-tip/arch/x86/oprofile/nmi_int.c
@@ -321,10 +321,10 @@ static void nmi_cpu_setup(void *dummy)
 	int cpu = smp_processor_id();
 	struct op_msrs *msrs = &per_cpu(cpu_msrs, cpu);
 	nmi_cpu_save_registers(msrs);
-	spin_lock(&oprofilefs_lock);
+	raw_spin_lock(&oprofilefs_lock);
 	model->setup_ctrs(model, msrs);
 	nmi_cpu_setup_mux(cpu, msrs);
-	spin_unlock(&oprofilefs_lock);
+	raw_spin_unlock(&oprofilefs_lock);
 	per_cpu(saved_lvtpc, cpu) = apic_read(APIC_LVTPC);
 	apic_write(APIC_LVTPC, APIC_DM_NMI);
 }
Index: linux-2.6-tip/drivers/oprofile/event_buffer.c
===================================================================
--- linux-2.6-tip.orig/drivers/oprofile/event_buffer.c
+++ linux-2.6-tip/drivers/oprofile/event_buffer.c
@@ -82,10 +82,10 @@ int alloc_event_buffer(void)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&oprofilefs_lock, flags);
+	raw_spin_lock_irqsave(&oprofilefs_lock, flags);
 	buffer_size = oprofile_buffer_size;
 	buffer_watershed = oprofile_buffer_watershed;
-	spin_unlock_irqrestore(&oprofilefs_lock, flags);
+	raw_spin_unlock_irqrestore(&oprofilefs_lock, flags);
 
 	if (buffer_watershed >= buffer_size)
 		return -EINVAL;
Index: linux-2.6-tip/drivers/oprofile/oprofilefs.c
===================================================================
--- linux-2.6-tip.orig/drivers/oprofile/oprofilefs.c
+++ linux-2.6-tip/drivers/oprofile/oprofilefs.c
@@ -21,7 +21,7 @@
 
 #define OPROFILEFS_MAGIC 0x6f70726f
 
-DEFINE_SPINLOCK(oprofilefs_lock);
+DEFINE_RAW_SPINLOCK(oprofilefs_lock);
 
 static struct inode *oprofilefs_get_inode(struct super_block *sb, int mode)
 {
@@ -75,9 +75,9 @@ int oprofilefs_ulong_from_user(unsigned 
 	if (copy_from_user(tmpbuf, buf, count))
 		return -EFAULT;
 
-	spin_lock_irqsave(&oprofilefs_lock, flags);
+	raw_spin_lock_irqsave(&oprofilefs_lock, flags);
 	*val = simple_strtoul(tmpbuf, NULL, 0);
-	spin_unlock_irqrestore(&oprofilefs_lock, flags);
+	raw_spin_unlock_irqrestore(&oprofilefs_lock, flags);
 	return 0;
 }
 
Index: linux-2.6-tip/include/linux/oprofile.h
===================================================================
--- linux-2.6-tip.orig/include/linux/oprofile.h
+++ linux-2.6-tip/include/linux/oprofile.h
@@ -156,7 +156,7 @@ ssize_t oprofilefs_ulong_to_user(unsigne
 int oprofilefs_ulong_from_user(unsigned long * val, char const __user * buf, size_t count);
 
 /** lock for read/write safety */
-extern spinlock_t oprofilefs_lock;
+extern raw_spinlock_t oprofilefs_lock;
 
 /**
  * Add the contents of a circular buffer to the event buffer.


