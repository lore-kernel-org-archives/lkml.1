Return-Path: <linux-kernel-owner+w=401wt.eu-S1946449AbXBCOLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946449AbXBCOLz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 09:11:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946455AbXBCOLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 09:11:55 -0500
Received: from science.horizon.com ([192.35.100.1]:12369 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1946449AbXBCOLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 09:11:54 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sat, 03 Feb 2007 09:11:54 EST
Date: 3 Feb 2007 09:05:13 -0500
Message-ID: <20070203140513.17092.qmail@science.horizon.com>
From: linux@horizon.com
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
Cc: linux@horizon.com, mingo@elte.hu, zach.brown@oracle.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

First of all, may I say, this is a wonderful piece of work.
It absolutely reeks of The Right Thing.  Well done!

However, while I need to study it in a lot more detail, I think Ingo's
implementation ideas make a lot more immediate sense.  It's the same
idea that I thought up.

Let me make it concrete.  When you start an async system call:
- Preallocate a second kernel stack, but don't do anything
  with it.  There should probably be a per-CPU pool of
  preallocated threads to avoid too much allocation and
  deallocation.
- Also at this point, do any resource limiting.
- Set the (normally NULL) "thread blocked" hook pointer to
  point to a handler, as explained below.
- Start down the regular system call path.
- In the fast-path case, the system call completes without blocking and
  we set up the completion structure and return to user space.
  We may want to return a special value to user space to tell it that
  there's no need to call asys_await_completion.  I think of it as the
  Amiga's IOF_QUICK.
- Also, when returning, check and clear the thread-blocked hook.

Note that we use one (cache-hot) stack for everything and do as little
setup as possible on the fast path.

However, if something blocks, it hits the slow path:
- If something would block the thread, the scheduler invokes the
  thread-blocked hook before scheduling a new thread.
- The hook copies the necessary state to a new (preallocated) kernel
  stack, which takes over the original caller's identity, so it can return
  immediately to user space with an "operation in progress" indicator.
- The scheduler hook is also cleared.
- The original thread is blocked.
- The new thread returns to user space and execution continues.

- The original thread completes the system call.  It may block again,
  but as its block hook is now clear, no more scheduler magic happens.

- When the operation completes and returns to sys_sys_submit(), it
  notices that its scheduler hook is no longer set.  Thus, this is a
  kernel-only worker thread, and it fills in the completion structure,
  places itself back in the available pool, and commits suicide.

Now, there is no chance that we will ever implement kernel state machines
for every little ioctl.  However, there may be some "async fast paths"
state machines that we can use.  If we're in a situation where we can
complete the operation without a kernel thread at all, then we can
detect the "would block" case (probably in-line, but you could
use a different scheduler hook function) and set up the state machine
structure.  Then return "operation in progress" and let the I/O
complete in its own good time.

Note that you don't need to implement all of a system call as an explicit
state machine; only its completion.  So, for example, you could do
indirect block lookups via an implicit (stack-based) state machine,
but the final I/O via an explicit one.  And you could do this only for
normal block devices and not NFS.  You only need to convert the hot
paths to the explicit state machine form; the bulk of the kernel code
can use separate kernel threads to do async system calls.

I'm also in the "why do we need fibrils?" camp.  I'm studying the code,
and looking for a reason, but using the existing thread abstraction
seems best.  If you encountered some fundamental reason why kernel threads
were Really Really Hard, then maybe it's worth it, but it's a new entity,
and entia non sunt multiplicanda praeter necessitatem.


One thing you can do for real-time tasks is, in addition to the
non-blocking flag (return EAGAIN from asys_submit rather than blocking),
you could have an "atomic" flag that would avoid blocking to preallocate
the additional kernel thread!  Then you'd really be guaranteed no
long delays, ever.
