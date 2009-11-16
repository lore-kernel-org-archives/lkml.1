Return-Path: <linux-kernel-owner+w=401wt.eu-S1753761AbZKPMWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761AbZKPMWh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 07:22:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753477AbZKPMUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 07:20:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49998 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752994AbZKPMTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 07:19:43 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 42/42] KVM: SVM: Add tracepoint for injected #vmexit
Date: Mon, 16 Nov 2009 14:19:43 +0200
Message-Id: <1258373983-8693-43-git-send-email-avi@redhat.com>
In-Reply-To: <1258373983-8693-1-git-send-email-avi@redhat.com>
References: <1258373983-8693-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

This patch adds a tracepoint for a nested #vmexit that gets
re-injected to the guest.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
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
index 192d58e..a522d9b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4986,3 +4986,4 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_msr);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_cr);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmrun);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmexit);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmexit_inject);
-- 
1.6.5.2

