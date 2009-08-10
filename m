Return-Path: <linux-kernel-owner+w=401wt.eu-S1753290AbZHJUxN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbZHJUxN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 16:53:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834AbZHJUxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 16:53:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60916 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753118AbZHJUxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 16:53:11 -0400
Date: Mon, 10 Aug 2009 16:52:19 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: fweisbec@gmail.com, mingo@elte.hu, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
       jiayingz@google.com, mbligh@google.com, lizf@cn.fujitsu.com
Message-Id: <cover.1249932670.git.jbaron@redhat.com>
Subject: [PATCH 00/12] add syscall tracepoints V3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

The following is an implementation of Frederic's syscall tracer on top of
tracepoints. It adds the ability to toggle the entry/exit of each syscall
via the standard events/syscalls/syscall_blah/enable interface. The
implementation is done by adding 2 tracepoints. One on entry and one for exit.

The patchset now also addes 'perf' tool support for counting the number of
syscall events. For example, I did a simple strace of 'cat'ing' a file, and
then verified that 'perf stat' gave a similar count.

For example:

#   perf stat -e syscalls:sys_enter_brk -e syscalls:sys_exit_brk -e syscalls:sys_enter_mmap -e syscalls:sys_enter_mmap -e syscalls:sys_enter_access -e syscalls:sys_exit_access  -e syscalls:sys_enter_close -e syscalls:sys_exit_close -e syscalls:sys_enter_read -e syscalls:sys_exit_read -e syscalls:sys_enter_write -e syscalls:sys_exit_write -e syscalls:sys_enter_mprotect -e syscalls:sys_exit_mprotect -e  syscalls:sys_enter_open -e syscalls:sys_exit_open -e syscalls:sys_enter_newfstat -e syscalls:sys_exit_newfstat -e syscalls:sys_enter_exit_group -e syscalls:sys_exit_exit_group cat /tmp/foo 


 Performance counter stats for 'cat /tmp/foo':

              3  syscalls:sys_enter_brk  
              3  syscalls:sys_exit_brk   
              9  syscalls:sys_enter_mmap 
              9  syscalls:sys_enter_mmap 
              1  syscalls:sys_enter_access
              1  syscalls:sys_exit_access
              6  syscalls:sys_enter_close
              6  syscalls:sys_exit_close 
              3  syscalls:sys_enter_read 
              3  syscalls:sys_exit_read  
              1  syscalls:sys_enter_write
              1  syscalls:sys_exit_write 
              3  syscalls:sys_enter_mprotect
              3  syscalls:sys_exit_mprotect
              4  syscalls:sys_enter_open 
              4  syscalls:sys_exit_open  
              5  syscalls:sys_enter_newfstat
              5  syscalls:sys_exit_newfstat
              1  syscalls:sys_enter_exit_group
              0  syscalls:sys_exit_exit_group

    0.000864861  seconds time elapsed


thanks,

-Jason


 arch/x86/include/asm/ftrace.h  |    4 +-
 arch/x86/kernel/ftrace.c       |   41 ++++--
 arch/x86/kernel/ptrace.c       |    6 +-
 arch/x86/kernel/sys_x86_64.c   |    8 +-
 include/linux/ftrace_event.h   |    5 +-
 include/linux/perf_counter.h   |    2 +
 include/linux/syscalls.h       |  125 ++++++++++++++++-
 include/linux/tracepoint.h     |   31 ++++-
 include/trace/ftrace.h         |    4 +-
 include/trace/syscall.h        |   54 ++++++--
 kernel/trace/trace.h           |    6 -
 kernel/trace/trace_events.c    |   33 +++--
 kernel/trace/trace_syscalls.c  |  311 ++++++++++++++++++++++++++++------------
 kernel/tracepoint.c            |   38 +++++
 tools/perf/util/parse-events.c |    8 +-
 15 files changed, 522 insertions(+), 154 deletions(-)

