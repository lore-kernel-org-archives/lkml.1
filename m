Return-Path: <linux-kernel-owner+w=401wt.eu-S1754046AbZKSNfN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbZKSNfN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 08:35:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753841AbZKSNfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 08:35:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19577 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752682AbZKSNfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 08:35:07 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 01/35] KVM: SVM: Add tracepoint for #vmexit because intr pending
Date: Thu, 19 Nov 2009 15:34:37 +0200
Message-Id: <1258637711-11674-2-git-send-email-avi@redhat.com>
In-Reply-To: <1258637711-11674-1-git-send-email-avi@redhat.com>
References: <1258637711-11674-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

This patch adds a special tracepoint for the event that a
nested #vmexit is injected because kvm wants to inject an
interrupt into the guest.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
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
index a522d9b..2cf4146 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4987,3 +4987,4 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_cr);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmrun);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmexit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmexit_inject);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_intr_vmexit);
-- 
1.6.5.2

