Return-Path: <linux-kernel-owner+w=401wt.eu-S1946023AbXBBTsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946023AbXBBTsM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 14:48:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423203AbXBBTsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 14:48:12 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:42040 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1423188AbXBBTsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 14:48:11 -0500
Date: Fri, 2 Feb 2007 19:59:32 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Zach Brown <zach.brown@oracle.com>,
       linux-kernel@vger.kernel.org, linux-aio@kvack.org,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
Message-ID: <20070202195932.15b9b4ed@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0702020738500.15057@woody.linux-foundation.org>
References: <patchbomb.1170193181@tetsuo.zabbo.net>
	<df7bc026d50ec5bbdd8e.1170193183@tetsuo.zabbo.net>
	<20070201083611.GC18233@elte.hu>
	<Pine.LNX.4.64.0702011154110.3632@woody.linux-foundation.org>
	<20070202104900.GA13941@elte.hu>
	<Pine.LNX.4.64.0702020738500.15057@woody.linux-foundation.org>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This one got shelved while I sorted other things out as it warranted a
longer look. Some comments follow, but firstly can we please bury this
"fibril" name. The constructs Zach is using appear to be identical to
co-routines, and they've been called that in computer science literature
for fifty years. They are one of the great and somehow forgotten ideas.
(and I admit I've used them extensively in past things where its
wonderful for multi-player gaming so I'm a convert already).

The stuff however isn't as free as you make out. Current kernel logic
knows about various things being "safe" but with fibrils you have to
address additional questions such as "What happens if I issue an I/O and
change priority". You also have an 800lb gorilla hiding behind a tree
waiting for you in priviledge and permission checking.

Right now current->*u/gid is safe across a syscall start to end, with an
asynchronous setuid all hell breaks loose. I'm not saying we shouldn't do
this, in fact we'd be able to do some of the utterly moronic poxix thread
uid handling in kernel space if we did, just that it isn't free. We have
locking rules defined by the magic serializing construct called
"the syscall" and you break those.

I'd expect the odd other gorilla waiting to mug you as well and the ones
nobody has thought of will be the worst 8)

The number of co-routines and stacks can be dealt with two ways - you use
small stacks allocated when you create a fibril, or you grab a page, use
separate IRQ stacks and either fail creation with -ENOBUFS etc which
drops work on user space, or block (for which cases ??) which also means
an overhead on co-routine exits. That can be tunable, for embedded easily
tuned right down.

Traditional co-routines have clear notions of being able to create a
co-routine, stack them and fire up specific ones. In part this is done
because many things expressed in this way know what to fire up next. It's
also a very clean way to express driver problem with a lot of state

Essentially as a co-routine is simply making "%esp" roughly the same as
the C++ world's "self". 

You get some other funny things from co-routines which are very powerful,
very dangerous, or plain insane depending upon your view of life. One big
one is the ability for real men (and women) to do stuff like this,
because you don't need to keep the context attached to the same task.

	send_reset_command(dev);
	wait_for_irq_event(dev->irq);
	/* co-routine continues in IRQ context here */
	clean_up_reset_command(dev);
	exit_irq_event();
	/* co-routine continues out of IRQ context here */
	send_identify_command(dev);

Notice we just dealt with all the IRQ stack problems the moment an IRQ is
a co-routine transfer 8)

Ditto with timers, although for the kernel that might not be smart as we
have a lot of timers.

Less insanely you can create a context, start doing stuff in it and then
pass it to someone else local variables, state and all. This one is
actually rather useful for avoiding a lot of the 'D' state crap in the
kernel.

For example we have driver code that sleeps uninterruptibly because its
too hard to undo the mess and get out of the current state if it is
interrupted. In the world of sending other people co-routines you just do
this

	coroutine_set(MUST_COMPLETE);

and in exit

	foreach(coroutine)
		if(coroutine->flags & MUST_COMPLETE)
			inherit_coroutine(init, coroutine);

and obviously you don't pass any over that will then not do the right
thing before accessing user space (well unless implementing
'read_for_someone_else()' or other strange syscalls - like ptrace...)

Other questions really relate to the scheduling - Zach do you intend
schedule_fibrils() to be a call code would make or just from schedule() ?


Linus will now tell me I'm out of my tree...


Alan (who used to use Co-routines in real languages on 36bit
computers with 9bit bytes before learning C)
