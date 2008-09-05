Return-Path: <linux-kernel-owner+w=401wt.eu-S1753508AbYIEQPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508AbYIEQPz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 12:15:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754033AbYIEQPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 12:15:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54083 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754016AbYIEQPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 12:15:35 -0400
Date: Fri, 5 Sep 2008 18:15:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: balbir@linux.vnet.ibm.com, Spencer Candland <spencer@bluehost.com>,
       dmitry.adamushko@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: Still seeing decreasing stime/utime
Message-ID: <20080905161516.GO10292@elte.hu>
References: <48B5C4C7.8040509@bluehost.com> <48B66BCC.8030207@linux.vnet.ibm.com> <48B702FA.8060308@bluehost.com> <20080828224502.GA1540@balbir.in.ibm.com> <48B859C8.5000001@bluehost.com> <48B8E102.5050503@linux.vnet.ibm.com> <1220095656.8426.23.camel@twins> <20080830135557.GA24039@balbir.in.ibm.com> <1220110327.14894.40.camel@lappy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220110327.14894.40.camel@lappy.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Sat, 2008-08-30 at 19:25 +0530, Balbir Singh wrote:
> > * Peter Zijlstra <a.p.zijlstra@chello.nl> [2008-08-30 13:27:36]:
> > 
> > > On Sat, 2008-08-30 at 11:26 +0530, Balbir Singh wrote:
> > > > Spencer Candland wrote:
> > > > >> Here is an experimental patch (I've just compiled and booted a machine
> > > > >> with it, I am unable to reproduce your problem), could you please test
> > > > >> it for me and see if it helps solve the problem
> > > > > 
> > > > > Looks like this fixed it.  I have been testing this for the last 16
> > > > > hours and everything is looking good.
> > > > > 
> > > > 
> > > > Excellent! Ingo, Peter, do you like the patch? If so, could you please pick it
> > > > up Ingo. I think we should even push the fix to stable releases.
> > > 
> > > Looks good, except for the issue you yourself earlier raised, a few of
> > > those functions looks too large to be inlined.
> > >
> > 
> > Here's the updated revision with task_*time functions moved to sched.c
> > and inlining removed, except for task_gtime(). I've compiled and
> > booted a machine (x86_64) with this patch applied.
> > 
> > Reported-by: spencer@bluehost.com
> > 
> > Spencer reported a problem where utime and stime were going negative despite
> > the fixes in commit b27f03d4bdc145a09fb7b0c0e004b29f1ee555fa. The suspected
> > reason for the problem is that signal_struct maintains it's own utime and
> > stime (of exited tasks), these are not updated using the new task_utime()
> > routine, hence sig->utime can go backwards and cause the same problem
> > to occur (sig->utime, adds tsk->utime and not task_utime()). This patch
> > fixes the problem
> > 
> > TODO: using max(task->prev_utime, derived utime) works for now, but a more
> > generic solution is to implement cputime_max() and use the cputime_gt()
> > function for comparison.
> > 
> > Comments?
> > 
> > Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> 
> Thanks Balbir!
> 
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

applied to tip/sched/urgent, thanks!

	Ingo
