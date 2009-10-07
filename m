Return-Path: <linux-kernel-owner+w=401wt.eu-S1759411AbZJGOcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759411AbZJGOcx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 10:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759390AbZJGOcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 10:32:50 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:29168 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759381AbZJGOcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 10:32:46 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i6bh43j65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-WSS-ID: 0KR5F10-01-FEQ-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 07/10] KVM: SVM: Add tracepoint for #vmexit because intr pending
Date: Wed, 7 Oct 2009 16:31:25 +0200
Message-ID: <1254925888-13743-8-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.4.3
In-Reply-To: <1254925888-13743-1-git-send-email-joerg.roedel@amd.com>
References: <1254925888-13743-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 07 Oct 2009 14:31:35.0327 (UTC) FILETIME=[DF5922F0:01CA475A]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a special tracepoint for the event that a
nested #vmexit is injected because kvm wants to inject an
interrupt into the guest.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c   |    1 +
 arch/x86/kvm/trace.h |   18 ++++++++++++++++++
 arch/x86/kvm/x86.c   |    1 +
 3 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 4de75e3..a03dba1 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1387,6 +1387,7 @@ static inline int nested_svm_intr(struct vcpu_svm *svm)
 		 * the #vmexit here.
 		 */
 		set_bit(KVM_REQ_VMEXIT, &svm->vcpu.requests);
+		trace_kvm_nested_intr_vmexit(svm->vmcb->save.rip);
 		return 1;
 	}
 
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index a00b235..20248a1 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -451,6 +451,24 @@ TRACE_EVENT(kvm_nested_vmexit_inject,
 		__entry->exit_info1, __entry->exit_info2,
 		__entry->exit_int_info, __entry->exit_int_info_err)
 );
+
+/*
+ * Tracepoint for nested #vmexit because of interrupt pending
+ */
+TRACE_EVENT(kvm_nested_intr_vmexit,
+	    TP_PROTO(__u64 rip),
+	    TP_ARGS(rip),
+
+	TP_STRUCT__entry(
+		__field(	__u64,	rip	)
+	),
+
+	TP_fast_assign(
+		__entry->rip	=	rip
+	),
+
+	TP_printk("rip=0x%016llx\n", __entry->rip)
+);
 #endif /* _TRACE_KVM_H */
 
 /* This part must be outside protection */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c7ea2d8..e0a8517 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5000,3 +5000,4 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_cr);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmrun);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmexit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmexit_inject);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_intr_vmexit);
-- 
1.6.4.3


