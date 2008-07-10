Return-Path: <linux-kernel-owner+w=401wt.eu-S1757285AbYGKJTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285AbYGKJTe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 05:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752352AbYGKJTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 05:19:24 -0400
Received: from r00tworld.com ([212.85.137.21]:33818 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074AbYGKJTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 05:19:23 -0400
From: pageexec@freemail.hu
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>
Date: Thu, 10 Jul 2008 23:21:31 +0200
MIME-Version: 1.0
Subject: Re: [Bug 11063][PATCH] exec: fix stack excutability without PT_GNU_STACK
Reply-to: pageexec@freemail.hu
CC: Andrew Morton <akpm@linux-foundation.org>, Ollie Wild <aaw@google.com>,
       bugme-daemon@bugzilla.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, stable@kernel.org,
       linux-kernel@vger.kernel.org
Message-ID: <4876997B.15434.250C736@pageexec.freemail.hu>
In-reply-to: <Pine.LNX.4.64.0807102110130.16171@blonde.site>
References: <bug-11063-27@http.bugzilla.kernel.org/>, <20080709152716.99e9bbe7.akpm@linux-foundation.org>, <Pine.LNX.4.64.0807102110130.16171@blonde.site>
X-mailer: Pegasus Mail for Windows (4.41)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.21]); Thu, 10 Jul 2008 23:22:03 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 Jul 2008 at 21:19, Hugh Dickins wrote:

> Kernel Bugzilla #11063 points out that on some architectures (e.g. x86_32)
> exec'ing an ELF without a PT_GNU_STACK program header should default to an
> executable stack; but this got broken by the unlimited argv feature because
> stack vma is now created before the right personality has been established:
> so breaking old binaries using nested function trampolines.
> 
> Therefore re-evaluate VM_STACK_FLAGS in setup_arg_pages, where stack
> vm_flags used to be set, before the mprotect_fixup.  Checking through
> our existing VM_flags, none would have changed since insert_vm_struct:
> so this seems safer than finding a way through the personality labyrinth.

alternatively, if there's a concern of stack_vma->vm_flags manipulation
during execve (maybe not now, but in the future or in non-ELF formats
that also want to rely on personality bits), you could opt for a safer

	vm_flags = vma->vm_flags | (VM_STACK_FLAGS & (VM_EXEC | VM_MAYEXEC));

to just recompute the exec rights related bits.

> Reported-by: pageexec@freemail.hu
> Signed-off-by: Hugh Dickins <hugh@veritas.com>
> Cc: stable@kernel.org
> ---
> 
>  fs/exec.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- 2.6.26-rc9/fs/exec.c	2008-06-21 08:41:19.000000000 +0100
> +++ linux/fs/exec.c	2008-07-10 20:02:25.000000000 +0100
> @@ -610,7 +610,7 @@ int setup_arg_pages(struct linux_binprm 
>  	bprm->exec -= stack_shift;
>  
>  	down_write(&mm->mmap_sem);
> -	vm_flags = vma->vm_flags;
> +	vm_flags = VM_STACK_FLAGS;
>  
>  	/*
>  	 * Adjust stack execute permissions; explicitly enable for
> 



