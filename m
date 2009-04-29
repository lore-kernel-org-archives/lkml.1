Return-Path: <linux-kernel-owner+w=401wt.eu-S1753314AbZD2Jt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314AbZD2Jt6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 05:49:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751779AbZD2Jtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 05:49:49 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:58081 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbZD2Jts convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 05:49:48 -0400
Date: Wed, 29 Apr 2009 11:48:01 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andrew Gallatin <gallatin@myri.com>, linux-kernel@vger.kernel.org,
       rick.jones2@hp.com, brice@myri.com, Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] sched: account system time properly
Message-ID: <20090429114801.09637e46@skybase>
In-Reply-To: <49F81BC3.2050805@cosmosbay.com>
References: <49F078FA.6010507@myri.com>
	<20090428163004.46733752.akpm@linux-foundation.org>
	<49F7DF44.8090907@cosmosbay.com>
	<49F805C9.9070303@cosmosbay.com>
	<20090429100840.77359cae@skybase>
	<49F81BC3.2050805@cosmosbay.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Apr 2009 11:20:03 +0200
Eric Dumazet <dada1@cosmosbay.com> wrote:

> Martin Schwidefsky a écrit :
> > On Wed, 29 Apr 2009 09:46:17 +0200
> > Eric Dumazet <dada1@cosmosbay.com> wrote:
> > 
> >> Eric Dumazet a écrit :
> >>> Andrew Morton a écrit :
> >>>
> >>> So, if IRQs are interrupting idle task, I guess if (p != rq->idle) will be false.
> >>>
> > 
> > If an IRQ interrupts the idle task the tick is supposed to be accounted
> > as an idle tick. Only if the IRQ interrupted the system while it has
> > been in hardirq or softirq processing then it should be accounted as
> > system tick.
> > 
> >> Maybe following patch is needed ?
> >>
> >> [PATCH] sched: account system time properly
> >>
> >> When idle task is interrupted by an IRQ, time accounting considers CPU is idle,
> >> even while it should account for hard or softirq.
> >>
> >> Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
> >>
> >> diff --git a/kernel/sched.c b/kernel/sched.c
> >> index b902e58..26efa47 100644
> >> --- a/kernel/sched.c
> >> +++ b/kernel/sched.c
> >> @@ -4732,7 +4732,7 @@ void account_process_tick(struct task_struct *p, int user_tick)
> >>  
> >>  	if (user_tick)
> >>  		account_user_time(p, one_jiffy, one_jiffy_scaled);
> >> -	else if (p != rq->idle)
> >> +	else if ((p != rq->idle) || (irq_count() != HARDIRQ_OFFSET))
> >>  		account_system_time(p, HARDIRQ_OFFSET, one_jiffy,
> >>  				    one_jiffy_scaled);
> >>  	else
> > 
> > That patch makes a lot of sense to me. Does it fix the problem?
> > 
> 
> Yes it does, on my machine at least :
> 
> 11:18:48 AM  CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest   %idle
> 11:18:58 AM  all    0.00    0.00    0.00    0.00    0.21    0.69    0.00    0.00   99.10
> 11:18:58 AM    0    0.00    0.00    0.00    0.00    1.70    5.50    0.00    0.00   92.80  << HERE >>
> 11:18:58 AM    1    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00  100.00
> 11:18:58 AM    2    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00  100.00
> 11:18:58 AM    3    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00  100.00
> 11:18:58 AM    4    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00  100.00
> 11:18:58 AM    5    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00  100.00
> 11:18:58 AM    6    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00  100.00
> 11:18:58 AM    7    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00  100.00

Very good. Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com> 


-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

