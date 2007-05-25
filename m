Return-Path: <linux-kernel-owner+w=401wt.eu-S1752865AbXEYHzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865AbXEYHzV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 03:55:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750809AbXEYHzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 03:55:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35395 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721AbXEYHzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 03:55:08 -0400
Date: Fri, 25 May 2007 09:54:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Satyam Sharma <satyam.sharma@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [patch] x86_64: fix sched_clock()
Message-ID: <20070525075446.GA20140@elte.hu>
References: <20070525071005.GA6431@elte.hu> <a781481a0705250022t3dec8f13u7c75d0ade40b0010@mail.gmail.com> <20070525073158.GB8094@one.firstfloor.org> <20070525073957.GA15207@elte.hu> <20070525074316.GA16821@elte.hu> <20070525074915.GA18400@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070525074915.GA18400@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [patch] x86_64: fix sched_clock()
From: Ingo Molnar <mingo@elte.hu>

sched_clock() is totally broken on x86_64, because it is not defined by 
the architecture at all! It fell the victim to the opaqueness of 
__attribute__((weak)) and to non-testing.

the i386 version was supposed to be used. This patch fixes that. Booted 
and tested on x86_64 and i386.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86_64/kernel/Makefile |    3 ++-
 include/asm-x86_64/tsc.h    |    5 +++++
 2 files changed, 7 insertions(+), 1 deletion(-)

Index: linux-cfs-2.6.22-rc2-mm1.q/arch/x86_64/kernel/Makefile
===================================================================
--- linux-cfs-2.6.22-rc2-mm1.q.orig/arch/x86_64/kernel/Makefile
+++ linux-cfs-2.6.22-rc2-mm1.q/arch/x86_64/kernel/Makefile
@@ -9,7 +9,7 @@ obj-y	:= process.o signal.o entry.o trap
 		x8664_ksyms.o i387.o syscall.o vsyscall.o \
 		setup64.o bootflag.o e820.o reboot.o quirks.o i8237.o \
 		pci-dma.o pci-nommu.o alternative.o hpet.o tsc.o bugs.o \
-		perfctr-watchdog.o
+		perfctr-watchdog.o sched-clock.o
 
 obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
 obj-$(CONFIG_X86_MCE)		+= mce.o therm_throt.o
@@ -49,6 +49,7 @@ obj-y				+= pcspeaker.o
 
 CFLAGS_vsyscall.o		:= $(PROFILING) -g0
 
+sched-clock-y			+= ../../i386/kernel/sched-clock.o
 therm_throt-y                   += ../../i386/kernel/cpu/mcheck/therm_throt.o
 bootflag-y			+= ../../i386/kernel/bootflag.o
 legacy_serial-y			+= ../../i386/kernel/legacy_serial.o
Index: linux-cfs-2.6.22-rc2-mm1.q/include/asm-x86_64/tsc.h
===================================================================
--- linux-cfs-2.6.22-rc2-mm1.q.orig/include/asm-x86_64/tsc.h
+++ linux-cfs-2.6.22-rc2-mm1.q/include/asm-x86_64/tsc.h
@@ -1 +1,6 @@
 #include <asm-i386/tsc.h>
+
+/*
+ * To be able to share sched-clock.c between i386 and x86_64:
+ */
+#define tsc_disable 0

