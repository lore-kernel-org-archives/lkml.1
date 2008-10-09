Return-Path: <linux-kernel-owner+w=401wt.eu-S1758759AbYJIKYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758759AbYJIKYu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 06:24:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756551AbYJIKYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 06:24:42 -0400
Received: from gir.skynet.ie ([193.1.99.77]:47618 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756529AbYJIKYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 06:24:41 -0400
Date: Thu, 9 Oct 2008 11:24:36 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
       dave@linux.vnet.ibm.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Report the pagesize backing a VMA in /proc/pid/smaps
Message-ID: <20081009102436.GD24962@csn.ul.ie>
References: <1223052415-18956-1-git-send-email-mel@csn.ul.ie> <1223052415-18956-2-git-send-email-mel@csn.ul.ie> <20081008213831.GA23729@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20081008213831.GA23729@x200.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (09/10/08 01:38), Alexey Dobriyan didst pronounce:
> On Fri, Oct 03, 2008 at 05:46:54PM +0100, Mel Gorman wrote:
> > It is useful to verify a hugepage-aware application is using the expected
> > pagesizes for its memory regions. This patch creates an entry called
> > KernelPageSize in /proc/pid/smaps that is the size of page used by the
> > kernel to back a VMA. The entry is not called PageSize as it is possible
> > the MMU uses a different size. This extension should not break any sensible
> > parser that skips lines containing unrecognised information.
> 
> > +		   "KernelPageSize: %8lu kB\n",
> 
> > +unsigned long vma_kernel_pagesize(struct vm_area_struct *vma)
> > +{
> > +	struct hstate *hstate;
> > +
> > +	if (!is_vm_hugetlb_page(vma))
> > +		return PAGE_SIZE;
> > +
> > +	hstate = hstate_vma(vma);
> > +	VM_BUG_ON(!hstate);
> > +
> > +	return 1UL << (hstate->order + PAGE_SHIFT);
> 			    ^^^^
> VM_BUG_ON is unneeded because kernel will oops here if hstate is NULL.
> 

Ok, will drop it. I used the VM_BUG_ON so if the situation was triggered,
it would come with line numbers but it'll be an obvious oops so I guess it
is redundant.

> Also, in /proc/*/maps it's printed only for hugetlb vmas and called
> hpagesize,

Well yes... because it's a huge pagesize for that VMA. The name reflects
what is being described there.

> in smaps it's printed for every vma and called
> KernelPageSize. All of this is inconsistent.
> 

In smaps, we are printing for every VMA because it's easier for parsers to
deal with the presense of information than its absense. The name KernelPageSize
there is an accurate description.

I don't feel it is inconsistent.

> And app will verify once that hugepages are of right size, so Pss cost
> argument for changing /proc/*/maps seems weak to me.
> 

Lets say someone wanted to monitor an application to see what its use of
hugepages were over time, they would have to constantly incur the PSS
cost to do that which seems a bit unfair.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
