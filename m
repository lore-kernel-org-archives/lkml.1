Return-Path: <linux-kernel-owner+w=401wt.eu-S936882AbXFGVJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936882AbXFGVJT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 17:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755402AbXFGVJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 17:09:11 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36107 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754952AbXFGVJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 17:09:10 -0400
Date: Thu, 7 Jun 2007 14:08:20 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
In-Reply-To: <46686EFA.1030302@cosmosbay.com>
Message-ID: <alpine.LFD.0.98.0706071356270.4205@woody.linux-foundation.org>
References: <send-serie.davidel@xmailserver.org.4625.1181169040.7>
 <20070606235906.72439d16@the-village.bc.nu>
 <alpine.LFD.0.98.0706071240150.4205@woody.linux-foundation.org>
 <46686EFA.1030302@cosmosbay.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 7 Jun 2007, Eric Dumazet wrote:
> 
> This is a nice idea, but 32/64 compat code is going to hate it :)

It should be fairly simple for 32/64-bit compat code too.

The compat code should just call the compat system call 

> syscall_indirect() would be writen in assembly for each arch, since there is
> no generic syscall table. Thats really a lot of work, especially if we want to
> mess with signal mask, umask ...

No no no. That would be horribly idiotic.

The thing should be 99% generic code, ie we would have

	syscall_indirect(..)
	{
		long retval;

		.. set up signals/flags ..
		retval = arch_syscall_indirect(syscall, args);
		.. unsetup signals/flags ..
		return retval;
	}

	compat_syscall_indirect(..)
	{
		int retval;

		.. set up signals/flags ..
		retval = compat_arch_syscall_indirect(syscall, args);
		.. unsetup signals/flags ..
		return retval;
	}

and the *only* thing that each architecture would need to do is that 
(trivial) arch_syscall_indirect() thing (and the compat version, if 
applicable). And those literally should be generally pretty damn trivial.

The only _subtle_ issue is any system call that actually uses "pt_regs". 
So we'd have to disallow exec/fork/vfork/clone/. They take magic pt_regs 
pointers etc. On x86, for example, the following system calls should *not* 
be things you can do this with:

	asmlinkage int sys_fork(struct pt_regs regs)
	asmlinkage int sys_clone(struct pt_regs regs)
	asmlinkage int sys_vfork(struct pt_regs regs)
	asmlinkage int sys_execve(struct pt_regs regs)
	asmlinkage int sys_vm86old(struct pt_regs regs)
	asmlinkage int sys_vm86(struct pt_regs regs)
	asmlinkage long sys_iopl(unsigned long unused)

because those either take pt_regs, or make pt_regs out of their arguments 
(that "unused" is used to do:

	volatile struct pt_regs * regs = (struct pt_regs *) &unused;

so there is *some* care needed, but other than taking care of this, the 
implementation on x86 should really be totally trivial.

		Linus
