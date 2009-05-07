Return-Path: <linux-kernel-owner+w=401wt.eu-S1763538AbZEHATq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763538AbZEHATq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 20:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758904AbZEHAKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 20:10:22 -0400
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:52721
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755272AbZEHAJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 20:09:58 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 5/8] xen/i386: make sure initial VGA/ISA mappings are not overridden
Date: Thu,  7 May 2009 13:24:59 -0700
Message-Id: <1241727902-3176-6-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1241727902-3176-1-git-send-email-jeremy@goop.org>
References: <1241727902-3176-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

arch/x86/mm/init_32.c overrides the ISA/VGA mappings with direct mappings
which do not have _PAGE_IOMAP set, thereby making the ISA space inaccessible.

This patch adds to the existing hack to make sure the pre-constructed
ISA mappings are not incorrectly overwritten.

This makes 32-bit dom0 VGA work properly.

Thanks to Gerd Hoffman for pointing this out.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/mmu.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index a96f5b9..5af62d8 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1443,10 +1443,17 @@ static void *xen_kmap_atomic_pte(struct page *page, enum km_type type)
 #ifdef CONFIG_X86_32
 static __init pte_t mask_rw_pte(pte_t *ptep, pte_t pte)
 {
-	/* If there's an existing pte, then don't allow _PAGE_RW to be set */
-	if (pte_val_ma(*ptep) & _PAGE_PRESENT)
+	pte_t oldpte = *ptep;
+
+	if (pte_flags(oldpte) & _PAGE_PRESENT) {
+		/* Don't allow existing IO mappings to be overridden */
+		if (pte_flags(oldpte) & _PAGE_IOMAP)
+			pte = oldpte;
+
+		/* Don't allow _PAGE_RW to be set on existing pte */
 		pte = __pte_ma(((pte_val_ma(*ptep) & _PAGE_RW) | ~_PAGE_RW) &
 			       pte_val_ma(pte));
+	}
 
 	return pte;
 }
-- 
1.6.0.6

