Return-Path: <linux-kernel-owner+w=401wt.eu-S1759019AbYDKHps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759019AbYDKHps (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 03:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757394AbYDKHpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 03:45:40 -0400
Received: from viefep31-int.chello.at ([62.179.121.49]:63956 "EHLO
	viefep31-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756953AbYDKHpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 03:45:40 -0400
Subject: Re: [PATCH] proc: Add RLIMIT_RTTIME to /proc/<pid>/limits
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>, Eugene Teo <eugeneteo@kernel.sg>,
       linux-kernel@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <cfd18e0f0804110038q3b7740c9q1a96858d9531ab92@mail.gmail.com>
References: <20080208145950.GA3910@kernel.sg>
	 <1202483445.6292.1.camel@lappy>
	 <517f3f820802280712o3d756b4fq46461b226515e1f2@mail.gmail.com>
	 <1204212100.12120.9.camel@twins>
	 <cfd18e0f0802280744q18ccad3at3c88bac166806118@mail.gmail.com>
	 <1204213821.12120.15.camel@twins>
	 <cfd18e0f0804110038q3b7740c9q1a96858d9531ab92@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 11 Apr 2008 09:45:30 +0200
Message-Id: <1207899930.7074.23.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-04-11 at 09:38 +0200, Michael Kerrisk wrote:
> On Thu, Feb 28, 2008 at 5:50 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> >
> > On Thu, 2008-02-28 at 16:44 +0100, Michael Kerrisk wrote:
> > > Peter,
> > >
> > > Thanks for the text.
> > >
> > > On Thu, Feb 28, 2008 at 4:21 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > > >
> > > >  On Thu, 2008-02-28 at 16:12 +0100, Michael Kerrisk wrote:
> > > >  > Peter,
> > > >  >
> > > >  > Could you please provide some text describing RLIMIT_RTTIMEfor the
> > > >  > getrlimit.2 man page.
> > > >
> > > >  The rlimit sets a timeout in [us] for SCHED_RR and SCHED_FIFO tasks.
> > > >  This time is measured between sleeps, so a schedule in RR or a
> > > >  preemption in either is not a sleep - the task needs to be dequeued and
> > > >  enqueued for the timer to reset.
> > >
> > > Just to clarify: sleep here means a call to some blocking syscall
> > > (e.g., nanosleep(), read(), select(), etc.), right?  Is there anything
> > > else that falls under the category of "sleep"?  What about a call to
> > > sched_yield() where the process explicitly lets go of the CPU?
> >
> > Yes, and yes, others would be blocking on futexes and the like.
> 
> Peter,
> 
> I've been testing this patch.  Above you seemed to be saying that
> doing a sched_yield() would be equivalent to a sleep, causing the rt
> counter to be reset to zero.  Howver, the results I'm seeing suggest
> that a sched_yield() does not cause the counter to be reset to zero
> (i.e., despite calling sched_yield() at frequent intervals, the
> process still encounters the RLIM_RTTIME soft limit and gets SIGXCPU).
>  Can you comment?

It appears you are right. I must have been staring at something else
than code when I said that :-(, yield() will indeed _not_ reset the
counter.

Now, I think it makes some sense to reset it, because we do try to play
nice by calling yield. OTOH we don't actually block and become
unrunnable - we'll still be contending for CPU time.



