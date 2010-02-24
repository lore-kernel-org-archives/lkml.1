Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757570Ab0BXSBi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 13:01:38 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:2771 "EHLO
	VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757469Ab0BXR7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 12:59:40 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i6bh87h43h63h)
X-Spam-TCS-SCL: 2:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYCXZ2-01-2R8-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 05/11] KVM: SVM: Add kvm_nested_intercepts tracepoint
Date: Wed, 24 Feb 2010 18:59:14 +0100
Message-ID: <1267034360-5907-6-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1267034360-5907-1-git-send-email-joerg.roedel@amd.com>
References: <1267034360-5907-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 24 Feb 2010 17:59:23.0668 (UTC) FILETIME=[18E3FD40:01CAB57B]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a tracepoint to get information about the
most important intercept bitmasks from the nested vmcb.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c   |    5 +++++
 arch/x86/kvm/trace.h |   22 ++++++++++++++++++++++
 arch/x86/kvm/x86.c   |    1 +
 3 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index b048c2b..6b7590a 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1838,6 +1838,11 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 			       nested_vmcb->control.event_inj,
 			       nested_vmcb->control.nested_ctl);
 
+	trace_kvm_nested_intercepts(nested_vmcb->control.intercept_cr_read,
+				    nested_vmcb->control.intercept_cr_write,
+				    nested_vmcb->control.intercept_exceptions,
+				    nested_vmcb->control.intercept);
+
 	/* Clear internal status */
 	kvm_clear_exception_queue(&svm->vcpu);
 	kvm_clear_interrupt_queue(&svm->vcpu);
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 12f8d2d..17b52cc 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -419,6 +419,28 @@ TRACE_EVENT(kvm_nested_vmrun,
 		__entry->npt ? "on" : "off")
 );
 
+TRACE_EVENT(kvm_nested_intercepts,
+	    TP_PROTO(__u16 cr_read, __u16 cr_write, __u32 exceptions, __u64 intercept),
+	    TP_ARGS(cr_read, cr_write, exceptions, intercept),
+
+	TP_STRUCT__entry(
+		__field(	__u16,		cr_read		)
+		__field(	__u16,		cr_write	)
+		__field(	__u32,		exceptions	)
+		__field(	__u64,		intercept	)
+	),
+
+	TP_fast_assign(
+		__entry->cr_read	= cr_read;
+		__entry->cr_write	= cr_write;
+		__entry->exceptions	= exceptions;
+		__entry->intercept	= intercept;
+	),
+
+	TP_printk("cr_read: %04x cr_write: %04x excp: %08x intercept: %016llx",
+		__entry->cr_read, __entry->cr_write, __entry->exceptions,
+		__entry->intercept)
+);
 /*
  * Tracepoint for #VMEXIT while nested
  */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7b436c8..2c24cb5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5924,3 +5924,4 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmexit_inject);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_intr_vmexit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_invlpga);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_skinit);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_intercepts);
-- 
1.7.0


