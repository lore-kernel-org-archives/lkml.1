Return-Path: <linux-kernel-owner+w=401wt.eu-S1760512AbZB0Kjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760512AbZB0Kjq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 05:39:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758205AbZB0K2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 05:28:37 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53573 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755404AbZB0K1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 05:27:10 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 08/37] KVM: ppc: E500 core-specific code
Date: Fri, 27 Feb 2009 12:26:31 +0200
Message-Id: <1235730420-7929-9-git-send-email-avi@redhat.com>
In-Reply-To: <1235730420-7929-1-git-send-email-avi@redhat.com>
References: <1235730420-7929-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hollis Blanchard <hollisb@us.ibm.com>

Signed-off-by: Liu Yu <yu.liu@freescale.com>
Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/include/asm/kvm_e500.h |   67 ++++
 arch/powerpc/kvm/Kconfig            |   13 +
 arch/powerpc/kvm/Makefile           |    9 +
 arch/powerpc/kvm/e500.c             |  151 +++++++
 arch/powerpc/kvm/e500_emulate.c     |  169 ++++++++
 arch/powerpc/kvm/e500_tlb.c         |  737 +++++++++++++++++++++++++++++++++++
 arch/powerpc/kvm/e500_tlb.h         |  184 +++++++++
 7 files changed, 1330 insertions(+), 0 deletions(-)
 create mode 100644 arch/powerpc/include/asm/kvm_e500.h
 create mode 100644 arch/powerpc/kvm/e500.c
 create mode 100644 arch/powerpc/kvm/e500_emulate.c
 create mode 100644 arch/powerpc/kvm/e500_tlb.c
 create mode 100644 arch/powerpc/kvm/e500_tlb.h

diff --git a/arch/powerpc/include/asm/kvm_e500.h b/arch/powerpc/include/asm/kvm_e500.h
new file mode 100644
index 0000000..9d497ce
--- /dev/null
+++ b/arch/powerpc/include/asm/kvm_e500.h
@@ -0,0 +1,67 @@
+/*
+ * Copyright (C) 2008 Freescale Semiconductor, Inc. All rights reserved.
+ *
+ * Author: Yu Liu, <yu.liu@freescale.com>
+ *
+ * Description:
+ * This file is derived from arch/powerpc/include/asm/kvm_44x.h,
+ * by Hollis Blanchard <hollisb@us.ibm.com>.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __ASM_KVM_E500_H__
+#define __ASM_KVM_E500_H__
+
+#include <linux/kvm_host.h>
+
+#define BOOKE_INTERRUPT_SIZE 36
+
+#define E500_PID_NUM   3
+#define E500_TLB_NUM   2
+
+struct tlbe{
+	u32 mas1;
+	u32 mas2;
+	u32 mas3;
+	u32 mas7;
+};
+
+struct kvmppc_vcpu_e500 {
+	/* Unmodified copy of the guest's TLB. */
+	struct tlbe *guest_tlb[E500_TLB_NUM];
+	/* TLB that's actually used when the guest is running. */
+	struct tlbe *shadow_tlb[E500_TLB_NUM];
+	/* Pages which are referenced in the shadow TLB. */
+	struct page **shadow_pages[E500_TLB_NUM];
+
+	unsigned int guest_tlb_size[E500_TLB_NUM];
+	unsigned int shadow_tlb_size[E500_TLB_NUM];
+	unsigned int guest_tlb_nv[E500_TLB_NUM];
+
+	u32 host_pid[E500_PID_NUM];
+	u32 pid[E500_PID_NUM];
+
+	u32 mas0;
+	u32 mas1;
+	u32 mas2;
+	u32 mas3;
+	u32 mas4;
+	u32 mas5;
+	u32 mas6;
+	u32 mas7;
+	u32 l1csr1;
+	u32 hid0;
+	u32 hid1;
+
+	struct kvm_vcpu vcpu;
+};
+
+static inline struct kvmppc_vcpu_e500 *to_e500(struct kvm_vcpu *vcpu)
+{
+	return container_of(vcpu, struct kvmppc_vcpu_e500, vcpu);
+}
+
+#endif /* __ASM_KVM_E500_H__ */
diff --git a/arch/powerpc/kvm/Kconfig b/arch/powerpc/kvm/Kconfig
index 6dbdc48..1465705 100644
--- a/arch/powerpc/kvm/Kconfig
+++ b/arch/powerpc/kvm/Kconfig
@@ -43,6 +43,19 @@ config KVM_EXIT_TIMING
 
 	  If unsure, say N.
 
+config KVM_E500
+	bool "KVM support for PowerPC E500 processors"
+	depends on EXPERIMENTAL && E500
+	select KVM
+	---help---
+	  Support running unmodified E500 guest kernels in virtual machines on
+	  E500 host processors.
+
+	  This module provides access to the hardware capabilities through
+	  a character device node named /dev/kvm.
+
+	  If unsure, say N.
+
 config KVM_TRACE
 	bool "KVM trace support"
 	depends on KVM && MARKERS && SYSFS
diff --git a/arch/powerpc/kvm/Makefile b/arch/powerpc/kvm/Makefile
index 3ef5261..4b2df66 100644
--- a/arch/powerpc/kvm/Makefile
+++ b/arch/powerpc/kvm/Makefile
@@ -22,3 +22,12 @@ kvm-440-objs := \
 	44x_tlb.o \
 	44x_emulate.o
 obj-$(CONFIG_KVM_440) += kvm-440.o
+
+kvm-e500-objs := \
+	booke.o \
+	booke_emulate.o \
+	booke_interrupts.o \
+	e500.o \
+	e500_tlb.o \
+	e500_emulate.o
+obj-$(CONFIG_KVM_E500) += kvm-e500.o
diff --git a/arch/powerpc/kvm/e500.c b/arch/powerpc/kvm/e500.c
new file mode 100644
index 0000000..7992da4
--- /dev/null
+++ b/arch/powerpc/kvm/e500.c
@@ -0,0 +1,151 @@
+/*
+ * Copyright (C) 2008 Freescale Semiconductor, Inc. All rights reserved.
+ *
+ * Author: Yu Liu, <yu.liu@freescale.com>
+ *
+ * Description:
+ * This file is derived from arch/powerpc/kvm/44x.c,
+ * by Hollis Blanchard <hollisb@us.ibm.com>.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kvm_host.h>
+#include <linux/err.h>
+
+#include <asm/reg.h>
+#include <asm/cputable.h>
+#include <asm/tlbflush.h>
+#include <asm/kvm_e500.h>
+#include <asm/kvm_ppc.h>
+
+#include "e500_tlb.h"
+
+void kvmppc_core_load_host_debugstate(struct kvm_vcpu *vcpu)
+{
+}
+
+void kvmppc_core_load_guest_debugstate(struct kvm_vcpu *vcpu)
+{
+}
+
+void kvmppc_core_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
+{
+	kvmppc_e500_tlb_load(vcpu, cpu);
+}
+
+void kvmppc_core_vcpu_put(struct kvm_vcpu *vcpu)
+{
+	kvmppc_e500_tlb_put(vcpu);
+}
+
+int kvmppc_core_check_processor_compat(void)
+{
+	int r;
+
+	if (strcmp(cur_cpu_spec->cpu_name, "e500v2") == 0)
+		r = 0;
+	else
+		r = -ENOTSUPP;
+
+	return r;
+}
+
+int kvmppc_core_vcpu_setup(struct kvm_vcpu *vcpu)
+{
+	struct kvmppc_vcpu_e500 *vcpu_e500 = to_e500(vcpu);
+
+	kvmppc_e500_tlb_setup(vcpu_e500);
+
+	/* Use the same core vertion as host's */
+	vcpu->arch.pvr = mfspr(SPRN_PVR);
+
+	return 0;
+}
+
+/* 'linear_address' is actually an encoding of AS|PID|EADDR . */
+int kvmppc_core_vcpu_translate(struct kvm_vcpu *vcpu,
+                               struct kvm_translation *tr)
+{
+	int index;
+	gva_t eaddr;
+	u8 pid;
+	u8 as;
+
+	eaddr = tr->linear_address;
+	pid = (tr->linear_address >> 32) & 0xff;
+	as = (tr->linear_address >> 40) & 0x1;
+
+	index = kvmppc_e500_tlb_search(vcpu, eaddr, pid, as);
+	if (index < 0) {
+		tr->valid = 0;
+		return 0;
+	}
+
+	tr->physical_address = kvmppc_mmu_xlate(vcpu, index, eaddr);
+	/* XXX what does "writeable" and "usermode" even mean? */
+	tr->valid = 1;
+
+	return 0;
+}
+
+struct kvm_vcpu *kvmppc_core_vcpu_create(struct kvm *kvm, unsigned int id)
+{
+	struct kvmppc_vcpu_e500 *vcpu_e500;
+	struct kvm_vcpu *vcpu;
+	int err;
+
+	vcpu_e500 = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL);
+	if (!vcpu_e500) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	vcpu = &vcpu_e500->vcpu;
+	err = kvm_vcpu_init(vcpu, kvm, id);
+	if (err)
+		goto free_vcpu;
+
+	err = kvmppc_e500_tlb_init(vcpu_e500);
+	if (err)
+		goto uninit_vcpu;
+
+	return vcpu;
+
+uninit_vcpu:
+	kvm_vcpu_uninit(vcpu);
+free_vcpu:
+	kmem_cache_free(kvm_vcpu_cache, vcpu_e500);
+out:
+	return ERR_PTR(err);
+}
+
+void kvmppc_core_vcpu_free(struct kvm_vcpu *vcpu)
+{
+	struct kvmppc_vcpu_e500 *vcpu_e500 = to_e500(vcpu);
+
+	kvmppc_e500_tlb_uninit(vcpu_e500);
+	kvm_vcpu_uninit(vcpu);
+	kmem_cache_free(kvm_vcpu_cache, vcpu_e500);
+}
+
+static int kvmppc_e500_init(void)
+{
+	int r;
+
+	r = kvmppc_booke_init();
+	if (r)
+		return r;
+
+	return kvm_init(NULL, sizeof(struct kvmppc_vcpu_e500), THIS_MODULE);
+}
+
+static void kvmppc_e500_exit(void)
+{
+	kvmppc_booke_exit();
+}
+
+module_init(kvmppc_e500_init);
+module_exit(kvmppc_e500_exit);
diff --git a/arch/powerpc/kvm/e500_emulate.c b/arch/powerpc/kvm/e500_emulate.c
new file mode 100644
index 0000000..a47f44c
--- /dev/null
+++ b/arch/powerpc/kvm/e500_emulate.c
@@ -0,0 +1,169 @@
+/*
+ * Copyright (C) 2008 Freescale Semiconductor, Inc. All rights reserved.
+ *
+ * Author: Yu Liu, <yu.liu@freescale.com>
+ *
+ * Description:
+ * This file is derived from arch/powerpc/kvm/44x_emulate.c,
+ * by Hollis Blanchard <hollisb@us.ibm.com>.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ */
+
+#include <asm/kvm_ppc.h>
+#include <asm/disassemble.h>
+#include <asm/kvm_e500.h>
+
+#include "booke.h"
+#include "e500_tlb.h"
+
+#define XOP_TLBIVAX 786
+#define XOP_TLBSX   914
+#define XOP_TLBRE   946
+#define XOP_TLBWE   978
+
+int kvmppc_core_emulate_op(struct kvm_run *run, struct kvm_vcpu *vcpu,
+                           unsigned int inst, int *advance)
+{
+	int emulated = EMULATE_DONE;
+	int ra;
+	int rb;
+	int rs;
+	int rt;
+
+	switch (get_op(inst)) {
+	case 31:
+		switch (get_xop(inst)) {
+
+		case XOP_TLBRE:
+			emulated = kvmppc_e500_emul_tlbre(vcpu);
+			break;
+
+		case XOP_TLBWE:
+			emulated = kvmppc_e500_emul_tlbwe(vcpu);
+			break;
+
+		case XOP_TLBSX:
+			rb = get_rb(inst);
+			emulated = kvmppc_e500_emul_tlbsx(vcpu,rb);
+			break;
+
+		case XOP_TLBIVAX:
+			ra = get_ra(inst);
+			rb = get_rb(inst);
+			emulated = kvmppc_e500_emul_tlbivax(vcpu, ra, rb);
+			break;
+
+		default:
+			emulated = EMULATE_FAIL;
+		}
+
+		break;
+
+	default:
+		emulated = EMULATE_FAIL;
+	}
+
+	if (emulated == EMULATE_FAIL)
+		emulated = kvmppc_booke_emulate_op(run, vcpu, inst, advance);
+
+	return emulated;
+}
+
+int kvmppc_core_emulate_mtspr(struct kvm_vcpu *vcpu, int sprn, int rs)
+{
+	struct kvmppc_vcpu_e500 *vcpu_e500 = to_e500(vcpu);
+	int emulated = EMULATE_DONE;
+
+	switch (sprn) {
+	case SPRN_PID:
+		vcpu_e500->pid[0] = vcpu->arch.shadow_pid =
+			vcpu->arch.pid = vcpu->arch.gpr[rs];
+		break;
+	case SPRN_PID1:
+		vcpu_e500->pid[1] = vcpu->arch.gpr[rs]; break;
+	case SPRN_PID2:
+		vcpu_e500->pid[2] = vcpu->arch.gpr[rs]; break;
+	case SPRN_MAS0:
+		vcpu_e500->mas0 = vcpu->arch.gpr[rs]; break;
+	case SPRN_MAS1:
+		vcpu_e500->mas1 = vcpu->arch.gpr[rs]; break;
+	case SPRN_MAS2:
+		vcpu_e500->mas2 = vcpu->arch.gpr[rs]; break;
+	case SPRN_MAS3:
+		vcpu_e500->mas3 = vcpu->arch.gpr[rs]; break;
+	case SPRN_MAS4:
+		vcpu_e500->mas4 = vcpu->arch.gpr[rs]; break;
+	case SPRN_MAS6:
+		vcpu_e500->mas6 = vcpu->arch.gpr[rs]; break;
+	case SPRN_MAS7:
+		vcpu_e500->mas7 = vcpu->arch.gpr[rs]; break;
+	case SPRN_L1CSR1:
+		vcpu_e500->l1csr1 = vcpu->arch.gpr[rs]; break;
+	case SPRN_HID0:
+		vcpu_e500->hid0 = vcpu->arch.gpr[rs]; break;
+	case SPRN_HID1:
+		vcpu_e500->hid1 = vcpu->arch.gpr[rs]; break;
+
+	default:
+		emulated = kvmppc_booke_emulate_mtspr(vcpu, sprn, rs);
+	}
+
+	return emulated;
+}
+
+int kvmppc_core_emulate_mfspr(struct kvm_vcpu *vcpu, int sprn, int rt)
+{
+	struct kvmppc_vcpu_e500 *vcpu_e500 = to_e500(vcpu);
+	int emulated = EMULATE_DONE;
+
+	switch (sprn) {
+	case SPRN_PID:
+		vcpu->arch.gpr[rt] = vcpu_e500->pid[0]; break;
+	case SPRN_PID1:
+		vcpu->arch.gpr[rt] = vcpu_e500->pid[1]; break;
+	case SPRN_PID2:
+		vcpu->arch.gpr[rt] = vcpu_e500->pid[2]; break;
+	case SPRN_MAS0:
+		vcpu->arch.gpr[rt] = vcpu_e500->mas0; break;
+	case SPRN_MAS1:
+		vcpu->arch.gpr[rt] = vcpu_e500->mas1; break;
+	case SPRN_MAS2:
+		vcpu->arch.gpr[rt] = vcpu_e500->mas2; break;
+	case SPRN_MAS3:
+		vcpu->arch.gpr[rt] = vcpu_e500->mas3; break;
+	case SPRN_MAS4:
+		vcpu->arch.gpr[rt] = vcpu_e500->mas4; break;
+	case SPRN_MAS6:
+		vcpu->arch.gpr[rt] = vcpu_e500->mas6; break;
+	case SPRN_MAS7:
+		vcpu->arch.gpr[rt] = vcpu_e500->mas7; break;
+
+	case SPRN_TLB0CFG:
+		vcpu->arch.gpr[rt] = mfspr(SPRN_TLB0CFG);
+		vcpu->arch.gpr[rt] &= ~0xfffUL;
+		vcpu->arch.gpr[rt] |= vcpu_e500->guest_tlb_size[0];
+		break;
+
+	case SPRN_TLB1CFG:
+		vcpu->arch.gpr[rt] = mfspr(SPRN_TLB1CFG);
+		vcpu->arch.gpr[rt] &= ~0xfffUL;
+		vcpu->arch.gpr[rt] |= vcpu_e500->guest_tlb_size[1];
+		break;
+
+	case SPRN_L1CSR1:
+		vcpu->arch.gpr[rt] = vcpu_e500->l1csr1; break;
+	case SPRN_HID0:
+		vcpu->arch.gpr[rt] = vcpu_e500->hid0; break;
+	case SPRN_HID1:
+		vcpu->arch.gpr[rt] = vcpu_e500->hid1; break;
+
+	default:
+		emulated = kvmppc_booke_emulate_mfspr(vcpu, sprn, rt);
+	}
+
+	return emulated;
+}
+
diff --git a/arch/powerpc/kvm/e500_tlb.c b/arch/powerpc/kvm/e500_tlb.c
new file mode 100644
index 0000000..6a50340
--- /dev/null
+++ b/arch/powerpc/kvm/e500_tlb.c
@@ -0,0 +1,737 @@
+/*
+ * Copyright (C) 2008 Freescale Semiconductor, Inc. All rights reserved.
+ *
+ * Author: Yu Liu, yu.liu@freescale.com
+ *
+ * Description:
+ * This file is based on arch/powerpc/kvm/44x_tlb.c,
+ * by Hollis Blanchard <hollisb@us.ibm.com>.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/types.h>
+#include <linux/string.h>
+#include <linux/kvm.h>
+#include <linux/kvm_host.h>
+#include <linux/highmem.h>
+#include <asm/kvm_ppc.h>
+#include <asm/kvm_e500.h>
+
+#include "e500_tlb.h"
+
+#define to_htlb1_esel(esel) (tlb1_entry_num - (esel) - 1)
+
+static unsigned int tlb1_entry_num;
+
+void kvmppc_dump_tlbs(struct kvm_vcpu *vcpu)
+{
+	struct kvmppc_vcpu_e500 *vcpu_e500 = to_e500(vcpu);
+	struct tlbe *tlbe;
+	int i, tlbsel;
+
+	printk("| %8s | %8s | %8s | %8s | %8s |\n",
+			"nr", "mas1", "mas2", "mas3", "mas7");
+
+	for (tlbsel = 0; tlbsel < 2; tlbsel++) {
+		printk("Guest TLB%d:\n", tlbsel);
+		for (i = 0; i < vcpu_e500->guest_tlb_size[tlbsel]; i++) {
+			tlbe = &vcpu_e500->guest_tlb[tlbsel][i];
+			if (tlbe->mas1 & MAS1_VALID)
+				printk(" G[%d][%3d] |  %08X | %08X | %08X | %08X |\n",
+					tlbsel, i, tlbe->mas1, tlbe->mas2,
+					tlbe->mas3, tlbe->mas7);
+		}
+	}
+
+	for (tlbsel = 0; tlbsel < 2; tlbsel++) {
+		printk("Shadow TLB%d:\n", tlbsel);
+		for (i = 0; i < vcpu_e500->shadow_tlb_size[tlbsel]; i++) {
+			tlbe = &vcpu_e500->shadow_tlb[tlbsel][i];
+			if (tlbe->mas1 & MAS1_VALID)
+				printk(" S[%d][%3d] |  %08X | %08X | %08X | %08X |\n",
+					tlbsel, i, tlbe->mas1, tlbe->mas2,
+					tlbe->mas3, tlbe->mas7);
+		}
+	}
+}
+
+static inline unsigned int tlb0_get_next_victim(
+		struct kvmppc_vcpu_e500 *vcpu_e500)
+{
+	unsigned int victim;
+
+	victim = vcpu_e500->guest_tlb_nv[0]++;
+	if (unlikely(vcpu_e500->guest_tlb_nv[0] >= KVM_E500_TLB0_WAY_NUM))
+		vcpu_e500->guest_tlb_nv[0] = 0;
+
+	return victim;
+}
+
+static inline unsigned int tlb1_max_shadow_size(void)
+{
+	return tlb1_entry_num - tlbcam_index;
+}
+
+static inline int tlbe_is_writable(struct tlbe *tlbe)
+{
+	return tlbe->mas3 & (MAS3_SW|MAS3_UW);
+}
+
+static inline u32 e500_shadow_mas3_attrib(u32 mas3, int usermode)
+{
+	/* Mask off reserved bits. */
+	mas3 &= MAS3_ATTRIB_MASK;
+
+	if (!usermode) {
+		/* Guest is in supervisor mode,
+		 * so we need to translate guest
+		 * supervisor permissions into user permissions. */
+		mas3 &= ~E500_TLB_USER_PERM_MASK;
+		mas3 |= (mas3 & E500_TLB_SUPER_PERM_MASK) << 1;
+	}
+
+	return mas3 | E500_TLB_SUPER_PERM_MASK;
+}
+
+static inline u32 e500_shadow_mas2_attrib(u32 mas2, int usermode)
+{
+	return mas2 & MAS2_ATTRIB_MASK;
+}
+
+/*
+ * writing shadow tlb entry to host TLB
+ */
+static inline void __write_host_tlbe(struct tlbe *stlbe)
+{
+	mtspr(SPRN_MAS1, stlbe->mas1);
+	mtspr(SPRN_MAS2, stlbe->mas2);
+	mtspr(SPRN_MAS3, stlbe->mas3);
+	mtspr(SPRN_MAS7, stlbe->mas7);
+	__asm__ __volatile__ ("tlbwe\n" : : );
+}
+
+static inline void write_host_tlbe(struct kvmppc_vcpu_e500 *vcpu_e500,
+		int tlbsel, int esel)
+{
+	struct tlbe *stlbe = &vcpu_e500->shadow_tlb[tlbsel][esel];
+
+	local_irq_disable();
+	if (tlbsel == 0) {
+		__write_host_tlbe(stlbe);
+	} else {
+		unsigned register mas0;
+
+		mas0 = mfspr(SPRN_MAS0);
+
+		mtspr(SPRN_MAS0, MAS0_TLBSEL(1) | MAS0_ESEL(to_htlb1_esel(esel)));
+		__write_host_tlbe(stlbe);
+
+		mtspr(SPRN_MAS0, mas0);
+	}
+	local_irq_enable();
+}
+
+void kvmppc_e500_tlb_load(struct kvm_vcpu *vcpu, int cpu)
+{
+	struct kvmppc_vcpu_e500 *vcpu_e500 = to_e500(vcpu);
+	int i;
+	unsigned register mas0;
+
+	/* Load all valid TLB1 entries to reduce guest tlb miss fault */
+	local_irq_disable();
+	mas0 = mfspr(SPRN_MAS0);
+	for (i = 0; i < tlb1_max_shadow_size(); i++) {
+		struct tlbe *stlbe = &vcpu_e500->shadow_tlb[1][i];
+
+		if (get_tlb_v(stlbe)) {
+			mtspr(SPRN_MAS0, MAS0_TLBSEL(1)
+					| MAS0_ESEL(to_htlb1_esel(i)));
+			__write_host_tlbe(stlbe);
+		}
+	}
+	mtspr(SPRN_MAS0, mas0);
+	local_irq_enable();
+}
+
+void kvmppc_e500_tlb_put(struct kvm_vcpu *vcpu)
+{
+	_tlbia();
+}
+
+/* Search the guest TLB for a matching entry. */
+static int kvmppc_e500_tlb_index(struct kvmppc_vcpu_e500 *vcpu_e500,
+		gva_t eaddr, int tlbsel, unsigned int pid, int as)
+{
+	int i;
+
+	/* XXX Replace loop with fancy data structures. */
+	for (i = 0; i < vcpu_e500->guest_tlb_size[tlbsel]; i++) {
+		struct tlbe *tlbe = &vcpu_e500->guest_tlb[tlbsel][i];
+		unsigned int tid;
+
+		if (eaddr < get_tlb_eaddr(tlbe))
+			continue;
+
+		if (eaddr > get_tlb_end(tlbe))
+			continue;
+
+		tid = get_tlb_tid(tlbe);
+		if (tid && (tid != pid))
+			continue;
+
+		if (!get_tlb_v(tlbe))
+			continue;
+
+		if (get_tlb_ts(tlbe) != as && as != -1)
+			continue;
+
+		return i;
+	}
+
+	return -1;
+}
+
+static void kvmppc_e500_shadow_release(struct kvmppc_vcpu_e500 *vcpu_e500,
+		int tlbsel, int esel)
+{
+	struct tlbe *stlbe = &vcpu_e500->shadow_tlb[tlbsel][esel];
+	struct page *page = vcpu_e500->shadow_pages[tlbsel][esel];
+
+	if (page) {
+		vcpu_e500->shadow_pages[tlbsel][esel] = NULL;
+
+		if (get_tlb_v(stlbe)) {
+			if (tlbe_is_writable(stlbe))
+				kvm_release_page_dirty(page);
+			else
+				kvm_release_page_clean(page);
+		}
+	}
+}
+
+static void kvmppc_e500_stlbe_invalidate(struct kvmppc_vcpu_e500 *vcpu_e500,
+		int tlbsel, int esel)
+{
+	struct tlbe *stlbe = &vcpu_e500->shadow_tlb[tlbsel][esel];
+
+	kvmppc_e500_shadow_release(vcpu_e500, tlbsel, esel);
+	stlbe->mas1 = 0;
+	KVMTRACE_5D(STLB_INVAL, &vcpu_e500->vcpu, index_of(tlbsel, esel),
+			stlbe->mas1, stlbe->mas2, stlbe->mas3, stlbe->mas7,
+			handler);
+}
+
+static void kvmppc_e500_tlb1_invalidate(struct kvmppc_vcpu_e500 *vcpu_e500,
+		gva_t eaddr, gva_t eend, u32 tid)
+{
+	unsigned int pid = tid & 0xff;
+	unsigned int i;
+
+	/* XXX Replace loop with fancy data structures. */
+	for (i = 0; i < vcpu_e500->guest_tlb_size[1]; i++) {
+		struct tlbe *stlbe = &vcpu_e500->shadow_tlb[1][i];
+		unsigned int tid;
+
+		if (!get_tlb_v(stlbe))
+			continue;
+
+		if (eend < get_tlb_eaddr(stlbe))
+			continue;
+
+		if (eaddr > get_tlb_end(stlbe))
+			continue;
+
+		tid = get_tlb_tid(stlbe);
+		if (tid && (tid != pid))
+			continue;
+
+		kvmppc_e500_stlbe_invalidate(vcpu_e500, 1, i);
+		write_host_tlbe(vcpu_e500, 1, i);
+	}
+}
+
+static inline void kvmppc_e500_deliver_tlb_miss(struct kvm_vcpu *vcpu,
+		unsigned int eaddr, int as)
+{
+	struct kvmppc_vcpu_e500 *vcpu_e500 = to_e500(vcpu);
+	unsigned int victim, pidsel, tsized;
+	int tlbsel;
+
+	/* since we only have tow TLBs, only lower bit is used. */
+	tlbsel = (vcpu_e500->mas4 >> 28) & 0x1;
+	victim = (tlbsel == 0) ? tlb0_get_next_victim(vcpu_e500) : 0;
+	pidsel = (vcpu_e500->mas4 >> 16) & 0xf;
+	tsized = (vcpu_e500->mas4 >> 8) & 0xf;
+
+	vcpu_e500->mas0 = MAS0_TLBSEL(tlbsel) | MAS0_ESEL(victim)
+		| MAS0_NV(vcpu_e500->guest_tlb_nv[tlbsel]);
+	vcpu_e500->mas1 = MAS1_VALID | (as ? MAS1_TS : 0)
+		| MAS1_TID(vcpu_e500->pid[pidsel])
+		| MAS1_TSIZE(tsized);
+	vcpu_e500->mas2 = (eaddr & MAS2_EPN)
+		| (vcpu_e500->mas4 & MAS2_ATTRIB_MASK);
+	vcpu_e500->mas3 &= MAS3_U0 | MAS3_U1 | MAS3_U2 | MAS3_U3;
+	vcpu_e500->mas6 = (vcpu_e500->mas6 & MAS6_SPID1)
+		| (get_cur_pid(vcpu) << 16)
+		| (as ? MAS6_SAS : 0);
+	vcpu_e500->mas7 = 0;
+}
+
+static inline void kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
+	u64 gvaddr, gfn_t gfn, struct tlbe *gtlbe, int tlbsel, int esel)
+{
+	struct page *new_page;
+	struct tlbe *stlbe;
+	hpa_t hpaddr;
+
+	stlbe = &vcpu_e500->shadow_tlb[tlbsel][esel];
+
+	/* Get reference to new page. */
+	new_page = gfn_to_page(vcpu_e500->vcpu.kvm, gfn);
+	if (is_error_page(new_page)) {
+		printk(KERN_ERR "Couldn't get guest page for gfn %lx!\n", gfn);
+		kvm_release_page_clean(new_page);
+		return;
+	}
+	hpaddr = page_to_phys(new_page);
+
+	/* Drop reference to old page. */
+	kvmppc_e500_shadow_release(vcpu_e500, tlbsel, esel);
+
+	vcpu_e500->shadow_pages[tlbsel][esel] = new_page;
+
+	/* Force TS=1 IPROT=0 TSIZE=4KB for all guest mappings. */
+	stlbe->mas1 = MAS1_TSIZE(BOOKE_PAGESZ_4K)
+		| MAS1_TID(get_tlb_tid(gtlbe)) | MAS1_TS | MAS1_VALID;
+	stlbe->mas2 = (gvaddr & MAS2_EPN)
+		| e500_shadow_mas2_attrib(gtlbe->mas2,
+				vcpu_e500->vcpu.arch.msr & MSR_PR);
+	stlbe->mas3 = (hpaddr & MAS3_RPN)
+		| e500_shadow_mas3_attrib(gtlbe->mas3,
+				vcpu_e500->vcpu.arch.msr & MSR_PR);
+	stlbe->mas7 = (hpaddr >> 32) & MAS7_RPN;
+
+	KVMTRACE_5D(STLB_WRITE, &vcpu_e500->vcpu, index_of(tlbsel, esel),
+			stlbe->mas1, stlbe->mas2, stlbe->mas3, stlbe->mas7,
+			handler);
+}
+
+/* XXX only map the one-one case, for now use TLB0 */
+static int kvmppc_e500_stlbe_map(struct kvmppc_vcpu_e500 *vcpu_e500,
+		int tlbsel, int esel)
+{
+	struct tlbe *gtlbe;
+
+	gtlbe = &vcpu_e500->guest_tlb[tlbsel][esel];
+
+	kvmppc_e500_shadow_map(vcpu_e500, get_tlb_eaddr(gtlbe),
+			get_tlb_raddr(gtlbe) >> PAGE_SHIFT,
+			gtlbe, tlbsel, esel);
+
+	return esel;
+}
+
+/* Caller must ensure that the specified guest TLB entry is safe to insert into
+ * the shadow TLB. */
+/* XXX for both one-one and one-to-many , for now use TLB1 */
+static int kvmppc_e500_tlb1_map(struct kvmppc_vcpu_e500 *vcpu_e500,
+		u64 gvaddr, gfn_t gfn, struct tlbe *gtlbe)
+{
+	unsigned int victim;
+
+	victim = vcpu_e500->guest_tlb_nv[1]++;
+
+	if (unlikely(vcpu_e500->guest_tlb_nv[1] >= tlb1_max_shadow_size()))
+		vcpu_e500->guest_tlb_nv[1] = 0;
+
+	kvmppc_e500_shadow_map(vcpu_e500, gvaddr, gfn, gtlbe, 1, victim);
+
+	return victim;
+}
+
+/* Invalidate all guest kernel mappings when enter usermode,
+ * so that when they fault back in they will get the
+ * proper permission bits. */
+void kvmppc_mmu_priv_switch(struct kvm_vcpu *vcpu, int usermode)
+{
+	if (usermode) {
+		struct kvmppc_vcpu_e500 *vcpu_e500 = to_e500(vcpu);
+		int i;
+
+		/* XXX Replace loop with fancy data structures. */
+		/* needn't set modified since tlbia will make TLB1 coherent */
+		for (i = 0; i < tlb1_max_shadow_size(); i++)
+			kvmppc_e500_stlbe_invalidate(vcpu_e500, 1, i);
+
+		_tlbia();
+	}
+}
+
+static int kvmppc_e500_gtlbe_invalidate(struct kvmppc_vcpu_e500 *vcpu_e500,
+		int tlbsel, int esel)
+{
+	struct tlbe *gtlbe = &vcpu_e500->guest_tlb[tlbsel][esel];
+
+	if (unlikely(get_tlb_iprot(gtlbe)))
+		return -1;
+
+	if (tlbsel == 1) {
+		kvmppc_e500_tlb1_invalidate(vcpu_e500, get_tlb_eaddr(gtlbe),
+				get_tlb_end(gtlbe),
+				get_tlb_tid(gtlbe));
+	} else {
+		kvmppc_e500_stlbe_invalidate(vcpu_e500, tlbsel, esel);
+	}
+
+	gtlbe->mas1 = 0;
+
+	return 0;
+}
+
+int kvmppc_e500_emul_tlbivax(struct kvm_vcpu *vcpu, int ra, int rb)
+{
+	struct kvmppc_vcpu_e500 *vcpu_e500 = to_e500(vcpu);
+	unsigned int ia;
+	int esel, tlbsel;
+	gva_t ea;
+
+	ea = ((ra) ? vcpu->arch.gpr[ra] : 0) + vcpu->arch.gpr[rb];
+
+	ia = (ea >> 2) & 0x1;
+
+	/* since we only have tow TLBs, only lower bit is used. */
+	tlbsel = (ea >> 3) & 0x1;
+
+	if (ia) {
+		/* invalidate all entries */
+		for (esel = 0; esel < vcpu_e500->guest_tlb_size[tlbsel]; esel++)
+			kvmppc_e500_gtlbe_invalidate(vcpu_e500, tlbsel, esel);
+	} else {
+		ea &= 0xfffff000;
+		esel = kvmppc_e500_tlb_index(vcpu_e500, ea, tlbsel,
+				get_cur_pid(vcpu), -1);
+		if (esel >= 0)
+			kvmppc_e500_gtlbe_invalidate(vcpu_e500, tlbsel, esel);
+	}
+
+	_tlbia();
+
+	return EMULATE_DONE;
+}
+
+int kvmppc_e500_emul_tlbre(struct kvm_vcpu *vcpu)
+{
+	struct kvmppc_vcpu_e500 *vcpu_e500 = to_e500(vcpu);
+	int tlbsel, esel;
+	struct tlbe *gtlbe;
+
+	tlbsel = get_tlb_tlbsel(vcpu_e500);
+	esel = get_tlb_esel(vcpu_e500, tlbsel);
+
+	gtlbe = &vcpu_e500->guest_tlb[tlbsel][esel];
+	vcpu_e500->mas0 &= MAS0_NV(0);
+	vcpu_e500->mas0 |= MAS0_NV(vcpu_e500->guest_tlb_nv[tlbsel]);
+	vcpu_e500->mas1 = gtlbe->mas1;
+	vcpu_e500->mas2 = gtlbe->mas2;
+	vcpu_e500->mas3 = gtlbe->mas3;
+	vcpu_e500->mas7 = gtlbe->mas7;
+
+	return EMULATE_DONE;
+}
+
+int kvmppc_e500_emul_tlbsx(struct kvm_vcpu *vcpu, int rb)
+{
+	struct kvmppc_vcpu_e500 *vcpu_e500 = to_e500(vcpu);
+	int as = !!get_cur_sas(vcpu_e500);
+	unsigned int pid = get_cur_spid(vcpu_e500);
+	int esel, tlbsel;
+	struct tlbe *gtlbe = NULL;
+	gva_t ea;
+
+	ea = vcpu->arch.gpr[rb];
+
+	for (tlbsel = 0; tlbsel < 2; tlbsel++) {
+		esel = kvmppc_e500_tlb_index(vcpu_e500, ea, tlbsel, pid, as);
+		if (esel >= 0) {
+			gtlbe = &vcpu_e500->guest_tlb[tlbsel][esel];
+			break;
+		}
+	}
+
+	if (gtlbe) {
+		vcpu_e500->mas0 = MAS0_TLBSEL(tlbsel) | MAS0_ESEL(esel)
+			| MAS0_NV(vcpu_e500->guest_tlb_nv[tlbsel]);
+		vcpu_e500->mas1 = gtlbe->mas1;
+		vcpu_e500->mas2 = gtlbe->mas2;
+		vcpu_e500->mas3 = gtlbe->mas3;
+		vcpu_e500->mas7 = gtlbe->mas7;
+	} else {
+		int victim;
+
+		/* since we only have tow TLBs, only lower bit is used. */
+		tlbsel = vcpu_e500->mas4 >> 28 & 0x1;
+		victim = (tlbsel == 0) ? tlb0_get_next_victim(vcpu_e500) : 0;
+
+		vcpu_e500->mas0 = MAS0_TLBSEL(tlbsel) | MAS0_ESEL(victim)
+			| MAS0_NV(vcpu_e500->guest_tlb_nv[tlbsel]);
+		vcpu_e500->mas1 = (vcpu_e500->mas6 & MAS6_SPID0)
+			| (vcpu_e500->mas6 & (MAS6_SAS ? MAS1_TS : 0))
+			| (vcpu_e500->mas4 & MAS4_TSIZED(~0));
+		vcpu_e500->mas2 &= MAS2_EPN;
+		vcpu_e500->mas2 |= vcpu_e500->mas4 & MAS2_ATTRIB_MASK;
+		vcpu_e500->mas3 &= MAS3_U0 | MAS3_U1 | MAS3_U2 | MAS3_U3;
+		vcpu_e500->mas7 = 0;
+	}
+
+	return EMULATE_DONE;
+}
+
+int kvmppc_e500_emul_tlbwe(struct kvm_vcpu *vcpu)
+{
+	struct kvmppc_vcpu_e500 *vcpu_e500 = to_e500(vcpu);
+	u64 eaddr;
+	u64 raddr;
+	u32 tid;
+	struct tlbe *gtlbe;
+	int tlbsel, esel, stlbsel, sesel;
+
+	tlbsel = get_tlb_tlbsel(vcpu_e500);
+	esel = get_tlb_esel(vcpu_e500, tlbsel);
+
+	gtlbe = &vcpu_e500->guest_tlb[tlbsel][esel];
+
+	if (get_tlb_v(gtlbe) && tlbsel == 1) {
+		eaddr = get_tlb_eaddr(gtlbe);
+		tid = get_tlb_tid(gtlbe);
+		kvmppc_e500_tlb1_invalidate(vcpu_e500, eaddr,
+				get_tlb_end(gtlbe), tid);
+	}
+
+	gtlbe->mas1 = vcpu_e500->mas1;
+	gtlbe->mas2 = vcpu_e500->mas2;
+	gtlbe->mas3 = vcpu_e500->mas3;
+	gtlbe->mas7 = vcpu_e500->mas7;
+
+	KVMTRACE_5D(GTLB_WRITE, vcpu, vcpu_e500->mas0,
+			gtlbe->mas1, gtlbe->mas2, gtlbe->mas3, gtlbe->mas7,
+			handler);
+
+	/* Invalidate shadow mappings for the about-to-be-clobbered TLBE. */
+	if (tlbe_is_host_safe(vcpu, gtlbe)) {
+		switch (tlbsel) {
+		case 0:
+			/* TLB0 */
+			gtlbe->mas1 &= ~MAS1_TSIZE(~0);
+			gtlbe->mas1 |= MAS1_TSIZE(BOOKE_PAGESZ_4K);
+
+			stlbsel = 0;
+			sesel = kvmppc_e500_stlbe_map(vcpu_e500, 0, esel);
+
+			break;
+
+		case 1:
+			/* TLB1 */
+			eaddr = get_tlb_eaddr(gtlbe);
+			raddr = get_tlb_raddr(gtlbe);
+
+			/* Create a 4KB mapping on the host.
+			 * If the guest wanted a large page,
+			 * only the first 4KB is mapped here and the rest
+			 * are mapped on the fly. */
+			stlbsel = 1;
+			sesel = kvmppc_e500_tlb1_map(vcpu_e500, eaddr,
+					raddr >> PAGE_SHIFT, gtlbe);
+			break;
+
+		default:
+			BUG();
+		}
+		write_host_tlbe(vcpu_e500, stlbsel, sesel);
+	}
+
+	return EMULATE_DONE;
+}
+
+int kvmppc_mmu_itlb_index(struct kvm_vcpu *vcpu, gva_t eaddr)
+{
+	unsigned int as = !!(vcpu->arch.msr & MSR_IS);
+
+	return kvmppc_e500_tlb_search(vcpu, eaddr, get_cur_pid(vcpu), as);
+}
+
+int kvmppc_mmu_dtlb_index(struct kvm_vcpu *vcpu, gva_t eaddr)
+{
+	unsigned int as = !!(vcpu->arch.msr & MSR_DS);
+
+	return kvmppc_e500_tlb_search(vcpu, eaddr, get_cur_pid(vcpu), as);
+}
+
+void kvmppc_mmu_itlb_miss(struct kvm_vcpu *vcpu)
+{
+	unsigned int as = !!(vcpu->arch.msr & MSR_IS);
+
+	kvmppc_e500_deliver_tlb_miss(vcpu, vcpu->arch.pc, as);
+}
+
+void kvmppc_mmu_dtlb_miss(struct kvm_vcpu *vcpu)
+{
+	unsigned int as = !!(vcpu->arch.msr & MSR_DS);
+
+	kvmppc_e500_deliver_tlb_miss(vcpu, vcpu->arch.fault_dear, as);
+}
+
+gpa_t kvmppc_mmu_xlate(struct kvm_vcpu *vcpu, unsigned int index,
+			gva_t eaddr)
+{
+	struct kvmppc_vcpu_e500 *vcpu_e500 = to_e500(vcpu);
+	struct tlbe *gtlbe =
+		&vcpu_e500->guest_tlb[tlbsel_of(index)][esel_of(index)];
+	u64 pgmask = get_tlb_bytes(gtlbe) - 1;
+
+	return get_tlb_raddr(gtlbe) | (eaddr & pgmask);
+}
+
+void kvmppc_mmu_destroy(struct kvm_vcpu *vcpu)
+{
+	struct kvmppc_vcpu_e500 *vcpu_e500 = to_e500(vcpu);
+	int tlbsel, i;
+
+	for (tlbsel = 0; tlbsel < 2; tlbsel++)
+		for (i = 0; i < vcpu_e500->guest_tlb_size[tlbsel]; i++)
+			kvmppc_e500_shadow_release(vcpu_e500, tlbsel, i);
+
+	/* discard all guest mapping */
+	_tlbia();
+}
+
+void kvmppc_mmu_map(struct kvm_vcpu *vcpu, u64 eaddr, gpa_t gpaddr,
+			unsigned int index)
+{
+	struct kvmppc_vcpu_e500 *vcpu_e500 = to_e500(vcpu);
+	int tlbsel = tlbsel_of(index);
+	int esel = esel_of(index);
+	int stlbsel, sesel;
+
+	switch (tlbsel) {
+	case 0:
+		stlbsel = 0;
+		sesel = esel;
+		break;
+
+	case 1: {
+		gfn_t gfn = gpaddr >> PAGE_SHIFT;
+		struct tlbe *gtlbe
+			= &vcpu_e500->guest_tlb[tlbsel][esel];
+
+		stlbsel = 1;
+		sesel = kvmppc_e500_tlb1_map(vcpu_e500, eaddr, gfn, gtlbe);
+		break;
+	}
+
+	default:
+		BUG();
+		break;
+	}
+	write_host_tlbe(vcpu_e500, stlbsel, sesel);
+}
+
+int kvmppc_e500_tlb_search(struct kvm_vcpu *vcpu,
+				gva_t eaddr, unsigned int pid, int as)
+{
+	struct kvmppc_vcpu_e500 *vcpu_e500 = to_e500(vcpu);
+	int esel, tlbsel;
+
+	for (tlbsel = 0; tlbsel < 2; tlbsel++) {
+		esel = kvmppc_e500_tlb_index(vcpu_e500, eaddr, tlbsel, pid, as);
+		if (esel >= 0)
+			return index_of(tlbsel, esel);
+	}
+
+	return -1;
+}
+
+void kvmppc_e500_tlb_setup(struct kvmppc_vcpu_e500 *vcpu_e500)
+{
+	struct tlbe *tlbe;
+
+	/* Insert large initial mapping for guest. */
+	tlbe = &vcpu_e500->guest_tlb[1][0];
+	tlbe->mas1 = MAS1_VALID | MAS1_TSIZE(BOOKE_PAGESZ_256M);
+	tlbe->mas2 = 0;
+	tlbe->mas3 = E500_TLB_SUPER_PERM_MASK;
+	tlbe->mas7 = 0;
+
+	/* 4K map for serial output. Used by kernel wrapper. */
+	tlbe = &vcpu_e500->guest_tlb[1][1];
+	tlbe->mas1 = MAS1_VALID | MAS1_TSIZE(BOOKE_PAGESZ_4K);
+	tlbe->mas2 = (0xe0004500 & 0xFFFFF000) | MAS2_I | MAS2_G;
+	tlbe->mas3 = (0xe0004500 & 0xFFFFF000) | E500_TLB_SUPER_PERM_MASK;
+	tlbe->mas7 = 0;
+}
+
+int kvmppc_e500_tlb_init(struct kvmppc_vcpu_e500 *vcpu_e500)
+{
+	tlb1_entry_num = mfspr(SPRN_TLB1CFG) & 0xFFF;
+
+	vcpu_e500->guest_tlb_size[0] = KVM_E500_TLB0_SIZE;
+	vcpu_e500->guest_tlb[0] =
+		kzalloc(sizeof(struct tlbe) * KVM_E500_TLB0_SIZE, GFP_KERNEL);
+	if (vcpu_e500->guest_tlb[0] == NULL)
+		goto err_out;
+
+	vcpu_e500->shadow_tlb_size[0] = KVM_E500_TLB0_SIZE;
+	vcpu_e500->shadow_tlb[0] =
+		kzalloc(sizeof(struct tlbe) * KVM_E500_TLB0_SIZE, GFP_KERNEL);
+	if (vcpu_e500->shadow_tlb[0] == NULL)
+		goto err_out_guest0;
+
+	vcpu_e500->guest_tlb_size[1] = KVM_E500_TLB1_SIZE;
+	vcpu_e500->guest_tlb[1] =
+		kzalloc(sizeof(struct tlbe) * KVM_E500_TLB1_SIZE, GFP_KERNEL);
+	if (vcpu_e500->guest_tlb[1] == NULL)
+		goto err_out_shadow0;
+
+	vcpu_e500->shadow_tlb_size[1] = tlb1_entry_num;
+	vcpu_e500->shadow_tlb[1] =
+		kzalloc(sizeof(struct tlbe) * tlb1_entry_num, GFP_KERNEL);
+	if (vcpu_e500->shadow_tlb[1] == NULL)
+		goto err_out_guest1;
+
+	vcpu_e500->shadow_pages[0] = (struct page **)
+		kzalloc(sizeof(struct page *) * KVM_E500_TLB0_SIZE, GFP_KERNEL);
+	if (vcpu_e500->shadow_pages[0] == NULL)
+		goto err_out_shadow1;
+
+	vcpu_e500->shadow_pages[1] = (struct page **)
+		kzalloc(sizeof(struct page *) * tlb1_entry_num, GFP_KERNEL);
+	if (vcpu_e500->shadow_pages[1] == NULL)
+		goto err_out_page0;
+
+	return 0;
+
+err_out_page0:
+	kfree(vcpu_e500->shadow_pages[0]);
+err_out_shadow1:
+	kfree(vcpu_e500->shadow_tlb[1]);
+err_out_guest1:
+	kfree(vcpu_e500->guest_tlb[1]);
+err_out_shadow0:
+	kfree(vcpu_e500->shadow_tlb[0]);
+err_out_guest0:
+	kfree(vcpu_e500->guest_tlb[0]);
+err_out:
+	return -1;
+}
+
+void kvmppc_e500_tlb_uninit(struct kvmppc_vcpu_e500 *vcpu_e500)
+{
+	kfree(vcpu_e500->shadow_pages[1]);
+	kfree(vcpu_e500->shadow_pages[0]);
+	kfree(vcpu_e500->shadow_tlb[1]);
+	kfree(vcpu_e500->guest_tlb[1]);
+	kfree(vcpu_e500->shadow_tlb[0]);
+	kfree(vcpu_e500->guest_tlb[0]);
+}
diff --git a/arch/powerpc/kvm/e500_tlb.h b/arch/powerpc/kvm/e500_tlb.h
new file mode 100644
index 0000000..d8833f9
--- /dev/null
+++ b/arch/powerpc/kvm/e500_tlb.h
@@ -0,0 +1,184 @@
+/*
+ * Copyright (C) 2008 Freescale Semiconductor, Inc. All rights reserved.
+ *
+ * Author: Yu Liu, yu.liu@freescale.com
+ *
+ * Description:
+ * This file is based on arch/powerpc/kvm/44x_tlb.h,
+ * by Hollis Blanchard <hollisb@us.ibm.com>.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __KVM_E500_TLB_H__
+#define __KVM_E500_TLB_H__
+
+#include <linux/kvm_host.h>
+#include <asm/mmu-fsl-booke.h>
+#include <asm/tlb.h>
+#include <asm/kvm_e500.h>
+
+#define KVM_E500_TLB0_WAY_SIZE_BIT	7	/* Fixed */
+#define KVM_E500_TLB0_WAY_SIZE		(1UL << KVM_E500_TLB0_WAY_SIZE_BIT)
+#define KVM_E500_TLB0_WAY_SIZE_MASK	(KVM_E500_TLB0_WAY_SIZE - 1)
+
+#define KVM_E500_TLB0_WAY_NUM_BIT	1	/* No greater than 7 */
+#define KVM_E500_TLB0_WAY_NUM		(1UL << KVM_E500_TLB0_WAY_NUM_BIT)
+#define KVM_E500_TLB0_WAY_NUM_MASK	(KVM_E500_TLB0_WAY_NUM - 1)
+
+#define KVM_E500_TLB0_SIZE  (KVM_E500_TLB0_WAY_SIZE * KVM_E500_TLB0_WAY_NUM)
+#define KVM_E500_TLB1_SIZE  16
+
+#define index_of(tlbsel, esel)	(((tlbsel) << 16) | ((esel) & 0xFFFF))
+#define tlbsel_of(index)	((index) >> 16)
+#define esel_of(index)		((index) & 0xFFFF)
+
+#define E500_TLB_USER_PERM_MASK (MAS3_UX|MAS3_UR|MAS3_UW)
+#define E500_TLB_SUPER_PERM_MASK (MAS3_SX|MAS3_SR|MAS3_SW)
+#define MAS2_ATTRIB_MASK \
+	  (MAS2_X0 | MAS2_X1 | MAS2_W | MAS2_I | MAS2_M | MAS2_G | MAS2_E)
+#define MAS3_ATTRIB_MASK \
+	  (MAS3_U0 | MAS3_U1 | MAS3_U2 | MAS3_U3 \
+	   | E500_TLB_USER_PERM_MASK | E500_TLB_SUPER_PERM_MASK)
+
+extern void kvmppc_dump_tlbs(struct kvm_vcpu *);
+extern int kvmppc_e500_emul_tlbwe(struct kvm_vcpu *);
+extern int kvmppc_e500_emul_tlbre(struct kvm_vcpu *);
+extern int kvmppc_e500_emul_tlbivax(struct kvm_vcpu *, int, int);
+extern int kvmppc_e500_emul_tlbsx(struct kvm_vcpu *, int);
+extern int kvmppc_e500_tlb_search(struct kvm_vcpu *, gva_t, unsigned int, int);
+extern void kvmppc_e500_tlb_put(struct kvm_vcpu *);
+extern void kvmppc_e500_tlb_load(struct kvm_vcpu *, int);
+extern int kvmppc_e500_tlb_init(struct kvmppc_vcpu_e500 *);
+extern void kvmppc_e500_tlb_uninit(struct kvmppc_vcpu_e500 *);
+extern void kvmppc_e500_tlb_setup(struct kvmppc_vcpu_e500 *);
+
+/* TLB helper functions */
+static inline unsigned int get_tlb_size(const struct tlbe *tlbe)
+{
+	return (tlbe->mas1 >> 8) & 0xf;
+}
+
+static inline gva_t get_tlb_eaddr(const struct tlbe *tlbe)
+{
+	return tlbe->mas2 & 0xfffff000;
+}
+
+static inline u64 get_tlb_bytes(const struct tlbe *tlbe)
+{
+	unsigned int pgsize = get_tlb_size(tlbe);
+	return 1ULL << 10 << (pgsize << 1);
+}
+
+static inline gva_t get_tlb_end(const struct tlbe *tlbe)
+{
+	u64 bytes = get_tlb_bytes(tlbe);
+	return get_tlb_eaddr(tlbe) + bytes - 1;
+}
+
+static inline u64 get_tlb_raddr(const struct tlbe *tlbe)
+{
+	u64 rpn = tlbe->mas7;
+	return (rpn << 32) | (tlbe->mas3 & 0xfffff000);
+}
+
+static inline unsigned int get_tlb_tid(const struct tlbe *tlbe)
+{
+	return (tlbe->mas1 >> 16) & 0xff;
+}
+
+static inline unsigned int get_tlb_ts(const struct tlbe *tlbe)
+{
+	return (tlbe->mas1 >> 12) & 0x1;
+}
+
+static inline unsigned int get_tlb_v(const struct tlbe *tlbe)
+{
+	return (tlbe->mas1 >> 31) & 0x1;
+}
+
+static inline unsigned int get_tlb_iprot(const struct tlbe *tlbe)
+{
+	return (tlbe->mas1 >> 30) & 0x1;
+}
+
+static inline unsigned int get_cur_pid(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.pid & 0xff;
+}
+
+static inline unsigned int get_cur_spid(
+		const struct kvmppc_vcpu_e500 *vcpu_e500)
+{
+	return (vcpu_e500->mas6 >> 16) & 0xff;
+}
+
+static inline unsigned int get_cur_sas(
+		const struct kvmppc_vcpu_e500 *vcpu_e500)
+{
+	return vcpu_e500->mas6 & 0x1;
+}
+
+static inline unsigned int get_tlb_tlbsel(
+		const struct kvmppc_vcpu_e500 *vcpu_e500)
+{
+	/*
+	 * Manual says that tlbsel has 2 bits wide.
+	 * Since we only have tow TLBs, only lower bit is used.
+	 */
+	return (vcpu_e500->mas0 >> 28) & 0x1;
+}
+
+static inline unsigned int get_tlb_nv_bit(
+		const struct kvmppc_vcpu_e500 *vcpu_e500)
+{
+	return vcpu_e500->mas0 & 0xfff;
+}
+
+static inline unsigned int get_tlb_esel_bit(
+		const struct kvmppc_vcpu_e500 *vcpu_e500)
+{
+	return (vcpu_e500->mas0 >> 16) & 0xfff;
+}
+
+static inline unsigned int get_tlb_esel(
+		const struct kvmppc_vcpu_e500 *vcpu_e500,
+		int tlbsel)
+{
+	unsigned int esel = get_tlb_esel_bit(vcpu_e500);
+
+	if (tlbsel == 0) {
+		esel &= KVM_E500_TLB0_WAY_NUM_MASK;
+		esel |= ((vcpu_e500->mas2 >> 12) & KVM_E500_TLB0_WAY_SIZE_MASK)
+				<< KVM_E500_TLB0_WAY_NUM_BIT;
+	} else {
+		esel &= KVM_E500_TLB1_SIZE - 1;
+	}
+
+	return esel;
+}
+
+static inline int tlbe_is_host_safe(const struct kvm_vcpu *vcpu,
+			const struct tlbe *tlbe)
+{
+	gpa_t gpa;
+
+	if (!get_tlb_v(tlbe))
+		return 0;
+
+	/* Does it match current guest AS? */
+	/* XXX what about IS != DS? */
+	if (get_tlb_ts(tlbe) != !!(vcpu->arch.msr & MSR_IS))
+		return 0;
+
+	gpa = get_tlb_raddr(tlbe);
+	if (!gfn_to_memslot(vcpu->kvm, gpa >> PAGE_SHIFT))
+		/* Mapping is not for RAM. */
+		return 0;
+
+	return 1;
+}
+
+#endif /* __KVM_E500_TLB_H__ */
-- 
1.6.0.6

