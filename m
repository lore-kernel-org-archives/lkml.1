Return-Path: <linux-kernel-owner+w=401wt.eu-S932246AbYDUO15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932246AbYDUO15 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 10:27:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758719AbYDUO1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 10:27:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40596 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757749AbYDUO1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 10:27:48 -0400
Date: Mon, 21 Apr 2008 16:27:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86: improve default idle
Message-ID: <20080421142737.GU9554@elte.hu>
References: <200804181737.m3IHb2k7009676@hera.kernel.org> <20080418154333.f2584b1d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080418154333.f2584b1d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 18 Apr 2008 17:37:02 GMT
> Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:
> 
> > Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=13af4836b3914b23946f6a8982934e2c828c183f
> > Commit:     13af4836b3914b23946f6a8982934e2c828c183f
> > Parent:     f5149a49f994e5c469ac398af7cdeb8eb612d3a4
> > Author:     Ingo Molnar <mingo@elte.hu>
> > AuthorDate: Wed Apr 2 13:23:22 2008 +0200
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Thu Apr 17 17:41:34 2008 +0200
> > 
> >     x86: improve default idle
> >     
> >     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > ---
> >  arch/x86/kernel/process_32.c |    8 --------
> >  arch/x86/kernel/process_64.c |    8 --------
> >  2 files changed, 0 insertions(+), 16 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
> > index 08c41ed..3903a8f 100644
> > --- a/arch/x86/kernel/process_32.c
> > +++ b/arch/x86/kernel/process_32.c
> > @@ -113,16 +113,8 @@ void default_idle(void)
> >  
> >  		local_irq_disable();
> >  		if (!need_resched()) {
> > -			ktime_t t0, t1;
> > -			u64 t0n, t1n;
> > -
> > -			t0 = ktime_get();
> > -			t0n = ktime_to_ns(t0);
> >  			safe_halt();	/* enables interrupts racelessly */
> >  			local_irq_disable();
> > -			t1 = ktime_get();
> > -			t1n = ktime_to_ns(t1);
> > -			sched_clock_idle_wakeup_event(t1n - t0n);
> >  		}
> >  		local_irq_enable();
> >  		current_thread_info()->status |= TS_POLLING;
> > diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
> > index 4f40272..e75ccc8 100644
> > --- a/arch/x86/kernel/process_64.c
> > +++ b/arch/x86/kernel/process_64.c
> > @@ -107,16 +107,8 @@ void default_idle(void)
> >  	smp_mb();
> >  	local_irq_disable();
> >  	if (!need_resched()) {
> > -		ktime_t t0, t1;
> > -		u64 t0n, t1n;
> > -
> > -		t0 = ktime_get();
> > -		t0n = ktime_to_ns(t0);
> >  		safe_halt();	/* enables interrupts racelessly */
> >  		local_irq_disable();
> > -		t1 = ktime_get();
> > -		t1n = ktime_to_ns(t1);
> > -		sched_clock_idle_wakeup_event(t1n - t0n);
> >  	}
> >  	local_irq_enable();
> >  	current_thread_info()->status |= TS_POLLING;
> 
> Ingo, what's going on?  There is no way that this patch is so obvious 
> that it doesn't even need a changelog.

sorry, the changelog should be: if a system uses acpi_pm clocksource but 
default idle method then the overhead of entry/exit measurement is quite 
noticeable in profiles. The measurement is redundant anyway, as in HLT 
sched_clock() is still supposed to work fine. (the worst i know of is a 
slight skew on certain CPUs in HLT)

	Ingo
