Return-Path: <linux-kernel-owner+w=401wt.eu-S1756307AbYGRKg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307AbYGRKg1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 06:36:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753832AbYGRKgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 06:36:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44392 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752976AbYGRKgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 06:36:19 -0400
Date: Fri, 18 Jul 2008 12:35:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [git pull] tracing fixes
Message-ID: <20080718103559.GA4368@elte.hu>
References: <20080717173210.GA12828@elte.hu> <Pine.LNX.4.58.0807172249230.22792@gandalf.stny.rr.com> <20080718084152.GJ6875@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080718084152.GJ6875@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > >  CFLAGS_REMOVE_sched_clock.o = -pg
> > > +CFLAGS_REMOVE_sched.o = -mno-spe -pg
> > >  endif
> > >
> > 
> > Ingo,
> > 
> > Why not trace the scheduler functions? I found a lot of useful 
> > information from seeing what functions are being called (namely the 
> > latencies caused by the fair scheduler balancing). Not being able to 
> > trace sched.c seems to keep a lot of useful data from being accessed.
> 
> i agree in general, but it was causing lockups with:
> 
>       http://redhat.com/~mingo/misc/config-Thu_Jul_17_13_34_52_CEST_2008
> 
> note the MAXSMP in the config which sets NR_CPUS to 4096:
> 
>       CONFIG_NR_CPUS=4096
> 
> our randconfig testing stumbled on it. That is a debug helper to "tune 
> up the kernel for as large systems as possible" and can bring in 
> regressions not normally seen.

ok, figured it out today: the lockups were due to the NMI watchdog and a 
missing NMI protection in cpu_clock(). I've reactivated the topic that 
solves this problem area and it all works fine now.

the sched.o change probably made a difference just because it reduced 
the cross section between the NMI watchdog and the scheduler, making 
lockups less likely during the ftrace self-test. I'll revert it once the 
tracing/nmisafe is upstream.

	Ingo
