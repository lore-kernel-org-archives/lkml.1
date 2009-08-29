Return-Path: <linux-kernel-owner+w=401wt.eu-S1751830AbZH2Omu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830AbZH2Omu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 10:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751711AbZH2Omt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 10:42:49 -0400
Received: from fifo99.com ([67.223.236.141]:56620 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751700AbZH2Omt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 10:42:49 -0400
Subject: Re: System lockup with 2.6.26.8-rt16 on ARM9 [Solved]
From: Daniel Walker <dwalker@fifo99.com>
To: Remy Bohmer <linux@bohmer.net>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>
In-Reply-To: <3efb10970908290047k6f4d5a14of148db7f2b179f18@mail.gmail.com>
References: <3efb10970908290047k6f4d5a14of148db7f2b179f18@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 29 Aug 2009 07:42:45 -0700
Message-Id: <1251556965.9909.10.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-08-29 at 09:47 +0200, Remy Bohmer wrote:

> Well, we found the root cause of this problem.
> It turned out to be caused by sched_clock() that made disjunct time jumps.
> This caused this check to become true in kernel/sched_rt.c:370:
>          if (rt_rq->rt_time > runtime) {
>                 rt_rq->rt_throttled = 1;
>                 if (rt_rq_throttled(rt_rq)) {
>                         sched_rt_rq_dequeue(rt_rq);
>                         return 1;
>                 }
>         }
> 
> The end results is that all realtime tasks got throttled for a long
> time, and that time got extended every time sched_clock() made such a
> jump. I would never have expected the scheduler would show this kind
> of behaviour while CONFIG_RT_GROUP_SCHED is _not_ set...
> 
> The root-cause of the sched_clock being faulty was a synchronisation
> issue between 2 clock domains. The CPU clock and the clock domain of
> the peripheral (GPT) on which the sched_clock() implementation was
> based. The GPT made jumps backwards which triggered a false wraparound
> detection in the conversion of 32->64 bit timestamps, causing the time
> to jump about 356 seconds in the future...
> 

Can you tell us more about what type of board this was? I've never heard
of a ARM board having an unstable clocksource before ..

Daniel

