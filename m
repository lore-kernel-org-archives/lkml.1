Return-Path: <linux-kernel-owner+w=401wt.eu-S933521AbZJIRGI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933521AbZJIRGI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 13:06:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761176AbZJIRGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 13:06:07 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:36643 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758850AbZJIRGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 13:06:06 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i6bh2a8h43j66h)
X-Spam-TCS-SCL: 5:0
X-FB-SS: 5,
X-WSS-ID: 0KR9BG6-02-00D-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 5/9] KVM: SVM: Add tracepoint for injected #vmexit
Date: Fri, 9 Oct 2009 16:08:29 +0200
Message-ID: <1255097313-23267-6-git-send-email-joerg.roedel@amd.com>
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

This patch adds a tracepoint for a nested #vmexit that gets
re-injected to the guest.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c   |    6 ++++++
 arch/x86/kvm/trace.h |   33 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c   |    1 +
 3 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index edf6e8b..369eeb8 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1592,6 +1592,12 @@ static int nested_svm_vmexit(struct vcpu_svm *svm)
 	struct vmcb *hsave = svm->nested.hsave;
 	struct vmcb *vmcb = svm->vmcb;
 
+	trace_kvm_nested_vmexit_inject(vmcb->control.exit_code,
+				       vmcb->control.exit_info_1,
+				       vmcb->control.exit_info_2,
+				       vmcb->control.exit_int_info,
+				       vmcb->control.exit_int_info_err);
+
 	nested_vmcb = nested_svm_map(svm, svm->nested.vmcb, KM_USER0);
 	if (!nested_vmcb)
 		return 1;
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index a7eb629..4d6bb5e 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -418,6 +418,39 @@ TRACE_EVENT(kvm_nested_vmexit,
 		  __entry->exit_int_info, __entry->exit_int_info_err)
 );
 
+/*
+ * Tracepoint for #VMEXIT reinjected to the guest
+ */
+TRACE_EVENT(kvm_nested_vmexit_inject,
+	    TP_PROTO(__u32 exit_code,
+		     __u64 exit_info1, __u64 exit_info2,
+		     __u32 exit_int_info, __u32 exit_int_info_err),
+	    TP_ARGS(exit_code, exit_info1, exit_info2,
+		    exit_int_info, exit_int_info_err),
+
+	TP_STRUCT__entry(
+		__field(	__u32,		exit_code		)
+		__field(	__u64,		exit_info1		)
+		__field(	__u64,		exit_info2		)
+		__field(	__u32,		exit_int_info		)
+		__field(	__u32,		exit_int_info_err	)
+	),
+
+	TP_fast_assign(
+		__entry->exit_code		= exit_code;
+		__entry->exit_info1		= exit_info1;
+		__entry->exit_info2		= exit_info2;
+		__entry->exit_int_info		= exit_int_info;
+		__entry->exit_int_info_err	= exit_int_info_err;
+	),
+
+	TP_printk("reason: %s ext_inf1: 0x%016llx "
+		  "ext_inf2: 0x%016llx ext_int: 0x%08x ext_int_err: 0x%08x\n",
+		  ftrace_print_symbols_seq(p, __entry->exit_code,
+					   kvm_x86_ops->exit_reasons_str),
+		__entry->exit_info1, __entry->exit_info2,
+		__entry->exit_int_info, __entry->exit_int_info_err)
+);
 #endif /* _TRACE_KVM_H */
 
 /* This part must be outside protection */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 00c8b60..4f90d45 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4982,3 +4982,4 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_msr);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_cr);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmrun);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmexit);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmexit_inject);
-- 
1.6.4.3


