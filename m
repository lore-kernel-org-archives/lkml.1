Return-Path: <linux-kernel-owner+w=401wt.eu-S1759458AbXKQPHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759458AbXKQPHv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 10:07:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753360AbXKQPHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 10:07:43 -0500
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:60883 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbXKQPHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 10:07:42 -0500
Date: Sat, 17 Nov 2007 10:06:54 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Remy Bohmer <linux@bohmer.net>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       RT <linux-rt-users@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [BUG on PREEMPT_RT, 2.6.23.1-rt5] in rt-mutex code and signals
In-Reply-To: <Pine.LNX.4.58.0711170840130.4453@gandalf.stny.rr.com>
Message-ID: <Pine.LNX.4.58.0711170952360.10044@gandalf.stny.rr.com>
References: <3efb10970711160751l279fe99dl9f3a130a4373a449@mail.gmail.com>
 <Pine.LNX.4.58.0711161516580.25989@gandalf.stny.rr.com>
 <3efb10970711161502m6216bf5rc19a34184b4f3a2b@mail.gmail.com>
 <Pine.LNX.4.58.0711161830570.28002@gandalf.stny.rr.com>
 <3efb10970711170344n670d8b69w6679d494922c5bb@mail.gmail.com>
 <Pine.LNX.4.58.0711170840130.4453@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 17 Nov 2007, Steven Rostedt wrote:
> On Sat, 17 Nov 2007, Remy Bohmer wrote:
> > * PI should only take place if it is for 100% sure that the 'struct
> > semaphore' is used as a mutex. And this is only the case when it is
> > initialised with init_MUTEX().
>
> Well, we can't determine that with code ;-)  Remember, there are still
> drivers out in the world that use semaphores as mutexes. So the PI
> on semaphores is really more of a compatibility issue.
>

Oh, I missed your point here. I was up late last night so I'm blaming that
for my _not_so_thorough_ reading ;-)

You are saying that we should change the semaphore to a mutex only if it
was initialized by init_MUTEX(). I see your point.

Actually, if something is initialized by init_MUTEX it really needs to be
a mutex :-)

Right now the compiler determines that something is a mutex or a
semaphore. If we make it a run time option, that will add more complexity
to the code and probably make it less efficient. The more complex part
is something we can deal with. The less efficient part we can not.

find .  -name "*.c" ! -type d  | xargs grep  "init_MUTEX" | wc -l
100

Heh, nice number.

Well, I guess I could start sending patches to mainline to convert
semaphores to mutexes. I'm sure that will probably annoy akpm, but I'll do
it one at a time, with lots of thought behind each change.

BTW, drivers breaking with the RT patch is not always considered a
regression.

For example, this is fine in vanilla kernel:

  local_irq_save(flags);
  [...]
  spin_lock(&lock);

Where as in the RT patch, that would break. And it would require either
changing the local_irq_save to a local_irq_save_nort, or find a way to do
the spin_lock_irqsave(&lock, flags) instead.

-- Steve


