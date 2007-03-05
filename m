Return-Path: <linux-kernel-owner+w=401wt.eu-S1752569AbXCEA3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569AbXCEA3Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 19:29:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752573AbXCEA3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 19:29:25 -0500
Received: from moutng.kundenserver.de ([212.227.126.179]:57470 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569AbXCEA3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 19:29:23 -0500
Message-Id: <20070305002632.960582899@arndb.de>
References: <20070305002024.875968120@arndb.de>
User-Agent: quilt/0.45-1
Date: Mon, 05 Mar 2007 01:20:26 +0100
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC PATCH 2/3] use hrtimer in select and pselect
Content-Disposition: inline; filename=implement-select-using-hrtimer.patch
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:c48f057754fc1b1a557605ab9fa6da41
X-Provags-ID2: V01U2FsdGVkX1/ZqxcmlqX5y2ET/wyPQkmIZUypGxLIib9AoSC
 xmlp4pQdhHA8TgSamD5AOVa8MdDfs+PzPzFx+xvCwX00pdXnfR
 KV6yNCFDJo92Gx4HuZzSg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This changes the select and pselect system calls to use the
new schedule_timeout_hr function. Since many applications
use the select function instead of nanosleep, this provides
a higher resolution sleep to them.

BUG: the same needs to be done for the compat syscalls, the
current patch breaks building on 64 bit machines.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Index: linux-cg/fs/select.c
===================================================================
--- linux-cg.orig/fs/select.c
+++ linux-cg/fs/select.c
@@ -189,7 +189,7 @@ get_max:
 #define POLLOUT_SET (POLLWRBAND | POLLWRNORM | POLLOUT | POLLERR)
 #define POLLEX_SET (POLLPRI)
 
-int do_select(int n, fd_set_bits *fds, s64 *timeout)
+int do_select(int n, fd_set_bits *fds, ktime_t *timeout)
 {
 	struct poll_wqueues table;
 	poll_table *wait;
@@ -205,12 +205,11 @@ int do_select(int n, fd_set_bits *fds, s
 
 	poll_initwait(&table);
 	wait = &table.pt;
-	if (!*timeout)
+	if (timeout && !timeout->tv64)
 		wait = NULL;
 	retval = 0;
 	for (;;) {
 		unsigned long *rinp, *routp, *rexp, *inp, *outp, *exp;
-		long __timeout;
 
 		set_current_state(TASK_INTERRUPTIBLE);
 
@@ -266,27 +265,19 @@ int do_select(int n, fd_set_bits *fds, s
 				*rexp = res_ex;
 		}
 		wait = NULL;
-		if (retval || !*timeout || signal_pending(current))
+		if (retval || (timeout && !timeout->tv64)
+		    || signal_pending(current))
 			break;
 		if(table.error) {
 			retval = table.error;
 			break;
 		}
 
-		if (*timeout < 0) {
+		if (!timeout || timeout->tv64 < 0)
 			/* Wait indefinitely */
-			__timeout = MAX_SCHEDULE_TIMEOUT;
-		} else if (unlikely(*timeout >= (s64)MAX_SCHEDULE_TIMEOUT - 1)) {
-			/* Wait for longer than MAX_SCHEDULE_TIMEOUT. Do it in a loop */
-			__timeout = MAX_SCHEDULE_TIMEOUT - 1;
-			*timeout -= __timeout;
-		} else {
-			__timeout = *timeout;
-			*timeout = 0;
-		}
-		__timeout = schedule_timeout(__timeout);
-		if (*timeout >= 0)
-			*timeout += __timeout;
+			schedule();
+		else
+			*timeout = schedule_timeout_hr(*timeout);
 	}
 	__set_current_state(TASK_RUNNING);
 
@@ -307,7 +298,7 @@ int do_select(int n, fd_set_bits *fds, s
 	((unsigned long) (MAX_SCHEDULE_TIMEOUT / HZ)-1)
 
 static int core_sys_select(int n, fd_set __user *inp, fd_set __user *outp,
-			   fd_set __user *exp, s64 *timeout)
+			   fd_set __user *exp, ktime_t *timeout)
 {
 	fd_set_bits fds;
 	void *bits;
@@ -384,7 +375,7 @@ out_nofds:
 asmlinkage long sys_select(int n, fd_set __user *inp, fd_set __user *outp,
 			fd_set __user *exp, struct timeval __user *tvp)
 {
-	s64 timeout = -1;
+	ktime_t timeout, *timeoutp = NULL;
 	struct timeval tv;
 	int ret;
 
@@ -395,24 +386,20 @@ asmlinkage long sys_select(int n, fd_set
 		if (tv.tv_sec < 0 || tv.tv_usec < 0)
 			return -EINVAL;
 
+		timeout = timeval_to_ktime(tv);
 		/* Cast to u64 to make GCC stop complaining */
-		if ((u64)tv.tv_sec >= (u64)MAX_INT64_SECONDS)
-			timeout = -1;	/* infinite */
-		else {
-			timeout = ROUND_UP(tv.tv_usec, USEC_PER_SEC/HZ);
-			timeout += tv.tv_sec * HZ;
-		}
+		if ((u64)tv.tv_sec < (u64)MAX_INT64_SECONDS)
+			timeoutp = &timeout;
 	}
 
-	ret = core_sys_select(n, inp, outp, exp, &timeout);
+	ret = core_sys_select(n, inp, outp, exp, timeoutp);
 
 	if (tvp) {
 		struct timeval rtv;
 
 		if (current->personality & STICKY_TIMEOUTS)
 			goto sticky;
-		rtv.tv_usec = jiffies_to_usecs(do_div((*(u64*)&timeout), HZ));
-		rtv.tv_sec = timeout;
+		rtv = ktime_to_timeval(timeout);
 		if (timeval_compare(&rtv, &tv) >= 0)
 			rtv = tv;
 		if (copy_to_user(tvp, &rtv, sizeof(rtv))) {
@@ -438,7 +425,7 @@ asmlinkage long sys_pselect7(int n, fd_s
 		fd_set __user *exp, struct timespec __user *tsp,
 		const sigset_t __user *sigmask, size_t sigsetsize)
 {
-	s64 timeout = MAX_SCHEDULE_TIMEOUT;
+	ktime_t timeout, *timeoutp = NULL;
 	sigset_t ksigmask, sigsaved;
 	struct timespec ts;
 	int ret;
@@ -450,13 +437,11 @@ asmlinkage long sys_pselect7(int n, fd_s
 		if (ts.tv_sec < 0 || ts.tv_nsec < 0)
 			return -EINVAL;
 
+		timeout = timespec_to_ktime(ts);
+
 		/* Cast to u64 to make GCC stop complaining */
-		if ((u64)ts.tv_sec >= (u64)MAX_INT64_SECONDS)
-			timeout = -1;	/* infinite */
-		else {
-			timeout = ROUND_UP(ts.tv_nsec, NSEC_PER_SEC/HZ);
-			timeout += ts.tv_sec * HZ;
-		}
+		if ((u64)ts.tv_sec < (u64)MAX_INT64_SECONDS)
+			timeoutp = &timeout;
 	}
 
 	if (sigmask) {
@@ -470,16 +455,15 @@ asmlinkage long sys_pselect7(int n, fd_s
 		sigprocmask(SIG_SETMASK, &ksigmask, &sigsaved);
 	}
 
-	ret = core_sys_select(n, inp, outp, exp, &timeout);
+	ret = core_sys_select(n, inp, outp, exp, timeoutp);
 
 	if (tsp) {
 		struct timespec rts;
 
 		if (current->personality & STICKY_TIMEOUTS)
 			goto sticky;
-		rts.tv_nsec = jiffies_to_usecs(do_div((*(u64*)&timeout), HZ)) *
-						1000;
-		rts.tv_sec = timeout;
+
+		rts = ktime_to_timespec(timeout);
 		if (timespec_compare(&rts, &ts) >= 0)
 			rts = ts;
 		if (copy_to_user(tsp, &rts, sizeof(rts))) {
Index: linux-cg/include/linux/poll.h
===================================================================
--- linux-cg.orig/include/linux/poll.h
+++ linux-cg/include/linux/poll.h
@@ -112,7 +112,7 @@ void zero_fd_set(unsigned long nr, unsig
 
 #define MAX_INT64_SECONDS (((s64)(~((u64)0)>>1)/HZ)-1)
 
-extern int do_select(int n, fd_set_bits *fds, s64 *timeout);
+extern int do_select(int n, fd_set_bits *fds, ktime_t *timeout);
 extern int do_sys_poll(struct pollfd __user * ufds, unsigned int nfds,
 		       s64 *timeout);
 

--

