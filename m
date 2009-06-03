Return-Path: <linux-kernel-owner+w=401wt.eu-S1754788AbZFCHMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbZFCHMR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 03:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753263AbZFCHMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 03:12:03 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33996 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753238AbZFCHMC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 03:12:02 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, paul@mad-scientist.net,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] coredump: Retry writes where appropriate
In-Reply-To: Oleg Nesterov's message of  Tuesday, 2 June 2009 02:08:50 +0200 <20090602000850.GA31064@redhat.com>
References: <1243748019.7369.319.camel@homebase.localnet>
	<20090531111851.07eb1df3@lxorguk.ukuu.org.uk>
	<20090601161234.GA10486@redhat.com>
	<20090601174159.48acf3f5@lxorguk.ukuu.org.uk>
	<20090601171119.GA13970@redhat.com>
	<20090601184608.6379440c@lxorguk.ukuu.org.uk>
	<20090601182305.GA16372@redhat.com>
	<20090601203845.B010DFC3C7@magilla.sf.frob.com>
	<20090601223241.GA26788@redhat.com>
	<20090601230210.C0B15FC3C7@magilla.sf.frob.com>
	<20090602000850.GA31064@redhat.com>
Emacs: Lovecraft was an optimist.
Message-Id: <20090603070939.4E31CFC333@magilla.sf.frob.com>
Date: Wed,  3 Jun 2009 00:09:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Oh, I forgot about freezer...

We all would like to.

> Well, not good to complicate recalc_sigpending_tsk() for this unlikely case.
> And this can't help, freezer does signal_wake_up() unconditionally.
> 
> So in fact this is another argument to check signal_pending() and clear it
> in dump_write/seek.

I can't agree with this at all.  IMHO it's far better to have a consistent
definition of when TIF_SIGPENDING ought to be triggered, and have
recalc_sigpending_tsk() use logic that matches the logic controlling when
to set TIF_SIGPENDING asynchronously (i.e. signal_wake_up calls).

> But since the coredumping task is not freezable anyway, perhaps we should
> change fake_signal_wake_up() to ignore SIGNAL_GROUP_DUMPING task.

That could be a long delay and a lot of i/o before suspending.

> Or we should make the coredumping freezable. This means dump_write/seek
> and exit_mm() should do try_to_freeze().

Yes, I think this is the thing to do for that issue.
(It's kind of a separate problem.)

> In any case, the coredumping is special. If ->write() returns -ERESTART/EINTR
> it assumes the return to ths user-space, this is not true for the coredump.
> This means that handling the spurious signals in coredump_file_write() is
> not so bad if we can't avoid this.

I am not so confident.  It seems far too easy to wind up with some other
way that TIF_SIGPENDING gets continually set and this loops, for example.
(This could be some day in the future when fs, driver or pipe-io code
changes somehow completely obscure.)  It's far better to have confidence
just in the signals code itself: the only things that set TIF_SIGPENDING
interlock with the logic of the only things that are expected to clear it.


Thanks,
Roland
