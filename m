Return-Path: <linux-kernel-owner+w=401wt.eu-S1760809AbXHHHIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760809AbXHHHIx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 03:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757332AbXHHHHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 03:07:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43547 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755544AbXHHHHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 03:07:35 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au, ak@suse.de,
       mingo@elte.hu, chrisw@sous-sol.org, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       lguest@ozlabs.org, Glauber de Oliveira Costa <gcosta@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 2/25] [PATCH] tlb flushing routines
Date: Wed,  8 Aug 2007 01:18:49 -0300
Message-Id: <1186546763582-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11865467592921-git-send-email-gcosta@redhat.com>
References: <11865467522495-git-send-email-gcosta@redhat.com> <11865467592921-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch turns the flush_tlb routines into native versions.
In case paravirt is not defined, the natives are defined into
the actually used ones. flush_tlb_others() goes in smp.c, unless
we smp is not in the game

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86_64/kernel/smp.c      |   10 +++++++++-
 include/asm-x86_64/smp.h      |    8 ++++++++
 include/asm-x86_64/tlbflush.h |   22 ++++++++++++++++++----
 3 files changed, 35 insertions(+), 5 deletions(-)

diff --git a/arch/x86_64/kernel/smp.c b/arch/x86_64/kernel/smp.c
index 673a300..39f5f6b 100644
--- a/arch/x86_64/kernel/smp.c
+++ b/arch/x86_64/kernel/smp.c
@@ -165,7 +165,7 @@ out:
 	cpu_clear(cpu, f->flush_cpumask);
 }
 
-static void flush_tlb_others(cpumask_t cpumask, struct mm_struct *mm,
+void native_flush_tlb_others(cpumask_t cpumask, struct mm_struct *mm,
 						unsigned long va)
 {
 	int sender;
@@ -198,6 +198,14 @@ static void flush_tlb_others(cpumask_t cpumask, struct mm_struct *mm,
 	spin_unlock(&f->tlbstate_lock);
 }
 
+/* Overriden in paravirt.c if CONFIG_PARAVIRT */
+void __attribute__((weak)) flush_tlb_others(cpumask_t cpumask,
+					    struct mm_struct *mm,
+					    unsigned long va)
+{
+	native_flush_tlb_others(cpumask, mm, va);
+}
+
 int __cpuinit init_smp_flush(void)
 {
 	int i;
diff --git a/include/asm-x86_64/smp.h b/include/asm-x86_64/smp.h
index 3f303d2..6b11114 100644
--- a/include/asm-x86_64/smp.h
+++ b/include/asm-x86_64/smp.h
@@ -19,6 +19,14 @@ extern int disable_apic;
 
 #include <asm/pda.h>
 
+#ifdef CONFIG_PARAVIRT
+#include <asm/paravirt.h>
+void native_flush_tlb_others(cpumask_t cpumask, struct mm_struct *mm,
+						unsigned long va);
+#else
+#define startup_ipi_hook(apicid, rip, rsp) do { } while (0)
+#endif
+
 struct pt_regs;
 
 extern cpumask_t cpu_present_mask;
diff --git a/include/asm-x86_64/tlbflush.h b/include/asm-x86_64/tlbflush.h
index 888eb4a..1c68cc8 100644
--- a/include/asm-x86_64/tlbflush.h
+++ b/include/asm-x86_64/tlbflush.h
@@ -6,21 +6,30 @@
 #include <asm/processor.h>
 #include <asm/system.h>
 
-static inline void __flush_tlb(void)
+static inline void native_flush_tlb(void)
 {
 	write_cr3(read_cr3());
 }
 
-static inline void __flush_tlb_all(void)
+static inline void native_flush_tlb_all(void)
 {
 	unsigned long cr4 = read_cr4();
 	write_cr4(cr4 & ~X86_CR4_PGE);	/* clear PGE */
 	write_cr4(cr4);			/* write old PGE again and flush TLBs */
 }
 
-#define __flush_tlb_one(addr) \
-	__asm__ __volatile__("invlpg (%0)" :: "r" (addr) : "memory")
+static inline void native_flush_tlb_one(unsigned long addr)
+{
+	asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
+}
 
+#ifdef CONFIG_PARAVIRT
+#include <asm/paravirt.h>
+#else
+#define __flush_tlb()		native_flush_tlb()
+#define __flush_tlb_all()	native_flush_tlb_all()
+#define __flush_tlb_one(addr)	native_flush_tlb_one(addr)
+#endif	/* CONFIG_PARAVIRT */
 
 /*
  * TLB flushing:
@@ -64,6 +73,11 @@ static inline void flush_tlb_range(struct vm_area_struct *vma,
 		__flush_tlb();
 }
 
+static inline void native_flush_tlb_others(cpumask_t *cpumask,
+					   struct mm_struct *mm, unsigned long va)
+{
+}
+
 #else
 
 #include <asm/smp.h>
-- 
1.4.4.2

