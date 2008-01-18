Return-Path: <linux-kernel-owner+w=401wt.eu-S1753087AbYARGdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087AbYARGdt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 01:33:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750984AbYARGdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 01:33:39 -0500
Received: from py-out-1112.google.com ([64.233.166.178]:61804 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbYARGdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 01:33:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Rgy1SPZGNO4vrX8adOv+37+8JCDMKMsa2w0aXHkkvYJdqyobv337jsbitOaQDj2XG5kzIJs9DBIDkbNc1iqt7VDsN1f+eMitz8o7KfB23bkuBO5XLBPnMAFlmGfovAt5ywjwdab+DYx+kXKCdmPWvPVSUxkurOZqjeHA/FXYhf0=
Message-ID: <7c86c4470801172233s333b5993q8b10e37f8ad151d@mail.gmail.com>
Date: Fri, 18 Jan 2008 07:33:35 +0100
From: "stephane eranian" <eranian@googlemail.com>
To: "Nick Piggin" <nickpiggin@yahoo.com.au>
Subject: Re: runqueue locks in schedule()
Cc: "Peter Zijlstra" <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       ia64 <linux-ia64@vger.kernel.org>,
       "Stephane Eranian" <eranian@gmail.com>,
       "Corey J Ashford" <cjashfor@us.ibm.com>, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <200801181307.53026.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7c86c4470801161629t3870da59hb6ac371c44126b07@mail.gmail.com>
	 <1200576266.28661.27.camel@twins>
	 <200801181307.53026.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick,

On Jan 18, 2008 3:07 AM, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
>
> On Friday 18 January 2008 00:24, Peter Zijlstra wrote:
> > [ At the very least CC'ing the scheduler maintainer would be
> > helpful :-) ]
> >
> > On Wed, 2008-01-16 at 16:29 -0800, stephane eranian wrote:
> > > Hello,
> > >
> > > As suggested by people on this list, I have changed perfmon2 to use
> > > the high resolution timers as the interface to allow timeout-based
> > > event set multiplexing. This works around the problems I had with
> > > tickless-enabled kernels.
> > >
> > > Multiplexing is supported in per-thread as well. In that case, the
> > > timeout measures virtual time. When the thread is context switched
> > > out, we need to save the remainder of the timeout and cancel the
> > > timer. When the thread is context switched in, we need to reinstall
> > > the timer. These timer save/restore operations have to be done in the
> > > switch_to() code near the end of schedule().
> > >
> > > There are situations where hrtimer_start() may end up trying to
> > > acquire the runqueue lock. This happens on a context switch where the
> > > current thread is blocking (not preempted) and the new timeout happens
> > > to be either in the past or just expiring. We've run into such
> > > situations with simple tests.
> > >
> > > On all architectures, but IA-64, it seems thet the runqueue lock is
> > > held until the end of schedule(). On IA-64, the lock is released
> > > BEFORE switch_to() for some reason I don't quite remember. That may
> > > not even be needed anymore.
> > >
> > > The early unlocking is controlled by a macro named
> > > __ARCH_WANT_UNLOCKED_CTXSW. Defining this macros on X86 (or PPC) fixed
> > > our problem.
> > >
> > > It is not clear to me why the runqueue lock needs to be held up until
> > > the end of schedule() on some platforms and not on others. Not that
> > > releasing the lock earlier does not necessarily introduce more
> > > overhead because the lock is never re-acquired later in the schedule()
> > > function.
> > >
> > > Question:
> > >    - is it safe to release the lock before switch_to() on all
> > > architectures?
> >
> > I had similar problem when using hrtimers from the scheduler, I extended
> > the HRTIMER_CB_IRQSAFE_NO_SOFTIRQ time type to run with cpu_base->lock
> > unlocked.
> >
> > http://git.kernel.org/?p=linux/kernel/git/mingo/linux-2.6-sched-devel.git;a
> >=commitdiff;h=7e7cbd617833dde5b442e03f69aac39d17d02ec7
> > http://git.kernel.org/?p=linux/kernel/git/mingo/linux-2.6-sched-devel.git;a
> >=commitdiff;h=45d10aad580a5cdd376e80848aeeaaaf1f97cc18
> > http://git.kernel.org/?p=linux/kernel/git/mingo/linux-2.6-sched-devel.git;a
> >=commitdiff;h=5ae5d6c5850d4735798bc0e4526d8c61199e9f93
> >
> > As for your __ARCH_WANT_UNLOCKED_CTXSW question I have to defer to Ingo,
> > as I'm unaware of the arch ramifications there.
>
> It is arch specific. If an architecture wants interrupts on during context
> switch, or runqueue unlocked, then they set it (btw INTERRUPTS_ON_CTXSW
> also implies UNLOCKED_CTXSW).
>
Yes , I noticed that. I am only interested in UNLOCKED_CTXSW.
But it appears that the approach suggested my Peter does work. We are
running some tests.

> Although, eg on x86, you would hold off interrupts and runqueue lock for
> slightly less time if you defined those, it results in _slightly_ more
> complicated context switching... although I did once find a workload
> where the reduced runqueue contention improved throughput a bit, it is
> not much problem in general to hold the lock.
>
By complicated you mean that now you'd have to make sure you don't
need to access runqueue data?

Thanks.
