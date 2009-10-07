Return-Path: <linux-kernel-owner+w=401wt.eu-S1759384AbZJGOcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759384AbZJGOcq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 10:32:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759359AbZJGOcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 10:32:45 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:17972
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759358AbZJGOcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 10:32:41 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KR5F0X-01-FEL-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 05/10] KVM: SVM: Add tracepoint for nested #vmexit
Date: Wed, 7 Oct 2009 16:31:23 +0200
Message-ID: <1254925888-13743-6-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.4.3
In-Reply-To: <1254925888-13743-1-git-send-email-joerg.roedel@amd.com>
References: <1254925888-13743-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 07 Oct 2009 14:31:35.0264 (UTC) FILETIME=[DF4F8600:01CA475A]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
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
index 8de84be..e759732 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2355,6 +2355,12 @@ static int handle_exit(struct kvm_vcpu *vcpu)
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
index d63272c..a0b89c3 100644
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
+	TP_printk("rip=0x%016llx reason=%s ext_inf1=0x%016llx "
+		  "ext_inf2=0x%016llx ext_int=0x%08x ext_int_err=0x%08x\n",
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
index b51a824..416282e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4998,3 +4998,4 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_page_fault);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_msr);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_cr);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmrun);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmexit);
-- 
1.6.4.3


