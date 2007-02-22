Return-Path: <linux-kernel-owner+w=401wt.eu-S1752067AbXBWAPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067AbXBWAPt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 19:15:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbXBWAPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 19:15:49 -0500
Received: from science.horizon.com ([192.35.100.1]:12922 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752067AbXBWAPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 19:15:48 -0500
Date: 22 Feb 2007 18:52:04 -0500
Message-ID: <20070222235204.28947.qmail@science.horizon.com>
From: linux@horizon.com
To: davem@davemloft.net, linux@horizon.com
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
In-Reply-To: <20070222.054012.71091934.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> It's brilliant for disk I/O, not for networking for which
> blocking is the norm not the exception.
> 
> So people will have to likely do something like divide their
> applications into handling for I/O to files and I/O to networking.
> So beautiful. :-)
>
> Nobody has proposed anything yet which scales well and handles both
> cases.

The truly brilliant thing about the whole "create a thread on blocking"
is that you immediately make *every* system call asynchronous-capable,
including the thousands of obscure ioctls, without having to boil the
ocean rewriting 5/6 of the kernel from implicit (stack-based) to
explicit state machines.

You're right that it doesn't solve everything, but it's a big step
forward while keeping a reasonably clean interface.


Now, we have some portions of the kernel (to be precise, those that
currently support poll() and select()) that are written as explicit
state machines and can block on a much smaller context structure.

In truth, the division you assume above isn't so terrible.
My applications are *already* written like that.  It's just "poll()
until I accumulate a whole request, then fork a thread to handle it."

The only way to avoid allocating a kernel stack is to have the entire
handling code path, including the return to user space, written in
explicit state machine style.  (Once you get to user space, you can have
a threading library there if you like.) All the flaming about different
ways to implement completion notification is precisely because not much
is known about the best way to do it; there aren't a lot of applications
that work that way.

(Certainly that's because it wasn't possible before, but it's clearly
an area that requires research, so not committing to an implementation
is A Good Thing.)

But once that is solved, and "system call complete" can be reported
without returning to a user-space thread (which is basically an alternate
system call submission interface, *independent* of the fibril/threadlet
non-blocking implementation), then you can find the hot paths in the
kernel and special-case them to avoid creating a whole thread.

To use a networking analogy, this is a cleanly layered protocol design,
with an optimized fast path *implementation* that blurs the boundaries.


As for the overhead of threading, there are basically three parts:
1) System call (user/kernel boundary crossing) costs.  These depend only
   on the total number of system calls and not on the number of threads
   making them.  They can be mitigated *if necessary* with a syslet-like
   "macro syscall" mechanism to increase the work per boundary crossing.

   The only place threading might increase these numbers is thread
   synchronization, and futexes already solve that pretty well.

2) Register and stack swapping.  These (and associated cache issues)
   are basically unavoidable, and are the bare minimum that longjmp()
   does.  Nothing thread-based is going to reduce this.  (Actually,
   the kernel can do better than user space because it can do lazy FPU
   state swapping.)

3) MMU context switch costs.  These are the big ones, particular on x86
   without TLB context IDs.  However, these fall into a few categories:
   - Mandatory switches because the entire application is blocked.
     I don't see how this can be avoided; these are the cases where
     even a user-space longjmp-based thread library would context
     switch.
   - Context switches between threads in an application.  The Linux
     kernel already optimizes out the MMU context switch in this case,
     and the scheduler already knows that such context switches are
     cheaper and preferred.

   The one further optimization that's possible is if you have a system
   call that (in a common case) blocks multiple times *without accessing
   user memory*.  This is not a read() or write(), but could be
   something like fsync() or ftruncate().  In this case, you could
   temporarily mark the thread as a "kernel thread" that can run in any
   MMU context, and then fix it explicitly when you unmark it on the
   return path.

I can see the space overhead of 1:1 threading, but I really don't think
there's much time overhead.
