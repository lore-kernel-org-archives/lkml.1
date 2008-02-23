Return-Path: <linux-kernel-owner+w=401wt.eu-S1762743AbYBWTl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762743AbYBWTl1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 14:41:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754813AbYBWTlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 14:41:19 -0500
Received: from wr-out-0506.google.com ([64.233.184.230]:42294 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755507AbYBWTlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 14:41:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XjedaW1ElmjBIoGVkzVXeV1ldCZiUlFHM0SKtgZ9/KG8snbl+TNvDhOBfE2B/TOs4VSb+7sfJcDj4OulJRY5wNzQ8jigZ4HMNj3j9yEbd3rxL3NfC6qHS/MjT78IfX6hz/KOlZ7yBEEJuugBgcCytcIApuF9slXnCL04OhDGjdA=
Message-ID: <b647ffbd0802231141y4088b8e5g793a1a186a56871d@mail.gmail.com>
Date: Sat, 23 Feb 2008 20:41:15 +0100
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: + kthread-add-a-missing-memory-barrier-to-kthread_stop.patch added to -mm tree
Cc: "Oleg Nesterov" <oleg@tv-sign.ru>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, apw@shadowen.org,
       mingo@elte.hu, nickpiggin@yahoo.com.au, paulmck@linux.vnet.ibm.com,
       rusty@rustcorp.com.au, "Steven Rostedt" <rostedt@goodmis.org>
In-Reply-To: <alpine.LFD.1.00.0802230937530.21332@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200802230733.m1N7XnMu018253@imap1.linux-foundation.org>
	 <20080223162705.GA7686@tv-sign.ru>
	 <alpine.LFD.1.00.0802230937530.21332@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/02/2008, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>  On Sat, 23 Feb 2008, Oleg Nesterov wrote:
>  >
>
> > In short: wake_up_process() doesn't imply mb(), this means that _in theory_
>  > the commonly used code like
>  >
>  >       set_current_state(TASK_INTERRUPTIBLE);
>  >       if (CONDITION)
>  >               return;
>  >       schedule();
>  >
>  > is racy wrt
>  >
>  >       CONDITION = 1;
>  >       wake_up_process(p);
>  >
>  > I'll be happy to be wrong though, please correct me.
>
>
> Well, you should be wrong on x86, because the spinlock at the head of
>  wake_up_process() (well, "try_to_wake_up()" to be exact) will be a full
>  memory barrier.
>
>  But yeah, in general spinlocks can have weaker semantics, and let
>  preceding writes percolate into the critical section and thus past the
>  point that actually sets task->state.
>
>  And I do agree that we should *not* add a memory barrier in the caller
>  (that's just going to be really confusing for everybody, and make these
>  things much harder than they should be), and we should make sure that the
>  above sequence is always race-free.
>
>  I also think that a full memory barrier is overkill. We should be ok with
>  just adding a write barrier to the top of wake_up_process(), no?

No, wmb is not enough. I've provided an explanation in the original thread.
(http://groups.google.com/group/fa.linux.kernel/browse_thread/thread/44c45685680585fc/e58785df0eeee6f8?lnk=raot)

Actually, there seems to be _no_ problem at all, provided a task to be
woken up is _not_ running on another CPU at the exact moment of
wakeup.

Why?

shared_data = new;
wake_up_task(p);

(1) try_to_wake_up() holds a lock of the runqueue on which 'p' is to-be-placed ;

(2) it's _guaranteed_ that 'shared_data' will be updated by the moment
any UNLOCK is called  -- in our case, try_to_wake_up(p) calls
unlock(&rq->lock);

(3) for 'p' to start running, something must call schedule() -> which
will take 'rq->lock'... and 'rq' is the same as in (2).

IOW, 'p' can't start running untill try_to_wake_up(p) releases
'rq->lock', and as said in (2), that implies that 'shared_data' will
be up-to-date by this moment.

IOW #2, 'rq->lock' is kind of a synchronization point/'barrier' in this case.

does it make sense now?

Another point is if 'p' is actually _running_ on another CPU at the
time when we do try_to_wake_up()... and I guess, the potential problem
is only relevant for situations like below:

CPU #0:

EIP_1 ---> (*)   /* so 'p' is at this point now */

set_current_state(TASK_INTERRUPTIBLE);

if (shared_data == magic)
        schedule();


CPU #1:

shared_data = magic;
try_to_wake_up(p);

now the problem is if 'p->state' (inside try_to_wake_up()) will be
loaded _before_ 'shared_data' has been updated.

recall, we are about to execute set_current_state(TASK_INTERRUPTIBLE)
on CPU #0...

so

p->state is still TASK_RUNNING, meaning that try_to_wake_up() just
exits ! (nothing to be done)

in the mean time,

on CPU #0: set_current_state(TASK_INTERRUPTIBLE) is called.

shared_data is checked _but_ it's still an old value (CPU #1 is still
inside try_to_wake_up(p))
so we call schedule() and go to sleep...

i.e. we actually lost a wakeup.

to sum it up, for the following scheme to work:

set_current_state(TASK_INTERRUPTIBLE);  <--- here we have a smb_mb()
if (condition)
        schedule();

effectively => (1) MODIFY(current->state) ; (2) LOAD(condition)

and a wake_up path must ensure access (LOAD or MODIFY) to the same
data happens in the _reverse_ order:

condition = new;
smb_mb();
try_to_wake_up();

=> (1) MODIFY(condition); (2) LOAD(current->state)

try_to_wake_up() does not need to be a full mb per se, the only
requirement (and only for situation like above) is that there is a
full mb between possible write ops. that have taken place before
try_to_wake_up() _and_ a load of p->state inside try_to_wake_up().

does it make sense #2 ? :-)

(yeah, maybe I'm just too paranoid :-)


>
>                         Linus
>

-- 
Best regards,
Dmitry Adamushko
