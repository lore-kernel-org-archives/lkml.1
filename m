Return-Path: <linux-kernel-owner+w=401wt.eu-S1752084AbXBDFNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084AbXBDFNG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 00:13:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752085AbXBDFNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 00:13:05 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:3209 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbXBDFND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 00:13:03 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sat, 3 Feb 2007 21:13:00 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Zach Brown <zach.brown@oracle.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0 of 4] Generic AIO by scheduling stacks
In-Reply-To: <patchbomb.1170193181@tetsuo.zabbo.net>
Message-ID: <Pine.LNX.4.64.0702031539370.9054@alien.or.mcafeemobile.com>
References: <patchbomb.1170193181@tetsuo.zabbo.net>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jan 2007, Zach Brown wrote:

> This very rough patch series introduces a different way to provide AIO support
> for system calls.

Zab, great stuff!
I've found a little time to take a look at the patches and throw some 
comments at you.
Keep in mind though, that the last time I seriously looked at this stuff, 
sched.c was like 2K lines of code, and now it's 7K. Enough said ;)




> Right now to provide AIO support for a system call you have to express your
> interface in the iocb argument struct for sys_io_submit(), teach fs/aio.c to
> translate this into some call path in the kernel that passes in an iocb, and
> then update your code path implement with either completion-based (EIOCBQUEUED)
> or retry-based (EIOCBRETRY) AIO with the iocb.
> 
> This patch series changes this by moving the complexity into generic code such
> that a system call handler would provide AIO support in exactly the same way
> that it supports a synchronous call.  It does this by letting a task have
> multiple stacks executing system calls in the kernel.  Stacks are switched in
> schedule() as they block and are made runnable.

As I said in another email, I think this is a *great* idea. It allows for 
generic async execution, while leaving the core kernel AIO unware. Of 
course, ot be usable, a lot of details needs to be polished, and 
performance evaluated.




> We start in sys_asys_submit().  It allocates a fibril for this executing
> submission syscall and hangs it off the task_struct.  This lets this submission
> fibril be scheduled along with the later asys system calls themselves.

Why do you need this "special" fibril for the submission task?



> The specific switching mechanics of this implementation rely on the notion of
> tracking a stack as a full thread_info pointer.  To make the switch we transfer
> the non-stack bits of the thread_info from the old fibril's ti to the new
> fibril's ti.  We update the book keeping in the task_struct to 
> consider the new thread_info as the current thread_info for the task.  Like so:
> 
>         *next->ti = *ti;
>         *thread_info_pt_regs(next->ti) = *thread_info_pt_regs(ti);
> 
>         current->thread_info = next->ti;
>         current->thread.esp0 = (unsigned long)(thread_info_pt_regs(next->ti) + 1);
>         current->fibril = next;
>         current->state = next->state;
>         current->per_call = next->per_call;
> 
> Yeah, messy.  I'm interested in aggressive feedback on how to do this sanely.
> Especially from the perspective of worrying about all the archs.

Maybe an arch-specific copy_thread_info()? Or, since there's a 1:1 
relationship, just merging them.



> Did everyone catch that "per_call" thing there?  That's to switch members of
> task_struct which are local to a specific call.  link_count, journal_info, that
> sort of thing.  More on that as we talk about the costs later.

Yes ;) Brutally copying the structure over does not look good IMO. Better 
keep a pointer and swapping them. A clone_per_call() and free_per_call() 
might be needed.




> Eventually the timer fires and the hrtimer code path wakes the fibril:
> 
> -       if (task)
> -               wake_up_process(task);
> +       if (wake_target)
> +               wake_up_target(wake_target);
> 
> We've doctored try_to_wake_up() to be able to tell if its argument is a
> task_struct or one of these fibril targets.  In the fibril case it calls
> try_to_wake_up_fibril().  It notices that the target fibril does need to be
> woken and sets it TASK_RUNNING.  It notices that it it's current in the task so
> it puts the fibril on the task's fibril run queue and wakes the task.  There's
> grossness here.  It needs the task to come through schedule() again so that it
> can find the new runnable fibril instead of continuing to execute its current
> fibril.  To this end, wake-up marks the task's current ti TIF_NEED_RESCHED.

Fine IMO. Better keep scheduling code localized inside schedule().



> - With get AIO support for all syscalls.  Every single one.  (Well, please, no
> asys sys_exit() :)).  Buffered IO, sendfile, recvmsg, poll, epoll, hardware
> crypto ioctls, open, mmap, getdents, the entire splice API, etc.

Eeek, ... poll, epoll :)
That might solve the async() <-> POSIX bridge in the other way around. The 
collector will become the async() events fetcher, instead of the other way 
around. Will work just fine ...



> - We wouldn't multiply testing and maintenance burden with separate AIO paths.
> No is_sync_kiocb() testing and divergence between returning or calling
> aio_complete().  No auditing to make sure that EIOCBRETRY only being returned
> after any significant references of current->.  No worries about completion
> racing from the submission return path and some aio_complete() being called
> from another context.  In this scheme if your sync syscall path isn't broken,
> your AIO path stands a great chance of working.

This is the *big win* of the whole thing IMO.



> - AIO syscalls which *don't* block see very little overhead.  They'll allocate
> stacks and juggle the run queue locks a little, but they'll execute in turn on
> the submitting (cache-hot, presumably) processor.  There's room to optimize
> this path, too, of course.

Stack allocation can be optimized/cached, as someone else already said.



> - The 800lb elephant in the room.  It uses a full stack per blocked operation.
> I believe this is a reasonable price to pay for the flexibility of having *any*
> call pending.  It rules out some loads which would want to keep *millions* of
> operations pending, but I humbly submit that a load rarely takes that number of
> concurrent ops to saturate a resource.  (think of it this way: we've gotten
> this far by having to burn a full *task* to have *any* syscall pending.)  While
> not optimal, it opens to door to a lot of functionality without having to
> rewrite the kernel as a giant non-blocking state machine.

This should not be a huge problem IMO. High latency operations like 
network sockets can be handled with standard I/O events interfaces like 
poll/epoll, so I do not expect to have a huge number of fibrils around. 
The number of fibrils will be proportional to the number of active 
connections, not to the total number of connections.



> It should be noted that my very first try was to copy the used part of stacks
> in to and out of one full allocated stack.  This uses less memory per blocking
> operation at the cpu cost of copying the used regions.  And it's a terrible
> idea, for at least two reasons.  First, to actually get the memory overhead
> savings you allocate at stack switch time.  If that allocation can't be
> satisfied you are in *trouble* because you might not be able to switch over to
> a fibril that is trying to free up memory.  Deadlock city.  Second, it means
> that *you can't reference on-stack data in the wake-up path*.  This is a
> nightmare.  Even our trivial sys_nanosleep() example would have had to take its
> hrtimer_sleeper off the stack and allocate it.  Never mind, you know, basically
> every single user of <linux/wait.h>.   My current thinking is that it's just
> not worth it.

Agreed. Most definitely not worth it, for the reasons above.



> - We would now have some measure of task_struct concurrency.  Read that twice,
> it's scary.  As two fibrils execute and block in turn they'll each be
> referencing current->.  It means that we need to audit task_struct to make sure
> that paths can handle racing as its scheduled away.  The current implementation
> *does not* let preemption trigger a fibril switch.  So one only has to worry
> about racing with voluntary scheduling of the fibril paths.  This can mean
> moving some task_struct members under an accessor that hides them in a struct
> in task_struct so they're switched along with the fibril.  I think this is a
> manageable burden.

That seems the correct policy in any case.



> - Signals.  I have no idea what behaviour we want.  Help?  My first guess is
> that we'll want signal state to be shared by fibrils by keeping it in the
> task_struct.  If we want something like individual cancellation,  we'll augment
> signal_pending() with some some per-fibril test which will cause it to return
> from TASK_INTERRUPTIBLE (the only reasonable way to implement generic
> cancellation, I'll argue) as it would have if a signal was pending.

Fibril should IMO use current thread signal policies. I think a signal 
should hit (wake) any TASK_INTERRUPTIBLE fibril, if the current thread 
policies mandate that. I'd keep a list_head of currently scheduled-out 
TASK_INTERRUPTIBLE fibrils, and I'd make them runnable when a signal is 
delivered to the thread (wake_target bit #1 set to mean wake-all-interruptable-fibrils?).
The other thing is signal_pending(). The sigpending flag test is not going 
to work as is (cleared at the first do_signal). Setting a bit in each 
fibril would mean walking the whole TASK_INTERRUPTIBLE fibril list. Maybe 
a sequential signal counter in task_struct, matched by one in the fibril. 
A signal would increment the task_struct counter, and a fibril 
schedule-out would save the task_struct counter to the fibril. The 
signal_pending() for a fibril is a compare of the two. Or something 
similar.
In general, I think it'd make sense to have a fibril-based implemenation 
and a kthread-based one, and compare the messyness :) of the two related 
to cons/performnces.



- Davide

