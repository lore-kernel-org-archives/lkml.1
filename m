Return-Path: <linux-kernel-owner+w=401wt.eu-S1760185AbXFQVr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760185AbXFQVr5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 17:47:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752659AbXFQVrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 17:47:49 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:36073 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147AbXFQVrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 17:47:48 -0400
To: mingo@elte.hu
CC: cebbert@redhat.com, chris@atlee.ca, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, torvalds@linux-foundation.org,
       akpm@linux-foundation.org
In-reply-to: <20070616103707.GA28096@elte.hu> (message from Ingo Molnar on
	Sat, 16 Jun 2007 12:37:07 +0200)
Subject: Re: [BUG] long freezes on thinkpad t60
References: <E1HrC3W-0005SZ-00@dorka.pomaz.szeredi.hu> <20070524125453.GA7554@elte.hu> <E1HrDuQ-0005m7-00@dorka.pomaz.szeredi.hu> <20070524141059.GA19872@elte.hu> <E1HrEIp-0005qy-00@dorka.pomaz.szeredi.hu> <20070524144447.GA25068@elte.hu> <E1HrGom-0006AC-00@dorka.pomaz.szeredi.hu> <20070524210153.GB19672@elte.hu> <E1HrWSH-0000mH-00@dorka.pomaz.szeredi.hu> <E1Hyrnk-0006On-00@dorka.pomaz.szeredi.hu> <20070616103707.GA28096@elte.hu>
Message-Id: <E1I02Zx-0005qu-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sun, 17 Jun 2007 23:46:37 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck, Ingo, thanks for the responses.

> > The pattern that emerges is that on CPU0 we have an interrupt, which 
> > is trying to acquire the rq lock, but can't.
> > 
> > On CPU1 we have strace which is doing wait_task_inactive(), which sort 
> > of spins acquiring and releasing the rq lock.  I've checked some of 
> > the traces and it is just before acquiring the rq lock, or just after 
> > releasing it, but is not actually holding it.
> > 
> > So is it possible that wait_task_inactive() could be starving the 
> > other waiters of the rq spinlock?  Any ideas?
> 
> hm, this is really interesting, and indeed a smoking gun. The T60 has a 
> Core2Duo and i've _never_ seen MESI starvation happen on dual-core 
> single-socket CPUs! (The only known serious MESI starvation i know about 
> is on multi-socket Opterons: there the trylock loop of spinlock 
> debugging is known to starve some CPUs out of those locks that are being 
> polled, so we had to turn off that aspect of spinlock debugging.)
> 
> wait_task_inactive(), although it busy-loops, is pretty robust: it does 
> a proper spin-lock/spin-unlock sequence and has a cpu_relax() inbetween. 
> Furthermore, the rep_nop() that cpu_relax() is based on is 
> unconditional, so it's not like we could somehow end up not having the 
> REP; NOP sequence there (which should make the lock polling even more 
> fair)
> 
> could you try the quick hack below, ontop of cfs-v17? It adds two things 
> to wait_task_inactive():
> 
> - a cond_resched() [in case you are running !PREEMPT]
> 
> - use MONITOR+MWAIT to monitor memory transactions to the rq->curr 
>   cacheline. This should make the polling loop definitely fair.

Is it not possible for the mwait to get stuck?

> If this solves the problem on your box then i'll do a proper fix and 
> introduce a cpu_relax_memory_change(*addr) type of API to around 
> monitor/mwait. This patch boots fine on my T60 - but i never saw your 
> problem.

Yes, the patch does make the pauses go away.  In fact just the
smp_mb() seems to suffice.

> [ btw., utrace IIRC fixes ptrace to get rid of wait_task_interactive(). ]

I looked at the utrace patch, and it still has wait_task_inactive(),
and I can still reproduce the freezes with the utrace patch applied.

Miklos
