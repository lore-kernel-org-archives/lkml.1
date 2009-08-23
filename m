Return-Path: <linux-kernel-owner+w=401wt.eu-S933838AbZHWMGE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933838AbZHWMGE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 08:06:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933723AbZHWMF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 08:05:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41868 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933527AbZHWL4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 07:56:48 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 10/46] Revert "KVM: x86: check for cr3 validity in ioctl_set_sregs"
Date: Sun, 23 Aug 2009 14:56:09 +0300
Message-Id: <1251028605-31977-11-git-send-email-avi@redhat.com>
In-Reply-To: <1251028605-31977-1-git-send-email-avi@redhat.com>
References: <1251028605-31977-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@web.de>

This reverts commit 6c20e1442bb1c62914bb85b7f4a38973d2a423ba.

To my understanding, it became obsolete with the advent of the more
robust check in mmu_alloc_roots (89da4ff17f). Moreover, it prevents
the conceptually safe pattern

 1. set sregs
 2. register mem-slots
 3. run vcpu

by setting a sticky triple fault during step 1.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6dde99c..0e74d98 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4326,13 +4326,7 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 
 	vcpu->arch.cr2 = sregs->cr2;
 	mmu_reset_needed |= vcpu->arch.cr3 != sregs->cr3;
-
-	down_read(&vcpu->kvm->slots_lock);
-	if (gfn_to_memslot(vcpu->kvm, sregs->cr3 >> PAGE_SHIFT))
-		vcpu->arch.cr3 = sregs->cr3;
-	else
-		set_bit(KVM_REQ_TRIPLE_FAULT, &vcpu->requests);
-	up_read(&vcpu->kvm->slots_lock);
+	vcpu->arch.cr3 = sregs->cr3;
 
 	kvm_set_cr8(vcpu, sregs->cr8);
 
-- 
1.6.4.1

