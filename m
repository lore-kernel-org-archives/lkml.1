Return-Path: <linux-kernel-owner+w=401wt.eu-S1759068AbYACEF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759068AbYACEF3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 23:05:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754150AbYACEFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 23:05:21 -0500
Received: from an-out-0708.google.com ([209.85.132.248]:43805 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910AbYACEFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 23:05:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=hMiZuPdKMQSJ2fxCx4r44VNAsO1Jv4a4jwHltbklj6ajgI4rPXOweI0sRgf8oDMrzaS7+3C9XwmmYjxlkqs08xJCqrRZkhGOlnse+lVIjrsTCo7oQzQy4yG4pDYmXFjEcBi7LXw0N7cOLa9xrB6VvnpdlLQys5KkuCqxpja9TYQ=
Subject: [PATCH] kprobes: Introduce is_kprobe_fault()
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 02 Jan 2008 20:05:14 -0800
Message-Id: <1199333115.6323.104.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a central is_kprobe_fault() inline in kprobes.h to remove all
of the arch-dependant, practically identical implementations in
avr32, ia64, powerpc, s390, sparc64, and x86.

avr32 was the only arch without the preempt_disable/enable pair
in its notify_page_fault implementation.  This should be checked
by avr32 people.

This uncovered a possible bug in the s390 version as that purely
copied the x86 version unconditionally passing 14 as the trapnr
rather than the error_code parameter.  This has been preserved
in this patch, s390 people should check if error_code really was
intended.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Andrew, this came up when discussing some x86 fault unification
work, figured you were the right person to feed this through.

At least the diffstat says I did something right.  Patch against
current Linus tree.

 arch/avr32/mm/fault.c   |   21 +--------------------
 arch/ia64/mm/fault.c    |   24 +-----------------------
 arch/powerpc/mm/fault.c |   25 +------------------------
 arch/s390/mm/fault.c    |   25 +------------------------
 arch/sparc64/mm/fault.c |   23 +----------------------
 arch/x86/mm/fault_32.c  |   26 ++------------------------
 arch/x86/mm/fault_64.c  |   26 ++------------------------
 include/linux/kprobes.h |   19 +++++++++++++++++++
 8 files changed, 28 insertions(+), 161 deletions(-)

diff --git a/arch/avr32/mm/fault.c b/arch/avr32/mm/fault.c
index 6560cb1..a95cce2 100644
--- a/arch/avr32/mm/fault.c
+++ b/arch/avr32/mm/fault.c
@@ -20,25 +20,6 @@
 #include <asm/tlb.h>
 #include <asm/uaccess.h>
 
-#ifdef CONFIG_KPROBES
-static inline int notify_page_fault(struct pt_regs *regs, int trap)
-{
-	int ret = 0;
-
-	if (!user_mode(regs)) {
-		if (kprobe_running() && kprobe_fault_handler(regs, trap))
-			ret = 1;
-	}
-
-	return ret;
-}
-#else
-static inline int notify_page_fault(struct pt_regs *regs, int trap)
-{
-	return 0;
-}
-#endif
-
 int exception_trace = 1;
 
 /*
@@ -66,7 +47,7 @@ asmlinkage void do_page_fault(unsigned long ecr, struct pt_regs *regs)
 	int code;
 	int fault;
 
-	if (notify_page_fault(regs, ecr))
+	if (is_kprobe_fault(regs, ecr))
 		return;
 
 	address = sysreg_read(TLBEAR);
diff --git a/arch/ia64/mm/fault.c b/arch/ia64/mm/fault.c
index 7571076..1696805 100644
--- a/arch/ia64/mm/fault.c
+++ b/arch/ia64/mm/fault.c
@@ -18,28 +18,6 @@
 
 extern void die (char *, struct pt_regs *, long);
 
-#ifdef CONFIG_KPROBES
-static inline int notify_page_fault(struct pt_regs *regs, int trap)
-{
-	int ret = 0;
-
-	if (!user_mode(regs)) {
-		/* kprobe_running() needs smp_processor_id() */
-		preempt_disable();
-		if (kprobe_running() && kprobes_fault_handler(regs, trap))
-			ret = 1;
-		preempt_enable();
-	}
-
-	return ret;
-}
-#else
-static inline int notify_page_fault(struct pt_regs *regs, int trap)
-{
-	return 0;
-}
-#endif
-
 /*
  * Return TRUE if ADDRESS points at a page in the kernel's mapped segment
  * (inside region 5, on ia64) and that page is present.
@@ -106,7 +84,7 @@ ia64_do_page_fault (unsigned long address, unsigned long isr, struct pt_regs *re
 	/*
 	 * This is to handle the kprobes on user space access instructions
 	 */
-	if (notify_page_fault(regs, TRAP_BRKPT))
+	if (is_kprobe_fault(regs, TRAP_BRKPT))
 		return;
 
 	down_read(&mm->mmap_sem);
diff --git a/arch/powerpc/mm/fault.c b/arch/powerpc/mm/fault.c
index 8135da0..00df6f9 100644
--- a/arch/powerpc/mm/fault.c
+++ b/arch/powerpc/mm/fault.c
@@ -39,29 +39,6 @@
 #include <asm/tlbflush.h>
 #include <asm/siginfo.h>
 
-
-#ifdef CONFIG_KPROBES
-static inline int notify_page_fault(struct pt_regs *regs)
-{
-	int ret = 0;
-
-	/* kprobe_running() needs smp_processor_id() */
-	if (!user_mode(regs)) {
-		preempt_disable();
-		if (kprobe_running() && kprobe_fault_handler(regs, 11))
-			ret = 1;
-		preempt_enable();
-	}
-
-	return ret;
-}
-#else
-static inline int notify_page_fault(struct pt_regs *regs)
-{
-	return 0;
-}
-#endif
-
 /*
  * Check whether the instruction at regs->nip is a store using
  * an update addressing form which will update r1.
@@ -164,7 +141,7 @@ int __kprobes do_page_fault(struct pt_regs *regs, unsigned long address,
 	is_write = error_code & ESR_DST;
 #endif /* CONFIG_4xx || CONFIG_BOOKE */
 
-	if (notify_page_fault(regs))
+	if (is_kprobe_fault(regs, 11))
 		return 0;
 
 	if (trap == 0x300) {
diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index 2456b52..59d3f0e 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -51,29 +51,6 @@ extern int sysctl_userprocess_debug;
 
 extern void die(const char *,struct pt_regs *,long);
 
-#ifdef CONFIG_KPROBES
-static inline int notify_page_fault(struct pt_regs *regs, long err)
-{
-	int ret = 0;
-
-	/* kprobe_running() needs smp_processor_id() */
-	if (!user_mode(regs)) {
-		preempt_disable();
-		if (kprobe_running() && kprobe_fault_handler(regs, 14))
-			ret = 1;
-		preempt_enable();
-	}
-
-	return ret;
-}
-#else
-static inline int notify_page_fault(struct pt_regs *regs, long err)
-{
-	return 0;
-}
-#endif
-
-
 /*
  * Unlock any spinlocks which will prevent us from getting the
  * message out.
@@ -309,7 +286,7 @@ do_exception(struct pt_regs *regs, unsigned long error_code, int write)
 	int si_code;
 	int fault;
 
-	if (notify_page_fault(regs, error_code))
+	if (is_kprobe_fault(regs, 14))
 		return;
 
 	tsk = current;
diff --git a/arch/sparc64/mm/fault.c b/arch/sparc64/mm/fault.c
index e2027f2..bb5c36a 100644
--- a/arch/sparc64/mm/fault.c
+++ b/arch/sparc64/mm/fault.c
@@ -31,27 +31,6 @@
 #include <asm/sections.h>
 #include <asm/mmu_context.h>
 
-#ifdef CONFIG_KPROBES
-static inline int notify_page_fault(struct pt_regs *regs)
-{
-	int ret = 0;
-
-	/* kprobe_running() needs smp_processor_id() */
-	if (!user_mode(regs)) {
-		preempt_disable();
-		if (kprobe_running() && kprobe_fault_handler(regs, 0))
-			ret = 1;
-		preempt_enable();
-	}
-	return ret;
-}
-#else
-static inline int notify_page_fault(struct pt_regs *regs)
-{
-	return 0;
-}
-#endif
-
 /*
  * To debug kernel to catch accesses to certain virtual/physical addresses.
  * Mode = 0 selects physical watchpoints, mode = 1 selects virtual watchpoints.
@@ -280,7 +259,7 @@ asmlinkage void __kprobes do_sparc64_fault(struct pt_regs *regs)
 
 	fault_code = get_thread_fault_code();
 
-	if (notify_page_fault(regs))
+	if (is_kprobe_fault(regs, 0))
 		return;
 
 	si_code = SEGV_MAPERR;
diff --git a/arch/x86/mm/fault_32.c b/arch/x86/mm/fault_32.c
index a2273d4..f2e909b 100644
--- a/arch/x86/mm/fault_32.c
+++ b/arch/x86/mm/fault_32.c
@@ -33,28 +33,6 @@
 
 extern void die(const char *,struct pt_regs *,long);
 
-#ifdef CONFIG_KPROBES
-static inline int notify_page_fault(struct pt_regs *regs)
-{
-	int ret = 0;
-
-	/* kprobe_running() needs smp_processor_id() */
-	if (!user_mode_vm(regs)) {
-		preempt_disable();
-		if (kprobe_running() && kprobe_fault_handler(regs, 14))
-			ret = 1;
-		preempt_enable();
-	}
-
-	return ret;
-}
-#else
-static inline int notify_page_fault(struct pt_regs *regs)
-{
-	return 0;
-}
-#endif
-
 /*
  * Return EIP plus the CS segment base.  The segment limit is also
  * adjusted, clamped to the kernel/user address space (whichever is
@@ -331,7 +309,7 @@ fastcall void __kprobes do_page_fault(struct pt_regs *regs,
 	if (unlikely(address >= TASK_SIZE)) {
 		if (!(error_code & 0x0000000d) && vmalloc_fault(address) >= 0)
 			return;
-		if (notify_page_fault(regs))
+		if (is_kprobe_fault(regs, 14))
 			return;
 		/*
 		 * Don't take the mm semaphore here. If we fixup a prefetch
@@ -340,7 +318,7 @@ fastcall void __kprobes do_page_fault(struct pt_regs *regs,
 		goto bad_area_nosemaphore;
 	}
 
-	if (notify_page_fault(regs))
+	if (is_kprobe_fault(regs, 14))
 		return;
 
 	/* It's safe to allow irq's after cr2 has been saved and the vmalloc
diff --git a/arch/x86/mm/fault_64.c b/arch/x86/mm/fault_64.c
index 0e26230..376e218 100644
--- a/arch/x86/mm/fault_64.c
+++ b/arch/x86/mm/fault_64.c
@@ -41,28 +41,6 @@
 #define PF_RSVD	(1<<3)
 #define PF_INSTR	(1<<4)
 
-#ifdef CONFIG_KPROBES
-static inline int notify_page_fault(struct pt_regs *regs)
-{
-	int ret = 0;
-
-	/* kprobe_running() needs smp_processor_id() */
-	if (!user_mode(regs)) {
-		preempt_disable();
-		if (kprobe_running() && kprobe_fault_handler(regs, 14))
-			ret = 1;
-		preempt_enable();
-	}
-
-	return ret;
-}
-#else
-static inline int notify_page_fault(struct pt_regs *regs)
-{
-	return 0;
-}
-#endif
-
 /* Sometimes the CPU reports invalid exceptions on prefetch.
    Check that here and ignore.
    Opcode checker based on code by Richard Brunner */
@@ -343,7 +321,7 @@ asmlinkage void __kprobes do_page_fault(struct pt_regs *regs,
 			if (vmalloc_fault(address) >= 0)
 				return;
 		}
-		if (notify_page_fault(regs))
+		if (is_kprobe_fault(regs, 14))
 			return;
 		/*
 		 * Don't take the mm semaphore here. If we fixup a prefetch
@@ -352,7 +330,7 @@ asmlinkage void __kprobes do_page_fault(struct pt_regs *regs,
 		goto bad_area_nosemaphore;
 	}
 
-	if (notify_page_fault(regs))
+	if (is_kprobe_fault(regs, 14))
 		return;
 
 	if (likely(regs->eflags & X86_EFLAGS_IF))
diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index 8189158..65c1ffb 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -36,6 +36,7 @@
 #include <linux/spinlock.h>
 #include <linux/rcupdate.h>
 #include <linux/mutex.h>
+#include <linux/hardirq.h>
 
 #ifdef CONFIG_KPROBES
 #include <asm/kprobes.h>
@@ -203,6 +204,20 @@ static inline struct kprobe *kprobe_running(void)
 	return (__get_cpu_var(current_kprobe));
 }
 
+/*
+ * If it is a kprobe pagefault we can not be premptible so return before
+ * calling kprobe_running() as it will assert on smp_processor_id if
+ * preemption is enabled.
+ */
+static inline int is_kprobe_fault(struct pt_regs *regs, int trapnr)
+{
+	if (!user_mode(regs) && !preemptible() && kprobe_running() &&
+	    kprobe_fault_handler(regs, trapnr))
+		return 1;
+	else
+		return 0;
+}
+
 static inline void reset_current_kprobe(void)
 {
 	__get_cpu_var(current_kprobe) = NULL;
@@ -237,6 +252,10 @@ static inline struct kprobe *kprobe_running(void)
 {
 	return NULL;
 }
+static inline int is_kprobe_fault(struct pt_regs *regs, int trapnr)
+{
+	return 0;
+}
 static inline int register_kprobe(struct kprobe *p)
 {
 	return -ENOSYS;
-- 
1.5.4.rc2.1097.gb6e0d



