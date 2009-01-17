Return-Path: <linux-kernel-owner+w=401wt.eu-S1758301AbZAQKfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758301AbZAQKfH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 05:35:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753769AbZAQKeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 05:34:50 -0500
Received: from mail.gmx.net ([213.165.64.20]:44932 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753381AbZAQKes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 05:34:48 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/69rhnXQX6GkjgZg0VxQsHwFwyEsgyW2O6bBsb2V
	ktkTjunnwrmJV1
Subject: Re: [git pull] scheduler fixes
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1232186877.14073.59.camel@laptop>
References: <20090111144305.GA7154@elte.hu>
	 <20090114121521.197dfc5e.akpm@linux-foundation.org>
	 <1231964647.14825.59.camel@laptop>
	 <20090116204049.f4d6ef1c.akpm@linux-foundation.org>
	 <1232173776.7073.21.camel@marge.simson.net>
	 <1232186054.6813.48.camel@marge.simson.net>
	 <1232186877.14073.59.camel@laptop>
Content-Type: text/plain
Date: Sat, 17 Jan 2009 11:34:44 +0100
Message-Id: <1232188484.6813.85.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-01-17 at 11:07 +0100, Peter Zijlstra wrote:
> On Sat, 2009-01-17 at 10:54 +0100, Mike Galbraith wrote:
> 
> Same comments as before..
> 
> > The problem with the C++ testcases seems to be wake_up_all() plunking a
> > genuine thundering herd onto runqueues.
> 
> I'm still trying to find what wake_up_all() is being hit... Both
> test-cases seem to create ping-pong threads/processes (lots of them
> though).

I logic leaped there from the sched_debug data.  Maybe bugs only made it
appear that leap was correct.

> >   The sleeper fairness logic
> > places the entire herd left of min_vruntime, meaning N*sched_latency
> > pain for the poor sods who are setting the runqueue pace.
> 
> Right, how about we flip the 'initial' case in place_entity() for !
> nr_exclusive wakeups.

Wouldn't that be more drastic than sleep denial?

>   		schedstat_inc(p, se.nr_wakeups_migrate);
> > @@ -2342,7 +2342,7 @@ out_activate:
> >  		schedstat_inc(p, se.nr_wakeups_local);
> >  	else
> >  		schedstat_inc(p, se.nr_wakeups_remote);
> > -	activate_task(rq, p, 1);
> > +	activate_task(rq, p, 1 + !herd);
> 
> Right, so how about 1 - !herd ?

Heh, I shouldn't start tinkering so early.

> > @@ -671,12 +671,12 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
> >  	 * little, place the new task so that it fits in the slot that
> >  	 * stays open at the end.
> >  	 */
> > -	if (initial && sched_feat(START_DEBIT))
> > +	if (!wakeup && sched_feat(START_DEBIT))
> >  		vruntime += sched_vslice(cfs_rq, se);
> >  
> > -	if (!initial) {
> > +	if (wakeup) {
> >  		/* sleeps upto a single latency don't count. */
> > -		if (sched_feat(NEW_FAIR_SLEEPERS)) {
> > +		if (sched_feat(NEW_FAIR_SLEEPERS && wakeup == 1)) {
> 
> That doesn't look like it fancies compiling though ;-)

Is booboo, but...

marge:..kernel/linux-2.6.29.git # make
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  SYMLINK include/asm -> include/asm-x86
  CALL    scripts/checksyscalls.sh
  CHK     include/linux/compile.h
  CC      kernel/sched.o
  LD      kernel/built-in.o
  LD      vmlinux.o
  MODPOST vmlinux.o
  GEN     .version
  CHK     include/linux/compile.h
  UPD     include/linux/compile.h
  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
  KSYM    .tmp_kallsyms1.S
  AS      .tmp_kallsyms1.o
  LD      .tmp_vmlinux2
  KSYM    .tmp_kallsyms2.S
  AS      .tmp_kallsyms2.o
  LD      vmlinux

>  	 * We can come here with TIF_NEED_RESCHED already set from new task
> > @@ -1416,10 +1421,10 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int sync)
> >  		return;
> >  	}
> >  
> > -	if (!sched_feat(WAKEUP_PREEMPT))
> > +	if (!sched_feat(WAKEUP_PREEMPT) || !sync & WAKE_PREEMPT)
> 
> C operator precendence suggests you write !(sync & WAKE_PREEMPT), unless
> you're attempting to write 0 in a complicated way.

Nope, booboo.

	-Mike

