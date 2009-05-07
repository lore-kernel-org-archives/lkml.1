Return-Path: <linux-kernel-owner+w=401wt.eu-S1758770AbZEHAKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758770AbZEHAKk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 20:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753997AbZEHAJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 20:09:54 -0400
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:52689
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753391AbZEHAJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 20:09:53 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Ian Campbell <ian.campbell@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 10/16] xen: clear reserved bits in l3 entries given in the initial pagetables
Date: Thu,  7 May 2009 14:10:47 -0700
Message-Id: <1241730653-4688-11-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1241730653-4688-1-git-send-email-jeremy@goop.org>
References: <1241730653-4688-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <ian.campbell@citrix.com>

Impact: workaround Xen bug in 32-on-64 dom0

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
index b35571f..55da7f9 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1835,6 +1835,7 @@ __init pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd,
 					 unsigned long max_pfn)
 {
 	pmd_t *kernel_pmd;
+	int i;
 
 	max_pfn_mapped = PFN_DOWN(__pa(xen_start_info->pt_base) +
 				  xen_start_info->nr_pt_frames * PAGE_SIZE +
@@ -1846,6 +1847,20 @@ __init pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd,
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

