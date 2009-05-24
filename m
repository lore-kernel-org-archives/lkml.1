Return-Path: <linux-kernel-owner+w=401wt.eu-S1757653AbZEXP5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757653AbZEXP5N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 11:57:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758574AbZEXPw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 11:52:56 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41850 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754838AbZEXPue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 11:50:34 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 33/45] KVM: s390: Unlink vcpu on destroy - v2
Date: Sun, 24 May 2009 18:50:18 +0300
Message-Id: <1243180230-2480-34-git-send-email-avi@redhat.com>
In-Reply-To: <1243180230-2480-1-git-send-email-avi@redhat.com>
References: <1243180230-2480-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Carsten Otte <cotte@de.ibm.com>

This patch makes sure we do unlink a vcpu's sie control block
from the system control area in kvm_arch_vcpu_destroy. This
prevents illegal accesses to the sie control block from other
virtual cpus after free.

Reported-by: Mijo Safradin <mijo@linux.vnet.ibm.com>
Signed-off-by: Carsten Otte <cotte@de.ibm.com>
Signed-off-by: Christian Ehrhardt <ehrhardt@de.ibm.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/s390/kvm/kvm-s390.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 36c654d..628494a 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -196,6 +196,10 @@ out_nokvm:
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
 	VCPU_EVENT(vcpu, 3, "%s", "free cpu");
+	if (vcpu->kvm->arch.sca->cpu[vcpu->vcpu_id].sda ==
+		(__u64) vcpu->arch.sie_block)
+		vcpu->kvm->arch.sca->cpu[vcpu->vcpu_id].sda = 0;
+	smp_mb();
 	free_page((unsigned long)(vcpu->arch.sie_block));
 	kvm_vcpu_uninit(vcpu);
 	kfree(vcpu);
@@ -310,8 +314,10 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
 
 	vcpu->arch.sie_block->icpua = id;
 	BUG_ON(!kvm->arch.sca);
-	BUG_ON(kvm->arch.sca->cpu[id].sda);
-	kvm->arch.sca->cpu[id].sda = (__u64) vcpu->arch.sie_block;
+	if (!kvm->arch.sca->cpu[id].sda)
+		kvm->arch.sca->cpu[id].sda = (__u64) vcpu->arch.sie_block;
+	else
+		BUG_ON(!kvm->vcpus[id]); /* vcpu does already exist */
 	vcpu->arch.sie_block->scaoh = (__u32)(((__u64)kvm->arch.sca) >> 32);
 	vcpu->arch.sie_block->scaol = (__u32)(__u64)kvm->arch.sca;
 
-- 
1.6.0.6

