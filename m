Return-Path: <linux-kernel-owner+w=401wt.eu-S1755575AbZDXPIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575AbZDXPIW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 11:08:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbZDXPIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 11:08:13 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:58712 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654AbZDXPIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 11:08:12 -0400
Date: Fri, 24 Apr 2009 08:08:09 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       torvalds@osdl.org, Andrew Morton <akpm@linux-foundation.org>,
       serue@us.ibm.com, viro@zeniv.linux.org.uk,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] It may not be assumed that wake_up(), finish_wait()
	and co. imply a memory barrier
Message-ID: <20090424150809.GA6754@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090413181733.GA10424@redhat.com> <32260.1239658818@redhat.com> <20090413214852.GA1127@redhat.com> <1239659841.16771.26.camel@heimdal.trondhjem.org> <20090413222451.GA2758@redhat.com> <14561.1239873018@redhat.com> <21239.1240407420@redhat.com> <5591.1240417398@redhat.com> <21209.1240504344@redhat.com> <26028.1240573601@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26028.1240573601@redhat.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 24, 2009 at 12:46:41PM +0100, David Howells wrote:
> Oleg Nesterov <oleg@redhat.com> wrote:
> 
> > Well. I am starting to suspect I missed something, but I disagree. Or I just
> > (this is very possible) misunderstand the above.
> 
> No, it's me getting myself confused.  After thinking about it for a while, I
> see that you're right: the potential misordering, I think, is between the
> setting of the task state and reading the data value in the sleeper, and
> between the writing of the data value and the clearing of the task state in
> the waker.
> 
> That means that provided that:
> 
>  (1) set_current_state() interpolates a full memory barrier after setting the
>      task state then there's no problem in the sleeper, and
> 
>  (2) wake_up() interpolates a write memory barrier before clearing the task
>      state - _if_ it wakes anything up - then there's no problem in the waker
>      either.
> 
> How about the attached doc patch?

One question, assuming that this documentation intends to guide the
reader on where to put the locking and/or memory-barrier primitives...

Suppose we have the following sequence of events:

1.	The waiter does "set_current_state(TASK_UNINTERRUPTIBLE);".
	This implies a full memory barrier.

2.	The awakener updates some shared state.

3.	The awakener does "event_indicated = 1;".

4.	The waiter does "if (event_indicated)", and, finding that
	the event has in fact been indicated, does "break".

5.	The waiter accesses the shared state set in #2 above.

6.	Some time later, the awakener does "wake_up(&event_wait_queue);"
	This does not awaken anyone, so no memory barrier.

Because there is no memory barrier between #2 and #3, reordering by
either the compiler or the CPU might cause the awakener to update the
event_indicated flag in #3 -before- completing its update of shared
state in #2.  Less likely (but still possible) optimizations might
cause the waiter to access the shared state in #5 before checking
the event_indicated flag in #4.

So, for this to work correctly, don't we need at least an smp_wmb()
between #2 and #3 and at least an smp_rmb() between #4 and #5?  And if
#2 does reads (but not writes) at least one variable in the shared state
that #5 writes to, don't both barriers need to be smp_mb()?

Or should I have waited until fully waking up before replying to this
email?  ;-)

For everyone's amusement, I have placed these memory barriers in the code
samples below.

And, yes, if these primitives are used with appropriate locks, then no
memory barriers are required.  So, again, for everyone's amusement, I
have indicated where the locking primitives would go -- not necessarily
where the memory barriers go due to the semipermeable nature of the
barriers implied by the locking primitives.

If I understand the purpose of this documentation, it would be good to
tell the reader where the required locks and/or memory barriers must go.

							Thanx, Paul

> David
> ---
> From: David Howells <dhowells@redhat.com>
> Subject: [PATCH] Document memory barriers implied by sleep/wake-up primitives
> 
> Add a section to the memory barriers document to note the implied memory
> barriers of sleep primitives (set_current_state() and wrappers) and wake-up
> primitives (wake_up() and co.).
> 
> Also extend the in-code comments on the wake_up() functions to note these
> implied barriers.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  Documentation/memory-barriers.txt |   93 +++++++++++++++++++++++++++++++++++++
>  kernel/sched.c                    |   23 +++++++++
>  2 files changed, 115 insertions(+), 1 deletions(-)
> 
> 
> diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
> index f5b7127..48d3c77 100644
> --- a/Documentation/memory-barriers.txt
> +++ b/Documentation/memory-barriers.txt
> @@ -31,6 +31,7 @@ Contents:
> 
>       - Locking functions.
>       - Interrupt disabling functions.
> +     - Sleep and wake-up functions.
>       - Miscellaneous functions.
> 
>   (*) Inter-CPU locking barrier effects.
> @@ -1217,6 +1218,96 @@ barriers are required in such a situation, they must be provided from some
>  other means.
> 
> 
> +SLEEP AND WAKE-UP FUNCTIONS
> +---------------------------
> +
> +Sleeping and waking on an event flagged in global data can be viewed as an
> +interaction between two pieces of data: the task state of the task waiting for
> +the event and the global data used to indicate the event.  To make sure that
> +these appear to happen in the right order, the primitives to begin the process
> +of going to sleep, and the primitives to initiate a wake up imply certain
> +barriers.
> +
> +Firstly, the sleeper normally follows something like this sequence of events:
> +
> +	for (;;) {
> +		set_current_state(TASK_UNINTERRUPTIBLE);
> +		if (event_indicated)
> +			break;
> +		schedule();
> +	}
	smp_rmb(); /* or smp_mb() if writing later, or spin_lock(). */
> +
> +A general memory barrier is interpolated automatically by set_current_state()
> +after it has altered the task state:
> +
> +	CPU 1
> +	===============================
> +	set_current_state();
> +	  set_mb();
> +	    STORE current->state
> +	    <general barrier>
> +	LOAD event_indicated
> +
> +set_current_state() may be wrapped by:
> +
> +	prepare_to_wait();
> +	prepare_to_wait_exclusive();
> +
> +which therefore also imply a general memory barrier after setting the state.
> +The whole sequence above is available in various canned forms, all of which
> +interpolate the memory barrier in the right place:
> +
> +	wait_event();
> +	wait_event_interruptible();
> +	wait_event_interruptible_exclusive();
> +	wait_event_interruptible_timeout();
> +	wait_event_killable();
> +	wait_event_timeout();
> +	wait_on_bit();
> +	wait_on_bit_lock();
> +
> +
> +Secondly, code that performs a wake up normally follows something like this:
> +
	smp_wmb(); /* or smp_mb() if trailing prior read to a variable.  */
> +	event_indicated = 1;
> +	wake_up(&event_wait_queue);
> +
> +or:
> +
	smp_wmb(); /* or smp_mb() if trailing prior read to a variable.  */
> +	event_indicated = 1;
	/* Or spin_unlock() here instead. */
> +	wake_up_process(event_daemon);
> +
> +A write memory barrier is implied by wake_up() and co. if and only if they wake
> +something up.  The barrier occurs before the task state is cleared, and so sits
> +between the STORE to indicate the event and the STORE to set TASK_RUNNING:
> +
> +	CPU 1				CPU 2
> +	===============================	===============================
> +	set_current_state();		STORE event_indicated
> +	  set_mb();			wake_up();
> +	    STORE current->state	  <write barrier>
> +	    <general barrier>		  STORE current->state
> +	LOAD event_indicated
> +
> +The available waker functions include:
> +
> +	complete();
> +	wake_up();
> +	wake_up_all();
> +	wake_up_bit();
> +	wake_up_interruptible();
> +	wake_up_interruptible_all();
> +	wake_up_interruptible_nr();
> +	wake_up_interruptible_poll();
> +	wake_up_interruptible_sync();
> +	wake_up_interruptible_sync_poll();
> +	wake_up_locked();
> +	wake_up_locked_poll();
> +	wake_up_nr();
> +	wake_up_poll();
> +	wake_up_process();
> +
> +
>  MISCELLANEOUS FUNCTIONS
>  -----------------------
> 
> @@ -1366,7 +1457,7 @@ WHERE ARE MEMORY BARRIERS NEEDED?
> 
>  Under normal operation, memory operation reordering is generally not going to
>  be a problem as a single-threaded linear piece of code will still appear to
> -work correctly, even if it's in an SMP kernel.  There are, however, three
> +work correctly, even if it's in an SMP kernel.  There are, however, four
>  circumstances in which reordering definitely _could_ be a problem:
> 
>   (*) Interprocessor interaction.
> diff --git a/kernel/sched.c b/kernel/sched.c
> index b902e58..fd0c2ce 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -2458,6 +2458,17 @@ out:
>  	return success;
>  }
> 
> +/**
> + * wake_up_process - Wake up a specific process
> + * @p: The process to be woken up.
> + *
> + * Attempt to wake up the nominated process and move it to the set of runnable
> + * processes.  Returns 1 if the process was woken up, 0 if it was already
> + * running.
> + *
> + * It may be assumed that this function implies a write memory barrier before
> + * changing the task state if and only if any tasks are woken up.
> + */
>  int wake_up_process(struct task_struct *p)
>  {
>  	return try_to_wake_up(p, TASK_ALL, 0);
> @@ -5241,6 +5252,9 @@ void __wake_up_common(wait_queue_head_t *q, unsigned int mode,
>   * @mode: which threads
>   * @nr_exclusive: how many wake-one or wake-many threads to wake up
>   * @key: is directly passed to the wakeup function
> + *
> + * It may be assumed that this function implies a write memory barrier before
> + * changing the task state if and only if any tasks are woken up.
>   */
>  void __wake_up(wait_queue_head_t *q, unsigned int mode,
>  			int nr_exclusive, void *key)
> @@ -5279,6 +5293,9 @@ void __wake_up_locked_key(wait_queue_head_t *q, unsigned int mode, void *key)
>   * with each other. This can prevent needless bouncing between CPUs.
>   *
>   * On UP it can prevent extra preemption.
> + *
> + * It may be assumed that this function implies a write memory barrier before
> + * changing the task state if and only if any tasks are woken up.
>   */
>  void __wake_up_sync_key(wait_queue_head_t *q, unsigned int mode,
>  			int nr_exclusive, void *key)
> @@ -5315,6 +5332,9 @@ EXPORT_SYMBOL_GPL(__wake_up_sync);	/* For internal use only */
>   * awakened in the same order in which they were queued.
>   *
>   * See also complete_all(), wait_for_completion() and related routines.
> + *
> + * It may be assumed that this function implies a write memory barrier before
> + * changing the task state if and only if any tasks are woken up.
>   */
>  void complete(struct completion *x)
>  {
> @@ -5332,6 +5352,9 @@ EXPORT_SYMBOL(complete);
>   * @x:  holds the state of this particular completion
>   *
>   * This will wake up all threads waiting on this particular completion event.
> + *
> + * It may be assumed that this function implies a write memory barrier before
> + * changing the task state if and only if any tasks are woken up.
>   */
>  void complete_all(struct completion *x)
>  {
