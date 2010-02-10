Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755780Ab0BJRXP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 12:23:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60385 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754494Ab0BJRXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 12:23:11 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 01/40] KVM: x86: make double/triple fault promotion generic to all exceptions
Date: Wed, 10 Feb 2010 19:22:30 +0200
Message-Id: <1265822589-11155-2-git-send-email-avi@redhat.com>
In-Reply-To: <1265822589-11155-1-git-send-email-avi@redhat.com>
References: <1265822589-11155-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eddie Dong <eddie.dong@intel.com>

Move Double-Fault generation logic out of page fault
exception generating function to cover more generic case.

Signed-off-by: Eddie Dong <eddie.dong@intel.com>
Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/kvm/x86.c |   89 +++++++++++++++++++++++++++++++++++----------------
 1 files changed, 61 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1ddcad4..b503614 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -257,12 +257,68 @@ void kvm_set_apic_base(struct kvm_vcpu *vcpu, u64 data)
 }
 EXPORT_SYMBOL_GPL(kvm_set_apic_base);
 
+#define EXCPT_BENIGN		0
+#define EXCPT_CONTRIBUTORY	1
+#define EXCPT_PF		2
+
+static int exception_class(int vector)
+{
+	switch (vector) {
+	case PF_VECTOR:
+		return EXCPT_PF;
+	case DE_VECTOR:
+	case TS_VECTOR:
+	case NP_VECTOR:
+	case SS_VECTOR:
+	case GP_VECTOR:
+		return EXCPT_CONTRIBUTORY;
+	default:
+		break;
+	}
+	return EXCPT_BENIGN;
+}
+
+static void kvm_multiple_exception(struct kvm_vcpu *vcpu,
+		unsigned nr, bool has_error, u32 error_code)
+{
+	u32 prev_nr;
+	int class1, class2;
+
+	if (!vcpu->arch.exception.pending) {
+	queue:
+		vcpu->arch.exception.pending = true;
+		vcpu->arch.exception.has_error_code = has_error;
+		vcpu->arch.exception.nr = nr;
+		vcpu->arch.exception.error_code = error_code;
+		return;
+	}
+
+	/* to check exception */
+	prev_nr = vcpu->arch.exception.nr;
+	if (prev_nr == DF_VECTOR) {
+		/* triple fault -> shutdown */
+		set_bit(KVM_REQ_TRIPLE_FAULT, &vcpu->requests);
+		return;
+	}
+	class1 = exception_class(prev_nr);
+	class2 = exception_class(nr);
+	if ((class1 == EXCPT_CONTRIBUTORY && class2 == EXCPT_CONTRIBUTORY)
+		|| (class1 == EXCPT_PF && class2 != EXCPT_BENIGN)) {
+		/* generate double fault per SDM Table 5-5 */
+		vcpu->arch.exception.pending = true;
+		vcpu->arch.exception.has_error_code = true;
+		vcpu->arch.exception.nr = DF_VECTOR;
+		vcpu->arch.exception.error_code = 0;
+	} else
+		/* replace previous exception with a new one in a hope
+		   that instruction re-execution will regenerate lost
+		   exception */
+		goto queue;
+}
+
 void kvm_queue_exception(struct kvm_vcpu *vcpu, unsigned nr)
 {
-	WARN_ON(vcpu->arch.exception.pending);
-	vcpu->arch.exception.pending = true;
-	vcpu->arch.exception.has_error_code = false;
-	vcpu->arch.exception.nr = nr;
+	kvm_multiple_exception(vcpu, nr, false, 0);
 }
 EXPORT_SYMBOL_GPL(kvm_queue_exception);
 
@@ -270,25 +326,6 @@ void kvm_inject_page_fault(struct kvm_vcpu *vcpu, unsigned long addr,
 			   u32 error_code)
 {
 	++vcpu->stat.pf_guest;
-
-	if (vcpu->arch.exception.pending) {
-		switch(vcpu->arch.exception.nr) {
-		case DF_VECTOR:
-			/* triple fault -> shutdown */
-			set_bit(KVM_REQ_TRIPLE_FAULT, &vcpu->requests);
-			return;
-		case PF_VECTOR:
-			vcpu->arch.exception.nr = DF_VECTOR;
-			vcpu->arch.exception.error_code = 0;
-			return;
-		default:
-			/* replace previous exception with a new one in a hope
-			   that instruction re-execution will regenerate lost
-			   exception */
-			vcpu->arch.exception.pending = false;
-			break;
-		}
-	}
 	vcpu->arch.cr2 = addr;
 	kvm_queue_exception_e(vcpu, PF_VECTOR, error_code);
 }
@@ -301,11 +338,7 @@ EXPORT_SYMBOL_GPL(kvm_inject_nmi);
 
 void kvm_queue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_code)
 {
-	WARN_ON(vcpu->arch.exception.pending);
-	vcpu->arch.exception.pending = true;
-	vcpu->arch.exception.has_error_code = true;
-	vcpu->arch.exception.nr = nr;
-	vcpu->arch.exception.error_code = error_code;
+	kvm_multiple_exception(vcpu, nr, true, error_code);
 }
 EXPORT_SYMBOL_GPL(kvm_queue_exception_e);
 
-- 
1.6.5.3

