Return-Path: <linux-kernel-owner+w=401wt.eu-S1753394AbZJEM3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbZJEM3R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 08:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbZJEM3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 08:29:16 -0400
Received: from viefep13-int.chello.at ([62.179.121.33]:9560 "EHLO
	viefep13-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbZJEM3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 08:29:16 -0400
X-SourceIP: 213.93.53.227
Subject: Re: find_busiest_group using lots of CPU
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, mingo@elte.hu
In-Reply-To: <20090930081811.GP23126@kernel.dk>
References: <20090930081811.GP23126@kernel.dk>
Content-Type: text/plain
Date: Mon, 05 Oct 2009 14:31:38 +0200
Message-Id: <1254745898.26976.52.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-30 at 10:18 +0200, Jens Axboe wrote:
> Hi,
> 
> I stuffed a few more SSDs into my text box. Running a simple workload
> that just does streaming reads from 10 processes (throughput is around
> 2.2GB/sec), find_busiest_group() is using > 10% of the CPU time. This is
> a 64 thread box.
> 
> The top two profile entries are:
> 
>     10.86%      fio  [kernel]                [k] find_busiest_group
>                 |          
>                 |--99.91%-- thread_return
>                 |          io_schedule
>                 |          sys_io_getevents
>                 |          system_call_fastpath
>                 |          0x7f4b50b61604
>                 |          |          
>                 |           --100.00%-- td_io_getevents
>                 |                     io_u_queued_complete
>                 |                     thread_main
>                 |                     run_threads
>                 |                     main
>                 |                     __libc_start_main
>                  --0.09%-- [...]
> 
>      5.78%      fio  [kernel]                [k] cpumask_next_and
>                 |          
>                 |--67.21%-- thread_return
>                 |          io_schedule
>                 |          sys_io_getevents
>                 |          system_call_fastpath
>                 |          0x7f4b50b61604
>                 |          |          
>                 |           --100.00%-- td_io_getevents
>                 |                     io_u_queued_complete
>                 |                     thread_main
>                 |                     run_threads
>                 |                     main
>                 |                     __libc_start_main
>                 |          
>                  --32.79%-- find_busiest_group
>                            thread_return
>                            io_schedule
>                            sys_io_getevents
>                            system_call_fastpath
>                            0x7f4b50b61604
>                            |          
>                             --100.00%-- td_io_getevents
>                                       io_u_queued_complete
>                                       thread_main
>                                       run_threads
>                                       main
>                                       __libc_start_main
> 
> This is with SCHED_DEBUG=y and SCHEDSTATS=y enabled, I just tried with
> both disabled but that yields the same result (well actually worse, 22%
> spent in there. dunno if that's normal "fluctuation"). GROUP_SCHED is
> not set. This seems way excessive!

io_schedule() straight into find_busiest_group() leads me to think this
could be SD_BALANCE_NEWIDLE, does something like:

for i in /proc/sys/kernel/sched_domain/cpu*/domain*/flags; 
do 
	val=`cat $i`; echo $((val & ~0x02)) > $i; 
done

[ assuming SCHED_DEBUG=y ]

Cure things?

If so, then its spending time looking for work, which there might not be
on your machine, since everything is waiting for IO or somesuch.

Not really sure what to do about it though, this is a quad socket
nehalem, right? We could possibly disable SD_BALANCE_NEWIDLE on the NODE
level, but that would again decrease throughput in things like kbuild.

