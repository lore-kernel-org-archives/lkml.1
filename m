Return-Path: <linux-kernel-owner+w=401wt.eu-S1755098AbYHaQc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098AbYHaQc1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 12:32:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754762AbYHaQb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 12:31:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:36223 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679AbYHaQbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 12:31:24 -0400
Date: Sun, 31 Aug 2008 09:30:10 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, tglx@tglx.de, mingo@elte.hu,
       torvalds@linux-foundation.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 3/5] select: add poll_select_set_timeout() and
 poll_select_copy_remaining() helpers
Message-ID: <20080831093010.3093455c@infradead.org>
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


From: Thomas Gleixner <tglx@linutronix.de>
Date: Sun, 31 Aug 2008 08:16:57 -0700
Subject: [PATCH] select: add poll_select_set_timeout() and
poll_select_copy_remaining() helpers

This patch adds 2 helpers that will be used for the hrtimer based
select/poll:

poll_select_set_timeout() is a helper that takes a timeout (as a
second, nanosecond pair) and turns that into a "struct timespec" that
represents the absolute end time. This is a common operation in the
many select() and poll() variants and needs various, common, sanity
checks.

poll_select_copy_remaining() is a helper that takes care of copying the
remaining time to userspace, as select(), pselect() and ppoll() do.
This function comes in both a natural and a compat implementation (due
to datastructure differences).

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 fs/compat.c          |   51 ++++++++++++++++++++++++++++++++++
 fs/select.c          |   75
++++++++++++++++++++++++++++++++++++++++++++++++++ include/linux/poll.h
|    2 + 3 files changed, 128 insertions(+), 0 deletions(-)

diff --git a/fs/compat.c b/fs/compat.c
index 075d050..424767c 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1436,6 +1436,57 @@ out_ret:
 
 #define __COMPAT_NFDBITS       (8 * sizeof(compat_ulong_t))
 
+static int poll_select_copy_remaining(struct timespec *end_time, void
__user *p,
+				      int timeval, int ret)
+{
+	struct timespec ts;
+
+	if (!p)
+		return ret;
+
+	if (current->personality & STICKY_TIMEOUTS)
+		goto sticky;
+
+	/* No update for zero timeout */
+	if (!end_time->tv_sec && !end_time->tv_nsec)
+		return ret;
+
+	ktime_get_ts(&ts);
+	ts = timespec_sub(*end_time, ts);
+	if (ts.tv_sec < 0)
+		ts.tv_sec = ts.tv_nsec = 0;
+
+	if (timeval) {
+		struct compat_timeval rtv;
+
+		rtv.tv_sec = ts.tv_sec;
+		rtv.tv_usec = ts.tv_nsec / NSEC_PER_USEC;
+
+		if (!copy_to_user(p, &rtv, sizeof(rtv)))
+			return ret;
+	} else {
+		struct compat_timespec rts;
+
+		rts.tv_sec = ts.tv_sec;
+		rts.tv_nsec = ts.tv_nsec;
+
+		if (!copy_to_user(p, &rts, sizeof(rts)))
+			return ret;
+	}
+	/*
+	 * If an application puts its timeval in read-only memory, we
+	 * don't want the Linux-specific update to the timeval to
+	 * cause a fault after the select has completed
+	 * successfully. However, because we're not updating the
+	 * timeval, we can't restart the system call.
+	 */
+
+sticky:
+	if (ret == -ERESTARTNOHAND)
+		ret = -EINTR;
+	return ret;
+}
+
 /*
  * Ooo, nasty.  We need here to frob 32-bit unsigned longs to
  * 64-bit unsigned longs.
diff --git a/fs/select.c b/fs/select.c
index da0e882..1180a62 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -130,6 +130,81 @@ static void __pollwait(struct file *filp,
wait_queue_head_t *wait_address, add_wait_queue(wait_address,
&entry->wait); }
 
+/**
+ * poll_select_set_timeout - helper function to setup the timeout value
+ * @to:		pointer to timespec variable for the final
timeout
+ * @sec:	seconds (from user space)
+ * @nsec:	nanoseconds (from user space)
+ *
+ * Note, we do not use a timespec for the user space value here, That
+ * way we can use the function for timeval and compat interfaces as
well.
+ *
+ * Returns -EINVAL if sec/nsec are not normalized. Otherwise 0.
+ */
+int poll_select_set_timeout(struct timespec *to, long sec, long nsec)
+{
+	struct timespec ts = {.tv_sec = sec, .tv_nsec = nsec};
+
+	if (!timespec_valid(&ts))
+		return -EINVAL;
+
+	/* Optimize for the zero timeout value here */
+	if (!sec && !nsec) {
+		to->tv_sec = to->tv_nsec = 0;
+	} else {
+		ktime_get_ts(to);
+		*to = timespec_add_safe(*to, ts);
+	}
+	return 0;
+}
+
+static int poll_select_copy_remaining(struct timespec *end_time, void
__user *p,
+				      int timeval, int ret)
+{
+	struct timespec rts;
+	struct timeval rtv;
+
+	if (!p)
+		return ret;
+
+	if (current->personality & STICKY_TIMEOUTS)
+		goto sticky;
+
+	/* No update for zero timeout */
+	if (!end_time->tv_sec && !end_time->tv_nsec)
+		return ret;
+
+	ktime_get_ts(&rts);
+	rts = timespec_sub(*end_time, rts);
+	if (rts.tv_sec < 0)
+		rts.tv_sec = rts.tv_nsec = 0;
+
+	if (timeval) {
+		rtv.tv_sec = rts.tv_sec;
+		rtv.tv_usec = rts.tv_nsec / NSEC_PER_USEC;
+
+		if (!copy_to_user(p, &rtv, sizeof(rtv)))
+			return ret;
+
+	} else if (!copy_to_user(p, &rts, sizeof(rts)))
+		return ret;
+
+	/*
+	 * If an application puts its timeval in read-only memory, we
+	 * don't want the Linux-specific update to the timeval to
+	 * cause a fault after the select has completed
+	 * successfully. However, because we're not updating the
+	 * timeval, we can't restart the system call.
+	 */
+
+sticky:
+	if (ret == -ERESTARTNOHAND)
+		ret = -EINTR;
+	return ret;
+}
+
+
+
 #define FDS_IN(fds, n)		(fds->in + n)
 #define FDS_OUT(fds, n)		(fds->out + n)
 #define FDS_EX(fds, n)		(fds->ex + n)
diff --git a/include/linux/poll.h b/include/linux/poll.h
index ef45382..f65de51 100644
--- a/include/linux/poll.h
+++ b/include/linux/poll.h
@@ -120,6 +120,8 @@ extern int do_sys_poll(struct pollfd __user * ufds,
unsigned int nfds, extern int core_sys_select(int n, fd_set __user
*inp, fd_set __user *outp, fd_set __user *exp, s64 *timeout);
 
+extern int poll_select_set_timeout(struct timespec *to, long sec, long
nsec); +
 #endif /* KERNEL */
 
 #endif /* _LINUX_POLL_H */
-- 
1.5.5.1

