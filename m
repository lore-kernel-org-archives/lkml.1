Return-Path: <linux-kernel-owner+w=401wt.eu-S1423266AbXBUXZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423266AbXBUXZl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 18:25:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423269AbXBUXZl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 18:25:41 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43745 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423266AbXBUXZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 18:25:39 -0500
Date: Thu, 22 Feb 2007 00:20:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 08/13] syslets: x86, add move_user_context() method
Message-ID: <20070221232017.GE32031@elte.hu>
References: <20070221211537.GH7579@elte.hu> <Pine.LNX.4.64.0702211428400.16904@alien.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702211428400.16904@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -5.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-5.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Davide Libenzi <davidel@xmailserver.org> wrote:

> On Wed, 21 Feb 2007, Ingo Molnar wrote:
> 
> > From: Ingo Molnar <mingo@elte.hu>
> > 
> > add the move_user_context() method to move the user-space
> > context of one kernel thread to another kernel thread.
> > User-space might notice the changed TID, but execution,
> > stack and register contents (general purpose and FPU) are
> > still the same.
> 
> Also signal handling should/must be maintained, on top of TID. You 
> don't want the user to be presented with a different signal handling 
> after an sys_async_exec call.

right now CLONE_SIGNAL and CLONE_SIGHAND is used for new async threads, 
so they should inherit and share all the signal settings.

one area that definitely needs more work is that the ptrace parent (if 
any) should probably follow the 'head' context. gdb at the moment copes 
surprisingly well, but some artifacts are visible every now and then.

> > +	*new_regs = *old_regs;
> > +	/*
> > +	 * Flip around the FPU state too:
> > +	 */
> > +	tmp = new_task->thread.i387;
> > +	new_task->thread.i387 = old_task->thread.i387;
> > +	old_task->thread.i387 = tmp;
> > +}
> 
> This is not going to work in this case (already posted twice in other 
> emails):

i'm really sorry - i still have a huge email backlog.

> So NTSK loads a non up2date FPUo, instead of the FPUc that was the 
> "dirty" context to migrate (since TS_USEDFPU was set). I think you 
> need an early __unlazy_fpu() in that case, that would turn the above 
> into:

yes. My plan is to to avoid all these problems by having a 
special-purpose sched_yield_to(old_task, new_task) function.

this, besides being even faster than the default scheduler (because the 
runqueue balance does not change so no real scheduling decision has to 
be done - the true scheduling decisions happen later on at async-wakeup 
time), should also avoid all the FPU races: the FPU just gets flipped 
between old_task and new_task (and TS_USEDFPU needs to be moved as well, 
etc.). No intermediate task can come inbetween.

can you see a hole in this sched_yield_to() method as well?

	Ingo
