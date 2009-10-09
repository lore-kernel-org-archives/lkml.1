Return-Path: <linux-kernel-owner+w=401wt.eu-S1760964AbZJIOJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760964AbZJIOJq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 10:09:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760938AbZJIOJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 10:09:34 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:2859 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760919AbZJIOJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 10:09:32 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i6bh2a8h43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KR93AG-04-7X8-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 4/9] KVM: SVM: Add tracepoint for nested #vmexit
Date: Fri, 9 Oct 2009 16:08:28 +0200
Message-ID: <1255097313-23267-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.4.3
In-Reply-To: <1255097313-23267-1-git-send-email-joerg.roedel@amd.com>
References: <1255097313-23267-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 09 Oct 2009 14:08:36.0372 (UTC) FILETIME=[FE40CD40:01CA48E9]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a tracepoint for every #vmexit we get from a
nested guest.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c   |    6 ++++++
 arch/x86/kvm/trace.h |   36 ++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c   |    1 +
 3 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 907af3f..edf6e8b 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2366,6 +2366,12 @@ static int handle_exit(struct kvm_vcpu *vcpu)
 	if (is_nested(svm)) {
 		int vmexit;
 
+		trace_kvm_nested_vmexit(svm->vmcb->save.rip, exit_code,
+					svm->vmcb->control.exit_info_1,
+					svm->vmcb->control.exit_info_2,
+					svm->vmcb->control.exit_int_info,
+					svm->vmcb->control.exit_int_info_err);
+
 		nsvm_printk("nested handle_exit: 0x%x | 0x%lx | 0x%lx | 0x%lx\n",
 			    exit_code, svm->vmcb->control.exit_info_1,
 			    svm->vmcb->control.exit_info_2, svm->vmcb->save.rip);
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index b5798e1..a7eb629 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -382,6 +382,42 @@ TRACE_EVENT(kvm_nested_vmrun,
 		__entry->npt ? "on" : "off")
 );
 
+/*
+ * Tracepoint for #VMEXIT while nested
+ */
+TRACE_EVENT(kvm_nested_vmexit,
+	    TP_PROTO(__u64 rip, __u32 exit_code,
+		     __u64 exit_info1, __u64 exit_info2,
+		     __u32 exit_int_info, __u32 exit_int_info_err),
+	    TP_ARGS(rip, exit_code, exit_info1, exit_info2,
+		    exit_int_info, exit_int_info_err),
+
+	TP_STRUCT__entry(
+		__field(	__u64,		rip			)
+		__field(	__u32,		exit_code		)
+		__field(	__u64,		exit_info1		)
+		__field(	__u64,		exit_info2		)
+		__field(	__u32,		exit_int_info		)
+		__field(	__u32,		exit_int_info_err	)
+	),
+
+	TP_fast_assign(
+		__entry->rip			= rip;
+		__entry->exit_code		= exit_code;
+		__entry->exit_info1		= exit_info1;
+		__entry->exit_info2		= exit_info2;
+		__entry->exit_int_info		= exit_int_info;
+		__entry->exit_int_info_err	= exit_int_info_err;
+	),
+	TP_printk("rip: 0x%016llx reason: %s ext_inf1: 0x%016llx "
+		  "ext_inf2: 0x%016llx ext_int: 0x%08x ext_int_err: 0x%08x\n",
+		  __entry->rip,
+		  ftrace_print_symbols_seq(p, __entry->exit_code,
+					   kvm_x86_ops->exit_reasons_str),
+		  __entry->exit_info1, __entry->exit_info2,
+		  __entry->exit_int_info, __entry->exit_int_info_err)
+);
+
 #endif /* _TRACE_KVM_H */
 
 /* This part must be outside protection */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f1e44e9..00c8b60 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4981,3 +4981,4 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_page_fault);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_msr);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_cr);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmrun);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmexit);
-- 
1.6.4.3


