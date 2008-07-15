Return-Path: <linux-kernel-owner+w=401wt.eu-S1760729AbYGOMOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760729AbYGOMOy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 08:14:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756848AbYGOMMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 08:12:48 -0400
Received: from il.qumranet.com ([212.179.150.194]:30355 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755841AbYGOMMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 08:12:41 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
       Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 06/19] KVM: s390: Set guest storage limit and offset to sane values
Date: Tue, 15 Jul 2008 15:12:25 +0300
Message-Id: <1216123958-10717-7-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6.1
In-Reply-To: <1216123958-10717-1-git-send-email-avi@qumranet.com>
References: <1216123958-10717-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Borntraeger <borntraeger@de.ibm.com>

Some machines do not accept 16EB as guest storage limit. Lets change the
default for the guest storage limit to a sane value. We also should set
the guest_origin to what userspace thinks it is. This allows guests
starting at an address != 0.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Carsten Otte <cotte@de.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/s390/kvm/kvm-s390.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index b802ce6..cdab57c 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -247,11 +247,16 @@ static void kvm_s390_vcpu_initial_reset(struct kvm_vcpu *vcpu)
 	vcpu->arch.sie_block->gbea = 1;
 }
 
+/* The current code can have up to 256 pages for virtio */
+#define VIRTIODESCSPACE (256ul * 4096ul)
+
 int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu)
 {
 	atomic_set(&vcpu->arch.sie_block->cpuflags, CPUSTAT_ZARCH);
-	vcpu->arch.sie_block->gmslm = 0xffffffffffUL;
-	vcpu->arch.sie_block->gmsor = 0x000000000000;
+	vcpu->arch.sie_block->gmslm = vcpu->kvm->arch.guest_memsize +
+				      vcpu->kvm->arch.guest_origin +
+				      VIRTIODESCSPACE - 1ul;
+	vcpu->arch.sie_block->gmsor = vcpu->kvm->arch.guest_origin;
 	vcpu->arch.sie_block->ecb   = 2;
 	vcpu->arch.sie_block->eca   = 0xC1002001U;
 	setup_timer(&vcpu->arch.ckc_timer, kvm_s390_idle_wakeup,
-- 
1.5.6.1

