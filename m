Return-Path: <linux-kernel-owner+w=401wt.eu-S965369AbXBQROb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965369AbXBQROb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 12:14:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965379AbXBQROa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 12:14:30 -0500
Received: from smtp.nokia.com ([131.228.20.172]:59586 "EHLO
	mgw-ext13.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965369AbXBQRO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 12:14:29 -0500
From: Artem Bityutskiy <dedekind@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>
Date: Sat, 17 Feb 2007 18:56:10 +0200
Message-Id: <20070217165610.5845.87954.sendpatchset@localhost.localdomain>
In-Reply-To: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
Subject: [PATCH 21/44 take 2] [UBI] background thread unit header
X-OriginalArrivalTime: 17 Feb 2007 16:56:09.0873 (UTC) FILETIME=[85FA9010:01C752B4]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070217185329-03D70BB0-04C98252/0-0/0-0
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -auNrp tmp-from/drivers/mtd/ubi/background.h tmp-to/drivers/mtd/ubi/background.h
--- tmp-from/drivers/mtd/ubi/background.h	1970-01-01 02:00:00.000000000 +0200
+++ tmp-to/drivers/mtd/ubi/background.h	2007-02-17 18:07:27.000000000 +0200
@@ -0,0 +1,177 @@
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
+/*
+ * UBI background thread unit.
+ *
+ * This unit maintains a per-UBI device thread which is supposed to do
+ * different background works. It is mostly used by the WL unit to perform
+ * eraseblock erasure and movement, but may also be used for other works.
+ */
+
+#ifndef __UBI_BACKGROUND_H__
+#define __UBI_BACKGROUND_H__
+
+#include <linux/sched.h>
+#include <linux/spinlock.h>
+#include <linux/mutex.h>
+#include <linux/completion.h>
+
+struct ubi_info;
+struct ubi_bgt_work;
+
+/**
+ * ubi_bgt_schedule - schedule a work.
+ *
+ * @ubi: the UBI device description object
+ * @wrk: the work to schedule
+ *
+ * This function enqueues a work defined by @wrk to the tail of the pending
+ * works list. Returns zero in case of success and %-ENODEV if the background
+ * thread was killed.
+ */
+int ubi_bgt_schedule(const struct ubi_info *ubi, struct ubi_bgt_work *wrk);
+
+/**
+ * ubi_bgt_reschedule - re-schedule a work.
+ *
+ * @ubi: the UBI device description object
+ * @wrk: the work to re-schedule.
+ *
+ * This function enqueues a work defined by @wrk to the tail of the pending
+ * works list. Returns zero in case of success and %-ENODEV if the background
+ * thread was killed.
+ */
+int ubi_bgt_reschedule(const struct ubi_info *ubi, struct ubi_bgt_work *wrk);
+
+/**
+ * ubi_bgt_do_work - do one pending work.
+ *
+ * @ubi: the UBI device description object
+ *
+ * This function returns zero in case of success and a negative error code in
+ * case of failure.
+ */
+int ubi_bgt_do_work(const struct ubi_info *ubi);
+
+/**
+ * ubi_bgt_enable - enable the background thread.
+ *
+ * @ubi: the UBI device description object
+ *
+ * This function enables the background thread for UBI device defined by @ubi.
+ * Returns zero in case of success and %-ENODEV if the background thread was
+ * killed.
+ */
+int ubi_bgt_enable(const struct ubi_info *ubi);
+
+/**
+ * ubi_bgt_disable - disable the background thread.
+ *
+ * @ubi: the UBI device description object
+ */
+void ubi_bgt_disable(const struct ubi_info *ubi);
+
+/**
+ * ubi_bgt_kill_thread - kill the background thread.
+ *
+ * @ubi: the UBI device description object
+ *
+ * This function kills the background thread for UBI device defined by @ubi.
+ * This function also makes sure all the pending tasks are done.
+ */
+void ubi_bgt_kill_thread(const struct ubi_info *ubi);
+
+/**
+ * ubi_bgt_init - initialize the background thread unit for an UBI device.
+ *
+ * @ubi: the UBI device description object
+ *
+ * This function returns zero in case of success and a negative error code in
+ * case of failure.
+ */
+int ubi_bgt_init(struct ubi_info *ubi);
+
+/**
+ * ubi_bgt_close - close the background thread unit for an UBI device.
+ *
+ * @ubi: the UBI device description object
+ */
+void ubi_bgt_close(struct ubi_info *ubi);
+
+/**
+ * ubi_bgt_worker_t - background worker function prototype.
+ *
+ * @ubi: the UBI device description object
+ * @wrk: the work object pointer
+ * @cancel: non-zero if the work has to be canceled
+ *
+ * The @cancel argument is not zero when the background thread is being killed
+ * and just wants the worker to free  everything associated with this work
+ * (@wrk).
+ */
+typedef int ubi_bgt_worker_t(const struct ubi_info *ubi,
+			     struct ubi_bgt_work *wrk, int cancel);
+
+/**
+ * struct ubi_bgt_work - a background work.
+ *
+ * @list: a link in the list of pending works
+ * @func: the worker function
+ * @priv: private data of the worker function
+ *
+ * To schedule a background work users have to construct a
+ * &struct ubi_bgt_work object, initialize the @func and @priv fields and call
+ * 'ubi_bgt_schedule()'.
+ */
+struct ubi_bgt_work {
+	struct list_head list;
+	ubi_bgt_worker_t *func;
+	void *priv;
+};
+
+/**
+ * struct ubi_bgt_work - UBI background thread unit description data structure.
+ *
+ * @pending_works: the list of pending works
+ * @active_work: the work which is currently running
+ * @pending_works_count: count of pending works
+ * @lock: protects the @pending_works, @active_work, @enabled, and @task fields
+ * @enabled: if the background thread is enabled
+ * @task: a pointer to the &struct task_struct of the background thread
+ * @bgt_name: the background thread name
+ * @thread_start: used to synchronize with starting of the background thread
+ * @thread_stop: used to synchronize with killing of the background thread
+ * @wrk_mutex: serializes execution if background works
+ */
+struct ubi_bgt_info {
+	struct list_head pending_works;   /* private */
+	struct ubi_bgt_work *active_work; /* private */
+	int pending_works_count;          /* public  */
+	spinlock_t lock;                  /* private */
+	int enabled;                      /* public  */
+	struct task_struct *task;         /* private */
+	char *bgt_name;                   /* public  */
+	struct completion thread_start;   /* private */
+	struct completion thread_stop;    /* private */
+	struct mutex wrk_mutex;           /* private */
+};
+
+#endif /* !__UBI_BACKGROUND_H__ */
