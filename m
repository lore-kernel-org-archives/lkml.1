Return-Path: <linux-kernel-owner+w=401wt.eu-S1760492AbYGKTZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760492AbYGKTZe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 15:25:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760972AbYGKTXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 15:23:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52640 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760961AbYGKTXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 15:23:42 -0400
Date: Fri, 11 Jul 2008 12:22:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jon Tollefson <kniht@linux.vnet.ibm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, penberg@cs.helsinki.fi,
       mpm@selenic.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       cl@linux-foundation.org, Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: SL*B: drop kmem cache argument from constructor
Message-Id: <20080711122228.eb40247f.akpm@linux-foundation.org>
In-Reply-To: <48763C60.9020805@linux.vnet.ibm.com>
References: <20080710011132.GA8327@martell.zuzino.mipt.ru>
	<48763C60.9020805@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jul 2008 11:44:16 -0500 Jon Tollefson <kniht@linux.vnet.ibm.com> wrote:

> Alexey Dobriyan wrote:
> > Kmem cache passed to constructor is only needed for constructors that are
> > themselves multiplexeres. Nobody uses this "feature", nor does anybody uses
> > passed kmem cache in non-trivial way, so pass only pointer to object.
> >
> > Non-trivial places are:
> > 	arch/powerpc/mm/init_64.c
> > 	arch/powerpc/mm/hugetlbpage.c
> >   
> ...<snip>...
> > --- a/arch/powerpc/mm/hugetlbpage.c
> > +++ b/arch/powerpc/mm/hugetlbpage.c
> > @@ -595,9 +595,9 @@ static int __init hugepage_setup_sz(char *str)
> >  }
> >  __setup("hugepagesz=", hugepage_setup_sz);
> >
> > -static void zero_ctor(struct kmem_cache *cache, void *addr)
> > +static void zero_ctor(void *addr)
> >  {
> > -	memset(addr, 0, kmem_cache_size(cache));
> > +	memset(addr, 0, HUGEPTE_TABLE_SIZE);
> >   
> This isn't going to work with the multiple huge page size support.  The
> HUGEPTE_TABLE_SIZE macro now takes a parameter with of the mmu psize
> index to indicate the size of page.
> 

hrm.  I suppose we could hold our noses and use ksize(), assuming that
we're ready to use ksize() at this stage in the object's lifetime.

Better would be to just use kmem_cache_zalloc()?

--- a/arch/powerpc/mm/hugetlbpage.c~slb-drop-kmem-cache-argument-from-constructor-fix
+++ a/arch/powerpc/mm/hugetlbpage.c
@@ -113,7 +113,7 @@ static inline pte_t *hugepte_offset(huge
 static int __hugepte_alloc(struct mm_struct *mm, hugepd_t *hpdp,
 			   unsigned long address, unsigned int psize)
 {
-	pte_t *new = kmem_cache_alloc(huge_pgtable_cache(psize),
+	pte_t *new = kmem_cache_zalloc(huge_pgtable_cache(psize),
 				      GFP_KERNEL|__GFP_REPEAT);
 
 	if (! new)
@@ -730,11 +730,6 @@ static int __init hugepage_setup_sz(char
 }
 __setup("hugepagesz=", hugepage_setup_sz);
 
-static void zero_ctor(void *addr)
-{
-	memset(addr, 0, HUGEPTE_TABLE_SIZE);
-}
-
 static int __init hugetlbpage_init(void)
 {
 	unsigned int psize;
@@ -756,7 +751,7 @@ static int __init hugetlbpage_init(void)
 						HUGEPTE_TABLE_SIZE(psize),
 						HUGEPTE_TABLE_SIZE(psize),
 						0,
-						zero_ctor);
+						NULL);
 			if (!huge_pgtable_cache(psize))
 				panic("hugetlbpage_init(): could not create %s"\
 				      "\n", HUGEPTE_CACHE_NAME(psize));
_


btw, Nick, what's with that dopey

	huge_pgtable_cache(psize) = kmem_cache_create(...

trick?  The result of a function call is not an lvalue, and writing a
macro which pretends to be a function and then using it in some manner
in which a function cannot be used is seven ways silly :(
