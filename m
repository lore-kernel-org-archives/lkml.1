Return-Path: <linux-kernel-owner+w=401wt.eu-S2992712AbXBQRE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992712AbXBQRE5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 12:04:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992709AbXBQREn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 12:04:43 -0500
Received: from smtp.nokia.com ([131.228.20.171]:56132 "EHLO
	mgw-ext12.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992603AbXBQRDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 12:03:19 -0500
From: Artem Bityutskiy <dedekind@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>
Date: Sat, 17 Feb 2007 18:56:15 +0200
Message-Id: <20070217165615.5845.79171.sendpatchset@localhost.localdomain>
In-Reply-To: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
Subject: [PATCH 22/44 take 2] [UBI] background thread unit implementation
X-OriginalArrivalTime: 17 Feb 2007 16:55:42.0707 (UTC) FILETIME=[75C95C30:01C752B4]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070217185415-3C659BB0-06EC9986/0-0/0-0
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -auNrp tmp-from/drivers/mtd/ubi/background.c tmp-to/drivers/mtd/ubi/background.c
--- tmp-from/drivers/mtd/ubi/background.c	1970-01-01 02:00:00.000000000 +0200
+++ tmp-to/drivers/mtd/ubi/background.c	2007-02-17 18:07:27.000000000 +0200
@@ -0,0 +1,352 @@
+/*
+ * Copyright (c) International Business Machines Corp., 2006
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See
+ * the GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ * Authors: Thomas Gleixner, Artem B. Bityutskiy
+ */
+
+#include <linux/string.h>
+#include <linux/sched.h>
+#include <linux/completion.h>
+#include <linux/spinlock.h>
+#include <linux/mutex.h>
+#include <linux/freezer.h>
+#include "ubi.h"
+#include "alloc.h"
+#include "debug.h"
+#include "background.h"
+#include "eba.h"
+
+/* Background thread name pattern */
+#define BGT_NAME_PATTERN "ubi_bgt%dd"
+
+/* Highest number of pending works */
+#define BGT_MAX_PENDING_WORKS 0x7FFFFFFF
+
+/*
+ * Maximum number of consecutive background thread failures which is enough to
+ * disable the thread.
+ */
+#define BGT_MAX_FAILURES 32
+
+int ubi_bgt_schedule(const struct ubi_info *ubi, struct ubi_bgt_work *wrk)
+{
+	int err = 0;
+	struct ubi_bgt_info *bgt = ubi->bgt;
+
+retry:
+	spin_lock(&bgt->lock);
+	dbg_bgt("%s: schedule work %p (func %p, priv %p)",
+		bgt->bgt_name, wrk, wrk->func, wrk->priv);
+
+	if (unlikely(!bgt->task)) {
+		ubi_err("task \"%s\" was killed", bgt->bgt_name);
+		spin_unlock(&bgt->lock);
+		return -ENODEV;
+	}
+
+	if (unlikely(bgt->pending_works_count == BGT_MAX_PENDING_WORKS)) {
+		/* Too many pending works */
+		spin_unlock(&bgt->lock);
+		dbg_bgt("pending queue is too long, do a work now");
+		err = ubi_bgt_do_work(ubi);
+		if (unlikely(err))
+			goto out;
+
+		cond_resched();
+		goto retry;
+	}
+
+	list_add_tail(&wrk->list, &bgt->pending_works);
+	bgt->pending_works_count += 1;
+
+	if (!bgt->active_work && likely(bgt->enabled))
+		wake_up_process(bgt->task);
+
+out:
+	spin_unlock(&bgt->lock);
+	return err;
+}
+
+int ubi_bgt_reschedule(const struct ubi_info *ubi, struct ubi_bgt_work *wrk)
+{
+	struct ubi_bgt_info *bgt = ubi->bgt;
+
+	spin_lock(&bgt->lock);
+	dbg_bgt("%s: re-schedule work %p (func %p, priv %p)",
+		bgt->bgt_name, wrk, wrk->func, wrk->priv);
+
+	if (unlikely(!bgt->task)) {
+		ubi_err("task \"%s\" was killed", bgt->bgt_name);
+		spin_unlock(&bgt->lock);
+		return -ENODEV;
+	}
+
+	list_add_tail(&wrk->list, &bgt->pending_works);
+	bgt->pending_works_count += 1;
+
+	if (!bgt->active_work && likely(bgt->enabled))
+		wake_up_process(bgt->task);
+	spin_unlock(&bgt->lock);
+	return 0;
+}
+
+int ubi_bgt_enable(const struct ubi_info *ubi)
+{
+	struct ubi_bgt_info *bgt = ubi->bgt;
+
+	spin_lock(&bgt->lock);
+	dbg_bgt("enable \"%s\"", bgt->bgt_name);
+
+	if (!bgt->task) {
+		ubi_err("task \"%s\" was killed", bgt->bgt_name);
+		spin_unlock(&bgt->lock);
+		return -ENODEV;
+	}
+
+	bgt->enabled = 1;
+	wake_up_process(bgt->task);
+	spin_unlock(&bgt->lock);
+	return 0;
+}
+
+void ubi_bgt_disable(const struct ubi_info *ubi)
+{
+	struct ubi_bgt_info *bgt = ubi->bgt;
+
+	spin_lock(&bgt->lock);
+	dbg_bgt("disable \"%s\"", bgt->bgt_name);
+	bgt->enabled = 0;
+	spin_unlock(&bgt->lock);
+}
+
+void ubi_bgt_kill_thread(const struct ubi_info *ubi)
+{
+	struct ubi_bgt_info *bgt = ubi->bgt;
+
+	dbg_bgt("disable \"%s\"", bgt->bgt_name);
+	if (bgt->task) {
+		send_sig(SIGKILL, bgt->task, 1);
+		wait_for_completion(&bgt->thread_stop);
+	}
+}
+
+int ubi_bgt_do_work(const struct ubi_info *ubi)
+{
+	int err;
+	struct ubi_bgt_work *wrk;
+	struct ubi_bgt_info *bgt = ubi->bgt;
+
+	mutex_lock(&bgt->wrk_mutex);
+
+	spin_lock(&bgt->lock);
+
+	if (unlikely(bgt->pending_works_count == 0)) {
+		err = 0;
+		goto out;
+	}
+
+	bgt->active_work = wrk = list_entry(bgt->pending_works.next,
+					    struct ubi_bgt_work, list);
+	list_del(&wrk->list);
+	bgt->pending_works_count -= 1;
+	ubi_assert(bgt->pending_works_count >= 0);
+	spin_unlock(&bgt->lock);
+
+	/*
+	 * Call the worker function. Do not touch the work structure
+	 * after this call as it will have been freed or reused by that
+	 * time by the worker function.
+	 */
+	dbg_bgt("%s: do work %p (func %p, priv %p)",
+		bgt->bgt_name, wrk, wrk->func, wrk->priv);
+
+	err = wrk->func(ubi, wrk, 0);
+	if (unlikely(err))
+		ubi_err("a work failed with error code %d", err);
+
+	spin_lock(&bgt->lock);
+	bgt->active_work = NULL;
+out:
+	spin_unlock(&bgt->lock);
+	mutex_unlock(&bgt->wrk_mutex);
+	return err;
+}
+
+/**
+ * ubi_thread - UBI background thread.
+ *
+ * @u: the UBI device description object pointer
+ */
+static int ubi_thread(void *u)
+{
+	int failures = 0;
+	const struct ubi_info *ubi = u;
+	struct ubi_bgt_info *bgt = ubi->bgt;
+
+	daemonize(bgt->bgt_name);
+	allow_signal(SIGKILL);
+	allow_signal(SIGSTOP);
+
+	ubi_msg("background thread \"%s\" started, PID %d",
+		bgt->bgt_name, current->pid);
+
+	bgt->task = current;
+	complete(&bgt->thread_start);
+	set_current_state(TASK_INTERRUPTIBLE);
+	schedule();
+
+	for (;;) {
+		cond_resched();
+
+		if (unlikely(!bgt->enabled) ||
+			     list_empty(&bgt->pending_works)) {
+			set_current_state(TASK_INTERRUPTIBLE);
+			schedule();
+		}
+
+		if (try_to_freeze())
+			continue;
+
+		while (signal_pending(current)) {
+			siginfo_t info;
+			unsigned long nr;
+
+			nr = dequeue_signal_lock(current, &current->blocked,
+						 &info);
+			if (nr == SIGKILL)
+				goto out;
+			if (nr == SIGSTOP) {
+				bgt->enabled = !bgt->enabled;
+				ubi_msg("%s the background thread",
+					bgt->enabled ? "enable" : "disable");
+			}
+		}
+
+		spin_lock(&bgt->lock);
+		while (bgt->pending_works_count > 0 && likely(bgt->enabled)) {
+			int err;
+
+			ubi_assert(!list_empty(&bgt->pending_works));
+			spin_unlock(&bgt->lock);
+
+			cond_resched();
+
+			err = ubi_bgt_do_work(ubi);
+			if (unlikely(err)) {
+				ubi_err("%s: work failed with error code %d",
+					bgt->bgt_name, err);
+				if (failures++ > BGT_MAX_FAILURES) {
+					/*
+					 * Too many failures, disable the
+					 * thread and switch to read-only mode.
+					 */
+					ubi_msg("%d consecutive failures, "
+						"disable the background thread",
+						BGT_MAX_FAILURES);
+					ubi_bgt_disable(ubi);
+					ubi_eba_ro_mode(ubi);
+					break;
+				} else
+					failures = 0;
+			}
+
+			spin_lock(&bgt->lock);
+		}
+		spin_unlock(&bgt->lock);
+	}
+
+out:
+	dbg_bgt("killing background thread \"%s\"", bgt->bgt_name);
+
+	/* Cancel all pending works before exiting */
+	spin_lock(&bgt->lock);
+	bgt->task = NULL;
+
+	bgt->enabled = 0;
+	while (!list_empty(&bgt->pending_works)) {
+		struct ubi_bgt_work *wrk;
+
+		wrk = list_entry(bgt->pending_works.next, struct ubi_bgt_work,
+				 list);
+		list_del(&wrk->list);
+		bgt->pending_works_count -= 1;
+		spin_unlock(&bgt->lock);
+		wrk->func(ubi, wrk, 1);
+		spin_lock(&bgt->lock);
+	}
+	spin_unlock(&bgt->lock);
+
+	complete_and_exit(&bgt->thread_stop, 0);
+}
+
+int ubi_bgt_init(struct ubi_info *ubi)
+{
+	int err;
+	pid_t pid;
+	struct ubi_bgt_info *bgt;
+
+	dbg_bgt("initialize the UBI background thread unit");
+
+	bgt = ubi_kzalloc(sizeof(struct ubi_bgt_info));
+	if (!bgt)
+		return -ENOMEM;
+	ubi->bgt = bgt;
+
+	init_completion(&bgt->thread_start);
+	init_completion(&bgt->thread_stop);
+	INIT_LIST_HEAD(&bgt->pending_works);
+	spin_lock_init(&bgt->lock);
+	mutex_init(&bgt->wrk_mutex);
+
+	bgt->bgt_name = ubi_kmalloc(sizeof(BGT_NAME_PATTERN) + 20);
+	if (!bgt->bgt_name) {
+		err = -ENOMEM;
+		goto out_bgt;
+	}
+	sprintf(bgt->bgt_name, BGT_NAME_PATTERN, ubi->ubi_num);
+
+	pid = kernel_thread(ubi_thread, ubi, CLONE_FS | CLONE_FILES);
+	if (pid < 0) {
+		err = pid;
+		ubi_err("cannot spawn \"%s\", error %d", bgt->bgt_name, err);
+		goto out_name;
+	}
+
+	wait_for_completion(&bgt->thread_start);
+	dbg_bgt("the UBI background thread unit is initialized");
+	return 0;
+
+out_name:
+	ubi_kfree(bgt->bgt_name);
+out_bgt:
+	ubi_kfree(bgt);
+	return err;
+}
+
+void ubi_bgt_close(struct ubi_info *ubi)
+{
+	struct ubi_bgt_info *bgt = ubi->bgt;
+
+	dbg_bgt("close the UBI background thread unit");
+
+	ubi_assert(!bgt->enabled);
+	ubi_assert(bgt->pending_works_count == 0);
+	ubi_assert(list_empty(&bgt->pending_works));
+
+	ubi_kfree(bgt->bgt_name);
+	ubi_kfree(bgt);
+}
