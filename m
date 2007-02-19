Return-Path: <linux-kernel-owner+w=401wt.eu-S1750860AbXBSK3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750860AbXBSK3y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 05:29:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750863AbXBSK3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 05:29:54 -0500
Received: from il.qumranet.com ([82.166.9.18]:57074 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859AbXBSK3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 05:29:53 -0500
Subject: [PATCH 9/13] KVM: Add hypercall host support for svm
From: Avi Kivity <avi@qumranet.com>
Date: Mon, 19 Feb 2007 10:29:52 -0000
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, mingo@elte.hu
References: <45D979D3.2020907@qumranet.com>
In-Reply-To: <45D979D3.2020907@qumranet.com>
Content-Type: text/plain; charset=UTF-8
Message-Id: <20070219102952.43A1C25016B@il.qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@qumranet.com>

Index: linux-2.6/drivers/kvm/svm.c
===================================================================
--- linux-2.6.orig/drivers/kvm/svm.c
+++ linux-2.6/drivers/kvm/svm.c
@@ -1076,6 +1076,20 @@ static int halt_interception(struct kvm_
 	return 0;
 }
 
+static int vmmcall_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+{
+	printk(KERN_DEBUG "got vmmcall at RIP %08llx\n",
+	       vcpu->svm->vmcb->save.rip);
+	printk(KERN_DEBUG "vmmcall params: %08llx, %08lx, %08lx, %08lx\n",
+	       vcpu->svm->vmcb->save.rax,
+	       vcpu->regs[VCPU_REGS_RCX],
+	       vcpu->regs[VCPU_REGS_RDX],
+	       vcpu->regs[VCPU_REGS_RBP]);
+	vcpu->svm->vmcb->save.rax = 0;
+	vcpu->svm->vmcb->save.rip += 3;
+	return 1;
+}
+
 static int invalid_op_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
 	inject_ud(vcpu);
@@ -1276,7 +1290,7 @@ static int (*svm_exit_handlers[])(struct
 	[SVM_EXIT_TASK_SWITCH]			= task_switch_interception,
 	[SVM_EXIT_SHUTDOWN]			= shutdown_interception,
 	[SVM_EXIT_VMRUN]			= invalid_op_interception,
-	[SVM_EXIT_VMMCALL]			= invalid_op_interception,
+	[SVM_EXIT_VMMCALL]			= vmmcall_interception,
 	[SVM_EXIT_VMLOAD]			= invalid_op_interception,
 	[SVM_EXIT_VMSAVE]			= invalid_op_interception,
 	[SVM_EXIT_STGI]				= invalid_op_interception,
