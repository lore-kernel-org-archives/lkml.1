Return-Path: <linux-kernel-owner+w=401wt.eu-S1752721AbZIIAht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbZIIAht (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 20:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbZIIAht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 20:37:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53772 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752640AbZIIAhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 20:37:48 -0400
Date: Tue, 8 Sep 2009 17:37:27 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: Linux 2.6.31-rc9
In-Reply-To: <20090908112003.GA30754@elte.hu>
Message-ID: <alpine.LFD.2.01.0909081720430.7458@localhost.localdomain>
References: <alpine.LFD.2.01.0909051645430.3329@localhost.localdomain> <20090908112003.GA30754@elte.hu>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ Added some people to the cc - this is very directly related to the 
  previous thread on "v2.6.31-rc6: BUG: unable to handle kernel NULL 
  pointer dereference at 0000000000000008", and the deadlock discussion 
  there ]

On Tue, 8 Sep 2009, Ingo Molnar wrote:
> 
> FYI, i'm getting very (very) rare warnings from the TTY code in this 
> place:
> 
> [   28.187364] rc.sysinit used greatest stack depth: 5224 bytes left
> [   31.422457] Adding 3911816k swap on /dev/sda2.  Priority:-1 extents:1 across:3911816k 
> [   32.974830] ssh used greatest stack depth: 5200 bytes left
> [   33.115028] ------------[ cut here ]------------
> [   33.119518] WARNING: at drivers/char/tty_io.c:1267 __tty_open+0x3ef/0x4c0()

Hmm. I think I see why, and I _suspect_ this is harmless, although it's 
obviously very annoying, and it really is indicative of a real locking 
problem.

What's going on is that same horrible deadlocak-avoidance where we have to 
drop the ldisc_mutex after clearing TTY_LDISC, in order to then wait for 
any pending work. See commit 5c58ceff103d8a654f24769bb1baaf84a841b0cc, 
which is probably also the one that introduced the timing that gets your 
particular warning.

So when __tty_open() does this:

	mutex_lock(&tty->ldisc_mutex);
	WARN_ON(!test_bit(TTY_LDISC, &tty->flags));
	mutex_unlock(&tty->ldisc_mutex);

it's really warning about something that really can happen: the things 
that clear TTY_LDISC will all release the ldisc_mutex with that bit still 
clear, because they all end up having to release the lock that they 
_should_ hold in order to avoid a deadlock.

So the warning is "real" in the sense that it does show a real locking 
problem. It's probably not _relevant_ in that it probably will never cause 
any other issues in practice.

> I got it on two systems so far. Config attached (but is probably 
> irrelevant). The warnings started in the .31 cycle. They occur every 
> 1000-2000 random kernels - i.e. every few days.

Yeah, the configuration won't matter. 

> These warnings were never fatal and my guess is that they are 
> ancient, pre-existing races in the TTY code - but wanted to mention 
> them here in case they matter.

The issue is pre-existing, yes - we've always done that 

	tty_ldisc_halt(tty);
	flush_scheduled_work();

outside the ldisc_mutex, but the commit mentioned above (5c58ceff) added a 
new case where we do it (it used to be in just tty_set_ldisc() and in 
tty_ldisc_release()). So it's a pre-existing issue that probably just got 
_way_ easier to hit fairly recently.

Quite frankly, the ldisc_mutex problem is not fixable at this stage in 
2.6.31, and it's probably not worth worrying about. I'm planning on 
revisiting this after releasing 2.6.31 (probably just deciding that the 
sane way to fix it is to turn that flush_to_ldisc thing into just a timer, 
not a delayed work - which allows us to hold the mutex), but there's no 
way I'm doing that before..

If the fix turns out straightforward, we can back-port it through stable. 

			Linus
