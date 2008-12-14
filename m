Return-Path: <linux-kernel-owner+w=401wt.eu-S1755145AbYLNIKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145AbYLNIKA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 03:10:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754304AbYLNIHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 03:07:25 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59918 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752886AbYLNIHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 03:07:15 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
       Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 04/36] KVM: s390: Fix memory leak of vcpu->run
Date: Sun, 14 Dec 2008 10:06:37 +0200
Message-Id: <1229242029-13410-5-git-send-email-avi@redhat.com>
In-Reply-To: <1229242029-13410-1-git-send-email-avi@redhat.com>
References: <1229242029-13410-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Borntraeger <borntraeger@de.ibm.com>

The s390 backend of kvm never calls kvm_vcpu_uninit. This causes
a memory leak of vcpu->run pages.
Lets call kvm_vcpu_uninit in kvm_arch_vcpu_destroy to free
the vcpu->run.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Acked-by: Carsten Otte <cotte@de.ibm.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/s390/kvm/kvm-s390.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 3db9e5d..76f05dd 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -198,6 +198,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
 	VCPU_EVENT(vcpu, 3, "%s", "free cpu");
 	free_page((unsigned long)(vcpu->arch.sie_block));
+	kvm_vcpu_uninit(vcpu);
 	kfree(vcpu);
 }
 
@@ -230,8 +231,7 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 
 void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu)
 {
-	/* kvm common code refers to this, but does'nt call it */
-	BUG();
+	/* Nothing todo */
 }
 
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
-- 
1.6.0.3

