Return-Path: <linux-kernel-owner+w=401wt.eu-S1757344AbZBKQE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344AbZBKQE3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 11:04:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754886AbZBKQEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 11:04:20 -0500
Received: from adelie.canonical.com ([91.189.90.139]:35725 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254AbZBKQET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 11:04:19 -0500
Date: Wed, 11 Feb 2009 16:03:40 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Hugh Dickins <hugh@veritas.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, Greg KH <gregkh@suse.de>,
       Maksim Yevmenkin <maksim.yevmenkin@gmail.com>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, will@crowder-design.com,
       Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Mikos Szeredi <miklos@szeredi.hu>, wli@movementarian.org
Subject: Re: [PATCH] Do not account for the address space used by hugetlbfs
	using VM_ACCOUNT V2 (Was Linus 2.6.29-rc4)
Message-ID: <20090211160340.GH25898@shadowen.org>
References: <alpine.LFD.2.00.0902081251090.3048@localhost.localdomain> <20090210140227.GC4023@csn.ul.ie> <20090211094329.GE26746@shadowen.org> <20090211103000.GA2416@csn.ul.ie> <20090211120317.GB25898@shadowen.org> <20090211142004.GB25799@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090211142004.GB25799@csn.ul.ie>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 11, 2009 at 02:20:04PM +0000, Mel Gorman wrote:
> On Wed, Feb 11, 2009 at 12:03:17PM +0000, Andy Whitcroft wrote:
> > > <SNIP>
> > >
> > > Yes, and this was a mistake. For noreserve mappings, we may now be taking
> > > twice the amount of quota and probably leaking it. This is wrong and I need
> > > to move the check for quota below the check for VM_NORESERVE. Good spot.
> > 
> > Thanks.
> > 
> 
> How about this?
> 
> =====
> [PATCH] Do not account for hugetlbfs quota at mmap() time if mapping *_NORESERVE
> 
> Commit 5a6fe125950676015f5108fb71b2a67441755003 brought hugetlbfs more in line
> with the core VM by obeying VM_NORESERVE and not reserving hugepages for both
> shared and private mappings when [SHM|MAP]_NORESERVE are specified. However,
> it is still taking filesystem quota unconditionally and this leads to
> double-accounting.
> 
> At fault time, if there are no reserves and attempt is made to allocate the
> page and account for filesystem quota. If either fail, the fault fails. This
> patch prevents quota being taken when [SHM|MAP]_NORESERVE is specified.
> To help prevent this mistake happening again, it improves the documentation
> of hugetlb_reserve_pages().
> 
> Reported-by: Andy Whitcroft <apw@canonical.com>
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> --- 
>  hugetlb.c |   29 +++++++++++++++++++++++------
>  1 file changed, 23 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 2074642..b0b63cd 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -2289,24 +2289,41 @@ int hugetlb_reserve_pages(struct inode *inode,
>  	if (chg < 0)
>  		return chg;
>  
> -	if (hugetlb_get_quota(inode->i_mapping, chg))
> -		return -ENOSPC;
> -
>  	/*
> -	 * Only apply hugepage reservation if asked. We still have to
> -	 * take the filesystem quota because it is an upper limit
> -	 * defined for the mount and not necessarily memory as a whole
> +	 * Only apply hugepage reservation if asked. At fault time, an
> +	 * attempt will be made for VM_NORESERVE to allocate a page
> +	 * and filesystem quota without using reserves
>  	 */
>  	if (acctflag & VM_NORESERVE) {
>  		reset_vma_resv_huge_pages(vma);
>  		return 0;
>  	}
>  
> +	/* There must be enough filesystem quota for the mapping */
> +	if (hugetlb_get_quota(inode->i_mapping, chg))
> +		return -ENOSPC;
> +
> +	/*
> +	 * Check enough hugepages are available for the reservation.
> +	 * Hand back the quota if there are not
> +	 */
>  	ret = hugetlb_acct_memory(h, chg);
>  	if (ret < 0) {
>  		hugetlb_put_quota(inode->i_mapping, chg);
>  		return ret;
>  	}
> +
> +	/*
> +	 * Account for the reservations made. Shared mappings record regions
> +	 * that have reservations as they are shared by multiple VMAs.
> +	 * When the last VMA disappears, the region map says how much
> +	 * the reservation was and the page cache tells how much of

how much of the area had a reservation and the page cache ...

> +	 * the reservation was consumed. Private mappings are per-VMA and
> +	 * only the consumed reservations are tracked. When the VMA
> +	 * disappears, the original reservation is the VMA size and the
> +	 * consumed reservations are stored in the map. Here, we just need
> +	 * to allocate the region map.
> +	 */
>  	if (!vma || vma->vm_flags & VM_SHARED)
>  		region_add(&inode->i_mapping->private_list, from, to);
>  	else {

I am worried about the failure semantics here.  For shared mappings we
alloc any memory we need with region_chg(), then take quota, then apply
it and done.  For private mappings we take the quota and then allocate
any memory we need.  If that fails we do not return the quota?  Sounds
like a quota leak to me?

I think we do need to allocate the private map up when we do the
region_chg() for the shared case.  And I think neither of those is needed
for NORESERVE mappings?

-apw
