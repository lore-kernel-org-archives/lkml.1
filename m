Return-Path: <linux-kernel-owner+w=401wt.eu-S1755259AbZIJI3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259AbZIJI3d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 04:29:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752769AbZIJI3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 04:29:32 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:51951 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbZIJI3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 04:29:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=aXRmtPFJ40OGdvrC4xUGNSrnvdGM+jjK12Qc+Ut+AFxyQdG2Kf9ixrkOTx5jUQ3lkF
         YnpFaTjctEeBo5D1cnHAwHn87IS4MW9TIxI2PVB0e3h3GRjr7GobFDJomlH3f7PYAbjU
         KkJkRPbHiI1HmKkcf4taD2pZyjrfgDWDlN8ok=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Prasad <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jan Kiszka <jan.kiszka@siemens.com>, Jiri Slaby <jirislaby@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Avi Kivity <avi@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: [RFC GIT PULL] hw-breakpoints: Rewrite on top of perf counters
Date: Thu, 10 Sep 2009 10:29:22 +0200
Message-Id: <1252571367-25876-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a rewrite of the hardware breakpoints on top of perf counters.

Most of the details can be found in the 3rd and 4th patches.

To sum-up, this brings the perf tunable features that a perf
counter can perform:

- Hardware registers scheduling through a pmu
- Pinned/flexible, exlusive/non-exclusive, tunable periodic
  events.
- Easier arch integration
- Optimized register allocation

There is still some work to do.
Beside the todo list found in individual patches:

- Fix a nasty bug: it doesn't properly free/unregister the breakpoint
  after a use through ptrace. I should fix it soon.

- Drop the struct hw_breakpoint type and integrate the breakpoint core
  fields into the counter structure (into the perf attributes)

Thanks,
Frederic.

---
The following changes since commit d6a65dffb30d8636b1e5d4c201564ef401a246cf:
  Frederic Weisbecker (1):
        tracing: Fix ring-buffer and ksym tracer merge interaction

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	tracing/hw-breakpoints

Frederic Weisbecker (4):
      perf_counter: Add open/close pmu callbacks
      perf_counter: Export various perf helpers for external users
      hw-breakpoints: Rewrite the hw-breakpoints layer on top of perf counters
      hw-breakpoints: Arbitrate access to pmu following registers constraints

Li Zefan (1):
      ksym_tracer: Remove KSYM_SELFTEST_ENTRY

 arch/Kconfig                         |    3 +
 arch/x86/include/asm/debugreg.h      |    7 -
 arch/x86/include/asm/hw_breakpoint.h |   31 ++-
 arch/x86/include/asm/processor.h     |   10 +-
 arch/x86/kernel/hw_breakpoint.c      |  217 ++++++++------
 arch/x86/kernel/process.c            |    4 +-
 arch/x86/kernel/process_32.c         |   28 +--
 arch/x86/kernel/process_64.c         |   28 +--
 arch/x86/kernel/ptrace.c             |  163 +++++++----
 arch/x86/kernel/smpboot.c            |    3 -
 arch/x86/power/cpu.c                 |    6 -
 include/asm-generic/hw_breakpoint.h  |   20 +-
 include/linux/perf_counter.h         |   42 +++
 kernel/hw_breakpoint.c               |  543 ++++++++++++++++++++--------------
 kernel/perf_counter.c                |  112 +++++--
 kernel/trace/trace.h                 |    1 -
 kernel/trace/trace_ksym.c            |  151 +++++++---
 kernel/trace/trace_selftest.c        |    2 +-
 18 files changed, 840 insertions(+), 531 deletions(-)
