Return-Path: <linux-kernel-owner+w=401wt.eu-S1753801AbZJXORR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801AbZJXORR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 10:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753750AbZJXORQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 10:17:16 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:62185 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741AbZJXORP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 10:17:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=uQ6vEvfqcWdfgJM467IPza5szaqA+xV5q4e3eD3sId1Swu9XUh3Vs+xGrP4taVSKpt
         qAOEypJfCHuF2/ZXboVpjkXFSaiK+pfQEhOWi4+so/VKr+efbroz3KUnA//4U3XtQbYs
         use2VOEq6T0X5tLCOswovhjQt3PHclCYazcPc=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Prasad <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Jan Kiszka <jan.kiszka@web.de>, Jiri Slaby <jirislaby@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Avi Kivity <avi@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>
Subject: [GIT PULL v2] hw-breakpoints: Rewrite on top of perf events
Date: Sat, 24 Oct 2009 16:16:52 +0200
Message-Id: <1256393818-8921-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This is the v2 of the hw-breakpoints API rewrite on top of perf events.
You can find the previous version here:
http://lwn.net/Articles/351922/

Changes in v2:
    
    - Follow the perf "event " rename
    - The ptrace regression have been fixed (ptrace breakpoint perf events
      weren't released when a task ended)
    - Drop the struct hw_breakpoint and store generic fields in
      perf_event_attr.
    - Separate core and arch specific headers, drop
      asm-generic/hw_breakpoint.h and create linux/hw_breakpoint.h
    - Use new generic len/type for breakpoint
    - Handle off case: when breakpoints api is not supported by an arch
    - Use proper in-kernel perf api provided by Arjan.

There are still a lot of things that need to be cleaned, simplified,
improved (ptrace side, the bp api, etc....) I guess these things can
be done incrementally if you agree.

I've also tried to get an arch-independent api. Generic fields for
breakpoints are stored in perf_event_attr structure (type, len, addr).
This needs to be discussed and improved before it becomes a perf
userspace ABI. We need to find a generic enough structure to host
the breakpoints parameters, something that can better fit to most arch
(handling breakpoint ranges in powerpc, etc...).

Thanks.

---

The following patchset are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	perfevents/hw-breakpoint

Arjan van de Ven (1):
      perf/core: Provide a kernel-internal interface to get to performance counters

Frederic Weisbecker (3):
      perf/core: Add a callback to perf events
      hw-breakpoints: Rewrite the hw-breakpoints layer on top of perf events
      hw-breakpoints: Arbitrate access to pmu following registers constraints

Li Zefan (1):
      ksym_tracer: Remove KSYM_SELFTEST_ENTRY

Paul Mundt (1):
      x86/hw-breakpoints: Actually flush thread breakpoints in flush_thread().

 arch/Kconfig                         |    3 +
 arch/x86/include/asm/debugreg.h      |    7 -
 arch/x86/include/asm/hw_breakpoint.h |   58 +++--
 arch/x86/include/asm/processor.h     |   12 +-
 arch/x86/kernel/hw_breakpoint.c      |  376 ++++++++++++++--------
 arch/x86/kernel/process.c            |    9 +-
 arch/x86/kernel/process_32.c         |   26 +--
 arch/x86/kernel/process_64.c         |   26 +--
 arch/x86/kernel/ptrace.c             |  182 +++++++----
 arch/x86/kernel/smpboot.c            |    3 -
 arch/x86/power/cpu.c                 |    6 -
 include/asm-generic/hw_breakpoint.h  |  139 --------
 include/linux/hw_breakpoint.h        |  131 ++++++++
 include/linux/perf_event.h           |   37 ++-
 kernel/exit.c                        |    5 +
 kernel/hw_breakpoint.c               |  595 +++++++++++++++++++++-------------
 kernel/perf_event.c                  |  137 ++++++++-
 kernel/trace/trace.h                 |    1 -
 kernel/trace/trace_entries.h         |    6 +-
 kernel/trace/trace_ksym.c            |  126 ++++----
 kernel/trace/trace_selftest.c        |    2 +-
 21 files changed, 1154 insertions(+), 733 deletions(-)
 delete mode 100644 include/asm-generic/hw_breakpoint.h
 create mode 100644 include/linux/hw_breakpoint.h
