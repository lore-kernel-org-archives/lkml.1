Return-Path: <linux-kernel-owner+w=401wt.eu-S1762123AbYDCTlF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762123AbYDCTlF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 15:41:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760344AbYDCTdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 15:33:23 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:53030
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759300AbYDCTdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 15:33:02 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Izik Eidus <izike@qumranet.com>
Subject: [PATCH 35/35] KVM: x86: hardware task switching support
Date: Thu,  3 Apr 2008 22:32:50 +0300
Message-Id: <1207251170-5013-36-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1207251170-5013-1-git-send-email-avi@qumranet.com>
References: <1207251170-5013-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Izik Eidus <izike@qumranet.com>

This emulates the x86 hardware task switch mechanism in software, as it is
unsupported by either vmx or svm.  It allows operating systems which use it,
like freedos, to run as kvm guests.

Signed-off-by: Izik Eidus <izike@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/svm.c         |   15 ++-
 arch/x86/kvm/svm.h         |    3 +
 arch/x86/kvm/tss.h         |   59 +++++++
 arch/x86/kvm/vmx.c         |   15 ++
 arch/x86/kvm/x86.c         |  408 ++++++++++++++++++++++++++++++++++++++++++++
 include/asm-x86/kvm_host.h |    9 +
 6 files changed, 506 insertions(+), 3 deletions(-)
 create mode 100644 arch/x86/kvm/tss.h

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index c1c1b97..ad27346 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1112,9 +1112,18 @@ static int invalid_op_interception(struct vcpu_svm *svm,
 static int task_switch_interception(struct vcpu_svm *svm,
 				    struct kvm_run *kvm_run)
 {
-	pr_unimpl(&svm->vcpu, "%s: task switch is unsupported\n", __func__);
-	kvm_run->exit_reason = KVM_EXIT_UNKNOWN;
-	return 0;
+	u16 tss_selector;
+
+	tss_selector = (u16)svm->vmcb->control.exit_info_1;
+	if (svm->vmcb->control.exit_info_2 &
+	    (1ULL << SVM_EXITINFOSHIFT_TS_REASON_IRET))
+		return kvm_task_switch(&svm->vcpu, tss_selector,
+				       TASK_SWITCH_IRET);
+	if (svm->vmcb->control.exit_info_2 &
+	    (1ULL << SVM_EXITINFOSHIFT_TS_REASON_JMP))
+		return kvm_task_switch(&svm->vcpu, tss_selector,
+				       TASK_SWITCH_JMP);
+	return kvm_task_switch(&svm->vcpu, tss_selector, TASK_SWITCH_CALL);
 }
 
 static int cpuid_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
diff --git a/arch/x86/kvm/svm.h b/arch/x86/kvm/svm.h
index 5fd5049..1b8afa7 100644
--- a/arch/x86/kvm/svm.h
+++ b/arch/x86/kvm/svm.h
@@ -238,6 +238,9 @@ struct __attribute__ ((__packed__)) vmcb {
 #define SVM_EXITINTINFO_VALID SVM_EVTINJ_VALID
 #define SVM_EXITINTINFO_VALID_ERR SVM_EVTINJ_VALID_ERR
 
+#define SVM_EXITINFOSHIFT_TS_REASON_IRET 36
+#define SVM_EXITINFOSHIFT_TS_REASON_JMP 38
+
 #define	SVM_EXIT_READ_CR0 	0x000
 #define	SVM_EXIT_READ_CR3 	0x003
 #define	SVM_EXIT_READ_CR4 	0x004
diff --git a/arch/x86/kvm/tss.h b/arch/x86/kvm/tss.h
new file mode 100644
index 0000000..622aa10
--- /dev/null
+++ b/arch/x86/kvm/tss.h
@@ -0,0 +1,59 @@
+#ifndef __TSS_SEGMENT_H
+#define __TSS_SEGMENT_H
+
+struct tss_segment_32 {
+	u32 prev_task_link;
+	u32 esp0;
+	u32 ss0;
+	u32 esp1;
+	u32 ss1;
+	u32 esp2;
+	u32 ss2;
+	u32 cr3;
+	u32 eip;
+	u32 eflags;
+	u32 eax;
+	u32 ecx;
+	u32 edx;
+	u32 ebx;
+	u32 esp;
+	u32 ebp;
+	u32 esi;
+	u32 edi;
+	u32 es;
+	u32 cs;
+	u32 ss;
+	u32 ds;
+	u32 fs;
+	u32 gs;
+	u32 ldt_selector;
+	u16 t;
+	u16 io_map;
+};
+
+struct tss_segment_16 {
+	u16 prev_task_link;
+	u16 sp0;
+	u16 ss0;
+	u16 sp1;
+	u16 ss1;
+	u16 sp2;
+	u16 ss2;
+	u16 ip;
+	u16 flag;
+	u16 ax;
+	u16 cx;
+	u16 dx;
+	u16 bx;
+	u16 sp;
+	u16 bp;
+	u16 si;
+	u16 di;
+	u16 es;
+	u16 cs;
+	u16 ss;
+	u16 ds;
+	u16 ldt;
+};
+
+#endif
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 9b56032..cbca46a 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2249,6 +2249,20 @@ static int handle_apic_access(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	return 1;
 }
 
+static int handle_task_switch(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+{
+	unsigned long exit_qualification;
+	u16 tss_selector;
+	int reason;
+
+	exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
+
+	reason = (u32)exit_qualification >> 30;
+	tss_selector = exit_qualification;
+
+	return kvm_task_switch(vcpu, tss_selector, reason);
+}
+
 /*
  * The exit handlers return 1 if the exit was handled fully and guest execution
  * may resume.  Otherwise they set the kvm_run parameter to indicate what needs
@@ -2271,6 +2285,7 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu,
 	[EXIT_REASON_TPR_BELOW_THRESHOLD]     = handle_tpr_below_threshold,
 	[EXIT_REASON_APIC_ACCESS]             = handle_apic_access,
 	[EXIT_REASON_WBINVD]                  = handle_wbinvd,
+	[EXIT_REASON_TASK_SWITCH]             = handle_task_switch,
 };
 
 static const int kvm_vmx_max_exit_handlers =
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 63afca1..acecde4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -18,6 +18,7 @@
 #include "irq.h"
 #include "mmu.h"
 #include "i8254.h"
+#include "tss.h"
 
 #include <linux/clocksource.h>
 #include <linux/kvm.h>
@@ -3077,6 +3078,413 @@ static void set_segment(struct kvm_vcpu *vcpu,
 	kvm_x86_ops->set_segment(vcpu, var, seg);
 }
 
+static void seg_desct_to_kvm_desct(struct desc_struct *seg_desc, u16 selector,
+				   struct kvm_segment *kvm_desct)
+{
+	kvm_desct->base = seg_desc->base0;
+	kvm_desct->base |= seg_desc->base1 << 16;
+	kvm_desct->base |= seg_desc->base2 << 24;
+	kvm_desct->limit = seg_desc->limit0;
+	kvm_desct->limit |= seg_desc->limit << 16;
+	kvm_desct->selector = selector;
+	kvm_desct->type = seg_desc->type;
+	kvm_desct->present = seg_desc->p;
+	kvm_desct->dpl = seg_desc->dpl;
+	kvm_desct->db = seg_desc->d;
+	kvm_desct->s = seg_desc->s;
+	kvm_desct->l = seg_desc->l;
+	kvm_desct->g = seg_desc->g;
+	kvm_desct->avl = seg_desc->avl;
+	if (!selector)
+		kvm_desct->unusable = 1;
+	else
+		kvm_desct->unusable = 0;
+	kvm_desct->padding = 0;
+}
+
+static void get_segment_descritptor_dtable(struct kvm_vcpu *vcpu,
+					   u16 selector,
+					   struct descriptor_table *dtable)
+{
+	if (selector & 1 << 2) {
+		struct kvm_segment kvm_seg;
+
+		get_segment(vcpu, &kvm_seg, VCPU_SREG_LDTR);
+
+		if (kvm_seg.unusable)
+			dtable->limit = 0;
+		else
+			dtable->limit = kvm_seg.limit;
+		dtable->base = kvm_seg.base;
+	}
+	else
+		kvm_x86_ops->get_gdt(vcpu, dtable);
+}
+
+/* allowed just for 8 bytes segments */
+static int load_guest_segment_descriptor(struct kvm_vcpu *vcpu, u16 selector,
+					 struct desc_struct *seg_desc)
+{
+	struct descriptor_table dtable;
+	u16 index = selector >> 3;
+
+	get_segment_descritptor_dtable(vcpu, selector, &dtable);
+
+	if (dtable.limit < index * 8 + 7) {
+		kvm_queue_exception_e(vcpu, GP_VECTOR, selector & 0xfffc);
+		return 1;
+	}
+	return kvm_read_guest(vcpu->kvm, dtable.base + index * 8, seg_desc, 8);
+}
+
+/* allowed just for 8 bytes segments */
+static int save_guest_segment_descriptor(struct kvm_vcpu *vcpu, u16 selector,
+					 struct desc_struct *seg_desc)
+{
+	struct descriptor_table dtable;
+	u16 index = selector >> 3;
+
+	get_segment_descritptor_dtable(vcpu, selector, &dtable);
+
+	if (dtable.limit < index * 8 + 7)
+		return 1;
+	return kvm_write_guest(vcpu->kvm, dtable.base + index * 8, seg_desc, 8);
+}
+
+static u32 get_tss_base_addr(struct kvm_vcpu *vcpu,
+			     struct desc_struct *seg_desc)
+{
+	u32 base_addr;
+
+	base_addr = seg_desc->base0;
+	base_addr |= (seg_desc->base1 << 16);
+	base_addr |= (seg_desc->base2 << 24);
+
+	return base_addr;
+}
+
+static int load_tss_segment32(struct kvm_vcpu *vcpu,
+			      struct desc_struct *seg_desc,
+			      struct tss_segment_32 *tss)
+{
+	u32 base_addr;
+
+	base_addr = get_tss_base_addr(vcpu, seg_desc);
+
+	return kvm_read_guest(vcpu->kvm, base_addr, tss,
+			      sizeof(struct tss_segment_32));
+}
+
+static int save_tss_segment32(struct kvm_vcpu *vcpu,
+			      struct desc_struct *seg_desc,
+			      struct tss_segment_32 *tss)
+{
+	u32 base_addr;
+
+	base_addr = get_tss_base_addr(vcpu, seg_desc);
+
+	return kvm_write_guest(vcpu->kvm, base_addr, tss,
+			       sizeof(struct tss_segment_32));
+}
+
+static int load_tss_segment16(struct kvm_vcpu *vcpu,
+			      struct desc_struct *seg_desc,
+			      struct tss_segment_16 *tss)
+{
+	u32 base_addr;
+
+	base_addr = get_tss_base_addr(vcpu, seg_desc);
+
+	return kvm_read_guest(vcpu->kvm, base_addr, tss,
+			      sizeof(struct tss_segment_16));
+}
+
+static int save_tss_segment16(struct kvm_vcpu *vcpu,
+			      struct desc_struct *seg_desc,
+			      struct tss_segment_16 *tss)
+{
+	u32 base_addr;
+
+	base_addr = get_tss_base_addr(vcpu, seg_desc);
+
+	return kvm_write_guest(vcpu->kvm, base_addr, tss,
+			       sizeof(struct tss_segment_16));
+}
+
+static u16 get_segment_selector(struct kvm_vcpu *vcpu, int seg)
+{
+	struct kvm_segment kvm_seg;
+
+	get_segment(vcpu, &kvm_seg, seg);
+	return kvm_seg.selector;
+}
+
+static int load_segment_descriptor_to_kvm_desct(struct kvm_vcpu *vcpu,
+						u16 selector,
+						struct kvm_segment *kvm_seg)
+{
+	struct desc_struct seg_desc;
+
+	if (load_guest_segment_descriptor(vcpu, selector, &seg_desc))
+		return 1;
+	seg_desct_to_kvm_desct(&seg_desc, selector, kvm_seg);
+	return 0;
+}
+
+static int load_segment_descriptor(struct kvm_vcpu *vcpu, u16 selector,
+				   int type_bits, int seg)
+{
+	struct kvm_segment kvm_seg;
+
+	if (load_segment_descriptor_to_kvm_desct(vcpu, selector, &kvm_seg))
+		return 1;
+	kvm_seg.type |= type_bits;
+
+	if (seg != VCPU_SREG_SS && seg != VCPU_SREG_CS &&
+	    seg != VCPU_SREG_LDTR)
+		if (!kvm_seg.s)
+			kvm_seg.unusable = 1;
+
+	set_segment(vcpu, &kvm_seg, seg);
+	return 0;
+}
+
+static void save_state_to_tss32(struct kvm_vcpu *vcpu,
+				struct tss_segment_32 *tss)
+{
+	tss->cr3 = vcpu->arch.cr3;
+	tss->eip = vcpu->arch.rip;
+	tss->eflags = kvm_x86_ops->get_rflags(vcpu);
+	tss->eax = vcpu->arch.regs[VCPU_REGS_RAX];
+	tss->ecx = vcpu->arch.regs[VCPU_REGS_RCX];
+	tss->edx = vcpu->arch.regs[VCPU_REGS_RDX];
+	tss->ebx = vcpu->arch.regs[VCPU_REGS_RBX];
+	tss->esp = vcpu->arch.regs[VCPU_REGS_RSP];
+	tss->ebp = vcpu->arch.regs[VCPU_REGS_RBP];
+	tss->esi = vcpu->arch.regs[VCPU_REGS_RSI];
+	tss->edi = vcpu->arch.regs[VCPU_REGS_RDI];
+
+	tss->es = get_segment_selector(vcpu, VCPU_SREG_ES);
+	tss->cs = get_segment_selector(vcpu, VCPU_SREG_CS);
+	tss->ss = get_segment_selector(vcpu, VCPU_SREG_SS);
+	tss->ds = get_segment_selector(vcpu, VCPU_SREG_DS);
+	tss->fs = get_segment_selector(vcpu, VCPU_SREG_FS);
+	tss->gs = get_segment_selector(vcpu, VCPU_SREG_GS);
+	tss->ldt_selector = get_segment_selector(vcpu, VCPU_SREG_LDTR);
+	tss->prev_task_link = get_segment_selector(vcpu, VCPU_SREG_TR);
+}
+
+static int load_state_from_tss32(struct kvm_vcpu *vcpu,
+				  struct tss_segment_32 *tss)
+{
+	kvm_set_cr3(vcpu, tss->cr3);
+
+	vcpu->arch.rip = tss->eip;
+	kvm_x86_ops->set_rflags(vcpu, tss->eflags | 2);
+
+	vcpu->arch.regs[VCPU_REGS_RAX] = tss->eax;
+	vcpu->arch.regs[VCPU_REGS_RCX] = tss->ecx;
+	vcpu->arch.regs[VCPU_REGS_RDX] = tss->edx;
+	vcpu->arch.regs[VCPU_REGS_RBX] = tss->ebx;
+	vcpu->arch.regs[VCPU_REGS_RSP] = tss->esp;
+	vcpu->arch.regs[VCPU_REGS_RBP] = tss->ebp;
+	vcpu->arch.regs[VCPU_REGS_RSI] = tss->esi;
+	vcpu->arch.regs[VCPU_REGS_RDI] = tss->edi;
+
+	if (load_segment_descriptor(vcpu, tss->ldt_selector, 0, VCPU_SREG_LDTR))
+		return 1;
+
+	if (load_segment_descriptor(vcpu, tss->es, 1, VCPU_SREG_ES))
+		return 1;
+
+	if (load_segment_descriptor(vcpu, tss->cs, 9, VCPU_SREG_CS))
+		return 1;
+
+	if (load_segment_descriptor(vcpu, tss->ss, 1, VCPU_SREG_SS))
+		return 1;
+
+	if (load_segment_descriptor(vcpu, tss->ds, 1, VCPU_SREG_DS))
+		return 1;
+
+	if (load_segment_descriptor(vcpu, tss->fs, 1, VCPU_SREG_FS))
+		return 1;
+
+	if (load_segment_descriptor(vcpu, tss->gs, 1, VCPU_SREG_GS))
+		return 1;
+	return 0;
+}
+
+static void save_state_to_tss16(struct kvm_vcpu *vcpu,
+				struct tss_segment_16 *tss)
+{
+	tss->ip = vcpu->arch.rip;
+	tss->flag = kvm_x86_ops->get_rflags(vcpu);
+	tss->ax = vcpu->arch.regs[VCPU_REGS_RAX];
+	tss->cx = vcpu->arch.regs[VCPU_REGS_RCX];
+	tss->dx = vcpu->arch.regs[VCPU_REGS_RDX];
+	tss->bx = vcpu->arch.regs[VCPU_REGS_RBX];
+	tss->sp = vcpu->arch.regs[VCPU_REGS_RSP];
+	tss->bp = vcpu->arch.regs[VCPU_REGS_RBP];
+	tss->si = vcpu->arch.regs[VCPU_REGS_RSI];
+	tss->di = vcpu->arch.regs[VCPU_REGS_RDI];
+
+	tss->es = get_segment_selector(vcpu, VCPU_SREG_ES);
+	tss->cs = get_segment_selector(vcpu, VCPU_SREG_CS);
+	tss->ss = get_segment_selector(vcpu, VCPU_SREG_SS);
+	tss->ds = get_segment_selector(vcpu, VCPU_SREG_DS);
+	tss->ldt = get_segment_selector(vcpu, VCPU_SREG_LDTR);
+	tss->prev_task_link = get_segment_selector(vcpu, VCPU_SREG_TR);
+}
+
+static int load_state_from_tss16(struct kvm_vcpu *vcpu,
+				 struct tss_segment_16 *tss)
+{
+	vcpu->arch.rip = tss->ip;
+	kvm_x86_ops->set_rflags(vcpu, tss->flag | 2);
+	vcpu->arch.regs[VCPU_REGS_RAX] = tss->ax;
+	vcpu->arch.regs[VCPU_REGS_RCX] = tss->cx;
+	vcpu->arch.regs[VCPU_REGS_RDX] = tss->dx;
+	vcpu->arch.regs[VCPU_REGS_RBX] = tss->bx;
+	vcpu->arch.regs[VCPU_REGS_RSP] = tss->sp;
+	vcpu->arch.regs[VCPU_REGS_RBP] = tss->bp;
+	vcpu->arch.regs[VCPU_REGS_RSI] = tss->si;
+	vcpu->arch.regs[VCPU_REGS_RDI] = tss->di;
+
+	if (load_segment_descriptor(vcpu, tss->ldt, 0, VCPU_SREG_LDTR))
+		return 1;
+
+	if (load_segment_descriptor(vcpu, tss->es, 1, VCPU_SREG_ES))
+		return 1;
+
+	if (load_segment_descriptor(vcpu, tss->cs, 9, VCPU_SREG_CS))
+		return 1;
+
+	if (load_segment_descriptor(vcpu, tss->ss, 1, VCPU_SREG_SS))
+		return 1;
+
+	if (load_segment_descriptor(vcpu, tss->ds, 1, VCPU_SREG_DS))
+		return 1;
+	return 0;
+}
+
+int kvm_task_switch_16(struct kvm_vcpu *vcpu, u16 tss_selector,
+		       struct desc_struct *cseg_desc,
+		       struct desc_struct *nseg_desc)
+{
+	struct tss_segment_16 tss_segment_16;
+	int ret = 0;
+
+	if (load_tss_segment16(vcpu, cseg_desc, &tss_segment_16))
+		goto out;
+
+	save_state_to_tss16(vcpu, &tss_segment_16);
+	save_tss_segment16(vcpu, cseg_desc, &tss_segment_16);
+
+	load_tss_segment16(vcpu, nseg_desc, &tss_segment_16);
+	if (load_state_from_tss16(vcpu, &tss_segment_16))
+		goto out;
+
+	ret = 1;
+out:
+	return ret;
+}
+
+int kvm_task_switch_32(struct kvm_vcpu *vcpu, u16 tss_selector,
+		       struct desc_struct *cseg_desc,
+		       struct desc_struct *nseg_desc)
+{
+	struct tss_segment_32 tss_segment_32;
+	int ret = 0;
+
+	if (load_tss_segment32(vcpu, cseg_desc, &tss_segment_32))
+		goto out;
+
+	save_state_to_tss32(vcpu, &tss_segment_32);
+	save_tss_segment32(vcpu, cseg_desc, &tss_segment_32);
+
+	if (load_tss_segment32(vcpu, nseg_desc, &tss_segment_32))
+		goto out;
+	if (load_state_from_tss32(vcpu, &tss_segment_32))
+		goto out;
+
+	ret = 1;
+out:
+	return ret;
+}
+
+int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_selector, int reason)
+{
+	struct kvm_segment tr_seg;
+	struct desc_struct cseg_desc;
+	struct desc_struct nseg_desc;
+	int ret = 0;
+
+	get_segment(vcpu, &tr_seg, VCPU_SREG_TR);
+
+	if (load_guest_segment_descriptor(vcpu, tss_selector, &nseg_desc))
+		goto out;
+
+	if (load_guest_segment_descriptor(vcpu, tr_seg.selector, &cseg_desc))
+		goto out;
+
+
+	if (reason != TASK_SWITCH_IRET) {
+		int cpl;
+
+		cpl = kvm_x86_ops->get_cpl(vcpu);
+		if ((tss_selector & 3) > nseg_desc.dpl || cpl > nseg_desc.dpl) {
+			kvm_queue_exception_e(vcpu, GP_VECTOR, 0);
+			return 1;
+		}
+	}
+
+	if (!nseg_desc.p || (nseg_desc.limit0 | nseg_desc.limit << 16) < 0x67) {
+		kvm_queue_exception_e(vcpu, TS_VECTOR, tss_selector & 0xfffc);
+		return 1;
+	}
+
+	if (reason == TASK_SWITCH_IRET || reason == TASK_SWITCH_JMP) {
+		cseg_desc.type &= ~(1 << 8); //clear the B flag
+		save_guest_segment_descriptor(vcpu, tr_seg.selector,
+					      &cseg_desc);
+	}
+
+	if (reason == TASK_SWITCH_IRET) {
+		u32 eflags = kvm_x86_ops->get_rflags(vcpu);
+		kvm_x86_ops->set_rflags(vcpu, eflags & ~X86_EFLAGS_NT);
+	}
+
+	kvm_x86_ops->skip_emulated_instruction(vcpu);
+	kvm_x86_ops->cache_regs(vcpu);
+
+	if (nseg_desc.type & 8)
+		ret = kvm_task_switch_32(vcpu, tss_selector, &cseg_desc,
+					 &nseg_desc);
+	else
+		ret = kvm_task_switch_16(vcpu, tss_selector, &cseg_desc,
+					 &nseg_desc);
+
+	if (reason == TASK_SWITCH_CALL || reason == TASK_SWITCH_GATE) {
+		u32 eflags = kvm_x86_ops->get_rflags(vcpu);
+		kvm_x86_ops->set_rflags(vcpu, eflags | X86_EFLAGS_NT);
+	}
+
+	if (TASK_SWITCH_IRET != 1) {
+		nseg_desc.type |= (1 << 8);
+		save_guest_segment_descriptor(vcpu, tss_selector,
+					      &nseg_desc);
+	}
+
+	kvm_x86_ops->set_cr0(vcpu, vcpu->arch.cr0 | X86_CR0_TS);
+	seg_desct_to_kvm_desct(&nseg_desc, tss_selector, &tr_seg);
+	tr_seg.type = 11;
+	set_segment(vcpu, &tr_seg, VCPU_SREG_TR);
+out:
+	kvm_x86_ops->decache_regs(vcpu);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(kvm_task_switch);
+
 int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 				  struct kvm_sregs *sregs)
 {
diff --git a/include/asm-x86/kvm_host.h b/include/asm-x86/kvm_host.h
index 06bd154..4382ca0 100644
--- a/include/asm-x86/kvm_host.h
+++ b/include/asm-x86/kvm_host.h
@@ -491,6 +491,8 @@ int emulator_get_dr(struct x86_emulate_ctxt *ctxt, int dr,
 int emulator_set_dr(struct x86_emulate_ctxt *ctxt, int dr,
 		    unsigned long value);
 
+int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_selector, int reason);
+
 void kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
 void kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr0);
 void kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr0);
@@ -655,4 +657,11 @@ static inline void kvm_inject_gp(struct kvm_vcpu *vcpu, u32 error_code)
 #define TSS_REDIRECTION_SIZE (256 / 8)
 #define RMODE_TSS_SIZE (TSS_BASE_SIZE + TSS_REDIRECTION_SIZE + TSS_IOPB_SIZE + 1)
 
+enum {
+	TASK_SWITCH_CALL = 0,
+	TASK_SWITCH_IRET = 1,
+	TASK_SWITCH_JMP = 2,
+	TASK_SWITCH_GATE = 3,
+};
+
 #endif
-- 
1.5.4.5

