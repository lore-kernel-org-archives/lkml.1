Return-Path: <linux-kernel-owner+w=401wt.eu-S1762151AbYBEWSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762151AbYBEWSY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 17:18:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756254AbYBEWSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 17:18:16 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:50927 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbYBEWSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 17:18:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Os+TqH5RdgTq1s9TNnAiXk21TXnJwQBY9WMxfKqTuvnP9rUtCeAFh+NFt2WtBdws8wcgqeWHiZvhZZnoE7fkM01QMwE3giOUie0wiJrGmt0JS/82eGxql64ovJfAT4o5JPySD3hXm0YVnZ9RJoxox7k+D3AE04OCs4C9lbC6Wcs=
Message-ID: <6101e8c40802051418q6a86db0fx1327597fcaf0cb88@mail.gmail.com>
Date: Tue, 5 Feb 2008 23:18:11 +0100
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [stable] OOM-killer invoked but why ?
Cc: "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>, stable@kernel.org,
       linux-kernel@vger.kernel.org, r31dmaeu@pc0312b.rz.unibw-muenchen.de,
       "Christoph Lameter" <clameter@sgi.com>
In-Reply-To: <20080205220445.GA6889@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47A1C4B1.8020607@pc0312a.rz.unibw-muenchen.de>
	 <20080205020737.cec97816.akpm@linux-foundation.org>
	 <20080205110303.GA8288@linux.vnet.ibm.com>
	 <20080205220445.GA6889@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

that are, not this version ..

this is the BAD:
----8<----
 From stable-bounces@linux.kernel.org Mon Dec 17 16:32:25 2007
   2 From: Christoph Lameter <clameter@sgi.com>
   3 Date: Mon, 17 Dec 2007 16:20:27 -0800
   4 Subject: quicklist: Set tlb->need_flush if pages are remaining in
quicklist 0
   5 To: torvalds@linux-foundation.org
   6 Cc: stable@kernel.org, akpm@linux-foundation.org,
dhaval@linux.vnet.ibm.com, clameter@sgi.com
   7 Message-ID: <200712180020.lBI0KSKF010011@imap1.linux-foundation.org>
   8
   9
  10 From: Christoph Lameter <clameter@sgi.com>
  11
  12 patch 421d99193537a6522aac2148286f08792167d5fd in mainline.
  13
  14 This ensures that the quicklists are drained. Otherwise draining may only
  15 occur when the processor reaches an idle state.
  16
  17 Fixes fatal leakage of pgd_t's on 2.6.22 and later.
  18
  19 Signed-off-by: Christoph Lameter <clameter@sgi.com>
  20 Reported-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
  21 Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
  22 Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
  23 Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
  24
  25
  26 ---
  27  include/asm-generic/tlb.h |    4 ++++
  28  1 file changed, 4 insertions(+)
  29
  30 --- a/include/asm-generic/tlb.h
  31 +++ b/include/asm-generic/tlb.h
  32 @@ -14,6 +14,7 @@
  33  #define _ASM_GENERIC__TLB_H
  34
  35  #include <linux/swap.h>
  36 +#include <linux/quicklist.h>
  37  #include <asm/pgalloc.h>
  38  #include <asm/tlbflush.h>
  39
  40 @@ -85,6 +86,9 @@ tlb_flush_mmu(struct mmu_gather *tlb, un
  41  static inline void
  42  tlb_finish_mmu(struct mmu_gather *tlb, unsigned long start,
unsigned long end)
  43  {
  44 +#ifdef CONFIG_QUICKLIST
  45 +       tlb->need_flush += &__get_cpu_var(quicklist)[0].nr_pages != 0;
  46 +#endif
  47         tlb_flush_mmu(tlb, start, end);
  48
  49         /* keep the page table cache within bounds
----8<----

On 2/5/08, Greg KH <greg@kroah.com> wrote:
> On Tue, Feb 05, 2008 at 04:33:03PM +0530, Dhaval Giani wrote:
> > On Tue, Feb 05, 2008 at 02:07:37AM -0800, Andrew Morton wrote:
> > > On Thu, 31 Jan 2008 13:53:05 +0100 Claude Frantz
> <r31dmaeu@pc0312b.rz.unibw-muenchen.de> wrote:
> > >
> > > > Hello !
> > > >
> > > > I'm faced to a problem where the OOM-killer is invoked but I cannot
> find
> > > > the reason why. The machine is rather powerfull, the load is very
> moderate,
> > > > the disk swap space is nearly unused. The only strange observation
> which
> > > > appears to me is the slow but progressive decreasing of kbbuffers
> during
> > > > many hours.
> > > >
> > > > Can you help me to diagnose the problem and to find a good solution ?
> > > >
> > > > ...
> > > >
> > > > Jan 28 03:50:49 toaster kernel: 177466 pages slab
> > > > Jan 28 03:50:49 toaster kernel: 1915 pages pagetables
> > > > Jan 28 03:50:49 toaster kernel: Out of memory: kill process 10859
> (amavisd) score 36218 or a child
> > > > Jan 28 03:50:49 toaster kernel: Killed process 19146 (amavisd)
> > >
> > > slab.  Maybe you've been bitten by the quicklist leak.  If you're able
> to
> > > patch your kernel then please try this fix:
> > >
> > > commit 96990a4ae979df9e235d01097d6175759331e88c
> > > Author: Christoph Lameter <clameter@sgi.com>
> > > Date:   Mon Jan 14 00:55:14 2008 -0800
> > >
> > >     quicklists: Only consider memory that can be used with GFP_KERNEL
> > >
> > >     Quicklists calculates the size of the quicklists based on the number
> of
> > >     free pages.  This must be the number of free pages that can be
> allocated
> > >     with GFP_KERNEL.  node_page_state() includes the pages in
> ZONE_HIGHMEM and
> > >     ZONE_MOVABLE which may lead the quicklists to become too large
> causing OOM.
> > >
> > >     Signed-off-by: Christoph Lameter <clameter@sgi.com>
> > >     Tested-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
> > >     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > >     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > >
> > > diff --git a/mm/quicklist.c b/mm/quicklist.c
> > > index ae8189c..3f703f7 100644
> > > --- a/mm/quicklist.c
> > > +++ b/mm/quicklist.c
> > > @@ -26,9 +26,17 @@ DEFINE_PER_CPU(struct quicklist,
> quicklist)[CONFIG_NR_QUICK];
> > >  static unsigned long max_pages(unsigned long min_pages)
> > >  {
> > >  	unsigned long node_free_pages, max;
> > > +	struct zone *zones = NODE_DATA(numa_node_id())->node_zones;
> > > +
> > > +	node_free_pages =
> > > +#ifdef CONFIG_ZONE_DMA
> > > +		zone_page_state(&zones[ZONE_DMA], NR_FREE_PAGES) +
> > > +#endif
> > > +#ifdef CONFIG_ZONE_DMA32
> > > +		zone_page_state(&zones[ZONE_DMA32], NR_FREE_PAGES) +
> > > +#endif
> > > +		zone_page_state(&zones[ZONE_NORMAL], NR_FREE_PAGES);
> > >
> > > -	node_free_pages = node_page_state(numa_node_id(),
> > > -			NR_FREE_PAGES);
> > >  	max = node_free_pages / FRACTION_OF_NODE_MEM;
> > >  	return max(max, min_pages);
> > >  }
> > >
> > >
> > > I note that this didn't have the stable@kernel.org cc.  Christoph, did
> we
> > > deliberately decide not to backport?
> > >
> >
> > According to
> > http://archive.netbsd.se/?ml=linux-stable-commits&a=2008-01&m=6134301 ,
> > its been added to the stable tree. I remember asking Greg to add it.
>
> And then Christoph told me to remove it...
>
> thanks,
>
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
Thanks,
Oliver
