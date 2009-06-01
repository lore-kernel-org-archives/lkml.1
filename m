Return-Path: <linux-kernel-owner+w=401wt.eu-S1758530AbZFAUkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758530AbZFAUkV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 16:40:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755180AbZFAUkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 16:40:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38264 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754443AbZFAUkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 16:40:10 -0400
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
In-Reply-To: Oleg Nesterov's message of  Monday, 1 June 2009 20:23:05 +0200 <20090601182305.GA16372@redhat.com>
References: <1243748019.7369.319.camel@homebase.localnet>
	<20090531111851.07eb1df3@lxorguk.ukuu.org.uk>
	<20090601161234.GA10486@redhat.com>
	<20090601174159.48acf3f5@lxorguk.ukuu.org.uk>
	<20090601171119.GA13970@redhat.com>
	<20090601184608.6379440c@lxorguk.ukuu.org.uk>
	<20090601182305.GA16372@redhat.com>
Emacs: freely redistributable; void where prohibited by law.
Message-Id: <20090601203845.B010DFC3C7@magilla.sf.frob.com>
Date: Mon,  1 Jun 2009 13:38:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IMHO it would certainly be wrong to have behavior differ based on what
particular method from userland was used to generate a signal.  I don't
think Alan was suggesting anything like that, just using ^C as shorthand
for what the user experience is that matters.  (Alan also mentioned ^\,
i.e. SIGQUIT.  I don't think it would make sense to have that interrupt
dumping--it's what you hit to request a core dump.)

I'm not really sure exactly how this has morphed over time, or how the
internal wrinkles were before that produced the observed behavior.  I
suspect it was always more by happenstance than careful attention.

Any sig_fatal() non-core signal that was sent before the core dumping
actually started already prevents the dump now.  The complete_signal()
code along with the signal_group_exit() check in zap_threads() should
ensure that.  This is as it should be: there was no guarantee of the
order in which the signals were processed, so the effect is that the
core dump signal was swallowed by the arrival of the just-fatal signal.

Aside from that, I see the following categories for newly-arriving signals.

1. More core-dump signals.  e.g., it was already crashing and you hit ^\
   or maybe just hit ^\ twice with a finger delay.  
2. Non-fatal signals (i.e. ones with handlers, stop signals).
3. Plain sig_fatal() non-core signals (e.g. SIGINT when not handled)
4. SIGKILL (an actual one from userland or oomkill, not group-exit)

#1 IMHO should not do anything at all.  
You are asking for a core dump, it's already doing it.

#2 should not do anything at all.
It's not really possible to suspend during the core dump, so unhandled,
unblocked stop signals can't do anything either.

#4 IMHO should always stop everything immediately.
That's what SIGKILL is for.  When userland generates a SIGKILL
explicitly, that says the top priority is to be gone and cease
consuming any resources ASAP.

#3 is the open question.  I don't feel strongly either way.

Whatever the decision on #3, we have a problem to fix for #1 and #2 at
least anyway.  These unblocked signals will cause TIF_SIGPENDING to be
set when dumping, either via recalc_sigpending() from dequeue_signal()
after the core signal is taken (more signals already pending), or via
signal_wake_up() from complete_signal() for newly-generated signals.
(PF_EXITING is not yet set to prevent it.)  This spuriously prevents
interruptible waits in the fs code or the pipe code or whatnot.

That looks simple to avoid just by clobbering ->real_blocked when we
start the core dump.  The dump-writing itself uses ->blocked, so that
actually won't pollute the data.  The less magical way that is obvious
would be to add a SIGNAL_GROUP_DUMPING flag that we set at the beginning
of the dumping, and make recalc_sigpending_tsk/complete_signal obey that.


Thanks,
Roland
