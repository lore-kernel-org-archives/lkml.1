Return-Path: <linux-kernel-owner+w=401wt.eu-S1757340AbYH2Lwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340AbYH2Lwk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 07:52:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754787AbYH2Lwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 07:52:31 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:13961 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756216AbYH2Lwa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 07:52:30 -0400
Message-Id: <48B7FF69.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 Beta 
Date: Fri, 29 Aug 2008 12:53:45 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: adjust vmalloc_sync_all() for Xen (2nd try)
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

Also do a little more cleanup in that function.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>

---
 arch/x86/mm/fault.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- linux-2.6.27-rc5/arch/x86/mm/fault.c	2008-08-21 14:37:29.000000000 +0200
+++ 2.6.27-rc5-x86-vmalloc-sync-all/arch/x86/mm/fault.c	2008-08-22 15:24:33.000000000 +0200
@@ -915,15 +915,15 @@ LIST_HEAD(pgd_list);
 
 void vmalloc_sync_all(void)
 {
-#ifdef CONFIG_X86_32
-	unsigned long start = VMALLOC_START & PGDIR_MASK;
 	unsigned long address;
 
+#ifdef CONFIG_X86_32
 	if (SHARED_KERNEL_PMD)
 		return;
 
-	BUILD_BUG_ON(TASK_SIZE & ~PGDIR_MASK);
-	for (address = start; address >= TASK_SIZE; address += PGDIR_SIZE) {
+	for (address = VMALLOC_START & PMD_MASK;
+	     address >= TASK_SIZE && address < FIXADDR_TOP;
+	     address += PMD_SIZE) {
 		unsigned long flags;
 		struct page *page;
 
@@ -936,10 +936,8 @@ void vmalloc_sync_all(void)
 		spin_unlock_irqrestore(&pgd_lock, flags);
 	}
 #else /* CONFIG_X86_64 */
-	unsigned long start = VMALLOC_START & PGDIR_MASK;
-	unsigned long address;
-
-	for (address = start; address <= VMALLOC_END; address += PGDIR_SIZE) {
+	for (address = VMALLOC_START & PGDIR_MASK; address <= VMALLOC_END;
+	     address += PGDIR_SIZE) {
 		const pgd_t *pgd_ref = pgd_offset_k(address);
 		unsigned long flags;
 		struct page *page;



