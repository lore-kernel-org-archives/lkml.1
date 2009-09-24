Return-Path: <linux-kernel-owner+w=401wt.eu-S1753120AbZIXUTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120AbZIXUTy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 16:19:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752512AbZIXUTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 16:19:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48788 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430AbZIXUTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 16:19:53 -0400
Date: Thu, 24 Sep 2009 22:19:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] itimers: fix racy writes to cpu_itimer fields
Message-ID: <20090924201943.GA19969@elte.hu>
References: <1253802903-979-1-git-send-email-sgruszka@redhat.com> <1253803687.18939.26.camel@laptop> <20090924195732.384bea26@dhcp-lab-109.englab.brq.redhat.com> <1253815467.18939.168.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253815467.18939.168.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Thu, 2009-09-24 at 19:57 +0200, Stanislaw Gruszka wrote:
> > On Thu, 24 Sep 2009 16:48:07 +0200
> > Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > 
> > > On Thu, 2009-09-24 at 16:35 +0200, Stanislaw Gruszka wrote:
> > > > incr_error and error fields of struct cpu_itimer are used when calculating
> > > > next timer tick in check_cpu_itimers() and should not be modified without
> > > > tsk->sighand->siglock taken.
> > > 
> > > Won't it be all-round much better to convert these things to hrtimers
> > > instead of adding more and more fuzz on top to make them deal with
> > > jiffies?
> > 
> > Perhaps it would, but I don't know how to do it :{ . Especially how to
> > precisely account user time. The only idea I have is make something like 
> > microstate accounting (http://lwn.net/Articles/127296/), but this patch
> > and whole idea was rejected long time ago. 
> 
> That patch does look a little painful indeed.
> 
> I was more thinking about about looking if an itimer was to expire less
> than 1 tick away on either sched-in or the tick.
> 
> When we find it is indeed less than 1 tick away, program an hrtimer for
> that cpu to expire at the required moment, see hrtick_start().
> 
> If we happen to de-schedule the task before the timer fires, we clear
> the hrtimer again (or let it pend and ignore the fire), see
> hrtick_clear().
> 
> [ there is no reason to rely on the tick though, we can program the 
> hrtimer on sched in to expire on at the right moment, and do so on 
> each schedule for as long as an itimer is active - re-setting whatever 
> pending timer the cpu still had. ]

we should think about the simplest approach: switching itimers to 
hrtimers.

	Ingo
