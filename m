Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932930Ab0BCVLS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 16:11:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932908Ab0BCVLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 16:11:17 -0500
Date: Wed, 3 Feb 2010 16:11:03 -0500
From: Rik van Riel <riel@redhat.com>
To: jdike@addtoit.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       aarcange@redhat.com, mtosatti@redhat.com
Subject: [PATCH] emulate accessed bit for EPT
Message-ID: <20100203161103.11e2b572@annuminas.surriel.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
Jeff, does this patch fix the issue you saw a few months ago, with
a 256MB KVM guest in a cgroup limited to 128GB memory?

 arch/x86/kvm/mmu.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 89a49fb..6101615 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -856,9 +856,15 @@ static int kvm_age_rmapp(struct kvm *kvm, unsigned long *rmapp,
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
