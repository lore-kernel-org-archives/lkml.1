Return-Path: <linux-kernel-owner+w=401wt.eu-S932309AbZJHKF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932309AbZJHKF3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 06:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932283AbZJHKF1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 06:05:27 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:46595 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932085AbZJHKFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 06:05:23 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i6bh65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-WSS-ID: 0KR6XB5-01-3BD-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6/9] KVM: SVM: Add tracepoint for #vmexit because intr pending
Date: Thu, 8 Oct 2009 12:03:16 +0200
Message-ID: <1254996199-17667-7-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.4.3
In-Reply-To: <1254996199-17667-1-git-send-email-joerg.roedel@amd.com>
References: <1254996199-17667-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 08 Oct 2009 10:03:23.0744 (UTC) FILETIME=[926E2E00:01CA47FE]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
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


