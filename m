Return-Path: <linux-kernel-owner+w=401wt.eu-S1757474AbYLIUd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474AbYLIUd1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 15:33:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755423AbYLIUYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 15:24:06 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34891 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754925AbYLIUXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 15:23:13 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 44/44] KVM: MMU: optimize set_spte for page sync
Date: Tue,  9 Dec 2008 22:22:59 +0200
Message-Id: <1228854179-23002-45-git-send-email-avi@redhat.com>
In-Reply-To: <1228854179-23002-1-git-send-email-avi@redhat.com>
References: <1228854179-23002-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

The write protect verification in set_spte is unnecessary for page sync.

Its guaranteed that, if the unsync spte was writable, the target page
does not have a write protected shadow (if it had, the spte would have
been write protected under mmu_lock by rmap_write_protect before).

Same reasoning applies to mark_page_dirty: the gfn has been marked as
dirty via the pagefault path.

The cost of hash table and memslot lookups are quite significant if the
workload is pagetable write intensive resulting in increased mmu_lock
contention.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/mmu.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index fa3486d..dd20b19 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1593,6 +1593,15 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *shadow_pte,
 
 		spte |= PT_WRITABLE_MASK;
 
+		/*
+		 * Optimization: for pte sync, if spte was writable the hash
+		 * lookup is unnecessary (and expensive). Write protection
+		 * is responsibility of mmu_get_page / kvm_sync_page.
+		 * Same reasoning can be applied to dirty page accounting.
+		 */
+		if (!can_unsync && is_writeble_pte(*shadow_pte))
+			goto set_pte;
+
 		if (mmu_need_write_protect(vcpu, gfn, can_unsync)) {
 			pgprintk("%s: found shadow page for %lx, marking ro\n",
 				 __func__, gfn);
-- 
1.6.0.3

