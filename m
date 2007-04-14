Return-Path: <linux-kernel-owner+w=401wt.eu-S1751861AbXDNRpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861AbXDNRpq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 13:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753806AbXDNRpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 13:45:46 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:52705 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbXDNRpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 13:45:45 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Willy Tarreau <w@1wt.eu>
Cc: Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Jiri Slaby <jirislaby@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
References: <20070414020424.GB14544@wotan.suse.de>
	<20070414063254.GB14875@elte.hu> <20070414064334.GA19463@elte.hu>
	<20070414080833.GL943@1wt.eu> <20070414083625.GM943@1wt.eu>
	<20070414105338.GB19454@elte.hu> <20070414130101.GA2538@1wt.eu>
	<20070414132732.GA22103@1wt.eu> <20070414161927.GD3099@elte.hu>
	<m1abxanahn.fsf@ebiederm.dsl.xmission.com>
	<20070414172920.GA2433@1wt.eu>
Date: Sat, 14 Apr 2007 11:44:21 -0600
In-Reply-To: <20070414172920.GA2433@1wt.eu> (Willy Tarreau's message of "Sat,
	14 Apr 2007 19:29:20 +0200")
Message-ID: <m1647yn956.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau <w@1wt.eu> writes:

> Hi Eric,
>
> [...]
>> >> the ramp up slows down after 700-800 processes, but something very 
>> >> strange happens. If I'm under X, I can switch the focus to all xterms 
>> >> (the WM is still alive) but all xterms are frozen. On the console, 
>> >> after one moment I simply cannot switch to another VT anymore while I 
>> >> can still start commands locally. But "chvt 2" simply blocks. SysRq-K 
>> >> killed everything and restored full control. Dmesg shows lots of :
>> >
>> >> SAK: killed process xxxx (scheddos2): process_session(p)==tty->session.
>> 
>> This.  Yes. SAK is noisy and tells you everything it kills.
>
> OK, that's what I suspected, but I did not know if the fact that it talked
> about the session was systematic or related to any particular state when it
> killed the task.
>
>> >> I wonder if part of the problem would be too many processes bound to 
>> >> the same tty :-/
>> >
>> > hm, that's really weird. I've Cc:-ed the tty experts (Erik, Jiri, Alan), 
>> > maybe this description rings a bell with them?
>> 
>> Is there any swapping going on?
>
> Not at all.
>
>> I'm inclined to suspect that it is a problem that has more to do with the
>> number of processes and has nothing to do with ttys.
>
> It is clearly possible. What I found strange is that I could still fork
> processes (eg: ls, dmesg|tail), ... but not switch to another VT anymore.
> It first happened under X with frozen xterms but a perfectly usable WM,
> then I reproduced it on pure console to rule out any potential X problem.
>
>> Anyway you can easily rule out ttys by having your startup program
>> detach from a controlling tty before you start everything.
>> 
>> I'm more inclined to guess something is reading /proc a lot, or doing
>> something that holds the tasklist lock, a lot or something like that,
>> if the problem isn't that you are being kicked into swap.
>
> Oh I'm sorry you were invited into the discussion without a first description
> of the context. I was giving a try to Ingo's new scheduler, and trying to
> reach corner cases with lots of processes competing for CPU.
>
> I simply used a "for" loop in bash to fork 1000 processes, and this problem
> happened between 700-800 children. The program only uses a busy loop and a
> pause. I then changed my program to close 0,1,2 and perform the fork itself,
> and the problem vanished. So there are two differences here :
>
>   - bash not forking anymore
>   - far less FDs on /dev/tty1

Yes.  But with /dev/tty1 being the controlling terminal in both cases,
as you haven't dropped your session, or disassociated your tty.

The bash problem may have something to setpgid or scheduling effects.
Hmm.  I just looked and setpgid does grab the tasklist lock for
writing so we may possibly have some contention there.

> At first, I had around 2200 fds on /dev/tty1, reason why I suspected something
> in this area.
>
> I agree that this is not normal usage at all, I'm just trying to attack
> Ingo's scheduler to ensure it is more robust than the stock one. But
> sometimes brute force methods can make other sleeping problems pop up.

Yep.  If we can narrow it down to one that would be interesting.  Of course
that also means when we start finding other possibly sleeping problems people
are working in areas of code the don't normally touch, so we must investigate.

> Thinking about it, I don't know if there are calls to schedule() while
> switching from tty1 to tty2. Alt-F2 had no effect anymore, and "chvt 2"
> simply blocked. It would have been possible that a schedule() call
> somewhere got starved due to the load, I don't know.

It looks like there is a call to schedule_work.

There are two pieces of the path. If you are switching in and out of a tty
controlled by something like X.  User space has to grant permission before
the operation happens.  Where there isn't a gate keeper I know it is cheaper
but I don't know by how much, I suspect there is still a schedule happening
in there.

Eric
