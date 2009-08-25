Return-Path: <linux-kernel-owner+w=401wt.eu-S1751230AbZHYENR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751230AbZHYENR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 00:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750713AbZHYENP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 00:13:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39290 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750705AbZHYENO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 00:13:14 -0400
Date: Mon, 24 Aug 2009 21:10:38 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: v2.6.31-rc6: BUG: unable to handle kernel NULL pointer dereference
 at 0000000000000008
In-Reply-To: <20090825033944.GA5227@nowhere>
Message-ID: <alpine.LFD.2.01.0908242043280.3218@localhost.localdomain>
References: <m163cjhwa4.fsf@fess.ebiederm.org> <m1skfnggrb.fsf@fess.ebiederm.org> <alpine.LFD.2.01.0908241530070.3824@localhost.localdomain> <alpine.LFD.2.01.0908241632060.3824@localhost.localdomain> <alpine.LFD.2.01.0908241655370.3824@localhost.localdomain>
 <20090825033944.GA5227@nowhere>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 25 Aug 2009, Frederic Weisbecker wrote:
> 
> Now that also makes the TTY_LDISC flag clearing unprotected by
> tty->ldisc_mutex.

Yes.

> tty_set_ldisc() can play concurrently with these flags right?

.. but that shouldn't matter.

The actual bit-setting is "atomic" already - and any other atomicity is 
pretty much unattainable, because all the routines in question drop the 
lock they need to hold in order to make it really be reliably atomic.

> tty_ldisc_halt() could remain protected by the mutex, so that the
> flag is safely toggled. Once it is cleared, we can ensure no more
> user can ref it and the lock can be relaxed while the pending
> work is flushed.

That would make no difference at all. tty_set_ldisc() won't care about the 
flag (in fact, it will do its own tty_ldisc_halt()), and will be happy to 
replace the ldisc we just flushed with a new one regardless of whether it 
was halted before or not. And it will do tty_ldisc_enable() regardless of 
whether it was enabled or not before.

In fact, because tty_set_ldisc() itself had to release the ldisc_mutex 
(for the same reason), you have this issue regardless of whether you hold 
the lock in tty_hangup() or not: the two will always be able to get "mixed 
up", because they - by design - have to release that silly lock.

That's why I said I was unhappy about the tty layer locking - it really 
isn't very sane. Things like tty_set_ldisc() will drop the lock in the 
middle because of that crazy workqueue deadlock - exactly for the same 
reasons that tty_ldisc_hangup() will need to do that "wait for things to 
flush" without the lock held.

So I could have taken the ldisc_mutex, and then just dropped it 
temporarily while waiting for any workqueue entries, but as far as I can 
tell, it doesn't actually solve anything.

I considered using the TTY_LDISC_CHANGING bit(*) there to protect against 
tty_set_ldisc(), and it may even be the right solution. But there's no way 
I'll do that kind of changes this late in the -rc series.

We also have the "TTY_HUPPED" bit that disables tty_set_ldisc(), but that 
is set too late by do_tty_hangup(), and so doesn't fix the problem either. 
Again, moving it earlier may be a solution, but again, it's not 
appropriate for this late in the -rc.

Finally, the solution that is most likely the _real_ solution would be to 
just fix the locking. The whole "ldisc_mutex" seems dubious. It's not even 
a real lock - exactly because it's dropped - and we already really use 
that TTY_LDISC_CHANGING bit to do the _real_ locking. I don't think it 
needs to be a mutex at all. The locking is just very dubious. 

And that, least of all, is anything I'm willing to really do in -rc. 

Anyway, I'll happily be shown wrong. I think the (second) patch I sent out 
is an acceptable hack in the presense of the current locking, but as I 
said, I'm not exactly happy about it, because I do think the locking is 
broken.

		Linus

(*) We already have that hacky open-coded "lock" using TTY_LDISC_CHANGING, 
which protects two different tty_set_ldisc()'s from screwing up each other 
when they drop the semaphore. It could be just separated out into a 
function of its own, and then the hangup code would/could/should be taught 
to use that logic.
