Return-Path: <linux-kernel-owner+w=401wt.eu-S1760803AbYF0RwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760803AbYF0RwO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 13:52:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757631AbYF0Rv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 13:51:59 -0400
Received: from [198.99.130.12] ([198.99.130.12]:42197 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756912AbYF0Rv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 13:51:58 -0400
Date: Fri, 27 Jun 2008 13:50:09 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Renzo Davoli <renzo@cs.unibo.it>
Cc: LKML <linux-kernel@vger.kernel.org>, Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH 0/1] ptrace_vm: let us simplify the code for ptrace and
	add useful features for VM
Message-ID: <20080627175009.GG8381@c2.user-mode-linux.org>
References: <20080616075804.GA6950@cs.unibo.it> <20080617162511.GA7223@c2.user-mode-linux.org> <20080617190831.GC32418@cs.unibo.it> <20080618164942.GC8225@c2.user-mode-linux.org> <20080622091102.GA29401@cs.unibo.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080622091102.GA29401@cs.unibo.it>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 22, 2008 at 11:11:02AM +0200, Renzo Davoli wrote:
> There are three events for a syscall:
> START - call notification
> CALL - run the SYSCALL
> EXIT - return notification.
> 
> I think that it is a non sense to write code for useless cases.
> Let us see all the combinations of doing/skipping each one of the three
> phases:
> 
> 0- DOSTART - DOCALL - DOEXIT - Standard PTRACE_SYSCALL (new option 0)
> 1- DOSTART - DOCALL - SKIPEXIT - PTRACE_VM_SKIPEXIT of my proposal
> 2- DOSTART - SKIPCALL - DOEXIT - useless, nothing has changed between
>                               the two notifications
> 3- DOSTART - SKIPCALL - SKIPEXIT - PTRACE_VM_SKIPCALL in my proposal
> 4- SKIPSTART - DOCALL - DOEXIT - is this useful? (Case 4,see below)
> 5- SKIPSTART - DOCALL - SKIPEXIT - simply don't use PTRACE_SYSCALL
> 6- SKIPSTART - SKIPCALL - DOEXIT - this is the old PTRACE_SYSEMU (case 6)
> 7- SKIPSTART - SKIPCALL - SKIPEXIT - nullify completely the syscalls
>                                 (case 7).
>                                 
> case 4: a vm or debugging monitor receives just the return value of a
> syscall. In many architectures it not even possible to read the parameters
> of the call (e.g. powerpc where the first argument and the return value
> use the same register). This choice must be done a-priori, so without
> actually know which will be the next system call.

I can see this being useful - this is kind of what strace wants,
except that it wouldn't be able to see that a system call is about to
sleep.  This could be implemented by just stashing any trashed
registers off to the side ala x86 orig_eax.

> case 6: this makes sense just for applications which virtualize *all* the
> system call, current PTRACE_SYSEMU works exactly in this way.
> My patch shows that for these applications it does not matter whether the
> virtualization takes place before skipping the call or after having just
> skipped the call. So PTRACE_VM_SKIPCALL can be used instead.

Yup.

> case 7: skip the next syscall and give no information about, there is no way
> to virtualize or trace what is going on.
> Who could be ever interested in an option like this?

No one.

> It seems that the combinations that really make sense are those skipping
> a trailing part of the sequence.
> 
> DOSTART - DOCALL - DOEXIT         my option 0
> DOSTART - DOCALL - SKIPEXIT       my option PTRACE_VM_SKIPEXIT
> DOSTART - SKIPCALL - SKIPEXIT     my option PTRACE_VM_SKIPCALL

Seems reasonable.  In this case, they should be numbered 0, 1, 2
rather than having masks or-ed together.  This happens to produce the
same numbers, except that 3 is outlawed.

> If you think that it is not clear from the tag name that PTRACE_VM_SKIPCALL
> implies PTRACE_VM_SKIPEXIT let us change the name in:
> PTRACE_VM_SKIPCALL_SKIPEXIT
> Maybe the name is quite long, but in this way it is clear what it
> does.

Maybe.  How about PTRACE_VM_TRACESTART?  Makes the naming somewhat
non-orthogonal, but shorter and descriptive.

		    	    	Jeff

-- 
Work email - jdike at linux dot intel dot com
