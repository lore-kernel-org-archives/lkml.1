Return-Path: <linux-kernel-owner+w=401wt.eu-S933109AbYDQJV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933109AbYDQJV0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760384AbYDQJLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:11:25 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:59088
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762875AbYDQJLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:11:05 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 24/45] KVM: MMU: prepopulate guest pages after write-protecting
Date: Thu, 17 Apr 2008 12:10:29 +0300
Message-Id: <1208423450-29415-25-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208423450-29415-1-git-send-email-avi@qumranet.com>
References: <1208423450-29415-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

Zdenek reported a bug where a looping "dmsetup status" eventually hangs
on SMP guests.

The problem is that kvm_mmu_get_page() prepopulates the shadow MMU
before write protecting the guest page tables. By doing so, it leaves a
window open where the guest can mark a pte as present while the host has
shadow cached such pte as "notrap". Accesses to such address will fault
in the guest without the host having a chance to fix the situation.

Fix by moving the write protection before the pte prefetch.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/mmu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 5c4c166..c89bf23 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -852,9 +852,9 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	sp->gfn = gfn;
 	sp->role = role;
 	hlist_add_head(&sp->hash_link, bucket);
-	vcpu->arch.mmu.prefetch_page(vcpu, sp);
 	if (!metaphysical)
 		rmap_write_protect(vcpu->kvm, gfn);
+	vcpu->arch.mmu.prefetch_page(vcpu, sp);
 	return sp;
 }
 
-- 
1.5.5

