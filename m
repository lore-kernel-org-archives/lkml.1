Return-Path: <linux-kernel-owner+w=401wt.eu-S1764403AbYDQJZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764403AbYDQJZQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:25:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762946AbYDQJLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:11:35 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:58956
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763255AbYDQJLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:11:09 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Xiantao Zhang <xiantao.zhang@intel.com>
Subject: [PATCH 33/45] KVM: ia64: Add header files for kvm/ia64
Date: Thu, 17 Apr 2008 12:10:38 +0300
Message-Id: <1208423450-29415-34-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208423450-29415-1-git-send-email-avi@qumranet.com>
References: <1208423450-29415-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiantao Zhang <xiantao.zhang@intel.com>

kvm_minstate.h : Marcos about Min save routines.
lapic.h: apic structure definition.
vcpu.h : routions related to vcpu virtualization.
vti.h  : Some macros or routines for VT support on Itanium.

Signed-off-by: Xiantao Zhang <xiantao.zhang@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/ia64/kvm/kvm_minstate.h |  273 ++++++++++++++++
 arch/ia64/kvm/lapic.h        |   25 ++
 arch/ia64/kvm/misc.h         |   93 ++++++
 arch/ia64/kvm/vcpu.h         |  740 ++++++++++++++++++++++++++++++++++++++++++
 arch/ia64/kvm/vti.h          |  290 +++++++++++++++++
 5 files changed, 1421 insertions(+), 0 deletions(-)
 create mode 100644 arch/ia64/kvm/kvm_minstate.h
 create mode 100644 arch/ia64/kvm/lapic.h
 create mode 100644 arch/ia64/kvm/misc.h
 create mode 100644 arch/ia64/kvm/vcpu.h
 create mode 100644 arch/ia64/kvm/vti.h

diff --git a/arch/ia64/kvm/kvm_minstate.h b/arch/ia64/kvm/kvm_minstate.h
new file mode 100644
index 0000000..13980d9
--- /dev/null
+++ b/arch/ia64/kvm/kvm_minstate.h
@@ -0,0 +1,273 @@
+/*
+ *  kvm_minstate.h: min save macros
+ *  Copyright (c) 2007, Intel Corporation.
+ *
+ *  Xuefei Xu (Anthony Xu) (Anthony.xu@intel.com)
+ *  Xiantao Zhang (xiantao.zhang@intel.com)
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
+ * Place - Suite 330, Boston, MA 02111-1307 USA.
+ *
+ */
+
+
+#include <asm/asmmacro.h>
+#include <asm/types.h>
+#include <asm/kregs.h>
+#include "asm-offsets.h"
+
+#define KVM_MINSTATE_START_SAVE_MIN	     					\
+	mov ar.rsc = 0;/* set enforced lazy mode, pl 0, little-endian, loadrs=0 */\
+	;;									\
+	mov.m r28 = ar.rnat;                                  			\
+	addl r22 = VMM_RBS_OFFSET,r1;            /* compute base of RBS */	\
+	;;									\
+	lfetch.fault.excl.nt1 [r22];						\
+	addl r1 = IA64_STK_OFFSET-VMM_PT_REGS_SIZE,r1;  /* compute base of memory stack */  \
+	mov r23 = ar.bspstore;			/* save ar.bspstore */          \
+	;;									\
+	mov ar.bspstore = r22;				/* switch to kernel RBS */\
+	;;									\
+	mov r18 = ar.bsp;							\
+	mov ar.rsc = 0x3;     /* set eager mode, pl 0, little-endian, loadrs=0 */
+
+
+
+#define KVM_MINSTATE_END_SAVE_MIN						\
+	bsw.1;          /* switch back to bank 1 (must be last in insn group) */\
+	;;
+
+
+#define PAL_VSA_SYNC_READ						\
+	/* begin to call pal vps sync_read */				\
+	add r25 = VMM_VPD_BASE_OFFSET, r21;				\
+	adds r20 = VMM_VCPU_VSA_BASE_OFFSET, r21;  /* entry point */	\
+	;;								\
+	ld8 r25 = [r25];      /* read vpd base */			\
+	ld8 r20 = [r20];						\
+	;;								\
+	add r20 = PAL_VPS_SYNC_READ,r20;				\
+	;;								\
+{ .mii;									\
+	nop 0x0;							\
+	mov r24 = ip;							\
+	mov b0 = r20;							\
+	;;								\
+};									\
+{ .mmb;									\
+	add r24 = 0x20, r24;						\
+	nop 0x0;							\
+	br.cond.sptk b0;        /*  call the service */			\
+	;;								\
+};
+
+
+
+#define KVM_MINSTATE_GET_CURRENT(reg)   mov reg=r21
+
+/*
+ * KVM_DO_SAVE_MIN switches to the kernel stacks (if necessary) and saves
+ * the minimum state necessary that allows us to turn psr.ic back
+ * on.
+ *
+ * Assumed state upon entry:
+ *  psr.ic: off
+ *  r31:	contains saved predicates (pr)
+ *
+ * Upon exit, the state is as follows:
+ *  psr.ic: off
+ *   r2 = points to &pt_regs.r16
+ *   r8 = contents of ar.ccv
+ *   r9 = contents of ar.csd
+ *  r10 = contents of ar.ssd
+ *  r11 = FPSR_DEFAULT
+ *  r12 = kernel sp (kernel virtual address)
+ *  r13 = points to current task_struct (kernel virtual address)
+ *  p15 = TRUE if psr.i is set in cr.ipsr
+ *  predicate registers (other than p2, p3, and p15), b6, r3, r14, r15:
+ *	  preserved
+ *
+ * Note that psr.ic is NOT turned on by this macro.  This is so that
+ * we can pass interruption state as arguments to a handler.
+ */
+
+
+#define PT(f) (VMM_PT_REGS_##f##_OFFSET)
+
+#define KVM_DO_SAVE_MIN(COVER,SAVE_IFS,EXTRA)			\
+	KVM_MINSTATE_GET_CURRENT(r16);  /* M (or M;;I) */	\
+	mov r27 = ar.rsc;         /* M */			\
+	mov r20 = r1;         /* A */				\
+	mov r25 = ar.unat;        /* M */			\
+	mov r29 = cr.ipsr;        /* M */			\
+	mov r26 = ar.pfs;         /* I */			\
+	mov r18 = cr.isr;         				\
+	COVER;              /* B;; (or nothing) */		\
+	;;							\
+	tbit.z p0,p15 = r29,IA64_PSR_I_BIT;			\
+	mov r1 = r16;						\
+/*	mov r21=r16;	*/					\
+	/* switch from user to kernel RBS: */			\
+	;;							\
+	invala;             /* M */				\
+	SAVE_IFS;						\
+	;;							\
+	KVM_MINSTATE_START_SAVE_MIN				\
+	adds r17 = 2*L1_CACHE_BYTES,r1;/* cache-line size */	\
+	adds r16 = PT(CR_IPSR),r1;				\
+	;;							\
+	lfetch.fault.excl.nt1 [r17],L1_CACHE_BYTES;		\
+	st8 [r16] = r29;      /* save cr.ipsr */		\
+	;;							\
+	lfetch.fault.excl.nt1 [r17];				\
+	tbit.nz p15,p0 = r29,IA64_PSR_I_BIT;			\
+	mov r29 = b0						\
+	;;							\
+	adds r16 = PT(R8),r1; /* initialize first base pointer */\
+	adds r17 = PT(R9),r1; /* initialize second base pointer */\
+	;;							\
+.mem.offset 0,0; st8.spill [r16] = r8,16;			\
+.mem.offset 8,0; st8.spill [r17] = r9,16;			\
+	;;							\
+.mem.offset 0,0; st8.spill [r16] = r10,24;			\
+.mem.offset 8,0; st8.spill [r17] = r11,24;			\
+	;;							\
+	mov r9 = cr.iip;         /* M */			\
+	mov r10 = ar.fpsr;        /* M */			\
+	;;							\
+	st8 [r16] = r9,16;    /* save cr.iip */			\
+	st8 [r17] = r30,16;   /* save cr.ifs */			\
+	sub r18 = r18,r22;    /* r18=RSE.ndirty*8 */		\
+	;;							\
+	st8 [r16] = r25,16;   /* save ar.unat */		\
+	st8 [r17] = r26,16;    /* save ar.pfs */		\
+	shl r18 = r18,16;     /* calu ar.rsc used for "loadrs" */\
+	;;							\
+	st8 [r16] = r27,16;   /* save ar.rsc */			\
+	st8 [r17] = r28,16;   /* save ar.rnat */		\
+	;;          /* avoid RAW on r16 & r17 */		\
+	st8 [r16] = r23,16;   /* save ar.bspstore */		\
+	st8 [r17] = r31,16;   /* save predicates */		\
+	;;							\
+	st8 [r16] = r29,16;   /* save b0 */			\
+	st8 [r17] = r18,16;   /* save ar.rsc value for "loadrs" */\
+	;;							\
+.mem.offset 0,0; st8.spill [r16] = r20,16;/* save original r1 */  \
+.mem.offset 8,0; st8.spill [r17] = r12,16;			\
+	adds r12 = -16,r1;    /* switch to kernel memory stack */  \
+	;;							\
+.mem.offset 0,0; st8.spill [r16] = r13,16;			\
+.mem.offset 8,0; st8.spill [r17] = r10,16;	/* save ar.fpsr */\
+	mov r13 = r21;   /* establish `current' */		\
+	;;							\
+.mem.offset 0,0; st8.spill [r16] = r15,16;			\
+.mem.offset 8,0; st8.spill [r17] = r14,16;			\
+	;;							\
+.mem.offset 0,0; st8.spill [r16] = r2,16;			\
+.mem.offset 8,0; st8.spill [r17] = r3,16;			\
+	adds r2 = VMM_PT_REGS_R16_OFFSET,r1;			\
+	 ;;							\
+	adds r16 = VMM_VCPU_IIPA_OFFSET,r13;			\
+	adds r17 = VMM_VCPU_ISR_OFFSET,r13;			\
+	mov r26 = cr.iipa;					\
+	mov r27 = cr.isr;					\
+	;;							\
+	st8 [r16] = r26;					\
+	st8 [r17] = r27;					\
+	;;							\
+	EXTRA;							\
+	mov r8 = ar.ccv;					\
+	mov r9 = ar.csd;					\
+	mov r10 = ar.ssd;					\
+	movl r11 = FPSR_DEFAULT;   /* L-unit */			\
+	adds r17 = VMM_VCPU_GP_OFFSET,r13;			\
+	;;							\
+	ld8 r1 = [r17];/* establish kernel global pointer */	\
+	;;							\
+	PAL_VSA_SYNC_READ					\
+	KVM_MINSTATE_END_SAVE_MIN
+
+/*
+ * SAVE_REST saves the remainder of pt_regs (with psr.ic on).
+ *
+ * Assumed state upon entry:
+ *  psr.ic: on
+ *  r2: points to &pt_regs.f6
+ *  r3: points to &pt_regs.f7
+ *  r8: contents of ar.ccv
+ *  r9: contents of ar.csd
+ *  r10:	contents of ar.ssd
+ *  r11:	FPSR_DEFAULT
+ *
+ * Registers r14 and r15 are guaranteed not to be touched by SAVE_REST.
+ */
+#define KVM_SAVE_REST				\
+.mem.offset 0,0; st8.spill [r2] = r16,16;	\
+.mem.offset 8,0; st8.spill [r3] = r17,16;	\
+	;;				\
+.mem.offset 0,0; st8.spill [r2] = r18,16;	\
+.mem.offset 8,0; st8.spill [r3] = r19,16;	\
+	;;				\
+.mem.offset 0,0; st8.spill [r2] = r20,16;	\
+.mem.offset 8,0; st8.spill [r3] = r21,16;	\
+	mov r18=b6;			\
+	;;				\
+.mem.offset 0,0; st8.spill [r2] = r22,16;	\
+.mem.offset 8,0; st8.spill [r3] = r23,16;	\
+	mov r19 = b7;				\
+	;;					\
+.mem.offset 0,0; st8.spill [r2] = r24,16;	\
+.mem.offset 8,0; st8.spill [r3] = r25,16;	\
+	;;					\
+.mem.offset 0,0; st8.spill [r2] = r26,16;	\
+.mem.offset 8,0; st8.spill [r3] = r27,16;	\
+	;;					\
+.mem.offset 0,0; st8.spill [r2] = r28,16;	\
+.mem.offset 8,0; st8.spill [r3] = r29,16;	\
+	;;					\
+.mem.offset 0,0; st8.spill [r2] = r30,16;	\
+.mem.offset 8,0; st8.spill [r3] = r31,32;	\
+	;;					\
+	mov ar.fpsr = r11;			\
+	st8 [r2] = r8,8;			\
+	adds r24 = PT(B6)-PT(F7),r3;		\
+	adds r25 = PT(B7)-PT(F7),r3;		\
+	;;					\
+	st8 [r24] = r18,16;       /* b6 */	\
+	st8 [r25] = r19,16;       /* b7 */	\
+	adds r2 = PT(R4)-PT(F6),r2;		\
+	adds r3 = PT(R5)-PT(F7),r3;		\
+	;;					\
+	st8 [r24] = r9;	/* ar.csd */		\
+	st8 [r25] = r10;	/* ar.ssd */	\
+	;;					\
+	mov r18 = ar.unat;			\
+	adds r19 = PT(EML_UNAT)-PT(R4),r2;	\
+	;;					\
+	st8 [r19] = r18; /* eml_unat */ 	\
+
+
+#define KVM_SAVE_EXTRA				\
+.mem.offset 0,0; st8.spill [r2] = r4,16;	\
+.mem.offset 8,0; st8.spill [r3] = r5,16;	\
+	;;					\
+.mem.offset 0,0; st8.spill [r2] = r6,16;	\
+.mem.offset 8,0; st8.spill [r3] = r7;		\
+	;;					\
+	mov r26 = ar.unat;			\
+	;;					\
+	st8 [r2] = r26;/* eml_unat */ 		\
+
+#define KVM_SAVE_MIN_WITH_COVER		KVM_DO_SAVE_MIN(cover, mov r30 = cr.ifs,)
+#define KVM_SAVE_MIN_WITH_COVER_R19	KVM_DO_SAVE_MIN(cover, mov r30 = cr.ifs, mov r15 = r19)
+#define KVM_SAVE_MIN			KVM_DO_SAVE_MIN(     , mov r30 = r0, )
diff --git a/arch/ia64/kvm/lapic.h b/arch/ia64/kvm/lapic.h
new file mode 100644
index 0000000..6d6cbcb
--- /dev/null
+++ b/arch/ia64/kvm/lapic.h
@@ -0,0 +1,25 @@
+#ifndef __KVM_IA64_LAPIC_H
+#define __KVM_IA64_LAPIC_H
+
+#include <linux/kvm_host.h>
+
+/*
+ * vlsapic
+ */
+struct kvm_lapic{
+	struct kvm_vcpu *vcpu;
+	uint64_t insvc[4];
+	uint64_t vhpi;
+	uint8_t xtp;
+	uint8_t pal_init_pending;
+	uint8_t pad[2];
+};
+
+int kvm_create_lapic(struct kvm_vcpu *vcpu);
+void kvm_free_lapic(struct kvm_vcpu *vcpu);
+
+int kvm_apic_match_physical_addr(struct kvm_lapic *apic, u16 dest);
+int kvm_apic_match_logical_addr(struct kvm_lapic *apic, u8 mda);
+int kvm_apic_set_irq(struct kvm_vcpu *vcpu, u8 vec, u8 trig);
+
+#endif
diff --git a/arch/ia64/kvm/misc.h b/arch/ia64/kvm/misc.h
new file mode 100644
index 0000000..e585c46
--- /dev/null
+++ b/arch/ia64/kvm/misc.h
@@ -0,0 +1,93 @@
+#ifndef __KVM_IA64_MISC_H
+#define __KVM_IA64_MISC_H
+
+#include <linux/kvm_host.h>
+/*
+ * misc.h
+ * 	Copyright (C) 2007, Intel Corporation.
+ *  	Xiantao Zhang  (xiantao.zhang@intel.com)
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
+ * Place - Suite 330, Boston, MA 02111-1307 USA.
+ *
+ */
+
+/*
+ *Return p2m base address at host side!
+ */
+static inline uint64_t *kvm_host_get_pmt(struct kvm *kvm)
+{
+	return (uint64_t *)(kvm->arch.vm_base + KVM_P2M_OFS);
+}
+
+static inline void kvm_set_pmt_entry(struct kvm *kvm, gfn_t gfn,
+		u64 paddr, u64 mem_flags)
+{
+	uint64_t *pmt_base = kvm_host_get_pmt(kvm);
+	unsigned long pte;
+
+	pte = PAGE_ALIGN(paddr) | mem_flags;
+	pmt_base[gfn] = pte;
+}
+
+/*Function for translating host address to guest address*/
+
+static inline void *to_guest(struct kvm *kvm, void *addr)
+{
+	return (void *)((unsigned long)(addr) - kvm->arch.vm_base +
+			KVM_VM_DATA_BASE);
+}
+
+/*Function for translating guest address to host address*/
+
+static inline void *to_host(struct kvm *kvm, void *addr)
+{
+	return (void *)((unsigned long)addr - KVM_VM_DATA_BASE
+			+ kvm->arch.vm_base);
+}
+
+/* Get host context of the vcpu */
+static inline union context *kvm_get_host_context(struct kvm_vcpu *vcpu)
+{
+	union context *ctx = &vcpu->arch.host;
+	return to_guest(vcpu->kvm, ctx);
+}
+
+/* Get guest context of the vcpu */
+static inline union context *kvm_get_guest_context(struct kvm_vcpu *vcpu)
+{
+	union context *ctx = &vcpu->arch.guest;
+	return  to_guest(vcpu->kvm, ctx);
+}
+
+/* kvm get exit data from gvmm! */
+static inline struct exit_ctl_data *kvm_get_exit_data(struct kvm_vcpu *vcpu)
+{
+	return &vcpu->arch.exit_data;
+}
+
+/*kvm get vcpu ioreq for kvm module!*/
+static inline struct kvm_mmio_req *kvm_get_vcpu_ioreq(struct kvm_vcpu *vcpu)
+{
+	struct exit_ctl_data *p_ctl_data;
+
+	if (vcpu) {
+		p_ctl_data = kvm_get_exit_data(vcpu);
+		if (p_ctl_data->exit_reason == EXIT_REASON_MMIO_INSTRUCTION)
+			return &p_ctl_data->u.ioreq;
+	}
+
+	return NULL;
+}
+
+#endif
diff --git a/arch/ia64/kvm/vcpu.h b/arch/ia64/kvm/vcpu.h
new file mode 100644
index 0000000..b0fcfb6
--- /dev/null
+++ b/arch/ia64/kvm/vcpu.h
@@ -0,0 +1,740 @@
+/*
+ *  vcpu.h: vcpu routines
+ *  	Copyright (c) 2005, Intel Corporation.
+ *  	Xuefei Xu (Anthony Xu) (Anthony.xu@intel.com)
+ *  	Yaozu Dong (Eddie Dong) (Eddie.dong@intel.com)
+ *
+ * 	Copyright (c) 2007, Intel Corporation.
+ *  	Xuefei Xu (Anthony Xu) (Anthony.xu@intel.com)
+ *	Xiantao Zhang (xiantao.zhang@intel.com)
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
+ * Place - Suite 330, Boston, MA 02111-1307 USA.
+ *
+ */
+
+
+#ifndef __KVM_VCPU_H__
+#define __KVM_VCPU_H__
+
+#include <asm/types.h>
+#include <asm/fpu.h>
+#include <asm/processor.h>
+
+#ifndef __ASSEMBLY__
+#include "vti.h"
+
+#include <linux/kvm_host.h>
+#include <linux/spinlock.h>
+
+typedef unsigned long IA64_INST;
+
+typedef union U_IA64_BUNDLE {
+	unsigned long i64[2];
+	struct { unsigned long template:5, slot0:41, slot1a:18,
+		slot1b:23, slot2:41; };
+	/* NOTE: following doesn't work because bitfields can't cross natural
+	   size boundaries
+	   struct { unsigned long template:5, slot0:41, slot1:41, slot2:41; }; */
+} IA64_BUNDLE;
+
+typedef union U_INST64_A5 {
+	IA64_INST inst;
+	struct { unsigned long qp:6, r1:7, imm7b:7, r3:2, imm5c:5,
+		imm9d:9, s:1, major:4; };
+} INST64_A5;
+
+typedef union U_INST64_B4 {
+	IA64_INST inst;
+	struct { unsigned long qp:6, btype:3, un3:3, p:1, b2:3, un11:11, x6:6,
+		wh:2, d:1, un1:1, major:4; };
+} INST64_B4;
+
+typedef union U_INST64_B8 {
+	IA64_INST inst;
+	struct { unsigned long qp:6, un21:21, x6:6, un4:4, major:4; };
+} INST64_B8;
+
+typedef union U_INST64_B9 {
+	IA64_INST inst;
+	struct { unsigned long qp:6, imm20:20, :1, x6:6, :3, i:1, major:4; };
+} INST64_B9;
+
+typedef union U_INST64_I19 {
+	IA64_INST inst;
+	struct { unsigned long qp:6, imm20:20, :1, x6:6, x3:3, i:1, major:4; };
+} INST64_I19;
+
+typedef union U_INST64_I26 {
+	IA64_INST inst;
+	struct { unsigned long qp:6, :7, r2:7, ar3:7, x6:6, x3:3, :1, major:4; };
+} INST64_I26;
+
+typedef union U_INST64_I27 {
+	IA64_INST inst;
+	struct { unsigned long qp:6, :7, imm:7, ar3:7, x6:6, x3:3, s:1, major:4; };
+} INST64_I27;
+
+typedef union U_INST64_I28 { /* not privileged (mov from AR) */
+	IA64_INST inst;
+	struct { unsigned long qp:6, r1:7, :7, ar3:7, x6:6, x3:3, :1, major:4; };
+} INST64_I28;
+
+typedef union U_INST64_M28 {
+	IA64_INST inst;
+	struct { unsigned long qp:6, :14, r3:7, x6:6, x3:3, :1, major:4; };
+} INST64_M28;
+
+typedef union U_INST64_M29 {
+	IA64_INST inst;
+	struct { unsigned long qp:6, :7, r2:7, ar3:7, x6:6, x3:3, :1, major:4; };
+} INST64_M29;
+
+typedef union U_INST64_M30 {
+	IA64_INST inst;
+	struct { unsigned long qp:6, :7, imm:7, ar3:7, x4:4, x2:2,
+		x3:3, s:1, major:4; };
+} INST64_M30;
+
+typedef union U_INST64_M31 {
+	IA64_INST inst;
+	struct { unsigned long qp:6, r1:7, :7, ar3:7, x6:6, x3:3, :1, major:4; };
+} INST64_M31;
+
+typedef union U_INST64_M32 {
+	IA64_INST inst;
+	struct { unsigned long qp:6, :7, r2:7, cr3:7, x6:6, x3:3, :1, major:4; };
+} INST64_M32;
+
+typedef union U_INST64_M33 {
+	IA64_INST inst;
+	struct { unsigned long qp:6, r1:7, :7, cr3:7, x6:6, x3:3, :1, major:4; };
+} INST64_M33;
+
+typedef union U_INST64_M35 {
+	IA64_INST inst;
+	struct { unsigned long qp:6, :7, r2:7, :7, x6:6, x3:3, :1, major:4; };
+
+} INST64_M35;
+
+typedef union U_INST64_M36 {
+	IA64_INST inst;
+	struct { unsigned long qp:6, r1:7, :14, x6:6, x3:3, :1, major:4; };
+} INST64_M36;
+
+typedef union U_INST64_M37 {
+	IA64_INST inst;
+	struct { unsigned long qp:6, imm20a:20, :1, x4:4, x2:2, x3:3,
+		i:1, major:4; };
+} INST64_M37;
+
+typedef union U_INST64_M41 {
+	IA64_INST inst;
+	struct { unsigned long qp:6, :7, r2:7, :7, x6:6, x3:3, :1, major:4; };
+} INST64_M41;
+
+typedef union U_INST64_M42 {
+	IA64_INST inst;
+	struct { unsigned long qp:6, :7, r2:7, r3:7, x6:6, x3:3, :1, major:4; };
+} INST64_M42;
+
+typedef union U_INST64_M43 {
+	IA64_INST inst;
+	struct { unsigned long qp:6, r1:7, :7, r3:7, x6:6, x3:3, :1, major:4; };
+} INST64_M43;
+
+typedef union U_INST64_M44 {
+	IA64_INST inst;
+	struct { unsigned long qp:6, imm:21, x4:4, i2:2, x3:3, i:1, major:4; };
+} INST64_M44;
+
+typedef union U_INST64_M45 {
+	IA64_INST inst;
+	struct { unsigned long qp:6, :7, r2:7, r3:7, x6:6, x3:3, :1, major:4; };
+} INST64_M45;
+
+typedef union U_INST64_M46 {
+	IA64_INST inst;
+	struct { unsigned long qp:6, r1:7, un7:7, r3:7, x6:6,
+		x3:3, un1:1, major:4; };
+} INST64_M46;
+
+typedef union U_INST64_M47 {
+	IA64_INST inst;
+	struct { unsigned long qp:6, un14:14, r3:7, x6:6, x3:3, un1:1, major:4; };
+} INST64_M47;
+
+typedef union U_INST64_M1{
+	IA64_INST inst;
+	struct { unsigned long qp:6, r1:7, un7:7, r3:7, x:1, hint:2,
+		x6:6, m:1, major:4; };
+} INST64_M1;
+
+typedef union U_INST64_M2{
+	IA64_INST inst;
+	struct { unsigned long qp:6, r1:7, r2:7, r3:7, x:1, hint:2,
+		x6:6, m:1, major:4; };
+} INST64_M2;
+
+typedef union U_INST64_M3{
+	IA64_INST inst;
+	struct { unsigned long qp:6, r1:7, imm7:7, r3:7, i:1, hint:2,
+		x6:6, s:1, major:4; };
+} INST64_M3;
+
+typedef union U_INST64_M4 {
+	IA64_INST inst;
+	struct { unsigned long qp:6, un7:7, r2:7, r3:7, x:1, hint:2,
+		x6:6, m:1, major:4; };
+} INST64_M4;
+
+typedef union U_INST64_M5 {
+	IA64_INST inst;
+	struct { unsigned long qp:6, imm7:7, r2:7, r3:7, i:1, hint:2,
+		x6:6, s:1, major:4; };
+} INST64_M5;
+
+typedef union U_INST64_M6 {
+	IA64_INST inst;
+	struct { unsigned long qp:6, f1:7, un7:7, r3:7, x:1, hint:2,
+		x6:6, m:1, major:4; };
+} INST64_M6;
+
+typedef union U_INST64_M9 {
+	IA64_INST inst;
+	struct { unsigned long qp:6, :7, f2:7, r3:7, x:1, hint:2,
+		x6:6, m:1, major:4; };
+} INST64_M9;
+
+typedef union U_INST64_M10 {
+	IA64_INST inst;
+	struct { unsigned long qp:6, imm7:7, f2:7, r3:7, i:1, hint:2,
+		x6:6, s:1, major:4; };
+} INST64_M10;
+
+typedef union U_INST64_M12 {
+	IA64_INST inst;
+	struct { unsigned long qp:6, f1:7, f2:7, r3:7, x:1, hint:2,
+		x6:6, m:1, major:4; };
+} INST64_M12;
+
+typedef union U_INST64_M15 {
+	IA64_INST inst;
+	struct { unsigned long qp:6, :7, imm7:7, r3:7, i:1, hint:2,
+		x6:6, s:1, major:4; };
+} INST64_M15;
+
+typedef union U_INST64 {
+	IA64_INST inst;
+	struct { unsigned long :37, major:4; } generic;
+	INST64_A5 A5;	/* used in build_hypercall_bundle only */
+	INST64_B4 B4;	/* used in build_hypercall_bundle only */
+	INST64_B8 B8;	/* rfi, bsw.[01] */
+	INST64_B9 B9;	/* break.b */
+	INST64_I19 I19;	/* used in build_hypercall_bundle only */
+	INST64_I26 I26;	/* mov register to ar (I unit) */
+	INST64_I27 I27;	/* mov immediate to ar (I unit) */
+	INST64_I28 I28;	/* mov from ar (I unit) */
+	INST64_M1  M1;	/* ld integer */
+	INST64_M2  M2;
+	INST64_M3  M3;
+	INST64_M4  M4;	/* st integer */
+	INST64_M5  M5;
+	INST64_M6  M6;	/* ldfd floating pointer 		*/
+	INST64_M9  M9;	/* stfd floating pointer		*/
+	INST64_M10 M10;	/* stfd floating pointer		*/
+	INST64_M12 M12;     /* ldfd pair floating pointer		*/
+	INST64_M15 M15;	/* lfetch + imm update			*/
+	INST64_M28 M28;	/* purge translation cache entry	*/
+	INST64_M29 M29;	/* mov register to ar (M unit)		*/
+	INST64_M30 M30;	/* mov immediate to ar (M unit)		*/
+	INST64_M31 M31;	/* mov from ar (M unit)			*/
+	INST64_M32 M32;	/* mov reg to cr			*/
+	INST64_M33 M33;	/* mov from cr				*/
+	INST64_M35 M35;	/* mov to psr				*/
+	INST64_M36 M36;	/* mov from psr				*/
+	INST64_M37 M37;	/* break.m				*/
+	INST64_M41 M41;	/* translation cache insert		*/
+	INST64_M42 M42;	/* mov to indirect reg/translation reg insert*/
+	INST64_M43 M43;	/* mov from indirect reg		*/
+	INST64_M44 M44;	/* set/reset system mask		*/
+	INST64_M45 M45;	/* translation purge			*/
+	INST64_M46 M46;	/* translation access (tpa,tak)		*/
+	INST64_M47 M47;	/* purge translation entry		*/
+} INST64;
+
+#define MASK_41 ((unsigned long)0x1ffffffffff)
+
+/* Virtual address memory attributes encoding */
+#define VA_MATTR_WB         0x0
+#define VA_MATTR_UC         0x4
+#define VA_MATTR_UCE        0x5
+#define VA_MATTR_WC         0x6
+#define VA_MATTR_NATPAGE    0x7
+
+#define PMASK(size)         (~((size) - 1))
+#define PSIZE(size)         (1UL<<(size))
+#define CLEARLSB(ppn, nbits)    (((ppn) >> (nbits)) << (nbits))
+#define PAGEALIGN(va, ps)	CLEARLSB(va, ps)
+#define PAGE_FLAGS_RV_MASK   (0x2|(0x3UL<<50)|(((1UL<<11)-1)<<53))
+#define _PAGE_MA_ST     (0x1 <<  2) /* is reserved for software use */
+
+#define ARCH_PAGE_SHIFT   12
+
+#define INVALID_TI_TAG (1UL << 63)
+
+#define VTLB_PTE_P_BIT      0
+#define VTLB_PTE_IO_BIT     60
+#define VTLB_PTE_IO         (1UL<<VTLB_PTE_IO_BIT)
+#define VTLB_PTE_P          (1UL<<VTLB_PTE_P_BIT)
+
+#define vcpu_quick_region_check(_tr_regions,_ifa)		\
+	(_tr_regions & (1 << ((unsigned long)_ifa >> 61)))
+
+#define vcpu_quick_region_set(_tr_regions,_ifa)             \
+	do {_tr_regions |= (1 << ((unsigned long)_ifa >> 61)); } while (0)
+
+static inline void vcpu_set_tr(struct thash_data *trp, u64 pte, u64 itir,
+		u64 va, u64 rid)
+{
+	trp->page_flags = pte;
+	trp->itir = itir;
+	trp->vadr = va;
+	trp->rid = rid;
+}
+
+extern u64 kvm_lookup_mpa(u64 gpfn);
+extern u64 kvm_gpa_to_mpa(u64 gpa);
+
+/* Return I/O type if trye */
+#define __gpfn_is_io(gpfn)			\
+	({						\
+	 u64 pte, ret = 0;			\
+	 pte = kvm_lookup_mpa(gpfn);		\
+	 if (!(pte & GPFN_INV_MASK))		\
+	 ret = pte & GPFN_IO_MASK;	\
+	 ret;					\
+	 })
+
+#endif
+
+#define IA64_NO_FAULT	0
+#define IA64_FAULT	1
+
+#define VMM_RBS_OFFSET  ((VMM_TASK_SIZE + 15) & ~15)
+
+#define SW_BAD  0   /* Bad mode transitition */
+#define SW_V2P  1   /* Physical emulatino is activated */
+#define SW_P2V  2   /* Exit physical mode emulation */
+#define SW_SELF 3   /* No mode transition */
+#define SW_NOP  4   /* Mode transition, but without action required */
+
+#define GUEST_IN_PHY    0x1
+#define GUEST_PHY_EMUL  0x2
+
+#define current_vcpu ((struct kvm_vcpu *) ia64_getreg(_IA64_REG_TP))
+
+#define VRN_SHIFT	61
+#define VRN_MASK	0xe000000000000000
+#define VRN0		0x0UL
+#define VRN1		0x1UL
+#define VRN2		0x2UL
+#define VRN3		0x3UL
+#define VRN4		0x4UL
+#define VRN5		0x5UL
+#define VRN6		0x6UL
+#define VRN7		0x7UL
+
+#define IRQ_NO_MASKED         0
+#define IRQ_MASKED_BY_VTPR    1
+#define IRQ_MASKED_BY_INSVC   2   /* masked by inservice IRQ */
+
+#define PTA_BASE_SHIFT      15
+
+#define IA64_PSR_VM_BIT     46
+#define IA64_PSR_VM (__IA64_UL(1) << IA64_PSR_VM_BIT)
+
+/* Interruption Function State */
+#define IA64_IFS_V_BIT      63
+#define IA64_IFS_V  (__IA64_UL(1) << IA64_IFS_V_BIT)
+
+#define PHY_PAGE_UC (_PAGE_A|_PAGE_D|_PAGE_P|_PAGE_MA_UC|_PAGE_AR_RWX)
+#define PHY_PAGE_WB (_PAGE_A|_PAGE_D|_PAGE_P|_PAGE_MA_WB|_PAGE_AR_RWX)
+
+#ifndef __ASSEMBLY__
+
+#include <asm/gcc_intrin.h>
+
+#define is_physical_mode(v)		\
+	((v->arch.mode_flags) & GUEST_IN_PHY)
+
+#define is_virtual_mode(v)	\
+	(!is_physical_mode(v))
+
+#define MODE_IND(psr)	\
+	(((psr).it << 2) + ((psr).dt << 1) + (psr).rt)
+
+#define _vmm_raw_spin_lock(x)						\
+	do {								\
+		__u32 *ia64_spinlock_ptr = (__u32 *) (x);		\
+		__u64 ia64_spinlock_val;				\
+		ia64_spinlock_val = ia64_cmpxchg4_acq(ia64_spinlock_ptr, 1, 0);\
+		if (unlikely(ia64_spinlock_val)) {			\
+			do {						\
+				while (*ia64_spinlock_ptr)		\
+				ia64_barrier();				\
+				ia64_spinlock_val =			\
+				ia64_cmpxchg4_acq(ia64_spinlock_ptr, 1, 0);\
+			} while (ia64_spinlock_val);			\
+		}							\
+	} while (0)
+
+#define _vmm_raw_spin_unlock(x)				\
+	do { barrier();				\
+		((spinlock_t *)x)->raw_lock.lock = 0; } \
+while (0)
+
+void vmm_spin_lock(spinlock_t *lock);
+void vmm_spin_unlock(spinlock_t *lock);
+enum {
+	I_TLB = 1,
+	D_TLB = 2
+};
+
+union kvm_va {
+	struct {
+		unsigned long off : 60;		/* intra-region offset */
+		unsigned long reg :  4;		/* region number */
+	} f;
+	unsigned long l;
+	void *p;
+};
+
+#define __kvm_pa(x)     ({union kvm_va _v; _v.l = (long) (x);		\
+						_v.f.reg = 0; _v.l; })
+#define __kvm_va(x)     ({union kvm_va _v; _v.l = (long) (x);		\
+				_v.f.reg = -1; _v.p; })
+
+#define _REGION_ID(x)           ({union ia64_rr _v; _v.val = (long)(x); \
+						_v.rid; })
+#define _REGION_PAGE_SIZE(x)    ({union ia64_rr _v; _v.val = (long)(x); \
+						_v.ps; })
+#define _REGION_HW_WALKER(x)    ({union ia64_rr _v; _v.val = (long)(x);	\
+						_v.ve; })
+
+enum vhpt_ref{ DATA_REF, NA_REF, INST_REF, RSE_REF };
+enum tlb_miss_type { INSTRUCTION, DATA, REGISTER };
+
+#define VCPU(_v, _x) ((_v)->arch.vpd->_x)
+#define VMX(_v, _x)  ((_v)->arch._x)
+
+#define VLSAPIC_INSVC(vcpu, i) ((vcpu)->arch.insvc[i])
+#define VLSAPIC_XTP(_v)        VMX(_v, xtp)
+
+static inline unsigned long itir_ps(unsigned long itir)
+{
+	return ((itir >> 2) & 0x3f);
+}
+
+
+/**************************************************************************
+  VCPU control register access routines
+ **************************************************************************/
+
+static inline u64 vcpu_get_itir(struct kvm_vcpu *vcpu)
+{
+	return ((u64)VCPU(vcpu, itir));
+}
+
+static inline void vcpu_set_itir(struct kvm_vcpu *vcpu, u64 val)
+{
+	VCPU(vcpu, itir) = val;
+}
+
+static inline u64 vcpu_get_ifa(struct kvm_vcpu *vcpu)
+{
+	return ((u64)VCPU(vcpu, ifa));
+}
+
+static inline void vcpu_set_ifa(struct kvm_vcpu *vcpu, u64 val)
+{
+	VCPU(vcpu, ifa) = val;
+}
+
+static inline u64 vcpu_get_iva(struct kvm_vcpu *vcpu)
+{
+	return ((u64)VCPU(vcpu, iva));
+}
+
+static inline u64 vcpu_get_pta(struct kvm_vcpu *vcpu)
+{
+	return ((u64)VCPU(vcpu, pta));
+}
+
+static inline u64 vcpu_get_lid(struct kvm_vcpu *vcpu)
+{
+	return ((u64)VCPU(vcpu, lid));
+}
+
+static inline u64 vcpu_get_tpr(struct kvm_vcpu *vcpu)
+{
+	return ((u64)VCPU(vcpu, tpr));
+}
+
+static inline u64 vcpu_get_eoi(struct kvm_vcpu *vcpu)
+{
+	return (0UL);		/*reads of eoi always return 0 */
+}
+
+static inline u64 vcpu_get_irr0(struct kvm_vcpu *vcpu)
+{
+	return ((u64)VCPU(vcpu, irr[0]));
+}
+
+static inline u64 vcpu_get_irr1(struct kvm_vcpu *vcpu)
+{
+	return ((u64)VCPU(vcpu, irr[1]));
+}
+
+static inline u64 vcpu_get_irr2(struct kvm_vcpu *vcpu)
+{
+	return ((u64)VCPU(vcpu, irr[2]));
+}
+
+static inline u64 vcpu_get_irr3(struct kvm_vcpu *vcpu)
+{
+	return ((u64)VCPU(vcpu, irr[3]));
+}
+
+static inline void vcpu_set_dcr(struct kvm_vcpu *vcpu, u64 val)
+{
+	ia64_setreg(_IA64_REG_CR_DCR, val);
+}
+
+static inline void vcpu_set_isr(struct kvm_vcpu *vcpu, u64 val)
+{
+	VCPU(vcpu, isr) = val;
+}
+
+static inline void vcpu_set_lid(struct kvm_vcpu *vcpu, u64 val)
+{
+	VCPU(vcpu, lid) = val;
+}
+
+static inline void vcpu_set_ipsr(struct kvm_vcpu *vcpu, u64 val)
+{
+	VCPU(vcpu, ipsr) = val;
+}
+
+static inline void vcpu_set_iip(struct kvm_vcpu *vcpu, u64 val)
+{
+	VCPU(vcpu, iip) = val;
+}
+
+static inline void vcpu_set_ifs(struct kvm_vcpu *vcpu, u64 val)
+{
+	VCPU(vcpu, ifs) = val;
+}
+
+static inline void vcpu_set_iipa(struct kvm_vcpu *vcpu, u64 val)
+{
+	VCPU(vcpu, iipa) = val;
+}
+
+static inline void vcpu_set_iha(struct kvm_vcpu *vcpu, u64 val)
+{
+	VCPU(vcpu, iha) = val;
+}
+
+
+static inline u64 vcpu_get_rr(struct kvm_vcpu *vcpu, u64 reg)
+{
+	return vcpu->arch.vrr[reg>>61];
+}
+
+/**************************************************************************
+  VCPU debug breakpoint register access routines
+ **************************************************************************/
+
+static inline void vcpu_set_dbr(struct kvm_vcpu *vcpu, u64 reg, u64 val)
+{
+	__ia64_set_dbr(reg, val);
+}
+
+static inline void vcpu_set_ibr(struct kvm_vcpu *vcpu, u64 reg, u64 val)
+{
+	ia64_set_ibr(reg, val);
+}
+
+static inline u64 vcpu_get_dbr(struct kvm_vcpu *vcpu, u64 reg)
+{
+	return ((u64)__ia64_get_dbr(reg));
+}
+
+static inline u64 vcpu_get_ibr(struct kvm_vcpu *vcpu, u64 reg)
+{
+	return ((u64)ia64_get_ibr(reg));
+}
+
+/**************************************************************************
+  VCPU performance monitor register access routines
+ **************************************************************************/
+static inline void vcpu_set_pmc(struct kvm_vcpu *vcpu, u64 reg, u64 val)
+{
+	/* NOTE: Writes to unimplemented PMC registers are discarded */
+	ia64_set_pmc(reg, val);
+}
+
+static inline void vcpu_set_pmd(struct kvm_vcpu *vcpu, u64 reg, u64 val)
+{
+	/* NOTE: Writes to unimplemented PMD registers are discarded */
+	ia64_set_pmd(reg, val);
+}
+
+static inline u64 vcpu_get_pmc(struct kvm_vcpu *vcpu, u64 reg)
+{
+	/* NOTE: Reads from unimplemented PMC registers return zero */
+	return ((u64)ia64_get_pmc(reg));
+}
+
+static inline u64 vcpu_get_pmd(struct kvm_vcpu *vcpu, u64 reg)
+{
+	/* NOTE: Reads from unimplemented PMD registers return zero */
+	return ((u64)ia64_get_pmd(reg));
+}
+
+static inline unsigned long vrrtomrr(unsigned long val)
+{
+	union ia64_rr rr;
+	rr.val = val;
+	rr.rid = (rr.rid << 4) | 0xe;
+	if (rr.ps > PAGE_SHIFT)
+		rr.ps = PAGE_SHIFT;
+	rr.ve = 1;
+	return rr.val;
+}
+
+
+static inline int highest_bits(int *dat)
+{
+	u32  bits, bitnum;
+	int i;
+
+	/* loop for all 256 bits */
+	for (i = 7; i >= 0 ; i--) {
+		bits = dat[i];
+		if (bits) {
+			bitnum = fls(bits);
+			return i * 32 + bitnum - 1;
+		}
+	}
+	return NULL_VECTOR;
+}
+
+/*
+ * The pending irq is higher than the inservice one.
+ *
+ */
+static inline int is_higher_irq(int pending, int inservice)
+{
+	return ((pending > inservice)
+			|| ((pending != NULL_VECTOR)
+				&& (inservice == NULL_VECTOR)));
+}
+
+static inline int is_higher_class(int pending, int mic)
+{
+	return ((pending >> 4) > mic);
+}
+
+/*
+ * Return 0-255 for pending irq.
+ *        NULL_VECTOR: when no pending.
+ */
+static inline int highest_pending_irq(struct kvm_vcpu *vcpu)
+{
+	if (VCPU(vcpu, irr[0]) & (1UL<<NMI_VECTOR))
+		return NMI_VECTOR;
+	if (VCPU(vcpu, irr[0]) & (1UL<<ExtINT_VECTOR))
+		return ExtINT_VECTOR;
+
+	return highest_bits((int *)&VCPU(vcpu, irr[0]));
+}
+
+static inline int highest_inservice_irq(struct kvm_vcpu *vcpu)
+{
+	if (VMX(vcpu, insvc[0]) & (1UL<<NMI_VECTOR))
+		return NMI_VECTOR;
+	if (VMX(vcpu, insvc[0]) & (1UL<<ExtINT_VECTOR))
+		return ExtINT_VECTOR;
+
+	return highest_bits((int *)&(VMX(vcpu, insvc[0])));
+}
+
+extern void vcpu_get_fpreg(struct kvm_vcpu *vcpu, u64 reg,
+					struct ia64_fpreg *val);
+extern void vcpu_set_fpreg(struct kvm_vcpu *vcpu, u64 reg,
+					struct ia64_fpreg *val);
+extern u64 vcpu_get_gr(struct kvm_vcpu *vcpu, u64 reg);
+extern void vcpu_set_gr(struct kvm_vcpu *vcpu, u64 reg, u64 val, int nat);
+extern u64 vcpu_get_psr(struct kvm_vcpu *vcpu);
+extern void vcpu_set_psr(struct kvm_vcpu *vcpu, u64 val);
+extern u64 vcpu_thash(struct kvm_vcpu *vcpu, u64 vadr);
+extern void vcpu_bsw0(struct kvm_vcpu *vcpu);
+extern void thash_vhpt_insert(struct kvm_vcpu *v, u64 pte,
+					u64 itir, u64 va, int type);
+extern struct thash_data *vhpt_lookup(u64 va);
+extern u64 guest_vhpt_lookup(u64 iha, u64 *pte);
+extern void thash_purge_entries(struct kvm_vcpu *v, u64 va, u64 ps);
+extern void thash_purge_entries_remote(struct kvm_vcpu *v, u64 va, u64 ps);
+extern u64 translate_phy_pte(u64 *pte, u64 itir, u64 va);
+extern int thash_purge_and_insert(struct kvm_vcpu *v, u64 pte,
+		u64 itir, u64 ifa, int type);
+extern void thash_purge_all(struct kvm_vcpu *v);
+extern struct thash_data *vtlb_lookup(struct kvm_vcpu *v,
+						u64 va, int is_data);
+extern int vtr_find_overlap(struct kvm_vcpu *vcpu, u64 va,
+						u64 ps, int is_data);
+
+extern void vcpu_increment_iip(struct kvm_vcpu *v);
+extern void vcpu_decrement_iip(struct kvm_vcpu *vcpu);
+extern void vcpu_pend_interrupt(struct kvm_vcpu *vcpu, u8 vec);
+extern void vcpu_unpend_interrupt(struct kvm_vcpu *vcpu, u8 vec);
+extern void data_page_not_present(struct kvm_vcpu *vcpu, u64 vadr);
+extern void dnat_page_consumption(struct kvm_vcpu *vcpu, u64 vadr);
+extern void alt_dtlb(struct kvm_vcpu *vcpu, u64 vadr);
+extern void nested_dtlb(struct kvm_vcpu *vcpu);
+extern void dvhpt_fault(struct kvm_vcpu *vcpu, u64 vadr);
+extern int vhpt_enabled(struct kvm_vcpu *vcpu, u64 vadr, enum vhpt_ref ref);
+
+extern void update_vhpi(struct kvm_vcpu *vcpu, int vec);
+extern int irq_masked(struct kvm_vcpu *vcpu, int h_pending, int h_inservice);
+
+extern int fetch_code(struct kvm_vcpu *vcpu, u64 gip, IA64_BUNDLE *pbundle);
+extern void emulate_io_inst(struct kvm_vcpu *vcpu, u64 padr, u64 ma);
+extern void vmm_transition(struct kvm_vcpu *vcpu);
+extern void vmm_trampoline(union context *from, union context *to);
+extern int vmm_entry(void);
+extern  u64 vcpu_get_itc(struct kvm_vcpu *vcpu);
+
+extern void vmm_reset_entry(void);
+void kvm_init_vtlb(struct kvm_vcpu *v);
+void kvm_init_vhpt(struct kvm_vcpu *v);
+void thash_init(struct thash_cb *hcb, u64 sz);
+
+void panic_vm(struct kvm_vcpu *v);
+
+extern u64 ia64_call_vsa(u64 proc, u64 arg1, u64 arg2, u64 arg3,
+		u64 arg4, u64 arg5, u64 arg6, u64 arg7);
+#endif
+#endif	/* __VCPU_H__ */
diff --git a/arch/ia64/kvm/vti.h b/arch/ia64/kvm/vti.h
new file mode 100644
index 0000000..f6c5617
--- /dev/null
+++ b/arch/ia64/kvm/vti.h
@@ -0,0 +1,290 @@
+/*
+ * vti.h: prototype for generial vt related interface
+ *   	Copyright (c) 2004, Intel Corporation.
+ *
+ *	Xuefei Xu (Anthony Xu) (anthony.xu@intel.com)
+ *	Fred Yang (fred.yang@intel.com)
+ * 	Kun Tian (Kevin Tian) (kevin.tian@intel.com)
+ *
+ *  	Copyright (c) 2007, Intel Corporation.
+ *  	Zhang xiantao <xiantao.zhang@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
+ * Place - Suite 330, Boston, MA 02111-1307 USA.
+ */
+#ifndef _KVM_VT_I_H
+#define _KVM_VT_I_H
+
+#ifndef __ASSEMBLY__
+#include <asm/page.h>
+
+#include <linux/kvm_host.h>
+
+/* define itr.i and itr.d  in ia64_itr function */
+#define	ITR	0x01
+#define	DTR	0x02
+#define	IaDTR	0x03
+
+#define IA64_TR_VMM       6 /*itr6, dtr6 : maps vmm code, vmbuffer*/
+#define IA64_TR_VM_DATA   7 /*dtr7       : maps current vm data*/
+
+#define RR6 (6UL<<61)
+#define RR7 (7UL<<61)
+
+
+/* config_options in pal_vp_init_env */
+#define	VP_INITIALIZE	1UL
+#define	VP_FR_PMC	1UL<<1
+#define	VP_OPCODE	1UL<<8
+#define	VP_CAUSE	1UL<<9
+#define VP_FW_ACC   	1UL<<63
+
+/* init vp env with initializing vm_buffer */
+#define	VP_INIT_ENV_INITALIZE  (VP_INITIALIZE | VP_FR_PMC |\
+	VP_OPCODE | VP_CAUSE | VP_FW_ACC)
+/* init vp env without initializing vm_buffer */
+#define	VP_INIT_ENV  VP_FR_PMC | VP_OPCODE | VP_CAUSE | VP_FW_ACC
+
+#define		PAL_VP_CREATE   265
+/* Stacked Virt. Initializes a new VPD for the operation of
+ * a new virtual processor in the virtual environment.
+ */
+#define		PAL_VP_ENV_INFO 266
+/*Stacked Virt. Returns the parameters needed to enter a virtual environment.*/
+#define		PAL_VP_EXIT_ENV 267
+/*Stacked Virt. Allows a logical processor to exit a virtual environment.*/
+#define		PAL_VP_INIT_ENV 268
+/*Stacked Virt. Allows a logical processor to enter a virtual environment.*/
+#define		PAL_VP_REGISTER 269
+/*Stacked Virt. Register a different host IVT for the virtual processor.*/
+#define		PAL_VP_RESUME   270
+/* Renamed from PAL_VP_RESUME */
+#define		PAL_VP_RESTORE  270
+/*Stacked Virt. Resumes virtual processor operation on the logical processor.*/
+#define		PAL_VP_SUSPEND  271
+/* Renamed from PAL_VP_SUSPEND */
+#define		PAL_VP_SAVE	271
+/* Stacked Virt. Suspends operation for the specified virtual processor on
+ * the logical processor.
+ */
+#define		PAL_VP_TERMINATE 272
+/* Stacked Virt. Terminates operation for the specified virtual processor.*/
+
+union vac {
+	unsigned long value;
+	struct {
+		int a_int:1;
+		int a_from_int_cr:1;
+		int a_to_int_cr:1;
+		int a_from_psr:1;
+		int a_from_cpuid:1;
+		int a_cover:1;
+		int a_bsw:1;
+		long reserved:57;
+	};
+};
+
+union vdc {
+	unsigned long value;
+	struct {
+		int d_vmsw:1;
+		int d_extint:1;
+		int d_ibr_dbr:1;
+		int d_pmc:1;
+		int d_to_pmd:1;
+		int d_itm:1;
+		long reserved:58;
+	};
+};
+
+struct vpd {
+	union vac   vac;
+	union vdc   vdc;
+	unsigned long  virt_env_vaddr;
+	unsigned long  reserved1[29];
+	unsigned long  vhpi;
+	unsigned long  reserved2[95];
+	unsigned long  vgr[16];
+	unsigned long  vbgr[16];
+	unsigned long  vnat;
+	unsigned long  vbnat;
+	unsigned long  vcpuid[5];
+	unsigned long  reserved3[11];
+	unsigned long  vpsr;
+	unsigned long  vpr;
+	unsigned long  reserved4[76];
+	union {
+		unsigned long  vcr[128];
+		struct {
+			unsigned long dcr;
+			unsigned long itm;
+			unsigned long iva;
+			unsigned long rsv1[5];
+			unsigned long pta;
+			unsigned long rsv2[7];
+			unsigned long ipsr;
+			unsigned long isr;
+			unsigned long rsv3;
+			unsigned long iip;
+			unsigned long ifa;
+			unsigned long itir;
+			unsigned long iipa;
+			unsigned long ifs;
+			unsigned long iim;
+			unsigned long iha;
+			unsigned long rsv4[38];
+			unsigned long lid;
+			unsigned long ivr;
+			unsigned long tpr;
+			unsigned long eoi;
+			unsigned long irr[4];
+			unsigned long itv;
+			unsigned long pmv;
+			unsigned long cmcv;
+			unsigned long rsv5[5];
+			unsigned long lrr0;
+			unsigned long lrr1;
+			unsigned long rsv6[46];
+		};
+	};
+	unsigned long  reserved5[128];
+	unsigned long  reserved6[3456];
+	unsigned long  vmm_avail[128];
+	unsigned long  reserved7[4096];
+};
+
+#define PAL_PROC_VM_BIT		(1UL << 40)
+#define PAL_PROC_VMSW_BIT	(1UL << 54)
+
+static inline s64 ia64_pal_vp_env_info(u64 *buffer_size,
+		u64 *vp_env_info)
+{
+	struct ia64_pal_retval iprv;
+	PAL_CALL_STK(iprv, PAL_VP_ENV_INFO, 0, 0, 0);
+	*buffer_size = iprv.v0;
+	*vp_env_info = iprv.v1;
+	return iprv.status;
+}
+
+static inline s64 ia64_pal_vp_exit_env(u64 iva)
+{
+	struct ia64_pal_retval iprv;
+
+	PAL_CALL_STK(iprv, PAL_VP_EXIT_ENV, (u64)iva, 0, 0);
+	return iprv.status;
+}
+
+static inline s64 ia64_pal_vp_init_env(u64 config_options, u64 pbase_addr,
+			u64 vbase_addr, u64 *vsa_base)
+{
+	struct ia64_pal_retval iprv;
+
+	PAL_CALL_STK(iprv, PAL_VP_INIT_ENV, config_options, pbase_addr,
+			vbase_addr);
+	*vsa_base = iprv.v0;
+
+	return iprv.status;
+}
+
+static inline s64 ia64_pal_vp_restore(u64 *vpd, u64 pal_proc_vector)
+{
+	struct ia64_pal_retval iprv;
+
+	PAL_CALL_STK(iprv, PAL_VP_RESTORE, (u64)vpd, pal_proc_vector, 0);
+
+	return iprv.status;
+}
+
+static inline s64 ia64_pal_vp_save(u64 *vpd, u64 pal_proc_vector)
+{
+	struct ia64_pal_retval iprv;
+
+	PAL_CALL_STK(iprv, PAL_VP_SAVE, (u64)vpd, pal_proc_vector, 0);
+
+	return iprv.status;
+}
+
+#endif
+
+/*VPD field offset*/
+#define VPD_VAC_START_OFFSET		0
+#define VPD_VDC_START_OFFSET		8
+#define VPD_VHPI_START_OFFSET		256
+#define VPD_VGR_START_OFFSET		1024
+#define VPD_VBGR_START_OFFSET		1152
+#define VPD_VNAT_START_OFFSET		1280
+#define VPD_VBNAT_START_OFFSET		1288
+#define VPD_VCPUID_START_OFFSET		1296
+#define VPD_VPSR_START_OFFSET		1424
+#define VPD_VPR_START_OFFSET		1432
+#define VPD_VRSE_CFLE_START_OFFSET	1440
+#define VPD_VCR_START_OFFSET		2048
+#define VPD_VTPR_START_OFFSET		2576
+#define VPD_VRR_START_OFFSET		3072
+#define VPD_VMM_VAIL_START_OFFSET	31744
+
+/*Virtualization faults*/
+
+#define EVENT_MOV_TO_AR			 1
+#define EVENT_MOV_TO_AR_IMM		 2
+#define EVENT_MOV_FROM_AR		 3
+#define EVENT_MOV_TO_CR			 4
+#define EVENT_MOV_FROM_CR		 5
+#define EVENT_MOV_TO_PSR		 6
+#define EVENT_MOV_FROM_PSR		 7
+#define EVENT_ITC_D			 8
+#define EVENT_ITC_I			 9
+#define EVENT_MOV_TO_RR			 10
+#define EVENT_MOV_TO_DBR		 11
+#define EVENT_MOV_TO_IBR		 12
+#define EVENT_MOV_TO_PKR		 13
+#define EVENT_MOV_TO_PMC		 14
+#define EVENT_MOV_TO_PMD		 15
+#define EVENT_ITR_D			 16
+#define EVENT_ITR_I			 17
+#define EVENT_MOV_FROM_RR		 18
+#define EVENT_MOV_FROM_DBR		 19
+#define EVENT_MOV_FROM_IBR		 20
+#define EVENT_MOV_FROM_PKR		 21
+#define EVENT_MOV_FROM_PMC		 22
+#define EVENT_MOV_FROM_CPUID		 23
+#define EVENT_SSM			 24
+#define EVENT_RSM			 25
+#define EVENT_PTC_L			 26
+#define EVENT_PTC_G			 27
+#define EVENT_PTC_GA			 28
+#define EVENT_PTR_D			 29
+#define EVENT_PTR_I			 30
+#define EVENT_THASH			 31
+#define EVENT_TTAG			 32
+#define EVENT_TPA			 33
+#define EVENT_TAK			 34
+#define EVENT_PTC_E			 35
+#define EVENT_COVER			 36
+#define EVENT_RFI			 37
+#define EVENT_BSW_0			 38
+#define EVENT_BSW_1			 39
+#define EVENT_VMSW			 40
+
+/**PAL virtual services offsets */
+#define PAL_VPS_RESUME_NORMAL           0x0000
+#define PAL_VPS_RESUME_HANDLER          0x0400
+#define PAL_VPS_SYNC_READ               0x0800
+#define PAL_VPS_SYNC_WRITE              0x0c00
+#define PAL_VPS_SET_PENDING_INTERRUPT   0x1000
+#define PAL_VPS_THASH                   0x1400
+#define PAL_VPS_TTAG                    0x1800
+#define PAL_VPS_RESTORE                 0x1c00
+#define PAL_VPS_SAVE                    0x2000
+
+#endif/* _VT_I_H*/
-- 
1.5.5

