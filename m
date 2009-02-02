Return-Path: <linux-kernel-owner+w=401wt.eu-S1755229AbZBBTZP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229AbZBBTZP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 14:25:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752900AbZBBTZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 14:25:00 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43654 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752673AbZBBTZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 14:25:00 -0500
Date: Mon, 2 Feb 2009 11:23:33 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Mel Gorman <mel@csn.ul.ie>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Hugh Dickins <hugh@veritas.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, Greg KH <gregkh@suse.de>,
       Maksim Yevmenkin <maksim.yevmenkin@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, will@crowder-design.com,
       Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Mikos Szeredi <miklos@szeredi.hu>, Andy Whitcroft <apw@canonical.com>
Subject: Re: [PATCH] Fix OOPS in mmap_region() when merging adjacent VM_LOCKED
 file segments
In-Reply-To: <20090202185810.GC9840@csn.ul.ie>
Message-ID: <alpine.LFD.2.00.0902021121120.3247@localhost.localdomain>
References: <20090202205515.EC89.KOSAKI.MOTOHIRO@jp.fujitsu.com> <Pine.LNX.4.64.0902021215060.18750@blonde.anvils> <20090202224410.EC95.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20090202185810.GC9840@csn.ul.ie>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 2 Feb 2009, Mel Gorman wrote:
>
> Do not account for address space usage when making hugetlbfs mappings RW
> 
> hugetlbfs accounts for its address space usage separate from the VM
> core. VM_ACCOUNT should not be set for its mappings but it is possible it gets
> set if a user creates a RO hugetlbfs mapping MAP_NORESERVE and then calls
> mprotect(). This patch stops VM_ACCOUNT being set for hugetlbfs mappings
> during mprotect().
> 
> Credit goes to Kosaki Motohiro for spotting this.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> 
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index abe2694..31ddc6a 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -153,7 +153,7 @@ mprotect_fixup(struct vm_area_struct *vma, struct vm_area_struct **pprev,
>  	 * but (without finer accounting) cannot reduce our commit if we
>  	 * make it unwritable again.
>  	 */
> -	if (newflags & VM_WRITE) {
> +	if (newflags & VM_WRITE && !(vma->vm_flags & VM_HUGETLB)) {

Wouldn't it be _much_ nicer to just depend on that whole VM_NORESERVE 
thing?

Those hugetlb mappings _should_ have VM_NORESERVE on them, so the 
following test:

>  		if (!(oldflags & (VM_ACCOUNT|VM_WRITE|
>  						VM_SHARED|VM_NORESERVE))) {
>  			charged = nrpages;

should do it all correctly.

Why make up some ad-hoc testing, when we already have a flag for _exactly_ 
this issue. That's what VM_NORESERVE means: don't apply VM_ACCOUNT.

IOW, I don't see the point of this patch at all.

And if there is some hugetlb path that doesn't set VM_NORESERVE, then fix 
_that_ instead.

			Linus
