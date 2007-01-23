Return-Path: <linux-kernel-owner+w=401wt.eu-S933033AbXAWOgH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933033AbXAWOgH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 09:36:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933026AbXAWOgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 09:36:07 -0500
Received: from il.qumranet.com ([62.219.232.206]:56758 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933033AbXAWOgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 09:36:05 -0500
Subject: [PATCH 5/5] KVM: SVM: Propagate cpu shutdown events to userspace
From: Avi Kivity <avi@qumranet.com>
Date: Tue, 23 Jan 2007 14:36:04 -0000
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, mingo@elte.hu
References: <45B61C09.5020501@qumranet.com>
In-Reply-To: <45B61C09.5020501@qumranet.com>
Message-Id: <20070123143604.4DD1A2507E1@il.qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

This patch implements forwarding of SHUTDOWN intercepts from the guest
on to userspace on AMD SVM. A SHUTDOWN event occurs when the guest produces
a triple fault (e.g. on reboot). This also fixes the bug that a guest
reboot actually causes a host reboot under some circumstances.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>

Index: linux-2.6/include/linux/kvm.h
===================================================================
--- linux-2.6.orig/include/linux/kvm.h
+++ linux-2.6/include/linux/kvm.h
@@ -46,6 +46,7 @@ enum kvm_exit_reason {
 	KVM_EXIT_HLT              = 5,
 	KVM_EXIT_MMIO             = 6,
 	KVM_EXIT_IRQ_WINDOW_OPEN  = 7,
+	KVM_EXIT_SHUTDOWN         = 8,
 };
 
 /* for KVM_RUN */
Index: linux-2.6/drivers/kvm/svm.c
===================================================================
--- linux-2.6.orig/drivers/kvm/svm.c
+++ linux-2.6/drivers/kvm/svm.c
@@ -502,6 +502,7 @@ static void init_vmcb(struct vmcb *vmcb)
 				(1ULL << INTERCEPT_IOIO_PROT) |
 				(1ULL << INTERCEPT_MSR_PROT) |
 				(1ULL << INTERCEPT_TASK_SWITCH) |
+				(1ULL << INTERCEPT_SHUTDOWN) |
 				(1ULL << INTERCEPT_VMRUN) |
 				(1ULL << INTERCEPT_VMMCALL) |
 				(1ULL << INTERCEPT_VMLOAD) |
@@ -892,6 +893,19 @@ static int pf_interception(struct kvm_vc
 	return 0;
 }
 
+static int shutdown_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+{
+	/*
+	 * VMCB is undefined after a SHUTDOWN intercept
+	 * so reinitialize it.
+	 */
+	memset(vcpu->svm->vmcb, 0, PAGE_SIZE);
+	init_vmcb(vcpu->svm->vmcb);
+
+	kvm_run->exit_reason = KVM_EXIT_SHUTDOWN;
+	return 0;
+}
+
 static int io_get_override(struct kvm_vcpu *vcpu,
 			  struct vmcb_seg **seg,
 			  int *addr_override)
@@ -1249,6 +1263,7 @@ static int (*svm_exit_handlers[])(struct
 	[SVM_EXIT_IOIO] 		  	= io_interception,
 	[SVM_EXIT_MSR]				= msr_interception,
 	[SVM_EXIT_TASK_SWITCH]			= task_switch_interception,
+	[SVM_EXIT_SHUTDOWN]			= shutdown_interception,
 	[SVM_EXIT_VMRUN]			= invalid_op_interception,
 	[SVM_EXIT_VMMCALL]			= invalid_op_interception,
 	[SVM_EXIT_VMLOAD]			= invalid_op_interception,
