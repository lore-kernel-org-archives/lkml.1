Return-Path: <linux-kernel-owner+w=401wt.eu-S1754768AbZJ1P6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768AbZJ1P6e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 11:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754735AbZJ1P6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 11:58:33 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:41650 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725AbZJ1P6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 11:58:33 -0400
Date: Wed, 28 Oct 2009 21:28:27 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>
Subject: [RFC Patch 0/4] Enhance perf-events to profile memory accesses
	using hw-breakpoints - ver II
Message-ID: <20091028155827.GA8604@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,
	Please find version II of the patchset that enables perf-events to
place hw-breakpoints over kernel symbols (along with requisite enhancements to
the hw-breakpoint layer).

Changelog version II
---------------------
Version I: http://lkml.org/lkml/2009/10/26/461

- Fixed parsing issues that disallowed other perf events to be invoked
- Fixed user-space breakpoint usage which was broken due to patch 2/4
- Introduced an instance of perf_sample_data for use by do_perf_sw_event()

An edited log of 'perf stat' and 'perf record' output is shown below for your
reference.

Kindly let me know your suggestions/feedback about the same.

Thanks,
K.Prasad

Screen logs
------------
# perf stat -v -i -e breakpoint-readwrite:pid_max -e breakpoint-write:jiffies make kernel/futex.o
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  SYMLINK include/asm -> include/asm-x86
  CALL    scripts/checksyscalls.sh
  CC      kernel/futex.o
breakpoint-readwrite: 68 298512531 298512531
breakpoint-write: 235 298512531 298512531

 Performance counter stats for 'make kernel/futex.o':

             68  breakpoint-readwrite     #      0.000 M/sec
            235  breakpoint-write         #      0.000 M/sec

   14.571235288  seconds time elapsed

#
#
# perf record -v -i -e breakpoint-readwrite:jiffies top

[Ran 'top' for about 10 seconds]

# perf report -i perf.data
# Samples: 2022950155
#
# Overhead  Command  Shared Object  Symbol
# ........  .......  .............  ......
#
    99.99%      top  [kernel]       [k] scheduler_tick
     0.01%     perf  [kernel]       [k] scheduler_tick
     0.00%      top  [kernel]       [k] set_track
     0.00%      top  [kernel]       [k] run_timer_softirq
     0.00%     perf  [kernel]       [k] set_track
     0.00%      top  [kernel]       [k] __call_rcu
     0.00%      top  [kernel]       [k] calc_global_load
     0.00%      top  [kernel]       [k] do_timer
     0.00%      top  [kernel]       [k] __rcu_process_callbacks
#
# (For a higher level overview, try: perf report --sort comm,dso)
#
