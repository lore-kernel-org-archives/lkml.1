Return-Path: <linux-kernel-owner+w=401wt.eu-S1751678AbXA3VkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678AbXA3VkY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 16:40:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751598AbXA3Vjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 16:39:51 -0500
Received: from tetsuo.zabbo.net ([207.173.201.20]:46901 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678AbXA3Vjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 16:39:47 -0500
Content-Type: multipart/mixed; boundary="===============0152984906=="
MIME-Version: 1.0
Subject: [PATCH 0 of 4] Generic AIO by scheduling stacks
Message-Id: <patchbomb.1170193181@tetsuo.zabbo.net>
Date: Tue, 30 Jan 2007 13:39:41 -0700
From: Zach Brown <zach.brown@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--===============0152984906==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

This very rough patch series introduces a different way to provide AIO support
for system calls.

Right now to provide AIO support for a system call you have to express your
interface in the iocb argument struct for sys_io_submit(), teach fs/aio.c to
translate this into some call path in the kernel that passes in an iocb, and
then update your code path implement with either completion-based (EIOCBQUEUED)
or retry-based (EIOCBRETRY) AIO with the iocb.

This patch series changes this by moving the complexity into generic code such
that a system call handler would provide AIO support in exactly the same way
that it supports a synchronous call.  It does this by letting a task have
multiple stacks executing system calls in the kernel.  Stacks are switched in
schedule() as they block and are made runnable.

First, let's introduce the term 'fibril'.  It means small fiber or thread.  It
represents the stack and the bits of data which manage its scheduling under the
task_struct.  There's a 1:1:1 relationship between a fibril, the stack it's
managing, and the thread_struct it's operating under.  They're static for the
fibril's lifetime.  I came to choosing a funny new term after a few iterations
of trying to use existing terms (stack, call, thread, task, path, fiber)
without going insane.  They were just too confusing to use with a clear
conscious.

So, let's illustrate the changes by walking through the execution of an asys
call.  Let's say sys_nanosleep().  Then we'll talk about the trade-offs.

Maybe it'd make sense to walk through the patches in another window while
reading the commentary.  I'm sorry if this seems tedious, but this is
non-trivial stuff.  I want to get the point across.

We start in sys_asys_submit().  It allocates a fibril for this executing
submission syscall and hangs it off the task_struct.  This lets this submission
fibril be scheduled along with the later asys system calls themselves.

sys_asys_submit() has arguments which specify system call numbers and
arguments.  For each of these calls the submission syscall allocates a fibril
and constructs an initial stack.  The fibril has eip pointing to the system
call handler and esp pointing to the new stack such that when the handler is
called its arguments will be on the stack.  The stack is also constructed so
that when the handler returns it jumps to a function which queues the return
code for collection in userspace.

sys_asys_submit() asks the scheduler to put these new fibrils on the simple run
queue in the task_struct.  It's just a list_head for now.  It then calls
schedule().

After we've gotten the run queue lock in the scheduler we notice that there are
fibrils on the task_struct's run queue.  Instead of continuing with schedule(),
then, we switch fibrils.  The old submission fibril will still be in schedule()
and we'll start executing sys_nanosleep() in the context of the submission
task_struct.

The specific switching mechanics of this implementation rely on the notion of
tracking a stack as a full thread_info pointer.  To make the switch we transfer
the non-stack bits of the thread_info from the old fibril's ti to the new
fibril's ti.  We update the book keeping in the task_struct to 
consider the new thread_info as the current thread_info for the task.  Like so:

        *next->ti = *ti;
        *thread_info_pt_regs(next->ti) = *thread_info_pt_regs(ti);

        current->thread_info = next->ti;
        current->thread.esp0 = (unsigned long)(thread_info_pt_regs(next->ti) + 1);
        current->fibril = next;
        current->state = next->state;
        current->per_call = next->per_call;

Yeah, messy.  I'm interested in aggressive feedback on how to do this sanely.
Especially from the perspective of worrying about all the archs.

Did everyone catch that "per_call" thing there?  That's to switch members of
task_struct which are local to a specific call.  link_count, journal_info, that
sort of thing.  More on that as we talk about the costs later.

After the switch we're executing in sys_nanosleep().  Eventually it gets to the
point where it's building its timer which will wake it after the sleep
interval.  Currently it would store a bare task_struct reference for
wake_up_process().  Instead we introduce a helper which returns a cookie that
is given to a specific wake_up_*() variant.  Like so:

-       sl->task = task;
+       sl->wake_target = task_wake_target(task);

It then marks itself as TASK_INTERRUPTIBLE and calls schedule().  schedule()
notices that we have another fibril on the run queue.  It's the submission
fibril that we switched from earlier.  As we switched we saw that it was still
TASK_RUNNING so we put it on the run queue as we switched.  We now switch back to
the submission fibril, leaving the sys_nanosleep() fibril sleeping.  Let's say
the submission task returns to userspace which then immediately calls
sys_asys_await_completion().  It's an easy case :).  It goes to sleep, there
are no running fibrils and the schedule() path really puts the task to sleep.

Eventually the timer fires and the hrtimer code path wakes the fibril:

-       if (task)
-               wake_up_process(task);
+       if (wake_target)
+               wake_up_target(wake_target);

We've doctored try_to_wake_up() to be able to tell if its argument is a
task_struct or one of these fibril targets.  In the fibril case it calls
try_to_wake_up_fibril().  It notices that the target fibril does need to be
woken and sets it TASK_RUNNING.  It notices that it it's current in the task so
it puts the fibril on the task's fibril run queue and wakes the task.  There's
grossness here.  It needs the task to come through schedule() again so that it
can find the new runnable fibril instead of continuing to execute its current
fibril.  To this end, wake-up marks the task's current ti TIF_NEED_RESCHED.
This seems to work, but there are some pretty terrifying interactions between
schedule, wake-up, and the maintenance of fibril->state and task->state that
need to be sorted out.

Remember our task was sleeping in asys_await_completion()?  The task was woken
by the fibril wake-up path, but it's still executing the
asys_await_completion() fibril.  It comes out of schedule() and sees
TIF_NEED_RESCHED and comes back through the top of schedule().  This time it
finds the runnable sys_nanosleep() fibril and switches to it.  sys_nanosleep()
runs to completion and it returns which, because of the way we built its stack,
calls asys_teardown_stack().

asys_teardown_stack() takes the return code and puts it off in a list for
asys_await_completion().  It wakes a wait_queue to notify waiters of pending
completions.  In so doing it wakes up the asys_await_completion() fibril that
was sleeping in our task.

Then it has to tear down the fibril for the call that just completed.  In the
current implementation the fibril struct is actually embedded in an "asys_call"
struct.  asys_teardown_stack() frees the asys_call struct, and so the fibril,
after having cleared current->fibril.  It then calls schedule().  Our
asys_await_completion() fibril is on the run queue so we switch to it.
Switching notices the null current->fibril that we're switching from and takes
that as a queue to mark the previous thread_info for freeing *after* the
switch.

After the switch we're in asys_await_completion().  We find the waiting return
code completion struct in the list that was left by asys_teardown_stack().  We
return it to userspace.

Phew.  OK, so what are the trade-offs here?  I'll start with the benefits for
obvious reasons :).

- With get AIO support for all syscalls.  Every single one.  (Well, please, no
asys sys_exit() :)).  Buffered IO, sendfile, recvmsg, poll, epoll, hardware
crypto ioctls, open, mmap, getdents, the entire splice API, etc.

- The syscall API does not change just because calls are being issued AIO,
particularly things that reference task_struct.  AIO sys_getpid() does what
you'd expect, signal masking, etc.  You don't have to worry about your AIO call
being secretly handled by some worker threads that get very different results
from current-> references.

- We wouldn't multiply testing and maintenance burden with separate AIO paths.
No is_sync_kiocb() testing and divergence between returning or calling
aio_complete().  No auditing to make sure that EIOCBRETRY only being returned
after any significant references of current->.  No worries about completion
racing from the submission return path and some aio_complete() being called
from another context.  In this scheme if your sync syscall path isn't broken,
your AIO path stands a great chance of working.

- The submission syscall won't block while handling submitted calls.  Not for
metadata IO, not for memory allocation, not for mutex contention, nothing.  

- AIO syscalls which *don't* block see very little overhead.  They'll allocate
stacks and juggle the run queue locks a little, but they'll execute in turn on
the submitting (cache-hot, presumably) processor.  There's room to optimize
this path, too, of course.

- We don't need to duplicate interfaces for each AIO interface we want to
support.  No iocb unions mirroring the syscall API, no magical AIO sys_
variants.

And the costs?  It's not free.

- The 800lb elephant in the room.  It uses a full stack per blocked operation.
I believe this is a reasonable price to pay for the flexibility of having *any*
call pending.  It rules out some loads which would want to keep *millions* of
operations pending, but I humbly submit that a load rarely takes that number of
concurrent ops to saturate a resource.  (think of it this way: we've gotten
this far by having to burn a full *task* to have *any* syscall pending.)  While
not optimal, it opens to door to a lot of functionality without having to
rewrite the kernel as a giant non-blocking state machine.

It should be noted that my very first try was to copy the used part of stacks
in to and out of one full allocated stack.  This uses less memory per blocking
operation at the cpu cost of copying the used regions.  And it's a terrible
idea, for at least two reasons.  First, to actually get the memory overhead
savings you allocate at stack switch time.  If that allocation can't be
satisfied you are in *trouble* because you might not be able to switch over to
a fibril that is trying to free up memory.  Deadlock city.  Second, it means
that *you can't reference on-stack data in the wake-up path*.  This is a
nightmare.  Even our trivial sys_nanosleep() example would have had to take its
hrtimer_sleeper off the stack and allocate it.  Never mind, you know, basically
every single user of <linux/wait.h>.   My current thinking is that it's just
not worth it.

- We would now have some measure of task_struct concurrency.  Read that twice,
it's scary.  As two fibrils execute and block in turn they'll each be
referencing current->.  It means that we need to audit task_struct to make sure
that paths can handle racing as its scheduled away.  The current implementation
*does not* let preemption trigger a fibril switch.  So one only has to worry
about racing with voluntary scheduling of the fibril paths.  This can mean
moving some task_struct members under an accessor that hides them in a struct
in task_struct so they're switched along with the fibril.  I think this is a
manageable burden.

- The fibrils can only execute in the submitter's task_struct.  While I think
this is in fact a feature, it does imply some interesting behaviour.
Submitters will be required to explicitly manage any concurrent between CPUs by
issuing their ops in tasks.  To guarantee forward-progress in syscall handling
paths (releasing i_mutex, say) we'll have to interrupt userspace when a fibril
is ready to run.

- Signals.  I have no idea what behaviour we want.  Help?  My first guess is
that we'll want signal state to be shared by fibrils by keeping it in the
task_struct.  If we want something like individual cancellation,  we'll augment
signal_pending() with some some per-fibril test which will cause it to return
from TASK_INTERRUPTIBLE (the only reasonable way to implement generic
cancellation, I'll argue) as it would have if a signal was pending.

- lockdep and co. will need to be updated to track fibrils instead of tasks.
sysrq-t might want to dump fibril stacks, too.  That kind of thing.  Sorry.

As for the current implementation, it's obviously just a rough sketch.  I'm
sending it out in this state because this is the first point at which a tree
walker using AIO openat(), fstat(), and getdents() actually worked on ext3.
Generally, though, these are paths that I don't have the most experience in.
I'd be thrilled to implement whatever the experts think is the right way to do
this. 

Blah blah blah.  Too much typing.  What do people think?

--===============0152984906==--
