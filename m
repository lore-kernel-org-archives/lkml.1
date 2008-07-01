Return-Path: <linux-kernel-owner+w=401wt.eu-S1761087AbYGBBCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761087AbYGBBCs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 21:02:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758069AbYGBBBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 21:01:51 -0400
Received: from gw.goop.org ([64.81.55.164]:58678 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757566AbYGBBBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 21:01:49 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 2 of 8] x86_64: unmap iomapping before populating
X-Mercurial-Node: ef1ab80b56717ed0561b9948a681bab7f9adfd9a
Message-Id: <ef1ab80b56717ed0561b.1214955991@localhost>
In-Reply-To: <patchbomb.1214955989@localhost>
Date: Tue, 01 Jul 2008 16:46:31 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xen doesn't like stray writable mappings of pagetable pages, so make
sure the ioremap mapping is removed before attaching the new page to
the pagetable.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/mm/init_64.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -333,11 +333,11 @@
 		pmd = alloc_low_page(&pmd_phys);
 
 		spin_lock(&init_mm.page_table_lock);
+		last_map_addr = phys_pmd_init(pmd, addr, end);
+		unmap_low_page(pmd);
 		pud_populate(&init_mm, pud, __va(pmd_phys));
-		last_map_addr = phys_pmd_init(pmd, addr, end);
 		spin_unlock(&init_mm.page_table_lock);
 
-		unmap_low_page(pmd);
 	}
 	__flush_tlb_all();
 	update_page_count(PG_LEVEL_1G, pages);
@@ -534,10 +534,10 @@
 		if (next > end)
 			next = end;
 		last_map_addr = phys_pud_init(pud, __pa(start), __pa(next));
+		unmap_low_page(pud);
 		if (!after_bootmem)
 			pgd_populate(&init_mm, pgd_offset_k(start),
 				     __va(pud_phys));
-		unmap_low_page(pud);
 	}
 
 	if (!after_bootmem)


