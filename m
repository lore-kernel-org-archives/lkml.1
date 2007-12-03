Return-Path: <linux-kernel-owner+w=401wt.eu-S1752028AbXLCXEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028AbXLCXEh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 18:04:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751372AbXLCXE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 18:04:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55810 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751362AbXLCXE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 18:04:28 -0500
Date: Tue, 4 Dec 2007 00:04:22 +0100
From: Nick Piggin <npiggin@suse.de>
To: Supriya Kannery <supriyak@in.ibm.com>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Hugh Dickins <hugh@veritas.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: remap_file_pages() broken in 2.6.23?
Message-ID: <20071203230422.GA23556@wotan.suse.de>
References: <474F16D3.5060009@redhat.com> <20071129233058.GA10359@wotan.suse.de> <4753F72C.6060202@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4753F72C.6060202@in.ibm.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2007 at 06:01:40PM +0530, Supriya Kannery wrote:
> Nick Piggin wrote:
> >On Thu, Nov 29, 2007 at 02:45:23PM -0500, Chuck Ebbert wrote:
> >  
> >>Original report: https://bugzilla.redhat.com/show_bug.cgi?id=404201
> >>
> >>The test case below, taken from the LTP test code, prints -1 (as
> >>expected) on 2.6.22 and 0 on 2.6.23. It tries to remap an out-of-range
> >>page. Proposed patch follows the program. Bug was apparently caused by
> >>commit 54cb8821de07f2ffcd28c380ce9b93d5784b40d7.
> >>    
> >
> >Ah, that's not such good behaviour anyway. mmap is allowed to map
> >outside the file offset, so you're telling me that remap_file_pages
> >just magically should not be allowed to remap these...?
> >
> >  
> Validation check for pgoff was there in populate() in earlier 
> kernels.When populate() got removed and populate_range() was added, 
> during the specified commit, validation for pgoff also got removed. This 
> symantic would break existing apps that expects an error from 
> remap_file_pages when a large value for pgoff is given. Though the 
> change is error handling related, it breaks ABI from previous kernel 
> versions.

But only Oracle uses it AFAIK, and they don't require this behaviour.

 
> For validation, we check whether the pgoff + size exceeds the file size, 
> all in page units. And while calculating file size in page units, one 
> additional page unit is taken into account to get the exact number of 
> pages that contain the file size in bytes.
> f_size = i_size_read(mapping->host) + PAGE_CACHE_SIZE - 1;
> <---- file size in bytes -------> <--- helps in rounding to next page 
> unit -->
> 
> mmap() will be mapping the minimum number of pages that can contain a 
> file. So offset cannot be a large value compared to file size. mmap() is 
> also supposed to return EINVAL when the offset is a large/invalid value 
> as man page mandates.

I don't think it is required that mmap must fail if it maps past i_size.
I don't think Linux fails in this case.


> >  
> >>Patch:
> >>
> >>Signed-off-by: Supriya Kannery <supriyak@in.ibm.com>
> >>
> >>--- linux-2.6.23/mm/fremap.c.orig	2007-11-22 00:56:09.000000000 -0600
> >>+++ linux-2.6.23/mm/fremap.c	2007-11-26 03:08:55.000000000 -0600
> >>@@ -124,6 +124,7 @@ asmlinkage long sys_remap_file_pages(uns
> >> 	struct vm_area_struct *vma;
> >> 	int err = -EINVAL;
> >> 	int has_write_lock = 0;
> >>+	unsigned long f_size = 0;
> >> 
> >> 	if (__prot)
> >> 		return err;
> >>@@ -181,6 +182,14 @@ asmlinkage long sys_remap_file_pages(uns
> >> 			goto retry;
> >> 		}
> >> 		mapping = vma->vm_file->f_mapping;
> >>+
> >>+		f_size = i_size_read(mapping->host) + PAGE_CACHE_SIZE - 1;
> >>+		f_size = f_size >> PAGE_CACHE_SHIFT;
> >>+		if ((pgoff + size >> PAGE_CACHE_SHIFT) > f_size) {
> >>+			err = -EINVAL;
> >>+			goto out;
> >>+		}
> >>+
> >> 		/*
> >> 		 * page_mkclean doesn't work on nonlinear vmas, so if
> >> 		 * dirty pages need to be accounted, emulate with linear
> >>    
> >
> >
> >I don't think there is anything preventing truncate races here. 
> >Theoretically
> >we could do it by taking i_mutex around here, but anyway then a subsequent
> >truncate is just going to be able to cause the mapping to be out of bounds
> >anyway.
> >
> >  
> i_size_read() is taking care of syncing between the writes/truncations 
> in SMP/ pre-emtable kernel. For SMP, it specifically takes care to get 
> the value again if any changes happen to the source.

And then right afterwards, the file gets truncated, and you hav eremapped
past i_size. So what's the point of preventing it? We have SIGBUS for
that.

Thanks,
Nick
