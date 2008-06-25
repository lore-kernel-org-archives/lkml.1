Return-Path: <linux-kernel-owner+w=401wt.eu-S1757783AbYFYEid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757783AbYFYEid (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 00:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752989AbYFYEhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 00:37:09 -0400
Received: from 9.sub-70-198-159.myvzw.com ([70.198.159.9]:37425 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752485AbYFYEhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 00:37:06 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 15 of 36] x86: simplify vmalloc_sync_all
X-Mercurial-Node: 89fbec3fceddfb6c2190f4a288fde7b7086bfbcf
Message-Id: <89fbec3fceddfb6c2190.1214367551@localhost>
In-Reply-To: <patchbomb.1214367536@localhost>
Date: Wed, 25 Jun 2008 00:19:11 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vmalloc_sync_all() is only called from register_die_notifier and
alloc_vm_area.  Neither is on any performance-critical paths, so
vmalloc_sync_all() itself is not on any hot paths.

Given that the optimisations in vmalloc_sync_all add a fair amount of
code and complexity, and are fairly hard to evaluate for correctness,
it's better to just remove them to simplify the code rather than worry
about its absolute performance.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/mm/fault.c |   73 ++++++++++++++++-----------------------------------
 1 file changed, 24 insertions(+), 49 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -949,14 +949,7 @@
 void vmalloc_sync_all(void)
 {
 #ifdef CONFIG_X86_32
-	/*
-	 * Note that races in the updates of insync and start aren't
-	 * problematic: insync can only get set bits added, and updates to
-	 * start are only improving performance (without affecting correctness
-	 * if undone).
-	 */
-	static DECLARE_BITMAP(insync, PTRS_PER_PGD);
-	static unsigned long start = TASK_SIZE;
+	unsigned long start = VMALLOC_START & PGDIR_MASK;
 	unsigned long address;
 
 	if (SHARED_KERNEL_PMD)
@@ -964,56 +957,38 @@
 
 	BUILD_BUG_ON(TASK_SIZE & ~PGDIR_MASK);
 	for (address = start; address >= TASK_SIZE; address += PGDIR_SIZE) {
-		if (!test_bit(pgd_index(address), insync)) {
-			unsigned long flags;
-			struct page *page;
+		unsigned long flags;
+		struct page *page;
 
-			spin_lock_irqsave(&pgd_lock, flags);
-			list_for_each_entry(page, &pgd_list, lru) {
-				if (!vmalloc_sync_one(page_address(page),
-						      address))
-					break;
-			}
-			spin_unlock_irqrestore(&pgd_lock, flags);
-			if (!page)
-				set_bit(pgd_index(address), insync);
+		spin_lock_irqsave(&pgd_lock, flags);
+		list_for_each_entry(page, &pgd_list, lru) {
+			if (!vmalloc_sync_one(page_address(page),
+					      address))
+				break;
 		}
-		if (address == start && test_bit(pgd_index(address), insync))
-			start = address + PGDIR_SIZE;
+		spin_unlock_irqrestore(&pgd_lock, flags);
 	}
 #else /* CONFIG_X86_64 */
-	/*
-	 * Note that races in the updates of insync and start aren't
-	 * problematic: insync can only get set bits added, and updates to
-	 * start are only improving performance (without affecting correctness
-	 * if undone).
-	 */
-	static DECLARE_BITMAP(insync, PTRS_PER_PGD);
-	static unsigned long start = VMALLOC_START & PGDIR_MASK;
+	unsigned long start = VMALLOC_START & PGDIR_MASK;
 	unsigned long address;
 
 	for (address = start; address <= VMALLOC_END; address += PGDIR_SIZE) {
-		if (!test_bit(pgd_index(address), insync)) {
-			const pgd_t *pgd_ref = pgd_offset_k(address);
-			unsigned long flags;
-			struct page *page;
+		const pgd_t *pgd_ref = pgd_offset_k(address);
+		unsigned long flags;
+		struct page *page;
 
-			if (pgd_none(*pgd_ref))
-				continue;
-			spin_lock_irqsave(&pgd_lock, flags);
-			list_for_each_entry(page, &pgd_list, lru) {
-				pgd_t *pgd;
-				pgd = (pgd_t *)page_address(page) + pgd_index(address);
-				if (pgd_none(*pgd))
-					set_pgd(pgd, *pgd_ref);
-				else
-					BUG_ON(pgd_page_vaddr(*pgd) != pgd_page_vaddr(*pgd_ref));
-			}
-			spin_unlock_irqrestore(&pgd_lock, flags);
-			set_bit(pgd_index(address), insync);
+		if (pgd_none(*pgd_ref))
+			continue;
+		spin_lock_irqsave(&pgd_lock, flags);
+		list_for_each_entry(page, &pgd_list, lru) {
+			pgd_t *pgd;
+			pgd = (pgd_t *)page_address(page) + pgd_index(address);
+			if (pgd_none(*pgd))
+				set_pgd(pgd, *pgd_ref);
+			else
+				BUG_ON(pgd_page_vaddr(*pgd) != pgd_page_vaddr(*pgd_ref));
 		}
-		if (address == start)
-			start = address + PGDIR_SIZE;
+		spin_unlock_irqrestore(&pgd_lock, flags);
 	}
 #endif
 }


