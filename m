Return-Path: <linux-kernel-owner+w=401wt.eu-S1760146AbYGBBCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760146AbYGBBCA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 21:02:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757590AbYGBBBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 21:01:49 -0400
Received: from gw.goop.org ([64.81.55.164]:58672 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756875AbYGBBBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 21:01:49 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 3 of 8] x86_64/setup: preserve existing PUD mappings
X-Mercurial-Node: 08fc44af0010d3592de6e323c7e74d70018538fc
Message-Id: <08fc44af0010d3592de6.1214955992@localhost>
In-Reply-To: <patchbomb.1214955989@localhost>
Date: Tue, 01 Jul 2008 16:46:32 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When constructing the physical mapping, reuse any existing PUD pages
rather than starting afresh.  This preserves any special mappings the
earlier boot code may have created.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/mm/init_64.c |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -493,6 +493,14 @@
 }
 #endif
 
+static unsigned long __meminit
+phys_pud_update(pgd_t *pgd, unsigned long addr, unsigned long end)
+{
+	pud_t *pud = (pud_t *)pgd_page_vaddr(*pgd);
+
+	return phys_pud_init(pud, addr, end);
+}
+
 /*
  * Setup the direct mapping of the physical memory at PAGE_OFFSET.
  * This runs before bootmem is initialized and gets pages directly from
@@ -525,14 +533,20 @@
 		unsigned long pud_phys;
 		pud_t *pud;
 
+		next = start + PGDIR_SIZE;
+		if (next > end)
+			next = end;
+
+		if (pgd_val(*pgd)) {
+			last_map_addr = phys_pud_update(pgd, __pa(start), __pa(end));
+			continue;
+		}
+
 		if (after_bootmem)
 			pud = pud_offset(pgd, start & PGDIR_MASK);
 		else
 			pud = alloc_low_page(&pud_phys);
 
-		next = start + PGDIR_SIZE;
-		if (next > end)
-			next = end;
 		last_map_addr = phys_pud_init(pud, __pa(start), __pa(next));
 		unmap_low_page(pud);
 		if (!after_bootmem)


