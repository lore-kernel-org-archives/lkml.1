Return-Path: <linux-kernel-owner+w=401wt.eu-S1754804AbZDVB7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804AbZDVB7W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 21:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752852AbZDVB7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 21:59:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45992 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752211AbZDVB7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 21:59:12 -0400
Date: Tue, 21 Apr 2009 18:53:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, Izik Eidus <ieidus@redhat.com>
Subject: Re: mmotm 2009-04-21-15-00 uploaded
Message-Id: <20090421185313.06bec1cc.akpm@linux-foundation.org>
In-Reply-To: <49EE7351.6080802@oracle.com>
References: <200904212219.n3LMJ2O7007301@imap1.linux-foundation.org>
	<49EE7351.6080802@oracle.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Apr 2009 18:30:57 -0700 Randy Dunlap <randy.dunlap@oracle.com> wrote:

> akpm@linux-foundation.org wrote:
> > The mm-of-the-moment snapshot 2009-04-21-15-00 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > and will soon be available at
> > 
> >    git://git.zen-sources.org/zen/mmotm.git
> > 
> > It contains the following patches against 2.6.30-rc2:
> 
> 
> 2 of 10 i386 builds ended like:
> 
> 
>   CC      arch/x86/kernel/asm-offsets.s
> In file included from include/linux/suspend.h:8,
>                  from arch/x86/kernel/asm-offsets_32.c:11,
>                  from arch/x86/kernel/asm-offsets.c:2:
> include/linux/mm.h: In function 'get_pte':
> include/linux/mm.h:907: error: implicit declaration of function 'kmap_atomic_pte'
> make[2]: *** [arch/x86/kernel/asm-offsets.s] Error 1
> make[1]: *** [prepare0] Error 2
> make: *** [sub-make] Error 2
> 
> 
> 
> config attached.

Caused by ksm-add-get_pte-helper-function-fetching-pte-for-va.patch.

hm, this will end badly.  Let's uninline it.

--- a/include/linux/mm.h~ksm-add-get_pte-helper-function-fetching-pte-for-va-fix
+++ a/include/linux/mm.h
@@ -883,30 +883,7 @@ extern void unregister_shrinker(struct s
 int vma_wants_writenotify(struct vm_area_struct *vma);
 
 extern pte_t *get_locked_pte(struct mm_struct *mm, unsigned long addr, spinlock_t **ptl);
-
-static inline pte_t *get_pte(struct mm_struct *mm, unsigned long addr)
-{
-	pgd_t *pgd;
-	pud_t *pud;
-	pmd_t *pmd;
-	pte_t *ptep = NULL;
-
-	pgd = pgd_offset(mm, addr);
-	if (!pgd_present(*pgd))
-		goto out;
-
-	pud = pud_offset(pgd, addr);
-	if (!pud_present(*pud))
-		goto out;
-
-	pmd = pmd_offset(pud, addr);
-	if (!pmd_present(*pmd))
-		goto out;
-
-	ptep = pte_offset_map(pmd, addr);
-out:
-	return ptep;
-}
+extern pte_t *get_pte(struct mm_struct *mm, unsigned long addr);
 
 #ifdef __PAGETABLE_PUD_FOLDED
 static inline int __pud_alloc(struct mm_struct *mm, pgd_t *pgd,
diff -puN mm/util.c~ksm-add-get_pte-helper-function-fetching-pte-for-va-fix mm/util.c
--- a/mm/util.c~ksm-add-get_pte-helper-function-fetching-pte-for-va-fix
+++ a/mm/util.c
@@ -1,4 +1,5 @@
 #include <linux/mm.h>
+#include <linux/highmem.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/module.h>
@@ -264,6 +265,31 @@ int __attribute__((weak)) get_user_pages
 }
 EXPORT_SYMBOL_GPL(get_user_pages_fast);
 
+pte_t *get_pte(struct mm_struct *mm, unsigned long addr)
+{
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *ptep = NULL;
+
+	pgd = pgd_offset(mm, addr);
+	if (!pgd_present(*pgd))
+		goto out;
+
+	pud = pud_offset(pgd, addr);
+	if (!pud_present(*pud))
+		goto out;
+
+	pmd = pmd_offset(pud, addr);
+	if (!pmd_present(*pmd))
+		goto out;
+
+	ptep = pte_offset_map(pmd, addr);
+out:
+	return ptep;
+}
+EXPORT_SYMBOL_GPL(get_pte);
+
 /* Tracepoints definitions. */
 EXPORT_TRACEPOINT_SYMBOL(kmalloc);
 EXPORT_TRACEPOINT_SYMBOL(kmem_cache_alloc);
_

