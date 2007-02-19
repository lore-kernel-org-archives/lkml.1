Return-Path: <linux-kernel-owner+w=401wt.eu-S1750848AbXBSK2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750848AbXBSK2y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 05:28:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750859AbXBSK2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 05:28:54 -0500
Received: from il.qumranet.com ([82.166.9.18]:35521 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750848AbXBSK2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 05:28:53 -0500
Subject: [PATCH 8/13] KVM: Add host hypercall support for vmx
From: Avi Kivity <avi@qumranet.com>
Date: Mon, 19 Feb 2007 10:28:52 -0000
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, mingo@elte.hu
References: <45D979D3.2020907@qumranet.com>
In-Reply-To: <45D979D3.2020907@qumranet.com>
Content-Type: text/plain; charset=UTF-8
Message-Id: <20070219102852.1892525016B@il.qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>

Signed-off-by: Avi Kivity <avi@qumranet.com>

Index: linux-2.6/include/linux/kvm_para.h
===================================================================
--- linux-2.6.orig/include/linux/kvm_para.h
+++ linux-2.6/include/linux/kvm_para.h
@@ -52,4 +52,22 @@ struct kvm_vcpu_para_state {
 
 #define KVM_EINVAL 1
 
+/*
+ * Hypercall calling convention:
+ *
+ * Each hypercall may have 0-6 parameters.
+ *
+ * 64-bit hypercall index is in RAX, goes from 0 to __NR_hypercalls-1
+ *
+ * 64-bit parameters 1-6 are in the standard gcc x86_64 calling convention
+ * order: RDI, RSI, RDX, RCX, R8, R9.
+ *
+ * 32-bit index is EBX, parameters are: EAX, ECX, EDX, ESI, EDI, EBP.
+ * (the first 3 are according to the gcc regparm calling convention)
+ *
+ * No registers are clobbered by the hypercall, except that the
+ * return value is in RAX.
+ */
+#define __NR_hypercalls			0
+
 #endif
Index: linux-2.6/drivers/kvm/vmx.c
===================================================================
--- linux-2.6.orig/drivers/kvm/vmx.c
+++ linux-2.6/drivers/kvm/vmx.c
@@ -1657,6 +1657,20 @@ static int handle_halt(struct kvm_vcpu *
 	return 0;
 }
 
+static int handle_vmcall(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+{
+	kvm_run->exit_reason = KVM_EXIT_DEBUG;
+	printk(KERN_DEBUG "got vmcall at RIP %08lx\n", vmcs_readl(GUEST_RIP));
+	printk(KERN_DEBUG "vmcall params: %08lx, %08lx, %08lx, %08lx\n",
+		vcpu->regs[VCPU_REGS_RAX],
+		vcpu->regs[VCPU_REGS_RCX],
+		vcpu->regs[VCPU_REGS_RDX],
+		vcpu->regs[VCPU_REGS_RBP]);
+	vcpu->regs[VCPU_REGS_RAX] = 0;
+	vmcs_writel(GUEST_RIP, vmcs_readl(GUEST_RIP)+3);
+	return 1;
+}
+
 /*
  * The exit handlers return 1 if the exit was handled fully and guest execution
  * may resume.  Otherwise they set the kvm_run parameter to indicate what needs
@@ -1675,6 +1689,7 @@ static int (*kvm_vmx_exit_handlers[])(st
 	[EXIT_REASON_MSR_WRITE]               = handle_wrmsr,
 	[EXIT_REASON_PENDING_INTERRUPT]       = handle_interrupt_window,
 	[EXIT_REASON_HLT]                     = handle_halt,
+	[EXIT_REASON_VMCALL]                  = handle_vmcall,
 };
 
 static const int kvm_vmx_max_exit_handlers =
