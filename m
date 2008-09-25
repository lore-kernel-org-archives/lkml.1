Return-Path: <linux-kernel-owner+w=401wt.eu-S1757097AbYIYMFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757097AbYIYMFq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 08:05:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755037AbYIYL4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 07:56:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48610 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754857AbYIYL4S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 07:56:18 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 33/39] KVM: MMU: Add locking around kvm_mmu_slot_remove_write_access()
Date: Thu, 25 Sep 2008 14:55:05 +0300
Message-Id: <1222343711-12508-34-git-send-email-avi@redhat.com>
In-Reply-To: <1222343711-12508-1-git-send-email-avi@redhat.com>
References: <1222343711-12508-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Avi Kivity <avi@qumranet.com>

It was generally safe due to slots_lock being held for write, but it wasn't
very nice.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/mmu.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index a24da8f..5052acd 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2097,6 +2097,7 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot)
 {
 	struct kvm_mmu_page *sp;
 
+	spin_lock(&kvm->mmu_lock);
 	list_for_each_entry(sp, &kvm->arch.active_mmu_pages, link) {
 		int i;
 		u64 *pt;
@@ -2110,6 +2111,7 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot)
 			if (pt[i] & PT_WRITABLE_MASK)
 				pt[i] &= ~PT_WRITABLE_MASK;
 	}
+	spin_unlock(&kvm->mmu_lock);
 }
 
 void kvm_mmu_zap_all(struct kvm *kvm)
-- 
1.6.0.1

