Return-Path: <linux-kernel-owner+w=401wt.eu-S1752759AbZBRLji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbZBRLji (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 06:39:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751494AbZBRLja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 06:39:30 -0500
Received: from brick.kernel.dk ([93.163.65.50]:18739 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453AbZBRLj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 06:39:29 -0500
Date: Wed, 18 Feb 2009 12:37:04 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Shan Wei <shanwei@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: CFQ is worse than other IO schedulers in some cases
Message-ID: <20090218113704.GW30821@kernel.dk>
References: <499BA413.2010705@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499BA413.2010705@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 18 2009, Shan Wei wrote:
> I found that CFQ's performance is worse than other IO scheduer in some cases
> I confirmed its phenomenon when I executed dump command and sysbench on 2.6.28.
> 
> 
> In dump(version:dump-0.4b41-2.fc6), I confirmed 
> the speed under CFQ is slower than other IO schedulers.
> 
> 
> The Test Result(dump):
>    UNIT:Mb/sec
>     _______________________
>     |   IO       |        | 
>     | scheduler  |  Speed |
>     +------------|--------|
>     |cfq         | 24.310 |  
>     |noop        | 36.885 |  
>     |anticipatory| 34.956 |  
>     |deadline    | 36.758 |  
>     +----------------------
> 
> 
> Steps to reproduce(dump):
>   #dump -0uf /dev/null /dev/sda6

The dump issue is a known one, it has to do with how dump uses seperate
processes to interleave IO to the 'same' location. Jeff Moyer posted a
fix for that some time ago, you can also find references to the
discussion and progress right here on lkml. For reference, patch is
included.

> In sysbench(version:sysbench-0.4.10), I confirmed followings.
>   - CFQ's performance is worse than other IO schedulers when only multiple
>     threads test.
>     (There is no difference under single thread test.)
>   - It is worse than other IO scheduler when
>     I used read mode. (No regression in write mode).
>   - There is no difference among other IO schedulers. (e.g noop deadline)
> 
> 
> The Test Result(sysbench):
>    UNIT:Mb/sec
>     __________________________________________________
>     |   IO       |      thread  number               |  
>     | scheduler  |-----------------------------------|
>     |            |  1   |  3    |  5   |   7  |   9  |
>     +------------|------|-------|------|------|------|
>     |cfq         | 77.8 |  32.4 | 43.3 | 55.8 | 58.5 | 
>     |noop        | 78.2 |  79.0 | 78.2 | 77.2 | 77.0 |
>     |anticipatory| 78.2 |  78.6 | 78.4 | 77.8 | 78.1 |
>     |deadline    | 76.9 |  78.4 | 77.0 | 78.4 | 77.9 |
>     +------------------------------------------------+

What kind of storage hardware did you use?

------

Hi,

dump performs poorly when run under the CFQ I/O scheduler.  The reason
for this is that the dump command interleaves I/O between two (or
three?) cooperating processes.  This is about the worst case scenario
you can get for CFQ, as the I/O access pattern within each process is
sequential.  Thus, CFQ will idle for a number of milliseconds waiting
for the current process to issue more I/O before switching to the next.

Now, this behaviour can be changed with tuning.  However, if the dump
command simply shared I/O contexts between cooperating processes, CFQ
could make more intelligent decisions about I/O scheduling.

So, here are the numbers, running under 2.6.28-rc3.

deadline    82241 kB/s
cfq	    34143 kB/s
cfq-shared  82241 kB/s

cfq-shared denotes that the dump utility was patched with the attached
patch to share I/O contexts.  As you can see, with a very little bit of
code change, we can drastically increase the performance of dump under
CFQ (which is the default I/O scheduler used in a number of
distributions).

For more information on the underlying problems, you can refer to the
following kernel discussion:
  http://lkml.org/lkml/2008/11/9/133

Comments are appreciated.

Cheers,

Jeff

diff -up ./dump/tape.c.orig ./dump/tape.c
--- ./dump/tape.c.orig	2005-08-20 17:00:48.000000000 -0400
+++ ./dump/tape.c	2008-11-17 16:40:42.575792509 -0500
@@ -187,6 +187,40 @@ static sigjmp_buf jmpbuf;	/* where to ju
 static int gtperr = 0;
 #endif
 
+/*
+ * Determine if we can use Linux' clone system call.  If so, call it
+ * with the CLONE_IO flag so that all processes will share the same I/O
+ * context, allowing the I/O schedulers to make better scheduling decisions.
+ */
+#ifdef __linux__
+#include <syscall.h>
+
+#ifndef SYS_clone
+#define fork_clone_io fork
+#else /* SYS_clone */
+#include <linux/version.h>
+ 
+/*
+ * Kernel 2.5.49 introduced two extra parameters to the clone system call.
+ * Neither is useful in our case, so this is easy to handle.
+ */
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,49)
+/* clone_flags, child_stack, parent_tidptr, child_tidptr */
+#define CLONE_ARGS SIGCHLD|CLONE_IO, 0, NULL, NULL
+#else
+#define CLONE_ARGS SIGCHLD|CLONE_IO, 0
+#endif /* LINUX_VERSION_CODE */
+
+#define _GNU_SOURCE
+#include <sched.h>
+#include <unistd.h>
+#undef _GNU_SOURCE
+pid_t fork_clone_io(void);
+#endif /* SYS_clone */
+#else /* __linux__ not defined */
+#define fork_clone_io fork
+#endif /* __linux__ */
+
 int
 alloctape(void)
 {
@@ -755,6 +789,16 @@ rollforward(void)
 #endif
 }
 
+#ifdef __linux__
+#ifdef SYS_clone
+pid_t
+fork_clone_io(void)
+{
+	return syscall(SYS_clone, CLONE_ARGS);
+}
+#endif
+#endif
+
 /*
  * We implement taking and restoring checkpoints on the tape level.
  * When each tape is opened, a new process is created by forking; this
@@ -801,7 +845,7 @@ restore_check_point:
 	/*
 	 *	All signals are inherited...
 	 */
-	childpid = fork();
+	childpid = fork_clone_io();
 	if (childpid < 0) {
 		msg("Context save fork fails in parent %d\n", parentpid);
 		Exit(X_ABORT);
@@ -1017,7 +1061,7 @@ enslave(void)
 		}
 
 		if (socketpair(AF_UNIX, SOCK_STREAM, 0, cmd) < 0 ||
-		    (slaves[i].pid = fork()) < 0)
+		    (slaves[i].pid = fork_clone_io()) < 0)
 			quit("too many slaves, %d (recompile smaller): %s\n",
 			    i, strerror(errno));
 

-- 
Jens Axboe

