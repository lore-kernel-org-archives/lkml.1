Return-Path: <linux-kernel-owner+w=401wt.eu-S1760170AbZC0SEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760170AbZC0SEw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 14:04:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755124AbZC0SCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 14:02:50 -0400
Received: from gw.goop.org ([64.81.55.164]:58159 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752856AbZC0SCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 14:02:47 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: the arch/x86 maintainers <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 6/8] x86/paravirt: allow preemption with lazy mmu mode
Date: Fri, 27 Mar 2009 11:02:41 -0700
Message-Id: <1238176963-21093-7-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1238176963-21093-1-git-send-email-jeremy@goop.org>
References: <1238176963-21093-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Impact: remove obsolete checks, simplification

Lift restrictions on preemption with lazy mmu mode, as it is now allowed.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/paravirt.c |    7 ++++---
 arch/x86/xen/mmu.c         |    8 +-------
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 35eb353..c59a9d3 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -247,7 +247,6 @@ static DEFINE_PER_CPU(enum paravirt_lazy_mode, paravirt_lazy_mode) = PARAVIRT_LA
 static inline void enter_lazy(enum paravirt_lazy_mode mode)
 {
 	BUG_ON(__get_cpu_var(paravirt_lazy_mode) != PARAVIRT_LAZY_NONE);
-	BUG_ON(preemptible());
 
 	__get_cpu_var(paravirt_lazy_mode) = mode;
 }
@@ -255,7 +254,6 @@ static inline void enter_lazy(enum paravirt_lazy_mode mode)
 static void leave_lazy(enum paravirt_lazy_mode mode)
 {
 	BUG_ON(__get_cpu_var(paravirt_lazy_mode) != mode);
-	BUG_ON(preemptible());
 
 	__get_cpu_var(paravirt_lazy_mode) = PARAVIRT_LAZY_NONE;
 }
@@ -272,6 +270,8 @@ void paravirt_leave_lazy_mmu(void)
 
 void paravirt_start_context_switch(struct task_struct *prev)
 {
+	BUG_ON(preemptible());
+
 	if (percpu_read(paravirt_lazy_mode) == PARAVIRT_LAZY_MMU) {
 		arch_leave_lazy_mmu_mode();
 		set_ti_thread_flag(task_thread_info(prev), TIF_LAZY_MMU_UPDATES);
@@ -281,6 +281,8 @@ void paravirt_start_context_switch(struct task_struct *prev)
 
 void paravirt_end_context_switch(struct task_struct *next)
 {
+	BUG_ON(preemptible());
+
 	leave_lazy(PARAVIRT_LAZY_CPU);
 
 	if (test_and_clear_ti_thread_flag(task_thread_info(next), TIF_LAZY_MMU_UPDATES))
@@ -300,7 +302,6 @@ void arch_flush_lazy_mmu_mode(void)
 	preempt_disable();
 
 	if (paravirt_get_lazy_mode() == PARAVIRT_LAZY_MMU) {
-		WARN_ON(preempt_count() == 1);
 		arch_leave_lazy_mmu_mode();
 		arch_enter_lazy_mmu_mode();
 	}
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index aba3b20..e194f72 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -419,10 +419,6 @@ void set_pte_mfn(unsigned long vaddr, unsigned long mfn, pgprot_t flags)
 void xen_set_pte_at(struct mm_struct *mm, unsigned long addr,
 		    pte_t *ptep, pte_t pteval)
 {
-	/* updates to init_mm may be done without lock */
-	if (mm == &init_mm)
-		preempt_disable();
-
 	ADD_STATS(set_pte_at, 1);
 //	ADD_STATS(set_pte_at_pinned, xen_page_pinned(ptep));
 	ADD_STATS(set_pte_at_current, mm == current->mm);
@@ -443,9 +439,7 @@ void xen_set_pte_at(struct mm_struct *mm, unsigned long addr,
 	}
 	xen_set_pte(ptep, pteval);
 
-out:
-	if (mm == &init_mm)
-		preempt_enable();
+out:	return;
 }
 
 pte_t xen_ptep_modify_prot_start(struct mm_struct *mm,
-- 
1.6.0.6

