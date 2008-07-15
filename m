Return-Path: <linux-kernel-owner+w=401wt.eu-S1761054AbYGOMQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761054AbYGOMQS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 08:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757217AbYGOMMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 08:12:50 -0400
Received: from il.qumranet.com ([212.179.150.194]:30360 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755979AbYGOMMm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 08:12:42 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 10/19] KVM: mmu_shrink: kvm_mmu_zap_page requires slots_lock to be held
Date: Tue, 15 Jul 2008 15:12:29 +0300
Message-Id: <1216123958-10717-11-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6.1
In-Reply-To: <1216123958-10717-1-git-send-email-avi@qumranet.com>
References: <1216123958-10717-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

kvm_mmu_zap_page() needs slots lock held (rmap_remove->gfn_to_memslot,
for example).

Since kvm_lock spinlock is held in mmu_shrink(), do a non-blocking
down_read_trylock().

Untested.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/mmu.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 1fd8e3b..ff7cf63 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1987,6 +1987,8 @@ static int mmu_shrink(int nr_to_scan, gfp_t gfp_mask)
 	list_for_each_entry(kvm, &vm_list, vm_list) {
 		int npages;
 
+		if (!down_read_trylock(&kvm->slots_lock))
+			continue;
 		spin_lock(&kvm->mmu_lock);
 		npages = kvm->arch.n_alloc_mmu_pages -
 			 kvm->arch.n_free_mmu_pages;
@@ -1999,6 +2001,7 @@ static int mmu_shrink(int nr_to_scan, gfp_t gfp_mask)
 		nr_to_scan--;
 
 		spin_unlock(&kvm->mmu_lock);
+		up_read(&kvm->slots_lock);
 	}
 	if (kvm_freed)
 		list_move_tail(&kvm_freed->vm_list, &vm_list);
-- 
1.5.6.1

