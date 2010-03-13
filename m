Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936339Ab0CMBQc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:16:32 -0500
Received: from kroah.org ([198.145.64.141]:60969 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935006Ab0CMAUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:20:49 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:13 2010
Message-Id: <20100313001513.015536228@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:13:08 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ian Campbell <ian.campbell@citrix.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       =?UTF-8?q?Pasi=20K=C3=A4rkk=C3=A4inen?= <pasik@iki.fi>,
       <xen-devel@lists.xensource.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [patch 090/123] x86, xen: Disable highmem PTE allocation even when CONFIG_HIGHPTE=y
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Ian Campbell <ian.campbell@citrix.com>

commit 817a824b75b1475f1b067c8cee318c7b4d66fcde upstream.

There's a path in the pagefault code where the kernel deliberately
breaks its own locking rules by kmapping a high pte page without
holding the pagetable lock (in at least page_check_address). This
breaks Xen's ability to track the pinned/unpinned state of the
page. There does not appear to be a viable workaround for this
behaviour so simply disable HIGHPTE for all Xen guests.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
LKML-Reference: <1267204562-11844-1-git-send-email-ian.campbell@citrix.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Pasi Kärkkäinen <pasik@iki.fi>
Cc: <xen-devel@lists.xensource.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/xen/enlighten.c |    7 +++++++
 arch/x86/xen/mmu.c       |   11 ++++++-----
 2 files changed, 13 insertions(+), 5 deletions(-)

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
@@ -1094,6 +1095,12 @@ asmlinkage void __init xen_start_kernel(
 
 	__supported_pte_mask |= _PAGE_IOMAP;
 
+	/*
+	 * Prevent page tables from being allocated in highmem, even
+	 * if CONFIG_HIGHPTE is enabled.
+	 */
+	__userpte_alloc_gfp &= ~__GFP_HIGHMEM;
+
 	/* Work out if we support NX */
 	x86_configure_nx();
 
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1432,14 +1432,15 @@ static void *xen_kmap_atomic_pte(struct
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


