Return-Path: <linux-kernel-owner+w=401wt.eu-S1750843AbXBSK1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750843AbXBSK1y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 05:27:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750859AbXBSK1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 05:27:54 -0500
Received: from il.qumranet.com ([82.166.9.18]:35490 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843AbXBSK1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 05:27:53 -0500
Subject: [PATCH 7/13] KVM: add MSR based hypercall API
From: Avi Kivity <avi@qumranet.com>
Date: Mon, 19 Feb 2007 10:27:52 -0000
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, mingo@elte.hu
References: <45D979D3.2020907@qumranet.com>
In-Reply-To: <45D979D3.2020907@qumranet.com>
Content-Type: text/plain; charset=UTF-8
Message-Id: <20070219102752.0F37125016B@il.qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>

This adds a special MSR based hypercall API to KVM. This is to be
used by paravirtual kernels and virtual drivers.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Avi Kivity <avi@qumranet.com>

Index: linux-2.6/drivers/kvm/kvm_main.c
===================================================================
--- linux-2.6.orig/drivers/kvm/kvm_main.c
+++ linux-2.6/drivers/kvm/kvm_main.c
@@ -1204,6 +1204,73 @@ void realmode_set_cr(struct kvm_vcpu *vc
 	}
 }
 
+/*
+ * Register the para guest with the host:
+ */
+static int vcpu_register_para(struct kvm_vcpu *vcpu, gpa_t para_state_gpa)
+{
+	struct kvm_vcpu_para_state *para_state;
+	hpa_t para_state_hpa, hypercall_hpa;
+	struct page *para_state_page;
+	unsigned char *hypercall;
+	gpa_t hypercall_gpa;
+
+	printk(KERN_DEBUG "kvm: guest trying to enter paravirtual mode\n");
+	printk(KERN_DEBUG ".... para_state_gpa: %08Lx\n", para_state_gpa);
+
+	/*
+	 * Needs to be page aligned:
+	 */
+	if (para_state_gpa != PAGE_ALIGN(para_state_gpa))
+		goto err_gp;
+
+	para_state_hpa = gpa_to_hpa(vcpu, para_state_gpa);
+	printk(KERN_DEBUG ".... para_state_hpa: %08Lx\n", para_state_hpa);
+	if (is_error_hpa(para_state_hpa))
+		goto err_gp;
+
+	para_state_page = pfn_to_page(para_state_hpa >> PAGE_SHIFT);
+	para_state = kmap_atomic(para_state_page, KM_USER0);
+
+	printk(KERN_DEBUG "....  guest version: %d\n", para_state->guest_version);
+	printk(KERN_DEBUG "....           size: %d\n", para_state->size);
+
+	para_state->host_version = KVM_PARA_API_VERSION;
+	/*
+	 * We cannot support guests that try to register themselves
+	 * with a newer API version than the host supports:
+	 */
+	if (para_state->guest_version > KVM_PARA_API_VERSION) {
+		para_state->ret = -KVM_EINVAL;
+		goto err_kunmap_skip;
+	}
+
+	hypercall_gpa = para_state->hypercall_gpa;
+	hypercall_hpa = gpa_to_hpa(vcpu, hypercall_gpa);
+	printk(KERN_DEBUG ".... hypercall_hpa: %08Lx\n", hypercall_hpa);
+	if (is_error_hpa(hypercall_hpa)) {
+		para_state->ret = -KVM_EINVAL;
+		goto err_kunmap_skip;
+	}
+
+	printk(KERN_DEBUG "kvm: para guest successfully registered.\n");
+	vcpu->para_state_page = para_state_page;
+	vcpu->para_state_gpa = para_state_gpa;
+	vcpu->hypercall_gpa = hypercall_gpa;
+
+	hypercall = kmap_atomic(pfn_to_page(hypercall_hpa >> PAGE_SHIFT),
+				KM_USER1) + (hypercall_hpa & ~PAGE_MASK);
+	kvm_arch_ops->patch_hypercall(vcpu, hypercall);
+	kunmap_atomic(hypercall, KM_USER1);
+
+	para_state->ret = 0;
+err_kunmap_skip:
+	kunmap_atomic(para_state, KM_USER0);
+	return 0;
+err_gp:
+	return 1;
+}
+
 int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 {
 	u64 data;
@@ -1312,6 +1379,12 @@ int kvm_set_msr_common(struct kvm_vcpu *
 	case MSR_IA32_MISC_ENABLE:
 		vcpu->ia32_misc_enable_msr = data;
 		break;
+	/*
+	 * This is the 'probe whether the host is KVM' logic:
+	 */
+	case MSR_KVM_API_MAGIC:
+		return vcpu_register_para(vcpu, data);
+
 	default:
 		printk(KERN_ERR "kvm: unhandled wrmsr: 0x%x\n", msr);
 		return 1;
Index: linux-2.6/drivers/kvm/kvm.h
===================================================================
--- linux-2.6.orig/drivers/kvm/kvm.h
+++ linux-2.6/drivers/kvm/kvm.h
@@ -14,6 +14,7 @@
 
 #include "vmx.h"
 #include <linux/kvm.h>
+#include <linux/kvm_para.h>
 
 #define CR0_PE_MASK (1ULL << 0)
 #define CR0_TS_MASK (1ULL << 3)
@@ -237,6 +238,9 @@ struct kvm_vcpu {
 	unsigned long cr0;
 	unsigned long cr2;
 	unsigned long cr3;
+	gpa_t para_state_gpa;
+	struct page *para_state_page;
+	gpa_t hypercall_gpa;
 	unsigned long cr4;
 	unsigned long cr8;
 	u64 pdptrs[4]; /* pae */
@@ -382,6 +386,8 @@ struct kvm_arch_ops {
 	int (*run)(struct kvm_vcpu *vcpu, struct kvm_run *run);
 	int (*vcpu_setup)(struct kvm_vcpu *vcpu);
 	void (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
+	void (*patch_hypercall)(struct kvm_vcpu *vcpu,
+				unsigned char *hypercall_addr);
 };
 
 extern struct kvm_stat kvm_stat;
Index: linux-2.6/include/linux/kvm_para.h
===================================================================
--- /dev/null
+++ linux-2.6/include/linux/kvm_para.h
@@ -0,0 +1,55 @@
+#ifndef __LINUX_KVM_PARA_H
+#define __LINUX_KVM_PARA_H
+
+/*
+ * Guest OS interface for KVM paravirtualization
+ *
+ * Note: this interface is totally experimental, and is certain to change
+ *       as we make progress.
+ */
+
+/*
+ * Per-VCPU descriptor area shared between guest and host. Writable to
+ * both guest and host. Registered with the host by the guest when
+ * a guest acknowledges paravirtual mode.
+ *
+ * NOTE: all addresses are guest-physical addresses (gpa), to make it
+ * easier for the hypervisor to map between the various addresses.
+ */
+struct kvm_vcpu_para_state {
+	/*
+	 * API version information for compatibility. If there's any support
+	 * mismatch (too old host trying to execute too new guest) then
+	 * the host will deny entry into paravirtual mode. Any other
+	 * combination (new host + old guest and new host + new guest)
+	 * is supposed to work - new host versions will support all old
+	 * guest API versions.
+	 */
+	u32 guest_version;
+	u32 host_version;
+	u32 size;
+	u32 ret;
+
+	/*
+	 * The address of the vm exit instruction (VMCALL or VMMCALL),
+	 * which the host will patch according to the CPU model the
+	 * VM runs on:
+	 */
+	u64 hypercall_gpa;
+
+} __attribute__ ((aligned(PAGE_SIZE)));
+
+#define KVM_PARA_API_VERSION 1
+
+/*
+ * This is used for an RDMSR's ECX parameter to probe for a KVM host.
+ * Hopefully no CPU vendor will use up this number. This is placed well
+ * out of way of the typical space occupied by CPU vendors' MSR indices,
+ * and we think (or at least hope) it wont be occupied in the future
+ * either.
+ */
+#define MSR_KVM_API_MAGIC 0x87655678
+
+#define KVM_EINVAL 1
+
+#endif
Index: linux-2.6/drivers/kvm/svm.c
===================================================================
--- linux-2.6.orig/drivers/kvm/svm.c
+++ linux-2.6/drivers/kvm/svm.c
@@ -1669,6 +1669,18 @@ static int is_disabled(void)
 	return 0;
 }
 
+static void
+svm_patch_hypercall(struct kvm_vcpu *vcpu, unsigned char *hypercall)
+{
+	/*
+	 * Patch in the VMMCALL instruction:
+	 */
+	hypercall[0] = 0x0f;
+	hypercall[1] = 0x01;
+	hypercall[2] = 0xd9;
+	hypercall[3] = 0xc3;
+}
+
 static struct kvm_arch_ops svm_arch_ops = {
 	.cpu_has_kvm_support = has_svm,
 	.disabled_by_bios = is_disabled,
@@ -1717,6 +1729,7 @@ static struct kvm_arch_ops svm_arch_ops 
 	.run = svm_vcpu_run,
 	.skip_emulated_instruction = skip_emulated_instruction,
 	.vcpu_setup = svm_vcpu_setup,
+	.patch_hypercall = svm_patch_hypercall,
 };
 
 static int __init svm_init(void)
Index: linux-2.6/drivers/kvm/vmx.c
===================================================================
--- linux-2.6.orig/drivers/kvm/vmx.c
+++ linux-2.6/drivers/kvm/vmx.c
@@ -1469,6 +1469,18 @@ static int handle_io(struct kvm_vcpu *vc
 	return 0;
 }
 
+static void
+vmx_patch_hypercall(struct kvm_vcpu *vcpu, unsigned char *hypercall)
+{
+	/*
+	 * Patch in the VMCALL instruction:
+	 */
+	hypercall[0] = 0x0f;
+	hypercall[1] = 0x01;
+	hypercall[2] = 0xc1;
+	hypercall[3] = 0xc3;
+}
+
 static int handle_cr(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
 	u64 exit_qualification;
@@ -2064,6 +2076,7 @@ static struct kvm_arch_ops vmx_arch_ops 
 	.run = vmx_vcpu_run,
 	.skip_emulated_instruction = skip_emulated_instruction,
 	.vcpu_setup = vmx_vcpu_setup,
+	.patch_hypercall = vmx_patch_hypercall,
 };
 
 static int __init vmx_init(void)
