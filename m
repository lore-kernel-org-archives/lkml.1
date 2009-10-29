Return-Path: <linux-kernel-owner+w=401wt.eu-S1756725AbZJ2WUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725AbZJ2WUn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 18:20:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756099AbZJ2WUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 18:20:42 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:58618 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756045AbZJ2WUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 18:20:41 -0400
Date: Fri, 30 Oct 2009 03:50:37 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>
Subject: [RFC Patch 0/5] PERF-HW_BKPT: Enhance perf-events to profile
	memory accesses using hw-breakpoints - ver III
Message-ID: <20091029222037.GA14906@in.ibm.com>
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

The patches have been tested on an x86 box running -tip tree (commit
d80c46df1d0e6387f3e0a49d5ffba2669eb76d71) and is intended for -tip tree
submission if there are no further comments.

Changelog version II
---------------------
Version I: http://lkml.org/lkml/2009/10/26/461
Version II: http://lkml.org/lkml/2009/10/28/208

- Renamed the event names to "memory-write"/"w" and "memory-readwrite"/"rw".
- Kernel symbolnames will accompany event-names in perf statistics.
- A few more code comments.

An edited log of 'perf stat' and 'perf record' output is shown below for your
reference.

Thanks,
K.Prasad

Screen logs
------------
#
# perf stat -v -i -e rw:pid_max -e w:jiffies make kernel/futex.o
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  SYMLINK include/asm -> include/asm-x86
  CALL    scripts/checksyscalls.sh
  CC      kernel/futex.o
memory-readwrite:pid_max: 68 301693959 301693959
memory-write:jiffies: 195 301693959 301693959

 Performance counter stats for 'make kernel/futex.o':

             68  memory-readwrite:pid_max #      0.000 M/sec
            195  memory-write:jiffies     #      0.000 M/sec

   16.345075062  seconds time elapsed

#
#
# perf record -v -i -a -e rw:pid_max top

<Ran 'top' for about 10 seconds>

[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.076 MB perf.data (~3306 samples) ]
# 
# perf report -i perf.data 
No symbols found in /sbin/init, maybe install a debug package?
<snipped>
# Samples: 306
#
# Overhead          Command  Shared Object  Symbol
# ........  ...............  .............  ......
#
    27.45%              yum  [kernel]       [k] alloc_pid
    22.88%               sh  [kernel]       [k] alloc_pid
    22.88%         powertop  [kernel]       [k] alloc_pid
    15.03%             bash  [kernel]       [k] alloc_pid
    10.46%          khelper  [kernel]       [k] alloc_pid
     0.65%              top  [kernel]       [k] do_proc_dointvec_minmax_conv
     0.65%             perf  [kernel]       [k] alloc_pid
#
# (For a higher level overview, try: perf report --sort comm,dso)
#
# 

