Return-Path: <linux-kernel-owner+w=401wt.eu-S1767249AbXDTU5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767249AbXDTU5n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 16:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767259AbXDTU5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 16:57:43 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38036 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767249AbXDTU5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 16:57:42 -0400
Date: Fri, 20 Apr 2007 13:57:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH] lazy freeing of memory through MADV_FREE
Message-Id: <20070420135715.f6e8e091.akpm@linux-foundation.org>
In-Reply-To: <46247427.6000902@redhat.com>
References: <46247427.6000902@redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Apr 2007 03:15:51 -0400
Rik van Riel <riel@redhat.com> wrote:

> Make it possible for applications to have the kernel free memory
> lazily.  This reduces a repeated free/malloc cycle from freeing
> pages and allocating them, to just marking them freeable.  If the
> application wants to reuse them before the kernel needs the memory,
> not even a page fault will happen.
> 
> This patch, together with Ulrich's glibc change, increases
> MySQL sysbench performance by a factor of 2 on my quad core
> test system.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
> 
> ---
> Ulrich Drepper has test glibc RPMS for this functionality at:
> 
>      http://people.redhat.com/drepper/rpms
> 
> Andrew, I have stress tested this patch for a few days now and
> have not been able to find any more bugs.  I believe it is ready
> to be merged in -mm, and upstream at the next merge window.
> 
> When the patch goes upstream, I will submit a small follow-up
> patch to revert MADV_DONTNEED behaviour to what it did previously
> and have the new behaviour trigger only on MADV_FREE: at that
> point people will have to get new test RPMs of glibc.
> 
> 

I've also merged Nick's "mm: madvise avoid exclusive mmap_sem".

- Nick's patch also will help this problem.  It could be that your patch
  no longer offers a 2x speedup when combined with Nick's patch.

  It could well be that the combination of the two is even better, but it
  would be nice to firm that up a bit.  Chewing a page flag is an expensive
  thing to do.

  I do go on about that.  But we're adding page flags at about one per
  year, and when we run out we're screwed - we'll need to grow the
  pageframe.

- I need to update your patch for Nick's patch.  Please confirm that
  down_read(mmap_sem) is sufficient for MADV_FREE.


Stylistic nit:

> +	if (PageLazyFree(page) && !migration) {
> +		/* There is new data in the page.  Reinstate it. */
> +		if (unlikely(pte_dirty(pteval))) {
> +			set_pte_at(mm, address, pte, pteval);
> +			ret = SWAP_FAIL;
> +			goto out_unmap;
> +		}

The comment should be inside the second `if' statement.  As it is, It
looks like we reinstate the page if (PageLazyFree(page) && !migration).

