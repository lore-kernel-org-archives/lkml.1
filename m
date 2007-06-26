Return-Path: <linux-kernel-owner+w=401wt.eu-S1758895AbXFZSRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758895AbXFZSRc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 14:17:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756771AbXFZSR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 14:17:26 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45682 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752379AbXFZSRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 14:17:24 -0400
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="W4OEqKSvhl"
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>
X-Fcc: ~/Mail/utrace
Cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] hwbkpt: Hardware breakpoints (was Kwatch)
In-Reply-To: Alan Stern's message of  Monday, 25 June 2007 16:51:42 -0400 <Pine.LNX.4.44L0.0706251642030.2546-100000@iolanthe.rowland.org>
Emacs: it's all fun and games, until somebody tries to edit a file.
Message-Id: <20070626181715.7264AD0002@magilla.localdomain>
Date: Tue, 26 Jun 2007 11:17:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--W4OEqKSvhl
Content-Type: text/plain; charset=us-ascii
Content-Description: message body text
Content-Transfer-Encoding: 7bit

I needed the attached patch on top of the bptest patch for the current
code.  Btw, that is a very nice little tester!

Below that is a patch to go on top of your current patch, with x86-64
support.  I've only tried a few trivial tests with bptest (including an
8-byte bp), which worked great.  It is a pretty faithful copy of your i386
changes.  I'm still not sure we have all that right, but you might as well
incorporate this into your patch.  You should change the x86_64 code in
parallel with any i386 changes we decide on later, and I can test it and
send you any typo fixups or whatnot.


Thanks,
Roland



--W4OEqKSvhl
Content-Type: text/plain
Content-Description: bptest patch
Content-Disposition: inline;
	filename="bptest-fixup.patch"
Content-Transfer-Encoding: 7bit

--- bptest/bptest.c.~1~	2007-06-25 04:08:06.000000000 -0700
+++ bptest/bptest.c	2007-06-26 01:14:20.000000000 -0700
@@ -147,17 +147,17 @@ static DRIVER_ATTR(call, 0200, NULL, cal
 /* Breakpoint callbacks */
 static void bptest_triggered(struct hw_breakpoint *bp, struct pt_regs *regs)
 {
-	printk(KERN_INFO "Breakpoint %d triggered\n", bp - bps);
+	printk(KERN_INFO "Breakpoint %d triggered\n", (int) (bp - bps));
 }
 
 static void bptest_installed(struct hw_breakpoint *bp)
 {
-	printk(KERN_INFO "Breakpoint %d installed\n", bp - bps);
+	printk(KERN_INFO "Breakpoint %d installed\n", (int) (bp - bps));
 }
 
 static void bptest_uninstalled(struct hw_breakpoint *bp)
 {
-	printk(KERN_INFO "Breakpoint %d uninstalled\n", bp - bps);
+	printk(KERN_INFO "Breakpoint %d uninstalled\n", (int) (bp - bps));
 }
 
 
@@ -204,7 +204,7 @@ static ssize_t bp_show(int n, char *buf)
 
 	a = -1;
 	if (type == 'e') {
-		const void *addr = hw_breakpoint_get_kaddr(bp);
+		const void *addr = hw_breakpoint_get_kaddress(bp);
 
 		if (addr == r0)
 			a = 0;
@@ -215,7 +215,7 @@ static ssize_t bp_show(int n, char *buf)
 		else if (addr == r3)
 			a = 3;
 	} else {
-		const unsigned char *p = hw_breakpoint_get_kaddr(bp);
+		const unsigned char *p = hw_breakpoint_get_kaddress(bp);
 
 		if (p >= bytes && p < bytes + NUM_BYTES)
 			a = p - bytes;
@@ -233,6 +233,7 @@ static ssize_t bp_store(int n, const cha
 	char atype;
 	unsigned len, type;
 	int i;
+	void *addr;
 
 	if (count <= 1) {
 		printk(KERN_INFO "bptest: bp%d: format:  priority type "
@@ -290,7 +291,7 @@ static ssize_t bp_store(int n, const cha
 		return -EINVAL;
 	}
 	if (atype == 'e')
-		hw_breakpoint_kinit(bp, rtns[a], len, type);
+		addr = rtns[a];
 	else {
 		switch (alen) {
 #ifdef HW_BREAKPOINT_LEN_1
@@ -311,14 +312,14 @@ static ssize_t bp_store(int n, const cha
 			return -EINVAL;
 			break;
 		}
-		hw_breakpoint_kinit(bp, &bytes[a], len, type);
+		addr = &bytes[a];
 	}
 
 	bp->triggered = bptest_triggered;
 	bp->installed = bptest_installed;
 	bp->uninstalled = bptest_uninstalled;
 
-	i = register_kernel_hw_breakpoint(bp);
+	i = register_kernel_hw_breakpoint(bp, addr, len, type);
 	if (i < 0) {
 		printk(KERN_WARNING "bptest: bp%d: failed to register %d\n",
 				n, i);

--W4OEqKSvhl
Content-Type: text/plain
Content-Description: hw-breakpoint port to x86-64
Content-Disposition: inline;
	filename="hw-breakpoint-x86_64.patch"
Content-Transfer-Encoding: 7bit

---
 arch/i386/kernel/hw_breakpoint.c   |    5 --
 arch/x86_64/ia32/ia32_aout.c       |   10 ----
 arch/x86_64/ia32/ptrace32.c        |   65 ++++----------------------------
 arch/x86_64/kernel/Makefile        |    3 +
 arch/x86_64/kernel/kprobes.c       |   14 +++++-
 arch/x86_64/kernel/machine_kexec.c |    2 
 arch/x86_64/kernel/process.c       |   46 +++++++++++-----------
 arch/x86_64/kernel/ptrace.c        |   72 +++++------------------------------
 arch/x86_64/kernel/signal.c        |    8 ---
 arch/x86_64/kernel/smpboot.c       |    4 +
 arch/x86_64/kernel/suspend.c       |   17 +-------
 arch/x86_64/kernel/traps.c         |   75 +++++++++++++------------------------
 include/asm-x86_64/debugreg.h      |   30 ++++++++++++++
 include/asm-x86_64/hw_breakpoint.h |   50 ++++++++++++++++++++++++
 include/asm-x86_64/processor.h     |   10 +---
 include/asm-x86_64/suspend.h       |    3 -
 16 files changed, 184 insertions(+), 230 deletions(-)

Index: b/arch/x86_64/kernel/kprobes.c
===================================================================
--- a/arch/x86_64/kernel/kprobes.c
+++ b/arch/x86_64/kernel/kprobes.c
@@ -42,6 +42,7 @@
 #include <asm/cacheflush.h>
 #include <asm/pgtable.h>
 #include <asm/uaccess.h>
+#include <asm/debugreg.h>
 
 void jprobe_return_end(void);
 static void __kprobes arch_copy_kprobe(struct kprobe *p);
@@ -652,8 +653,17 @@ int __kprobes kprobe_exceptions_notify(s
 			ret = NOTIFY_STOP;
 		break;
 	case DIE_DEBUG:
-		if (post_kprobe_handler(args->regs))
-			ret = NOTIFY_STOP;
+		/*
+		 * The DR6 value is stored in args->err.
+		 * If DR_STEP is set and it's ours, we should clear DR_STEP
+		 * from the user's virtualized DR6 register.
+		 * Then if no more bits are set we should eat this exception.
+		 */
+		if ((args->err & DR_STEP) && post_kprobe_handler(args->regs)) {
+			current->thread.vdr6 &= ~DR_STEP;
+			if ((args->err & ~DR_STEP) == 0)
+				ret = NOTIFY_STOP;
+		}
 		break;
 	case DIE_GPF:
 	case DIE_PAGE_FAULT:
Index: b/include/asm-x86_64/hw_breakpoint.h
===================================================================
--- /dev/null
+++ b/include/asm-x86_64/hw_breakpoint.h
@@ -0,0 +1,50 @@
+#ifndef	_X86_64_HW_BREAKPOINT_H
+#define	_X86_64_HW_BREAKPOINT_H
+
+#ifdef	__KERNEL__
+#define	__ARCH_HW_BREAKPOINT_H
+
+struct arch_hw_breakpoint {
+	unsigned long	address;
+	u8		len;
+	u8		type;
+} __attribute__((packed));
+
+#include <asm-generic/hw_breakpoint.h>
+
+/* HW breakpoint accessor routines */
+static inline const void *hw_breakpoint_get_kaddress(struct hw_breakpoint *bp)
+{
+	return (const void *) bp->info.address;
+}
+
+static inline const void __user *hw_breakpoint_get_uaddress(
+		struct hw_breakpoint *bp)
+{
+	return (const void __user *) bp->info.address;
+}
+
+static inline unsigned hw_breakpoint_get_len(struct hw_breakpoint *bp)
+{
+	return bp->info.len;
+}
+
+static inline unsigned hw_breakpoint_get_type(struct hw_breakpoint *bp)
+{
+	return bp->info.type;
+}
+
+/* Available HW breakpoint length encodings */
+#define HW_BREAKPOINT_LEN_1		0x40
+#define HW_BREAKPOINT_LEN_2		0x44
+#define HW_BREAKPOINT_LEN_4		0x4c
+#define HW_BREAKPOINT_LEN_8		0x48
+#define HW_BREAKPOINT_LEN_EXECUTE	0x40
+
+/* Available HW breakpoint type encodings */
+#define HW_BREAKPOINT_EXECUTE	0x80	/* trigger on instruction execute */
+#define HW_BREAKPOINT_WRITE	0x81	/* trigger on memory write */
+#define HW_BREAKPOINT_RW	0x83	/* trigger on memory read or write */
+
+#endif	/* __KERNEL__ */
+#endif	/* _X86_64_HW_BREAKPOINT_H */
Index: b/include/asm-x86_64/debugreg.h
===================================================================
--- a/include/asm-x86_64/debugreg.h
+++ b/include/asm-x86_64/debugreg.h
@@ -49,6 +49,8 @@
 
 #define DR_LOCAL_ENABLE_SHIFT 0    /* Extra shift to the local enable bit */
 #define DR_GLOBAL_ENABLE_SHIFT 1   /* Extra shift to the global enable bit */
+#define DR_LOCAL_ENABLE (0x1)      /* Local enable for reg 0 */
+#define DR_GLOBAL_ENABLE (0x2)     /* Global enable for reg 0 */
 #define DR_ENABLE_SIZE 2           /* 2 enable bits per register */
 
 #define DR_LOCAL_ENABLE_MASK (0x55)  /* Set  local bits for all 4 regs */
@@ -62,4 +64,32 @@
 #define DR_LOCAL_SLOWDOWN (0x100)   /* Local slow the pipeline */
 #define DR_GLOBAL_SLOWDOWN (0x200)  /* Global slow the pipeline */
 
+
+/*
+ * HW breakpoint additions
+ */
+#ifdef __KERNEL__
+
+#define HB_NUM		4	/* Number of hardware breakpoints */
+
+/* For process management */
+void flush_thread_hw_breakpoint(struct task_struct *tsk);
+int copy_thread_hw_breakpoint(struct task_struct *tsk,
+		struct task_struct *child, unsigned long clone_flags);
+void dump_thread_hw_breakpoint(struct task_struct *tsk, int u_debugreg[8]);
+void switch_to_thread_hw_breakpoint(struct task_struct *tsk);
+
+/* For CPU management */
+void load_debug_registers(void);
+static inline void disable_debug_registers(void)
+{
+	set_debugreg(0UL, 7);
+}
+
+/* For use by ptrace */
+unsigned long thread_get_debugreg(struct task_struct *tsk, int n);
+int thread_set_debugreg(struct task_struct *tsk, int n, unsigned long val);
+
+#endif	/* __KERNEL__ */
+
 #endif
Index: b/arch/x86_64/ia32/ia32_aout.c
===================================================================
--- a/arch/x86_64/ia32/ia32_aout.c
+++ b/arch/x86_64/ia32/ia32_aout.c
@@ -32,6 +32,7 @@
 #include <asm/cacheflush.h>
 #include <asm/user32.h>
 #include <asm/ia32.h>
+#include <asm/debugreg.h>
 
 #undef WARN_OLD
 #undef CORE_DUMP /* probably broken */
@@ -57,14 +58,7 @@ static void dump_thread32(struct pt_regs
 	dump->u_dsize = ((unsigned long) (current->mm->brk + (PAGE_SIZE-1))) >> PAGE_SHIFT;
 	dump->u_dsize -= dump->u_tsize;
 	dump->u_ssize = 0;
-	dump->u_debugreg[0] = current->thread.debugreg0;  
-	dump->u_debugreg[1] = current->thread.debugreg1;  
-	dump->u_debugreg[2] = current->thread.debugreg2;  
-	dump->u_debugreg[3] = current->thread.debugreg3;  
-	dump->u_debugreg[4] = 0;  
-	dump->u_debugreg[5] = 0;  
-	dump->u_debugreg[6] = current->thread.debugreg6;  
-	dump->u_debugreg[7] = current->thread.debugreg7;  
+	dump_thread_hw_breakpoint(current, dump->u_debugreg);
 
 	if (dump->start_stack < 0xc0000000)
 		dump->u_ssize = ((unsigned long) (0xc0000000 - dump->start_stack)) >> PAGE_SHIFT;
Index: b/arch/x86_64/ia32/ptrace32.c
===================================================================
--- a/arch/x86_64/ia32/ptrace32.c
+++ b/arch/x86_64/ia32/ptrace32.c
@@ -39,7 +39,6 @@
 
 static int putreg32(struct task_struct *child, unsigned regno, u32 val)
 {
-	int i;
 	__u64 *stack = (__u64 *)task_pt_regs(child);
 
 	switch (regno) {
@@ -85,43 +84,11 @@ static int putreg32(struct task_struct *
 		break;
 	}
 
-	case offsetof(struct user32, u_debugreg[4]): 
-	case offsetof(struct user32, u_debugreg[5]):
-		return -EIO;
-
-	case offsetof(struct user32, u_debugreg[0]):
-		child->thread.debugreg0 = val;
-		break;
-
-	case offsetof(struct user32, u_debugreg[1]):
-		child->thread.debugreg1 = val;
-		break;
-
-	case offsetof(struct user32, u_debugreg[2]):
-		child->thread.debugreg2 = val;
-		break;
-
-	case offsetof(struct user32, u_debugreg[3]):
-		child->thread.debugreg3 = val;
-		break;
-
-	case offsetof(struct user32, u_debugreg[6]):
-		child->thread.debugreg6 = val;
-		break; 
-
-	case offsetof(struct user32, u_debugreg[7]):
-		val &= ~DR_CONTROL_RESERVED;
-		/* See arch/i386/kernel/ptrace.c for an explanation of
-		 * this awkward check.*/
-		for(i=0; i<4; i++)
-			if ((0x5454 >> ((val >> (16 + 4*i)) & 0xf)) & 1)
-			       return -EIO;
-		child->thread.debugreg7 = val; 
-		if (val)
-			set_tsk_thread_flag(child, TIF_DEBUG);
-		else
-			clear_tsk_thread_flag(child, TIF_DEBUG);
-		break; 
+	case offsetof(struct user32, u_debugreg[0])
+		... offsetof(struct user32, u_debugreg[7]):
+		regno -= offsetof(struct user32, u_debugreg[0]);
+		regno >>= 2;
+		return thread_set_debugreg(child, regno, val);
 		    
 	default:
 		if (regno > sizeof(struct user32) || (regno & 3))
@@ -170,23 +137,11 @@ static int getreg32(struct task_struct *
 	R32(eflags, eflags);
 	R32(esp, rsp);
 
-	case offsetof(struct user32, u_debugreg[0]): 
-		*val = child->thread.debugreg0; 
-		break; 
-	case offsetof(struct user32, u_debugreg[1]): 
-		*val = child->thread.debugreg1; 
-		break; 
-	case offsetof(struct user32, u_debugreg[2]): 
-		*val = child->thread.debugreg2; 
-		break; 
-	case offsetof(struct user32, u_debugreg[3]): 
-		*val = child->thread.debugreg3; 
-		break; 
-	case offsetof(struct user32, u_debugreg[6]): 
-		*val = child->thread.debugreg6; 
-		break; 
-	case offsetof(struct user32, u_debugreg[7]): 
-		*val = child->thread.debugreg7; 
+	case offsetof(struct user32, u_debugreg[0])
+		... offsetof(struct user32, u_debugreg[7]):
+		regno -= offsetof(struct user32, u_debugreg[0]);
+		regno >>= 2;
+		*val = thread_get_debugreg(child, regno);
 		break; 
 		    
 	default:
Index: b/arch/x86_64/kernel/Makefile
===================================================================
--- a/arch/x86_64/kernel/Makefile
+++ b/arch/x86_64/kernel/Makefile
@@ -61,3 +61,6 @@ msr-$(subst m,y,$(CONFIG_X86_MSR))  += .
 alternative-y			+= ../../i386/kernel/alternative.o
 pcspeaker-y			+= ../../i386/kernel/pcspeaker.o
 perfctr-watchdog-y		+= ../../i386/kernel/cpu/perfctr-watchdog.o
+
+obj-y				+= hw_breakpoint.o
+hw_breakpoint-y			+= ../../i386/kernel/hw_breakpoint.o
Index: b/arch/x86_64/kernel/machine_kexec.c
===================================================================
--- a/arch/x86_64/kernel/machine_kexec.c
+++ b/arch/x86_64/kernel/machine_kexec.c
@@ -14,6 +14,7 @@
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
 #include <asm/io.h>
+#include <asm/debugreg.h>
 
 #define PAGE_ALIGNED __attribute__ ((__aligned__(PAGE_SIZE)))
 static u64 kexec_pgd[512] PAGE_ALIGNED;
@@ -185,6 +186,7 @@ NORET_TYPE void machine_kexec(struct kim
 
 	/* Interrupts aren't acceptable while we reboot */
 	local_irq_disable();
+	disable_debug_registers();
 
 	control_page = page_address(image->control_code_page) + PAGE_SIZE;
 	memcpy(control_page, relocate_kernel, PAGE_SIZE);
Index: b/arch/x86_64/kernel/process.c
===================================================================
--- a/arch/x86_64/kernel/process.c
+++ b/arch/x86_64/kernel/process.c
@@ -51,6 +51,7 @@
 #include <asm/proto.h>
 #include <asm/ia32.h>
 #include <asm/idle.h>
+#include <asm/debugreg.h>
 
 asmlinkage extern void ret_from_fork(void);
 
@@ -379,6 +380,9 @@ void exit_thread(void)
 		t->io_bitmap_max = 0;
 		put_cpu();
 	}
+
+	if (unlikely(me->thread.hw_breakpoint_info))
+		flush_thread_hw_breakpoint(me);
 }
 
 void flush_thread(void)
@@ -394,14 +398,10 @@ void flush_thread(void)
 			current_thread_info()->status |= TS_COMPAT;
 		}
 	}
-	clear_tsk_thread_flag(tsk, TIF_DEBUG);
 
-	tsk->thread.debugreg0 = 0;
-	tsk->thread.debugreg1 = 0;
-	tsk->thread.debugreg2 = 0;
-	tsk->thread.debugreg3 = 0;
-	tsk->thread.debugreg6 = 0;
-	tsk->thread.debugreg7 = 0;
+	if (unlikely(tsk->thread.hw_breakpoint_info))
+		flush_thread_hw_breakpoint(tsk);
+
 	memset(tsk->thread.tls_array, 0, sizeof(tsk->thread.tls_array));	
 	/*
 	 * Forget coprocessor state..
@@ -487,6 +487,14 @@ int copy_thread(int nr, unsigned long cl
 	asm("mov %%es,%0" : "=m" (p->thread.es));
 	asm("mov %%ds,%0" : "=m" (p->thread.ds));
 
+	p->thread.hw_breakpoint_info = NULL;
+	p->thread.io_bitmap_ptr = NULL;
+
+	err = -ENOMEM;
+	if (unlikely(me->thread.hw_breakpoint_info) &&
+	    copy_thread_hw_breakpoint(me, p, clone_flags))
+		goto out;
+
 	if (unlikely(test_tsk_thread_flag(me, TIF_IO_BITMAP))) {
 		p->thread.io_bitmap_ptr = kmalloc(IO_BITMAP_BYTES, GFP_KERNEL);
 		if (!p->thread.io_bitmap_ptr) {
@@ -513,6 +521,8 @@ int copy_thread(int nr, unsigned long cl
 	}
 	err = 0;
 out:
+	if (err)
+		flush_thread_hw_breakpoint(p);
 	if (err && p->thread.io_bitmap_ptr) {
 		kfree(p->thread.io_bitmap_ptr);
 		p->thread.io_bitmap_max = 0;
@@ -520,11 +530,6 @@ out:
 	return err;
 }
 
-/*
- * This special macro can be used to load a debugging register
- */
-#define loaddebug(thread,r) set_debugreg(thread->debugreg ## r, r)
-
 static inline void __switch_to_xtra(struct task_struct *prev_p,
 			     	    struct task_struct *next_p,
 			     	    struct tss_struct *tss)
@@ -534,16 +539,6 @@ static inline void __switch_to_xtra(stru
 	prev = &prev_p->thread,
 	next = &next_p->thread;
 
-	if (test_tsk_thread_flag(next_p, TIF_DEBUG)) {
-		loaddebug(next, 0);
-		loaddebug(next, 1);
-		loaddebug(next, 2);
-		loaddebug(next, 3);
-		/* no 4 and 5 */
-		loaddebug(next, 6);
-		loaddebug(next, 7);
-	}
-
 	if (test_tsk_thread_flag(next_p, TIF_IO_BITMAP)) {
 		/*
 		 * Copy the relevant range of the IO bitmap.
@@ -557,6 +552,13 @@ static inline void __switch_to_xtra(stru
 		 */
 		memset(tss->io_bitmap, 0xff, prev->io_bitmap_max);
 	}
+
+	/*
+	 * Handle debug registers.  This must be done _after_ current
+	 * is updated.
+	 */
+	if (unlikely(test_tsk_thread_flag(next_p, TIF_DEBUG)))
+		switch_to_thread_hw_breakpoint(next_p);
 }
 
 /*
Index: b/arch/x86_64/kernel/ptrace.c
===================================================================
--- a/arch/x86_64/kernel/ptrace.c
+++ b/arch/x86_64/kernel/ptrace.c
@@ -307,7 +307,7 @@ static unsigned long getreg(struct task_
 
 long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 {
-	long i, ret;
+	long ret;
 	unsigned ui;
 
 	switch (request) {
@@ -338,23 +338,11 @@ long arch_ptrace(struct task_struct *chi
 		case 0 ... sizeof(struct user_regs_struct) - sizeof(long):
 			tmp = getreg(child, addr);
 			break;
-		case offsetof(struct user, u_debugreg[0]):
-			tmp = child->thread.debugreg0;
-			break;
-		case offsetof(struct user, u_debugreg[1]):
-			tmp = child->thread.debugreg1;
-			break;
-		case offsetof(struct user, u_debugreg[2]):
-			tmp = child->thread.debugreg2;
-			break;
-		case offsetof(struct user, u_debugreg[3]):
-			tmp = child->thread.debugreg3;
-			break;
-		case offsetof(struct user, u_debugreg[6]):
-			tmp = child->thread.debugreg6;
-			break;
-		case offsetof(struct user, u_debugreg[7]):
-			tmp = child->thread.debugreg7;
+		case offsetof(struct user, u_debugreg[0])
+			... offsetof(struct user, u_debugreg[7]):
+			addr -= offsetof(struct user, u_debugreg[0]);
+			addr >>= 3;
+			tmp = thread_get_debugreg(child, addr);
 			break;
 		default:
 			tmp = 0;
@@ -375,7 +363,6 @@ long arch_ptrace(struct task_struct *chi
 
 	case PTRACE_POKEUSR: /* write the word at location addr in the USER area */
 	{
-		int dsize = test_tsk_thread_flag(child, TIF_IA32) ? 3 : 7;
 		ret = -EIO;
 		if ((addr & 7) ||
 		    addr > sizeof(struct user) - 7)
@@ -385,49 +372,12 @@ long arch_ptrace(struct task_struct *chi
 		case 0 ... sizeof(struct user_regs_struct) - sizeof(long):
 			ret = putreg(child, addr, data);
 			break;
-		/* Disallows to set a breakpoint into the vsyscall */
-		case offsetof(struct user, u_debugreg[0]):
-			if (data >= TASK_SIZE_OF(child) - dsize) break;
-			child->thread.debugreg0 = data;
-			ret = 0;
-			break;
-		case offsetof(struct user, u_debugreg[1]):
-			if (data >= TASK_SIZE_OF(child) - dsize) break;
-			child->thread.debugreg1 = data;
-			ret = 0;
-			break;
-		case offsetof(struct user, u_debugreg[2]):
-			if (data >= TASK_SIZE_OF(child) - dsize) break;
-			child->thread.debugreg2 = data;
-			ret = 0;
-			break;
-		case offsetof(struct user, u_debugreg[3]):
-			if (data >= TASK_SIZE_OF(child) - dsize) break;
-			child->thread.debugreg3 = data;
-			ret = 0;
-			break;
-		case offsetof(struct user, u_debugreg[6]):
-				  if (data >> 32)
-				break; 
-			child->thread.debugreg6 = data;
-			ret = 0;
+		case offsetof(struct user, u_debugreg[0])
+			... offsetof(struct user, u_debugreg[7]):
+			addr -= offsetof(struct user, u_debugreg[0]);
+			addr >>= 3;
+			ret = thread_set_debugreg(child, addr, data);
 			break;
-		case offsetof(struct user, u_debugreg[7]):
-			/* See arch/i386/kernel/ptrace.c for an explanation of
-			 * this awkward check.*/
-			data &= ~DR_CONTROL_RESERVED;
-			for(i=0; i<4; i++)
-				if ((0x5554 >> ((data >> (16 + 4*i)) & 0xf)) & 1)
-					break;
-			if (i == 4) {
-			  child->thread.debugreg7 = data;
-			  if (data)
-			  	set_tsk_thread_flag(child, TIF_DEBUG);
-			  else
-			  	clear_tsk_thread_flag(child, TIF_DEBUG);
-			  ret = 0;
-		  	}
-		  break;
 		}
 		break;
 	}
Index: b/arch/x86_64/kernel/signal.c
===================================================================
--- a/arch/x86_64/kernel/signal.c
+++ b/arch/x86_64/kernel/signal.c
@@ -411,14 +411,6 @@ static void do_signal(struct pt_regs *re
 
 	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
 	if (signr > 0) {
-		/* Reenable any watchpoints before delivering the
-		 * signal to user space. The processor register will
-		 * have been cleared if the watchpoint triggered
-		 * inside the kernel.
-		 */
-		if (current->thread.debugreg7)
-			set_debugreg(current->thread.debugreg7, 7);
-
 		/* Whee!  Actually deliver the signal.  */
 		if (handle_signal(signr, &info, &ka, oldset, regs) == 0) {
 			/* a signal was successfully delivered; the saved
Index: b/arch/x86_64/kernel/smpboot.c
===================================================================
--- a/arch/x86_64/kernel/smpboot.c
+++ b/arch/x86_64/kernel/smpboot.c
@@ -59,6 +59,7 @@
 #include <asm/irq.h>
 #include <asm/hw_irq.h>
 #include <asm/numa.h>
+#include <asm/debugreg.h>
 
 /* Number of siblings per CPU package */
 int smp_num_siblings = 1;
@@ -378,6 +379,8 @@ void __cpuinit start_secondary(void)
 
 	unlock_ipi_call_lock();
 
+	load_debug_registers();
+
 	cpu_idle();
 }
 
@@ -1043,6 +1046,7 @@ int __cpu_disable(void)
 	spin_unlock(&vector_lock);
 	remove_cpu_from_maps();
 	fixup_irqs(cpu_online_map);
+	disable_debug_registers();
 	return 0;
 }
 
Index: b/arch/x86_64/kernel/suspend.c
===================================================================
--- a/arch/x86_64/kernel/suspend.c
+++ b/arch/x86_64/kernel/suspend.c
@@ -13,6 +13,7 @@
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/mtrr.h>
+#include <asm/debugreg.h>
 
 /* References to section boundaries */
 extern const void __nosave_begin, __nosave_end;
@@ -60,6 +61,8 @@ void __save_processor_state(struct saved
 	asm volatile ("movq %%cr3, %0" : "=r" (ctxt->cr3));
 	asm volatile ("movq %%cr4, %0" : "=r" (ctxt->cr4));
 	asm volatile ("movq %%cr8, %0" : "=r" (ctxt->cr8));
+
+	disable_debug_registers();
 }
 
 void save_processor_state(void)
@@ -131,19 +134,7 @@ void fix_processor_context(void)
 	load_TR_desc();				/* This does ltr */
 	load_LDT(&current->active_mm->context);	/* This does lldt */
 
-	/*
-	 * Now maybe reload the debug registers
-	 */
-	if (current->thread.debugreg7){
-                loaddebug(&current->thread, 0);
-                loaddebug(&current->thread, 1);
-                loaddebug(&current->thread, 2);
-                loaddebug(&current->thread, 3);
-                /* no 4 and 5 */
-                loaddebug(&current->thread, 6);
-                loaddebug(&current->thread, 7);
-	}
-
+	load_debug_registers();
 }
 
 #ifdef CONFIG_SOFTWARE_SUSPEND
Index: b/arch/x86_64/kernel/traps.c
===================================================================
--- a/arch/x86_64/kernel/traps.c
+++ b/arch/x86_64/kernel/traps.c
@@ -829,67 +829,46 @@ asmlinkage __kprobes struct pt_regs *syn
 asmlinkage void __kprobes do_debug(struct pt_regs * regs,
 				   unsigned long error_code)
 {
-	unsigned long condition;
+	unsigned long dr6;
 	struct task_struct *tsk = current;
 	siginfo_t info;
 
-	get_debugreg(condition, 6);
+	get_debugreg(dr6, 6);
+	set_debugreg(0UL, 6);	/* DR6 may or may not be cleared by the CPU */
 
-	if (notify_die(DIE_DEBUG, "debug", regs, condition, error_code,
+	/* Store the virtualized DR6 value */
+	tsk->thread.vdr6 = dr6;
+
+	if (notify_die(DIE_DEBUG, "debug", regs, dr6, error_code,
 						SIGTRAP) == NOTIFY_STOP)
 		return;
 
 	preempt_conditional_sti(regs);
 
-	/* Mask out spurious debug traps due to lazy DR7 setting */
-	if (condition & (DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3)) {
-		if (!tsk->thread.debugreg7) { 
-			goto clear_dr7;
-		}
+	/*
+	 * Single-stepping through system calls: ignore any exceptions in
+	 * kernel space, but re-enable TF when returning to user mode.
+	 *
+	 * We already checked v86 mode above, so we can check for kernel mode
+	 * by just checking the CPL of CS.
+	 */
+	if ((dr6 & DR_STEP) && !user_mode(regs)) {
+		tsk->thread.vdr6 &= ~DR_STEP;
+		set_tsk_thread_flag(tsk, TIF_SINGLESTEP);
+		regs->eflags &= ~X86_EFLAGS_TF;
 	}
 
-	tsk->thread.debugreg6 = condition;
-
-	/* Mask out spurious TF errors due to lazy TF clearing */
-	if (condition & DR_STEP) {
-		/*
-		 * The TF error should be masked out only if the current
-		 * process is not traced and if the TRAP flag has been set
-		 * previously by a tracing process (condition detected by
-		 * the PT_DTRACE flag); remember that the i386 TRAP flag
-		 * can be modified by the process itself in user mode,
-		 * allowing programs to debug themselves without the ptrace()
-		 * interface.
-		 */
-                if (!user_mode(regs))
-                       goto clear_TF_reenable;
-		/*
-		 * Was the TF flag set by a debugger? If so, clear it now,
-		 * so that register information is correct.
-		 */
-		if (tsk->ptrace & PT_DTRACE) {
-			regs->eflags &= ~TF_MASK;
-			tsk->ptrace &= ~PT_DTRACE;
-		}
+	if (tsk->thread.vdr6 & (DR_STEP|DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3)) {
+		/* Ok, finally something we can handle */
+		tsk->thread.trap_no = 1;
+		tsk->thread.error_code = error_code;
+		info.si_signo = SIGTRAP;
+		info.si_errno = 0;
+		info.si_code = TRAP_BRKPT;
+		info.si_addr = user_mode(regs) ? (void __user *)regs->rip : NULL;
+		force_sig_info(SIGTRAP, &info, tsk);
 	}
 
-	/* Ok, finally something we can handle */
-	tsk->thread.trap_no = 1;
-	tsk->thread.error_code = error_code;
-	info.si_signo = SIGTRAP;
-	info.si_errno = 0;
-	info.si_code = TRAP_BRKPT;
-	info.si_addr = user_mode(regs) ? (void __user *)regs->rip : NULL;
-	force_sig_info(SIGTRAP, &info, tsk);
-
-clear_dr7:
-	set_debugreg(0UL, 7);
-	preempt_conditional_cli(regs);
-	return;
-
-clear_TF_reenable:
-	set_tsk_thread_flag(tsk, TIF_SINGLESTEP);
-	regs->eflags &= ~TF_MASK;
 	preempt_conditional_cli(regs);
 }
 
Index: b/include/asm-x86_64/processor.h
===================================================================
--- a/include/asm-x86_64/processor.h
+++ b/include/asm-x86_64/processor.h
@@ -221,13 +221,9 @@ struct thread_struct {
 	unsigned long	fs;
 	unsigned long	gs;
 	unsigned short	es, ds, fsindex, gsindex;	
-/* Hardware debugging registers */
-	unsigned long	debugreg0;  
-	unsigned long	debugreg1;  
-	unsigned long	debugreg2;  
-	unsigned long	debugreg3;  
-	unsigned long	debugreg6;  
-	unsigned long	debugreg7;  
+/* Hardware breakpoint info */
+	unsigned long	vdr6;
+	struct thread_hw_breakpoint	*hw_breakpoint_info;
 /* fault info */
 	unsigned long	cr2, trap_no, error_code;
 /* floating point info */
Index: b/include/asm-x86_64/suspend.h
===================================================================
--- a/include/asm-x86_64/suspend.h
+++ b/include/asm-x86_64/suspend.h
@@ -39,9 +39,6 @@ extern unsigned long saved_context_r08, 
 extern unsigned long saved_context_r12, saved_context_r13, saved_context_r14, saved_context_r15;
 extern unsigned long saved_context_eflags;
 
-#define loaddebug(thread,register) \
-	set_debugreg((thread)->debugreg##register, register)
-
 extern void fix_processor_context(void);
 
 #ifdef CONFIG_ACPI_SLEEP
Index: b/arch/i386/kernel/hw_breakpoint.c
===================================================================
--- a/arch/i386/kernel/hw_breakpoint.c
+++ b/arch/i386/kernel/hw_breakpoint.c
@@ -128,7 +128,7 @@ static void arch_install_chbi(struct cpu
 	struct hw_breakpoint **bps;
 
 	/* Don't allow debug exceptions while we update the registers */
-	set_debugreg(0, 7);
+	set_debugreg(0UL, 7);
 	chbi->cur_kbpdata = rcu_dereference(cur_kbpdata);
 
 	/* Kernel breakpoints are stored starting in DR0 and going up */
@@ -391,7 +391,6 @@ static void ptrace_triggered(struct hw_b
 	if (thbi) {
 		i = bp - thbi->vdr_bps;
 		tsk->thread.vdr6 |= (DR_TRAP0 << i);
-		send_sigtrap(tsk, regs, 0);
 	}
 }
 
@@ -588,7 +587,7 @@ static int __kprobes hw_breakpoint_handl
 	/* Disable all breakpoints so that the callbacks can run without
 	 * triggering recursive debug exceptions.
 	 */
-	set_debugreg(0, 7);
+	set_debugreg(0UL, 7);
 
 	/* Handle all the breakpoints that were triggered */
 	for (i = 0; i < HB_NUM; ++i) {

--W4OEqKSvhl--
