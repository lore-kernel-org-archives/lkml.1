Return-Path: <linux-kernel-owner+w=401wt.eu-S1753040AbZGTRIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040AbZGTRIQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 13:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752738AbZGTRIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 13:08:15 -0400
Received: from mail-px0-f193.google.com ([209.85.216.193]:53625 "EHLO
	mail-px0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602AbZGTRIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 13:08:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=FhCQPOJ0FpYo/ZyJyzF6OG7x25GMOhi7ZgHgA1wMNO1KZLS/H3bJZbG36Iaf1SK+Hj
         RkhGvj8knv63sw2LQ/RWPe8mNIKBH/4n0Ag+TjScfRwkPI8RFq4v8WP2HX20L1hh7QNz
         GmzfYfpPgNFgu9DRzECbu8NZpcBDhLmO/AdXM=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linuxtronix.de>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Anton Blanchard <anton@samba.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "K . Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: [RFC][PATCH 0/5] hw-breakpoints: Make the API generic + support for perfcounters
Date: Mon, 20 Jul 2009 13:08:02 -0400
Message-Id: <1248109687-7808-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset aims to make the hardware breakpoint API generic and
also to provide the support for hardware breakpoints from perfcounters.

The hardware breakpoint API changes are a first shot of idea.

The support for perf counter has strange effects. It looks like only
a part of the breakpoint events are actually recorded. The triggered callback
receives well the events but if there are only few of them, none is passed
in userspace (or userspace ignores them, dunno). Once I have some time, I'll
take a deeper look inside the perf mmap syscall or whatever could be
the origin.

Thanks.

Example which traces the BKL accesses by stressing reiserfs:

bkl=0x$(cat ../../System.map | grep kernel_flag | cut -d" " -f 1)
./perf record -f -g -e 5:$bkl -- dbench -t 20 20
./perf report -g -s s
 # Samples: 36
 #
 # Overhead  Symbol
 # ........  ......
 #
    83.33%  [k] lock_kernel
                |
                |--51.72%-- __pwrite64
                |
                |--27.59%-- 0x7f9d83a17b15
                |
                |--13.79%-- __open
                |
                 --10.34%-- unlink

    16.67%  [k] unlock_kernel
                |
                |--80.00%-- 0x7f9d83a17b15
                |
                |--20.00%-- unlink
                |
                 --20.00%-- __pwrite64

Frederic Weisbecker (5):
  hw-breakpoints: Make kernel breakpoints API truly generic
  hw-breakpoints: Pull up the target symbol in a generic field
  hw-breakpoints: Make user breakpoints API truly generic
  perfcounter: Grow the event number to 64 bits
  perfcounter: Add support for kernel hardware breakpoints

 arch/x86/include/asm/hw_breakpoint.h    |    9 ++-
 arch/x86/kernel/hw_breakpoint.c         |   91 +++++++++++-----
 arch/x86/kernel/ptrace.c                |   21 ++--
 include/asm-generic/hw_breakpoint.h     |  116 ++++++++-------------
 include/linux/perf_counter.h            |    1 +
 kernel/hw_breakpoint.c                  |  173 ++++++++++++++++++++++++++++---
 kernel/perf_counter.c                   |   41 +++++++-
 kernel/trace/trace.h                    |    5 +-
 kernel/trace/trace_ksym.c               |   67 ++++++------
 kernel/trace/trace_selftest.c           |    2 +-
 samples/hw_breakpoint/data_breakpoint.c |   10 +--
 11 files changed, 368 insertions(+), 168 deletions(-)

