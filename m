Return-Path: <linux-kernel-owner+w=401wt.eu-S1761837AbZE0HW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761837AbZE0HW0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760852AbZE0HRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:17:49 -0400
Received: from claw.goop.org ([74.207.240.146]:41512 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760836AbZE0HRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:17:48 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>, Greg KH <gregkh@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, Chris Wright <chrisw@redhat.com>,
       kurt.hackel@oracle.com, Andrew Morton <akpm@linux-foundation.org>,
       Ky Srinivasan <ksrinivasan@novell.com>, Beulich <jbeulich@novell.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 16/16] xen/i386: make sure initial VGA/ISA mappings are not overridden
Date: Wed, 27 May 2009 00:15:38 -0700
Message-Id: <1243408538-21100-17-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1243408538-21100-1-git-send-email-jeremy@goop.org>
References: <1243408538-21100-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

arch/x86/mm/init_32.c overrides the ISA/VGA mappings with direct mappings
which do not have _PAGE_IOMAP set, thereby making the ISA space inaccessible.

This patch adds to the existing hack to make sure the pre-constructed
ISA mappings are not incorrectly overwritten.

Thanks to Gerd Hoffman for pointing this out.

[ Impact: Makes 32-bit dom0 VGA work properly. ]

Diagnosed-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/mmu.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 85d9d18..331e52d 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1502,10 +1502,17 @@ static void *xen_kmap_atomic_pte(struct page *page, enum km_type type)
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

