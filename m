Return-Path: <linux-kernel-owner+w=401wt.eu-S1759381AbXJaPTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759381AbXJaPTo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 11:19:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756526AbXJaPTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 11:19:36 -0400
Received: from mx1.suse.de ([195.135.220.2]:49850 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756060AbXJaPTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 11:19:36 -0400
Date: Wed, 31 Oct 2007 16:19:34 +0100
From: Nick Piggin <npiggin@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Duane Griffin <duaneg@dghda.com>,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org
Subject: Re: 2.6.23 regression: accessing invalid mmap'ed memory from gdb causes unkillable spinning
Message-ID: <20071031151934.GA19211@wotan.suse.de>
References: <e9e943910710301745u429b14fj6c5a66fcbf6b0efa@mail.gmail.com> <20071031041932.GA12189@wotan.suse.de> <alpine.LFD.0.999.0710310756220.30120@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0710310756220.30120@woody.linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2007 at 08:11:10AM -0700, Linus Torvalds wrote:
> 
> 
> On Wed, 31 Oct 2007, Nick Piggin wrote:
> > 
> > However I actually don't really like how this all works. I don't like that
> > filemap.c should have to know about ptrace, or exactly what ptrace wants here.
> 
> It shouldn't. It should just fail when it fails. Then, handle_mm_fault() 
> should return an error code, which should cause get_user_pages() to return 
> an error code. Which should make ptrace just stop.
> 
> So I think your patch is wrong. mm/filemap.c should *not* care about who 
> does the fault.  I think the proper patch is something untested like the 
> appended...

Well the patch is right, in the context of the regression I introduced
(and so it should probably go into 2.6.23).

I'd love to get rid of that outside data content crap if possible in
2.6.24. I think you're the one who has the best feeling for the ptrace
cases we have in the VM, so I trust you ;)


> > It's a bit hairy to force insert page into pagecache and pte into pagetables
> > here, given the races.
> 
> It's also wrong. They shouldn't be in the page cache, since that can cause 
> problems with truncate etc. Maybe it doesn't any more, but it's reasonable 
> to believe that a page outside of i_size should not exist.

No I believe it could still be a problem (and at least, it is quite
fragile).

 
> > In access_process_vm, can't we just zero fill in the case of a sigbus? Linus?
> > That will also avoid changing applicatoin behaviour due to a gdb read...
> 
> access_process_vm() should just return how many bytes it could fill (which 
> means a truncated copy - very including zero bytes - for an error), and 
> the caller should decide what the right thing to do is.
> 
> But who knows, maybe I missed something.

I hope it works.
 

> Duane? Does this fix things for you?
> 
> 			Linus
> 
> ---
>  mm/filemap.c |   13 ++-----------
>  1 files changed, 2 insertions(+), 11 deletions(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 9940895..188cf5f 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1300,7 +1300,7 @@ int filemap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
>  
>  	size = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
>  	if (vmf->pgoff >= size)
> -		goto outside_data_content;
> +		return VM_FAULT_SIGBUS;
>  
>  	/* If we don't want any read-ahead, don't bother */
>  	if (VM_RandomReadHint(vma))
> @@ -1377,7 +1377,7 @@ retry_find:
>  	if (unlikely(vmf->pgoff >= size)) {
>  		unlock_page(page);
>  		page_cache_release(page);
> -		goto outside_data_content;
> +		return VM_FAULT_SIGBUS;
>  	}
>  
>  	/*
> @@ -1388,15 +1388,6 @@ retry_find:
>  	vmf->page = page;
>  	return ret | VM_FAULT_LOCKED;
>  
> -outside_data_content:
> -	/*
> -	 * An external ptracer can access pages that normally aren't
> -	 * accessible..
> -	 */
> -	if (vma->vm_mm == current->mm)
> -		return VM_FAULT_SIGBUS;
> -
> -	/* Fall through to the non-read-ahead case */
>  no_cached_page:
>  	/*
>  	 * We're only likely to ever get here if MADV_RANDOM is in
