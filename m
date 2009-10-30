Return-Path: <linux-kernel-owner+w=401wt.eu-S932923AbZJ3VX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932923AbZJ3VX1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 17:23:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932901AbZJ3VX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 17:23:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50110 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932886AbZJ3VXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 17:23:25 -0400
Date: Fri, 30 Oct 2009 14:22:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Robin Getz <rgetz@blackfin.uclinux.org>, stable@kernel.org
Subject: Re: [PATCH] NOMMU: Don't pass NULL pointers to fput() in
 do_mmap_pgoff()
Message-Id: <20091030142201.29a492e9.akpm@linux-foundation.org>
In-Reply-To: <20091030131326.5891.68842.stgit@warthog.procyon.org.uk>
References: <20091030131326.5891.68842.stgit@warthog.procyon.org.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Oct 2009 13:13:26 +0000
David Howells <dhowells@redhat.com> wrote:

> Don't pass NULL pointers to fput() in the error handling paths of the NOMMU
> do_mmap_pgoff() as it can't handle it.
> 
> The following can be used as a test program:
> 
> 	int main() { static long long a[1024 * 1024 * 20] = { 0 }; return a;}
> 
> Without the patch, the code oopses in atomic_long_dec_and_test() as called by
> fput() after the kernel complains that it can't allocate that big a chunk of
> memory.  With the patch, the kernel just complains about the allocation size
> and then the program segfaults during execve() as execve() can't complete the
> allocation of all the new ELF program segments.
> 
> Reported-by: Robin Getz <rgetz@blackfin.uclinux.org>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Acked-by: Robin Getz <rgetz@blackfin.uclinux.org>
> ---
> 
>  mm/nommu.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/mm/nommu.c b/mm/nommu.c
> index cfea46c..969392c 100644
> --- a/mm/nommu.c
> +++ b/mm/nommu.c
> @@ -1364,9 +1364,11 @@ share:
>  error_just_free:
>  	up_write(&nommu_region_sem);
>  error:
> -	fput(region->vm_file);
> +	if (region->vm_file)
> +		fput(region->vm_file);
>  	kmem_cache_free(vm_region_jar, region);
> -	fput(vma->vm_file);
> +	if (vma->vm_file)
> +		fput(vma->vm_file);
>  	if (vma->vm_flags & VM_EXECUTABLE)
>  		removed_exe_file_vma(vma->vm_mm);
>  	kmem_cache_free(vm_area_cachep, vma);

Seems like a pretty obvious -stable candidate, but no stable tag in the
changelog?

Assuming this is needed in -stable, do we know how far back in time the
bug exists?

