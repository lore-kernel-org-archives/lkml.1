Return-Path: <linux-kernel-owner+w=401wt.eu-S1752739AbZHSNJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739AbZHSNJd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 09:09:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751942AbZHSNJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 09:09:32 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50555 "EHLO mx2.redhat.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751894AbZHSNCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 09:02:47 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 14/47] KVM: Replace pending exception by PF if it happens serially
Date: Wed, 19 Aug 2009 16:02:10 +0300
Message-Id: <1250686963-8357-15-git-send-email-avi@redhat.com>
In-Reply-To: <1250686963-8357-1-git-send-email-avi@redhat.com>
References: <1250686963-8357-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

Replace previous exception with a new one in a hope that instruction
re-execution will regenerate lost exception.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c |   20 +++++++++++++-------
 1 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 30492f0..a066876 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -181,16 +181,22 @@ void kvm_inject_page_fault(struct kvm_vcpu *vcpu, unsigned long addr,
 	++vcpu->stat.pf_guest;
 
 	if (vcpu->arch.exception.pending) {
-		if (vcpu->arch.exception.nr == PF_VECTOR) {
-			printk(KERN_DEBUG "kvm: inject_page_fault:"
-					" double fault 0x%lx\n", addr);
-			vcpu->arch.exception.nr = DF_VECTOR;
-			vcpu->arch.exception.error_code = 0;
-		} else if (vcpu->arch.exception.nr == DF_VECTOR) {
+		switch(vcpu->arch.exception.nr) {
+		case DF_VECTOR:
 			/* triple fault -> shutdown */
 			set_bit(KVM_REQ_TRIPLE_FAULT, &vcpu->requests);
+			return;
+		case PF_VECTOR:
+			vcpu->arch.exception.nr = DF_VECTOR;
+			vcpu->arch.exception.error_code = 0;
+			return;
+		default:
+			/* replace previous exception with a new one in a hope
+			   that instruction re-execution will regenerate lost
+			   exception */
+			vcpu->arch.exception.pending = false;
+			break;
 		}
-		return;
 	}
 	vcpu->arch.cr2 = addr;
 	kvm_queue_exception_e(vcpu, PF_VECTOR, error_code);
-- 
1.6.3.3

