Return-Path: <linux-kernel-owner+w=401wt.eu-S1751780AbXLDBDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751780AbXLDBDJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 20:03:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751116AbXLDBC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 20:02:57 -0500
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:42875 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751033AbXLDBC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 20:02:56 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=YBzUVjCHSJWXd8tclTuQprvLIFdqxDLhRxYtkQt5rtRocGkVKBHZqeP3d/M+q8oladNfVqNvzV0PliFovwTivty+jCbQHb6USFzD9mXBscLMMiSI1+X6eAa3yyhQEKuuZKh2ZtfP4ySG9YZz1wvkMM9q61sR1vlF4oIfkvoAHwE=  ;
X-YMail-OSG: OdxsqR4VM1nJ2FkSzZ3Kn7rGz0jhKWzJQi8rf9SLrApVVq6FER.dbdKP_IStX8RD2g2WGKVU0Q--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: sched_yield: delete sysctl_sched_compat_yield
Date: Tue, 4 Dec 2007 12:02:47 +1100
User-Agent: KMail/1.9.5
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <1196155985.25646.31.camel@ymzhang> <200712032202.37975.nickpiggin@yahoo.com.au> <20071203113716.GA8432@elte.hu>
In-Reply-To: <20071203113716.GA8432@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712041202.47602.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 December 2007 22:37, Ingo Molnar wrote:
> * Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > > given how poorly sched_yield() is/was defined the only "compatible"
> > > solution would be to go back to the old yield code.
> >
> > While it is technically allowed to do anything with SCHED_OTHER class,
> > putting the thread to the back of the runnable tasks, or at least
> > having it give up _some_ priority (like the old scheduler) is less
> > surprising than having it do _nothing_.
>
> wrong: it's not "nothing" that the new code does - run two yield-ing
> loops and they'll happily switch to each other, at a rate of a few
> million context switches per second.

OK, it's not nothing, it interacts with the quantisation of the
update granularity and wakeup granularity... It's definitely not
what would be expected if you didn't look at the implementation
though.


> > Wheras JVMs (eg. that have garbage collectors call yield), presumably
> > get quite a lot of tuning, and that was probably done with the less
> > surprising (and more common) sched_yield behaviour.
>
> i disagree. To some of them, having a _more_ agressive yield than 2.6.22
> might increase latencies and jitter - which can be seen as a regression
> as well. All tests i've seen so far show dramatically lower jitter in
> v2.6.23 and upwards kernels.

Right so we should have one being about the _same_ aggressiveness.
Doesn't that make sense?


> anyway, right now what we have is a closed-source benchmark (which is a
> quite silly one as well) against a popular open-source desktop app and
> in that case the choice is obvious. Actual Java app server benchmarks
> did not show any regression so maybe Java's use of yield for locking is
> not that significant after all and it's only Volanomark that is doing
> extra (unnecessary) yields. (and java benchmarks are part of the
> upstream kernel test grid anyway so we'd have noticed any serious
> regression)

Sure I'm not basing this purely on volanomark at all. If you've tested
a reasonable range of actual java app server benchmarks with a range of
jvms then fine.


> if you insist on flipping the default then that just shows a blatant
> disregard to desktop performance

That statement is true. But you know I'm not insisting on flipping
the default, so I don't see how it is relevant.

BTW. can you answer what workload did firefox see the sched_yield
pauses with, and/or where that thread is archived? I still think
firefox should not call sched_yield at all.


> > > i think the sanest long-term solution is to strongly discourage the
> > > use of SCHED_OTHER::yield, because there's just no sane definition
> > > for yield that apps could rely upon. (well Linus suggested a pretty
> > > sane definition but that would necessiate the burdening of the
> > > scheduler fastpath - we dont want to do that.) New ideas are welcome
> > > of course.
> >
> > sched_yield is defined to put the calling task at the end of the queue
> > for the given priority level as you know (ie. at the end of all other
> > priority 0 tasks, for SCHED_OTHER).
>
> almost: substitute "priority" with "nice level". One problem is, that's
> not what the old scheduler did.

I'm not sure if that's right. Posix realtime scheduling says that all
SCHED_OTHER tasks are priority 0. But I'm not much of a standards reader.
And even if it were just applied to a given nice level, that would be
more intuitive than the current default.


> > > [ also, actual technical feedback on the SCHED_BATCH patch i sent
> > >   (which was the only "forward looking" moment in this thread so far
> > >    ;-) would be nice too. ]
> >
> > I dislike a wholesale change in behaviour like that. Especially when
> > it is changing behaviour of yield among SCHED_BATCH tasks versus yield
> > among SCHED_OTHER tasks.
>
> There's no wholesale change in behavior, SCHED_BATCH tasks have clear
> expectations of being throughput versus latency, hence the patch makes
> quite a bit of sense to me. YMMV.

sched_yield semantics are totally different depending on whether the
process is SCHED_BATCH or not. That's what I was calling a change in
behaviour, so arguing otherwise is just arguing semantics.

I just would think it isn't such a good thing if you suddently got a
500% speedup by making your jvm SCHED_BATCH, only to find that it
stops working when your batch cron jobs or something start running...
But if there are no real jvm workloads that would see such a speedup,
then I guess the point is moot ;)

