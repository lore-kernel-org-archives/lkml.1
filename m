Return-Path: <linux-kernel-owner+w=401wt.eu-S1755400AbZFBWnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400AbZFBWnz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 18:43:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753720AbZFBWnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 18:43:42 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:21607 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075AbZFBWnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 18:43:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=BypEcO5kUb2oRyus9wpOhjD2YLDlEgJFHh2do7WmyYGjZMWzSJ6HLulIkcEX1CcMo3
         P3KPjft4CVcMKzXnaDXtf9YNA6nFge46qLs6p8tkyct8KkDGnZLy8aqcU8X3dxRYGaaA
         FNHjBQGVdh1b9SVZ34nU4a+6gf28Duuy+q1gg=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "K . Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 00/12] hw-breakpoints: new hardware breakpoints API
Date: Wed,  3 Jun 2009 00:43:24 +0200
Message-Id: <1243982616-18212-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

The new hardware breakpoint API has benefit from deep reviews since
its first iteration several months ago, and Prasad has addressed
most (all?) of them.

After a small reorg and few fixes that were done recently, it seems
ready for integration on -tip.

I've tested it successfully for both kernel (ftrace) and user (gdb)
hardware breakpoints.

Thanks!

Frederic.

The following changes since commit 43bd1236234cacbc18d1476a9b57e7a306efddf5:
  Frederic Weisbecker (1):
        tracing/stat: remove unappropriate safe walk on list

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git hw-breakpoints

K.Prasad (12):
      hw-breakpoints: prepare the code for Hardware Breakpoint interfaces
      hw-breakpoints: introducing generic hardware breakpoint handler interfaces
      hw-breakpoints: x86 architecture implementation of Hardware Breakpoint interfaces
      hw-breakpoints: modifying generic debug exception to use thread-specific debug registers
      hw-breakpoints: use wrapper routines around debug registers in processor related functions
      hw-breakpoints: use the new wrapper routines to access debug registers in process/thread code
      hw-breakpoints: modify signal handling code to refrain from re-enabling HW Breakpoints
      hw-breakpoints: modify Ptrace routines to access breakpoint registers
      hw-breakpoints: cleanup HW Breakpoint registers before kexec
      hw-breakpoints: sample HW breakpoint over kernel data address
      hw-breakpoints: ftrace plugin for kernel symbol tracing using HW Breakpoint interfaces
      hw-breakpoints: reset bits in dr6 after the corresponding exception is handled

 arch/Kconfig                            |    4 +
 arch/x86/Kconfig                        |    1 +
 arch/x86/include/asm/a.out-core.h       |    8 +-
 arch/x86/include/asm/debugreg.h         |   29 ++
 arch/x86/include/asm/hw_breakpoint.h    |   55 ++++
 arch/x86/include/asm/processor.h        |    8 +-
 arch/x86/kernel/Makefile                |    2 +-
 arch/x86/kernel/hw_breakpoint.c         |  391 +++++++++++++++++++++++
 arch/x86/kernel/kgdb.c                  |    6 +
 arch/x86/kernel/kprobes.c               |    9 +-
 arch/x86/kernel/machine_kexec_32.c      |    2 +
 arch/x86/kernel/machine_kexec_64.c      |    2 +
 arch/x86/kernel/process.c               |   22 +-
 arch/x86/kernel/process_32.c            |   28 ++
 arch/x86/kernel/process_64.c            |   31 ++
 arch/x86/kernel/ptrace.c                |  231 +++++++++------
 arch/x86/kernel/signal.c                |    9 -
 arch/x86/kernel/smpboot.c               |    3 +
 arch/x86/kernel/traps.c                 |   71 ++---
 arch/x86/mm/kmmio.c                     |    8 +-
 arch/x86/power/cpu_32.c                 |   13 +-
 arch/x86/power/cpu_64.c                 |   12 +-
 include/asm-generic/hw_breakpoint.h     |  139 ++++++++
 kernel/Makefile                         |    1 +
 kernel/hw_breakpoint.c                  |  378 ++++++++++++++++++++++
 kernel/trace/Kconfig                    |   21 ++
 kernel/trace/Makefile                   |    1 +
 kernel/trace/trace.h                    |   23 ++
 kernel/trace/trace_ksym.c               |  525 +++++++++++++++++++++++++++++++
 kernel/trace/trace_selftest.c           |   53 +++
 samples/Kconfig                         |    6 +
 samples/Makefile                        |    3 +-
 samples/hw_breakpoint/Makefile          |    1 +
 samples/hw_breakpoint/data_breakpoint.c |   83 +++++
 34 files changed, 1987 insertions(+), 192 deletions(-)
 create mode 100644 arch/x86/include/asm/hw_breakpoint.h
 create mode 100644 arch/x86/kernel/hw_breakpoint.c
 create mode 100644 include/asm-generic/hw_breakpoint.h
 create mode 100644 kernel/hw_breakpoint.c
 create mode 100644 kernel/trace/trace_ksym.c
 create mode 100644 samples/hw_breakpoint/Makefile
 create mode 100644 samples/hw_breakpoint/data_breakpoint.c
