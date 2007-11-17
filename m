Return-Path: <linux-kernel-owner+w=401wt.eu-S1758784AbXKQOI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758784AbXKQOI7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 09:08:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752845AbXKQOIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 09:08:51 -0500
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:48882 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbXKQOIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 09:08:50 -0500
Date: Sat, 17 Nov 2007 09:08:18 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Remy Bohmer <linux@bohmer.net>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       RT <linux-rt-users@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [BUG on PREEMPT_RT, 2.6.23.1-rt5] in rt-mutex code and signals
In-Reply-To: <3efb10970711170344n670d8b69w6679d494922c5bb@mail.gmail.com>
Message-ID: <Pine.LNX.4.58.0711170840130.4453@gandalf.stny.rr.com>
References: <3efb10970711160751l279fe99dl9f3a130a4373a449@mail.gmail.com>
 <Pine.LNX.4.58.0711161516580.25989@gandalf.stny.rr.com>
 <3efb10970711161502m6216bf5rc19a34184b4f3a2b@mail.gmail.com>
 <Pine.LNX.4.58.0711161830570.28002@gandalf.stny.rr.com>
 <3efb10970711170344n670d8b69w6679d494922c5bb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 17 Nov 2007, Remy Bohmer wrote:

> Hello Steven,
>
> > The taker of a mutex must also be the one that releases it.  I don't see
> > how you could use a mutex for this. It really requires some kind of
> > completion, or a compat_semaphore.
>
> I tried several ways of working around the bug, even tried
> implementing it with kernel threads and protecting global data with
> mutexes. Therefor I know that I have the same problem with mutexes. I
> just created a simple example that showed the problem quickly, this
> does not mean that this is the only case that does not work.
>
> BTW: I am hacking around in the PREEMPT-RT kernel for years now, I
> know the history very well, and I know what I am doing... Please, do
> not find holes in the example I quickly hacked together, please focus
> on the OOPS message, and help me figuring out what is causing this. I
> can give you other examples of code that shows the same problem. But,
> basically, every call that blocks with _inturruptible() on a rt-mutex
> beneath the surface in the context of a user space process (and
> receives a signal during the block) shows the same problem.

Please don't think that I just took your example to find a hole in it.

Actually, the reason I pointed that out was not because of "Oh, this
example is broken", but because of the description of the problem you
are trying to solve. To me, it needs to be done with a completion or
compat_semaphore otherwise it will become very complex in solving.

>
> > Exactly why it should be a completion or compat semaphores. The reason we
> > did PI on semaphores is only because they were used as mutexes before Ingo
> > pushed to actually get a mutex primative into the kernel. Since then,
> > we've been trying to remove all semaphores with either a mutex or
> > completion.
>
> Okay, sounds fair. But: the current implementation does counting the
> number of up's and down's, suggesting that it really behaves like a
> semaphore. It only does some special things during the transition of
> the counter from 0->1 and from 1->0. If this counting is illegal use
> of the mutex mechanism, it should report (compile) errors if:
> * sema_init is used on 'struct semaphore' -> init_MUTEX() must be used instead.
> * sema_init should only be used on 'struct compat_semaphore' types.
> * calls to up() and down() in a row should report a BUG message,
> * if up() is called from a different thread than the down() it should
> report a BUG message. Further, the counting up's and down's are not
> allowed on struct semphore types, so it should be removed from the
> code.

It should print out warnings, do you have CONFIG_DEBUG_RT_MUTEXES set?

> * PI should only take place if it is for 100% sure that the 'struct
> semaphore' is used as a mutex. And this is only the case when it is
> initialised with init_MUTEX().

Well, we can't determine that with code ;-)  Remember, there are still
drivers out in the world that use semaphores as mutexes. So the PI
on semaphores is really more of a compatibility issue.

>
> So, because all these items are not there, I doubt it is really true
> that it is illegal to use 'struct semaphore' types as counting
> semaphores across multiple threads. BESIDES: Everything works fine
> UNTIL a signal is generated during a block on the semaphore. I think
> Ingo tried to make the 'struct semaphore' type to behave like the
> non-RT kernel 'struct semaphore', which actually does NOT show this
> problem wtih my example driver!!!

Right, because a non-RT semaphore _is_ a compat_semaphore. I'm saying if
you see the bug in your driver with the compat_semaphore then lets debug
that. Because that _is_ a bug!


>
> So, this is a regression if exactly the same driver is used in both
> non-preempt-rt patched kernel and preempt-rt patched kernels.

Not really.  There are things that the preempt-rt kernels require. One, is
that things that need to keep semaphores instead of using them as mutexes,
they should be converted to compat_semaphores.  Perhaps now that we have
mutexes, we can remove the PI on semaphores, and out-of-tree drivers will
need to make sure they don't use semaphores as mutexes anymore.

>
> >         down_interruptible(&dummy);
> >         printk("We will block now, and if you press CTRL-C from here, we get an OOPS.\n");
> >         down_interruptible(&dummy);
> >
> > This double down is actually illegal with rt semaphores. Because we treat
> > semaphores as mutexes unless they are declared as compat_semaphores. In
> > which case we don't do PI.
>
> According to code there is a counting mechanism there, which suggest
> that this is allowed to do. It works fine, until a signal arrives.the
> SIGNAL is the only problem here!

Yeah, that code is more of a hack to convert counting semaphores into
mutexes. But semaphores still need to have owners, and they should not
block on themselves. That may be where the bug is.

>
> > Seems that you need to work out how to use a completion for your code. And
> > if that doesn't work, then use a compat_semaphore. But beware, that the
> > compat_semaphore can cause unbounded latencies. But then again, so can
> > completions.
>
> I hope you get my point now. Other mechanisms like ordinary rt-mutexes
> show the same problem, so either case: Please help me figuring out
> which bug the signal is triggering here.

OK, I wont be able to work on this this weekend, but I'll try to get to it
on Monday.  A better example to show the bug you are looking for is simply
create a mutex and create a thread that grabs that mutex and goes to
sleep. Have your driver read grab that mutex with
mutex_lock_interruptible. And if the signal code is broken with this, then
you definitely got a point that the inerruptible code is broken.

This will keep the semantics clean and not obfuscate it with the semaphore
code.

I'll write up that example on Monday if you don't have the time.

Note, that the unloading of the module should wake up the thread that
grabbed the mutex so it can release it.

-- Steve
