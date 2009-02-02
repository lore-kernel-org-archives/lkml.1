Return-Path: <linux-kernel-owner+w=401wt.eu-S1758869AbZBBWfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758869AbZBBWfi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 17:35:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753431AbZBBWf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 17:35:29 -0500
Received: from gir.skynet.ie ([193.1.99.77]:39577 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752919AbZBBWf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 17:35:28 -0500
Date: Mon, 2 Feb 2009 22:35:26 +0000
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
Message-ID: <20090202223526.GE9840@csn.ul.ie>
References: <20090202205515.EC89.KOSAKI.MOTOHIRO@jp.fujitsu.com> <Pine.LNX.4.64.0902021215060.18750@blonde.anvils> <20090202224410.EC95.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20090202185810.GC9840@csn.ul.ie> <alpine.LFD.2.00.0902021121120.3247@localhost.localdomain> <20090202215042.GD9840@csn.ul.ie> <alpine.LFD.2.00.0902021410460.3247@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0902021410460.3247@localhost.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 02, 2009 at 02:12:30PM -0800, Linus Torvalds wrote:
> 
> 
> On Mon, 2 Feb 2009, Mel Gorman wrote:
> > 
> > Lets say someone does the following
> > 
> > 1. mmap(PROT_READ, MAP_PRIVATE) on a hugetlbfs file
> > 	VM_ACCOUNT is not set for hugetlbfs
> > 	VM_NORESERVE is not set because MAP_NORESERVE was not there
> 
> But isn't this exactly the thing that we have that odd "accountable" flag 
> for, and we do the whole
> 
> 	if (!accountable)
> 		vm_flags |= VM_NORESERVE;
> 
> in mmap_region() for?
> 
> So VM_NORESERVE _will_ be set.
> 

Then it's getting unconditionally set which breaks the hugetlb accounting
for reserving hugepages. See mm/hugetlb.c#decrement_hugepage_resv_vma() and
mm/hugetlb.c#hugetlb_reserve_pages() which depend on VM_NORESERVE being set
or not set depending on MAP_NORESERVE, not whether the core VM is accounting
it or not.

This is why I tried replacing 

 	if (!accountable)
 		vm_flags |= VM_NORESERVE;

with

        if ((flags & MAP_NORESERVE) && should_overcommit(file))
                vm_flags |= VM_NORESERVE;

and

static inline int should_overcommit(struct file *file)
{
        /* Check if the sysctl allows overcommit */
        if (sysctl_overcommit_memory != OVERCOMMIT_NEVER)
                return 1;

        /* hugetlbfs does its own accounting */
        if (file && is_file_hugepages(file))
                return 1;

        return 0;
}

in the first patch I mailed out.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
