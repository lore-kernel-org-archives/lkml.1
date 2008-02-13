Return-Path: <linux-kernel-owner+w=401wt.eu-S1756080AbYBMG4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080AbYBMG4s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 01:56:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbYBMG4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 01:56:37 -0500
Received: from sif.is.scarlet.be ([193.74.71.28]:45062 "EHLO sif.is.scarlet.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752037AbYBMG4g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 01:56:36 -0500
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Feb 2008 01:56:36 EST
Date: Wed, 13 Feb 2008 07:49:12 +0100
Message-Id: <JW60A0$CF80A6CA85E28806A3D1EDDACE158868@scarlet.be>
Subject: Re: parisc compile error
MIME-Version: 1.0
X-Sensitivity: 3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
From: "rubisher" <rubi.sher@scarlet.be>
To: "kyle" <kyle@mcmartin.ca>
Cc: "clameter" <clameter@sgi.com>, "kyle" <kyle@mcmartin.ca>,
       "bunk" <bunk@kernel.org>, "kyle" <kyle@parisc-linux.org>,
       "matthew" <matthew@wil.cx>, "grundler" <grundler@parisc-linux.org>,
       "linux-parisc" <linux-parisc@vger.kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "rubisher" <rubisher@scarlet.be>
X-XaM3-API-Version: 4.1 (B54)
X-type: 0
X-SenderIP: 57.67.177.33
X-DCC-scarlet.be-Metrics: sif; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Feb 07, 2008 at 03:33:07PM -0800, Christoph Lameter wrote:
> > On Thu, 7 Feb 2008, Kyle McMartin wrote:
> > 
> > > yes, it's in my batch of fixes.
> > 
> > <big sigh of relief> So I do not have to worry about it?
> > 
> 
> haha no. i don't expect people to have to untangle the mess of includes
> that is <asm-parisc/*.h> :)
> 
> cheers, kyle
> -
This move to define those symbol before including linux/mm.h seems to make the
drill:
--- include/asm-parisc/pgtable.h.Orig	2007-10-22 08:19:20.000000000 +0000
+++ include/asm-parisc/pgtable.h	2008-02-12 16:28:36.000000000 +0000
@@ -10,6 +10,12 @@
  * we simulate an x86-style page table for the linux mm code
  */
 
+extern  void *vmalloc_start;
+#define PCXL_DMA_MAP_SIZE   (8*1024*1024)
+#define VMALLOC_START   ((unsigned long)vmalloc_start)
+/* this is a fixmap remnant, see fixmap.h */
+#define VMALLOC_END	(KERNEL_MAP_END)
+
 #include <linux/mm.h>		/* for vm_area_struct */
 #include <linux/bitops.h>
 #include <asm/processor.h>
@@ -116,14 +122,6 @@
 
 #define FIRST_USER_ADDRESS	0
 
-#ifndef __ASSEMBLY__
-extern  void *vmalloc_start;
-#define PCXL_DMA_MAP_SIZE   (8*1024*1024)
-#define VMALLOC_START   ((unsigned long)vmalloc_start)
-/* this is a fixmap remnant, see fixmap.h */
-#define VMALLOC_END	(KERNEL_MAP_END)
-#endif
-
 /* NB: The tlb miss handlers make certain assumptions about the order */
 /*     of the following bits, so be careful (One example, bits 25-31  */
 /*     are moved together in one instruction).                        */
=== <> ====

But next compile error appears there:

In file included from
/CAD/linux-2.6.25-rc1-pa-git-20080212/arch/parisc/mm/init.c:26:
include2/asm/pgalloc.h:142: error: conflicting types for 'pte_free_kernel'
include2/asm/pgalloc.h:137: error: previous definition of 'pte_free_kernel'
was here
include2/asm/pgalloc.h: In function 'pte_free_kernel':
include2/asm/pgalloc.h:144: error: expected ')' before ';' token
include2/asm/pgalloc.h:145: error: too few arguments to function 'pte_free_kernel'
include2/asm/pgalloc.h:145: error: expected ';' before '}' token
make[2]: *** [arch/parisc/mm/init.o] Error 1
make[1]: *** [arch/parisc/mm] Error 2
make: *** [sub-make] Error 2


and in include/asm-parisc/pgalloc.h we can read:

static inline void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
{
        free_page((unsigned long)pte);
}

static inline void pte_free_kernel(struct mm_struct *mm, struct page *pte)
{
        pgtable_page_dtor(pte);
        pte_free_kernel(page_address((pte));
}

i.e. 2 time the definition of the same function: which is the right definition?

Cheers,
    r.

---
Scarlet One, ADSL 6 Mbps + Telephone, from EUR 29,95...
http://www.scarlet.be/

