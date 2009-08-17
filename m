Return-Path: <linux-kernel-owner+w=401wt.eu-S1756967AbZHQGsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967AbZHQGsw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 02:48:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756898AbZHQGsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 02:48:51 -0400
Received: from brick.kernel.dk ([93.163.65.50]:36987 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756890AbZHQGsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 02:48:51 -0400
Date: Mon, 17 Aug 2009 08:48:51 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
       mingo@elte.hu
Subject: Re: [PATCH] basic perf support for sparc
Message-ID: <20090817064851.GQ12579@kernel.dk>
References: <20090729112509.GN4148@kernel.dk> <20090802.131705.81498579.davem@davemloft.net> <20090806070242.GF12579@kernel.dk> <20090816.183134.90977928.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090816.183134.90977928.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 16 2009, David Miller wrote:
> From: Jens Axboe <jens.axboe@oracle.com>
> Date: Thu, 6 Aug 2009 09:02:42 +0200
> 
> > On Sun, Aug 02 2009, David Miller wrote:
> >> From: Jens Axboe <jens.axboe@oracle.com>
> >> Date: Wed, 29 Jul 2009 13:25:10 +0200
> >> 
> >> > -#define NR_SYSCALLS		327
> >> > +#define NR_SYSCALLS		328
> >> 
> >> When you increase this value, you have to add entries to all of the
> >> syscall tables.  The syscall dispatch checks against this as a limit,
> >> so if you don't explicitly add an entry to all the tables, it's
> >> possible to deref garbage past the end of the table and try to jump to
> >> it as a syscall.
> > 
> > Oops, missed the 32-bit table. Does the below look better?
> 
> You got the native 32-bit table, and the native 64-bit table,
> but you missed sparc64's 32-bit compat syscall table :-)
> 
> There are two syscall tables in arch/sparc/systbls.S, you only
> got the native 64-bit one.
> 
> Please fix this up, and the patch is fine with that cured,
> so make it a formal submission with commit message and signoffs
> thanks!

Gotcha, I missed the compat table. So below is a full patch, signed off
and everything. It also adds the select HAVE_PERF_COUNTERS for sparc32,
but it's only tested on sparc64.

> > I'm assuming that this will happen automatically at some point, instead
> > of perf defaulting to building with the same 32/64-bit of the kernel.
> 
> Right, it looks like Ingo and co. are going to take care of that.

It's already much better, I can just type make and it'll work. Still
builds 64-bit, but at least it only requires zlib and elf which I
already got fixed.

commit 4c66ea6871ad059b35e35e915fd7910724dc0bd6
Author: Jens Axboe <jens.axboe@oracle.com>
Date:   Mon Aug 17 08:40:50 2009 +0200

    sparc: add basic support for 'perf'
    
    This wires up the perf_counter_open() syscall so that basic
    software support for perf is working.
    
    Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 3f8b6a9..71a9a11 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -25,6 +25,7 @@ config SPARC
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select RTC_CLASS
 	select RTC_DRV_M48T59
+	select HAVE_PERF_COUNTERS
 
 config SPARC32
 	def_bool !64BIT
@@ -44,6 +45,7 @@ config SPARC64
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
diff --git a/arch/sparc/kernel/systbls_32.S b/arch/sparc/kernel/systbls_32.S
index 6909016..0418157 100644
--- a/arch/sparc/kernel/systbls_32.S
+++ b/arch/sparc/kernel/systbls_32.S
@@ -82,5 +82,5 @@ sys_call_table:
 /*310*/	.long sys_utimensat, sys_signalfd, sys_timerfd_create, sys_eventfd, sys_fallocate
 /*315*/	.long sys_timerfd_settime, sys_timerfd_gettime, sys_signalfd4, sys_eventfd2, sys_epoll_create1
 /*320*/	.long sys_dup3, sys_pipe2, sys_inotify_init1, sys_accept4, sys_preadv
-/*325*/	.long sys_pwritev, sys_rt_tgsigqueueinfo
+/*325*/	.long sys_pwritev, sys_rt_tgsigqueueinfo, sys_perf_counter_open
 
diff --git a/arch/sparc/kernel/systbls_64.S b/arch/sparc/kernel/systbls_64.S
index 6b3ee88..01e4849 100644
--- a/arch/sparc/kernel/systbls_64.S
+++ b/arch/sparc/kernel/systbls_64.S
@@ -83,7 +83,7 @@ sys_call_table32:
 /*310*/	.word compat_sys_utimensat, compat_sys_signalfd, sys_timerfd_create, sys_eventfd, compat_sys_fallocate
 	.word compat_sys_timerfd_settime, compat_sys_timerfd_gettime, compat_sys_signalfd4, sys_eventfd2, sys_epoll_create1
 /*320*/	.word sys_dup3, sys_pipe2, sys_inotify_init1, sys_accept4, compat_sys_preadv
-	.word compat_sys_pwritev, compat_sys_rt_tgsigqueueinfo
+	.word compat_sys_pwritev, compat_sys_rt_tgsigqueueinfo, sys_perf_counter_open
 
 #endif /* CONFIG_COMPAT */
 
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

