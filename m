Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965468Ab0BZRQM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 12:16:12 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:45662 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965456Ab0BZRQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 12:16:08 -0500
X-IronPort-AV: E=Sophos;i="4.49,547,1262581200"; 
   d="scan'208";a="85874838"
From: Ian Campbell <ian.campbell@citrix.com>
To: linux-kernel@vger.kernel.org
Cc: Ian Campbell <ian.campbell@citrix.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>,
       =?utf-8?q?Pasi=20K=C3=A4rkk=C3=A4inen?= <pasik@iki.fi>,
       <xen-devel@lists.xensource.com>
Subject: [PATCH 1/3] xen: disable highmem PTE allocation even when CONFIG_HIGHPTE=y
Date: Fri, 26 Feb 2010 17:16:00 +0000
Message-Id: <1267204562-11844-1-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1267204547.11737.12659.camel@zakaz.uk.xensource.com>
References: <1267204547.11737.12659.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 26 Feb 2010 17:16:06.0813 (UTC) FILETIME=[61DEDCD0:01CAB707]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's a path in the pagefault code where the kernel deliberately
breaks its own locking rules by kmapping a high pte page without
holding the pagetable lock (in at least page_check_address). This
breaks Xen's ability to track the pinned/unpinned state of the
page. There does not appear to be a viable workaround for this
behaviour so simply disable HIGHPTE for all Xen guests.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Pasi Kärkkäinen <pasik@iki.fi>
Cc: <stable@kernel.org> # .32.x: 14315592: Allow highmem user page tables to be disabled at boot time
Cc: <stable@kernel.org> # .32.x
Cc: <xen-devel@lists.xensource.com>
---
 arch/x86/xen/enlighten.c |    7 +++++++
 arch/x86/xen/mmu.c       |   11 ++++++-----
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 36daccb..b607239 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -50,6 +50,7 @@
 #include <asm/traps.h>
 #include <asm/setup.h>
 #include <asm/desc.h>
+#include <asm/pgalloc.h>
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/reboot.h>
@@ -1094,6 +1095,12 @@ asmlinkage void __init xen_start_kernel(void)
 
 	__supported_pte_mask |= _PAGE_IOMAP;
 
+	/*
+	 * Prevent page tables from being allocated in highmem, even
+	 * if CONFIG_HIGHPTE is enabled.
+	 */
+	__userpte_alloc_gfp &= ~__GFP_HIGHMEM;
+
 	/* Work out if we support NX */
 	x86_configure_nx();
 
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index bf4cd6b..350a3de 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1432,14 +1432,15 @@ static void *xen_kmap_atomic_pte(struct page *page, enum km_type type)
 {
 	pgprot_t prot = PAGE_KERNEL;
 
+	/*
+	 * We disable highmem allocations for page tables so we should never
+	 * see any calls to kmap_atomic_pte on a highmem page.
+	 */
+	BUG_ON(PageHighMem(page));
+
 	if (PagePinned(page))
 		prot = PAGE_KERNEL_RO;
 
-	if (0 && PageHighMem(page))
-		printk("mapping highpte %lx type %d prot %s\n",
-		       page_to_pfn(page), type,
-		       (unsigned long)pgprot_val(prot) & _PAGE_RW ? "WRITE" : "READ");
-
 	return kmap_atomic_prot(page, type, prot);
 }
 #endif
-- 
1.5.6.5

