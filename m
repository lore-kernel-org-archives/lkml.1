Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932857Ab0BPKfz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 05:35:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35308 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932833Ab0BPKfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 05:35:41 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 37/38] KVM: VMX: emulate accessed bit for EPT
Date: Tue, 16 Feb 2010 12:35:35 +0200
Message-Id: <1266316536-28936-38-git-send-email-avi@redhat.com>
In-Reply-To: <1266316536-28936-1-git-send-email-avi@redhat.com>
References: <1266316536-28936-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

Currently KVM pretends that pages with EPT mappings never got
accessed.  This has some side effects in the VM, like swapping
out actively used guest pages and needlessly breaking up actively
used hugepages.

We can avoid those very costly side effects by emulating the
accessed bit for EPT PTEs, which should only be slightly costly
because pages pass through page_referenced infrequently.

TLB flushing is taken care of by kvm_mmu_notifier_clear_flush_young().

This seems to help prevent KVM guests from being swapped out when
they should not on my system.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/mmu.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 913ef4b..b8da671 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -838,9 +838,15 @@ static int kvm_age_rmapp(struct kvm *kvm, unsigned long *rmapp,
 	u64 *spte;
 	int young = 0;
 
-	/* always return old for EPT */
+	/*
+	 * Emulate the accessed bit for EPT, by checking if this page has
+	 * an EPT mapping, and clearing it if it does. On the next access,
+	 * a new EPT mapping will be established.
+	 * This has some overhead, but not as much as the cost of swapping
+	 * out actively used pages or breaking up actively used hugepages.
+	 */
 	if (!shadow_accessed_mask)
-		return 0;
+		return kvm_unmap_rmapp(kvm, rmapp, data);
 
 	spte = rmap_next(kvm, rmapp, NULL);
 	while (spte) {
-- 
1.6.5.3

