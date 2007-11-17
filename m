Return-Path: <linux-kernel-owner+w=401wt.eu-S1760565AbXKQLoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760565AbXKQLoo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 06:44:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754385AbXKQLof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 06:44:35 -0500
Received: from py-out-1112.google.com ([64.233.166.176]:54257 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754280AbXKQLoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 06:44:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=JAJw+g4WQ6il4noC+ltAPrM8BZWb579syZxIS6X5W/MdyDlRA5monScjERkw2zd542xZNm50Pn4osN+NxIiUIXE6inuyWhYB0llV1WuCZOQ+Om2T1GZSk2ejtgT7bk++uHOhrA9ET3f/UQkBxtnOiVZj3tPYYhXyUyqMEDXpbSM=
Message-ID: <3efb10970711170344n670d8b69w6679d494922c5bb@mail.gmail.com>
Date: Sat, 17 Nov 2007 12:44:32 +0100
From: "Remy Bohmer" <linux@bohmer.net>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [BUG on PREEMPT_RT, 2.6.23.1-rt5] in rt-mutex code and signals
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       RT <linux-rt-users@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.58.0711161830570.28002@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3efb10970711160751l279fe99dl9f3a130a4373a449@mail.gmail.com>
	 <Pine.LNX.4.58.0711161516580.25989@gandalf.stny.rr.com>
	 <3efb10970711161502m6216bf5rc19a34184b4f3a2b@mail.gmail.com>
	 <Pine.LNX.4.58.0711161830570.28002@gandalf.stny.rr.com>
X-Google-Sender-Auth: 8b7432a22a96b08d
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Steven,

> The taker of a mutex must also be the one that releases it.  I don't see
> how you could use a mutex for this. It really requires some kind of
> completion, or a compat_semaphore.

I tried several ways of working around the bug, even tried
implementing it with kernel threads and protecting global data with
mutexes. Therefor I know that I have the same problem with mutexes. I
just created a simple example that showed the problem quickly, this
does not mean that this is the only case that does not work.

BTW: I am hacking around in the PREEMPT-RT kernel for years now, I
know the history very well, and I know what I am doing... Please, do
not find holes in the example I quickly hacked together, please focus
on the OOPS message, and help me figuring out what is causing this. I
can give you other examples of code that shows the same problem. But,
basically, every call that blocks with _inturruptible() on a rt-mutex
beneath the surface in the context of a user space process (and
receives a signal during the block) shows the same problem.

> Exactly why it should be a completion or compat semaphores. The reason we
> did PI on semaphores is only because they were used as mutexes before Ingo
> pushed to actually get a mutex primative into the kernel. Since then,
> we've been trying to remove all semaphores with either a mutex or
> completion.

Okay, sounds fair. But: the current implementation does counting the
number of up's and down's, suggesting that it really behaves like a
semaphore. It only does some special things during the transition of
the counter from 0->1 and from 1->0. If this counting is illegal use
of the mutex mechanism, it should report (compile) errors if:
* sema_init is used on 'struct semaphore' -> init_MUTEX() must be used instead.
* sema_init should only be used on 'struct compat_semaphore' types.
* calls to up() and down() in a row should report a BUG message,
* if up() is called from a different thread than the down() it should
report a BUG message. Further, the counting up's and down's are not
allowed on struct semphore types, so it should be removed from the
code.
* PI should only take place if it is for 100% sure that the 'struct
semaphore' is used as a mutex. And this is only the case when it is
initialised with init_MUTEX().

So, because all these items are not there, I doubt it is really true
that it is illegal to use 'struct semaphore' types as counting
semaphores across multiple threads. BESIDES: Everything works fine
UNTIL a signal is generated during a block on the semaphore. I think
Ingo tried to make the 'struct semaphore' type to behave like the
non-RT kernel 'struct semaphore', which actually does NOT show this
problem wtih my example driver!!!

So, this is a regression if exactly the same driver is used in both
non-preempt-rt patched kernel and preempt-rt patched kernels.

>         down_interruptible(&dummy);
>         printk("We will block now, and if you press CTRL-C from here, we get an OOPS.\n");
>         down_interruptible(&dummy);
>
> This double down is actually illegal with rt semaphores. Because we treat
> semaphores as mutexes unless they are declared as compat_semaphores. In
> which case we don't do PI.

According to code there is a counting mechanism there, which suggest
that this is allowed to do. It works fine, until a signal arrives.the
SIGNAL is the only problem here!

> Seems that you need to work out how to use a completion for your code. And
> if that doesn't work, then use a compat_semaphore. But beware, that the
> compat_semaphore can cause unbounded latencies. But then again, so can
> completions.

I hope you get my point now. Other mechanisms like ordinary rt-mutexes
show the same problem, so either case: Please help me figuring out
which bug the signal is triggering here.


Kind Regards,

Remy Bohmer


2007/11/17, Steven Rostedt <rostedt@goodmis.org>:
>
>
>
> On Sat, 17 Nov 2007, Remy Bohmer wrote:
>
> > Hello Steven,
> >
> > Thanks for your reply
> >
> > > The above sounds more like you need a completion.
> > Funny, I first started with using completion structures, but that did
> > not work either. I get similar OOPses on all these kind of locking
> > mechanisms, as long as I use the _interruptible() type. I tried every
> > work-around I can think of, but none worked :-((
> > Even if I block on an ordinary rt-mutex in the same routine, wait a
> > _interruptible() type, I get the same problem.
>
> The taker of a mutex must also be the one that releases it.  I don't see
> how you could use a mutex for this. It really requires some kind of
> completion, or a compat_semaphore.
>
> >
> > > What's used to wake up the caller of down_interruptible?
> > A call to up() is used from inside an interrupt(thread) context, but
> > this is not relevant for the problem, because only blocking on a
> > semaphore with down_interruptible() and waking the thread by CTRL-C is
> > enough to get this Oops.
> >
> > I saw that the code is trying to wake 'other waiters', while there is
> > only 1 thread waiting on the semaphore at most. I feel that the root
> > cause of this problem has to be searched there.
> >
> > I believe that executing any PI code on semaphores is a strange
> > behavior anyway, because a semaphore is never 'owned' by a thread, and
> > it is always another thread that wakes the thread that blocks on a
> > semaphore, and because the waker is unknown, the PI code will always
> > boost the prio of the wrong thread.
>
> Exactly why it should be a completion or compat semaphores. The reason we
> did PI on semaphores is only because they were used as mutexes before Ingo
> pushed to actually get a mutex primative into the kernel. Since then,
> we've been trying to remove all semaphores with either a mutex or
> completion.
>
> >
> > Strange is also, that I get different behavior on ARM if I use
> > sema_init(&sema, 1) versus sema_init(&sema,0). The latter seems to
> > crash less, it will not crash until the first up(); while the first
> > will crash even without any up().
> >
> > Attached I have put a sample driver I just hacked together a few
> > minutes ago. It is NOT the driver that has generates the oops in the
> > previous mail, but I have stripped a scull-driver down that much that
> > it will be much easier to talk about, and to keep us focussed on the
> > part of the code that is causing this.
> > Besides: I tested this driver on X86 with 2.6.23.1-rt5 and I get the
> > also OOPSes although slightly different than on ARM. See the attached
> > dummy.txt file.
> >
> >
> > Beware: The up(&sema) is NOT required to get this OOPS, I get it even
> > without any up(&sema) !
> >
> > I hope you can look at the attached driver source and help me with this...
> >
>
>         down_interruptible(&dummy);
>         printk("We will block now, and if you press CTRL-C from here, we get an OOPS.\n");
>         down_interruptible(&dummy);
>
>
> This double down is actually illegal with rt semaphores. Because we treat
> semaphores as mutexes unless they are declared as compat_semaphores. In
> which case we don't do PI.
>
> Seems that you need to work out how to use a completion for your code. And
> if that doesn't work, then use a compat_semaphore. But beware, that the
> compat_semaphore can cause unbounded latencies. But then again, so can
> completions.
>
>
> -- Steve
>
>
