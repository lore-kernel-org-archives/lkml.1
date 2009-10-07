Return-Path: <linux-kernel-owner+w=401wt.eu-S1759399AbZJGOcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759399AbZJGOcu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 10:32:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759388AbZJGOcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 10:32:48 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:29330 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759359AbZJGOcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 10:32:47 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KR5F12-01-FEU-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 09/10] KVM: SVM: Add tracepoint for skinit instruction
Date: Wed, 7 Oct 2009 16:31:27 +0200
Message-ID: <1254925888-13743-10-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.4.3
In-Reply-To: <1254925888-13743-1-git-send-email-joerg.roedel@amd.com>
References: <1254925888-13743-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 07 Oct 2009 14:31:35.0405 (UTC) FILETIME=[DF6509D0:01CA475A]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a tracepoint for the event that the guest
executed the SKINIT instruction. This information is
important because SKINIT is an SVM extenstion not yet
implemented by nested SVM and we may need this information
for debugging hypervisors that do not yet run on nested SVM.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c   |   10 +++++++++-
 arch/x86/kvm/trace.h |   22 ++++++++++++++++++++++
 arch/x86/kvm/x86.c   |    1 +
 3 files changed, 32 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 563ddd3..5082558 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1984,6 +1984,14 @@ static int invlpga_interception(struct vcpu_svm *svm)
 	return 1;
 }
 
+static int skinit_interception(struct vcpu_svm *svm)
+{
+	trace_kvm_skinit(svm->vmcb->save.rip, svm->vcpu.arch.regs[VCPU_REGS_RAX]);
+
+	kvm_queue_exception(&svm->vcpu, UD_VECTOR);
+	return 1;
+}
+
 static int invalid_op_interception(struct vcpu_svm *svm)
 {
 	kvm_queue_exception(&svm->vcpu, UD_VECTOR);
@@ -2347,7 +2355,7 @@ static int (*svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	[SVM_EXIT_VMSAVE]			= vmsave_interception,
 	[SVM_EXIT_STGI]				= stgi_interception,
 	[SVM_EXIT_CLGI]				= clgi_interception,
-	[SVM_EXIT_SKINIT]			= invalid_op_interception,
+	[SVM_EXIT_SKINIT]			= skinit_interception,
 	[SVM_EXIT_WBINVD]                       = emulate_on_interception,
 	[SVM_EXIT_MONITOR]			= invalid_op_interception,
 	[SVM_EXIT_MWAIT]			= invalid_op_interception,
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index a6dcd2d..7948b49 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -492,6 +492,28 @@ TRACE_EVENT(kvm_invlpga,
 	TP_printk("rip=0x%016llx asid=%d adress=0x%016llx\n",
 		  __entry->rip, __entry->asid, __entry->address)
 );
+
+/*
+ * Tracepoint for nested #vmexit because of interrupt pending
+ */
+TRACE_EVENT(kvm_skinit,
+	    TP_PROTO(__u64 rip, __u32 slb),
+	    TP_ARGS(rip, slb),
+
+	TP_STRUCT__entry(
+		__field(	__u64,	rip	)
+		__field(	__u32,	slb	)
+	),
+
+	TP_fast_assign(
+		__entry->rip		=	rip;
+		__entry->slb		=	slb;
+	),
+
+	TP_printk("rip=0x%016llx slb=0x%08x\n",
+		  __entry->rip, __entry->slb)
+);
+
 #endif /* _TRACE_KVM_H */
 
 /* This part must be outside protection */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 18284e1..8043d76 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5002,3 +5002,4 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmexit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmexit_inject);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_intr_vmexit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_invlpga);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_skinit);
-- 
1.6.4.3


