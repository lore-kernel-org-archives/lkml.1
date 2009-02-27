Return-Path: <linux-kernel-owner+w=401wt.eu-S1759998AbZB0Kc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759998AbZB0Kc2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 05:32:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757714AbZB0K1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 05:27:31 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53566 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755366AbZB0K1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 05:27:09 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 12/37] KVM: VMX: Fix guest state validity checks
Date: Fri, 27 Feb 2009 12:26:35 +0200
Message-Id: <1235730420-7929-13-git-send-email-avi@redhat.com>
In-Reply-To: <1235730420-7929-1-git-send-email-avi@redhat.com>
References: <1235730420-7929-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The vmx guest state validity checks are full of bugs.  Make them
conform to the manual.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/vmx.c |   18 ++++++++++++++----
 1 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 3312047..be94410 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1784,14 +1784,16 @@ static bool code_segment_valid(struct kvm_vcpu *vcpu)
 	vmx_get_segment(vcpu, &cs, VCPU_SREG_CS);
 	cs_rpl = cs.selector & SELECTOR_RPL_MASK;
 
+	if (cs.unusable)
+		return false;
 	if (~cs.type & (AR_TYPE_CODE_MASK|AR_TYPE_ACCESSES_MASK))
 		return false;
 	if (!cs.s)
 		return false;
-	if (!(~cs.type & (AR_TYPE_CODE_MASK|AR_TYPE_WRITEABLE_MASK))) {
+	if (cs.type & AR_TYPE_WRITEABLE_MASK) {
 		if (cs.dpl > cs_rpl)
 			return false;
-	} else if (cs.type & AR_TYPE_CODE_MASK) {
+	} else {
 		if (cs.dpl != cs_rpl)
 			return false;
 	}
@@ -1810,7 +1812,9 @@ static bool stack_segment_valid(struct kvm_vcpu *vcpu)
 	vmx_get_segment(vcpu, &ss, VCPU_SREG_SS);
 	ss_rpl = ss.selector & SELECTOR_RPL_MASK;
 
-	if ((ss.type != 3) || (ss.type != 7))
+	if (ss.unusable)
+		return true;
+	if (ss.type != 3 && ss.type != 7)
 		return false;
 	if (!ss.s)
 		return false;
@@ -1830,6 +1834,8 @@ static bool data_segment_valid(struct kvm_vcpu *vcpu, int seg)
 	vmx_get_segment(vcpu, &var, seg);
 	rpl = var.selector & SELECTOR_RPL_MASK;
 
+	if (var.unusable)
+		return true;
 	if (!var.s)
 		return false;
 	if (!var.present)
@@ -1851,9 +1857,11 @@ static bool tr_valid(struct kvm_vcpu *vcpu)
 
 	vmx_get_segment(vcpu, &tr, VCPU_SREG_TR);
 
+	if (tr.unusable)
+		return false;
 	if (tr.selector & SELECTOR_TI_MASK)	/* TI = 1 */
 		return false;
-	if ((tr.type != 3) || (tr.type != 11)) /* TODO: Check if guest is in IA32e mode */
+	if (tr.type != 3 && tr.type != 11) /* TODO: Check if guest is in IA32e mode */
 		return false;
 	if (!tr.present)
 		return false;
@@ -1867,6 +1875,8 @@ static bool ldtr_valid(struct kvm_vcpu *vcpu)
 
 	vmx_get_segment(vcpu, &ldtr, VCPU_SREG_LDTR);
 
+	if (ldtr.unusable)
+		return true;
 	if (ldtr.selector & SELECTOR_TI_MASK)	/* TI = 1 */
 		return false;
 	if (ldtr.type != 2)
-- 
1.6.0.6

