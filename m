Return-Path: <linux-kernel-owner+w=401wt.eu-S1760980AbZJIOJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760980AbZJIOJw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 10:09:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760967AbZJIOJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 10:09:50 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:2859 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760938AbZJIOJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 10:09:47 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i2a8h6bh43j65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-WSS-ID: 0KR93AH-04-7X9-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6/9] KVM: SVM: Add tracepoint for #vmexit because intr pending
Date: Fri, 9 Oct 2009 16:08:30 +0200
Message-ID: <1255097313-23267-7-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.4.3
In-Reply-To: <1255097313-23267-1-git-send-email-joerg.roedel@amd.com>
References: <1255097313-23267-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 09 Oct 2009 14:08:36.0622 (UTC) FILETIME=[FE66F2E0:01CA48E9]
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
 arch/x86/kvm/svm.c   |    2 +-
 arch/x86/kvm/trace.h |   18 ++++++++++++++++++
 arch/x86/kvm/x86.c   |    1 +
 3 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 369eeb8..78a391c 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1390,7 +1390,7 @@ static inline int nested_svm_intr(struct vcpu_svm *svm)
 		 * the #vmexit here.
 		 */
 		svm->nested.exit_required = true;
-		nsvm_printk("VMexit -> INTR\n");
+		trace_kvm_nested_intr_vmexit(svm->vmcb->save.rip);
 		return 1;
 	}
 
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 4d6bb5e..3cc8f44 100644
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
+	TP_printk("rip: 0x%016llx\n", __entry->rip)
+);
 #endif /* _TRACE_KVM_H */
 
 /* This part must be outside protection */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4f90d45..877f910 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4983,3 +4983,4 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_cr);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmrun);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmexit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmexit_inject);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_intr_vmexit);
-- 
1.6.4.3


