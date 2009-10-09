Return-Path: <linux-kernel-owner+w=401wt.eu-S933078AbZJIOKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933078AbZJIOKV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 10:10:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932377AbZJIOKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 10:10:18 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:21102
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760928AbZJIOJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 10:09:33 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i6bh2a8h43j63h)
X-Spam-TCS-SCL: 2:0
X-FB-SS: 5,
X-WSS-ID: 0KR93AJ-04-7XA-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 8/9] KVM: SVM: Add tracepoint for skinit instruction
Date: Fri, 9 Oct 2009 16:08:32 +0200
Message-ID: <1255097313-23267-9-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.4.3
In-Reply-To: <1255097313-23267-1-git-send-email-joerg.roedel@amd.com>
References: <1255097313-23267-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 09 Oct 2009 14:08:36.0637 (UTC) FILETIME=[FE693CD0:01CA48E9]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
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
index ba18fb7..8b9f6fb 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1987,6 +1987,14 @@ static int invlpga_interception(struct vcpu_svm *svm)
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
@@ -2350,7 +2358,7 @@ static int (*svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	[SVM_EXIT_VMSAVE]			= vmsave_interception,
 	[SVM_EXIT_STGI]				= stgi_interception,
 	[SVM_EXIT_CLGI]				= clgi_interception,
-	[SVM_EXIT_SKINIT]			= invalid_op_interception,
+	[SVM_EXIT_SKINIT]			= skinit_interception,
 	[SVM_EXIT_WBINVD]                       = emulate_on_interception,
 	[SVM_EXIT_MONITOR]			= invalid_op_interception,
 	[SVM_EXIT_MWAIT]			= invalid_op_interception,
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 7e1f08e..816e044 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -492,6 +492,28 @@ TRACE_EVENT(kvm_invlpga,
 	TP_printk("rip: 0x%016llx asid: %d address: 0x%016llx\n",
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
+	TP_printk("rip: 0x%016llx slb: 0x%08x\n",
+		  __entry->rip, __entry->slb)
+);
+
 #endif /* _TRACE_KVM_H */
 
 /* This part must be outside protection */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1153d92..ed4622c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4985,3 +4985,4 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmexit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmexit_inject);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_intr_vmexit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_invlpga);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_skinit);
-- 
1.6.4.3


