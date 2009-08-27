Return-Path: <linux-kernel-owner+w=401wt.eu-S1754801AbZH0CcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801AbZH0CcU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 22:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754780AbZH0CcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 22:32:20 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:53185 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754770AbZH0CcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 22:32:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=fiB0SaOeY7jBK8s82t9i8cA+zUWniltOsVjvQXq6MJGlqnDO0agMBBaUlOcho+rpJg
         VBwxfAkocRtMI3s3Vaej5xyElhttrj/zo3Ml+ezcsZEdPhSwnaZYf2fRdVKyy3lOaFNF
         EpVIXZPKeO4SqARBvEyVQUITg+BX5ZcU/F+aU=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [GIT PULL] tracing/kprobes: Add dynamic tracepoints + instruction decoder
Date: Thu, 27 Aug 2009 04:31:59 +0200
Message-Id: <1251340337-5640-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

This is the kprobes tracing pile of patches. I've tested it
successfully by setting some kprobes through debugfs by hand.

It brings no known regressions.

However, the stress test provided by Masami have revealed some
unstable points. Some symbols are unsafe to probe and raise
probing recursion.

I've added a tiny patch in the series that helps identifying the
kprobe that has raised such situation.
For example it has learned me today that it's unsafe to trace
ret_from_exception() (obviously: it's on the int 3 handler path).

Anyway, we have all the tools to debug that and easily find the
fragile points to probe. It's then just a matter of investigation
and stress tests now.

And because the pile of patches becomes big enough, I've thought it
could be time to do a pull request for -tip for it to have a
private branch and get fixes over the time.

Tell me if that's a problem and we can delay the pull request until
we fix the recursive points problems.

Thanks,
Frederic.

The following changes since commit 35dce1a99d010f3d738af4ce1b9b77302fdfe69c:
  Ingo Molnar (1):
        Merge branch 'tracing/core' of git://git.kernel.org/.../frederic/random-tracing into tracing/core

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	tracing/kprobes

Frederic Weisbecker (1):
      tracing/kprobes: Dump the culprit kprobe in case of kprobe recursion

Masami Hiramatsu (17):
      x86: Instruction decoder API
      x86: X86 instruction decoder build-time selftest
      kprobes: Checks probe address is instruction boudary on x86
      kprobes: Cleanup fix_riprel() using insn decoder on x86
      x86: Add pt_regs register and stack access APIs
      tracing: Ftrace dynamic ftrace_event_call support
      tracing: Introduce TRACE_FIELD_ZERO() macro
      tracing: Add kprobe-based event tracer
      tracing: Add kprobe-based event tracer documentation
      tracing: Kprobe-tracer supports more than 6 arguments
      tracing: Generate names for each kprobe event automatically
      tracing: Kprobe tracer assigns new event ids for each event
      tracing: Add kprobes event profiling interface
      x86: Fix x86 instruction decoder selftest to check only .text
      x86: Check awk features before generating inat-tables.c
      tracing/kprobes: Fix format typo in trace_kprobes
      tracing/kprobes: Change trace_arg to probe_arg

 Documentation/trace/kprobetrace.txt  |  148 ++++
 arch/x86/Kconfig.debug               |    9 +
 arch/x86/Makefile                    |    3 +
 arch/x86/include/asm/inat.h          |  188 ++++++
 arch/x86/include/asm/inat_types.h    |   29 +
 arch/x86/include/asm/insn.h          |  143 ++++
 arch/x86/include/asm/ptrace.h        |   62 ++
 arch/x86/kernel/kprobes.c            |  209 +++---
 arch/x86/kernel/ptrace.c             |  112 +++
 arch/x86/lib/Makefile                |   13 +
 arch/x86/lib/inat.c                  |   78 +++
 arch/x86/lib/insn.c                  |  464 +++++++++++++
 arch/x86/lib/x86-opcode-map.txt      |  719 ++++++++++++++++++++
 arch/x86/tools/Makefile              |   15 +
 arch/x86/tools/distill.awk           |   42 ++
 arch/x86/tools/gen-insn-attr-x86.awk |  334 +++++++++
 arch/x86/tools/test_get_len.c        |  113 ++++
 include/linux/ftrace_event.h         |   19 +-
 include/linux/kprobes.h              |    2 +
 include/linux/syscalls.h             |    4 +-
 include/trace/ftrace.h               |   16 +-
 include/trace/syscall.h              |   11 +-
 kernel/kprobes.c                     |    7 +
 kernel/trace/Kconfig                 |   12 +
 kernel/trace/Makefile                |    1 +
 kernel/trace/trace.h                 |   24 +
 kernel/trace/trace_event_types.h     |    4 +-
 kernel/trace/trace_events.c          |  121 +++-
 kernel/trace/trace_export.c          |   34 +-
 kernel/trace/trace_kprobe.c          | 1231 ++++++++++++++++++++++++++++++++++
 kernel/trace/trace_syscalls.c        |   20 +-
 31 files changed, 3991 insertions(+), 196 deletions(-)
 create mode 100644 Documentation/trace/kprobetrace.txt
 create mode 100644 arch/x86/include/asm/inat.h
 create mode 100644 arch/x86/include/asm/inat_types.h
 create mode 100644 arch/x86/include/asm/insn.h
 create mode 100644 arch/x86/lib/inat.c
 create mode 100644 arch/x86/lib/insn.c
 create mode 100644 arch/x86/lib/x86-opcode-map.txt
 create mode 100644 arch/x86/tools/Makefile
 create mode 100644 arch/x86/tools/distill.awk
 create mode 100644 arch/x86/tools/gen-insn-attr-x86.awk
 create mode 100644 arch/x86/tools/test_get_len.c
 create mode 100644 kernel/trace/trace_kprobe.c
