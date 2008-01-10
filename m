Return-Path: <linux-kernel-owner+w=401wt.eu-S1756329AbYAJApQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756329AbYAJApQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 19:45:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753507AbYAJApE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 19:45:04 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:20788 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818AbYAJApB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 19:45:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=RKf+d5gpALnkLzQLmieooZLZ4y48l8agd6vG2KLji9puVTn3vFX9U6tVEAJKZRPFi8wADjy1WOFjHmZuS0b7MxjGZkxDQbGcG3KVEQxGKk4PmR8Xr86d8zuWL+t9s7uXz6PChqIYl+NhG7nHIOxUkDMDqUnSUlLuDPRhScurAgE=
Subject: [PATCH 1/2] kprobes: Introduce kprobe_handle_fault()
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       David Miller <davem@davemloft.net>, hskinnemoen@atmel.com,
       schwidefsky@de.ibm.com, tony.luck@intel.com,
       Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       David Wilder <dwilder@us.ibm.com>, jkenisto@us.ibm.com
In-Reply-To: <20080109231620.GA9002@osiris.ibm.com>
References: <1199737486.7666.12.camel@brick>
	 <18307.64807.204087.375733@cargo.ozlabs.ibm.com>
	 <1199833324.6424.12.camel@brick> <1199852360.6424.39.camel@brick>
	 <20080109061408.GA9486@osiris.ibm.com> <1199859742.6424.44.camel@brick>
	 <1199916062.6424.60.camel@brick>  <20080109231620.GA9002@osiris.ibm.com>
Content-Type: text/plain
Date: Wed, 09 Jan 2008 16:44:58 -0800
Message-Id: <1199925898.6424.85.camel@brick>
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
 arch/avr32/mm/fault.c   |   21 +--------------------
 arch/ia64/mm/fault.c    |   24 +-----------------------
 arch/powerpc/mm/fault.c |   25 +------------------------
 arch/s390/mm/fault.c    |   25 +------------------------
 arch/sparc64/mm/fault.c |   23 +----------------------
 arch/x86/mm/fault_64.c  |   26 ++------------------------
 include/linux/kprobes.h |   20 ++++++++++++++++++++
 7 files changed, 27 insertions(+), 137 deletions(-)

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
index 8135da0..ff64bd3 100644
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
 
 	if (trap == 0x300) {
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
diff --git a/arch/x86/mm/fault_64.c b/arch/x86/mm/fault_64.c
index 0e26230..c29e462 100644
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
+		if (kprobe_handle_fault(regs, 14))
 			return;
 		/*
 		 * Don't take the mm semaphore here. If we fixup a prefetch
@@ -352,7 +330,7 @@ asmlinkage void __kprobes do_page_fault(struct pt_regs *regs,
 		goto bad_area_nosemaphore;
 	}
 
-	if (notify_page_fault(regs))
+	if (kprobe_handle_fault(regs, 14))
 		return;
 
 	if (likely(regs->eflags & X86_EFLAGS_IF))
diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index 8189158..c01e320 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -36,6 +36,7 @@
 #include <linux/spinlock.h>
 #include <linux/rcupdate.h>
 #include <linux/mutex.h>
+#include <linux/hardirq.h>
 
 #ifdef CONFIG_KPROBES
 #include <asm/kprobes.h>
@@ -203,6 +204,21 @@ static inline struct kprobe *kprobe_running(void)
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
@@ -237,6 +253,10 @@ static inline struct kprobe *kprobe_running(void)
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
1.5.4.rc2.1164.g6451


