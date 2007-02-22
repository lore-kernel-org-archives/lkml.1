Return-Path: <linux-kernel-owner+w=401wt.eu-S1751497AbXBVEK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751497AbXBVEK5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 23:10:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbXBVEK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 23:10:57 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:4408 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbXBVEK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 23:10:56 -0500
X-AuthUser: davidel@xmailserver.org
Date: Wed, 21 Feb 2007 20:10:55 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ingo Molnar <mingo@elte.hu>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
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
In-Reply-To: <20070221232017.GE32031@elte.hu>
Message-ID: <Pine.LNX.4.64.0702212005340.16904@alien.or.mcafeemobile.com>
References: <20070221211537.GH7579@elte.hu> <Pine.LNX.4.64.0702211428400.16904@alien.or.mcafeemobile.com>
 <20070221232017.GE32031@elte.hu>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Feb 2007, Ingo Molnar wrote:

> 
> * Davide Libenzi <davidel@xmailserver.org> wrote:
> 
> > On Wed, 21 Feb 2007, Ingo Molnar wrote:
> > 
> > > From: Ingo Molnar <mingo@elte.hu>
> > > 
> > > add the move_user_context() method to move the user-space
> > > context of one kernel thread to another kernel thread.
> > > User-space might notice the changed TID, but execution,
> > > stack and register contents (general purpose and FPU) are
> > > still the same.
> > 
> > Also signal handling should/must be maintained, on top of TID. You 
> > don't want the user to be presented with a different signal handling 
> > after an sys_async_exec call.
> 
> right now CLONE_SIGNAL and CLONE_SIGHAND is used for new async threads, 
> so they should inherit and share all the signal settings.

Right. Sorry I missed the signal cloning flags (still has to go thru the 
whole code).



> > So NTSK loads a non up2date FPUo, instead of the FPUc that was the 
> > "dirty" context to migrate (since TS_USEDFPU was set). I think you 
> > need an early __unlazy_fpu() in that case, that would turn the above 
> > into:
> 
> yes. My plan is to to avoid all these problems by having a 
> special-purpose sched_yield_to(old_task, new_task) function.
> 
> this, besides being even faster than the default scheduler (because the 
> runqueue balance does not change so no real scheduling decision has to 
> be done - the true scheduling decisions happen later on at async-wakeup 
> time), should also avoid all the FPU races: the FPU just gets flipped 
> between old_task and new_task (and TS_USEDFPU needs to be moved as well, 
> etc.). No intermediate task can come inbetween.
> 
> can you see a hole in this sched_yield_to() method as well?

Not sure till I see the code, but in that case we really need a sync&copy. 
This is really a fork-like for the FPU context IMO. The current "dirty" 
FPU context should follow both OTSK and NTSK.



- Davide


