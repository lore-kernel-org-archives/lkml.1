Return-Path: <linux-kernel-owner+w=401wt.eu-S1754066AbZI3ISJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066AbZI3ISJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 04:18:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753428AbZI3ISI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 04:18:08 -0400
Received: from brick.kernel.dk ([93.163.65.50]:48492 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752913AbZI3ISH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 04:18:07 -0400
Date: Wed, 30 Sep 2009 10:18:11 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl
Subject: find_busiest_group using lots of CPU
Message-ID: <20090930081811.GP23126@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I stuffed a few more SSDs into my text box. Running a simple workload
that just does streaming reads from 10 processes (throughput is around
2.2GB/sec), find_busiest_group() is using > 10% of the CPU time. This is
a 64 thread box.

The top two profile entries are:

    10.86%      fio  [kernel]                [k] find_busiest_group
                |          
                |--99.91%-- thread_return
                |          io_schedule
                |          sys_io_getevents
                |          system_call_fastpath
                |          0x7f4b50b61604
                |          |          
                |           --100.00%-- td_io_getevents
                |                     io_u_queued_complete
                |                     thread_main
                |                     run_threads
                |                     main
                |                     __libc_start_main
                 --0.09%-- [...]

     5.78%      fio  [kernel]                [k] cpumask_next_and
                |          
                |--67.21%-- thread_return
                |          io_schedule
                |          sys_io_getevents
                |          system_call_fastpath
                |          0x7f4b50b61604
                |          |          
                |           --100.00%-- td_io_getevents
                |                     io_u_queued_complete
                |                     thread_main
                |                     run_threads
                |                     main
                |                     __libc_start_main
                |          
                 --32.79%-- find_busiest_group
                           thread_return
                           io_schedule
                           sys_io_getevents
                           system_call_fastpath
                           0x7f4b50b61604
                           |          
                            --100.00%-- td_io_getevents
                                      io_u_queued_complete
                                      thread_main
                                      run_threads
                                      main
                                      __libc_start_main

This is with SCHED_DEBUG=y and SCHEDSTATS=y enabled, I just tried with
both disabled but that yields the same result (well actually worse, 22%
spent in there. dunno if that's normal "fluctuation"). GROUP_SCHED is
not set. This seems way excessive!

-- 
Jens Axboe

