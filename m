Return-Path: <linux-kernel-owner+w=401wt.eu-S1753442AbYIAXRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442AbYIAXRd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 19:17:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753229AbYIAXPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 19:15:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:45017 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbYIAXPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 19:15:42 -0400
Date: Mon, 1 Sep 2008 16:14:59 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, torvalds@linux-foundation.org,
       dwmw2@infradead.org, drepper@redhat.com, mingo@elte.hu, tglx@tglx.de
Subject: [PATCH 13/13] hrtimer: make select() and poll() use the hrtimer
 range feature
Message-ID: <20080901161459.0990a16b@infradead.org>
In-Reply-To: <20080901160343.75a89ec9@infradead.org>
References: <20080901160343.75a89ec9@infradead.org>
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
Subject: [PATCH] hrtimer: make select() and poll() use the hrtimer range feature

This patch makes the select() and poll() hrtimers use the new range
feature and settings from the task struct.

In addition, this includes the estimate_accuracy() function that Linus
posted to lkml (but with a few steps added based on experiments).

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 fs/select.c |   68 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 66 insertions(+), 2 deletions(-)

diff --git a/fs/select.c b/fs/select.c
index f6dceb5..21bf77d 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -28,6 +28,62 @@
 
 #include <asm/uaccess.h>
 
+
+/* Estimate expected accuracy in ns from a timeval */
+
+static unsigned long __estimate_accuracy(struct timespec *tv)
+{
+	/*
+	 * Tens of ms if we're looking at seconds, even
+	 * more for 10s+ sleeping
+	 */
+	if (tv->tv_sec) {
+		/* 100 milliseconds for long sleeps */
+		if (tv->tv_sec > 10)
+			return 100 * NSEC_PER_MSEC;
+
+		/*
+		 * Tens of ms for second-granularity sleeps. This,
+		 * btw, is the historical Linux 100Hz timer range.
+		 */
+		return 10 * NSEC_PER_MSEC;
+	}
+
+	/* 5 msec if we're looking at 100+ milliseconds */
+	if (tv->tv_nsec > 100 * NSEC_PER_MSEC)
+		return 5 * NSEC_PER_MSEC;
+
+	/* A msec if we're looking at 10+ milliseconds */
+	if (tv->tv_nsec > 10 * NSEC_PER_MSEC)
+		return NSEC_PER_MSEC;
+
+	/* half a msec if we're looking at milliseconds */
+	if (tv->tv_nsec > NSEC_PER_MSEC)
+		return NSEC_PER_MSEC/2;
+
+	/* Single usecs if we're looking at microseconds */
+	if (tv->tv_nsec > NSEC_PER_USEC)
+		return NSEC_PER_USEC;
+
+	/* Aim for tenths of nanosecs otherwise */
+	return 10;
+}
+
+static unsigned long estimate_accuracy(struct timespec *tv)
+{
+	unsigned long ret;
+	struct timespec now;
+
+	ktime_get_ts(&now);
+	now = timespec_sub(*tv, now);
+	ret = __estimate_accuracy(&now);
+	if (ret < current->timer_slack_ns)
+		return current->timer_slack_ns;
+	return ret;
+}
+
+
+
 struct poll_table_page {
 	struct poll_table_page * next;
 	struct poll_table_entry * entry;
@@ -262,6 +318,7 @@ int do_select(int n, fd_set_bits *fds, struct timespec *end_time)
 	struct poll_wqueues table;
 	poll_table *wait;
 	int retval, i, timed_out = 0;
+	unsigned long slack = 0;
 
 	rcu_read_lock();
 	retval = max_select_fd(n, fds);
@@ -278,6 +335,9 @@ int do_select(int n, fd_set_bits *fds, struct timespec *end_time)
 		timed_out = 1;
 	}
 
+	if (end_time)
+		slack = estimate_accuracy(end_time);
+
 	retval = 0;
 	for (;;) {
 		unsigned long *rinp, *routp, *rexp, *inp, *outp, *exp;
@@ -353,7 +413,7 @@ int do_select(int n, fd_set_bits *fds, struct timespec *end_time)
 			to = &expire;
 		}
 
-		if (!schedule_hrtimeout(to, HRTIMER_MODE_ABS))
+		if (!schedule_hrtimeout_range(to, slack, HRTIMER_MODE_ABS))
 			timed_out = 1;
 	}
 	__set_current_state(TASK_RUNNING);
@@ -593,6 +653,7 @@ static int do_poll(unsigned int nfds,  struct poll_list *list,
 	poll_table* pt = &wait->pt;
 	ktime_t expire, *to = NULL;
 	int timed_out = 0, count = 0;
+	unsigned long slack = 0;
 
 	/* Optimise the no-wait case */
 	if (end_time && !end_time->tv_sec && !end_time->tv_nsec) {
@@ -600,6 +661,9 @@ static int do_poll(unsigned int nfds,  struct poll_list *list,
 		timed_out = 1;
 	}
 
+	if (end_time)
+		slack = estimate_accuracy(end_time);
+
 	for (;;) {
 		struct poll_list *walk;
 
@@ -646,7 +710,7 @@ static int do_poll(unsigned int nfds,  struct poll_list *list,
 			to = &expire;
 		}
 
-		if (!schedule_hrtimeout(to, HRTIMER_MODE_ABS))
+		if (!schedule_hrtimeout_range(to, slack, HRTIMER_MODE_ABS))
 			timed_out = 1;
 	}
 	__set_current_state(TASK_RUNNING);
-- 
1.5.5.1

