Return-Path: <linux-kernel-owner+w=401wt.eu-S932564AbZJGOdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932564AbZJGOdR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 10:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932483AbZJGOdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 10:33:15 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:45640
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932456AbZJGOdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 10:33:12 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KR5F0Y-02-3PG-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 04/10] KVM: SVM: Add tracepoint for nested vmrun
Date: Wed, 7 Oct 2009 16:31:22 +0200
Message-ID: <1254925888-13743-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.4.3
In-Reply-To: <1254925888-13743-1-git-send-email-joerg.roedel@amd.com>
References: <1254925888-13743-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 07 Oct 2009 14:31:35.0233 (UTC) FILETIME=[DF4ACB10:01CA475A]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a dedicated kvm tracepoint for a nested
vmrun.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c   |    6 ++++++
 arch/x86/kvm/trace.h |   33 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c   |    1 +
 3 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 7015680..8de84be 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1722,6 +1722,12 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 	/* nested_vmcb is our indicator if nested SVM is activated */
 	svm->nested.vmcb = svm->vmcb->save.rax;
 
+	trace_kvm_nested_vmrun(svm->vmcb->save.rip - 3, svm->nested.vmcb,
+			       nested_vmcb->save.rip,
+			       nested_vmcb->control.int_ctl,
+			       nested_vmcb->control.event_inj,
+			       nested_vmcb->control.nested_ctl);
+
 	/* Clear internal status */
 	kvm_clear_exception_queue(&svm->vcpu);
 	kvm_clear_interrupt_queue(&svm->vcpu);
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 0d480e7..d63272c 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -349,6 +349,39 @@ TRACE_EVENT(kvm_apic_accept_irq,
 		  __entry->coalesced ? " (coalesced)" : "")
 );
 
+/*
+ * Tracepoint for nested VMRUN
+ */
+TRACE_EVENT(kvm_nested_vmrun,
+	    TP_PROTO(__u64 rip, __u64 vmcb, __u64 nested_rip, __u32 int_ctl,
+		     __u32 event_inj, bool npt),
+	    TP_ARGS(rip, vmcb, nested_rip, int_ctl, event_inj, npt),
+
+	TP_STRUCT__entry(
+		__field(	__u64,		rip		)
+		__field(	__u64,		vmcb		)
+		__field(	__u64,		nested_rip	)
+		__field(	__u32,		int_ctl		)
+		__field(	__u32,		event_inj	)
+		__field(	bool,		npt		)
+	),
+
+	TP_fast_assign(
+		__entry->rip		= rip;
+		__entry->vmcb		= vmcb;
+		__entry->nested_rip	= nested_rip;
+		__entry->int_ctl	= int_ctl;
+		__entry->event_inj	= event_inj;
+		__entry->npt		= npt;
+	),
+
+	TP_printk("rip=0x%016llx vmcb=0x%016llx nrip=0x%016llx int_ctl=0x%08x "
+		  "event_inj=0x%08x npt=%s\n",
+		__entry->rip, __entry->vmcb, __entry->nested_rip,
+		__entry->int_ctl, __entry->event_inj,
+		__entry->npt ? "on" : "off")
+);
+
 #endif /* _TRACE_KVM_H */
 
 /* This part must be outside protection */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 97e1d9d..b51a824 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4997,3 +4997,4 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_inj_virq);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_page_fault);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_msr);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_cr);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmrun);
-- 
1.6.4.3


