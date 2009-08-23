Return-Path: <linux-kernel-owner+w=401wt.eu-S933722AbZHWMBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933722AbZHWMBw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 08:01:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933651AbZHWMAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 08:00:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933554AbZHWL4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 07:56:50 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 29/46] KVM: MMU: fix missing locking in alloc_mmu_pages
Date: Sun, 23 Aug 2009 14:56:28 +0300
Message-Id: <1251028605-31977-30-git-send-email-avi@redhat.com>
In-Reply-To: <1251028605-31977-1-git-send-email-avi@redhat.com>
References: <1251028605-31977-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

n_requested_mmu_pages/n_free_mmu_pages are used by
kvm_mmu_change_mmu_pages to calculate the number of pages to zap.

alloc_mmu_pages, called from the vcpu initialization path, modifies this
variables without proper locking, which can result in a negative value
in kvm_mmu_change_mmu_pages (say, with cpu hotplug).

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/kvm/mmu.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 87c67f4..86c2551 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2728,12 +2728,14 @@ static int alloc_mmu_pages(struct kvm_vcpu *vcpu)
 
 	ASSERT(vcpu);
 
+	spin_lock(&vcpu->kvm->mmu_lock);
 	if (vcpu->kvm->arch.n_requested_mmu_pages)
 		vcpu->kvm->arch.n_free_mmu_pages =
 					vcpu->kvm->arch.n_requested_mmu_pages;
 	else
 		vcpu->kvm->arch.n_free_mmu_pages =
 					vcpu->kvm->arch.n_alloc_mmu_pages;
+	spin_unlock(&vcpu->kvm->mmu_lock);
 	/*
 	 * When emulating 32-bit mode, cr3 is only 32 bits even on x86_64.
 	 * Therefore we need to allocate shadow page tables in the first
-- 
1.6.4.1

