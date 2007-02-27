Return-Path: <linux-kernel-owner+w=401wt.eu-S932964AbXB0IpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932964AbXB0IpY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 03:45:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161037AbXB0InM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 03:43:12 -0500
Received: from gw.goop.org ([64.81.55.164]:46844 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932948AbXB0Iii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 03:38:38 -0500
Message-Id: <20070227081631.921696519@goop.org>
References: <20070227081337.434798469@goop.org>
User-Agent: quilt/0.46-1
Date: Tue, 27 Feb 2007 00:13:45 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@muc.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-arch@vger.kernel.org
Subject: [patch 08/26] Xen-paravirt_ops: add hooks to intercept mm creation and destruction
Content-Disposition: inline; filename=mm-lifetime-hooks.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add hooks to allow a paravirt implementation to track the lifetime of
an mm.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: linux-arch@vger.kernel.org
---
 arch/i386/kernel/paravirt.c    |    4 ++++
 include/asm-i386/mmu_context.h |    8 ++++++--
 include/asm-i386/paravirt.h    |   25 +++++++++++++++++++++++++
 include/linux/sched.h          |    6 ++++++
 kernel/fork.c                  |    2 ++
 mm/mmap.c                      |    3 +++
 6 files changed, 46 insertions(+), 2 deletions(-)

===================================================================
--- a/arch/i386/kernel/paravirt.c
+++ b/arch/i386/kernel/paravirt.c
@@ -700,6 +700,10 @@ struct paravirt_ops paravirt_ops = {
 	.irq_enable_sysexit = native_irq_enable_sysexit,
 	.iret = native_iret,
 
+	.dup_mmap = paravirt_nop,
+	.exit_mmap = paravirt_nop,
+	.activate_mm = paravirt_nop,
+
 	.startup_ipi_hook = paravirt_nop,
 };
 
===================================================================
--- a/include/asm-i386/mmu_context.h
+++ b/include/asm-i386/mmu_context.h
@@ -5,6 +5,7 @@
 #include <asm/atomic.h>
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
+#include <asm/paravirt.h>
 
 /*
  * Used for LDT copy/destruction.
@@ -65,7 +66,10 @@ static inline void switch_mm(struct mm_s
 #define deactivate_mm(tsk, mm)			\
 	asm("movl %0,%%gs": :"r" (0));
 
-#define activate_mm(prev, next) \
-	switch_mm((prev),(next),NULL)
+#define activate_mm(prev, next)				\
+	do {						\
+		arch_activate_mm(prev, next);		\
+		switch_mm((prev),(next),NULL);		\
+	} while(0);
 
 #endif
===================================================================
--- a/include/asm-i386/paravirt.h
+++ b/include/asm-i386/paravirt.h
@@ -123,6 +123,12 @@ struct paravirt_ops
 	void (*io_delay)(void);
 	void (*const_udelay)(unsigned long loops);
 
+	void (*activate_mm)(struct mm_struct *prev,
+			    struct mm_struct *next);
+	void (*dup_mmap)(struct mm_struct *oldmm,
+			 struct mm_struct *mm);
+	void (*exit_mmap)(struct mm_struct *mm);
+
 #ifdef CONFIG_X86_LOCAL_APIC
 	void (*apic_write)(unsigned long reg, unsigned long v);
 	void (*apic_write_atomic)(unsigned long reg, unsigned long v);
@@ -426,6 +432,24 @@ static inline void startup_ipi_hook(int 
 }
 #endif
 
+#define __HAVE_ARCH_MM_LIFETIME
+static inline void arch_activate_mm(struct mm_struct *prev,
+				    struct mm_struct *next)
+{
+	paravirt_ops.activate_mm(prev, next);
+}
+
+static inline void arch_dup_mmap(struct mm_struct *oldmm,
+				 struct mm_struct *mm)
+{
+	paravirt_ops.dup_mmap(oldmm, mm);
+}
+
+static inline void arch_exit_mmap(struct mm_struct *mm)
+{
+	paravirt_ops.exit_mmap(mm);
+}
+
 #define __flush_tlb() paravirt_ops.flush_tlb_user()
 #define __flush_tlb_global() paravirt_ops.flush_tlb_kernel()
 #define __flush_tlb_single(addr) paravirt_ops.flush_tlb_single(addr)
@@ -673,5 +697,6 @@ static inline void paravirt_pagetable_se
 	set_pgd(&base[0], base[USER_PTRS_PER_PGD]);
 #endif
 }
+
 #endif /* CONFIG_PARAVIRT */
 #endif	/* __ASM_PARAVIRT_H */
===================================================================
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -374,6 +374,12 @@ struct mm_struct {
 	rwlock_t		ioctx_list_lock;
 	struct kioctx		*ioctx_list;
 };
+
+#ifndef __HAVE_ARCH_MM_LIFETIME
+#define arch_activate_mm(prev, next)	do {} while(0)
+#define arch_dup_mmap(oldmm, mm)	do {} while(0)
+#define arch_exit_mmap(mm)		do {} while(0)
+#endif
 
 struct sighand_struct {
 	atomic_t		count;
===================================================================
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -286,6 +286,8 @@ static inline int dup_mmap(struct mm_str
 		if (retval)
 			goto out;
 	}
+	/* a new mm has just been created */
+	arch_dup_mmap(oldmm, mm);
 	retval = 0;
 out:
 	up_write(&mm->mmap_sem);
===================================================================
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1976,6 +1976,9 @@ void exit_mmap(struct mm_struct *mm)
 	struct vm_area_struct *vma = mm->mmap;
 	unsigned long nr_accounted = 0;
 	unsigned long end;
+
+	/* mm's last user has gone, and its about to be pulled down */
+	arch_exit_mmap(mm);
 
 	lru_add_drain();
 	flush_cache_mm(mm);

-- 

