Return-Path: <linux-kernel-owner+w=401wt.eu-S932271AbZB1CEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932271AbZB1CEi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 21:04:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758739AbZB1B7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 20:59:39 -0500
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:59187
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757210AbZB1B7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 20:59:32 -0500
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Ian Campbell <ian.campbell@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH] xen: clear reserved bits in l3 entries given in the initial pagetables
Date: Fri, 27 Feb 2009 17:59:18 -0800
Message-Id: <1235786365-17744-13-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1235786365-17744-1-git-send-email-jeremy@goop.org>
References: <1235786365-17744-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <ian.campbell@citrix.com>

In native PAE, the only flag that may be legitimately set in an L3
entry is Present.  When Xen grafts the top-level PAE L3 pagetable
entries into the L4 pagetable, it must also set the other permissions
flags so that the mapped pages are actually accessible.

However, due to a bug in the hypervisor, it validates update to the L3
entries as formal PAE entries, so it will refuse to validate these
entries with the extra bits requires for 4-level pagetables.

This patch simply masks the entries back to the bare PAE level,
leaving Xen to add whatever bits it feels are necessary.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/mmu.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 367a7d2..5f034a1 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1778,6 +1778,7 @@ __init pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd,
 					 unsigned long max_pfn)
 {
 	pmd_t *kernel_pmd;
+	int i;
 
 	init_pg_tables_start = __pa(pgd);
 	init_pg_tables_end = __pa(pgd) + xen_start_info->nr_pt_frames*PAGE_SIZE;
@@ -1789,6 +1790,20 @@ __init pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd,
 	xen_map_identity_early(level2_kernel_pgt, max_pfn);
 
 	memcpy(swapper_pg_dir, pgd, sizeof(pgd_t) * PTRS_PER_PGD);
+
+	/*
+	 * When running a 32 bit domain 0 on a 64 bit hypervisor a
+	 * pinned L3 (such as the initial pgd here) contains bits
+	 * which are reserved in the PAE layout but not in the 64 bit
+	 * layout. Unfortunately some versions of the hypervisor
+	 * (incorrectly) validate compat mode guests against the PAE
+	 * layout and hence will not allow such a pagetable to be
+	 * pinned by the guest. Therefore we mask off only the PFN and
+	 * Present bits of the supplied L3.
+	 */
+	for (i = 0; i < PTRS_PER_PGD; i++)
+		swapper_pg_dir[i].pgd &= (PTE_PFN_MASK | _PAGE_PRESENT);
+
 	set_pgd(&swapper_pg_dir[KERNEL_PGD_BOUNDARY],
 			__pgd(__pa(level2_kernel_pgt) | _PAGE_PRESENT));
 
-- 
1.6.0.6

