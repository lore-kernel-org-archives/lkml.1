Return-Path: <linux-kernel-owner+w=401wt.eu-S1760953AbZJIOJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760953AbZJIOJh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 10:09:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760927AbZJIOJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 10:09:36 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:2757 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756715AbZJIOJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 10:09:33 -0400
X-SpamScore: 5
X-BigFish: VPS5(zba6lzzz1202hzzz32i6bh2a8h62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KR93AE-01-0U5-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 7/9] KVM: SVM: Add tracepoint for invlpga instruction
Date: Fri, 9 Oct 2009 16:08:31 +0200
Message-ID: <1255097313-23267-8-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.4.3
In-Reply-To: <1255097313-23267-1-git-send-email-joerg.roedel@amd.com>
References: <1255097313-23267-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 09 Oct 2009 14:08:36.0637 (UTC) FILETIME=[FE693CD0:01CA48E9]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a tracepoint for the event that the guest
executed the INVLPGA instruction.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c   |    3 +++
 arch/x86/kvm/trace.h |   23 +++++++++++++++++++++++
 arch/x86/kvm/x86.c   |    1 +
 3 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 78a391c..ba18fb7 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1976,6 +1976,9 @@ static int invlpga_interception(struct vcpu_svm *svm)
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 	nsvm_printk("INVLPGA\n");
 
+	trace_kvm_invlpga(svm->vmcb->save.rip, vcpu->arch.regs[VCPU_REGS_RCX],
+			  vcpu->arch.regs[VCPU_REGS_RAX]);
+
 	/* Let's treat INVLPGA the same as INVLPG (can be optimized!) */
 	kvm_mmu_invlpg(vcpu, vcpu->arch.regs[VCPU_REGS_RAX]);
 
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 3cc8f44..7e1f08e 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -469,6 +469,29 @@ TRACE_EVENT(kvm_nested_intr_vmexit,
 
 	TP_printk("rip: 0x%016llx\n", __entry->rip)
 );
+
+/*
+ * Tracepoint for nested #vmexit because of interrupt pending
+ */
+TRACE_EVENT(kvm_invlpga,
+	    TP_PROTO(__u64 rip, int asid, u64 address),
+	    TP_ARGS(rip, asid, address),
+
+	TP_STRUCT__entry(
+		__field(	__u64,	rip	)
+		__field(	int,	asid	)
+		__field(	__u64,	address	)
+	),
+
+	TP_fast_assign(
+		__entry->rip		=	rip;
+		__entry->asid		=	asid;
+		__entry->address	=	address;
+	),
+
+	TP_printk("rip: 0x%016llx asid: %d address: 0x%016llx\n",
+		  __entry->rip, __entry->asid, __entry->address)
+);
 #endif /* _TRACE_KVM_H */
 
 /* This part must be outside protection */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 877f910..1153d92 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4984,3 +4984,4 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmrun);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmexit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmexit_inject);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_intr_vmexit);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_invlpga);
-- 
1.6.4.3


