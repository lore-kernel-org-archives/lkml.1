Return-Path: <linux-kernel-owner+w=401wt.eu-S1755483AbYHaQdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483AbYHaQdA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 12:33:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755206AbYHaQbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 12:31:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:36236 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755128AbYHaQbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 12:31:32 -0400
Date: Sun, 31 Aug 2008 09:31:08 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, tglx@tglx.de, mingo@elte.hu,
       torvalds@linux-foundation.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5/5] select: switch select() and poll() over to hrtimers
Message-ID: <20080831093108.27c5bdda@infradead.org>
In-Reply-To: <20080831092828.13ae0279@infradead.org>
References: <20080831092828.13ae0279@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sun, 31 Aug 2008 08:26:40 -0700
Subject: [PATCH] select: switch select() and poll() over to hrtimers

With lots of help, input and cleanups from Thomas Gleixner

This patch switches select() and poll() over to hrtimers.

The core of the patch is replacing the "s64 timeout" with a
"struct timespec end_time" in all the plumbing.

But most of the diffstat comes from using the just introduced helpers:
	poll_select_set_timeout
	poll_select_copy_remaining
	timespec_add_safe
which make manipulating the timespec easier and less error-prone.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 fs/compat.c          |  136 ++++----------------------
 fs/select.c          |  263 +++++++++++++++++---------------------------------
 include/linux/poll.h |    6 +-
 3 files changed, 111 insertions(+), 294 deletions(-)

diff --git a/fs/compat.c b/fs/compat.c
index 424767c..133ed7f 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1568,7 +1568,8 @@ int compat_set_fd_set(unsigned long nr, compat_ulong_t __user *ufdset,
 	((unsigned long) (MAX_SCHEDULE_TIMEOUT / HZ)-1)
 
 int compat_core_sys_select(int n, compat_ulong_t __user *inp,
-	compat_ulong_t __user *outp, compat_ulong_t __user *exp, s64 *timeout)
+	compat_ulong_t __user *outp, compat_ulong_t __user *exp,
+	struct timespec *end_time)
 {
 	fd_set_bits fds;
 	void *bits;
@@ -1615,7 +1616,7 @@ int compat_core_sys_select(int n, compat_ulong_t __user *inp,
 	zero_fd_set(n, fds.res_out);
 	zero_fd_set(n, fds.res_ex);
 
-	ret = do_select(n, &fds, timeout);
+	ret = do_select(n, &fds, end_time);
 
 	if (ret < 0)
 		goto out;
@@ -1641,7 +1642,7 @@ asmlinkage long compat_sys_select(int n, compat_ulong_t __user *inp,
 	compat_ulong_t __user *outp, compat_ulong_t __user *exp,
 	struct compat_timeval __user *tvp)
 {
-	s64 timeout = -1;
+	struct timespec end_time, *to = NULL;
 	struct compat_timeval tv;
 	int ret;
 
@@ -1649,43 +1650,14 @@ asmlinkage long compat_sys_select(int n, compat_ulong_t __user *inp,
 		if (copy_from_user(&tv, tvp, sizeof(tv)))
 			return -EFAULT;
 
-		if (tv.tv_sec < 0 || tv.tv_usec < 0)
+		to = &end_time;
+		if (poll_select_set_timeout(to, tv.tv_sec,
+					    tv.tv_usec * NSEC_PER_USEC))
 			return -EINVAL;
-
-		/* Cast to u64 to make GCC stop complaining */
-		if ((u64)tv.tv_sec >= (u64)MAX_INT64_SECONDS)
-			timeout = -1;	/* infinite */
-		else {
-			timeout = DIV_ROUND_UP(tv.tv_usec, 1000000/HZ);
-			timeout += tv.tv_sec * HZ;
-		}
 	}
 
-	ret = compat_core_sys_select(n, inp, outp, exp, &timeout);
-
-	if (tvp) {
-		struct compat_timeval rtv;
-
-		if (current->personality & STICKY_TIMEOUTS)
-			goto sticky;
-		rtv.tv_usec = jiffies_to_usecs(do_div((*(u64*)&timeout), HZ));
-		rtv.tv_sec = timeout;
-		if (compat_timeval_compare(&rtv, &tv) >= 0)
-			rtv = tv;
-		if (copy_to_user(tvp, &rtv, sizeof(rtv))) {
-sticky:
-			/*
-			 * If an application puts its timeval in read-only
-			 * memory, we don't want the Linux-specific update to
-			 * the timeval to cause a fault after the select has
-			 * completed successfully. However, because we're not
-			 * updating the timeval, we can't restart the system
-			 * call.
-			 */
-			if (ret == -ERESTARTNOHAND)
-				ret = -EINTR;
-		}
-	}
+	ret = compat_core_sys_select(n, inp, outp, exp, to);
+	ret = poll_select_copy_remaining(&end_time, tvp, 1, ret);
 
 	return ret;
 }
@@ -1698,15 +1670,16 @@ asmlinkage long compat_sys_pselect7(int n, compat_ulong_t __user *inp,
 {
 	compat_sigset_t ss32;
 	sigset_t ksigmask, sigsaved;
-	s64 timeout = MAX_SCHEDULE_TIMEOUT;
 	struct compat_timespec ts;
+	struct timespec end_time, *to = NULL;
 	int ret;
 
 	if (tsp) {
 		if (copy_from_user(&ts, tsp, sizeof(ts)))
 			return -EFAULT;
 
-		if (ts.tv_sec < 0 || ts.tv_nsec < 0)
+		to = &end_time;
+		if (poll_select_set_timeout(to, ts.tv_sec, ts.tv_nsec))
 			return -EINVAL;
 	}
 
@@ -1721,51 +1694,8 @@ asmlinkage long compat_sys_pselect7(int n, compat_ulong_t __user *inp,
 		sigprocmask(SIG_SETMASK, &ksigmask, &sigsaved);
 	}
 
-	do {
-		if (tsp) {
-			if ((unsigned long)ts.tv_sec < MAX_SELECT_SECONDS) {
-				timeout = DIV_ROUND_UP(ts.tv_nsec, 1000000000/HZ);
-				timeout += ts.tv_sec * (unsigned long)HZ;
-				ts.tv_sec = 0;
-				ts.tv_nsec = 0;
-			} else {
-				ts.tv_sec -= MAX_SELECT_SECONDS;
-				timeout = MAX_SELECT_SECONDS * HZ;
-			}
-		}
-
-		ret = compat_core_sys_select(n, inp, outp, exp, &timeout);
-
-	} while (!ret && !timeout && tsp && (ts.tv_sec || ts.tv_nsec));
-
-	if (tsp) {
-		struct compat_timespec rts;
-
-		if (current->personality & STICKY_TIMEOUTS)
-			goto sticky;
-
-		rts.tv_sec = timeout / HZ;
-		rts.tv_nsec = (timeout % HZ) * (NSEC_PER_SEC/HZ);
-		if (rts.tv_nsec >= NSEC_PER_SEC) {
-			rts.tv_sec++;
-			rts.tv_nsec -= NSEC_PER_SEC;
-		}
-		if (compat_timespec_compare(&rts, &ts) >= 0)
-			rts = ts;
-		if (copy_to_user(tsp, &rts, sizeof(rts))) {
-sticky:
-			/*
-			 * If an application puts its timeval in read-only
-			 * memory, we don't want the Linux-specific update to
-			 * the timeval to cause a fault after the select has
-			 * completed successfully. However, because we're not
-			 * updating the timeval, we can't restart the system
-			 * call.
-			 */
-			if (ret == -ERESTARTNOHAND)
-				ret = -EINTR;
-		}
-	}
+	ret = compat_core_sys_select(n, inp, outp, exp, to);
+	ret = poll_select_copy_remaining(&end_time, tsp, 0, ret);
 
 	if (ret == -ERESTARTNOHAND) {
 		/*
@@ -1810,18 +1740,16 @@ asmlinkage long compat_sys_ppoll(struct pollfd __user *ufds,
 	compat_sigset_t ss32;
 	sigset_t ksigmask, sigsaved;
 	struct compat_timespec ts;
-	s64 timeout = -1;
+	struct timespec end_time, *to = NULL;
 	int ret;
 
 	if (tsp) {
 		if (copy_from_user(&ts, tsp, sizeof(ts)))
 			return -EFAULT;
 
-		/* We assume that ts.tv_sec is always lower than
-		   the number of seconds that can be expressed in
-		   an s64. Otherwise the compiler bitches at us */
-		timeout = DIV_ROUND_UP(ts.tv_nsec, 1000000000/HZ);
-		timeout += ts.tv_sec * HZ;
+		to = &end_time;
+		if (poll_select_set_timeout(to, ts.tv_sec, ts.tv_nsec))
+			return -EINVAL;
 	}
 
 	if (sigmask) {
@@ -1835,7 +1763,7 @@ asmlinkage long compat_sys_ppoll(struct pollfd __user *ufds,
 		sigprocmask(SIG_SETMASK, &ksigmask, &sigsaved);
 	}
 
-	ret = do_sys_poll(ufds, nfds, &timeout);
+	ret = do_sys_poll(ufds, nfds, to);
 
 	/* We can restart this syscall, usually */
 	if (ret == -EINTR) {
@@ -1853,31 +1781,7 @@ asmlinkage long compat_sys_ppoll(struct pollfd __user *ufds,
 	} else if (sigmask)
 		sigprocmask(SIG_SETMASK, &sigsaved, NULL);
 
-	if (tsp && timeout >= 0) {
-		struct compat_timespec rts;
-
-		if (current->personality & STICKY_TIMEOUTS)
-			goto sticky;
-		/* Yes, we know it's actually an s64, but it's also positive. */
-		rts.tv_nsec = jiffies_to_usecs(do_div((*(u64*)&timeout), HZ)) *
-					1000;
-		rts.tv_sec = timeout;
-		if (compat_timespec_compare(&rts, &ts) >= 0)
-			rts = ts;
-		if (copy_to_user(tsp, &rts, sizeof(rts))) {
-sticky:
-			/*
-			 * If an application puts its timeval in read-only
-			 * memory, we don't want the Linux-specific update to
-			 * the timeval to cause a fault after the select has
-			 * completed successfully. However, because we're not
-			 * updating the timeval, we can't restart the system
-			 * call.
-			 */
-			if (ret == -ERESTARTNOHAND && timeout >= 0)
-				ret = -EINTR;
-		}
-	}
+	ret = poll_select_copy_remaining(&end_time, tsp, 0, ret);
 
 	return ret;
 }
diff --git a/fs/select.c b/fs/select.c
index 1180a62..f6dceb5 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -24,6 +24,7 @@
 #include <linux/fdtable.h>
 #include <linux/fs.h>
 #include <linux/rcupdate.h>
+#include <linux/hrtimer.h>
 
 #include <asm/uaccess.h>
 
@@ -203,8 +204,6 @@ sticky:
 	return ret;
 }
 
-
-
 #define FDS_IN(fds, n)		(fds->in + n)
 #define FDS_OUT(fds, n)		(fds->out + n)
 #define FDS_EX(fds, n)		(fds->ex + n)
@@ -257,11 +256,12 @@ get_max:
 #define POLLOUT_SET (POLLWRBAND | POLLWRNORM | POLLOUT | POLLERR)
 #define POLLEX_SET (POLLPRI)
 
-int do_select(int n, fd_set_bits *fds, s64 *timeout)
+int do_select(int n, fd_set_bits *fds, struct timespec *end_time)
 {
+	ktime_t expire, *to = NULL;
 	struct poll_wqueues table;
 	poll_table *wait;
-	int retval, i;
+	int retval, i, timed_out = 0;
 
 	rcu_read_lock();
 	retval = max_select_fd(n, fds);
@@ -273,12 +273,14 @@ int do_select(int n, fd_set_bits *fds, s64 *timeout)
 
 	poll_initwait(&table);
 	wait = &table.pt;
-	if (!*timeout)
+	if (end_time && !end_time->tv_sec && !end_time->tv_nsec) {
 		wait = NULL;
+		timed_out = 1;
+	}
+
 	retval = 0;
 	for (;;) {
 		unsigned long *rinp, *routp, *rexp, *inp, *outp, *exp;
-		long __timeout;
 
 		set_current_state(TASK_INTERRUPTIBLE);
 
@@ -334,27 +336,25 @@ int do_select(int n, fd_set_bits *fds, s64 *timeout)
 			cond_resched();
 		}
 		wait = NULL;
-		if (retval || !*timeout || signal_pending(current))
+		if (retval || timed_out || signal_pending(current))
 			break;
 		if (table.error) {
 			retval = table.error;
 			break;
 		}
 
-		if (*timeout < 0) {
-			/* Wait indefinitely */
-			__timeout = MAX_SCHEDULE_TIMEOUT;
-		} else if (unlikely(*timeout >= (s64)MAX_SCHEDULE_TIMEOUT - 1)) {
-			/* Wait for longer than MAX_SCHEDULE_TIMEOUT. Do it in a loop */
-			__timeout = MAX_SCHEDULE_TIMEOUT - 1;
-			*timeout -= __timeout;
-		} else {
-			__timeout = *timeout;
-			*timeout = 0;
+		/*
+		 * If this is the first loop and we have a timeout
+		 * given, then we convert to ktime_t and set the to
+		 * pointer to the expiry value.
+		 */
+		if (end_time && !to) {
+			expire = timespec_to_ktime(*end_time);
+			to = &expire;
 		}
-		__timeout = schedule_timeout(__timeout);
-		if (*timeout >= 0)
-			*timeout += __timeout;
+
+		if (!schedule_hrtimeout(to, HRTIMER_MODE_ABS))
+			timed_out = 1;
 	}
 	__set_current_state(TASK_RUNNING);
 
@@ -375,7 +375,7 @@ int do_select(int n, fd_set_bits *fds, s64 *timeout)
 	((unsigned long) (MAX_SCHEDULE_TIMEOUT / HZ)-1)
 
 int core_sys_select(int n, fd_set __user *inp, fd_set __user *outp,
-			   fd_set __user *exp, s64 *timeout)
+			   fd_set __user *exp, struct timespec *end_time)
 {
 	fd_set_bits fds;
 	void *bits;
@@ -426,7 +426,7 @@ int core_sys_select(int n, fd_set __user *inp, fd_set __user *outp,
 	zero_fd_set(n, fds.res_out);
 	zero_fd_set(n, fds.res_ex);
 
-	ret = do_select(n, &fds, timeout);
+	ret = do_select(n, &fds, end_time);
 
 	if (ret < 0)
 		goto out;
@@ -452,7 +452,7 @@ out_nofds:
 asmlinkage long sys_select(int n, fd_set __user *inp, fd_set __user *outp,
 			fd_set __user *exp, struct timeval __user *tvp)
 {
-	s64 timeout = -1;
+	struct timespec end_time, *to = NULL;
 	struct timeval tv;
 	int ret;
 
@@ -460,43 +460,14 @@ asmlinkage long sys_select(int n, fd_set __user *inp, fd_set __user *outp,
 		if (copy_from_user(&tv, tvp, sizeof(tv)))
 			return -EFAULT;
 
-		if (tv.tv_sec < 0 || tv.tv_usec < 0)
+		to = &end_time;
+		if (poll_select_set_timeout(to, tv.tv_sec,
+					    tv.tv_usec * NSEC_PER_USEC))
 			return -EINVAL;
-
-		/* Cast to u64 to make GCC stop complaining */
-		if ((u64)tv.tv_sec >= (u64)MAX_INT64_SECONDS)
-			timeout = -1;	/* infinite */
-		else {
-			timeout = DIV_ROUND_UP(tv.tv_usec, USEC_PER_SEC/HZ);
-			timeout += tv.tv_sec * HZ;
-		}
 	}
 
-	ret = core_sys_select(n, inp, outp, exp, &timeout);
-
-	if (tvp) {
-		struct timeval rtv;
-
-		if (current->personality & STICKY_TIMEOUTS)
-			goto sticky;
-		rtv.tv_usec = jiffies_to_usecs(do_div((*(u64*)&timeout), HZ));
-		rtv.tv_sec = timeout;
-		if (timeval_compare(&rtv, &tv) >= 0)
-			rtv = tv;
-		if (copy_to_user(tvp, &rtv, sizeof(rtv))) {
-sticky:
-			/*
-			 * If an application puts its timeval in read-only
-			 * memory, we don't want the Linux-specific update to
-			 * the timeval to cause a fault after the select has
-			 * completed successfully. However, because we're not
-			 * updating the timeval, we can't restart the system
-			 * call.
-			 */
-			if (ret == -ERESTARTNOHAND)
-				ret = -EINTR;
-		}
-	}
+	ret = core_sys_select(n, inp, outp, exp, to);
+	ret = poll_select_copy_remaining(&end_time, tvp, 1, ret);
 
 	return ret;
 }
@@ -506,25 +477,17 @@ asmlinkage long sys_pselect7(int n, fd_set __user *inp, fd_set __user *outp,
 		fd_set __user *exp, struct timespec __user *tsp,
 		const sigset_t __user *sigmask, size_t sigsetsize)
 {
-	s64 timeout = MAX_SCHEDULE_TIMEOUT;
 	sigset_t ksigmask, sigsaved;
-	struct timespec ts;
+	struct timespec ts, end_time, *to = NULL;
 	int ret;
 
 	if (tsp) {
 		if (copy_from_user(&ts, tsp, sizeof(ts)))
 			return -EFAULT;
 
-		if (ts.tv_sec < 0 || ts.tv_nsec < 0)
+		to = &end_time;
+		if (poll_select_set_timeout(to, ts.tv_sec, ts.tv_nsec))
 			return -EINVAL;
-
-		/* Cast to u64 to make GCC stop complaining */
-		if ((u64)ts.tv_sec >= (u64)MAX_INT64_SECONDS)
-			timeout = -1;	/* infinite */
-		else {
-			timeout = DIV_ROUND_UP(ts.tv_nsec, NSEC_PER_SEC/HZ);
-			timeout += ts.tv_sec * HZ;
-		}
 	}
 
 	if (sigmask) {
@@ -538,32 +501,8 @@ asmlinkage long sys_pselect7(int n, fd_set __user *inp, fd_set __user *outp,
 		sigprocmask(SIG_SETMASK, &ksigmask, &sigsaved);
 	}
 
-	ret = core_sys_select(n, inp, outp, exp, &timeout);
-
-	if (tsp) {
-		struct timespec rts;
-
-		if (current->personality & STICKY_TIMEOUTS)
-			goto sticky;
-		rts.tv_nsec = jiffies_to_usecs(do_div((*(u64*)&timeout), HZ)) *
-						1000;
-		rts.tv_sec = timeout;
-		if (timespec_compare(&rts, &ts) >= 0)
-			rts = ts;
-		if (copy_to_user(tsp, &rts, sizeof(rts))) {
-sticky:
-			/*
-			 * If an application puts its timeval in read-only
-			 * memory, we don't want the Linux-specific update to
-			 * the timeval to cause a fault after the select has
-			 * completed successfully. However, because we're not
-			 * updating the timeval, we can't restart the system
-			 * call.
-			 */
-			if (ret == -ERESTARTNOHAND)
-				ret = -EINTR;
-		}
-	}
+	ret = core_sys_select(n, inp, outp, exp, &end_time);
+	ret = poll_select_copy_remaining(&end_time, tsp, 0, ret);
 
 	if (ret == -ERESTARTNOHAND) {
 		/*
@@ -649,18 +588,20 @@ static inline unsigned int do_pollfd(struct pollfd *pollfd, poll_table *pwait)
 }
 
 static int do_poll(unsigned int nfds,  struct poll_list *list,
-		   struct poll_wqueues *wait, s64 *timeout)
+		   struct poll_wqueues *wait, struct timespec *end_time)
 {
-	int count = 0;
 	poll_table* pt = &wait->pt;
+	ktime_t expire, *to = NULL;
+	int timed_out = 0, count = 0;
 
 	/* Optimise the no-wait case */
-	if (!(*timeout))
+	if (end_time && !end_time->tv_sec && !end_time->tv_nsec) {
 		pt = NULL;
+		timed_out = 1;
+	}
 
 	for (;;) {
 		struct poll_list *walk;
-		long __timeout;
 
 		set_current_state(TASK_INTERRUPTIBLE);
 		for (walk = list; walk != NULL; walk = walk->next) {
@@ -692,27 +633,21 @@ static int do_poll(unsigned int nfds,  struct poll_list *list,
 			if (signal_pending(current))
 				count = -EINTR;
 		}
-		if (count || !*timeout)
+		if (count || timed_out)
 			break;
 
-		if (*timeout < 0) {
-			/* Wait indefinitely */
-			__timeout = MAX_SCHEDULE_TIMEOUT;
-		} else if (unlikely(*timeout >= (s64)MAX_SCHEDULE_TIMEOUT-1)) {
-			/*
-			 * Wait for longer than MAX_SCHEDULE_TIMEOUT. Do it in
-			 * a loop
-			 */
-			__timeout = MAX_SCHEDULE_TIMEOUT - 1;
-			*timeout -= __timeout;
-		} else {
-			__timeout = *timeout;
-			*timeout = 0;
+		/*
+		 * If this is the first loop and we have a timeout
+		 * given, then we convert to ktime_t and set the to
+		 * pointer to the expiry value.
+		 */
+		if (end_time && !to) {
+			expire = timespec_to_ktime(*end_time);
+			to = &expire;
 		}
 
-		__timeout = schedule_timeout(__timeout);
-		if (*timeout >= 0)
-			*timeout += __timeout;
+		if (!schedule_hrtimeout(to, HRTIMER_MODE_ABS))
+			timed_out = 1;
 	}
 	__set_current_state(TASK_RUNNING);
 	return count;
@@ -721,7 +656,8 @@ static int do_poll(unsigned int nfds,  struct poll_list *list,
 #define N_STACK_PPS ((sizeof(stack_pps) - sizeof(struct poll_list))  / \
 			sizeof(struct pollfd))
 
-int do_sys_poll(struct pollfd __user *ufds, unsigned int nfds, s64 *timeout)
+int do_sys_poll(struct pollfd __user *ufds, unsigned int nfds,
+		struct timespec *end_time)
 {
 	struct poll_wqueues table;
  	int err = -EFAULT, fdcount, len, size;
@@ -761,7 +697,7 @@ int do_sys_poll(struct pollfd __user *ufds, unsigned int nfds, s64 *timeout)
 	}
 
 	poll_initwait(&table);
-	fdcount = do_poll(nfds, head, &table, timeout);
+	fdcount = do_poll(nfds, head, &table, end_time);
 	poll_freewait(&table);
 
 	for (walk = head; walk; walk = walk->next) {
@@ -787,16 +723,21 @@ out_fds:
 
 static long do_restart_poll(struct restart_block *restart_block)
 {
-	struct pollfd __user *ufds = (struct pollfd __user*)restart_block->arg0;
-	int nfds = restart_block->arg1;
-	s64 timeout = ((s64)restart_block->arg3<<32) | (s64)restart_block->arg2;
+	struct pollfd __user *ufds = restart_block->poll.ufds;
+	int nfds = restart_block->poll.nfds;
+	struct timespec *to = NULL, end_time;
 	int ret;
 
-	ret = do_sys_poll(ufds, nfds, &timeout);
+	if (restart_block->poll.has_timeout) {
+		end_time.tv_sec = restart_block->poll.tv_sec;
+		end_time.tv_nsec = restart_block->poll.tv_nsec;
+		to = &end_time;
+	}
+
+	ret = do_sys_poll(ufds, nfds, to);
+
 	if (ret == -EINTR) {
 		restart_block->fn = do_restart_poll;
-		restart_block->arg2 = timeout & 0xFFFFFFFF;
-		restart_block->arg3 = (u64)timeout >> 32;
 		ret = -ERESTART_RESTARTBLOCK;
 	}
 	return ret;
@@ -805,31 +746,32 @@ static long do_restart_poll(struct restart_block *restart_block)
 asmlinkage long sys_poll(struct pollfd __user *ufds, unsigned int nfds,
 			long timeout_msecs)
 {
-	s64 timeout_jiffies;
+	struct timespec end_time, *to = NULL;
 	int ret;
 
-	if (timeout_msecs > 0) {
-#if HZ > 1000
-		/* We can only overflow if HZ > 1000 */
-		if (timeout_msecs / 1000 > (s64)0x7fffffffffffffffULL / (s64)HZ)
-			timeout_jiffies = -1;
-		else
-#endif
-			timeout_jiffies = msecs_to_jiffies(timeout_msecs) + 1;
-	} else {
-		/* Infinite (< 0) or no (0) timeout */
-		timeout_jiffies = timeout_msecs;
+	if (timeout_msecs >= 0) {
+		to = &end_time;
+		poll_select_set_timeout(to, timeout_msecs / MSEC_PER_SEC,
+			NSEC_PER_MSEC * (timeout_msecs % MSEC_PER_SEC));
 	}
 
-	ret = do_sys_poll(ufds, nfds, &timeout_jiffies);
+	ret = do_sys_poll(ufds, nfds, to);
+
 	if (ret == -EINTR) {
 		struct restart_block *restart_block;
+
 		restart_block = &current_thread_info()->restart_block;
 		restart_block->fn = do_restart_poll;
-		restart_block->arg0 = (unsigned long)ufds;
-		restart_block->arg1 = nfds;
-		restart_block->arg2 = timeout_jiffies & 0xFFFFFFFF;
-		restart_block->arg3 = (u64)timeout_jiffies >> 32;
+		restart_block->poll.ufds = ufds;
+		restart_block->poll.nfds = nfds;
+
+		if (timeout_msecs >= 0) {
+			restart_block->poll.tv_sec = end_time.tv_sec;
+			restart_block->poll.tv_nsec = end_time.tv_nsec;
+			restart_block->poll.has_timeout = 1;
+		} else
+			restart_block->poll.has_timeout = 0;
+
 		ret = -ERESTART_RESTARTBLOCK;
 	}
 	return ret;
@@ -841,21 +783,16 @@ asmlinkage long sys_ppoll(struct pollfd __user *ufds, unsigned int nfds,
 	size_t sigsetsize)
 {
 	sigset_t ksigmask, sigsaved;
-	struct timespec ts;
-	s64 timeout = -1;
+	struct timespec ts, end_time, *to = NULL;
 	int ret;
 
 	if (tsp) {
 		if (copy_from_user(&ts, tsp, sizeof(ts)))
 			return -EFAULT;
 
-		/* Cast to u64 to make GCC stop complaining */
-		if ((u64)ts.tv_sec >= (u64)MAX_INT64_SECONDS)
-			timeout = -1;	/* infinite */
-		else {
-			timeout = DIV_ROUND_UP(ts.tv_nsec, NSEC_PER_SEC/HZ);
-			timeout += ts.tv_sec * HZ;
-		}
+		to = &end_time;
+		if (poll_select_set_timeout(to, ts.tv_sec, ts.tv_nsec))
+			return -EINVAL;
 	}
 
 	if (sigmask) {
@@ -869,7 +806,7 @@ asmlinkage long sys_ppoll(struct pollfd __user *ufds, unsigned int nfds,
 		sigprocmask(SIG_SETMASK, &ksigmask, &sigsaved);
 	}
 
-	ret = do_sys_poll(ufds, nfds, &timeout);
+	ret = do_sys_poll(ufds, nfds, to);
 
 	/* We can restart this syscall, usually */
 	if (ret == -EINTR) {
@@ -887,31 +824,7 @@ asmlinkage long sys_ppoll(struct pollfd __user *ufds, unsigned int nfds,
 	} else if (sigmask)
 		sigprocmask(SIG_SETMASK, &sigsaved, NULL);
 
-	if (tsp && timeout >= 0) {
-		struct timespec rts;
-
-		if (current->personality & STICKY_TIMEOUTS)
-			goto sticky;
-		/* Yes, we know it's actually an s64, but it's also positive. */
-		rts.tv_nsec = jiffies_to_usecs(do_div((*(u64*)&timeout), HZ)) *
-						1000;
-		rts.tv_sec = timeout;
-		if (timespec_compare(&rts, &ts) >= 0)
-			rts = ts;
-		if (copy_to_user(tsp, &rts, sizeof(rts))) {
-		sticky:
-			/*
-			 * If an application puts its timeval in read-only
-			 * memory, we don't want the Linux-specific update to
-			 * the timeval to cause a fault after the select has
-			 * completed successfully. However, because we're not
-			 * updating the timeval, we can't restart the system
-			 * call.
-			 */
-			if (ret == -ERESTARTNOHAND && timeout >= 0)
-				ret = -EINTR;
-		}
-	}
+	ret = poll_select_copy_remaining(&end_time, tsp, 0, ret);
 
 	return ret;
 }
diff --git a/include/linux/poll.h b/include/linux/poll.h
index f65de51..badd98a 100644
--- a/include/linux/poll.h
+++ b/include/linux/poll.h
@@ -114,11 +114,11 @@ void zero_fd_set(unsigned long nr, unsigned long *fdset)
 
 #define MAX_INT64_SECONDS (((s64)(~((u64)0)>>1)/HZ)-1)
 
-extern int do_select(int n, fd_set_bits *fds, s64 *timeout);
+extern int do_select(int n, fd_set_bits *fds, struct timespec *end_time);
 extern int do_sys_poll(struct pollfd __user * ufds, unsigned int nfds,
-		       s64 *timeout);
+		       struct timespec *end_time);
 extern int core_sys_select(int n, fd_set __user *inp, fd_set __user *outp,
-			   fd_set __user *exp, s64 *timeout);
+			   fd_set __user *exp, struct timespec *end_time);
 
 extern int poll_select_set_timeout(struct timespec *to, long sec, long nsec);
 
-- 
1.5.5.1

