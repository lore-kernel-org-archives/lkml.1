Return-Path: <linux-kernel-owner+w=401wt.eu-S1754391AbZHYEbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391AbZHYEbu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 00:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753348AbZHYEbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 00:31:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47377 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753263AbZHYEbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 00:31:47 -0400
Date: Mon, 24 Aug 2009 21:30:16 -0700 (PDT)
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
In-Reply-To: <alpine.LFD.2.01.0908242043280.3218@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0908242113540.3218@localhost.localdomain>
References: <m163cjhwa4.fsf@fess.ebiederm.org> <m1skfnggrb.fsf@fess.ebiederm.org> <alpine.LFD.2.01.0908241530070.3824@localhost.localdomain> <alpine.LFD.2.01.0908241632060.3824@localhost.localdomain> <alpine.LFD.2.01.0908241655370.3824@localhost.localdomain>
 <20090825033944.GA5227@nowhere> <alpine.LFD.2.01.0908242043280.3218@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 24 Aug 2009, Linus Torvalds wrote:
> 
> Anyway, I'll happily be shown wrong. I think the (second) patch I sent out 
> is an acceptable hack in the presense of the current locking, but as I 
> said, I'm not exactly happy about it, because I do think the locking is 
> broken.

Btw, another solution to all this would be to just not have that 
ldisc_mutex deadlock due to do_tty_hangup -> tty_ldisc_hangup at all.

The actual _flushing_ doesn't need the mutex - it's just that both 
flushing and hangup is done with workqueues.

If we can avoid the deadlock by not having the (artificial) workqueue 
dependency, it would allow everybody to just hold on to the mutex over the 
whole sequence - and would obviate the need for that hacky 
TTY_LDISC_CHANGING bit thing in tty_set_ldisc.

In other words, the whole problem really comes in from the fact that 
do_tty_hangup() is called from "hangup_work", and the workqueues can get 
hung to the point where you can't then do the (totally _unrelated_) queue 
flushing.

Because flush_to_ldisc() itself - which is what we want to do - doesn't 
need that mutex or the workqueue at all. It could run from any context, 
afaik.

So if we were to turn it into just a timer (rather than a "delayed work"), 
then we'd not need to do that "flush_scheduled_work()" thing at all, and 
we wouldn't have that interaction with do_tty_hangup(). At which point we 
could again hold on to locks, because we wouldn't need to worry about the 
workqueues getting stuck on the mutex (that isn't even needed for the 
actual flushing part that we want to do!).

So don't get me wrong - there are _multiple_ ways to solve this. But they 
are all pretty major surgery, changing "big" semantics. We could fix the 
locking, we could change how we flush, we could do all of those things. 
And I'd love to. But I think the almost-oneliner is the safest approach 
right now. It's certainly not perfect, but it's fairly minimal impact.

		Linus
