Return-Path: <linux-kernel-owner+w=401wt.eu-S1756747AbYH2PXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747AbYH2PXa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 11:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754470AbYH2PXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 11:23:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:57100 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbYH2PXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 11:23:06 -0400
Date: Fri, 29 Aug 2008 08:06:30 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, mingo@elte.hu, tglx@tglx.de,
       torvalds@linux-foundation.org
Subject: [PATCH 1/5] select: add a timespec version of the timeout to
 select/poll
Message-ID: <20080829080630.5e0ea608@infradead.org>
In-Reply-To: <20080829080549.6906b744@infradead.org>
References: <20080829080549.6906b744@infradead.org>
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
Date: Wed, 27 Aug 2008 11:24:52 -0700
Subject: [PATCH] select: add a timespec version of the timeout to select/poll

This patch adds the end_time parameter to the various pieces in the select()
and poll() paths; but does not use it yet (that is for later patches in
the series). This end_time is the timespec accuracy of the end time (eg
nanoseconds) rather than the current jiffies-juggling that happens all
over the poll/select code. It's also an absolute time, so we can always
see how long there is to go just by looking at the delta between the
end time and the current time.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 fs/compat.c          |   28 ++++++++++++++++++++----
 fs/select.c          |   56 ++++++++++++++++++++++++++++++++++++++++---------
 include/linux/poll.h |    6 ++--
 3 files changed, 71 insertions(+), 19 deletions(-)

diff --git a/fs/compat.c b/fs/compat.c
index c9d1472..7c9b2a1 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1513,7 +1513,8 @@ int compat_set_fd_set(unsigned long nr, compat_ulong_t __user *ufdset,
 	((unsigned long) (MAX_SCHEDULE_TIMEOUT / HZ)-1)
 
 int compat_core_sys_select(int n, compat_ulong_t __user *inp,
-	compat_ulong_t __user *outp, compat_ulong_t __user *exp, s64 *timeout)
+	compat_ulong_t __user *outp, compat_ulong_t __user *exp, s64 *timeout,
+	struct timespec *end_time)
 {
 	fd_set_bits fds;
 	void *bits;
@@ -1560,7 +1561,7 @@ int compat_core_sys_select(int n, compat_ulong_t __user *inp,
 	zero_fd_set(n, fds.res_out);
 	zero_fd_set(n, fds.res_ex);
 
-	ret = do_select(n, &fds, timeout);
+	ret = do_select(n, &fds, timeout, end_time);
 
 	if (ret < 0)
 		goto out;
@@ -1589,6 +1590,7 @@ asmlinkage long compat_sys_select(int n, compat_ulong_t __user *inp,
 	s64 timeout = -1;
 	struct compat_timeval tv;
 	int ret;
+	struct timespec end_time;
 
 	if (tvp) {
 		if (copy_from_user(&tv, tvp, sizeof(tv)))
@@ -1604,9 +1606,12 @@ asmlinkage long compat_sys_select(int n, compat_ulong_t __user *inp,
 			timeout = DIV_ROUND_UP(tv.tv_usec, 1000000/HZ);
 			timeout += tv.tv_sec * HZ;
 		}
+		ktime_get_ts(&end_time);
+		timespec_add_ns(&end_time, tv.tv_usec*1000);
+		end_time.tv_sec += tv.tv_sec;
 	}
 
-	ret = compat_core_sys_select(n, inp, outp, exp, &timeout);
+	ret = compat_core_sys_select(n, inp, outp, exp, &timeout, &end_time);
 
 	if (tvp) {
 		struct compat_timeval rtv;
@@ -1645,6 +1650,8 @@ asmlinkage long compat_sys_pselect7(int n, compat_ulong_t __user *inp,
 	sigset_t ksigmask, sigsaved;
 	s64 timeout = MAX_SCHEDULE_TIMEOUT;
 	struct compat_timespec ts;
+	struct timespec end_time;
+
 	int ret;
 
 	if (tsp) {
@@ -1653,6 +1660,11 @@ asmlinkage long compat_sys_pselect7(int n, compat_ulong_t __user *inp,
 
 		if (ts.tv_sec < 0 || ts.tv_nsec < 0)
 			return -EINVAL;
+		ktime_get_ts(&end_time);
+		end_time.tv_sec += ts.tv_sec;
+		timespec_add_ns(&end_time, ts.tv_nsec);
+	} else {
+		memset(&end_time, 0, sizeof(end_time));
 	}
 
 	if (sigmask) {
@@ -1679,7 +1691,7 @@ asmlinkage long compat_sys_pselect7(int n, compat_ulong_t __user *inp,
 			}
 		}
 
-		ret = compat_core_sys_select(n, inp, outp, exp, &timeout);
+		ret = compat_core_sys_select(n, inp, outp, exp, &timeout, &end_time);
 
 	} while (!ret && !timeout && tsp && (ts.tv_sec || ts.tv_nsec));
 
@@ -1755,6 +1767,7 @@ asmlinkage long compat_sys_ppoll(struct pollfd __user *ufds,
 	compat_sigset_t ss32;
 	sigset_t ksigmask, sigsaved;
 	struct compat_timespec ts;
+	struct timespec end_time;
 	s64 timeout = -1;
 	int ret;
 
@@ -1767,6 +1780,11 @@ asmlinkage long compat_sys_ppoll(struct pollfd __user *ufds,
 		   an s64. Otherwise the compiler bitches at us */
 		timeout = DIV_ROUND_UP(ts.tv_nsec, 1000000000/HZ);
 		timeout += ts.tv_sec * HZ;
+		ktime_get_ts(&end_time);
+		end_time.tv_sec += ts.tv_sec;
+		timespec_add_ns(&end_time, ts.tv_nsec);
+	} else {
+		memset(&end_time, 0, sizeof(end_time));
 	}
 
 	if (sigmask) {
@@ -1780,7 +1798,7 @@ asmlinkage long compat_sys_ppoll(struct pollfd __user *ufds,
 		sigprocmask(SIG_SETMASK, &ksigmask, &sigsaved);
 	}
 
-	ret = do_sys_poll(ufds, nfds, &timeout);
+	ret = do_sys_poll(ufds, nfds, &timeout, &end_time);
 
 	/* We can restart this syscall, usually */
 	if (ret == -EINTR) {
diff --git a/fs/select.c b/fs/select.c
index da0e882..6a6e33a 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -182,7 +182,7 @@ get_max:
 #define POLLOUT_SET (POLLWRBAND | POLLWRNORM | POLLOUT | POLLERR)
 #define POLLEX_SET (POLLPRI)
 
-int do_select(int n, fd_set_bits *fds, s64 *timeout)
+int do_select(int n, fd_set_bits *fds, s64 *timeout, struct timespec *end_time)
 {
 	struct poll_wqueues table;
 	poll_table *wait;
@@ -300,7 +300,7 @@ int do_select(int n, fd_set_bits *fds, s64 *timeout)
 	((unsigned long) (MAX_SCHEDULE_TIMEOUT / HZ)-1)
 
 int core_sys_select(int n, fd_set __user *inp, fd_set __user *outp,
-			   fd_set __user *exp, s64 *timeout)
+			   fd_set __user *exp, s64 *timeout, struct timespec *end_time)
 {
 	fd_set_bits fds;
 	void *bits;
@@ -351,7 +351,7 @@ int core_sys_select(int n, fd_set __user *inp, fd_set __user *outp,
 	zero_fd_set(n, fds.res_out);
 	zero_fd_set(n, fds.res_ex);
 
-	ret = do_select(n, &fds, timeout);
+	ret = do_select(n, &fds, timeout, end_time);
 
 	if (ret < 0)
 		goto out;
@@ -380,6 +380,9 @@ asmlinkage long sys_select(int n, fd_set __user *inp, fd_set __user *outp,
 	s64 timeout = -1;
 	struct timeval tv;
 	int ret;
+	struct timespec end_time;
+
+	memset(&end_time, 0, sizeof(end_time));
 
 	if (tvp) {
 		if (copy_from_user(&tv, tvp, sizeof(tv)))
@@ -388,6 +391,11 @@ asmlinkage long sys_select(int n, fd_set __user *inp, fd_set __user *outp,
 		if (tv.tv_sec < 0 || tv.tv_usec < 0)
 			return -EINVAL;
 
+		ktime_get_ts(&end_time);
+		timespec_add_ns(&end_time, tv.tv_usec*1000);
+		end_time.tv_sec += tv.tv_sec;
+
+
 		/* Cast to u64 to make GCC stop complaining */
 		if ((u64)tv.tv_sec >= (u64)MAX_INT64_SECONDS)
 			timeout = -1;	/* infinite */
@@ -397,7 +405,7 @@ asmlinkage long sys_select(int n, fd_set __user *inp, fd_set __user *outp,
 		}
 	}
 
-	ret = core_sys_select(n, inp, outp, exp, &timeout);
+	ret = core_sys_select(n, inp, outp, exp, &timeout, &end_time);
 
 	if (tvp) {
 		struct timeval rtv;
@@ -434,15 +442,22 @@ asmlinkage long sys_pselect7(int n, fd_set __user *inp, fd_set __user *outp,
 	s64 timeout = MAX_SCHEDULE_TIMEOUT;
 	sigset_t ksigmask, sigsaved;
 	struct timespec ts;
+	struct timespec end_time;
 	int ret;
 
+	memset(&end_time, 0, sizeof(end_time));
+
 	if (tsp) {
+		ktime_get_ts(&end_time);
 		if (copy_from_user(&ts, tsp, sizeof(ts)))
 			return -EFAULT;
 
 		if (ts.tv_sec < 0 || ts.tv_nsec < 0)
 			return -EINVAL;
 
+		end_time.tv_sec += ts.tv_sec;
+		timespec_add_ns(&end_time, ts.tv_nsec);
+
 		/* Cast to u64 to make GCC stop complaining */
 		if ((u64)ts.tv_sec >= (u64)MAX_INT64_SECONDS)
 			timeout = -1;	/* infinite */
@@ -463,7 +478,7 @@ asmlinkage long sys_pselect7(int n, fd_set __user *inp, fd_set __user *outp,
 		sigprocmask(SIG_SETMASK, &ksigmask, &sigsaved);
 	}
 
-	ret = core_sys_select(n, inp, outp, exp, &timeout);
+	ret = core_sys_select(n, inp, outp, exp, &timeout, &end_time);
 
 	if (tsp) {
 		struct timespec rts;
@@ -574,7 +589,8 @@ static inline unsigned int do_pollfd(struct pollfd *pollfd, poll_table *pwait)
 }
 
 static int do_poll(unsigned int nfds,  struct poll_list *list,
-		   struct poll_wqueues *wait, s64 *timeout)
+		   struct poll_wqueues *wait, s64 *timeout,
+		   struct timespec *end_time)
 {
 	int count = 0;
 	poll_table* pt = &wait->pt;
@@ -646,7 +662,8 @@ static int do_poll(unsigned int nfds,  struct poll_list *list,
 #define N_STACK_PPS ((sizeof(stack_pps) - sizeof(struct poll_list))  / \
 			sizeof(struct pollfd))
 
-int do_sys_poll(struct pollfd __user *ufds, unsigned int nfds, s64 *timeout)
+int do_sys_poll(struct pollfd __user *ufds, unsigned int nfds, s64 *timeout,
+		struct timespec *end_time)
 {
 	struct poll_wqueues table;
  	int err = -EFAULT, fdcount, len, size;
@@ -686,7 +703,7 @@ int do_sys_poll(struct pollfd __user *ufds, unsigned int nfds, s64 *timeout)
 	}
 
 	poll_initwait(&table);
-	fdcount = do_poll(nfds, head, &table, timeout);
+	fdcount = do_poll(nfds, head, &table, timeout, end_time);
 	poll_freewait(&table);
 
 	for (walk = head; walk; walk = walk->next) {
@@ -716,8 +733,15 @@ static long do_restart_poll(struct restart_block *restart_block)
 	int nfds = restart_block->arg1;
 	s64 timeout = ((s64)restart_block->arg3<<32) | (s64)restart_block->arg2;
 	int ret;
+	struct timespec end_time;
+
+	memset(&end_time, 0, sizeof(end_time));
+	if (timeout) {
+		ktime_get_ts(&end_time);
+		timespec_add_ns(&end_time, timeout * NSEC_PER_SEC/HZ);
+	}
 
-	ret = do_sys_poll(ufds, nfds, &timeout);
+	ret = do_sys_poll(ufds, nfds, &timeout, &end_time);
 	if (ret == -EINTR) {
 		restart_block->fn = do_restart_poll;
 		restart_block->arg2 = timeout & 0xFFFFFFFF;
@@ -732,6 +756,7 @@ asmlinkage long sys_poll(struct pollfd __user *ufds, unsigned int nfds,
 {
 	s64 timeout_jiffies;
 	int ret;
+	struct timespec end_time;
 
 	if (timeout_msecs > 0) {
 #if HZ > 1000
@@ -741,12 +766,15 @@ asmlinkage long sys_poll(struct pollfd __user *ufds, unsigned int nfds,
 		else
 #endif
 			timeout_jiffies = msecs_to_jiffies(timeout_msecs) + 1;
+		ktime_get_ts(&end_time);
+		timespec_add_ns(&end_time, timeout_msecs*1000*1000);
 	} else {
 		/* Infinite (< 0) or no (0) timeout */
 		timeout_jiffies = timeout_msecs;
+		memset(&end_time, 0, sizeof(end_time));
 	}
 
-	ret = do_sys_poll(ufds, nfds, &timeout_jiffies);
+	ret = do_sys_poll(ufds, nfds, &timeout_jiffies, &end_time);
 	if (ret == -EINTR) {
 		struct restart_block *restart_block;
 		restart_block = &current_thread_info()->restart_block;
@@ -768,6 +796,7 @@ asmlinkage long sys_ppoll(struct pollfd __user *ufds, unsigned int nfds,
 	sigset_t ksigmask, sigsaved;
 	struct timespec ts;
 	s64 timeout = -1;
+	struct timespec end_time;
 	int ret;
 
 	if (tsp) {
@@ -781,6 +810,11 @@ asmlinkage long sys_ppoll(struct pollfd __user *ufds, unsigned int nfds,
 			timeout = DIV_ROUND_UP(ts.tv_nsec, NSEC_PER_SEC/HZ);
 			timeout += ts.tv_sec * HZ;
 		}
+		ktime_get_ts(&end_time);
+		end_time.tv_sec += ts.tv_sec;
+		timespec_add_ns(&end_time, ts.tv_nsec);
+	} else {
+		memset(&end_time, 0, sizeof(end_time));
 	}
 
 	if (sigmask) {
@@ -794,7 +828,7 @@ asmlinkage long sys_ppoll(struct pollfd __user *ufds, unsigned int nfds,
 		sigprocmask(SIG_SETMASK, &ksigmask, &sigsaved);
 	}
 
-	ret = do_sys_poll(ufds, nfds, &timeout);
+	ret = do_sys_poll(ufds, nfds, &timeout, &end_time);
 
 	/* We can restart this syscall, usually */
 	if (ret == -EINTR) {
diff --git a/include/linux/poll.h b/include/linux/poll.h
index ef45382..ba9d4ce 100644
--- a/include/linux/poll.h
+++ b/include/linux/poll.h
@@ -114,11 +114,11 @@ void zero_fd_set(unsigned long nr, unsigned long *fdset)
 
 #define MAX_INT64_SECONDS (((s64)(~((u64)0)>>1)/HZ)-1)
 
-extern int do_select(int n, fd_set_bits *fds, s64 *timeout);
+extern int do_select(int n, fd_set_bits *fds, s64 *timeout, struct timespec *end_time);
 extern int do_sys_poll(struct pollfd __user * ufds, unsigned int nfds,
-		       s64 *timeout);
+		       s64 *timeout, struct timespec *end_time);
 extern int core_sys_select(int n, fd_set __user *inp, fd_set __user *outp,
-			   fd_set __user *exp, s64 *timeout);
+			   fd_set __user *exp, s64 *timeout, struct timespec *end_time);
 
 #endif /* KERNEL */
 
-- 
1.5.5.1

