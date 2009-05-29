Return-Path: <linux-kernel-owner+w=401wt.eu-S1761369AbZE2O6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761369AbZE2O6t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 10:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759633AbZE2O6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 10:58:41 -0400
Received: from mail-px0-f123.google.com ([209.85.216.123]:60916 "EHLO
	mail-px0-f123.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756489AbZE2O6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 10:58:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=PTaSt5FpqGy0PdpyK4kBfmMxV0ps2LGj+xrkx90wD4rmKD7z7VOUuLlNSWgdt3Xa6t
         CdPf2iPVwA5MDbN2sV/r83WCUlLexDGCh7bb4ppTlBzjKaJ6qOg/ckphB/fDNk8BBCo0
         7oniY/mq36VptrG62Z6F6EiAKoyXoJnSZ1USo=
From: wuzhangjin@gmail.com
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Cc: Wu Zhangjin <wuzj@lemote.com>, Steven Rostedt <rostedt@goodmis.org>,
       Ralf Baechle <ralf@linux-mips.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nicholas Mc Guire <der.herr@hofr.at>
Subject: [PATCH v2 0/6] mips-specific ftrace support
Date: Fri, 29 May 2009 22:58:08 +0800
Message-Id: <cover.1243604390.git.wuzj@lemote.com>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzj@lemote.com>

ftrace is a mcount based kernel tracing tool/framework, which is originally
from RT_PREEMPT(http://rt.wiki.kernel.org).

ftrace is short for function tracer, this is its original name, but now, it
becomes a kernel tracing framework, lots of kernel tracers are built on it,
such as irqoff tracer, wakeup tracer and so forth.  these tracers are
arch-independent(?), but some of them are arch-dependent, such as the original
ftrace: function tracer, and dynamic function tracer, function graph tracer,
and also, system call tracer.

here is the mips porting of these four arch-dependent tracers, it will enable
the following new kernel config options in linux-mips system.

kernel hacking --->
           Tracers -->
                [*] Kernel Function Tracer
                [*]   Kernel Function Graph Tracer
                ...
                [*] Trace syscalls
                                ...
                [*] enable/disable ftrace tracepoints dynamically

in reality, because the timestamp getting function are arch-dependent, lots of
the tracers are arch-dependent. the arch-dependent part is that: sched_clock.
the original sched_clock in mips is jiffes based, only give 10ms precision in
1000HZ, which is not enough for ftrace. to get high-precise timestamp, we must
implement a new native_sched_clock via reading the MIPS clock counter, but
since it is only 32bit long, so, overflow should be handled carefully.

this -v2 patch series is based on the -v1 patch series and incorporates the
feedback from Steven Rostedt and Thomas Gleixner.

read the following document, and play with it:
        Documentation/trace/ftrace.txt

Wu Zhangjin (6):
  mips static function tracer support
  mips dynamic function tracer support
  add an endian argument to scripts/recordmcount.pl
  mips function graph tracer support
  mips specific clock function to get precise timestamp
  mips specific system call tracer

 arch/mips/Kconfig                   |    7 +
 arch/mips/Makefile                  |    2 +
 arch/mips/include/asm/ftrace.h      |   35 ++++-
 arch/mips/include/asm/ptrace.h      |    2 +
 arch/mips/include/asm/reg.h         |    5 +
 arch/mips/include/asm/syscall.h     |   84 +++++++++
 arch/mips/include/asm/thread_info.h |    5 +-
 arch/mips/kernel/Makefile           |   12 ++
 arch/mips/kernel/csrc-r4k.c         |    2 +-
 arch/mips/kernel/entry.S            |    2 +-
 arch/mips/kernel/ftrace.c           |  350 +++++++++++++++++++++++++++++++++++
 arch/mips/kernel/ftrace_clock.c     |   71 +++++++
 arch/mips/kernel/mcount.S           |  185 ++++++++++++++++++
 arch/mips/kernel/mips_ksyms.c       |    5 +
 arch/mips/kernel/ptrace.c           |   14 ++-
 arch/mips/kernel/scall64-o32.S      |    2 +-
 arch/mips/kernel/vmlinux.lds.S      |    1 +
 kernel/trace/trace_clock.c          |    2 +-
 scripts/Makefile.build              |    1 +
 scripts/recordmcount.pl             |   32 +++-
 20 files changed, 805 insertions(+), 14 deletions(-)
 create mode 100644 arch/mips/include/asm/syscall.h
 create mode 100644 arch/mips/kernel/ftrace.c
 create mode 100644 arch/mips/kernel/ftrace_clock.c
 create mode 100644 arch/mips/kernel/mcount.S

