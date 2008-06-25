Return-Path: <linux-kernel-owner+w=401wt.eu-S1760255AbYFYEqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760255AbYFYEqw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 00:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755328AbYFYEhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 00:37:45 -0400
Received: from 9.sub-70-198-159.myvzw.com ([70.198.159.9]:37481 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755568AbYFYEh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 00:37:27 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 06 of 36] x86_64: use p??_populate() to attach pages to
	pagetable
X-Mercurial-Node: 2545dccb2180bd76b1af2241aefb3e305234455d
Message-Id: <2545dccb2180bd76b1af.1214367542@localhost>
In-Reply-To: <patchbomb.1214367536@localhost>
Date: Wed, 25 Jun 2008 00:19:02 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the _populate() functions to attach new pages to a pagetable, to
make sure the right paravirt_ops calls get called.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/mm/init_64.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -167,7 +167,7 @@
 	pud = pud_offset(pgd, vaddr);
 	if (pud_none(*pud)) {
 		pmd = (pmd_t *) spp_getpage();
-		set_pud(pud, __pud(__pa(pmd) | _KERNPG_TABLE | _PAGE_USER));
+		pud_populate(&init_mm, pud, pmd);
 		if (pmd != pmd_offset(pud, 0)) {
 			printk(KERN_ERR "PAGETABLE BUG #01! %p <-> %p\n",
 				pmd, pmd_offset(pud, 0));
@@ -177,7 +177,7 @@
 	pmd = pmd_offset(pud, vaddr);
 	if (pmd_none(*pmd)) {
 		pte = (pte_t *) spp_getpage();
-		set_pmd(pmd, __pmd(__pa(pte) | _KERNPG_TABLE | _PAGE_USER));
+		pmd_populate_kernel(&init_mm, pmd, pte);
 		if (pte != pte_offset_kernel(pmd, 0)) {
 			printk(KERN_ERR "PAGETABLE BUG #02!\n");
 			return;
@@ -389,7 +389,7 @@
 		pmd = alloc_low_page(&pmd_phys);
 
 		spin_lock(&init_mm.page_table_lock);
-		set_pud(pud, __pud(pmd_phys | _KERNPG_TABLE));
+		pud_populate(&init_mm, pud, __va(pmd_phys));
 		last_map_addr = phys_pmd_init(pmd, addr, end);
 		spin_unlock(&init_mm.page_table_lock);
 
@@ -591,7 +591,8 @@
 			next = end;
 		last_map_addr = phys_pud_init(pud, __pa(start), __pa(next));
 		if (!after_bootmem)
-			set_pgd(pgd_offset_k(start), mk_kernel_pgd(pud_phys));
+			pgd_populate(&init_mm, pgd_offset_k(start),
+				     __va(pud_phys));
 		unmap_low_page(pud);
 	}
 


