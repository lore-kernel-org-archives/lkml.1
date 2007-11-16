Return-Path: <linux-kernel-owner+w=401wt.eu-S1765357AbXKPUUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765357AbXKPUUc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 15:20:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753918AbXKPUUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 15:20:23 -0500
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:48005 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbXKPUUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 15:20:22 -0500
Date: Fri, 16 Nov 2007 15:20:05 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Remy Bohmer <linux@bohmer.net>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       RT <linux-rt-users@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [BUG on PREEMPT_RT, 2.6.23.1-rt5] in rt-mutex code and signals
In-Reply-To: <3efb10970711160751l279fe99dl9f3a130a4373a449@mail.gmail.com>
Message-ID: <Pine.LNX.4.58.0711161516580.25989@gandalf.stny.rr.com>
References: <3efb10970711160751l279fe99dl9f3a130a4373a449@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 16 Nov 2007, Remy Bohmer wrote:

> Hello All,
>
> I have a problem with the RT-mutex code and signals. The problem is
> very easily reproducible, but I do not have found the root-cause yet.
> I hope someone can help me on this one.
>
> This is what I am doing:
> * I have a simple character driver with a read call.(called spi_read()
> in the logging below )
> * The read call blocks on a semaphore until some condition in hardware
> is reached. (in the routine wait_for_io_level(), see logging below)
> * I use a down_interruptible() call on a 'struct semaphore' type
> semaphore, which eventually blocks on a mutex. (the semaphore is, of
> course, initialised with sema_init() )

The above sounds more like you need a completion. What's used to wake up
the caller of down_interruptible?

Can you post some code to see what you are doing. That would make it much
easier to analyze.

-- Steve


>
> What happens is that when a user-space RT-thread is waiting on the
> semaphore through the spi_read() call, and a signal arrives during the
> wait at this thread (like e.g. CTRL-C), the kernel starts oopsing
> until it is as good as brain-dead.
>
> If I do NOT sent a posix-signal the code/mutex/semaphore is working
> properly for days,
> So, it seems to be related by waking up from a blocking situation,
> because of a pending posix-signal.
>
> I tried also the types 'struct compat_semaphore', and mutexes; none of
> them work.
> In fact the real Mutex type, declared with init_MUTEX() has the same problem.
>
> Anyone an idea?
> Below the kernel oops output. (I run on ARM, but I think that should
> not matter for this problem)
>
