Return-Path: <linux-kernel-owner+w=401wt.eu-S965521AbXA3OkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965521AbXA3OkF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 09:40:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965525AbXA3OkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 09:40:04 -0500
Received: from il.qumranet.com ([62.219.232.206]:53250 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965372AbXA3OkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 09:40:01 -0500
Subject: [PATCH 4/11] KVM: vmx: handle triple faults by returning
	EXIT_REASON_SHUTDOWN to userspace
From: Avi Kivity <avi@qumranet.com>
Date: Tue, 30 Jan 2007 14:40:00 -0000
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, mingo@elte.hu
References: <45BF57C9.7000103@qumranet.com>
In-Reply-To: <45BF57C9.7000103@qumranet.com>
Message-Id: <20070130144000.1F6DFA0014@il.qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Just like svm.

Signed-off-by: Avi Kivity <avi@qumranet.com>

Index: linux-2.6/drivers/kvm/vmx.c
===================================================================
--- linux-2.6.orig/drivers/kvm/vmx.c
+++ linux-2.6/drivers/kvm/vmx.c
@@ -1373,6 +1373,11 @@ static int handle_external_interrupt(str
 	return 1;
 }
 
+static int handle_triple_fault(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+{
+	kvm_run->exit_reason = KVM_EXIT_SHUTDOWN;
+	return 0;
+}
 
 static int get_io_count(struct kvm_vcpu *vcpu, u64 *count)
 {
@@ -1633,6 +1638,7 @@ static int (*kvm_vmx_exit_handlers[])(st
 				      struct kvm_run *kvm_run) = {
 	[EXIT_REASON_EXCEPTION_NMI]           = handle_exception,
 	[EXIT_REASON_EXTERNAL_INTERRUPT]      = handle_external_interrupt,
+	[EXIT_REASON_TRIPLE_FAULT]            = handle_triple_fault,
 	[EXIT_REASON_IO_INSTRUCTION]          = handle_io,
 	[EXIT_REASON_CR_ACCESS]               = handle_cr,
 	[EXIT_REASON_DR_ACCESS]               = handle_dr,
Index: linux-2.6/drivers/kvm/vmx.h
===================================================================
--- linux-2.6.orig/drivers/kvm/vmx.h
+++ linux-2.6/drivers/kvm/vmx.h
@@ -180,6 +180,7 @@ enum vmcs_field {
 
 #define EXIT_REASON_EXCEPTION_NMI       0
 #define EXIT_REASON_EXTERNAL_INTERRUPT  1
+#define EXIT_REASON_TRIPLE_FAULT        2
 
 #define EXIT_REASON_PENDING_INTERRUPT   7
 
