Return-Path: <linux-kernel-owner+w=401wt.eu-S932336AbZIDGeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336AbZIDGeT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 02:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751414AbZIDGeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 02:34:18 -0400
Received: from brick.kernel.dk ([93.163.65.50]:53558 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341AbZIDGeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 02:34:17 -0400
Date: Fri, 4 Sep 2009 08:34:19 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: David Miller <davem@davemloft.net>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       fweisbec@gmail.com
Subject: Re: [PATCH] basic perf support for sparc
Message-ID: <20090904063419.GO18599@kernel.dk>
References: <20090817064851.GQ12579@kernel.dk> <20090903.213702.250776705.davem@davemloft.net> <20090904050256.GA8382@elte.hu> <20090903.220906.44384937.davem@davemloft.net> <20090904052005.GN18599@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090904052005.GN18599@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 04 2009, Jens Axboe wrote:
> On Thu, Sep 03 2009, David Miller wrote:
> > From: Ingo Molnar <mingo@elte.hu>
> > Date: Fri, 4 Sep 2009 07:02:56 +0200
> > 
> > > 
> > > * David Miller <davem@davemloft.net> wrote:
> > > 
> > >> Does this build for you without adding an
> > >> arch/sparc/include/asm/perf_counter.h that looks
> > >> something like the following?
> > >> 
> > >> #ifndef _ASM_SPARC_PERF_COUNTER_H
> > >> #define _ASM_SPARC_PERF_COUNTER_H
> > >> 
> > >> #define PERF_COUNTER_INDEX_OFFSET	0
> > >> 
> > >> #endif
> > >> 
> > >> Or is this somehow now required in the -tip trees?
> > > 
> > > This used to be required but i recently fixed this (and that fix is 
> > > upstream as well) via:
> > > 
> > >   f738eb1: perf_counter: Fix the PARISC build
> > > 
> > > there's now a default define of 0 so you dont have to define it and 
> > > can leave out this chunk.
> > > 
> > > ( That index is only interesting if the architecture has a way to 
> > >   allow unprivileged user-space to access counter registers 
> > >   directly. In that case the index reflects the offset from the 
> > >   (constantly changing) dynamix index which we put into the mmap 
> > >   header. With Sparc not having a hw-PMU implementation this index 
> > >   is entirely uninteresting at this stage. )
> > 
> > But you still do need at least an empty perf_counter.h file
> > right?  Jens must have left the file out of his submission
> > by accident, and that's what I'm trying to get to the bottom
> > of here :-)
> > 
> > I assume there was a similar change to deal with references to
> > set_perf_counter_pending() too or is at least a NOP definition
> > still needed?
> 
> It wasn't required when I built and used it (and sent the patch), I used
> the posted patch as-is. It's been a few weeks since I last updated and
> ran that box, let me double check after morning coffee and send you a
> fresh patch (if needed) :-)

It seems I had a left-over arch/sparc/include/asm/perf_counter.h from
earlier experiments that was never checked in, so that is why it worked
for me. include/linux/sched.h does:

#ifdef CONFIG_PERF_COUNTERS
# include <asm/perf_counter.h>
#endif

so that's no way around an empty stub file. Updated patch below, this is
what I have been using.

commit 99d9c7f3326a73e2b9952c99d6c7a15bf761858f
Author: Jens Axboe <jens.axboe@oracle.com>
Date:   Fri Sep 4 08:31:22 2009 +0200

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
diff --git a/arch/sparc/include/asm/perf_counter.h b/arch/sparc/include/asm/perf_counter.h
new file mode 100644
index 0000000..664b624
--- /dev/null
+++ b/arch/sparc/include/asm/perf_counter.h
@@ -0,0 +1,8 @@
+#ifndef __ASM_SPARC_PERF_COUNTER_H
+#define __ASM_SPARC_PERF_COUNTER_H
+
+static inline void set_perf_counter_pending(void) { }
+
+#define	PERF_COUNTER_INDEX_OFFSET	0
+
+#endif 
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
index 2ee7250..91b06b7 100644
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

