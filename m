Return-Path: <linux-kernel-owner+w=401wt.eu-S1753900AbXHUJHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900AbXHUJHo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 05:07:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753375AbXHUJHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 05:07:33 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:16598 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633AbXHUJHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 05:07:32 -0400
Subject: Re: [accounting regression since rc1]  scheduler updates
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Ingo Molnar <mingo@elte.hu>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jan Glauber <jang@linux.vnet.ibm.com>, heiko.carstens@de.ibm.com,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <20070821084243.GB1144@elte.hu>
References: <20070812163225.GA11996@elte.hu>
	 <200708141037.48001.borntraeger@de.ibm.com> <20070820154529.GA300@elte.hu>
	 <200708211017.02998.borntraeger@de.ibm.com> <20070821084243.GB1144@elte.hu>
Content-Type: text/plain
Organization: IBM Corporation
Date: Tue, 21 Aug 2007 11:11:16 +0200
Message-Id: <1187687476.7623.8.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-21 at 10:42 +0200, Ingo Molnar wrote:
> * Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> 
> > Am Montag, 20. August 2007 schrieb Ingo Molnar:
> > > could you send that precise sched_clock() patch? It should be an order 
> > > of magnitude simpler than the high-precision stime/utime tracking you 
> > > already do, and it's needed for quality scheduling anyway.
> > 
> > I have a question about that. I just played with sched_clock, and even 
> > when I intentionally slow down sched_clock by a factor of 2, my cpu 
> > bound process gets 100 % in top. If this is intentional, I dont 
> > understand how a virtualized sched_clock would fix the accounting 
> > change?
> 
> hm, does on s390 scheduler_tick() get driven in virtual time or in real 
> time? The very latest scheduler code will enforce a minimum rate of 
> sched_clock() across two scheduler_tick() calls (in rc3 and later 
> kernels). If sched_clock() "slows down" but scheduler_tick() still has a 
> real-time frequency then that impacts the quality of scheduling. So 
> scheduler_tick() and sched_clock() must really have the same behavior 
> (either both are virtual or both are real), so that scheduling becomes 
> invariant to steal-time.

scheduler_tick() is based on the HZ timer which uses the TOD clock =
real time. sched_clock() currently uses the TOD clock as well so in
regard to the new scheduler we currently do not have a problem. We have
a problem with cpu time accounting, the change to the /proc code breaks
the precise accounting on s390. To solve the cpu time accounting we need
to change sched_clock() to the cpu timer = virtual time. To change the
scheduler_tick() as well requires another patch and I fear it would
complicate things in the s390 backend.

And if you say that the scheduling becomes invariant to steal-time, how
is the cpu time accounting via sum_exec supposed to work if it does not
take steal-time into account ?

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


