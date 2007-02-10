Return-Path: <linux-kernel-owner+w=401wt.eu-S1751567AbXBJRaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751567AbXBJRaK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 12:30:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751534AbXBJRaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 12:30:09 -0500
Received: from rubidium.solidboot.com ([81.22.244.175]:36122 "EHLO
	mail.solidboot.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbXBJRaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 12:30:08 -0500
Date: Sat, 10 Feb 2007 19:29:59 +0200
From: Imre Deak <imre.deak@solidboot.com>
To: rmk@arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: VM: fix user page protection values (was Re: [PATCH] DEV: zero: use correct pgprot for zeromapping)
Message-ID: <20070210172959.GA25080@bitbox.mine.nu>
References: <20070210091521.GA7350@bitbox.mine.nu> <20070210093954.GA29145@flint.arm.linux.org.uk> <20070210100340.GA7519@bitbox.mine.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070210100340.GA7519@bitbox.mine.nu>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 10, 2007 at 12:03:40PM +0200, Imre Deak wrote:
> On Sat, Feb 10, 2007 at 09:39:54AM +0000, Russell King wrote:
> > On Sat, Feb 10, 2007 at 11:15:21AM +0200, Imre Deak wrote:
> > > Instead of PAGE_COPY use the pgprot bits established already at
> > > original mapping time of the VMA. This will also include any
> > > architecture specific bits setup through protection_map.
> > > zeromap_page_range will take care of COW'ing the passed pgprot.
> > 
> > NAK.  What if PAGE_COPY is used elsewhere and ends up accidentally
> > allowing write access?
> 
> Or rather, result in the bogus global mapping. True.
> 
> > 
> > I think the right solution is to make PAGE_COPY a variable in the same
> > way that PAGE_KERNEL is, and adjust it as appropriate.
> 
> Ok, and also at least PAGE_SHARED and PAGE_READONLY I assume.

[ For consistency base all PAGE_* macros off a variable. I tested this
on ARM1136. ]

The PAGE_* user page protection macros don't take into account the
configured memory policy and other architecture specific bits like
the global/ASID and shared mapping bits. Instead of constants let
these depend on a variable fixed up at init just like PAGE_KERNEL.

Signed-off-by: Imre Deak <imre.deak@solidboot.com>
---
 arch/arm/mm/mmu.c         |    3 ++
 include/asm-arm/pgtable.h |   54 ++++++++++++++++++++++++++------------------
 2 files changed, 35 insertions(+), 22 deletions(-)

diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index 655c837..94fd4bf 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -49,8 +49,10 @@ pmd_t *top_pmd;
 
 static unsigned int cachepolicy __initdata = CPOLICY_WRITEBACK;
 static unsigned int ecc_mask __initdata = 0;
+pgprot_t pgprot_user;
 pgprot_t pgprot_kernel;
 
+EXPORT_SYMBOL(pgprot_user);
 EXPORT_SYMBOL(pgprot_kernel);
 
 struct cachepolicy {
@@ -345,6 +347,7 @@ static void __init build_mem_type_table(void)
 		mem_types[MT_MINICLEAN].prot_sect &= ~PMD_SECT_TEX(1);
 	}
 
+	pgprot_user   = __pgprot(L_PTE_PRESENT | L_PTE_YOUNG | user_pgprot);
 	pgprot_kernel = __pgprot(L_PTE_PRESENT | L_PTE_YOUNG |
 				 L_PTE_DIRTY | L_PTE_WRITE |
 				 L_PTE_EXEC | kern_pgprot);
diff --git a/include/asm-arm/pgtable.h b/include/asm-arm/pgtable.h
index b8cf2d5..7b2bafc 100644
--- a/include/asm-arm/pgtable.h
+++ b/include/asm-arm/pgtable.h
@@ -175,19 +175,29 @@ extern void __pgd_error(const char *file, int line, unsigned long val);
 #ifndef __ASSEMBLY__
 
 /*
- * The following macros handle the cache and bufferable bits...
+ * The pgprot_* and protection_map entries will be fixed up in runtime
+ * to include the cachable and bufferable bits based on memory policy,
+ * as well as any architecture dependent bits like global/ASID and SMP
+ * shared mapping bits.
  */
 #define _L_PTE_DEFAULT	L_PTE_PRESENT | L_PTE_YOUNG | L_PTE_CACHEABLE | L_PTE_BUFFERABLE
 #define _L_PTE_READ	L_PTE_USER | L_PTE_EXEC
 
+extern pgprot_t		pgprot_user;
 extern pgprot_t		pgprot_kernel;
 
-#define PAGE_NONE       __pgprot(_L_PTE_DEFAULT)
-#define PAGE_COPY       __pgprot(_L_PTE_DEFAULT | _L_PTE_READ)
-#define PAGE_SHARED     __pgprot(_L_PTE_DEFAULT | _L_PTE_READ | L_PTE_WRITE)
-#define PAGE_READONLY   __pgprot(_L_PTE_DEFAULT | _L_PTE_READ)
+#define PAGE_NONE	pgprot_user
+#define PAGE_COPY	__pgprot(pgprot_val(pgprot_user) | _L_PTE_READ)
+#define PAGE_SHARED	__pgprot(pgprot_val(pgprot_user) | _L_PTE_READ | \
+				 L_PTE_WRITE)
+#define PAGE_READONLY	__pgprot(pgprot_val(pgprot_user) | _L_PTE_READ)
 #define PAGE_KERNEL	pgprot_kernel
 
+#define __PAGE_NONE	__pgprot(_L_PTE_DEFAULT)
+#define __PAGE_COPY	__pgprot(_L_PTE_DEFAULT | _L_PTE_READ)
+#define __PAGE_SHARED	__pgprot(_L_PTE_DEFAULT | _L_PTE_READ | L_PTE_WRITE)
+#define __PAGE_READONLY	__pgprot(_L_PTE_DEFAULT | _L_PTE_READ)
+
 #endif /* __ASSEMBLY__ */
 
 /*
@@ -198,23 +208,23 @@ extern pgprot_t		pgprot_kernel;
  *  2) If we could do execute protection, then read is implied
  *  3) write implies read permissions
  */
-#define __P000  PAGE_NONE
-#define __P001  PAGE_READONLY
-#define __P010  PAGE_COPY
-#define __P011  PAGE_COPY
-#define __P100  PAGE_READONLY
-#define __P101  PAGE_READONLY
-#define __P110  PAGE_COPY
-#define __P111  PAGE_COPY
-
-#define __S000  PAGE_NONE
-#define __S001  PAGE_READONLY
-#define __S010  PAGE_SHARED
-#define __S011  PAGE_SHARED
-#define __S100  PAGE_READONLY
-#define __S101  PAGE_READONLY
-#define __S110  PAGE_SHARED
-#define __S111  PAGE_SHARED
+#define __P000  __PAGE_NONE
+#define __P001  __PAGE_READONLY
+#define __P010  __PAGE_COPY
+#define __P011  __PAGE_COPY
+#define __P100  __PAGE_READONLY
+#define __P101  __PAGE_READONLY
+#define __P110  __PAGE_COPY
+#define __P111  __PAGE_COPY
+
+#define __S000  __PAGE_NONE
+#define __S001  __PAGE_READONLY
+#define __S010  __PAGE_SHARED
+#define __S011  __PAGE_SHARED
+#define __S100  __PAGE_READONLY
+#define __S101  __PAGE_READONLY
+#define __S110  __PAGE_SHARED
+#define __S111  __PAGE_SHARED
 
 #ifndef __ASSEMBLY__
 /*
-- 
1.4.4.3.GIT

