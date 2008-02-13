Return-Path: <linux-kernel-owner+w=401wt.eu-S1762058AbYBMNA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762058AbYBMNA3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 08:00:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755667AbYBMNAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 08:00:20 -0500
Received: from hel.is.scarlet.be ([193.74.71.26]:41887 "EHLO hel.is.scarlet.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756871AbYBMNAT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 08:00:19 -0500
X-Greylist: delayed 1044 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Feb 2008 08:00:18 EST
Date: Wed, 13 Feb 2008 13:42:10 +0100
Message-Id: <JW6GMA$1445536B7A545413BA0D6B6753D6901F@scarlet.be>
Subject: Re: parisc compile error
MIME-Version: 1.0
X-Sensitivity: 3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
From: "rubisher" <rubisher@scarlet.be>
To: "rubi\.sher" <rubi.sher@scarlet.be>
Cc: "kyle" <kyle@mcmartin.ca>, "clameter" <clameter@sgi.com>,
       "kyle" <kyle@mcmartin.ca>, "bunk" <bunk@kernel.org>,
       "kyle" <kyle@parisc-linux.org>, "matthew" <matthew@wil.cx>,
       "grundler" <grundler@parisc-linux.org>,
       "linux-parisc" <linux-parisc@vger.kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "rubisher" <rubisher@scarlet.be>
X-XaM3-API-Version: 4.1 (B54)
X-type: 0
X-SenderIP: 57.67.177.33
X-DCC-scarlet.be-Metrics: hel; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > On Thu, Feb 07, 2008 at 03:33:07PM -0800, Christoph Lameter wrote:
> > > On Thu, 7 Feb 2008, Kyle McMartin wrote:
> > > 
> > > > yes, it's in my batch of fixes.
> > > 
> > > <big sigh of relief> So I do not have to worry about it?
> > > 
> > 
> > haha no. i don't expect people to have to untangle the mess of includes
> > that is <asm-parisc/*.h> :)
> > 
> > cheers, kyle
> > -
> This move to define those symbol before including linux/mm.h seems to make the
> drill:
> --- include/asm-parisc/pgtable.h.Orig	2007-10-22 08:19:20.000000000 +0000
> +++ include/asm-parisc/pgtable.h	2008-02-12 16:28:36.000000000 +0000
> @@ -10,6 +10,12 @@
>   * we simulate an x86-style page table for the linux mm code
>   */
>  
> +extern  void *vmalloc_start;
> +#define PCXL_DMA_MAP_SIZE   (8*1024*1024)
> +#define VMALLOC_START   ((unsigned long)vmalloc_start)
> +/* this is a fixmap remnant, see fixmap.h */
> +#define VMALLOC_END	(KERNEL_MAP_END)
> +
>  #include <linux/mm.h>		/* for vm_area_struct */
>  #include <linux/bitops.h>
>  #include <asm/processor.h>
> @@ -116,14 +122,6 @@
>  
>  #define FIRST_USER_ADDRESS	0
>  
> -#ifndef __ASSEMBLY__
> -extern  void *vmalloc_start;
> -#define PCXL_DMA_MAP_SIZE   (8*1024*1024)
> -#define VMALLOC_START   ((unsigned long)vmalloc_start)
> -/* this is a fixmap remnant, see fixmap.h */
> -#define VMALLOC_END	(KERNEL_MAP_END)
> -#endif
> -
>  /* NB: The tlb miss handlers make certain assumptions about the order */
>  /*     of the following bits, so be careful (One example, bits 25-31  */
>  /*     are moved together in one instruction).                        */
> === <> ====
> 
> But next compile error appears there:
> 
> In file included from
> /CAD/linux-2.6.25-rc1-pa-git-20080212/arch/parisc/mm/init.c:26:
> include2/asm/pgalloc.h:142: error: conflicting types for 'pte_free_kernel'
> include2/asm/pgalloc.h:137: error: previous definition of 'pte_free_kernel'
> was here
> include2/asm/pgalloc.h: In function 'pte_free_kernel':
> include2/asm/pgalloc.h:144: error: expected ')' before ';' token
> include2/asm/pgalloc.h:145: error: too few arguments to function
'pte_free_kernel'
> include2/asm/pgalloc.h:145: error: expected ';' before '}' token
> make[2]: *** [arch/parisc/mm/init.o] Error 1
> make[1]: *** [arch/parisc/mm] Error 2
> make: *** [sub-make] Error 2
> 
> 
> and in include/asm-parisc/pgalloc.h we can read:
> 
> static inline void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
> {
>         free_page((unsigned long)pte);
> }
> 
> static inline void pte_free_kernel(struct mm_struct *mm, struct page *pte)
> {
>         pgtable_page_dtor(pte);
>         pte_free_kernel(page_address((pte));
> }
> 
Well may be is it much more what parisc need?
--- ./include/asm-parisc/pgalloc.h.Orig	2008-02-11 07:31:24.000000000 +0000
+++ ./include/asm-parisc/pgalloc.h	2008-02-13 10:02:53.000000000 +0000
@@ -138,10 +138,10 @@
 	free_page((unsigned long)pte);
 }
 
-static inline void pte_free_kernel(struct mm_struct *mm, struct page *pte)
+static inline void pte_free(struct mm_struct *mm, pgtable_t pte)
 {
 	pgtable_page_dtor(pte);
-	pte_free_kernel(page_address((pte));
+	pte_free_kernel(mm, page_address((pte)));
 }
 
 #define check_pgt_cache()	do { } while (0)
=== <> ===

And btw some more small hunk:
    - sys_timerfd was gone so
--- ./arch/parisc/kernel/syscall_table.S.Orig	2007-10-22 08:18:54.000000000 +0000
+++ ./arch/parisc/kernel/syscall_table.S	2008-02-13 12:00:08.000000000 +0000
@@ -401,7 +401,7 @@
 	ENTRY_COMP(kexec_load)		/* 300 */
 	ENTRY_COMP(utimensat)
 	ENTRY_COMP(signalfd)
-	ENTRY_COMP(timerfd)
+	ENTRY_SAME(ni_syscall)		/* 303 (timerfd -- dead) */
 	ENTRY_SAME(eventfd)
 	ENTRY_COMP(fallocate)		/* 305 */
 
=== <> ===

    - some lake of changes of kset to kobj:
--- ./drivers/parisc/pdc_stable.c.Orig	2008-01-28 07:09:26.000000000 +0000
+++ ./drivers/parisc/pdc_stable.c	2008-02-13 11:22:16.000000000 +0000
@@ -829,7 +829,7 @@
 				   struct kobj_attribute *attr,
 				   const char *buf, size_t count)
 {
-	return pdcs_auto_write(kset, attr, buf, count, PF_AUTOBOOT);
+	return pdcs_auto_write(kobj, attr, buf, count, PF_AUTOBOOT);
 }
 
 /**
@@ -845,7 +845,7 @@
 				     struct kobj_attribute *attr,
 				     const char *buf, size_t count)
 {
-	return pdcs_auto_write(kset, attr, buf, count, PF_AUTOSEARCH);
+	return pdcs_auto_write(kobj, attr, buf, count, PF_AUTOSEARCH);
 }
 
 /**
@@ -1066,7 +1066,7 @@
 	}
 
 	/* Don't forget the root entries */
-	error = sysfs_create_group(stable_kobj, pdcs_attr_group);
+	error = sysfs_create_group(stable_kobj, &pdcs_attr_group);
 
 	/* register the paths kset as a child of the stable kset */
 	paths_kset = kset_create_and_add("paths", NULL, stable_kobj);
=== <> ===

And the kernel build, but I don't yet try to boot it...

Hth,
r.
---
Scarlet One, ADSL 6 Mbps + Telephone, from EUR 29,95...
http://www.scarlet.be/

