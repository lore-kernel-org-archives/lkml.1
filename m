Return-Path: <linux-kernel-owner+w=401wt.eu-S938238AbZDJHT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938238AbZDJHT6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 03:19:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938019AbZDJHRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 03:17:15 -0400
Received: from mfbichi12.ns.itscom.net ([219.110.2.190]:35963 "EHLO
	mfbichi12.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936608AbZDJHRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 03:17:11 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
To: linux-kernel@vger.kernel.org
Cc: greg@kroah.com, linux-fsdevel@vger.kernel.org,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: [RFC Aufs2 #5 08/29] aufs workqueue
Date: Fri, 10 Apr 2009 16:02:22 +0900
Message-Id: <1239346963-30953-9-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.6.1.284.g5dc13
In-Reply-To: <1239346963-30953-1-git-send-email-hooanon05@yahoo.co.jp>
References: <1239346963-30953-1-git-send-email-hooanon05@yahoo.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

initial commit
workqueue for asynchronous and super-io operations.
they are used for:
- handling 'opaque' directory and whiteout
- lookup and copy-up/down with credential
- internal xino file i/o

Signed-off-by: J. R. Okajima <hooanon05@yahoo.co.jp>
---
 fs/aufs/wkq.c |  249 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/aufs/wkq.h |   72 +++++++++++++++++
 2 files changed, 321 insertions(+), 0 deletions(-)
 create mode 100644 fs/aufs/wkq.c
 create mode 100644 fs/aufs/wkq.h

diff --git a/fs/aufs/wkq.c b/fs/aufs/wkq.c
new file mode 100644
index 0000000..41e30be
--- /dev/null
+++ b/fs/aufs/wkq.c
@@ -0,0 +1,249 @@
+/*
+ * Copyright (C) 2005-2009 Junjiro R. Okajima
+ *
+ * This program, aufs is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/*
+ * workqueue for asynchronous/super-io operations
+ * todo: try new dredential scheme
+ */
+
+#include "aufs.h"
+
+/* internal workqueue named AUFS_WKQ_NAME */
+static struct au_wkq {
+	struct workqueue_struct	*q;
+
+	/* balancing */
+	atomic_t		busy;
+} *au_wkq;
+
+struct au_wkinfo {
+	struct work_struct wk;
+	struct super_block *sb;
+
+	unsigned int flags; /* see wkq.h */
+
+	au_wkq_func_t func;
+	void *args;
+
+	atomic_t *busyp;
+	struct completion *comp;
+};
+
+/* ---------------------------------------------------------------------- */
+
+static int enqueue(struct au_wkq *wkq, struct au_wkinfo *wkinfo)
+{
+	wkinfo->busyp = &wkq->busy;
+	if (au_ftest_wkq(wkinfo->flags, WAIT))
+		return !queue_work(wkq->q, &wkinfo->wk);
+	else
+		return !schedule_work(&wkinfo->wk);
+}
+
+static void do_wkq(struct au_wkinfo *wkinfo)
+{
+	unsigned int idle, n;
+	int i, idle_idx;
+
+	while (1) {
+		if (au_ftest_wkq(wkinfo->flags, WAIT)) {
+			idle_idx = 0;
+			idle = UINT_MAX;
+			for (i = 0; i < aufs_nwkq; i++) {
+				n = atomic_inc_return(&au_wkq[i].busy);
+				if (n == 1 && !enqueue(au_wkq + i, wkinfo))
+					return; /* success */
+
+				if (n < idle) {
+					idle_idx = i;
+					idle = n;
+				}
+				atomic_dec(&au_wkq[i].busy);
+			}
+		} else
+			idle_idx = aufs_nwkq;
+
+		atomic_inc(&au_wkq[idle_idx].busy);
+		if (!enqueue(au_wkq + idle_idx, wkinfo))
+			return; /* success */
+
+		/* impossible? */
+		AuWarn1("failed to queue_work()\n");
+		yield();
+	}
+}
+
+static void wkq_func(struct work_struct *wk)
+{
+	struct au_wkinfo *wkinfo = container_of(wk, struct au_wkinfo, wk);
+
+	wkinfo->func(wkinfo->args);
+	atomic_dec(wkinfo->busyp);
+	if (au_ftest_wkq(wkinfo->flags, WAIT))
+		complete(wkinfo->comp);
+	else {
+		kobject_put(&au_sbi(wkinfo->sb)->si_kobj);
+		module_put(THIS_MODULE);
+		kfree(wkinfo);
+	}
+}
+
+/*
+ * Since struct completion is large, try allocating it dynamically.
+ */
+#if defined(CONFIG_4KSTACKS) || defined(AuTest4KSTACKS)
+#define AuWkqCompDeclare(name)	struct completion *comp = NULL
+
+static int au_wkq_comp_alloc(struct au_wkinfo *wkinfo, struct completion **comp)
+{
+	*comp = kmalloc(sizeof(**comp), GFP_NOFS);
+	if (*comp) {
+		init_completion(*comp);
+		wkinfo->comp = *comp;
+		return 0;
+	}
+	return -ENOMEM;
+}
+
+static void au_wkq_comp_free(struct completion *comp)
+{
+	kfree(comp);
+}
+
+#else
+
+/* no braces */
+#define AuWkqCompDeclare(name) \
+	DECLARE_COMPLETION_ONSTACK(_ ## name); \
+	struct completion *comp = &_ ## name
+
+static int au_wkq_comp_alloc(struct au_wkinfo *wkinfo, struct completion **comp)
+{
+	wkinfo->comp = *comp;
+	return 0;
+}
+
+static void au_wkq_comp_free(struct completion *comp __maybe_unused)
+{
+	/* empty */
+}
+#endif /* 4KSTACKS */
+
+static void au_wkq_run(struct au_wkinfo *wkinfo)
+{
+	au_dbg_verify_kthread();
+	INIT_WORK(&wkinfo->wk, wkq_func);
+	do_wkq(wkinfo);
+}
+
+int au_wkq_wait(au_wkq_func_t func, void *args)
+{
+	int err;
+	AuWkqCompDeclare(comp);
+	struct au_wkinfo wkinfo = {
+		.flags	= AuWkq_WAIT,
+		.func	= func,
+		.args	= args
+	};
+
+	err = au_wkq_comp_alloc(&wkinfo, &comp);
+	if (!err) {
+		au_wkq_run(&wkinfo);
+		/* no timeout, no interrupt */
+		wait_for_completion(wkinfo.comp);
+		au_wkq_comp_free(comp);
+	}
+
+	return err;
+
+}
+
+int au_wkq_nowait(au_wkq_func_t func, void *args, struct super_block *sb)
+{
+	int err;
+	struct au_wkinfo *wkinfo;
+
+	atomic_inc(&au_sbi(sb)->si_nowait.nw_len);
+
+	/*
+	 * wkq_func() must free this wkinfo.
+	 * it highly depends upon the implementation of workqueue.
+	 */
+	err = 0;
+	wkinfo = kmalloc(sizeof(*wkinfo), GFP_NOFS);
+	if (wkinfo) {
+		wkinfo->sb = sb;
+		wkinfo->flags = !AuWkq_WAIT;
+		wkinfo->func = func;
+		wkinfo->args = args;
+		wkinfo->comp = NULL;
+		kobject_get(&au_sbi(sb)->si_kobj);
+		__module_get(THIS_MODULE);
+
+		au_wkq_run(wkinfo);
+	} else {
+		err = -ENOMEM;
+		atomic_dec(&au_sbi(sb)->si_nowait.nw_len);
+	}
+
+	return err;
+}
+
+/* ---------------------------------------------------------------------- */
+
+void au_nwt_init(struct au_nowait_tasks *nwt)
+{
+	atomic_set(&nwt->nw_len, 0);
+	/* smp_mb();*/ /* atomic_set */
+	init_waitqueue_head(&nwt->nw_wq);
+}
+
+void au_wkq_fin(void)
+{
+	int i;
+
+	for (i = 0; i < aufs_nwkq; i++)
+		if (au_wkq[i].q && !IS_ERR(au_wkq[i].q))
+			destroy_workqueue(au_wkq[i].q);
+	kfree(au_wkq);
+}
+
+int __init au_wkq_init(void)
+{
+	int err, i;
+	struct au_wkq *nowaitq;
+
+	/* '+1' is for accounting of nowait queue */
+	err = -ENOMEM;
+	au_wkq = kcalloc(aufs_nwkq + 1, sizeof(*au_wkq), GFP_NOFS);
+	if (unlikely(!au_wkq))
+		goto out;
+
+	err = 0;
+	for (i = 0; i < aufs_nwkq; i++) {
+		au_wkq[i].q = create_singlethread_workqueue(AUFS_WKQ_NAME);
+		if (au_wkq[i].q && !IS_ERR(au_wkq[i].q)) {
+			atomic_set(&au_wkq[i].busy, 0);
+			continue;
+		}
+
+		err = PTR_ERR(au_wkq[i].q);
+		au_wkq_fin();
+		goto out;
+	}
+
+	/* nowait accounting */
+	nowaitq = au_wkq + aufs_nwkq;
+	atomic_set(&nowaitq->busy, 0);
+	nowaitq->q = NULL;
+	/* smp_mb(); */ /* atomic_set */
+
+ out:
+	return err;
+}
diff --git a/fs/aufs/wkq.h b/fs/aufs/wkq.h
new file mode 100644
index 0000000..17d24d8
--- /dev/null
+++ b/fs/aufs/wkq.h
@@ -0,0 +1,72 @@
+/*
+ * Copyright (C) 2005-2009 Junjiro R. Okajima
+ *
+ * This program, aufs is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/*
+ * workqueue for asynchronous/super-io operations
+ * todo: try new credentials management scheme
+ */
+
+#ifndef __AUFS_WKQ_H__
+#define __AUFS_WKQ_H__
+
+#ifdef __KERNEL__
+
+#include <linux/fs.h>
+#include <linux/sched.h>
+#include <linux/workqueue.h>
+#include <linux/aufs_type.h>
+
+/* ---------------------------------------------------------------------- */
+
+/*
+ * in the next operation, wait for the 'nowait' tasks in system-wide workqueue
+ */
+struct au_nowait_tasks {
+	atomic_t		nw_len;
+	wait_queue_head_t	nw_wq;
+};
+
+/* ---------------------------------------------------------------------- */
+
+typedef void (*au_wkq_func_t)(void *args);
+
+/* wkq flags */
+#define AuWkq_WAIT	1
+#define au_ftest_wkq(flags, name)	((flags) & AuWkq_##name)
+#define au_fset_wkq(flags, name)	{ (flags) |= AuWkq_##name; }
+#define au_fclr_wkq(flags, name)	{ (flags) &= ~AuWkq_##name; }
+
+/* wkq.c */
+int au_wkq_wait(au_wkq_func_t func, void *args);
+int au_wkq_nowait(au_wkq_func_t func, void *args, struct super_block *sb);
+void au_nwt_init(struct au_nowait_tasks *nwt);
+int __init au_wkq_init(void);
+void au_wkq_fin(void);
+
+/* ---------------------------------------------------------------------- */
+
+static inline int au_test_wkq(struct task_struct *tsk)
+{
+	return !tsk->mm && !strcmp(tsk->comm, AUFS_WKQ_NAME);
+}
+
+static inline void au_nwt_done(struct au_nowait_tasks *nwt)
+{
+	if (!atomic_dec_return(&nwt->nw_len))
+		wake_up_all(&nwt->nw_wq);
+}
+
+static inline int au_nwt_flush(struct au_nowait_tasks *nwt)
+{
+	wait_event(nwt->nw_wq, !atomic_read(&nwt->nw_len));
+	return 0;
+}
+
+#endif /* __KERNEL__ */
+#endif /* __AUFS_WKQ_H__ */
-- 
1.6.1.284.g5dc13

