Return-Path: <linux-kernel-owner+w=401wt.eu-S1755361AbZCDIQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361AbZCDIQU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 03:16:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752401AbZCDIQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 03:16:12 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:44341 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbZCDIQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 03:16:11 -0500
Subject: Re: [PATCH] x86: set_highmem_pages_init() cleanup
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <20090303121532.GC5740@elte.hu>
References: <1236082212.2675.24.camel@penberg-laptop>
	 <20090303121532.GC5740@elte.hu>
Date: Wed, 04 Mar 2009 10:16:07 +0200
Message-Id: <1236154567.29024.23.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-03 at 13:15 +0100, Ingo Molnar wrote:
> * Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> 
> > From: Pekka Enberg <penberg@cs.helsinki.fi>
> > 
> > Impact: cleanup
> > 
> > This patch moves set_highmem_pages_init() to arch/x86/mm/highmem_32.c. The
> > declaration of the function is kept in asm/numa_32.h because asm/highmem.h is
> > included only CONFIG_HIGHMEM is enabled so we can't put the empty static inline
> > function there.
> > 
> > Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> > ---
> >  arch/x86/include/asm/numa_32.h |    6 +++++-
> >  arch/x86/mm/highmem_32.c       |   34 ++++++++++++++++++++++++++++++++++
> >  arch/x86/mm/init_32.c          |   12 ------------
> >  arch/x86/mm/numa_32.c          |   26 --------------------------
> >  4 files changed, 39 insertions(+), 39 deletions(-)
> 
> Applied, thanks!
> 
> One question:
> 
> > diff --git a/arch/x86/include/asm/numa_32.h b/arch/x86/include/asm/numa_32.h
> > index e9f5db7..a372290 100644
> > --- a/arch/x86/include/asm/numa_32.h
> > +++ b/arch/x86/include/asm/numa_32.h
> > @@ -4,8 +4,12 @@
> >  extern int pxm_to_nid(int pxm);
> >  extern void numa_remove_cpu(int cpu);
> >  
> > -#ifdef CONFIG_NUMA
> > +#ifdef CONFIG_HIGHMEM
> >  extern void set_highmem_pages_init(void);
> > +#else
> > +static inline void set_highmem_pages_init(void)
> > +{
> > +}
> >  #endif
> >  
> >  #endif /* _ASM_X86_NUMA_32_H */
> > diff --git a/arch/x86/mm/highmem_32.c b/arch/x86/mm/highmem_32.c
> > index bcc079c..13a823c 100644
> > --- a/arch/x86/mm/highmem_32.c
> > +++ b/arch/x86/mm/highmem_32.c
> > @@ -1,5 +1,6 @@
> >  #include <linux/highmem.h>
> >  #include <linux/module.h>
> > +#include <linux/swap.h> /* for totalram_pages */
> >  
> >  void *kmap(struct page *page)
> >  {
> > @@ -156,3 +157,36 @@ EXPORT_SYMBOL(kmap);
> >  EXPORT_SYMBOL(kunmap);
> >  EXPORT_SYMBOL(kmap_atomic);
> >  EXPORT_SYMBOL(kunmap_atomic);
> > +
> > +#ifdef CONFIG_NUMA
> > +void __init set_highmem_pages_init(void)
> > +{
> > +	struct zone *zone;
> > +	int nid;
> > +
> > +	for_each_zone(zone) {
> > +		unsigned long zone_start_pfn, zone_end_pfn;
> > +
> > +		if (!is_highmem(zone))
> > +			continue;
> > +
> > +		zone_start_pfn = zone->zone_start_pfn;
> > +		zone_end_pfn = zone_start_pfn + zone->spanned_pages;
> > +
> > +		nid = zone_to_nid(zone);
> > +		printk(KERN_INFO "Initializing %s for node %d (%08lx:%08lx)\n",
> > +				zone->name, nid, zone_start_pfn, zone_end_pfn);
> > +
> > +		add_highpages_with_active_regions(nid, zone_start_pfn,
> > +				 zone_end_pfn);
> > +	}
> > +	totalram_pages += totalhigh_pages;
> > +}
> > +#else
> > +static void __init set_highmem_pages_init(void)
> > +{
> > +	add_highpages_with_active_regions(0, highstart_pfn, highend_pfn);
> > +
> > +	totalram_pages += totalhigh_pages;
> > +}
> > +#endif /* CONFIG_NUMA */
> 
> Couldnt we just wrap the !NUMA case into the NUMA case and just 
> have the NUMA function present, by making for_each_zone() a 
> two-entries matter and making the second entry contain:
> 
>    zone->zone_start_pfn := highstart_pfn
>    zone->spanned_pages := highend_pfn-highstart_pfn 

OK, I don't quite understand your suggestion here. The zones are set up
completely at this stage so AFAICT, even for the UMA case, there should
be a highmem zone there. So unless I am missing something here, I think
we can get away with something as simple as the following.

I don't have any highmem machines to test this but some printk()'s seem
to confirm this (although for machines that don't have any highmem
available, ->zone_start_pfn is zero (whereas highstart_pfn is non-zero).
I think that's because of the !size test in free_area_init_core() but
AFAICT, it's fine as add_highpages_with_active_regions() takes care of
that nicely.

But I'll cc Mel just in case... :-)

			Pekka

>From 29c85778896d263ce5c59c496c13548488b7593c Mon Sep 17 00:00:00 2001
From: Pekka Enberg <penberg@cs.helsinki.fi>
Date: Wed, 4 Mar 2009 10:10:53 +0200
Subject: [PATCH] x86: unify uma and numa copies of set_highmem_pages_init()

Impact: cleanup

The zones are set up at this stage so there's a highmem zone available even for
the UMA case. The only difference there is that for machines that have
CONFIG_HIGHMEM enabled but don't have any highmem available, ->zone_start_pfn
is zero whereas highstart_pfn is non-zero). The field is left zeroed because of
the !size test in free_area_init_core() but shouldn't be a problem because
add_highpages_with_active_regions() handles empty ranges just fine.

Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 arch/x86/mm/highmem_32.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/arch/x86/mm/highmem_32.c b/arch/x86/mm/highmem_32.c
index 00f127c..d117453 100644
--- a/arch/x86/mm/highmem_32.c
+++ b/arch/x86/mm/highmem_32.c
@@ -158,7 +158,6 @@ EXPORT_SYMBOL(kunmap);
 EXPORT_SYMBOL(kmap_atomic);
 EXPORT_SYMBOL(kunmap_atomic);
 
-#ifdef CONFIG_NUMA
 void __init set_highmem_pages_init(void)
 {
 	struct zone *zone;
@@ -182,11 +181,3 @@ void __init set_highmem_pages_init(void)
 	}
 	totalram_pages += totalhigh_pages;
 }
-#else
-void __init set_highmem_pages_init(void)
-{
-	add_highpages_with_active_regions(0, highstart_pfn, highend_pfn);
-
-	totalram_pages += totalhigh_pages;
-}
-#endif /* CONFIG_NUMA */
-- 
1.5.4.3



