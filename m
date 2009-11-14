Return-Path: <linux-kernel-owner+w=401wt.eu-S1752826AbZKNGan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826AbZKNGan (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 01:30:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752328AbZKNGan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 01:30:43 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:63188 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165AbZKNGam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 01:30:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=fd5P7hNpDnZkeoH0yfJvQtFN+kRiSrr0+79E8aAGetBlh+uwaPkW6XYJubOQpADJ/Z
         si5XcvGoEc3/ZiWrnORz4kIxxfDfANKQzPrCR4WUDg59aSd0TAL6N0PeKoV7xnHLgQgf
         LQSSnFdcdojaI154WKa3K522wUHHHxeAI7JmE=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: rostedt@goodmis.org, Ralf Baechle <ralf@linux-mips.org>
Cc: Wu Zhangjin <wuzhangjin@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Nicholas Mc Guire <der.herr@hofr.at>,
       David Daney <ddaney@caviumnetworks.com>,
       Richard Sandiford <rdsandiford@googlemail.com>,
       Patrik Kluba <kpajko79@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Michal Simek <monstr@monstr.eu>,
       "Maciej W . Rozycki" <macro@linux-mips.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, zhangfx@lemote.com, zhouqg@gmail.com
Subject: [PATCH v8 00/16] ftrace for MIPS
Date: Sat, 14 Nov 2009 14:30:31 +0800
Message-Id: <cover.1258177321.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzhangjin@gmail.com>

This patchset adds ftrace support for MIPS, including static ftracer, dynamic
ftracer and function graph tracer, and also, a MIPS specific
trace_clock_local() function is added to get high precision timestamp.

Differ from the v7, This v8 revision incoporates the feedbacks from David, Ralf
and Maciej. thanks goes to them.

  o Remove the needless -mlong-calls introduced in the old "tracing: add static
  function tracer support for MIPS"

    static ftracer already support module tracing for there is an existing
    -mlong-calls for modules in arch/mips/Makefile:
        MODFLAGS                        += -mlong-calls

  o Make dynamic ftracer work without -mlong-calls.

    Now, we need to consider the kernel and module respectively, the kernel part
    is without -mlong-calls, the module part is with -mlong-calls.
    
    In scripts/recordmcount.pl, we need to get the right offset, and in
    arch/mips/kernel/ftrace.c, we need to replace the right instruction in
    ftrace_make_nop() & ftrace_make_call().

    And what I must mention here:

      I. we will not really get the offset of calling to _mcount in
      scripts/recordmcount.pl for the modules with -mlong-calls, we get the
      offset of "lui,v1,hi16_mcount".

     II. and in the ftrace_make_nop(), we not really replace the instruction by a
     nop, but by a "b 1f" instead. so, ftrace_make_nop not mean its original
     meaning.

  o Make function graph tracer work without -mlong-calls

    'Cause -pg with and without -mlong-calls generate different number of
    instructions, we need to consider this and move the searching pointer to
    the right position in ftrace_get_parent_addr().

All of the updates have been tested with gcc-4.4/binutils-2.19.1 and
gcc-4.5(including David's mcount-ra-address)/binutils-2.20 on a YeeLoong
netbook. and the source code have been pushed into:

git://dev.lemote.com/rt4ls.git  linux-mips/dev/ftrace-upstream

BTW: What about this revision? Hope it is the last revision from me, but I can
not promise for the kernel developers are always "rigorous": they need the best
solution ;) So, more feedbacks are welcome!

Thanks & Regards,
	Wu Zhangjin

Wu Zhangjin (16):
  tracing: convert trace_clock_local() as weak function
  tracing: add mips_timecounter_read() for MIPS
  tracing: add MIPS specific trace_clock_local()
  tracing: add static function tracer support for MIPS
  tracing: enable HAVE_FUNCTION_TRACE_MCOUNT_TEST for MIPS
  tracing: add an endian argument to scripts/recordmcount.pl
  tracing: add dynamic function tracer support for MIPS
  tracing: add IRQENTRY_EXIT section for MIPS
  tracing: define a new __time_notrace annotation flag
  tracing: not trace the timecounter_read* in kernel/time/clocksource.c
  tracing: not trace mips_timecounter_read() for MIPS
  tracing: add function graph tracer support for MIPS
  tracing: add dynamic function graph tracer for MIPS
  tracing: make ftrace for MIPS work without -fno-omit-frame-pointer
  tracing: reserve $12(t0) for mcount-ra-address of gcc 4.5
  tracing: make function graph tracer work with -mmcount-ra-address

 arch/mips/Kconfig              |    5 +
 arch/mips/Makefile             |    9 ++
 arch/mips/include/asm/ftrace.h |   97 ++++++++++++++-
 arch/mips/include/asm/irq.h    |   29 +----
 arch/mips/include/asm/time.h   |   20 +++
 arch/mips/kernel/Makefile      |    9 ++
 arch/mips/kernel/csrc-r4k.c    |   42 ++++++
 arch/mips/kernel/ftrace.c      |  275 ++++++++++++++++++++++++++++++++++++++++
 arch/mips/kernel/irq.c         |   30 +++++
 arch/mips/kernel/mcount.S      |  189 +++++++++++++++++++++++++++
 arch/mips/kernel/mips_ksyms.c  |    5 +
 arch/mips/kernel/smp.c         |    3 +-
 arch/mips/kernel/smtc.c        |   21 ++-
 arch/mips/kernel/time.c        |    2 +
 arch/mips/kernel/trace_clock.c |   33 +++++
 arch/mips/kernel/vmlinux.lds.S |    1 +
 arch/mips/sgi-ip22/ip22-int.c  |    3 +-
 arch/mips/sgi-ip22/ip22-time.c |    3 +-
 include/linux/ftrace.h         |   12 ++
 kernel/time/clocksource.c      |    5 +-
 kernel/trace/trace_clock.c     |    2 +-
 scripts/Makefile.build         |    1 +
 scripts/recordmcount.pl        |   60 ++++++++-
 23 files changed, 812 insertions(+), 44 deletions(-)
 create mode 100644 arch/mips/kernel/ftrace.c
 create mode 100644 arch/mips/kernel/mcount.S
 create mode 100644 arch/mips/kernel/trace_clock.c

