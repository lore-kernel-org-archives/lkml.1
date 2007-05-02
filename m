Return-Path: <linux-kernel-owner+w=401wt.eu-S2992768AbXEBFj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992768AbXEBFj5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 01:39:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030622AbXEBFiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 01:38:16 -0400
Received: from haxent.com ([65.99.219.155]:2184 "EHLO haxent.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030591AbXEBFeu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 01:34:50 -0400
Message-Id: <20070502053426.030750000@haxent.com.br>
References: <20070502052235.914764000@haxent.com.br>
User-Agent: quilt/0.45-1
Date: Wed, 02 May 2007 02:22:44 -0300
From: Davi Arnaut <davi@haxent.com.br>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [patch 09/22] pollfs: pollable hrtimers
Content-Disposition: inline; filename=pollfs-timer.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Per file descriptor high-resolution timers. A classic unix file interface for
the POSIX timer_(create|settime|gettime|delete) family of functions.

Signed-off-by: Davi E. M. Arnaut <davi@haxent.com.br>

---
 fs/pollfs/Makefile |    1 
 fs/pollfs/timer.c  |  198 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 init/Kconfig       |    7 +
 3 files changed, 206 insertions(+)

Index: linux-2.6/fs/pollfs/timer.c
===================================================================
--- /dev/null
+++ linux-2.6/fs/pollfs/timer.c
@@ -0,0 +1,198 @@
+/*
+ * pollable timers
+ *
+ * Copyright (C) 2007 Davi E. M. Arnaut
+ *
+ * Licensed under the GNU GPL. See the file COPYING for details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/wait.h>
+#include <linux/poll.h>
+#include <linux/pollfs_fs.h>
+#include <linux/hrtimer.h>
+
+struct pfs_timer {
+	wait_queue_head_t wait;
+	ktime_t interval;
+	spinlock_t lock;
+	unsigned long overruns;
+	struct hrtimer timer;
+	struct pfs_file file;
+};
+
+struct hrtimerspec {
+	int flags;
+	clockid_t clock;
+	struct itimerspec expr;
+};
+
+static ssize_t read(struct pfs_timer *evs, struct itimerspec __user *uspec)
+{
+	int ret = -EAGAIN;
+	ktime_t remaining = {};
+	unsigned long overruns = 0;
+	struct itimerspec spec = {};
+	struct hrtimer *timer = &evs->timer;
+
+	spin_lock_irq(&evs->lock);
+
+	if (!evs->overruns)
+		goto out_unlock;
+
+	if (hrtimer_active(timer))
+		remaining = hrtimer_get_remaining(timer);
+	else if (evs->interval.tv64 > 0)
+		overruns = hrtimer_forward(timer, hrtimer_cb_get_time(timer),
+					   evs->interval);
+
+	ret = -EOVERFLOW;
+	if (overruns > (ULONG_MAX - evs->overruns))
+		goto out_unlock;
+	else
+		evs->overruns += overruns;
+
+	if (remaining.tv64 > 0)
+		spec.it_value = ktime_to_timespec(remaining);
+
+	spec.it_interval = ktime_to_timespec(evs->interval);
+
+	ret = 0;
+
+out_unlock:
+	spin_unlock_irq(&evs->lock);
+
+	if (ret)
+		return ret;
+
+	if (copy_to_user(uspec, &spec, sizeof(spec)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static enum hrtimer_restart timer_fn(struct hrtimer *timer)
+{
+	struct pfs_timer *evs = container_of(timer, struct pfs_timer, timer);
+	unsigned long flags;
+
+	spin_lock_irqsave(&evs->lock, flags);
+	/* timer tick, interval has elapsed */
+	if (!evs->overruns++)
+		wake_up_all(&evs->wait);
+	spin_unlock_irqrestore(&evs->lock, flags);
+
+	return HRTIMER_NORESTART;
+}
+
+static inline void rearm_timer(struct pfs_timer *evs, struct hrtimerspec *spec)
+{
+	struct hrtimer *timer = &evs->timer;
+	enum hrtimer_mode mode = HRTIMER_MODE_REL;
+
+	if (spec->flags & TIMER_ABSTIME)
+		mode = HRTIMER_MODE_ABS;
+
+	do {
+		spin_lock_irq(&evs->lock);
+		if (hrtimer_try_to_cancel(timer) >= 0)
+			break;
+		spin_unlock_irq(&evs->lock);
+		cpu_relax();
+	} while (1);
+
+	hrtimer_init(timer, spec->clock, mode);
+
+	timer->function = timer_fn;
+	timer->expires = timespec_to_ktime(spec->expr.it_value);
+	evs->interval = timespec_to_ktime(spec->expr.it_interval);
+
+	if (timer->expires.tv64)
+		hrtimer_start(timer, timer->expires, mode);
+
+	spin_unlock_irq(&evs->lock);
+}
+
+static inline int spec_invalid(const struct hrtimerspec *spec)
+{
+	if (spec->clock != CLOCK_REALTIME && spec->clock != CLOCK_MONOTONIC)
+		return 1;
+
+	if (!timespec_valid(&spec->expr.it_value) ||
+	    !timespec_valid(&spec->expr.it_interval))
+		return 1;
+
+	return 0;
+}
+
+static ssize_t write(struct pfs_timer *evs,
+		     const struct hrtimerspec __user *uspec)
+{
+	struct hrtimerspec spec;
+
+	if (copy_from_user(&spec, uspec, sizeof(spec)))
+		return -EFAULT;
+
+	if (spec_invalid(&spec))
+		return -EINVAL;
+
+	rearm_timer(evs, &spec);
+
+	return 0;
+}
+
+static int poll(struct pfs_timer *evs)
+{
+	int ret;
+
+	ret = evs->overruns ? POLLIN : 0;
+
+	return ret;
+}
+
+static int release(struct pfs_timer *evs)
+{
+	hrtimer_cancel(&evs->timer);
+	kfree(evs);
+
+	return 0;
+}
+
+static const struct pfs_operations timer_ops = {
+	.read = PFS_READ(read, struct pfs_timer, struct itimerspec),
+	.write = PFS_WRITE(write, struct pfs_timer, struct hrtimerspec),
+	.poll = PFS_POLL(poll, struct pfs_timer),
+	.release = PFS_RELEASE(release, struct pfs_timer),
+	.rsize = sizeof(struct itimerspec),
+	.wsize = sizeof(struct hrtimerspec),
+};
+
+asmlinkage long sys_pltimer(void)
+{
+	long error;
+	struct pfs_timer *evs;
+
+	evs = kmalloc(sizeof(*evs), GFP_KERNEL);
+	if (!evs)
+		return -ENOMEM;
+
+	evs->overruns = 0;
+	spin_lock_init(&evs->lock);
+	init_waitqueue_head(&evs->wait);
+	hrtimer_init(&evs->timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
+
+	evs->file.data = evs;
+	evs->file.fops = &timer_ops;
+	evs->file.wait = &evs->wait;
+
+	error = pfs_open(&evs->file);
+
+	if (error < 0)
+		release(evs);
+
+	return error;
+}
Index: linux-2.6/fs/pollfs/Makefile
===================================================================
--- linux-2.6.orig/fs/pollfs/Makefile
+++ linux-2.6/fs/pollfs/Makefile
@@ -2,3 +2,4 @@ obj-$(CONFIG_POLLFS) += pollfs.o
 pollfs-y := file.o
 
 pollfs-$(CONFIG_POLLFS_SIGNAL) += signal.o
+pollfs-$(CONFIG_POLLFS_TIMER) += timer.o
Index: linux-2.6/init/Kconfig
===================================================================
--- linux-2.6.orig/init/Kconfig
+++ linux-2.6/init/Kconfig
@@ -476,6 +476,13 @@ config POLLFS_SIGNAL
 	help
 	 Pollable signal support
 
+config POLLFS_TIMER
+	bool "Enable pollfs timer" if EMBEDDED
+	default y
+	depends on POLLFS
+	help
+	 Pollable timer support
+
 config SHMEM
 	bool "Use full shmem filesystem" if EMBEDDED
 	default y

--
