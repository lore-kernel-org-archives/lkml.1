Return-Path: <linux-kernel-owner+w=401wt.eu-S1752781AbYKMMgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781AbYKMMgr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 07:36:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754169AbYKMMge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 07:36:34 -0500
Received: from mx2.redhat.com ([66.187.237.31]:33397 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754168AbYKMMgd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 07:36:33 -0500
From: Glauber Costa <glommer@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, avi@redhat.com
Subject: [PATCH] Check for ambiguities in create alias ioctl.
Date: Thu, 13 Nov 2008 12:32:56 -0200
Message-Id: <1226586776-18999-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current alias ioctl allows for the creation of
an alias covering a gpa that already exists. It is invalid,
because the gpa space needs to be uniquely mapped. So, if
there's a memory slot covering gpa range 0x123000 to 0x124000,
and we create an alias from any gpa within that range to a different
target, we create an essential ambiguity that brings no value at
the cost of a lot of confusion. Right now this confusion
manifests itself as a BUG() triggered in the rmaps code path.

Signed-off-by: Glauber Costa <glommer@redhat.com>
---
 arch/x86/kvm/x86.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7a2aeba..c3b5770 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1591,6 +1591,8 @@ static int kvm_vm_ioctl_set_memory_alias(struct kvm *kvm,
 {
 	int r, n;
 	struct kvm_mem_alias *p;
+	gfn_t base_gfn;
+	unsigned long npages;
 
 	r = -EINVAL;
 	/* General sanity checks */
@@ -1607,12 +1609,18 @@ static int kvm_vm_ioctl_set_memory_alias(struct kvm *kvm,
 	    < alias->target_phys_addr)
 		goto out;
 
+	base_gfn = alias->guest_phys_addr >> PAGE_SHIFT;
+	npages = alias->memory_size >> PAGE_SHIFT;
+
+	if (gfn_to_memslot(kvm, base_gfn) || gfn_to_memslot(kvm, base_gfn + npages))
+		goto out;
+
 	down_write(&kvm->slots_lock);
 	spin_lock(&kvm->mmu_lock);
 
 	p = &kvm->arch.aliases[alias->slot];
-	p->base_gfn = alias->guest_phys_addr >> PAGE_SHIFT;
-	p->npages = alias->memory_size >> PAGE_SHIFT;
+	p->base_gfn = base_gfn;
+	p->npages = npages;
 	p->target_gfn = alias->target_phys_addr >> PAGE_SHIFT;
 
 	for (n = KVM_ALIAS_SLOTS; n > 0; --n)
-- 
1.5.6.5

