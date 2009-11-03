Return-Path: <linux-kernel-owner+w=401wt.eu-S1754614AbZKCTLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614AbZKCTLR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 14:11:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754583AbZKCTLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 14:11:16 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:35814 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599AbZKCTLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 14:11:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=SBSUO0QISBLTpP+7ynjpu+y44pv2UTGbsNdwGmFmK9AIG/BlfseH+IQ7Zo56cEEFi+
         tQ/0X4BH8mQAOP/rux/QDX8h2QgHhgMJggI27VFT/EH0LMviAsNGupRnt7E/js7k2XZS
         sMcpFd0a4Q4vvtVmMGUhhTy6jWM6hUR+FEL8Y=
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
Subject: [GIT PULL v4] hw-breakpoints: Rewrite on top of perf events v4
Date: Tue,  3 Nov 2009 20:11:08 +0100
Message-Id: <1257275474-5285-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This is the v4 of the hw-breakpoints API rewrite on top of perf events.

This integrates the following fixes:

Changes in v4:

    - Drop the hw_breakpoint_restore() stub as it is only used by KVM
    - EXPORT_SYMBOL_GPL hw_breakpoint_restore() as KVM can be built as a
      module
    - Restore the breakpoints unconditionally on kvm guest exit:
      TIF_DEBUG_THREAD doesn't anymore cover every cases of running
      breakpoints and vcpu->arch.switch_db_regs might not always be
      set when the guest used debug registers.
      (Waiting for a reliable optimization)
    - Simplify a bit the callback attribution as suggested by Paul
      Mackerras
    - Remove the wrong comment about the fact
      perf_event_create_kernel_counter must be called from a kernel
      thread.

Changes in v3:

    - Fix broken CONFIG_KVM, propagate the breakpoint api
      changes to kvm when we exit the guest and restore the bp registers
      to the host. The only change is in the 4th patch.

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

This tree can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	perfevents/hw-breakpoint-v4

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
 arch/x86/include/asm/debugreg.h      |   11 +-
 arch/x86/include/asm/hw_breakpoint.h |   58 +++--
 arch/x86/include/asm/processor.h     |   12 +-
 arch/x86/kernel/hw_breakpoint.c      |  391 +++++++++++++++--------
 arch/x86/kernel/process.c            |    9 +-
 arch/x86/kernel/process_32.c         |   26 +--
 arch/x86/kernel/process_64.c         |   26 +--
 arch/x86/kernel/ptrace.c             |  182 +++++++----
 arch/x86/kernel/smpboot.c            |    3 -
 arch/x86/kvm/x86.c                   |   15 +-
 arch/x86/power/cpu.c                 |    6 -
 include/asm-generic/hw_breakpoint.h  |  139 --------
 include/linux/hw_breakpoint.h        |  131 ++++++++
 include/linux/perf_event.h           |   37 ++-
 kernel/exit.c                        |    5 +
 kernel/hw_breakpoint.c               |  595 +++++++++++++++++++++-------------
 kernel/perf_event.c                  |  136 ++++++++-
 kernel/trace/trace.h                 |    1 -
 kernel/trace/trace_entries.h         |    6 +-
 kernel/trace/trace_ksym.c            |  126 ++++----
 kernel/trace/trace_selftest.c        |    2 +-
 22 files changed, 1180 insertions(+), 740 deletions(-)
 delete mode 100644 include/asm-generic/hw_breakpoint.h
 create mode 100644 include/linux/hw_breakpoint.h
