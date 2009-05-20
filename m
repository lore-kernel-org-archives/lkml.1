Return-Path: <linux-kernel-owner+w=401wt.eu-S1757546AbZETLWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757546AbZETLWs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 07:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756313AbZETLTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 07:19:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55292 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755813AbZETLSv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 07:18:51 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 38/46] KVM: ia64: preserve int status through call to kvm_insert_vmm_mapping
Date: Wed, 20 May 2009 14:18:35 +0300
Message-Id: <1242818323-10413-39-git-send-email-avi@redhat.com>
In-Reply-To: <1242818323-10413-1-git-send-email-avi@redhat.com>
References: <1242818323-10413-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jes Sorensen <jes@sgi.com>

Preserve interrupt status around call to kvm_insert_vmm_mappin()
in kvm_vcpu_pre_transition().

Signed-off-by: Jes Sorensen <jes@sgi.com>
Acked-by: Xiantao Zhang <xiantao.zhang@intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/ia64/kvm/kvm-ia64.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index 5b868db..cf5a193 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -619,6 +619,8 @@ static void kvm_purge_vmm_mapping(struct kvm_vcpu *vcpu)
 
 static int kvm_vcpu_pre_transition(struct kvm_vcpu *vcpu)
 {
+	unsigned long psr;
+	int r;
 	int cpu = smp_processor_id();
 
 	if (vcpu->arch.last_run_cpu != cpu ||
@@ -630,7 +632,10 @@ static int kvm_vcpu_pre_transition(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.host_rr6 = ia64_get_rr(RR6);
 	vti_set_rr6(vcpu->arch.vmm_rr);
-	return kvm_insert_vmm_mapping(vcpu);
+	local_irq_save(psr);
+	r = kvm_insert_vmm_mapping(vcpu);
+	local_irq_restore(psr);
+	return r;
 }
 
 static void kvm_vcpu_post_transition(struct kvm_vcpu *vcpu)
-- 
1.6.0.6

