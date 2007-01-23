Return-Path: <linux-kernel-owner+w=401wt.eu-S964930AbXAWMxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964930AbXAWMxw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 07:53:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964933AbXAWMxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 07:53:52 -0500
Received: from outbound-cpk.frontbridge.com ([207.46.163.16]:24297 "EHLO
	outbound2-cpk-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964930AbXAWMxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 07:53:51 -0500
X-BigFish: VP
X-Server-Uuid: 89466532-923C-4A88-82C1-66ACAA0041DF
Date: Tue, 23 Jan 2007 13:50:29 +0100
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Avi Kivity" <avi@qumranet.com>
cc: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH] KVM: propagate SHUTDOWN intercept to userspace on SVM
Message-ID: <20070123125029.GA7919@amd.com>
MIME-Version: 1.0
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 23 Jan 2007 12:50:29.0277 (UTC)
 FILETIME=[0F925CD0:01C73EED]
X-WSS-ID: 69A8DB121WC5143853-01-01
Content-Type: multipart/mixed;
 boundary=sdtB3X0nJg68CQEu
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--sdtB3X0nJg68CQEu
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

This patch implements forwarding of SHUTDOWN intercepts from the guest
on to userspace on AMD SVM. A SHUTDOWN event occurs when the guest produces
a triple fault (e.g. on reboot). This also fixes the bug that a guest
reboot actually causes a host reboot under some circumstances.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>

-- 
Joerg Roedel
Operating System Research Center
AMD Saxony LLC & Co. KG

--sdtB3X0nJg68CQEu
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: attachment;
 filename=kvm-svm-reboot.patch
Content-Transfer-Encoding: 7bit

diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index 714f6a7..1bbaa16 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -502,6 +502,7 @@ static void init_vmcb(struct vmcb *vmcb)
 				(1ULL << INTERCEPT_IOIO_PROT) |
 				(1ULL << INTERCEPT_MSR_PROT) |
 				(1ULL << INTERCEPT_TASK_SWITCH) |
+				(1ULL << INTERCEPT_SHUTDOWN) |
 				(1ULL << INTERCEPT_VMRUN) |
 				(1ULL << INTERCEPT_VMMCALL) |
 				(1ULL << INTERCEPT_VMLOAD) |
@@ -892,6 +893,19 @@ static int pf_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	return 0;
 }
 
+static int shutdown_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+{
+	/* 
+	 * VMCB is undefined after a SHUTDOWN intercept 
+	 * so reinitalize it
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
@@ -1249,6 +1263,7 @@ static int (*svm_exit_handlers[])(struct kvm_vcpu *vcpu,
 	[SVM_EXIT_IOIO] 		  	= io_interception,
 	[SVM_EXIT_MSR]				= msr_interception,
 	[SVM_EXIT_TASK_SWITCH]			= task_switch_interception,
+	[SVM_EXIT_SHUTDOWN]			= shutdown_interception,
 	[SVM_EXIT_VMRUN]			= invalid_op_interception,
 	[SVM_EXIT_VMMCALL]			= invalid_op_interception,
 	[SVM_EXIT_VMLOAD]			= invalid_op_interception,
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index bc8b461..1be148f 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -46,6 +46,7 @@ enum kvm_exit_reason {
 	KVM_EXIT_HLT              = 5,
 	KVM_EXIT_MMIO             = 6,
 	KVM_EXIT_IRQ_WINDOW_OPEN  = 7,
+	KVM_EXIT_SHUTDOWN         = 8,
 };
 
 /* for KVM_RUN */

--sdtB3X0nJg68CQEu--


