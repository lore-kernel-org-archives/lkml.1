Return-Path: <linux-kernel-owner+w=401wt.eu-S1753485AbZKAVJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbZKAVJP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 16:09:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753442AbZKAVJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 16:09:12 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:42263 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436AbZKAVJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 16:09:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=kjbzz1qiNGc3oBxovfd69/YebRJ+qgO6RKTGzFawZs0iFPYMytaP0FmLavg9DVlQYC
         D4Z7NY2Ev4i/Xj8N9yod42Id/eyNTxd2UK+1Rqkj5e/NLMQzblYhMmpKQ6LpiCfx6Ydb
         hy0/Do+9z3Fwr0SoFq2dYca8Ta4iE9uLWb4Sk=
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
Subject: [GIT PULL v3] hw-breakpoints: Rewrite on top of perf events
Date: Sun,  1 Nov 2009 22:09:07 +0100
Message-Id: <1257109753-6464-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <4AE55B1B.2030006@web.de>
References: <4AE55B1B.2030006@web.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This is the v3 of the hw-breakpoints API rewrite on top of perf events.
You can find the previous version here:
http://lwn.net/Articles/358594/

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


The following changes since commit 0f8f86c7bdd1c954fbe153af437a0d91a6c5721a:
  Frederic Weisbecker (1):
        Merge commit 'perf/core' into perf/hw-breakpoint

are available in the git repository at:

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
 arch/x86/include/asm/debugreg.h      |   13 +-
 arch/x86/include/asm/hw_breakpoint.h |   58 +++--
 arch/x86/include/asm/processor.h     |   12 +-
 arch/x86/kernel/hw_breakpoint.c      |  390 +++++++++++++++--------
 arch/x86/kernel/process.c            |    9 +-
 arch/x86/kernel/process_32.c         |   26 +--
 arch/x86/kernel/process_64.c         |   26 +--
 arch/x86/kernel/ptrace.c             |  182 +++++++----
 arch/x86/kernel/smpboot.c            |    3 -
 arch/x86/kvm/x86.c                   |   11 +-
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
 22 files changed, 1178 insertions(+), 740 deletions(-)
 delete mode 100644 include/asm-generic/hw_breakpoint.h
 create mode 100644 include/linux/hw_breakpoint.h
