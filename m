Return-Path: <linux-kernel-owner+w=401wt.eu-S1759973AbZBBV6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759973AbZBBV6o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 16:58:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759508AbZBBV6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 16:58:09 -0500
Received: from gw.goop.org ([64.81.55.164]:42474 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759240AbZBBV6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 16:58:08 -0500
Message-ID: <49876C6E.3010809@goop.org>
Date: Mon, 02 Feb 2009 13:58:06 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] xen: fix 32-bit build resulting from mmu move
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moving the mmu code from enlighten.c to mmu.c inadvertently broke the
32-bit build.  Fix it.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/mmu.c |   37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

===================================================================
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1388,6 +1388,43 @@
 #endif
 }
 
+#ifdef CONFIG_HIGHPTE
+static void *xen_kmap_atomic_pte(struct page *page, enum km_type type)
+{
+	pgprot_t prot = PAGE_KERNEL;
+
+	if (PagePinned(page))
+		prot = PAGE_KERNEL_RO;
+
+	if (0 && PageHighMem(page))
+		printk("mapping highpte %lx type %d prot %s\n",
+		       page_to_pfn(page), type,
+		       (unsigned long)pgprot_val(prot) & _PAGE_RW ? "WRITE" : "READ");
+
+	return kmap_atomic_prot(page, type, prot);
+}
+#endif
+
+#ifdef CONFIG_X86_32
+static __init pte_t mask_rw_pte(pte_t *ptep, pte_t pte)
+{
+	/* If there's an existing pte, then don't allow _PAGE_RW to be set */
+	if (pte_val_ma(*ptep) & _PAGE_PRESENT)
+		pte = __pte_ma(((pte_val_ma(*ptep) & _PAGE_RW) | ~_PAGE_RW) &
+			       pte_val_ma(pte));
+
+	return pte;
+}
+
+/* Init-time set_pte while constructing initial pagetables, which
+   doesn't allow RO pagetable pages to be remapped RW */
+static __init void xen_set_pte_init(pte_t *ptep, pte_t pte)
+{
+	pte = mask_rw_pte(ptep, pte);
+
+	xen_set_pte(ptep, pte);
+}
+#endif
 
 /* Early in boot, while setting up the initial pagetable, assume
    everything is pinned. */


