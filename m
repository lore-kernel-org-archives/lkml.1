Return-Path: <linux-kernel-owner+w=401wt.eu-S1759880AbYB1Wdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759880AbYB1Wdg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 17:33:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752873AbYB1Wd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 17:33:27 -0500
Received: from www.tglx.de ([62.245.132.106]:40636 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170AbYB1Wd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 17:33:27 -0500
Date: Thu, 28 Feb 2008 23:32:05 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Roland McGrath <roland@redhat.com>
cc: Oleg Nesterov <oleg@tv-sign.ru>, Pavel Emelyanov <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] Consolidate send_sigqueue and send_group_sigqueue
In-Reply-To: <20080228113633.7431C2700FD@magilla.localdomain>
Message-ID: <alpine.LFD.1.00.0802282326560.3111@apollo.tec.linutronix.de>
References: <47BEC663.7050904@openvz.org> <20080222144155.GA4349@tv-sign.ru> <alpine.LFD.1.00.0802280546360.7583@apollo.tec.linutronix.de> <20080228061723.GB108@tv-sign.ru> <20080228113633.7431C2700FD@magilla.localdomain>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Feb 2008, Roland McGrath wrote:

> That code dates from the original introduction of those two functions.
> I can't see any reason why those ever had swapped order of the two checks.
> I think it must have just been sloppy coding in the original work.
> 
> I'm not clear on how the already-queued case could ever happen.  Do we
> really need that check at all?  It shouldn't be possible for the timer to
> be firing when it's already queued, because it won't have been reloaded.
> It only reloads via do_schedule_next_timer after it's dequeued, or because
> a 1 return value said it never was queued.  Perhaps a timer_settime can
> restart it while queued?  But I don't think it should.
> 
> I think the rules for send_sigqueue and send_group_sigqueue should match.
> Any call that did not result in the signal being queued must return 1.
> If it is in fact possible at all that the signal is already queued, then
> that case must return 0 if the signal will ever be dequeued.
> 
> Looking at this makes me think we are incorrect in another anal case.
> Say the timer signal is blocked and the timer has fired, so it is on the
> queue and expects to be reloaded by do_schedule_next_timer at dequeue.
> Now, sigaction is used to set that signal to SIG_IGN, so the pending
> signal is removed from the queue but not dequeued.  Time passes, so the
> timer has in theory fired and reloaded several times counted as overruns.
> Next, sigaction is used to establish a handler for that signal, and then
> we unblock it too.  Time continues to pass, but the timer has not been
> reloaded after the first firing, and so it never fires with the handled
> signal though it now should have done so.  This case is at least a bit
> pathological.  But I'm not sure there is anything in POSIX to exempt us
> from making it work correctly.  Off hand the change that seems like it
> would work is to do the dequeue-time SI_TIMER check at discard time too.

Right. I was working on a fix for that for a different reason. What we
really want is a check for such a timer on a transition from SIGIGN to
another state.  This would allow us to drop the ugly auto rearm code
for ignored timers completely. I had some working proof of concept
code, but got distracted. Need to find it again and dust if off.

Thanks,

	tglx
