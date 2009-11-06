Return-Path: <linux-kernel-owner+w=401wt.eu-S1759168AbZKFC27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759168AbZKFC27 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 21:28:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759074AbZKFC27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 21:28:59 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:51442 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757455AbZKFC26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 21:28:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=VOmnT5Irxv7OqpS1JSxrY1d5QCPAqHVsiQc8kmgUbCT2o6iPijE5TH9MBKnrw8eKJ9
         P6/pQPpO0tqz6y6KYmljAzToEyE14RvDeoAFNFtt8HJcbXf6bqyY3Aa7qruJsCdms60x
         4Et28bxuiYRd3c9we9f2Orf7TTxCBrI2FhJsk=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Prasad <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Jan Kiszka <jan.kiszka@web.de>,
       Jiri Slaby <jirislaby@gmail.com>, Avi Kivity <avi@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: [GIT PULL v5] hw-breakpoints: Rewrite on top of perf events v5 
Date: Fri,  6 Nov 2009 03:28:55 +0100
Message-Id: <1257474542-6648-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the tracing/hw-breakpoints branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	tracing/hw-breakpoints

Changes in v5:

- Split-up the asm-generic/hw-breakpoint.h moving to
  linux/hw_breakpoint.h into a separate patch (Suggested by Prasad)
- Optimize the breakpoints restoring while switching from kvm guest
  to host. We only want to restore the state if we have active
  breakpoints to the host, otherwise we don't care about messed-up
  address registers (Suggested by Jan Kizka)
- Add asm/hw_breakpoint.h to Kbuild
- Fix bad breakpoint type in trace_selftest.c
- Fix unreleased non-pinned task-bound-only counters. We only released
  it in the first cpu. (Thanks to Paul Mackerras for reporting that)

Thanks,
	Frederic
---

Frederic Weisbecker (4):
      perf/core: Add a callback to perf events
      hw-breakpoint: Move asm-generic/hw_breakpoint.h to linux/hw_breakpoint.h
      hw-breakpoints: Rewrite the hw-breakpoints layer on top of perf events
      hw-breakpoints: Arbitrate access to pmu following registers constraints

Arjan van de Ven (1):
      perf/core: Provide a kernel-internal interface to get to performance counters

Li Zefan (1):
      ksym_tracer: Remove KSYM_SELFTEST_ENTRY

Paul Mundt (1):
      x86/hw-breakpoints: Actually flush thread breakpoints in flush_thread().


 arch/Kconfig                         |    3 +
 arch/x86/include/asm/Kbuild          |    1 +
 arch/x86/include/asm/debugreg.h      |   11 +-
 arch/x86/include/asm/hw_breakpoint.h |   58 +++--
 arch/x86/include/asm/processor.h     |   12 +-
 arch/x86/kernel/hw_breakpoint.c      |  391 ++++++++++++++--------
 arch/x86/kernel/process.c            |    9 +-
 arch/x86/kernel/process_32.c         |   26 +--
 arch/x86/kernel/process_64.c         |   26 +--
 arch/x86/kernel/ptrace.c             |  182 +++++++----
 arch/x86/kernel/smpboot.c            |    3 -
 arch/x86/kvm/x86.c                   |   18 +-
 arch/x86/power/cpu.c                 |    6 -
 include/asm-generic/hw_breakpoint.h  |  139 --------
 include/linux/hw_breakpoint.h        |  131 ++++++++
 include/linux/perf_event.h           |   37 ++-
 kernel/exit.c                        |    5 +
 kernel/hw_breakpoint.c               |  602 +++++++++++++++++++++-------------
 kernel/perf_event.c                  |  136 ++++++++-
 kernel/trace/trace.h                 |    1 -
 kernel/trace/trace_entries.h         |    6 +-
 kernel/trace/trace_ksym.c            |  126 ++++----
 kernel/trace/trace_selftest.c        |    4 +-
 23 files changed, 1194 insertions(+), 739 deletions(-)
