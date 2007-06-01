Return-Path: <linux-kernel-owner+w=401wt.eu-S1763516AbXFASu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763516AbXFASu1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 14:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762018AbXFASuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 14:50:18 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:59860 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761924AbXFASuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 14:50:17 -0400
Date: Fri, 1 Jun 2007 19:50:14 +0100
To: Andrew Morton <akpm@linux-foundation.org>
Cc: benh@kernel.crashing.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc3-mm1: IA64 make allnoconfig broken
Message-ID: <20070601185013.GA13126@skynet.ie>
References: <20070530235823.793f00d9.akpm@linux-foundation.org> <20070601164204.GA25049@skynet.ie> <20070601100004.1e72654d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20070601100004.1e72654d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (01/06/07 10:00), Andrew Morton didst pronounce:
> On Fri, 1 Jun 2007 17:42:04 +0100 mel@skynet.ie (Mel Gorman) wrote:
> 
> > mm/memory.c: In function `do_wp_page':
> > mm/memory.c:1700: error: parse error before "__changed"
> > mm/memory.c:1700: error: parse error before ')' token
> > mm/memory.c:1704: error: parse error before "ret"
> 
> this?
> 
> --- a/include/asm-ia64/pgtable.h~rework-ptep_set_access_flags-and-fix-sun4c-fix
> +++ a/include/asm-ia64/pgtable.h
> @@ -546,7 +546,7 @@ extern void lazy_mmu_prot_update (pte_t 
>  # define ptep_set_access_flags(__vma, __addr, __ptep, __entry, __safely_writable) \
>  ({										\
>  	int __changed = !pte_same(*(__ptep), __entry);				\
> -	if (__changed) {							\
> +	if (__changed)							\
>  		ptep_establish(__vma, __addr, __ptep, __entry)			\
>  	__changed;								\
>  })

Fails with

mm/memory.c: In function `do_wp_page':
mm/memory.c:1700: error: parse error before "__changed"
mm/memory.c: In function `handle_pte_fault':
mm/memory.c:2544: error: parse error before "__changed"

Am currently testing the following;

diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.22-rc3-mm1-clean/include/asm-ia64/pgtable.h linux-2.6.22-rc3-mm1-ia64fix/include/asm-ia64/pgtable.h
--- linux-2.6.22-rc3-mm1-clean/include/asm-ia64/pgtable.h	2007-06-01 09:24:39.000000000 +0100
+++ linux-2.6.22-rc3-mm1-ia64fix/include/asm-ia64/pgtable.h	2007-06-01 19:44:48.000000000 +0100
@@ -546,8 +546,8 @@ extern void lazy_mmu_prot_update (pte_t 
 # define ptep_set_access_flags(__vma, __addr, __ptep, __entry, __safely_writable) \
 ({										\
 	int __changed = !pte_same(*(__ptep), __entry);				\
-	if (__changed) {							\
-		ptep_establish(__vma, __addr, __ptep, __entry)			\
+	if (__changed)							\
+		ptep_establish(__vma, __addr, __ptep, __entry);			\
 	__changed;								\
 })
 #endif

-- 
-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
