Return-Path: <linux-kernel-owner+w=401wt.eu-S933080AbXBLHrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933080AbXBLHrz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 02:47:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933082AbXBLHqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 02:46:53 -0500
Received: from ns2.suse.de ([195.135.220.15]:49607 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933079AbXBLHhz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 02:37:55 -0500
From: Andi Kleen <ak@suse.de>
References: <20070212837.963446000@suse.de>
In-Reply-To: <20070212837.963446000@suse.de>
To: Glauber de Oliveira Costa <gcosta@redhat.com>, Andi Kleen <ak@suse.de>,
       patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH x86 for review II] [8/39] x86_64: Remove fastcall references in x86_64 code
Message-Id: <20070212073754.79C9913D01@wotan.suse.de>
Date: Mon, 12 Feb 2007 08:37:54 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Glauber de Oliveira Costa <gcosta@redhat.com>

Unlike x86, x86_64 already passes arguments in registers.  The use of
regparm attribute makes no difference in produced code, and the use of
fastcall just bloats the code.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/x86_64/kernel/acpi/sleep.c  |    2 +-
 arch/x86_64/kernel/x8664_ksyms.c |    4 ++--
 include/asm-x86_64/hw_irq.h      |    2 +-
 include/asm-x86_64/mutex.h       |    6 +++---
 4 files changed, 7 insertions(+), 7 deletions(-)

Index: linux/arch/x86_64/kernel/acpi/sleep.c
===================================================================
--- linux.orig/arch/x86_64/kernel/acpi/sleep.c
+++ linux/arch/x86_64/kernel/acpi/sleep.c
@@ -58,7 +58,7 @@ unsigned long acpi_wakeup_address = 0;
 unsigned long acpi_video_flags;
 extern char wakeup_start, wakeup_end;
 
-extern unsigned long FASTCALL(acpi_copy_wakeup_routine(unsigned long));
+extern unsigned long acpi_copy_wakeup_routine(unsigned long);
 
 static pgd_t low_ptr;
 
Index: linux/arch/x86_64/kernel/x8664_ksyms.c
===================================================================
--- linux.orig/arch/x86_64/kernel/x8664_ksyms.c
+++ linux/arch/x86_64/kernel/x8664_ksyms.c
@@ -36,8 +36,8 @@ EXPORT_SYMBOL(copy_page);
 EXPORT_SYMBOL(clear_page);
 
 #ifdef CONFIG_SMP
-extern void FASTCALL( __write_lock_failed(rwlock_t *rw));
-extern void FASTCALL( __read_lock_failed(rwlock_t *rw));
+extern void  __write_lock_failed(rwlock_t *rw);
+extern void  __read_lock_failed(rwlock_t *rw);
 EXPORT_SYMBOL(__write_lock_failed);
 EXPORT_SYMBOL(__read_lock_failed);
 #endif
Index: linux/include/asm-x86_64/hw_irq.h
===================================================================
--- linux.orig/include/asm-x86_64/hw_irq.h
+++ linux/include/asm-x86_64/hw_irq.h
@@ -91,7 +91,7 @@ extern void enable_8259A_irq(unsigned in
 extern int i8259A_irq_pending(unsigned int irq);
 extern void make_8259A_irq(unsigned int irq);
 extern void init_8259A(int aeoi);
-extern void FASTCALL(send_IPI_self(int vector));
+extern void send_IPI_self(int vector);
 extern void init_VISWS_APIC_irqs(void);
 extern void setup_IO_APIC(void);
 extern void disable_IO_APIC(void);
Index: linux/include/asm-x86_64/mutex.h
===================================================================
--- linux.orig/include/asm-x86_64/mutex.h
+++ linux/include/asm-x86_64/mutex.h
@@ -21,7 +21,7 @@ do {									\
 	unsigned long dummy;						\
 									\
 	typecheck(atomic_t *, v);					\
-	typecheck_fn(fastcall void (*)(atomic_t *), fail_fn);		\
+	typecheck_fn(void (*)(atomic_t *), fail_fn);			\
 									\
 	__asm__ __volatile__(						\
 		LOCK_PREFIX "   decl (%%rdi)	\n"			\
@@ -47,7 +47,7 @@ do {									\
  */
 static inline int
 __mutex_fastpath_lock_retval(atomic_t *count,
-			     int fastcall (*fail_fn)(atomic_t *))
+			     int (*fail_fn)(atomic_t *))
 {
 	if (unlikely(atomic_dec_return(count) < 0))
 		return fail_fn(count);
@@ -67,7 +67,7 @@ do {									\
 	unsigned long dummy;						\
 									\
 	typecheck(atomic_t *, v);					\
-	typecheck_fn(fastcall void (*)(atomic_t *), fail_fn);		\
+	typecheck_fn(void (*)(atomic_t *), fail_fn);			\
 									\
 	__asm__ __volatile__(						\
 		LOCK_PREFIX "   incl (%%rdi)	\n"			\
