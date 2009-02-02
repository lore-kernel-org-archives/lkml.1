Return-Path: <linux-kernel-owner+w=401wt.eu-S1759554AbZBBVuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759554AbZBBVuz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 16:50:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758224AbZBBVup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 16:50:45 -0500
Received: from gir.skynet.ie ([193.1.99.77]:33344 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753754AbZBBVuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 16:50:44 -0500
Date: Mon, 2 Feb 2009 21:50:42 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Hugh Dickins <hugh@veritas.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, Greg KH <gregkh@suse.de>,
       Maksim Yevmenkin <maksim.yevmenkin@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, will@crowder-design.com,
       Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Mikos Szeredi <miklos@szeredi.hu>, Andy Whitcroft <apw@canonical.com>
Subject: Re: [PATCH] Fix OOPS in mmap_region() when merging adjacent
	VM_LOCKED file segments
Message-ID: <20090202215042.GD9840@csn.ul.ie>
References: <20090202205515.EC89.KOSAKI.MOTOHIRO@jp.fujitsu.com> <Pine.LNX.4.64.0902021215060.18750@blonde.anvils> <20090202224410.EC95.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20090202185810.GC9840@csn.ul.ie> <alpine.LFD.2.00.0902021121120.3247@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0902021121120.3247@localhost.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 02, 2009 at 11:23:33AM -0800, Linus Torvalds wrote:
> 
> 
> On Mon, 2 Feb 2009, Mel Gorman wrote:
> >
> > Do not account for address space usage when making hugetlbfs mappings RW
> > 
> > hugetlbfs accounts for its address space usage separate from the VM
> > core. VM_ACCOUNT should not be set for its mappings but it is possible it gets
> > set if a user creates a RO hugetlbfs mapping MAP_NORESERVE and then calls
> > mprotect(). This patch stops VM_ACCOUNT being set for hugetlbfs mappings
> > during mprotect().
> > 
> > Credit goes to Kosaki Motohiro for spotting this.
> > 
> > Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> > 
> > diff --git a/mm/mprotect.c b/mm/mprotect.c
> > index abe2694..31ddc6a 100644
> > --- a/mm/mprotect.c
> > +++ b/mm/mprotect.c
> > @@ -153,7 +153,7 @@ mprotect_fixup(struct vm_area_struct *vma, struct vm_area_struct **pprev,
> >  	 * but (without finer accounting) cannot reduce our commit if we
> >  	 * make it unwritable again.
> >  	 */
> > -	if (newflags & VM_WRITE) {
> > +	if (newflags & VM_WRITE && !(vma->vm_flags & VM_HUGETLB)) {
> 
> Wouldn't it be _much_ nicer to just depend on that whole VM_NORESERVE 
> thing?
> 

Yeah, it would but it's not a trivial change. mm/hugetlb.c depends on
VM_NORESERVE for its own accounting but also depends on VM_ACCOUNT not being
set because counters would get mucked up when the VMAs get unmapped.

The ideal answer would be to handle VM_ACCOUNT properly but it's not
clear-cut. If it's counted towards reserves, then we are double reserving -
the huge pages already allocated and base pages that will never be used. Then
again, maybe the right thing to do is update nr_accounted when VM_HUGETLB
is not set converting things like

               if (vma->vm_flags & VM_ACCOUNT)
                        *nr_accounted += (end - start) >> PAGE_SHIFT;

to

               if (vma->vm_flags & (VM_ACCOUNT | VM_HUGETLB) == VM_ACCOUNT)
                        *nr_accounted += (end - start) >> PAGE_SHIFT;

?

> Those hugetlb mappings _should_ have VM_NORESERVE on them, so the 
> following test:
> 
> >  		if (!(oldflags & (VM_ACCOUNT|VM_WRITE|
> >  						VM_SHARED|VM_NORESERVE))) {
> >  			charged = nrpages;
> 
> should do it all correctly.
> 

Lets say someone does the following

1. mmap(PROT_READ, MAP_PRIVATE) on a hugetlbfs file
	VM_ACCOUNT is not set for hugetlbfs
	VM_NORESERVE is not set because MAP_NORESERVE was not there
2. mprotect(PROT_WRITE)
	VM_ACCOUNT|VM_WRITE|VM_SHARE|VM_NORESERVE == 0
	That check is true
	newflags |= VM_ACCOUNT and hugetlbfs now has VM_ACCOUNT
3. unmap the vmas
	nr_accounted gets decremented, maybe wraps negative and
	unhappiness ensues

> Why make up some ad-hoc testing, when we already have a flag for _exactly_ 
> this issue. That's what VM_NORESERVE means: don't apply VM_ACCOUNT.
> 
> IOW, I don't see the point of this patch at all.
> 
> And if there is some hugetlb path that doesn't set VM_NORESERVE, then fix 
> _that_ instead.
> 

It gets set all right, the problem is with VM_ACCOUNT getting set.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
