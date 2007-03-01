Return-Path: <linux-kernel-owner+w=401wt.eu-S932657AbXCAGGB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932657AbXCAGGB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 01:06:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932670AbXCAGGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 01:06:00 -0500
Received: from smtp.osdl.org ([65.172.181.24]:57140 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932657AbXCAGGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 01:06:00 -0500
Date: Wed, 28 Feb 2007 22:03:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <compudj@google.com>
Cc: "Martin J. Bligh" <mbligh@google.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, "David S. Miller" <davem@davemloft.net>,
       Paul Mackerras <paulus@samba.org>, "Luck, Tony" <tony.luck@intel.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: Thread flags modified without set_thread_flag() (non
 atomically)
Message-Id: <20070228220349.b42bf571.akpm@linux-foundation.org>
In-Reply-To: <45E33EBD.6020603@google.com>
References: <45E33EBD.6020603@google.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Feb 2007 12:10:37 -0800 Mathieu Desnoyers <compudj@google.com> wrote:

> Hi,

How come I'm the only person around here with a Reply button?

> Looking into the thread flags, I found out that some architecture 
> specific kernel functions (in 2.6.20) sets the thread flags with non 
> atomic operation.
> 
> A good way to list the most trivial : grep -r TIF_ * | grep =
> 
> Some examples follows. If, for instance, 
> x86_64/kernel/process.c:flush_thread is called from an exec system call, 
> it will do the following :
> 
> x86_64/kernel/process.c:                t->flags ^= (_TIF_ABI_PENDING | 
> _TIF_IA32);
> x86_64/kernel/process.c:        t->flags &= ~_TIF_DEBUG;
> 
> void flush_thread(void)
> {
>         struct task_struct *tsk = current;
>         struct thread_info *t = current_thread_info();
> 
>         if (t->flags & _TIF_ABI_PENDING) {
>                 t->flags ^= (_TIF_ABI_PENDING | _TIF_IA32);
>                 if (t->flags & _TIF_IA32)
>                         current_thread_info()->status |= TS_COMPAT;
>         }
>         t->flags &= ~_TIF_DEBUG;
> ....
> 
> As long as the flags are only updated by the thread itself at this 
> moment, it seems safe, but if other updates coming from other threads 
> are expected, wouldn't it result in a bad behavior ?
> 
> i.e if resched_task ia being called by another CPU at the same time for 
> this specific thread would set the TIF_NEED_RESCHED flag, but it could 
> be overwritten by the non-atomic modification in flush_thread.

It does seem risky.  Perhaps it is a micro-optimisation which utilises
knowledge that this thread_struct cannot be looked up via any path in this
context.

Or perhaps it is a bug.  Andi, can you please comment?

> And about this specific flush_thread, I am puzzled about the t->flags ^= 
> (_TIF_ABI_PENDING | _TIF_IA32); line. The XOR will clearly flip the 
> _TIF_ABI_PENDING bit to 0, and very likely set _TIF_IA32 to the opposite 
> of its current value. Why does this change need to be written atomically 
> (can other threads play with these flags ?) ?
> 

Don't know.

> 
> 
> Other examples :
> 
> sparc64/kernel/ptrace.c:                if 
> ((task_thread_info(child)->flags & _TIF_32BIT) != 0) {
> sparc64/kernel/process.c:               t->flags ^= (_TIF_ABI_PENDING | 
> _TIF_32BIT);
> sparc64/kernel/process.c:                       t->flags &= ~_TIF_PERFCTR;
> 
> sparc/kernel/process.c:         current_thread_info()->flags &= 
> ~_TIF_USEDFPU;
> sparc/kernel/process.c:         current_thread_info()->flags &= 
> ~_TIF_USEDFPU;
> sparc/kernel/process.c:         current_thread_info()->flags &= 
> ~_TIF_USEDFPU;
> sparc/kernel/process.c:                 current_thread_info()->flags &= 
> ~(_TIF_USEDFPU);
> sparc/kernel/traps.c:   current_thread_info()->flags |= _TIF_USEDFPU;
> sparc/kernel/traps.c:   task_thread_info(fpt)->flags &= ~_TIF_USEDFPU;

That all looks rather deliberate.

> powerpc/kernel/process.c:               t->flags ^= (_TIF_ABI_PENDING | 
> _TIF_32BIT);
>
> ia64/kernel/mca.c:      ti->flags = _TIF_MCA_INIT;
>
> avr32/kernel/ptrace.c:          ti->flags |= _TIF_BREAKPOINT;

No, I don't immediately see anything in the flush_old_exec() code path
which tells us that nobody else can look up this thread_info (or be holding
a ref to it) in this context.


> avr32/kernel/ptrace.c:                  ti->flags |= TIF_SINGLE_STEP;

heh.  Haarvard, you got a bug.


