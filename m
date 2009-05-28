Return-Path: <linux-kernel-owner+w=401wt.eu-S1764777AbZE1Uqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764777AbZE1Uqt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 16:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758715AbZE1Uqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 16:46:42 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:12662 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731AbZE1Uql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 16:46:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=W1JJ5nILP81Ny+A5OP9Wg//NHDn4Pqz0hrjOADAsQzq9vWlJdtrmXXgiCIMmtajWd/
         dojqZBY7yiSNcaiqA4U0epHwm4ue1oZPU4W2klBChPYzIl3UfWXs1nmUpvYgssbIbJJD
         lLBeWB1TVqepQikaMrUmrFBWy96IvntEXWW04=
From: wuzhangjin@gmail.com
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Cc: Wu Zhangjin <wuzj@lemote.com>, Steven Rostedt <rostedt@goodmis.org>,
       Ralf Baechle <ralf@linux-mips.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nicholas Mc Guire <der.herr@hofr.at>
Subject: [PATCH v1 0/5] mips-specific ftrace support
Date: Fri, 29 May 2009 04:46:08 +0800
Message-Id: <cover.1243542927.git.wuzj@lemote.com>
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

in reality, because the high-precise timestamp getting function are
arch-dependent, lots of the tracers are arch-dependent. the arch-dependent part
is that: sched_clock, or we say ring_buffer_time_stamp or trace_clock_local
function. to get high-precise timestamp, we can read the MIPS clock counter,
but since it is only 32bit long, so, overflow should be handled carefully.

read the following document, and play with it:
        Documentation/trace/ftrace.txt

Wu Zhangjin (5):
  mips static function tracer support
  mips dynamic function tracer support
  mips function graph tracer support
  mips specific clock function to get precise timestamp
  mips specific system call tracer

 arch/mips/Kconfig                   |    7 +
 arch/mips/Makefile                  |    2 +
 arch/mips/include/asm/ftrace.h      |   35 ++++-
 arch/mips/include/asm/ptrace.h      |    2 +
 arch/mips/include/asm/reg.h         |    5 +
 arch/mips/include/asm/syscall.h     |   84 ++++++++
 arch/mips/include/asm/thread_info.h |    5 +-
 arch/mips/kernel/Makefile           |   13 ++
 arch/mips/kernel/csrc-r4k.c         |    2 +-
 arch/mips/kernel/entry.S            |    2 +-
 arch/mips/kernel/ftrace.c           |  360 +++++++++++++++++++++++++++++++++++
 arch/mips/kernel/ftrace_clock.c     |   77 ++++++++
 arch/mips/kernel/mcount.S           |  185 ++++++++++++++++++
 arch/mips/kernel/mips_ksyms.c       |    5 +
 arch/mips/kernel/ptrace.c           |   14 ++-
 arch/mips/kernel/scall64-o32.S      |    2 +-
 arch/mips/kernel/vmlinux.lds.S      |    1 +
 kernel/trace/ring_buffer.c          |    3 +-
 kernel/trace/trace_clock.c          |    2 +-
 scripts/Makefile.build              |    1 +
 scripts/recordmcount.pl             |   32 +++-
 21 files changed, 824 insertions(+), 15 deletions(-)
 create mode 100644 arch/mips/include/asm/syscall.h
 create mode 100644 arch/mips/kernel/ftrace.c
 create mode 100644 arch/mips/kernel/ftrace_clock.c
 create mode 100644 arch/mips/kernel/mcount.S

