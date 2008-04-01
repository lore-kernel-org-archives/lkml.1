Return-Path: <linux-kernel-owner+w=401wt.eu-S1759468AbYDAUpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759468AbYDAUpy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 16:45:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757039AbYDAUpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 16:45:44 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:43430 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079AbYDAUpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 16:45:43 -0400
Date: Tue, 1 Apr 2008 16:44:58 -0400
Message-Id: <200804012044.m31KiwQt005659@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: fmayhar@google.com, mingo@elte.hu, oleg@tv-sign.ru, tglx@linutronix.de
Subject: Re: + itimer-fix-hangs-with-many-threads.patch added to -mm tree 
In-reply-to: Your message of "Mon, 31 Mar 2008 14:47:36 PDT."
             <200803312147.m2VLlbr5027658@imap1.linux-foundation.org> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <200803312147.m2VLlbr5027658@imap1.linux-foundation.org>, akpm@linux-foundation.org writes:
> 
> The patch titled
>      itimer: fix hangs with many threads
> has been added to the -mm tree.  Its filename is
>      itimer-fix-hangs-with-many-threads.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
> out what to do about this
> 
> The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

This patch doesn't compile for me on MMOTM (stamp-2008-04-01-02-39):

  CC      kernel/sys.o
kernel/sys.c: In function 'sys_times':
kernel/sys.c:885: error: 'sig' undeclared (first use in this function)
kernel/sys.c:885: error: (Each undeclared identifier is reported only once
kernel/sys.c:885: error: for each function it appears in.)
make[1]: *** [kernel/sys.o] Error 1
  CC      kernel/posix-cpu-timers.o
kernel/posix-cpu-timers.c: In function 'run_posix_cpu_timers':
kernel/posix-cpu-timers.c:1214: error: 'sig' undeclared (first use in this function)
kernel/posix-cpu-timers.c:1214: error: (Each undeclared identifier is reported only once
kernel/posix-cpu-timers.c:1214: error: for each function it appears in.)
make[1]: *** [kernel/posix-cpu-timers.o] Error 1

Small patch below.

Cheers,
Erez.


diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 325fdbe..56e9f6a 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -1211,7 +1211,7 @@ void run_posix_cpu_timers(struct task_struct *tsk)
 	    virt_ticks(tsk), tsk->se.sum_exec_runtime)) {
 		if (unlikely(tsk->signal == NULL))
 			return;
-		if (!sig->thread_group_times)
+		if (!tsk->signal->thread_group_times)
 			return;
 		thread_group_cputime(&tg_times, tsk->signal);
 		tg_prof = cputime_add(tg_times.utime, tg_times.stime);
diff --git a/kernel/sys.c b/kernel/sys.c
index c8b5ed0..cf7063a 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -882,7 +882,7 @@ asmlinkage long sys_times(struct tms __user * tbuf)
 		 * If a POSIX interval timer is running use the process-wide
 		 * fields, else fall back to brute force.
 		 */
-		if (sig->thread_group_times) {
+		if (tsk->signal->thread_group_times) {
 			thread_group_cputime(&thread_group_times, tsk->signal);
 			utime = thread_group_times.utime;
 			stime = thread_group_times.stime;
