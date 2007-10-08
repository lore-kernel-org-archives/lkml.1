Return-Path: <linux-kernel-owner+w=401wt.eu-S1755602AbXJHUFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602AbXJHUFd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 16:05:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752933AbXJHUFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 16:05:24 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:44466 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbXJHUFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 16:05:23 -0400
Date: Mon, 8 Oct 2007 14:37:59 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Yan Zheng <yanzheng@21cn.com>
cc: Nick Piggin <nickpiggin@yahoo.com.au>, Miklos Szeredi <miklos@szeredi.hu>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH]fix VM_CAN_NONLINEAR check in sys_remap_file_pages
In-Reply-To: <3d0408630710080445j4dea115emdfe29aac26814536@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0710081418140.8640@blonde.wat.veritas.com>
References: <3d0408630710080445j4dea115emdfe29aac26814536@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Oct 2007, Yan Zheng wrote:
> 
> The test for VM_CAN_NONLINEAR always fails

Good catch indeed.  Though I was puzzled how we do nonlinear at all,
until I realized it's "The test for not VM_CAN_NONLINEAR always fails".

It's not as serious as it appears, since code further down has been
added more recently to simulate nonlinear on non-RAM-backed filesystems,
instead of going the real nonlinear way; so most filesystems are now not
required to do what VM_CAN_NONLINEAR was put in to ensure they could do.

I'm confused as to where that leaves us: is this actually a fix that
needs to go into 2.6.23?  or will it suddenly disable a system call
which has been silently working fine on various filesystems which did
not add VM_CAN_NONLINEAR?  could we just rip out VM_CAN_NONLINEAR?
I hope Nick or Miklos is clearer on what the risks are.

(Apologies for all the "not"s and "non"s here, I'm embarrassed
after just criticizing Ingo's SCHED_NO_NO_OMIT_FRAME_POINTER!)

Hugh

> 
> Signed-off-by: Yan Zheng<yanzheng@21cn.com>
> ----
> diff -ur linux-2.6.23-rc9/mm/fremap.c linux/mm/fremap.c
> --- linux-2.6.23-rc9/mm/fremap.c	2007-10-07 15:03:33.000000000 +0800
> +++ linux/mm/fremap.c	2007-10-08 19:33:44.000000000 +0800
> @@ -160,7 +160,7 @@
>  	if (vma->vm_private_data && !(vma->vm_flags & VM_NONLINEAR))
>  		goto out;
> 
> -	if (!vma->vm_flags & VM_CAN_NONLINEAR)
> +	if (!(vma->vm_flags & VM_CAN_NONLINEAR))
>  		goto out;
> 
>  	if (end <= start || start < vma->vm_start || end > vma->vm_end)
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
