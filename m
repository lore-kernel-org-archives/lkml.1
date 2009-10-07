Return-Path: <linux-kernel-owner+w=401wt.eu-S1759371AbZJGOco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759371AbZJGOco (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 10:32:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759359AbZJGOcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 10:32:43 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:45640
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759357AbZJGOcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 10:32:41 -0400
X-SpamScore: 5
X-BigFish: VPS5(zba6lzzz1202hzzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KR5F11-01-FER-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 08/10] KVM: SVM: Add tracepoint for invlpga instruction
Date: Wed, 7 Oct 2009 16:31:26 +0200
Message-ID: <1254925888-13743-9-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.4.3
In-Reply-To: <1254925888-13743-1-git-send-email-joerg.roedel@amd.com>
References: <1254925888-13743-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 07 Oct 2009 14:31:35.0358 (UTC) FILETIME=[DF5DDDE0:01CA475A]
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
index a03dba1..563ddd3 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1973,6 +1973,9 @@ static int invlpga_interception(struct vcpu_svm *svm)
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 	nsvm_printk("INVLPGA\n");
 
+	trace_kvm_invlpga(svm->vmcb->save.rip, vcpu->arch.regs[VCPU_REGS_RCX],
+			  vcpu->arch.regs[VCPU_REGS_RAX]);
+
 	/* Let's treat INVLPGA the same as INVLPG (can be optimized!) */
 	kvm_mmu_invlpg(vcpu, vcpu->arch.regs[VCPU_REGS_RAX]);
 
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 20248a1..a6dcd2d 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -469,6 +469,29 @@ TRACE_EVENT(kvm_nested_intr_vmexit,
 
 	TP_printk("rip=0x%016llx\n", __entry->rip)
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
+	TP_printk("rip=0x%016llx asid=%d adress=0x%016llx\n",
+		  __entry->rip, __entry->asid, __entry->address)
+);
 #endif /* _TRACE_KVM_H */
 
 /* This part must be outside protection */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e0a8517..18284e1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5001,3 +5001,4 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmrun);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmexit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmexit_inject);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_intr_vmexit);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_invlpga);
-- 
1.6.4.3


