Return-Path: <linux-kernel-owner+w=401wt.eu-S1759519AbZE2M5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759519AbZE2M5B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 08:57:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758729AbZE2M4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 08:56:53 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:37250 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758870AbZE2M4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 08:56:52 -0400
Date: Fri, 29 May 2009 14:56:14 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Rob van der Heij <rvdheij@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       john stultz <johnstul@us.ibm.com>
Subject: Re: [patch 1/2] idle profile hits with NOHZ
Message-ID: <20090529145614.77694e20@skybase>
In-Reply-To: <alpine.LFD.2.00.0905282204130.3397@localhost.localdomain>
References: <20090528150447.152019714@de.ibm.com>
	<20090528150502.044210490@de.ibm.com>
	<alpine.LFD.2.00.0905282204130.3397@localhost.localdomain>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 May 2009 22:19:44 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Thu, 28 May 2009, Martin Schwidefsky wrote:
> > --- quilt-2.6.orig/kernel/time/tick-sched.c
> > +++ quilt-2.6/kernel/time/tick-sched.c
> > @@ -166,6 +166,7 @@ static void tick_nohz_stop_idle(int cpu)
> >  		ts->idle_lastupdate = now;
> >  		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
> >  		ts->idle_active = 0;
> > +		ts->idle_pc = profile_pc(get_irq_regs());
> 
>   Hmm, tick_nohz_stop_idle() is called from
>   tick_nohz_restart_sched_tick() as well in the context of the idle
>   task.
> 
>   I think there is no guarantee that get_irq_regs() will return
>   anything useful in thread context.
> 
>   So get_irq_regs() might return a NULL pointer which will explode
>   some of the profile_pc() implementations. If not it can still feed
>   total nonsense to the profile_hits() call.

Drat, but if it is called from idle we should be able to just skip the
assignment to ts->idle_pc, no? Then a simple in_interrupt() test is
missing.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

