Return-Path: <linux-kernel-owner+w=401wt.eu-S1756204AbZLOAl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204AbZLOAl5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 19:41:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753514AbZLOAl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 19:41:57 -0500
Received: from mail2.shareable.org ([80.68.89.115]:46575 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbZLOAl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 19:41:56 -0500
Date: Tue, 15 Dec 2009 00:41:43 +0000
From: Jamie Lokier <jamie@shareable.org>
To: uClinux development list <uclinux-dev@uclinux.org>
Cc: vapier.adi@gmail.com, lethal@linux-sh.org, jie.zhang@analog.com,
       stefani@seibold.net, gerg@snapgear.com, linux-kernel@vger.kernel.org
Subject: Re: [uClinux-dev] [PATCH 5/7] NOMMU: Avoiding duplicate icache flushes of shared maps
Message-ID: <20091215004143.GA15785@shareable.org>
References: <20091210135755.6325.78149.stgit@warthog.procyon.org.uk> <20091210135816.6325.37536.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091210135816.6325.37536.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
> From: Mike Frysinger <vapier.adi@gmail.com>
> 
> When working with FDPIC, there are many shared mappings of read-only code
> regions between applications (the C library, applet packages like busybox,
> etc.), but the current do_mmap_pgoff() function will issue an icache flush
> whenever a VMA is added to an MM instead of only doing it when the map is
> initially created.
> 
> @@ -1354,10 +1355,14 @@ unsigned long do_mmap_pgoff(struct file *file,
>  share:
>  	add_vma_to_mm(current->mm, vma);
>  
> -	up_write(&nommu_region_sem);
> +	/* we flush the region from the icache only when the first executable
> +	 * mapping of it is made  */
> +	if (vma->vm_flags & VM_EXEC && !region->vm_icache_flushed) {
> +		flush_icache_range(region->vm_start, region->vm_end);
> +		region->vm_icache_flushed = true;
> +	}
>  
> -	if (prot & PROT_EXEC)
> -		flush_icache_range(result, result + len);
> +	up_write(&nommu_region_sem);
>  
>  	kleave(" = %lx", result);
>  	return result;

This looks like it won't work in the following sequence:

    process A maps MAP_SHARED, PROT_READ|PROT_EXEC (flushes icache)
    process B maps MAP_SHARED, PROT_READ|PROT_WRITE
        and proceeds to modify the data
    process C maps MAP_SHARED, PROT_READ|PROT_EXEC (no icache flush)

On a possibly related note:

What about icache flushes in these cases:

When using mprotect() PROT_READ|PROT_WRITE -> PROT_READ|PROT_EXEC,
e.g. as an FDPIC implementation may do when updating PLT entries.

And when calling msync(), like this:

    process A maps MAP_SHARED, PROT_READ|PROT_EXEC (flushes icache)
    process B maps MAP_SHARED, PROT_READ|PROT_WRITE
        and proceeds to modify the data
    process A calls msync()
        and proceeds to execute the modified contents

Do you think the mprotect() and msync() calls should flush icache in
those cases?

If seen arguments for it, and arguments that the executing process can
be expected to explicitly flush icache itself in those cases because
it knows what it is doing.  (Personally I lean towards the kernel
should be doing it.  IRIX interestingly offers both alternatives, with
a PROT_EXEC_NOFLUSH).

But in the first example above, I don't see how process C could be
expected to know it must flush icache, and process B could just be an
"optimised with writable mmap" file copy, so it shouldn't have
responsibility for icache either.

Or is icache fully flushed on every context switch on all nommu
architectures anyway, and defined to do so?

-- Jamie

