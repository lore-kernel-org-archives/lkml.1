Return-Path: <linux-kernel-owner+w=401wt.eu-S1757939AbZBPXuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757939AbZBPXuz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 18:50:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755955AbZBPXq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 18:46:27 -0500
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:50815
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751992AbZBPXqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 18:46:19 -0500
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yinghai@kernel.org>, Ian Campbell <Ian.Campbell@citrix.com>,
       Ian Campbell <ian.campbell@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 12/19] xen: clear reserved bits in l3 entries given in the initial pagetables
Date: Mon, 16 Feb 2009 15:46:06 -0800
Message-Id: <0b79be113b42a033f3b3ca4d4f3ca4035c8a7bf5.1234826723.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <2fe9663efa1686898ebf9d28e911daac3185b6b7.1234826723.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <cover.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <cover.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <edde7fdd064390d321bdafcfb993b28b4d2588b1.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <9fbd402b72d6c494f453ff86e071ac1b2658ece9.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <f47f399029ba9035a14ae381b6ae504a5c5bd445.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <f1402ed2345e1d654faa823afefa53fc4745e368.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <f0d2b3f946de1b3398c278c7a33069f670b78268.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <83b1377d81029933b769798dbe1ca134f6d365ae.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <630b678d3259163fc237f673b6f2a4a5fa76ac25.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <8349825a016bec5b8712940ad6f8c3f18f8003fb.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <f156acbfffc23cccd71b71d36e6668c6c246f3b4.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <f156acbfffc23cccd71b71d36e6668c6c246f3b4.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <e59d440a548af3d4e4bb483c73e24614a5b3af63.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <2fe9663efa1686898ebf9d28e911daac3185b6b7.1234826723.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1234826723.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1234826723.git.jeremy.fitzhardinge@citrix.com>
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

