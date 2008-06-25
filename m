Return-Path: <linux-kernel-owner+w=401wt.eu-S1759211AbYFYEo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759211AbYFYEo2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 00:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756266AbYFYEhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 00:37:35 -0400
Received: from 9.sub-70-198-159.myvzw.com ([70.198.159.9]:37448 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755237AbYFYEhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 00:37:22 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 20 of 36] paravirt/x86_64: move __PAGE_OFFSET to leave a space
	for hypervisor
X-Mercurial-Node: 68c291617885d5f819eab00bff916559f9d9aceb
Message-Id: <68c291617885d5f819ea.1214367556@localhost>
In-Reply-To: <patchbomb.1214367536@localhost>
Date: Wed, 25 Jun 2008 00:19:16 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eduardo Habkost <ehabkost@redhat.com>
From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Set __PAGE_OFFSET to the most negative possible address +
16*PGDIR_SIZE.  The gap is to allow a space for a hypervisor to fit.
The gap is more or less arbitrary, but it's what Xen needs.

When booting native, kernel/head_64.S has a set of compile-time
generated pagetables used at boot time.  This patch removes their
absolutely hard-coded layout, and makes it parameterised on
__PAGE_OFFSET (and __START_KERNEL_map).

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/head_64.S |   19 +++++++++++++------
 include/asm-x86/page_64.h |    8 +++++++-
 2 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -31,6 +31,13 @@
  * because we need identity-mapped pages.
  *
  */
+
+#define pud_index(x)	(((x) >> PUD_SHIFT) & (PTRS_PER_PUD-1))
+
+L4_PAGE_OFFSET = pgd_index(__PAGE_OFFSET)
+L3_PAGE_OFFSET = pud_index(__PAGE_OFFSET)
+L4_START_KERNEL = pgd_index(__START_KERNEL_map)
+L3_START_KERNEL = pud_index(__START_KERNEL_map)
 
 	.text
 	.section .text.head
@@ -77,8 +84,8 @@
 	/* Fixup the physical addresses in the page table
 	 */
 	addq	%rbp, init_level4_pgt + 0(%rip)
-	addq	%rbp, init_level4_pgt + (258*8)(%rip)
-	addq	%rbp, init_level4_pgt + (511*8)(%rip)
+	addq	%rbp, init_level4_pgt + (L4_PAGE_OFFSET*8)(%rip)
+	addq	%rbp, init_level4_pgt + (L4_START_KERNEL*8)(%rip)
 
 	addq	%rbp, level3_ident_pgt + 0(%rip)
 
@@ -338,9 +345,9 @@
 	 */
 NEXT_PAGE(init_level4_pgt)
 	.quad	level3_ident_pgt - __START_KERNEL_map + _KERNPG_TABLE
-	.fill	257,8,0
+	.org	init_level4_pgt + L4_PAGE_OFFSET*8, 0
 	.quad	level3_ident_pgt - __START_KERNEL_map + _KERNPG_TABLE
-	.fill	252,8,0
+	.org	init_level4_pgt + L4_START_KERNEL*8, 0
 	/* (2^48-(2*1024*1024*1024))/(2^39) = 511 */
 	.quad	level3_kernel_pgt - __START_KERNEL_map + _PAGE_TABLE
 
@@ -349,7 +356,7 @@
 	.fill	511,8,0
 
 NEXT_PAGE(level3_kernel_pgt)
-	.fill	510,8,0
+	.fill	L3_START_KERNEL,8,0
 	/* (2^48-(2*1024*1024*1024)-((2^39)*511))/(2^30) = 510 */
 	.quad	level2_kernel_pgt - __START_KERNEL_map + _KERNPG_TABLE
 	.quad	level2_fixmap_pgt - __START_KERNEL_map + _PAGE_TABLE
diff --git a/include/asm-x86/page_64.h b/include/asm-x86/page_64.h
--- a/include/asm-x86/page_64.h
+++ b/include/asm-x86/page_64.h
@@ -26,7 +26,13 @@
 #define PUD_PAGE_SIZE		(_AC(1, UL) << PUD_SHIFT)
 #define PUD_PAGE_MASK		(~(PUD_PAGE_SIZE-1))
 
-#define __PAGE_OFFSET           _AC(0xffff810000000000, UL)
+/*
+ * Set __PAGE_OFFSET to the most negative possible address +
+ * PGDIR_SIZE*16 (pgd slot 272).  The gap is to allow a space for a
+ * hypervisor to fit.  Choosing 16 slots here is arbitrary, but it's
+ * what Xen requires.
+ */
+#define __PAGE_OFFSET           _AC(0xffff880000000000, UL)
 
 #define __PHYSICAL_START	CONFIG_PHYSICAL_START
 #define __KERNEL_ALIGN		0x200000


