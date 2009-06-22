Return-Path: <linux-kernel-owner+w=401wt.eu-S1756570AbZFVOl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570AbZFVOl2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 10:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751497AbZFVOlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 10:41:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39631 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342AbZFVOlU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 10:41:20 -0400
Date: Mon, 22 Jun 2009 16:41:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Rob van der Heij <rvdheij@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       john stultz <johnstul@us.ibm.com>, Andi Kleen <andi@firstfloor.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch 0/2] NOHZ vs. profile/oprofile v2
Message-ID: <20090622144110.GA9771@elte.hu>
References: <20090603152223.083010123@de.ibm.com> <alpine.LFD.2.00.0906092252150.3351@localhost.localdomain> <20090622162631.4b4dcee4@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090622162631.4b4dcee4@skybase>
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


* Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:

> On Tue, 9 Jun 2009 22:52:51 +0200 (CEST)
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > > version 2 of the profile patches. The only change is the in_interrupt()
> > > fix in tick_nohz_stop_idle(). I would like to know how to proceed with
> > > the issue.
> > > Andy, do you still prefer to handle the old style profiler analog to
> > > the oprofile patch? If yes I would drop patch #1 and extend patch #2
> > > with another tick_nohz_disable().  
> > 
> > Any update on this one ?
> 
> A solution to this problem should go upstream soon, no? How about this
> patch, it uses the tick_nohz_disable/tick_nohz_enable mechanic for 
> oprofile and the old style kernel profiler. Good enough ?
> 
> ---
> Subject: [PATCH] keep on ticking if a profiler is active
> 
> From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> 
> On a NOHZ system with oprofile or the old style kernel profiler enabled
> the timer tick should not be stopped when a cpu goes idle. Currently
> a maximum of 1 tick is accounted if a cpu sleeps for a longer period of
> time. This does bad things to the percentages in the profiler output.
> 
> Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> ---
> 
>  drivers/oprofile/oprof.c |    3 +++
>  include/linux/tick.h     |    4 ++++
>  kernel/profile.c         |    4 ++++
>  kernel/time/tick-sched.c |   27 ++++++++++++++++++++++++++-
>  4 files changed, 37 insertions(+), 1 deletion(-)

Hm, this is rather ugly. Why not use hrtimers like 'perf' does when 
it fallback-samples based on the timer tick?

That method has three advantages:

 - no weird hookery needed
 - resolution can go far beyond HZ
 - it is evidently dynticks-safe

	Ingo
