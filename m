Return-Path: <linux-kernel-owner+w=401wt.eu-S1753662AbZKPMX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662AbZKPMX3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 07:23:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753450AbZKPMUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 07:20:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44452 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752904AbZKPMTl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 07:19:41 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 27/42] KVM: SVM: Remove remaining occurences of rdtscll
Date: Mon, 16 Nov 2009 14:19:28 +0200
Message-Id: <1258373983-8693-28-git-send-email-avi@redhat.com>
In-Reply-To: <1258373983-8693-1-git-send-email-avi@redhat.com>
References: <1258373983-8693-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

This patch replaces them with native_read_tsc() which can
also be used in expressions and saves a variable on the
stack in this case.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/kvm/svm.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 41c996a..9a4daca 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -763,14 +763,13 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	int i;
 
 	if (unlikely(cpu != vcpu->cpu)) {
-		u64 tsc_this, delta;
+		u64 delta;
 
 		/*
 		 * Make sure that the guest sees a monotonically
 		 * increasing TSC.
 		 */
-		rdtscll(tsc_this);
-		delta = vcpu->arch.host_tsc - tsc_this;
+		delta = vcpu->arch.host_tsc - native_read_tsc();
 		svm->vmcb->control.tsc_offset += delta;
 		if (is_nested(svm))
 			svm->nested.hsave->control.tsc_offset += delta;
@@ -792,7 +791,7 @@ static void svm_vcpu_put(struct kvm_vcpu *vcpu)
 	for (i = 0; i < NR_HOST_SAVE_USER_MSRS; i++)
 		wrmsrl(host_save_user_msrs[i], svm->host_user_msrs[i]);
 
-	rdtscll(vcpu->arch.host_tsc);
+	vcpu->arch.host_tsc = native_read_tsc();
 }
 
 static unsigned long svm_get_rflags(struct kvm_vcpu *vcpu)
-- 
1.6.5.2

