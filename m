Return-Path: <linux-kernel-owner+w=401wt.eu-S1754697AbYLHLmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697AbYLHLmn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 06:42:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752327AbYLHLhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 06:37:42 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48284 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753106AbYLHLhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 06:37:07 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hollis Blanchard <hollisb@us.ibm.com>
Subject: [PATCH 41/45] KVM: ppc: Refactor powerpc.c to relocate 440-specific code
Date: Mon,  8 Dec 2008 13:36:52 +0200
Message-Id: <1228736216-15787-42-git-send-email-avi@redhat.com>
In-Reply-To: <1228736216-15787-1-git-send-email-avi@redhat.com>
References: <1228736216-15787-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hollis Blanchard <hollisb@us.ibm.com>

This introduces a set of core-provided hooks. For 440, some of these are
implemented by booke.c, with the rest in (the new) 44x.c.

Note that these hooks are link-time, not run-time. Since it is not possible to
build a single kernel for both e500 and 440 (for example), using function
pointers would only add overhead.

Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/include/asm/kvm_host.h |    3 +
 arch/powerpc/include/asm/kvm_ppc.h  |   34 +++++-----
 arch/powerpc/kvm/44x.c              |  123 +++++++++++++++++++++++++++++++++++
 arch/powerpc/kvm/44x_tlb.h          |    1 +
 arch/powerpc/kvm/Kconfig            |   11 +--
 arch/powerpc/kvm/Makefile           |    4 +-
 arch/powerpc/kvm/booke.c            |   61 +++++++++++++----
 arch/powerpc/kvm/emulate.c          |    2 +-
 arch/powerpc/kvm/powerpc.c          |  103 +++--------------------------
 9 files changed, 207 insertions(+), 135 deletions(-)
 create mode 100644 arch/powerpc/kvm/44x.c

diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index df73351..f5850d7 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -74,6 +74,9 @@ struct kvmppc_44x_tlbe {
 struct kvm_arch {
 };
 
+/* XXX Can't include mmu-44x.h because it redefines struct mm_context. */
+#define PPC44x_TLB_SIZE 64
+
 struct kvm_vcpu_arch {
 	/* Unmodified copy of the guest's TLB. */
 	struct kvmppc_44x_tlbe guest_tlb[PPC44x_TLB_SIZE];
diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
index 39daeaa..96d5de9 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -61,23 +61,6 @@ extern void kvmppc_mmu_map(struct kvm_vcpu *vcpu, u64 gvaddr, gfn_t gfn,
 extern void kvmppc_mmu_priv_switch(struct kvm_vcpu *vcpu, int usermode);
 extern void kvmppc_mmu_switch_pid(struct kvm_vcpu *vcpu, u32 pid);
 
-/* XXX Book E specific */
-extern void kvmppc_tlbe_set_modified(struct kvm_vcpu *vcpu, unsigned int i);
-
-extern void kvmppc_check_and_deliver_interrupts(struct kvm_vcpu *vcpu);
-
-static inline void kvmppc_queue_exception(struct kvm_vcpu *vcpu, int exception)
-{
-	unsigned int priority = exception_priority[exception];
-	set_bit(priority, &vcpu->arch.pending_exceptions);
-}
-
-static inline void kvmppc_clear_exception(struct kvm_vcpu *vcpu, int exception)
-{
-	unsigned int priority = exception_priority[exception];
-	clear_bit(priority, &vcpu->arch.pending_exceptions);
-}
-
 /* Helper function for "full" MSR writes. No need to call this if only EE is
  * changing. */
 static inline void kvmppc_set_msr(struct kvm_vcpu *vcpu, u32 new_msr)
@@ -99,6 +82,23 @@ static inline void kvmppc_set_pid(struct kvm_vcpu *vcpu, u32 new_pid)
 	}
 }
 
+/* Core-specific hooks */
+
+extern int kvmppc_core_check_processor_compat(void);
+
+extern void kvmppc_core_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
+extern void kvmppc_core_vcpu_put(struct kvm_vcpu *vcpu);
+
+extern void kvmppc_core_load_guest_debugstate(struct kvm_vcpu *vcpu);
+extern void kvmppc_core_load_host_debugstate(struct kvm_vcpu *vcpu);
+
+extern void kvmppc_core_deliver_interrupts(struct kvm_vcpu *vcpu);
+extern int kvmppc_core_pending_dec(struct kvm_vcpu *vcpu);
+extern void kvmppc_core_queue_program(struct kvm_vcpu *vcpu);
+extern void kvmppc_core_queue_dec(struct kvm_vcpu *vcpu);
+extern void kvmppc_core_queue_external(struct kvm_vcpu *vcpu,
+                                       struct kvm_interrupt *irq);
+
 extern void kvmppc_core_destroy_mmu(struct kvm_vcpu *vcpu);
 
 #endif /* __POWERPC_KVM_PPC_H__ */
diff --git a/arch/powerpc/kvm/44x.c b/arch/powerpc/kvm/44x.c
new file mode 100644
index 0000000..fcf8c7d
--- /dev/null
+++ b/arch/powerpc/kvm/44x.c
@@ -0,0 +1,123 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ *
+ * Copyright IBM Corp. 2008
+ *
+ * Authors: Hollis Blanchard <hollisb@us.ibm.com>
+ */
+
+#include <linux/kvm_host.h>
+#include <asm/reg.h>
+#include <asm/cputable.h>
+#include <asm/tlbflush.h>
+
+#include "44x_tlb.h"
+
+/* Note: clearing MSR[DE] just means that the debug interrupt will not be
+ * delivered *immediately*. Instead, it simply sets the appropriate DBSR bits.
+ * If those DBSR bits are still set when MSR[DE] is re-enabled, the interrupt
+ * will be delivered as an "imprecise debug event" (which is indicated by
+ * DBSR[IDE].
+ */
+static void kvm44x_disable_debug_interrupts(void)
+{
+	mtmsr(mfmsr() & ~MSR_DE);
+}
+
+void kvmppc_core_load_host_debugstate(struct kvm_vcpu *vcpu)
+{
+	kvm44x_disable_debug_interrupts();
+
+	mtspr(SPRN_IAC1, vcpu->arch.host_iac[0]);
+	mtspr(SPRN_IAC2, vcpu->arch.host_iac[1]);
+	mtspr(SPRN_IAC3, vcpu->arch.host_iac[2]);
+	mtspr(SPRN_IAC4, vcpu->arch.host_iac[3]);
+	mtspr(SPRN_DBCR1, vcpu->arch.host_dbcr1);
+	mtspr(SPRN_DBCR2, vcpu->arch.host_dbcr2);
+	mtspr(SPRN_DBCR0, vcpu->arch.host_dbcr0);
+	mtmsr(vcpu->arch.host_msr);
+}
+
+void kvmppc_core_load_guest_debugstate(struct kvm_vcpu *vcpu)
+{
+	struct kvm_guest_debug *dbg = &vcpu->guest_debug;
+	u32 dbcr0 = 0;
+
+	vcpu->arch.host_msr = mfmsr();
+	kvm44x_disable_debug_interrupts();
+
+	/* Save host debug register state. */
+	vcpu->arch.host_iac[0] = mfspr(SPRN_IAC1);
+	vcpu->arch.host_iac[1] = mfspr(SPRN_IAC2);
+	vcpu->arch.host_iac[2] = mfspr(SPRN_IAC3);
+	vcpu->arch.host_iac[3] = mfspr(SPRN_IAC4);
+	vcpu->arch.host_dbcr0 = mfspr(SPRN_DBCR0);
+	vcpu->arch.host_dbcr1 = mfspr(SPRN_DBCR1);
+	vcpu->arch.host_dbcr2 = mfspr(SPRN_DBCR2);
+
+	/* set registers up for guest */
+
+	if (dbg->bp[0]) {
+		mtspr(SPRN_IAC1, dbg->bp[0]);
+		dbcr0 |= DBCR0_IAC1 | DBCR0_IDM;
+	}
+	if (dbg->bp[1]) {
+		mtspr(SPRN_IAC2, dbg->bp[1]);
+		dbcr0 |= DBCR0_IAC2 | DBCR0_IDM;
+	}
+	if (dbg->bp[2]) {
+		mtspr(SPRN_IAC3, dbg->bp[2]);
+		dbcr0 |= DBCR0_IAC3 | DBCR0_IDM;
+	}
+	if (dbg->bp[3]) {
+		mtspr(SPRN_IAC4, dbg->bp[3]);
+		dbcr0 |= DBCR0_IAC4 | DBCR0_IDM;
+	}
+
+	mtspr(SPRN_DBCR0, dbcr0);
+	mtspr(SPRN_DBCR1, 0);
+	mtspr(SPRN_DBCR2, 0);
+}
+
+void kvmppc_core_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
+{
+	int i;
+
+	/* Mark every guest entry in the shadow TLB entry modified, so that they
+	 * will all be reloaded on the next vcpu run (instead of being
+	 * demand-faulted). */
+	for (i = 0; i <= tlb_44x_hwater; i++)
+		kvmppc_tlbe_set_modified(vcpu, i);
+}
+
+void kvmppc_core_vcpu_put(struct kvm_vcpu *vcpu)
+{
+	/* Don't leave guest TLB entries resident when being de-scheduled. */
+	/* XXX It would be nice to differentiate between heavyweight exit and
+	 * sched_out here, since we could avoid the TLB flush for heavyweight
+	 * exits. */
+	_tlbia();
+}
+
+int kvmppc_core_check_processor_compat(void)
+{
+	int r;
+
+	if (strcmp(cur_cpu_spec->platform, "ppc440") == 0)
+		r = 0;
+	else
+		r = -ENOTSUPP;
+
+	return r;
+}
diff --git a/arch/powerpc/kvm/44x_tlb.h b/arch/powerpc/kvm/44x_tlb.h
index e5b0a76..357d79a 100644
--- a/arch/powerpc/kvm/44x_tlb.h
+++ b/arch/powerpc/kvm/44x_tlb.h
@@ -29,6 +29,7 @@ extern struct kvmppc_44x_tlbe *kvmppc_44x_dtlb_search(struct kvm_vcpu *vcpu,
                                                       gva_t eaddr);
 extern struct kvmppc_44x_tlbe *kvmppc_44x_itlb_search(struct kvm_vcpu *vcpu,
                                                       gva_t eaddr);
+extern void kvmppc_tlbe_set_modified(struct kvm_vcpu *vcpu, unsigned int i);
 
 /* TLB helper functions */
 static inline unsigned int get_tlb_size(const struct kvmppc_44x_tlbe *tlbe)
diff --git a/arch/powerpc/kvm/Kconfig b/arch/powerpc/kvm/Kconfig
index ffed96f..37e9b3c 100644
--- a/arch/powerpc/kvm/Kconfig
+++ b/arch/powerpc/kvm/Kconfig
@@ -16,11 +16,9 @@ if VIRTUALIZATION
 
 config KVM
 	bool "Kernel-based Virtual Machine (KVM) support"
-	depends on 44x && EXPERIMENTAL
+	depends on EXPERIMENTAL
 	select PREEMPT_NOTIFIERS
 	select ANON_INODES
-	# We can only run on Book E hosts so far
-	select KVM_BOOKE
 	---help---
 	  Support hosting virtualized guest machines. You will also
 	  need to select one or more of the processor modules below.
@@ -30,12 +28,11 @@ config KVM
 
 	  If unsure, say N.
 
-config KVM_BOOKE
-	bool "KVM support for Book E PowerPC processors"
+config KVM_440
+	bool "KVM support for PowerPC 440 processors"
 	depends on KVM && 44x
 	---help---
-	  Provides host support for KVM on Book E PowerPC processors. Currently
-	  this works on 440 processors only.
+	  KVM can run unmodified 440 guest kernels on 440 host processors.
 
 config KVM_TRACE
 	bool "KVM trace support"
diff --git a/arch/powerpc/kvm/Makefile b/arch/powerpc/kvm/Makefile
index a7f8574..f5e3375 100644
--- a/arch/powerpc/kvm/Makefile
+++ b/arch/powerpc/kvm/Makefile
@@ -13,5 +13,5 @@ obj-$(CONFIG_KVM) += kvm.o
 
 AFLAGS_booke_interrupts.o := -I$(obj)
 
-kvm-booke-objs := booke.o booke_interrupts.o 44x_tlb.o
-obj-$(CONFIG_KVM_BOOKE) += kvm-booke.o
+kvm-440-objs := booke.o booke_interrupts.o 44x.o 44x_tlb.o
+obj-$(CONFIG_KVM_440) += kvm-440.o
diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index b1e90a1..138014a 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -134,6 +134,40 @@ void kvmppc_dump_vcpu(struct kvm_vcpu *vcpu)
 	}
 }
 
+static void kvmppc_booke_queue_exception(struct kvm_vcpu *vcpu, int exception)
+{
+	unsigned int priority = exception_priority[exception];
+	set_bit(priority, &vcpu->arch.pending_exceptions);
+}
+
+static void kvmppc_booke_clear_exception(struct kvm_vcpu *vcpu, int exception)
+{
+	unsigned int priority = exception_priority[exception];
+	clear_bit(priority, &vcpu->arch.pending_exceptions);
+}
+
+void kvmppc_core_queue_program(struct kvm_vcpu *vcpu)
+{
+	kvmppc_booke_queue_exception(vcpu, BOOKE_INTERRUPT_PROGRAM);
+}
+
+void kvmppc_core_queue_dec(struct kvm_vcpu *vcpu)
+{
+	kvmppc_booke_queue_exception(vcpu, BOOKE_INTERRUPT_DECREMENTER);
+}
+
+int kvmppc_core_pending_dec(struct kvm_vcpu *vcpu)
+{
+	unsigned int priority = exception_priority[BOOKE_INTERRUPT_DECREMENTER];
+	return test_bit(priority, &vcpu->arch.pending_exceptions);
+}
+
+void kvmppc_core_queue_external(struct kvm_vcpu *vcpu,
+                                struct kvm_interrupt *irq)
+{
+	kvmppc_booke_queue_exception(vcpu, BOOKE_INTERRUPT_EXTERNAL);
+}
+
 /* Check if we are ready to deliver the interrupt */
 static int kvmppc_can_deliver_interrupt(struct kvm_vcpu *vcpu, int interrupt)
 {
@@ -168,7 +202,7 @@ static int kvmppc_can_deliver_interrupt(struct kvm_vcpu *vcpu, int interrupt)
 	return r;
 }
 
-static void kvmppc_deliver_interrupt(struct kvm_vcpu *vcpu, int interrupt)
+static void kvmppc_booke_deliver_interrupt(struct kvm_vcpu *vcpu, int interrupt)
 {
 	switch (interrupt) {
 	case BOOKE_INTERRUPT_DECREMENTER:
@@ -183,7 +217,7 @@ static void kvmppc_deliver_interrupt(struct kvm_vcpu *vcpu, int interrupt)
 }
 
 /* Check pending exceptions and deliver one, if possible. */
-void kvmppc_check_and_deliver_interrupts(struct kvm_vcpu *vcpu)
+void kvmppc_core_deliver_interrupts(struct kvm_vcpu *vcpu)
 {
 	unsigned long *pending = &vcpu->arch.pending_exceptions;
 	unsigned int exception;
@@ -193,8 +227,8 @@ void kvmppc_check_and_deliver_interrupts(struct kvm_vcpu *vcpu)
 	while (priority <= BOOKE_MAX_INTERRUPT) {
 		exception = priority_exception[priority];
 		if (kvmppc_can_deliver_interrupt(vcpu, exception)) {
-			kvmppc_clear_exception(vcpu, exception);
-			kvmppc_deliver_interrupt(vcpu, exception);
+			kvmppc_booke_clear_exception(vcpu, exception);
+			kvmppc_booke_deliver_interrupt(vcpu, exception);
 			break;
 		}
 
@@ -251,7 +285,7 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 			/* Program traps generated by user-level software must be handled
 			 * by the guest kernel. */
 			vcpu->arch.esr = vcpu->arch.fault_esr;
-			kvmppc_queue_exception(vcpu, BOOKE_INTERRUPT_PROGRAM);
+			kvmppc_booke_queue_exception(vcpu, BOOKE_INTERRUPT_PROGRAM);
 			r = RESUME_GUEST;
 			break;
 		}
@@ -284,27 +318,27 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 		break;
 
 	case BOOKE_INTERRUPT_FP_UNAVAIL:
-		kvmppc_queue_exception(vcpu, exit_nr);
+		kvmppc_booke_queue_exception(vcpu, exit_nr);
 		r = RESUME_GUEST;
 		break;
 
 	case BOOKE_INTERRUPT_DATA_STORAGE:
 		vcpu->arch.dear = vcpu->arch.fault_dear;
 		vcpu->arch.esr = vcpu->arch.fault_esr;
-		kvmppc_queue_exception(vcpu, exit_nr);
+		kvmppc_booke_queue_exception(vcpu, exit_nr);
 		vcpu->stat.dsi_exits++;
 		r = RESUME_GUEST;
 		break;
 
 	case BOOKE_INTERRUPT_INST_STORAGE:
 		vcpu->arch.esr = vcpu->arch.fault_esr;
-		kvmppc_queue_exception(vcpu, exit_nr);
+		kvmppc_booke_queue_exception(vcpu, exit_nr);
 		vcpu->stat.isi_exits++;
 		r = RESUME_GUEST;
 		break;
 
 	case BOOKE_INTERRUPT_SYSCALL:
-		kvmppc_queue_exception(vcpu, exit_nr);
+		kvmppc_booke_queue_exception(vcpu, exit_nr);
 		vcpu->stat.syscall_exits++;
 		r = RESUME_GUEST;
 		break;
@@ -318,7 +352,7 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 		gtlbe = kvmppc_44x_dtlb_search(vcpu, eaddr);
 		if (!gtlbe) {
 			/* The guest didn't have a mapping for it. */
-			kvmppc_queue_exception(vcpu, exit_nr);
+			kvmppc_booke_queue_exception(vcpu, exit_nr);
 			vcpu->arch.dear = vcpu->arch.fault_dear;
 			vcpu->arch.esr = vcpu->arch.fault_esr;
 			vcpu->stat.dtlb_real_miss_exits++;
@@ -360,7 +394,7 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 		gtlbe = kvmppc_44x_itlb_search(vcpu, eaddr);
 		if (!gtlbe) {
 			/* The guest didn't have a mapping for it. */
-			kvmppc_queue_exception(vcpu, exit_nr);
+			kvmppc_booke_queue_exception(vcpu, exit_nr);
 			vcpu->stat.itlb_real_miss_exits++;
 			break;
 		}
@@ -380,8 +414,7 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 			               gtlbe->word2);
 		} else {
 			/* Guest mapped and leaped at non-RAM! */
-			kvmppc_queue_exception(vcpu,
-			                       BOOKE_INTERRUPT_MACHINE_CHECK);
+			kvmppc_booke_queue_exception(vcpu, BOOKE_INTERRUPT_MACHINE_CHECK);
 		}
 
 		break;
@@ -409,7 +442,7 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 
 	local_irq_disable();
 
-	kvmppc_check_and_deliver_interrupts(vcpu);
+	kvmppc_core_deliver_interrupts(vcpu);
 
 	/* Do some exit accounting. */
 	vcpu->stat.sum_exits++;
diff --git a/arch/powerpc/kvm/emulate.c b/arch/powerpc/kvm/emulate.c
index 0ce8ed5..c5d2bfc 100644
--- a/arch/powerpc/kvm/emulate.c
+++ b/arch/powerpc/kvm/emulate.c
@@ -139,7 +139,7 @@ int kvmppc_emulate_instruction(struct kvm_run *run, struct kvm_vcpu *vcpu)
 	switch (get_op(inst)) {
 	case 3:                                                 /* trap */
 		printk("trap!\n");
-		kvmppc_queue_exception(vcpu, BOOKE_INTERRUPT_PROGRAM);
+		kvmppc_core_queue_program(vcpu);
 		advance = 0;
 		break;
 
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index fda9baa..800fe97 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -98,14 +98,7 @@ void kvm_arch_hardware_unsetup(void)
 
 void kvm_arch_check_processor_compat(void *rtn)
 {
-	int r;
-
-	if (strcmp(cur_cpu_spec->platform, "ppc440") == 0)
-		r = 0;
-	else
-		r = -ENOTSUPP;
-
-	*(int *)rtn = r;
+	*(int *)rtn = kvmppc_core_check_processor_compat();
 }
 
 struct kvm *kvm_arch_create_vm(void)
@@ -211,16 +204,14 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 
 int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
 {
-	unsigned int priority = exception_priority[BOOKE_INTERRUPT_DECREMENTER];
-
-	return test_bit(priority, &vcpu->arch.pending_exceptions);
+	return kvmppc_core_pending_dec(vcpu);
 }
 
 static void kvmppc_decrementer_func(unsigned long data)
 {
 	struct kvm_vcpu *vcpu = (struct kvm_vcpu *)data;
 
-	kvmppc_queue_exception(vcpu, BOOKE_INTERRUPT_DECREMENTER);
+	kvmppc_core_queue_dec(vcpu);
 
 	if (waitqueue_active(&vcpu->wq)) {
 		wake_up_interruptible(&vcpu->wq);
@@ -241,96 +232,20 @@ void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu)
 	kvmppc_core_destroy_mmu(vcpu);
 }
 
-/* Note: clearing MSR[DE] just means that the debug interrupt will not be
- * delivered *immediately*. Instead, it simply sets the appropriate DBSR bits.
- * If those DBSR bits are still set when MSR[DE] is re-enabled, the interrupt
- * will be delivered as an "imprecise debug event" (which is indicated by
- * DBSR[IDE].
- */
-static void kvmppc_disable_debug_interrupts(void)
-{
-	mtmsr(mfmsr() & ~MSR_DE);
-}
-
-static void kvmppc_restore_host_debug_state(struct kvm_vcpu *vcpu)
-{
-	kvmppc_disable_debug_interrupts();
-
-	mtspr(SPRN_IAC1, vcpu->arch.host_iac[0]);
-	mtspr(SPRN_IAC2, vcpu->arch.host_iac[1]);
-	mtspr(SPRN_IAC3, vcpu->arch.host_iac[2]);
-	mtspr(SPRN_IAC4, vcpu->arch.host_iac[3]);
-	mtspr(SPRN_DBCR1, vcpu->arch.host_dbcr1);
-	mtspr(SPRN_DBCR2, vcpu->arch.host_dbcr2);
-	mtspr(SPRN_DBCR0, vcpu->arch.host_dbcr0);
-	mtmsr(vcpu->arch.host_msr);
-}
-
-static void kvmppc_load_guest_debug_registers(struct kvm_vcpu *vcpu)
-{
-	struct kvm_guest_debug *dbg = &vcpu->guest_debug;
-	u32 dbcr0 = 0;
-
-	vcpu->arch.host_msr = mfmsr();
-	kvmppc_disable_debug_interrupts();
-
-	/* Save host debug register state. */
-	vcpu->arch.host_iac[0] = mfspr(SPRN_IAC1);
-	vcpu->arch.host_iac[1] = mfspr(SPRN_IAC2);
-	vcpu->arch.host_iac[2] = mfspr(SPRN_IAC3);
-	vcpu->arch.host_iac[3] = mfspr(SPRN_IAC4);
-	vcpu->arch.host_dbcr0 = mfspr(SPRN_DBCR0);
-	vcpu->arch.host_dbcr1 = mfspr(SPRN_DBCR1);
-	vcpu->arch.host_dbcr2 = mfspr(SPRN_DBCR2);
-
-	/* set registers up for guest */
-
-	if (dbg->bp[0]) {
-		mtspr(SPRN_IAC1, dbg->bp[0]);
-		dbcr0 |= DBCR0_IAC1 | DBCR0_IDM;
-	}
-	if (dbg->bp[1]) {
-		mtspr(SPRN_IAC2, dbg->bp[1]);
-		dbcr0 |= DBCR0_IAC2 | DBCR0_IDM;
-	}
-	if (dbg->bp[2]) {
-		mtspr(SPRN_IAC3, dbg->bp[2]);
-		dbcr0 |= DBCR0_IAC3 | DBCR0_IDM;
-	}
-	if (dbg->bp[3]) {
-		mtspr(SPRN_IAC4, dbg->bp[3]);
-		dbcr0 |= DBCR0_IAC4 | DBCR0_IDM;
-	}
-
-	mtspr(SPRN_DBCR0, dbcr0);
-	mtspr(SPRN_DBCR1, 0);
-	mtspr(SPRN_DBCR2, 0);
-}
-
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
-	int i;
-
 	if (vcpu->guest_debug.enabled)
-		kvmppc_load_guest_debug_registers(vcpu);
+		kvmppc_core_load_guest_debugstate(vcpu);
 
-	/* Mark every guest entry in the shadow TLB entry modified, so that they
-	 * will all be reloaded on the next vcpu run (instead of being
-	 * demand-faulted). */
-	for (i = 0; i <= tlb_44x_hwater; i++)
-		kvmppc_tlbe_set_modified(vcpu, i);
+	kvmppc_core_vcpu_load(vcpu, cpu);
 }
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
 	if (vcpu->guest_debug.enabled)
-		kvmppc_restore_host_debug_state(vcpu);
+		kvmppc_core_load_host_debugstate(vcpu);
 
-	/* Don't leave guest TLB entries resident when being de-scheduled. */
-	/* XXX It would be nice to differentiate between heavyweight exit and
-	 * sched_out here, since we could avoid the TLB flush for heavyweight
-	 * exits. */
-	_tlbia();
+	kvmppc_core_vcpu_put(vcpu);
 }
 
 int kvm_arch_vcpu_ioctl_debug_guest(struct kvm_vcpu *vcpu,
@@ -459,7 +374,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		vcpu->arch.dcr_needed = 0;
 	}
 
-	kvmppc_check_and_deliver_interrupts(vcpu);
+	kvmppc_core_deliver_interrupts(vcpu);
 
 	local_irq_disable();
 	kvm_guest_enter();
@@ -477,7 +392,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 
 int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu, struct kvm_interrupt *irq)
 {
-	kvmppc_queue_exception(vcpu, BOOKE_INTERRUPT_EXTERNAL);
+	kvmppc_core_queue_external(vcpu, irq);
 
 	if (waitqueue_active(&vcpu->wq)) {
 		wake_up_interruptible(&vcpu->wq);
-- 
1.6.0.3

