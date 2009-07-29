Return-Path: <linux-kernel-owner+w=401wt.eu-S1754199AbZG2LZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbZG2LZM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 07:25:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753519AbZG2LZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 07:25:11 -0400
Received: from brick.kernel.dk ([93.163.65.50]:42133 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754068AbZG2LZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 07:25:10 -0400
Date: Wed, 29 Jul 2009 13:25:10 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: davem@davemloft.net
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] basic perf support for sparc
Message-ID: <20090729112509.GN4148@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This adds the little necessary bits to get perf going at
least. Callgraph doesn't work, but basic profiling does.

Building the perf tool is somewhat involved on sparc64
though, since 64-bit versions of zlib/libelf/bfd aren't
directly available (at least on debian 5.x). But once you
get there, it runs :-). Would it be easier/functional
to build 32-bit userland perf instead?

$  perf record -f ls > /dev/null
[ perf record: Captured and wrote 0.004 MB perf.data (~194 samples) ]
$ perf report --sort comm,dso,symbol | head -n10
# Samples: 98
#
# Overhead  Command  Shared Object  Symbol
# ........  .......  .............  ......
#
    25.51%       ls       f7f62e00  [.] 0x000000f7f62e00
     6.12%     perf  [kernel]       [.] 0xfffff801007e4b38
     6.12%       ls  [kernel]       [k] sparc64_realfault_common
     3.06%       ls  [kernel]       [k] tg_shares_up
     3.06%       ls  [kernel]       [k] find_next_bit

$ perf record -f -g ls > /dev/null
[ perf record: Captured and wrote 0.005 MB perf.data (~223 samples) ]
$ perf report -g | head -n10
Warning: empty node in callchain tree
Warning: empty node in callchain tree
Warning: empty node in callchain tree
[...]

Patch is against latest -git.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 3f8b6a9..2f951a9 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -44,6 +44,7 @@ config SPARC64
 	select RTC_DRV_BQ4802
 	select RTC_DRV_SUN4V
 	select RTC_DRV_STARFIRE
+	select HAVE_PERF_COUNTERS
 
 config ARCH_DEFCONFIG
 	string
diff --git a/arch/sparc/include/asm/unistd.h b/arch/sparc/include/asm/unistd.h
index b2c406d..706df66 100644
--- a/arch/sparc/include/asm/unistd.h
+++ b/arch/sparc/include/asm/unistd.h
@@ -395,8 +395,9 @@
 #define __NR_preadv		324
 #define __NR_pwritev		325
 #define __NR_rt_tgsigqueueinfo	326
+#define __NR_perf_counter_open	327
 
-#define NR_SYSCALLS		327
+#define NR_SYSCALLS		328
 
 #ifdef __32bit_syscall_numbers__
 /* Sparc 32-bit only has the "setresuid32", "getresuid32" variants,
diff --git a/arch/sparc/kernel/systbls_64.S b/arch/sparc/kernel/systbls_64.S
index 6b3ee88..80ebf20 100644
--- a/arch/sparc/kernel/systbls_64.S
+++ b/arch/sparc/kernel/systbls_64.S
@@ -158,4 +158,4 @@ sys_call_table:
 /*310*/	.word sys_utimensat, sys_signalfd, sys_timerfd_create, sys_eventfd, sys_fallocate
 	.word sys_timerfd_settime, sys_timerfd_gettime, sys_signalfd4, sys_eventfd2, sys_epoll_create1
 /*320*/	.word sys_dup3, sys_pipe2, sys_inotify_init1, sys_accept4, sys_preadv
-	.word sys_pwritev, sys_rt_tgsigqueueinfo
+	.word sys_pwritev, sys_rt_tgsigqueueinfo, sys_perf_counter_open

diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index e5148e2..2abeb20 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -41,6 +41,12 @@
 #define cpu_relax()	asm volatile("" ::: "memory");
 #endif
 
+#ifdef __sparc__
+#include "../../arch/sparc/include/asm/unistd.h"
+#define rmb()		asm volatile("":::"memory")
+#define cpu_relax()	asm volatile("":::"memory")
+#endif
+
 #include <time.h>
 #include <unistd.h>
 #include <sys/types.h>

-- 
Jens Axboe

