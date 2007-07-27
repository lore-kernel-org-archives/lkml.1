Return-Path: <linux-kernel-owner+w=401wt.eu-S1764521AbXG0AXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764521AbXG0AXx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 20:23:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755706AbXG0AXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 20:23:47 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59460 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755370AbXG0AXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 20:23:46 -0400
Date: Thu, 26 Jul 2007 17:23:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Suleiman Souhlal <ssouhlal@FreeBSD.org>
Cc: linux-kernel@vger.kernel.org, Suleiman Souhlal <suleiman@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] Don't needlessly dirty mlocked pages when initially
 faulting them in.
Message-Id: <20070726172330.d3409b57.akpm@linux-foundation.org>
In-Reply-To: <11854939641916-git-send-email-ssouhlal@FreeBSD.org>
References: <11854939641916-git-send-email-ssouhlal@FreeBSD.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jul 2007 16:52:44 -0700 Suleiman Souhlal <ssouhlal@FreeBSD.org> wrote:

> make_pages_present() is dirtying mlocked pages if the VMA is writable, even
> though it shouldn't, by telling get_user_pages() to simulate a write fault.
> 
> A simple way to test this is to mlock a multi-GB file, and then sync.
> The sync will take a long time.

ugh, how bad of us.

> As far as I can see, it should be safe to just not simulate a write fault.

We pass in "write=1" to force a COW.  This is because we want to do all
that memory allocation at mlock()-time, not later on, when the app writes
to the page.

> Signed-off-by: Suleiman Souhlal <suleiman@google.com>
> ---
>  mm/memory.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index f64cbf9..f43c9e8 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2664,18 +2664,17 @@ #endif /* __PAGETABLE_PMD_FOLDED */
>  
>  int make_pages_present(unsigned long addr, unsigned long end)
>  {
> -	int ret, len, write;
> +	int ret, len;
>  	struct vm_area_struct * vma;
>  
>  	vma = find_vma(current->mm, addr);
>  	if (!vma)
>  		return -1;
> -	write = (vma->vm_flags & VM_WRITE) != 0;
>  	BUG_ON(addr >= end);
>  	BUG_ON(end > vma->vm_end);
>  	len = (end+PAGE_SIZE-1)/PAGE_SIZE-addr/PAGE_SIZE;
>  	ret = get_user_pages(current, current->mm, addr,
> -			len, write, 0, NULL, NULL);
> +			len, 0, 0, NULL, NULL);
>  	if (ret < 0)
>  		return ret;
>  	return ret == len ? 0 : -1;

So something sterner will need to be done.  I guess the write_access arg to
handle_mm_fault() would need to become a three-value thing.

