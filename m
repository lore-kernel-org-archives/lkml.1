Return-Path: <linux-kernel-owner+w=401wt.eu-S932192AbZJFLsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932192AbZJFLsA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 07:48:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756063AbZJFLr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 07:47:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55541 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755941AbZJFLr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 07:47:58 -0400
Date: Tue, 6 Oct 2009 13:47:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: find_busiest_group using lots of CPU
Message-ID: <20091006114716.GA28609@elte.hu>
References: <20090930081811.GP23126@kernel.dk> <1254745898.26976.52.camel@twins> <20091006075127.GF5216@kernel.dk> <20091006112006.GO5216@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091006112006.GO5216@kernel.dk>
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


* Jens Axboe <jens.axboe@oracle.com> wrote:

> On Tue, Oct 06 2009, Jens Axboe wrote:
> > On Mon, Oct 05 2009, Peter Zijlstra wrote:
> > > On Wed, 2009-09-30 at 10:18 +0200, Jens Axboe wrote:
> > > > Hi,
> > > > 
> > > > I stuffed a few more SSDs into my text box. Running a simple workload
> > > > that just does streaming reads from 10 processes (throughput is around
> > > > 2.2GB/sec), find_busiest_group() is using > 10% of the CPU time. This is
> > > > a 64 thread box.
> > > > 
> > > > The top two profile entries are:
> > > > 
> > > >     10.86%      fio  [kernel]                [k] find_busiest_group
> > > >                 |          
> > > >                 |--99.91%-- thread_return
> > > >                 |          io_schedule
> > > >                 |          sys_io_getevents
> > > >                 |          system_call_fastpath
> > > >                 |          0x7f4b50b61604
> > > >                 |          |          
> > > >                 |           --100.00%-- td_io_getevents
> > > >                 |                     io_u_queued_complete
> > > >                 |                     thread_main
> > > >                 |                     run_threads
> > > >                 |                     main
> > > >                 |                     __libc_start_main
> > > >                  --0.09%-- [...]
> > > > 
> > > >      5.78%      fio  [kernel]                [k] cpumask_next_and
> > > >                 |          
> > > >                 |--67.21%-- thread_return
> > > >                 |          io_schedule
> > > >                 |          sys_io_getevents
> > > >                 |          system_call_fastpath
> > > >                 |          0x7f4b50b61604
> > > >                 |          |          
> > > >                 |           --100.00%-- td_io_getevents
> > > >                 |                     io_u_queued_complete
> > > >                 |                     thread_main
> > > >                 |                     run_threads
> > > >                 |                     main
> > > >                 |                     __libc_start_main
> > > >                 |          
> > > >                  --32.79%-- find_busiest_group
> > > >                            thread_return
> > > >                            io_schedule
> > > >                            sys_io_getevents
> > > >                            system_call_fastpath
> > > >                            0x7f4b50b61604
> > > >                            |          
> > > >                             --100.00%-- td_io_getevents
> > > >                                       io_u_queued_complete
> > > >                                       thread_main
> > > >                                       run_threads
> > > >                                       main
> > > >                                       __libc_start_main
> > > > 
> > > > This is with SCHED_DEBUG=y and SCHEDSTATS=y enabled, I just tried with
> > > > both disabled but that yields the same result (well actually worse, 22%
> > > > spent in there. dunno if that's normal "fluctuation"). GROUP_SCHED is
> > > > not set. This seems way excessive!
> > > 
> > > io_schedule() straight into find_busiest_group() leads me to think this
> > > could be SD_BALANCE_NEWIDLE, does something like:
> > > 
> > > for i in /proc/sys/kernel/sched_domain/cpu*/domain*/flags; 
> > > do 
> > > 	val=`cat $i`; echo $((val & ~0x02)) > $i; 
> > > done
> > > 
> > > [ assuming SCHED_DEBUG=y ]
> > > 
> > > Cure things?
> > 
> > I can try, as mentioned it doesn't look any better with SCHED_DEBUG=n
> 
> It does, it's gone from the profiles.

Peter mentioned SCHED_DEBUG=y to have 
/proc/sys/kernel/sched_domain/cpu*/domain*/flags available.

	Ingo
