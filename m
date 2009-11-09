Return-Path: <linux-kernel-owner+w=401wt.eu-S1756125AbZKIP3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125AbZKIP3S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 10:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756064AbZKIP3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 10:29:17 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:52199 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756063AbZKIP3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 10:29:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=eIyMN8gc22rVrit+/MFirExos7Y2XqL8wq8Lo6PUgvhEa4I08S0CoLxg3jS3QmADDP
         BuCCT4PklYctYAQXoiSHFWTRdYy9R3uvFiw2nboljlJr8q6Omn5pVR9C3xPDQlYPGz4g
         P9XT+iGAUlJZnn61xInS7xav0zjdQlylM6pc0=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Cc: zhangfx@lemote.com, zhouqg@gmail.com, Wu Zhangjin <wuzhangjin@gmail.com>,
       Ralf Baechle <ralf@linux-mips.org>, rostedt@goodmis.org,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Nicholas Mc Guire <der.herr@hofr.at>,
       David Daney <ddaney@caviumnetworks.com>,
       Richard Sandiford <rdsandiford@googlemail.com>,
       Patrik Kluba <kpajko79@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Michal Simek <monstr@monstr.eu>
Subject: [PATCH v7 00/17] ftrace for MIPS
Date: Mon,  9 Nov 2009 23:29:06 +0800
Message-Id: <cover.1257779502.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzhangjin@gmail.com>

This patchset incorporates the feedbacks from Steven, Frederic, David, Richard
and Michal.

The main changes from the v6 version:

 o tracing: add IRQENTRY_EXIT section for MIPS: keep the return value of
 do_IRQ_* be void as the original version does.

 o tracing: define a new __time_notrace annotation flag: replace the old
 __arch_notrace by __time_notrace, just keep the stuff simpler.

 o tracing: make ftrace for MIPS work without -fno-omit-frame-pointer: prepare
 for the future -fomit-frame-pointer, Seems we are not necessary to enable
 -fno-omit-frame-pointer with -pg

 o tracing: make ftrace for MIPS more robust: add the safe load/store
 operations for MIPS
 
 o tracing: add function graph tracer support for MIPS: make the searching of
 the location of return address(ra) clearer.

 o tracing: reserve $12(t0) for mcount-ra-address of gcc 4.5
   tracing: make function graph tracer work with -mmcount-ra-address
 
All of these updates have been pused into:

git://dev.lemote.com/rt4ls.git  linux-mips/dev/ftrace-upstream

All of these stuff and their combinations have been tested with gcc 4.4 & 4.5
on a YeeLoong netbook.

Welcome to play with it and give more feedbacks ;)

Thanks & Regards,
       Wu Zhangjin

Wu Zhangjin (17):
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
  tracing: make ftrace for MIPS more robust
  tracing: reserve $12(t0) for mcount-ra-address of gcc 4.5
  tracing: make function graph tracer work with -mmcount-ra-address

 arch/mips/Kconfig              |    5 +
 arch/mips/Makefile             |    7 +
 arch/mips/include/asm/ftrace.h |   97 ++++++++++++++++-
 arch/mips/include/asm/irq.h    |   29 +-----
 arch/mips/include/asm/time.h   |   20 ++++
 arch/mips/kernel/Makefile      |    9 ++
 arch/mips/kernel/csrc-r4k.c    |   42 +++++++
 arch/mips/kernel/ftrace.c      |  240 ++++++++++++++++++++++++++++++++++++++++
 arch/mips/kernel/irq.c         |   30 +++++
 arch/mips/kernel/mcount.S      |  191 ++++++++++++++++++++++++++++++++
 arch/mips/kernel/mips_ksyms.c  |    5 +
 arch/mips/kernel/smp.c         |    3 +-
 arch/mips/kernel/smtc.c        |   21 +++-
 arch/mips/kernel/time.c        |    2 +
 arch/mips/kernel/trace_clock.c |   33 ++++++
 arch/mips/kernel/vmlinux.lds.S |    1 +
 arch/mips/sgi-ip22/ip22-int.c  |    3 +-
 arch/mips/sgi-ip22/ip22-time.c |    3 +-
 include/linux/ftrace.h         |   12 ++
 kernel/time/clocksource.c      |    5 +-
 kernel/trace/trace_clock.c     |    2 +-
 scripts/Makefile.build         |    1 +
 scripts/recordmcount.pl        |   47 ++++++++-
 23 files changed, 764 insertions(+), 44 deletions(-)
 create mode 100644 arch/mips/kernel/ftrace.c
 create mode 100644 arch/mips/kernel/mcount.S
 create mode 100644 arch/mips/kernel/trace_clock.c

