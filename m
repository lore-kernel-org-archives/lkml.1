Return-Path: <linux-kernel-owner+w=401wt.eu-S1753186AbZDNUBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186AbZDNUBe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 16:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751268AbZDNUBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 16:01:25 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:45849 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbZDNUBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 16:01:24 -0400
Date: Tue, 14 Apr 2009 20:59:24 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org, fuse-devel@lists.sourceforge.net,
       miklos@szeredi.hu, akpm@linux-foundation.org, npiggin@suse.de
Subject: Re: [PATCH 1/5] mmap: don't assume f_op->mmap() doesn't change
 vma->vm_file
In-Reply-To: <1239674662-31318-2-git-send-email-tj@kernel.org>
Message-ID: <Pine.LNX.4.64.0904142047410.16616@blonde.anvils>
References: <1239674662-31318-1-git-send-email-tj@kernel.org>
 <1239674662-31318-2-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Apr 2009, Tejun Heo wrote:

> mmap_region() assumes that vma->vm_file isn't changed by f_op->mmap()
> and continues to use cache file after f_op->mmap() returns.

It does use "file" again in the unmap_and_free_vma error path
(isn't that reasonable? if the ->mmap failed, it shouldn't have
mucked with vma; and even if it has, then we'd better not change
the current behaviour of which to fput), but I don't see where else.

Further down, covering both vma->vm_file previously set and previously
unset cases, there is a "file = vma->vm_file;" before file is used.
So I think this patch is not necessary - if it is necessary, it's
already a bug, because already we switch from /dev/zero to a
shmem file there.

Hugh

> Don't assume that.  This will be used by FUSE to redirect mmap to
> shmem_file.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Nick Piggin <npiggin@suse.de>
> ---
>  mm/mmap.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 4a38411..46a7ae5 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1194,6 +1194,7 @@ munmap_back:
>  		vma->vm_file = file;
>  		get_file(file);
>  		error = file->f_op->mmap(file, vma);
> +		file = vma->vm_file;
>  		if (error)
>  			goto unmap_and_free_vma;
>  		if (vm_flags & VM_EXECUTABLE)
> -- 
> 1.6.0.2
