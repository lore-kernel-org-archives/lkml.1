Return-Path: <linux-kernel-owner+w=401wt.eu-S935601AbYBCDAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935601AbYBCDAc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 22:00:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932357AbYBCDAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 22:00:18 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:4963 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950AbYBCDAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 22:00:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ov/yWQqY88QkUio/EM9j2cluDpYpoBqWzTVzJpEoNBkP/SKk+V2Pd1v/A0ckyMw7C7D8CtX4g5IFA/4SjreE9w/YhsLQsHmQID62kZtoHFwk9p6iooHdzm8z+JQUzRUOpt7EX0A2nzrXeniQ/tGUJ3fW0Fi7YaSbTuJy2iFUyzo=
Subject: [PATCH 1/2] kprobes: Introduce kprobe_handle_fault()
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 02 Feb 2008 19:00:23 -0800
Message-Id: <1202007623.1844.44.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a central kprobe_handle_fault() inline in kprobes.h to remove
all of the arch-dependant, practically identical implementations in
avr32, ia64, powerpc, s390, sparc64, and x86.

avr32 was the only arch without the preempt_disable/enable pair
in its notify_page_fault implementation.

This uncovered a possible bug in the s390 version as that purely
copied the x86 version unconditionally passing 14 as the trapnr
rather than the error_code parameter.  s390 is changed to pass
error_code in this patch.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Andrew, 1/2 is low risk, 2/2 has been tested on x86-32 and 64,
but the !preemptible invariant seems correct.

 arch/arm/mm/fault.c     |   25 +------------------------
 arch/avr32/mm/fault.c   |   21 +--------------------
 arch/ia64/mm/fault.c    |   24 +-----------------------
 arch/powerpc/mm/fault.c |   25 +------------------------
 arch/s390/mm/fault.c    |   25 +------------------------
 arch/sparc64/mm/fault.c |   23 +----------------------
 arch/x86/mm/fault.c     |   26 ++------------------------
 include/linux/kprobes.h |   20 ++++++++++++++++++++
 8 files changed, 28 insertions(+), 161 deletions(-)

diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
index 28ad7ab..5def64f 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -21,29 +21,6 @@
 
 #include "fault.h"
 
-
-#ifdef CONFIG_KPROBES
-static inline int notify_page_fault(struct pt_regs *regs, unsigned int fsr)
-{
-	int ret = 0;
-
-	if (!user_mode(regs)) {
-		/* kprobe_running() needs smp_processor_id() */
-		preempt_disable();
-		if (kprobe_running() && kprobe_fault_handler(regs, fsr))
-			ret = 1;
-		preempt_enable();
-	}
-
-	return ret;
-}
-#else
-static inline int notify_page_fault(struct pt_regs *regs, unsigned int fsr)
-{
-	return 0;
-}
-#endif
-
 /*
  * This is useful to dump out the page tables associated with
  * 'addr' in mm 'mm'.
@@ -246,7 +223,7 @@ do_page_fault(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 	struct mm_struct *mm;
 	int fault, sig, code;
 
-	if (notify_page_fault(regs, fsr))
+	if (handle_kprobe_fault(regs, fsr))
 		return 0;
 
 	tsk = current;
diff --git a/arch/avr32/mm/fault.c b/arch/avr32/mm/fault.c
index 6560cb1..e41953e 100644
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
+	if (kprobe_handle_fault(regs, ecr))
 		return;
 
 	address = sysreg_read(TLBEAR);
diff --git a/arch/ia64/mm/fault.c b/arch/ia64/mm/fault.c
index 7571076..bfc83e8 100644
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
+	if (kprobe_handle_fault(regs, TRAP_BRKPT))
 		return;
 
 	down_read(&mm->mmap_sem);
diff --git a/arch/powerpc/mm/fault.c b/arch/powerpc/mm/fault.c
index 7b25107..3246953 100644
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
+	if (kprobe_handle_fault(regs, 11))
 		return 0;
 
 	if (unlikely(debugger_fault_handler(regs)))
diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index 2456b52..5a47295 100644
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
+	if (kprobe_handle_fault(regs, error_code))
 		return;
 
 	tsk = current;
diff --git a/arch/sparc64/mm/fault.c b/arch/sparc64/mm/fault.c
index e2027f2..8467dd6 100644
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
+	if (kprobe_handle_fault(regs, 0))
 		return;
 
 	si_code = SEGV_MAPERR;
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 3fff490..f0adbb0 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -49,29 +49,6 @@
 #define PF_RSVD		(1<<3)
 #define PF_INSTR	(1<<4)
 
-static inline int notify_page_fault(struct pt_regs *regs)
-{
-#ifdef CONFIG_KPROBES
-	int ret = 0;
-
-	/* kprobe_running() needs smp_processor_id() */
-#ifdef CONFIG_X86_32
-	if (!user_mode_vm(regs)) {
-#else
-	if (!user_mode(regs)) {
-#endif
-		preempt_disable();
-		if (kprobe_running() && kprobe_fault_handler(regs, 14))
-			ret = 1;
-		preempt_enable();
-	}
-
-	return ret;
-#else
-	return 0;
-#endif
-}
-
 /*
  * X86_32
  * Sometimes AMD Athlon/Opteron CPUs report invalid exceptions on prefetch.
@@ -589,7 +566,8 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
 
 	si_code = SEGV_MAPERR;
 
-	if (notify_page_fault(regs))
+	/* Must not try to handle kprobes in v8086 mode */
+	if (!v8086_mode(regs) && kprobe_handle_fault(regs, 14))
 		return;
 
 	/*
diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index 6168c0a..e5ecb1e 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -36,6 +36,7 @@
 #include <linux/spinlock.h>
 #include <linux/rcupdate.h>
 #include <linux/mutex.h>
+#include <linux/hardirq.h>
 
 #ifdef CONFIG_KPROBES
 #include <asm/kprobes.h>
@@ -212,6 +213,21 @@ static inline struct kprobe *kprobe_running(void)
 	return (__get_cpu_var(current_kprobe));
 }
 
+static inline int kprobe_handle_fault(struct pt_regs *regs, int trapnr)
+{
+	int ret = 0;
+
+	/* kprobe_running() needs smp_processor_id() */
+	if (!user_mode(regs)) {
+		preempt_disable();
+		if (kprobe_running() && kprobe_fault_handler(regs, trapnr))
+			ret = 1;
+		preempt_enable();
+	}
+
+	return ret;
+}
+
 static inline void reset_current_kprobe(void)
 {
 	__get_cpu_var(current_kprobe) = NULL;
@@ -247,6 +263,10 @@ static inline struct kprobe *kprobe_running(void)
 {
 	return NULL;
 }
+static inline int kprobe_handle_fault(struct pt_regs *regs, int trapnr)
+{
+	return 0;
+}
 static inline int register_kprobe(struct kprobe *p)
 {
 	return -ENOSYS;
-- 
1.5.4.rc4.1142.gf5a97


