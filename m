Return-Path: <linux-kernel-owner+w=401wt.eu-S1754051AbYFRLkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051AbYFRLkR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 07:40:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753058AbYFRLkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 07:40:05 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:26364 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997AbYFRLkE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 07:40:04 -0400
Message-Id: <48591049.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Wed, 18 Jun 2008 12:40:25 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] i386: fix vmalloc_sync_all() for Xen
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the fourth PDPT entry cannot be shared under Xen,
vmalloc_sync_all() must iterate over pmd-s rather than pgd-s here.
Luckily, the code isn't used for native PAE (SHARED_KERNEL_PMD is 1)
and the change is benign to non-PAE.

Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/mm/fault.c |   29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

--- linux-2.6.26-rc6/arch/x86/mm/fault.c	2008-06-18 09:56:16.000000000 +0200
+++ 2.6.26-rc6-i386-xen-vmalloc_sync_all/arch/x86/mm/fault.c	2008-06-06 08:51:52.000000000 +0200
@@ -921,32 +921,43 @@ void vmalloc_sync_all(void)
 	 * start are only improving performance (without affecting correctness
 	 * if undone).
 	 */
-	static DECLARE_BITMAP(insync, PTRS_PER_PGD);
+#define sync_index(a) ((a) >> PMD_SHIFT)
+	static DECLARE_BITMAP(insync, PTRS_PER_PGD*PTRS_PER_PMD);
 	static unsigned long start = TASK_SIZE;
 	unsigned long address;
 
 	if (SHARED_KERNEL_PMD)
 		return;
 
-	BUILD_BUG_ON(TASK_SIZE & ~PGDIR_MASK);
-	for (address = start; address >= TASK_SIZE; address += PGDIR_SIZE) {
-		if (!test_bit(pgd_index(address), insync)) {
+	BUILD_BUG_ON(TASK_SIZE & ~PMD_MASK);
+	for (address = start; address >= TASK_SIZE; address += PMD_SIZE) {
+		if (!test_bit(sync_index(address), insync)) {
 			unsigned long flags;
 			struct page *page;
 
 			spin_lock_irqsave(&pgd_lock, flags);
+			if (unlikely(list_empty(&pgd_list))) {
+				spin_unlock_irqrestore(&pgd_lock, flags);
+				return;
+			}
 			list_for_each_entry(page, &pgd_list, lru) {
 				if (!vmalloc_sync_one(page_address(page),
-						      address))
+						      address)) {
+					BUG_ON(list_first_entry(&pgd_list,
+								struct page,
+								lru) != page);
+					page = NULL;
 					break;
+				}
 			}
 			spin_unlock_irqrestore(&pgd_lock, flags);
-			if (!page)
-				set_bit(pgd_index(address), insync);
+			if (page)
+				set_bit(sync_index(address), insync);
 		}
-		if (address == start && test_bit(pgd_index(address), insync))
-			start = address + PGDIR_SIZE;
+		if (address == start && test_bit(sync_index(address), insync))
+			start = address + PMD_SIZE;
 	}
+#undef sync_index
 #else /* CONFIG_X86_64 */
 	/*
 	 * Note that races in the updates of insync and start aren't



