Return-Path: <linux-kernel-owner+w=401wt.eu-S1754498AbYCJRoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498AbYCJRoQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 13:44:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751346AbYCJRoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 13:44:01 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:50423 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbYCJRoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 13:44:00 -0400
Date: Mon, 10 Mar 2008 17:40:52 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Will Newton <will.newton@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: copy_page_range() with VM_LOCKED
In-Reply-To: <87a5b0800803100926t1e4a1bb3t905d02d4c311d5e@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0803101728470.3398@blonde.site>
References: <87a5b0800803100926t1e4a1bb3t905d02d4c311d5e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Mar 2008, Will Newton wrote:
> 
> In order to optimize fork performance copy_page_range avoids copying
> page tables under certain circumstances:
> 
>         if (!(vma->vm_flags &
> (VM_HUGETLB|VM_NONLINEAR|VM_PFNMAP|VM_INSERTPAGE))) {
>                 if (!vma->anon_vma)
>                         return 0;
>         }
> 
> I have a VM_LOCKED vma that I would really, really like not to fault
> on, but because copy_page_range does not copy the page tables of the
> vma I do end up faulting in my VM_LOCKED vma.

Faulting on the child's (non-)copy of the parent's VM_LOCKED vma.
Yes, but did you realize that VM_LOCKED is cleared from the child's
vma (the "vma" in that code sample above happens to be the parent's)?
Though an area is locked in the parent, that's not carried over to the
child.

> Now as far as I'm aware
> mmap with MAP_LOCKED only promises the page will not be paged out, not
> that the page will never fault but I would like to get that behaviour.
> 
> Would it be possible to add VM_LOCKED to the above conditional so
> copy_page_range would always copy VM_LOCKED vma page tables or would
> that be considered insane and broken?

It would be possible, but I don't think it would be justified - for
everybody who wants your behaviour, there'll be others who want the
current behaviour (and that condition reflects those cases on which
correctness demands we do the copy).

If you really want that, I think you'll have to patch your own kernel.

But much much better, mlock that area in your child after the fork,
since it isn't actually locked at present: that mlock will bring in
the pages - not quite as efficiently as copy_page_range would have done,
but as or more efficiently than the original mlock in the parent.

Hugh
