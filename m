Return-Path: <linux-kernel-owner+w=401wt.eu-S1754802AbZGVKLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802AbZGVKLr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 06:11:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754715AbZGVKLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 06:11:46 -0400
Received: from cmpxchg.org ([85.214.51.133]:42321 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754759AbZGVKLp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 06:11:45 -0400
Date: Wed, 22 Jul 2009 12:10:32 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>, mingo@elte.hu,
       Chris Zankel <chris@zankel.net>
Subject: Re: [Patch 2/2] xtensa: use generic sys_pipe()
Message-ID: <20090722101032.GA2102@cmpxchg.org>
References: <20090722091051.6621.15184.sendpatchset@localhost.localdomain> <20090722091100.6621.80645.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090722091100.6621.80645.sendpatchset@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CC Chris]

On Wed, Jul 22, 2009 at 05:08:42AM -0400, Amerigo Wang wrote:
> 
> As suggested by Al, we can use the generic sys_pipe() instead of xtensa_pipe()
> for xtensa.
> 
> Signed-off-by: WANG Cong <amwang@redhat.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk> 
> CC: Linus Torvalds <torvalds@linux-foundation.org>

Reviewed-by: Johannes Weiner <jw@emlix.com>

> ---
> diff --git a/arch/xtensa/include/asm/syscall.h b/arch/xtensa/include/asm/syscall.h
> index 05cebf8..76a1fb8 100644
> --- a/arch/xtensa/include/asm/syscall.h
> +++ b/arch/xtensa/include/asm/syscall.h
> @@ -12,7 +12,6 @@ struct pt_regs;
>  struct sigaction;
>  asmlinkage long xtensa_execve(char*, char**, char**, struct pt_regs*);
>  asmlinkage long xtensa_clone(unsigned long, unsigned long, struct pt_regs*);
> -asmlinkage long xtensa_pipe(int __user *);
>  asmlinkage long xtensa_mmap2(unsigned long, unsigned long, unsigned long,
>      			     unsigned long, unsigned long, unsigned long);
>  asmlinkage long xtensa_ptrace(long, long, long, long);
> diff --git a/arch/xtensa/include/asm/unistd.h b/arch/xtensa/include/asm/unistd.h
> index c092c8f..b6880c8 100644
> --- a/arch/xtensa/include/asm/unistd.h
> +++ b/arch/xtensa/include/asm/unistd.h
> @@ -94,7 +94,7 @@ __SYSCALL( 35, sys_readlink, 3)
>  #define __NR_mknod 				 36
>  __SYSCALL( 36, sys_mknod, 3)
>  #define __NR_pipe 				 37
> -__SYSCALL( 37, xtensa_pipe, 1)
> +__SYSCALL(37, sys_pipe, 1)

It would have been nice to keep the spacing but that shouldn't be a
show stopper..

>  #define __NR_unlink 				 38
>  __SYSCALL( 38, sys_unlink, 1)
>  #define __NR_rmdir 				 39
> diff --git a/arch/xtensa/kernel/syscall.c b/arch/xtensa/kernel/syscall.c
> index ac15ecb..c7279be 100644
> --- a/arch/xtensa/kernel/syscall.c
> +++ b/arch/xtensa/kernel/syscall.c
> @@ -39,24 +39,6 @@ syscall_t sys_call_table[__NR_syscall_count] /* FIXME __cacheline_aligned */= {
>  #include <asm/unistd.h>
>  };
>  
> -/*
> - * xtensa_pipe() is the normal C calling standard for creating a pipe. It's not
> - * the way unix traditional does this, though.
> - */
> -
> -asmlinkage long xtensa_pipe(int __user *userfds)
> -{
> -	int fd[2];
> -	int error;
> -
> -	error = do_pipe_flags(fd, 0);
> -	if (!error) {
> -		if (copy_to_user(userfds, fd, 2 * sizeof(int)))
> -			error = -EFAULT;
> -	}
> -	return error;
> -}
> -
>  
>  asmlinkage long xtensa_mmap2(unsigned long addr, unsigned long len,
>     			     unsigned long prot, unsigned long flags,

	Hannes
