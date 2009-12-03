Return-Path: <linux-kernel-owner+w=401wt.eu-S1755483AbZLCUgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483AbZLCUgw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 15:36:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755069AbZLCUgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 15:36:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50125 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754790AbZLCUgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 15:36:49 -0500
Date: Thu, 3 Dec 2009 21:36:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/cleanups for v2.6.33
Message-ID: <20091203203642.GA18116@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-cleanups-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-cleanups-for-linus

 Thanks,

	Ingo

------------------>
H. Peter Anvin (4):
      x86: use kernel_stack_pointer() in process_32.c
      x86: use kernel_stack_pointer() in dumpstack.c
      x86: use kernel_stack_pointer() in kgdb.c
      x86: use kernel_stack_pointer() in kprobes.c

Helight.Xu (1):
      x86: Fix a section mismatch in arch/x86/kernel/setup.c

Thomas Gleixner (3):
      x86: Remove BKL from microcode
      x86: Remove BKL from apm_32
      x86: Fixup last users of irq_chip->typename


 arch/x86/kernel/apm_32.c         |   14 ++++++--------
 arch/x86/kernel/dumpstack.c      |    7 ++++---
 arch/x86/kernel/kgdb.c           |    3 +--
 arch/x86/kernel/kprobes.c        |   14 +-------------
 arch/x86/kernel/microcode_core.c |    2 --
 arch/x86/kernel/process_32.c     |    2 +-
 arch/x86/kernel/setup.c          |    4 ++--
 arch/x86/kernel/visws_quirks.c   |    6 +++---
 8 files changed, 18 insertions(+), 34 deletions(-)

diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index 151ace6..b5b6b23 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -204,7 +204,6 @@
 #include <linux/module.h>
 
 #include <linux/poll.h>
-#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/stddef.h>
 #include <linux/timer.h>
@@ -403,6 +402,7 @@ static DECLARE_WAIT_QUEUE_HEAD(apm_waitqueue);
 static DECLARE_WAIT_QUEUE_HEAD(apm_suspend_waitqueue);
 static struct apm_user *user_list;
 static DEFINE_SPINLOCK(user_list_lock);
+static DEFINE_MUTEX(apm_mutex);
 
 /*
  * Set up a segment that references the real mode segment 0x40
@@ -1531,7 +1531,7 @@ static long do_ioctl(struct file *filp, u_int cmd, u_long arg)
 		return -EPERM;
 	switch (cmd) {
 	case APM_IOC_STANDBY:
-		lock_kernel();
+		mutex_lock(&apm_mutex);
 		if (as->standbys_read > 0) {
 			as->standbys_read--;
 			as->standbys_pending--;
@@ -1540,10 +1540,10 @@ static long do_ioctl(struct file *filp, u_int cmd, u_long arg)
 			queue_event(APM_USER_STANDBY, as);
 		if (standbys_pending <= 0)
 			standby();
-		unlock_kernel();
+		mutex_unlock(&apm_mutex);
 		break;
 	case APM_IOC_SUSPEND:
-		lock_kernel();
+		mutex_lock(&apm_mutex);
 		if (as->suspends_read > 0) {
 			as->suspends_read--;
 			as->suspends_pending--;
@@ -1552,13 +1552,14 @@ static long do_ioctl(struct file *filp, u_int cmd, u_long arg)
 			queue_event(APM_USER_SUSPEND, as);
 		if (suspends_pending <= 0) {
 			ret = suspend(1);
+			mutex_unlock(&apm_mutex);
 		} else {
 			as->suspend_wait = 1;
+			mutex_unlock(&apm_mutex);
 			wait_event_interruptible(apm_suspend_waitqueue,
 					as->suspend_wait == 0);
 			ret = as->suspend_result;
 		}
-		unlock_kernel();
 		return ret;
 	default:
 		return -ENOTTY;
@@ -1608,12 +1609,10 @@ static int do_open(struct inode *inode, struct file *filp)
 {
 	struct apm_user *as;
 
-	lock_kernel();
 	as = kmalloc(sizeof(*as), GFP_KERNEL);
 	if (as == NULL) {
 		printk(KERN_ERR "apm: cannot allocate struct of size %d bytes\n",
 		       sizeof(*as));
-		       unlock_kernel();
 		return -ENOMEM;
 	}
 	as->magic = APM_BIOS_MAGIC;
@@ -1635,7 +1634,6 @@ static int do_open(struct inode *inode, struct file *filp)
 	user_list = as;
 	spin_unlock(&user_list_lock);
 	filp->private_data = as;
-	unlock_kernel();
 	return 0;
 }
 
diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index 2d8a371..b8ce165 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -268,11 +268,12 @@ int __kprobes __die(const char *str, struct pt_regs *regs, long err)
 
 	show_registers(regs);
 #ifdef CONFIG_X86_32
-	sp = (unsigned long) (&regs->sp);
-	savesegment(ss, ss);
-	if (user_mode(regs)) {
+	if (user_mode_vm(regs)) {
 		sp = regs->sp;
 		ss = regs->ss & 0xffff;
+	} else {
+		sp = kernel_stack_pointer(regs);
+		savesegment(ss, ss);
 	}
 	printk(KERN_EMERG "EIP: [<%08lx>] ", regs->ip);
 	print_symbol("%s", regs->ip);
diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index 8d82a77..3310d84 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -88,7 +88,6 @@ void pt_regs_to_gdb_regs(unsigned long *gdb_regs, struct pt_regs *regs)
 	gdb_regs[GDB_SS]	= __KERNEL_DS;
 	gdb_regs[GDB_FS]	= 0xFFFF;
 	gdb_regs[GDB_GS]	= 0xFFFF;
-	gdb_regs[GDB_SP]	= (int)&regs->sp;
 #else
 	gdb_regs[GDB_R8]	= regs->r8;
 	gdb_regs[GDB_R9]	= regs->r9;
@@ -101,8 +100,8 @@ void pt_regs_to_gdb_regs(unsigned long *gdb_regs, struct pt_regs *regs)
 	gdb_regs32[GDB_PS]	= regs->flags;
 	gdb_regs32[GDB_CS]	= regs->cs;
 	gdb_regs32[GDB_SS]	= regs->ss;
-	gdb_regs[GDB_SP]	= regs->sp;
 #endif
+	gdb_regs[GDB_SP]	= kernel_stack_pointer(regs);
 }
 
 /**
diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index 7b5169d..2ee4fa3 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -60,19 +60,7 @@ void jprobe_return_end(void);
 DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
 DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
 
-#ifdef CONFIG_X86_64
-#define stack_addr(regs) ((unsigned long *)regs->sp)
-#else
-/*
- * "&regs->sp" looks wrong, but it's correct for x86_32.  x86_32 CPUs
- * don't save the ss and esp registers if the CPU is already in kernel
- * mode when it traps.  So for kprobes, regs->sp and regs->ss are not
- * the [nonexistent] saved stack pointer and ss register, but rather
- * the top 8 bytes of the pre-int3 stack.  So &regs->sp happens to
- * point to the top of the pre-int3 stack.
- */
-#define stack_addr(regs) ((unsigned long *)&regs->sp)
-#endif
+#define stack_addr(regs) ((unsigned long *)kernel_stack_pointer(regs))
 
 #define W(row, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf)\
 	(((b0##UL << 0x0)|(b1##UL << 0x1)|(b2##UL << 0x2)|(b3##UL << 0x3) |   \
diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index 378e9a8..2bcad39 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -73,7 +73,6 @@
 #include <linux/platform_device.h>
 #include <linux/miscdevice.h>
 #include <linux/capability.h>
-#include <linux/smp_lock.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
@@ -201,7 +200,6 @@ static int do_microcode_update(const void __user *buf, size_t size)
 
 static int microcode_open(struct inode *unused1, struct file *unused2)
 {
-	cycle_kernel_lock();
 	return capable(CAP_SYS_RAWIO) ? 0 : -EPERM;
 }
 
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 4cf7956..35e6fad 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -134,7 +134,7 @@ void __show_regs(struct pt_regs *regs, int all)
 		ss = regs->ss & 0xffff;
 		gs = get_user_gs(regs);
 	} else {
-		sp = (unsigned long) (&regs->sp);
+		sp = kernel_stack_pointer(regs);
 		savesegment(ss, ss);
 		savesegment(gs, gs);
 	}
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index e09f0e2..e020b2d 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -247,7 +247,7 @@ EXPORT_SYMBOL(edd);
  *              from boot_params into a safe place.
  *
  */
-static inline void copy_edd(void)
+static inline void __init copy_edd(void)
 {
      memcpy(edd.mbr_signature, boot_params.edd_mbr_sig_buffer,
 	    sizeof(edd.mbr_signature));
@@ -256,7 +256,7 @@ static inline void copy_edd(void)
      edd.edd_info_nr = boot_params.eddbuf_entries;
 }
 #else
-static inline void copy_edd(void)
+static inline void __init copy_edd(void)
 {
 }
 #endif
diff --git a/arch/x86/kernel/visws_quirks.c b/arch/x86/kernel/visws_quirks.c
index f068553..f084dfd 100644
--- a/arch/x86/kernel/visws_quirks.c
+++ b/arch/x86/kernel/visws_quirks.c
@@ -486,7 +486,7 @@ static void end_cobalt_irq(unsigned int irq)
 }
 
 static struct irq_chip cobalt_irq_type = {
-	.typename =	"Cobalt-APIC",
+	.name =		"Cobalt-APIC",
 	.startup =	startup_cobalt_irq,
 	.shutdown =	disable_cobalt_irq,
 	.enable =	enable_cobalt_irq,
@@ -523,7 +523,7 @@ static void end_piix4_master_irq(unsigned int irq)
 }
 
 static struct irq_chip piix4_master_irq_type = {
-	.typename =	"PIIX4-master",
+	.name =		"PIIX4-master",
 	.startup =	startup_piix4_master_irq,
 	.ack =		ack_cobalt_irq,
 	.end =		end_piix4_master_irq,
@@ -531,7 +531,7 @@ static struct irq_chip piix4_master_irq_type = {
 
 
 static struct irq_chip piix4_virtual_irq_type = {
-	.typename =	"PIIX4-virtual",
+	.name =		"PIIX4-virtual",
 	.shutdown =	disable_8259A_irq,
 	.enable =	enable_8259A_irq,
 	.disable =	disable_8259A_irq,
