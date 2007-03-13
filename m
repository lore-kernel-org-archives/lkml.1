Return-Path: <linux-kernel-owner+w=401wt.eu-S1753157AbXCMHFD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157AbXCMHFD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 03:05:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753164AbXCMHFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 03:05:03 -0400
Received: from mercury.realtime.net ([205.238.132.86]:59306 "EHLO
	ruth.realtime.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753157AbXCMHFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 03:05:00 -0400
Mime-Version: 1.0 (Apple Message framework v624)
In-Reply-To: <20070307201018.GA8485@kryten>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <7b920b9e06dea14598b9dcc669a39203@bga.com>
Content-Transfer-Encoding: 7bit
Cc: Anton Blanchard <anton@samba.org>, Stephen Rothwell <sfr@canb.auug.org.au>
From: Milton Miller <miltonm@bga.com>
Subject: Re: [patch 00/12] Syslets, Threadlets, generic AIO support, v5
Date: Tue, 13 Mar 2007 02:05:18 -0500
To: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
X-Mailer: Apple Mail (2.624)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Anton Blanchard wrote:
> Hi Ingo,
>
>> this is the v5 release of the syslet/threadlet subsystem:
>>
>>    http://redhat.com/~mingo/syslet-patches/
>
> Nice!
>

I too went and downloaded patches-v5 for review.

First off, one problem I noticed in sys_async_wait:

+	ah->events_left = min_wait_events - (kernel_ring_idx - user_ring_idx);

This completely misses the wraparound case of kernel_ring_idx <
user_ring_idx. I wonder if this is causing some of the benchmark 
problems?
(add max_ring_index if kernel < user).

> I tried to port this to ppc64 but found a few problems:
>
> The 64bit powerpc ABI has the concept of a TOC (r2) which is used for
> per function data. This means this wont work:
[deleted]
> I think we would want to change restore_ip to restore_function, and 
> then
> create a per arch helper, perhaps:
>
> void set_user_context(struct task_struct *task, unsigned long stack,
> 		      unsigned long function, unsigned long retval);
>
> ppc64 could then grab the ip and r2 values from the function 
> descriptor.
>
> The other issue involves the syscall table:
>
> asmlinkage struct syslet_uatom __user *
> sys_async_exec(struct syslet_uatom __user *uatom,
>                struct async_head_user __user *ahu)
> {
>         return __sys_async_exec(uatom, ahu, sys_call_table, 
> NR_syscalls);
> }
>
> This exposes the layout of the syscall table. Unfortunately it wont 
> work
> on ppc64. In arch/powerpc/kernel/systbl.S:
>
> #define COMPAT_SYS(func)        .llong  .sys_##func,.compat_sys_##func
>
> Both syscall tables are overlaid.
>
> Anton

In addition, the entries in the table are not function pointers, they
are the actual code targets.   So we need a arch helper to invoke the
system call.

Here is another problem with your compat code.  Just telling user space
that everything is u64 and having the kernel retrieve pointers and ulong
doesn't work, you have to actually copy in u64 values and truncate them
down.  Your current code is broken on all 32bit big endian kernels.
Actually, the check needs to be that the upper 32 bits are 0 or return
-EINVAL.

In addition, the compat syscall entry points assume that the arguments
have been truncated to compat_ulong values by the syscall entry path,
and that they only need to do sign extension (and/or pointer conversion
on s390 with its 31 bit pointers).  So all compat kernels are broken.

The two of these things together makes me think we want two copy
functions.  At that point we may as well define the struct uatom in
terms of ulong and compat_ulong for the compat_uatom.  That would lead
to two copies of exec_uatom, but the elimination of passing the syscall
table as an argument down.  The need_resched and signal check could
become part of the common next_uatom routine, although it would need to
know uatom+1 instead of doing the addition in itself.

Other observations:

All the logic setting at and async_ready is a bit hard to follow.
After some analysis, t->at is only ever set to &t->__at and
async_ready is only set to the same at or NULL.  Both of these
should become flags, and at->task should be converted to
container_of.  Also, the name at is hard to grep / search for.

The stop flags are decoded with a case but are not densely encoded,
rather they are one hot.  We either need to error on multiple stop
bits being set, stop on each possible condition, or encode them
densely.

There is no check for flags being set that are not recognized.
If we ever add a flag for another stop condition this would
lead to incorrect execution by the kernel.

There are some syscalls that can return -EFAULT but later have
force_syscall_noerror.  We should create a stop on ERROR and
clear the force_noerror flag between syscalls.  The umem_add
syscall should add force_noerror if the put_user succeeds.

In copy_uatom, you call verify_read on the entire uatom.  This means
that the struct with all user space size has to be within the process
limit, which violates your assertion that userspace doesn't need the
whole structure.  If we add the requirement that the space that would
be occupied by the complete atom has to exist, then we can copy the
whole struct uatom with copy_from_user and then copy the args with
get_user.  User space can still pack them more densely, and we can
still stop copying on a null arg pointer.  Actually, calling access_ok
then __get_user can be more expensive on some architectures because
they have to verify both start and length on access_ok but can only
verify start on get_user because they have unmapped areas between user
space and kernel space.  This would also mean that we don't check
arg_ptr for NULL without verifying that get_user actually worked.	
The gotos in exec_uatom are just a while loop with a break.

sys_umem_add should be in /lib under lib-y in the Makefile.
In fact declaring the function weak does not make it a weak
syscall implementation on some architectures.

Weak syscalls aliases to sys_ni_syscall are needed for when
async support is not selected in Kconfig.

The Documentation patch does not explain threadlets.  In fact, I
had to read the old patch announcement to find out what a threadlet
was and how the concept was different from a syslet.

Do we need 32 bits for the syscall number?   I wonder if we
would be better served by a 16 bit syscall number and 16 bits
reserved for future use.

The how does userspace actually find out about the error doing the
completion in the syslet case?  Its actually executing in an
async_thread.  The only case a return code is given to userspace
is sys_async_thread, and those are mostly invisible to the thread.

I'm not sure if the api for threadlets is ready.  Why does user space
need scan for the stack being consumed?  Can't it infer that by the
return code of the sync task?

<partial-thought> It appears you expect restore_ip and restore_stack
implement a minimal longjmp back to userspace.  Instead of passing
these explicitly, why not treat async_on as a setjmp and return to that
point. As Anton pointed out, a simple stack pointer and next instruction
pointer are not enough for all architectures.  </partial-thought>

Why must the sp reg macro not be an lvalue?  To enforce your stack
clear api?

There seemed to be some copied comments in the x86-64 code (including
some space vs tabs).

Is testing t->async_ready what we want to exclude system calls on?  I
thought that would catch callers who might go async on schedule()
instead of those running async in the background.   I think we want
somthing more like t->at or whatever flag that becomes, saying that
the thread is a background thread.  Or maybe a combination.

milton

