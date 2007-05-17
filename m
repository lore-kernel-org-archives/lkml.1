Return-Path: <linux-kernel-owner+w=401wt.eu-S1758997AbXEQTOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758997AbXEQTOW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 15:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755795AbXEQTOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 15:14:16 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:14264 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072AbXEQTOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 15:14:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=YNo55YsNMF80Mie50ZDxNxAp8g0HykyhKX1NxC1ach34ubpz0OCAYk+vTCP4rnZ/6OxfbpUnULL60PrR8L5o9cT/V6KZyndD7IFeSFAtiB7y2gxiX5lmal+v4IQ6VsU5Y8IMb8y5liYqzDosSSPoA7iJO8JF70z13y0D8EEx1tw=
Message-ID: <4354d3270705171214v25bc4834t5e28a08649761e91@mail.gmail.com>
Date: Thu, 17 May 2007 19:14:13 +0000
From: "=?ISO-8859-1?Q?T=F6r=F6k_Edvin?=" <edwintorok@gmail.com>
To: mingo@redhat.com
Subject: CFS Scheduler and real-time tasks
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have tested your new CFS scheduler (v2.6.21.1-v12) on a Dell
Inspiron 6400 (Intel Core Duo @ 1.66 Ghz, SMP).

I tested with the bash-for-loop, and the massiv_intr.c workload you
suggested here http://lkml.org/lkml/2007/5/14/227 , then I tested with
a modified version of massiv_intr.c.
My modifications were: add a new task, that modifies work_msecs after
each iteration, and also increases sleep_time; and run this task with
realtime static priority 1. The purpose isn't to test how much 'time'
the rt process gets (it should get all the CPU while it runs, right?),
but to test if a RT priority task can 'unbalance' non-rt tasks.
[diff can be found at end of my mail, it should be applied to
massive_intr.c from http://lkml.org/lkml/2007/3/26/319]

In short, my results are: CFS is much more precise than standard
scheduler (on my system, with my workload), but:
- the precision of CFS on my system is worse than on your system
- the precision of CFS decreases if real-time tasks are run

Ingo, you have obtained much more accurate results (massive_intr
output max error is 1; vs. my results, where error is: 20 - 40).
Is there anything I can change in my kernel to increase precision of CFS?
[I have tried running test with both ondemand and performance
governors, same results]

Is there something I am doing wrong, or is the precision decrease
expected, when running real-time tasks too?

I have run the test using 'Linux localhost 2.6.21-gentoo', gentoo 2007.0.

Results of bash-for-loop:
7730 edwin     20   0  2888  552  256 R   20  0.1   0:05.69 bash
 7731 edwin     20   0  2888  552  256 R   19  0.1   0:05.68 bash
 7732 edwin     20   0  2888  552  256 R   19  0.1   0:05.69 bash
 7728 edwin     20   0  2888  552  256 R   19  0.1   0:05.70 bash
 7729 edwin     20   0  2888  552  256 R   19  0.1   0:05.67 bash
 7733 edwin     20   0  2888  552  256 R   19  0.1   0:05.58 bash
 7734 edwin     20   0  2888  552  256 R   19  0.1   0:05.57 bash
 7735 edwin     20   0  2888  552  256 R   19  0.1   0:05.58 bash
 7736 edwin     20   0  2888  552  256 R   19  0.1   0:05.58 bash
 7737 edwin     20   0  2888  552  256 R   19  0.1   0:05.58 bash

Very precise indeed, the default scheduler produces lots of different
timings there.

Running original massiv_intr.c, I can see that the maximum error is ~20.
[gcc massive_intr_orig.c -o mo -lrt]

edwin@localhost ~ $ ./mo 9 10
025633  00000182
025630  00000182
025627  00000185
025628  00000187
025634  00000194
025632  00000181
025626  00000195
025629  00000181
025631  00000194
edwin@localhost ~ $ ./mo 9 10
025840  00000175
025845  00000175
025842  00000172
025848  00000174
025841  00000205
025847  00000207
025846  00000208
025844  00000173
025843  00000207
edwin@localhost ~ $ ./mo 9 10
026318  00000216
026319  00000212
026324  00000221
026322  00000218
026320  00000213
026321  00000213
026323  00000212
026317  00000194
026316  00000220
edwin@localhost ~ $ ./mo 9 10
026646  00000230
026645  00000219
026653  00000227
026651  00000233
026650  00000228
026647  00000228
026648  00000217
026652  00000208
026649  00000230

Running my version of massiv_intr.c:
[gcc massive_intr_new.c -o massive_new -lrt]

./massiv_new 9 10
027216  00000205
027218  00000202
027220  00000227
027217  00000205
027219  00000228
027222  00000226
027215  00000227
027221  00000206

RT JOB:027223   00000061

edwin@localhost ~ $ ./massiv_new 9 10
027547  00000196
027542  00000205
027546  00000223
027544  00000198
027541  00000224
027548  00000218
027545  00000226
027543  00000202

RT JOB:027549   00000059


Everything fine, now I run it with root privileges, so that the
real-time priority task gets to run with RT priority:
localhost edwin # ./massiv_new 9 10
027957  00000158
027954  00000172
027956  00000163
027955  00000146
027958  00000140
027960  00000184
027959  00000181
027961  00000157

RT JOB:027962   00000187

localhost edwin # ./massiv_new 9 10
028333  00000177
028335  00000159
028332  00000185
028337  00000136
028336  00000156
028334  00000145
028338  00000175
028339  00000162

RT JOB:028340   00000183

The error is ~40, which is double the error when running with no RT task.


Best regards,
Edwin

--- massiv_orig.c	2007-05-17 21:20:21.000000000 +0000
+++ massive_intr.c	2007-05-17 21:39:31.000000000 +0000
@@ -43,6 +43,7 @@
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <sys/mman.h>
+#include <sched.h>
 #include <sys/wait.h>
 #include <fcntl.h>
 #include <unistd.h>
@@ -56,6 +57,8 @@

 #define WORK_MSECS	8
 #define SLEEP_MSECS	1
+#define RT_MSECS_INCREMENT 1
+#define RT_MSECS_MAX	 50

 #define MAX_PROC	1024
 #define SAMPLE_COUNT	1000000000
@@ -113,6 +116,74 @@
 	after = tv[1].tv_sec*USECS_PER_SEC+tv[1].tv_usec;
 	return SAMPLE_COUNT/(after - before)*USECS_PER_MSEC;
 }
+static void *test_job_rt(void *arg)
+{
+	int l = (int)arg;
+	int count = 0;
+	time_t current;
+	sigset_t sigset;
+	struct sigaction sa;
+	struct timespec ts0 = { 0, NSECS_PER_MSEC*SLEEP_MSECS};
+	struct timespec ts1 = { 0, NSECS_PER_MSEC*RT_MSECS_MAX};
+	struct timespec ts_delta = { 0, NSECS_PER_MSEC*RT_MSECS_INCREMENT};
+	struct timespec ts = ts0;
+	struct sched_param sp;
+	int work_msecs = WORK_MSECS;
+
+	sa.sa_handler = sighandler;
+	if (sigemptyset(&sa.sa_mask) < 0) {
+		warn("sigemptyset() failed");
+		abnormal_exit();
+	}
+	sa.sa_flags = 0;
+	if (sigaction(SIGUSR1, &sa, NULL) < 0) {
+		warn("sigaction() failed");
+		abnormal_exit();
+	}
+	if (sigemptyset(&sigset) < 0) {
+		warn("sigfillset() failed");
+		abnormal_exit();
+	}
+	sigsuspend(&sigset);
+	if (errno != EINTR) {
+		warn("sigsuspend() failed");
+		abnormal_exit();
+	}
+	sp.sched_priority = 1;
+
+	sched_setscheduler(0, SCHED_FIFO, &sp);
+	/* main loop */
+	do {
+		loopfnc(work_msecs*l);
+		if (nanosleep(&ts, NULL) < 0) {
+			warn("nanosleep() failed");
+			abnormal_exit();
+		}
+		count++;
+		if (time(&current) == -1) {
+			warn("time() failed");
+			abnormal_exit();
+		}
+		ts.tv_nsec += ts_delta.tv_nsec;
+		if(ts.tv_nsec > ts1.tv_nsec)
+			ts = ts0;
+		work_msecs += RT_MSECS_INCREMENT;
+		if(work_msecs > RT_MSECS_MAX)
+			work_msecs = WORK_MSECS;
+	} while (difftime(current, *first) < runtime);
+	sp.sched_priority = 0;
+	sched_setscheduler(0, SCHED_OTHER, &sp);
+	if (sem_wait(printsem) < 0) {
+		warn("sem_wait() failed");
+		abnormal_exit();
+	}
+	printf("\nRT JOB:%06d\t%08d\n\n", getpid(), count);
+	if (sem_post(printsem) < 0) {
+		warn("sem_post() failed");
+		abnormal_exit();
+	}
+	exit(EXIT_SUCCESS);
+}
 static void *test_job(void *arg)
 {
 	int l = (int)arg;
@@ -237,8 +308,12 @@
 					warn("kill() failed");
 			goto err_sem;
 		}
-		if (pid[i] == 0)
-			test_job((void *)c);
+		if (pid[i] == 0) {
+			if(i == nproc-1)
+				test_job_rt((void *)c);
+			else
+				test_job((void*)c);
+		}
 	}
 	if (sigemptyset(&sigset) < 0) {
 		warn("sigemptyset() failed");
