Return-Path: <linux-kernel-owner+w=401wt.eu-S1754463AbZKHP26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463AbZKHP26 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 10:28:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754304AbZKHP25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 10:28:57 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:57937 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206AbZKHP24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 10:28:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ZZ+z6Pv90b1QkrGwDaRKq72dUWSFVRI92gECT4mJbD6L6xD0WBgwY6U/tl3IPQ8wKf
         IKBQ3VsJ7QRbDy24vVX2/NhoExBWuS1ORRBZnlU//MkzMXgtFmTMm/sBML7mdQswPKlQ
         XtfZ+ToYSNrp9RbwQKxehecGdrWNOaRWfX0tI=
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
Subject: [GIT PULL v6] hw-breakpoints: Rewrite on top of perf events v6
Date: Sun,  8 Nov 2009 16:28:54 +0100
Message-Id: <1257694141-5670-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the tracing/hw-breakpoints branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	tracing/hw-breakpoints

Changes in v6:

- Fix wrong header inclusion in trace.h (triggered a build
  error with CONFIG_FTRACE_SELFTEST)

- Currently, events scheduling are done in this order: cpu context
  pinned + cpu context non-pinned + task context pinned + task context
  non-pinned events. Then our current constraints are right theoretically
  but not in practice, because non-pinned counters may be scheduled
  before we can apply every possible pinned counters. So consider
  non-pinned counters as pinned for now (thanks Paul for reporting this)

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
 arch/x86/kernel/hw_breakpoint.c      |  391 +++++++++++++++--------
 arch/x86/kernel/process.c            |    9 +-
 arch/x86/kernel/process_32.c         |   26 +--
 arch/x86/kernel/process_64.c         |   26 +--
 arch/x86/kernel/ptrace.c             |  182 ++++++++----
 arch/x86/kernel/smpboot.c            |    3 -
 arch/x86/kvm/x86.c                   |   18 +-
 arch/x86/power/cpu.c                 |    6 -
 include/asm-generic/hw_breakpoint.h  |  139 ---------
 include/linux/hw_breakpoint.h        |  131 ++++++++
 include/linux/perf_event.h           |   37 +++-
 kernel/exit.c                        |    5 +
 kernel/hw_breakpoint.c               |  569 ++++++++++++++++++++--------------
 kernel/perf_event.c                  |  136 ++++++++-
 kernel/trace/trace.h                 |    6 +-
 kernel/trace/trace_entries.h         |    6 +-
 kernel/trace/trace_ksym.c            |  126 ++++----
 kernel/trace/trace_selftest.c        |    4 +-
 23 files changed, 1162 insertions(+), 743 deletions(-)
