Return-Path: <linux-kernel-owner+w=401wt.eu-S934244AbXK2XbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934244AbXK2XbQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 18:31:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932841AbXK2XbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 18:31:00 -0500
Received: from mx2.suse.de ([195.135.220.15]:37867 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932747AbXK2Xa7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 18:30:59 -0500
Date: Fri, 30 Nov 2007 00:30:58 +0100
From: Nick Piggin <npiggin@suse.de>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Hugh Dickins <hugh@veritas.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: remap_file_pages() broken in 2.6.23?
Message-ID: <20071129233058.GA10359@wotan.suse.de>
References: <474F16D3.5060009@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <474F16D3.5060009@redhat.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2007 at 02:45:23PM -0500, Chuck Ebbert wrote:
> Original report: https://bugzilla.redhat.com/show_bug.cgi?id=404201
> 
> The test case below, taken from the LTP test code, prints -1 (as
> expected) on 2.6.22 and 0 on 2.6.23. It tries to remap an out-of-range
> page. Proposed patch follows the program. Bug was apparently caused by
> commit 54cb8821de07f2ffcd28c380ce9b93d5784b40d7.

Ah, that's not such good behaviour anyway. mmap is allowed to map
outside the file offset, so you're telling me that remap_file_pages
just magically should not be allowed to remap these...?
 

> Patch:
> 
> Signed-off-by: Supriya Kannery <supriyak@in.ibm.com>
> 
> --- linux-2.6.23/mm/fremap.c.orig	2007-11-22 00:56:09.000000000 -0600
> +++ linux-2.6.23/mm/fremap.c	2007-11-26 03:08:55.000000000 -0600
> @@ -124,6 +124,7 @@ asmlinkage long sys_remap_file_pages(uns
>  	struct vm_area_struct *vma;
>  	int err = -EINVAL;
>  	int has_write_lock = 0;
> +	unsigned long f_size = 0;
>  
>  	if (__prot)
>  		return err;
> @@ -181,6 +182,14 @@ asmlinkage long sys_remap_file_pages(uns
>  			goto retry;
>  		}
>  		mapping = vma->vm_file->f_mapping;
> +
> +		f_size = i_size_read(mapping->host) + PAGE_CACHE_SIZE - 1;
> +		f_size = f_size >> PAGE_CACHE_SHIFT;
> +		if ((pgoff + size >> PAGE_CACHE_SHIFT) > f_size) {
> +			err = -EINVAL;
> +			goto out;
> +		}
> +
>  		/*
>  		 * page_mkclean doesn't work on nonlinear vmas, so if
>  		 * dirty pages need to be accounted, emulate with linear


I don't think there is anything preventing truncate races here. Theoretically
we could do it by taking i_mutex around here, but anyway then a subsequent
truncate is just going to be able to cause the mapping to be out of bounds
anyway.

If it were any other syscall than remap_file_pages, I'd be much more
hesitant to say this: I propose we change the test case instead. I
also changed other elements of the API, and we had the result tested
and verified by Oracle...

