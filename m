Return-Path: <linux-kernel-owner+w=401wt.eu-S1754317AbZBRWbE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317AbZBRWbE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 17:31:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752957AbZBRWaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 17:30:24 -0500
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:43888
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752447AbZBRWaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 17:30:23 -0500
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Rusty Russell <rusty@rustcorp.com.au>, Zachary Amsden <zach@vmware.com>,
       Alok N Kataria <akataria@vmware.com>, Avi Kivity <avi@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 6/9] x86/paravirt: allow preemption with lazy mmu mode
Date: Wed, 18 Feb 2009 14:30:15 -0800
Message-Id: <bb490ee65960b57a95874510baf766bc2b8574fd.1234988621.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <cover.1234988621.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1234988621.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1234988621.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1234988621.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Lift restrictions on preemption with lazy mmu mode, as it is now allowed.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/paravirt.c |    7 ++++---
 arch/x86/xen/mmu.c         |    8 +-------
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 554dadd..1a81ce9 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -248,7 +248,6 @@ static DEFINE_PER_CPU(enum paravirt_lazy_mode, paravirt_lazy_mode) = PARAVIRT_LA
 static inline void enter_lazy(enum paravirt_lazy_mode mode)
 {
 	BUG_ON(__get_cpu_var(paravirt_lazy_mode) != PARAVIRT_LAZY_NONE);
-	BUG_ON(preemptible());
 
 	__get_cpu_var(paravirt_lazy_mode) = mode;
 }
@@ -256,7 +255,6 @@ static inline void enter_lazy(enum paravirt_lazy_mode mode)
 static void leave_lazy(enum paravirt_lazy_mode mode)
 {
 	BUG_ON(__get_cpu_var(paravirt_lazy_mode) != mode);
-	BUG_ON(preemptible());
 
 	__get_cpu_var(paravirt_lazy_mode) = PARAVIRT_LAZY_NONE;
 }
@@ -273,6 +271,8 @@ void paravirt_leave_lazy_mmu(void)
 
 void paravirt_enter_lazy_cpu(void)
 {
+	BUG_ON(preemptible());
+
 	if (percpu_read(paravirt_lazy_mode) == PARAVIRT_LAZY_MMU) {
 		arch_leave_lazy_mmu_mode();
 		set_thread_flag(TIF_LAZY_MMU_UPDATES);
@@ -282,6 +282,8 @@ void paravirt_enter_lazy_cpu(void)
 
 void paravirt_leave_lazy_cpu(void)
 {
+	BUG_ON(preemptible());
+
 	leave_lazy(PARAVIRT_LAZY_CPU);
 
 	if (test_and_clear_thread_flag(TIF_LAZY_MMU_UPDATES))
@@ -301,7 +303,6 @@ void arch_flush_lazy_mmu_mode(void)
 	preempt_disable();
 
 	if (paravirt_get_lazy_mode() == PARAVIRT_LAZY_MMU) {
-		WARN_ON(preempt_count() == 1);
 		arch_leave_lazy_mmu_mode();
 		arch_enter_lazy_mmu_mode();
 	}
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 2669c58..92c6463 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -412,10 +412,6 @@ void set_pte_mfn(unsigned long vaddr, unsigned long mfn, pgprot_t flags)
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
@@ -436,9 +432,7 @@ void xen_set_pte_at(struct mm_struct *mm, unsigned long addr,
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

