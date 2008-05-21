Return-Path: <linux-kernel-owner+w=401wt.eu-S935847AbYEUDrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935847AbYEUDrn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 23:47:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934272AbYEUDeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 23:34:44 -0400
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:44143 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764143AbYEUDdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 23:33:08 -0400
From: hooanon05@yahoo.co.jp
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Junjiro Okajima <hooanon05@yahoo.co.jp>
Subject: [AUFS PATCH v2.6.26-rc2-mm1 11/39] aufs workqueue
Date: Wed, 21 May 2008 12:22:41 +0900
Message-Id: <1211340189-11813-12-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.5.5.1.308.g1fbb5.dirty
In-Reply-To: <1211340189-11813-1-git-send-email-hooanon05@yahoo.co.jp>
References: <1211340189-11813-1-git-send-email-hooanon05@yahoo.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Junjiro Okajima <hooanon05@yahoo.co.jp>

initial commit
workqueue for asynchronous, super-io or delegated operations.
they are used in various places such as,
- handling 'opaque' directory and whiteout
- lookup and copy-up/down with credential
- create/remove files and file i/o by delegation
- internal xino file i/o

Signed-off-by: Junjiro Okajima <hooanon05@yahoo.co.jp>
---
 fs/aufs/wkq.c |  294 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/aufs/wkq.h |  158 +++++++++++++++++++++++++++++++
 2 files changed, 452 insertions(+), 0 deletions(-)
 create mode 100644 fs/aufs/wkq.c
 create mode 100644 fs/aufs/wkq.h

diff --git a/fs/aufs/wkq.c b/fs/aufs/wkq.c
new file mode 100644
index 0000000..4c7d1d3
--- /dev/null
+++ b/fs/aufs/wkq.c
@@ -0,0 +1,294 @@
+/*
+ * Copyright (C) 2005-2008 Junjiro Okajima
+ *
+ * This program, aufs is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+/*
+ * workqueue for asynchronous/super-io/delegated operations
+ */
+
+#include <linux/module.h>
+#include "aufs.h"
+
+struct au_wkq *au_wkq;
+
+struct au_cred {
+#ifdef CONFIG_AUFS_DLGT
+	int umask;
+	uid_t fsuid;
+	gid_t fsgid;
+	kernel_cap_t cap_effective, cap_inheritable, cap_permitted;
+#if 0 /* reserved for future use */
+	unsigned keep_capabilities:1;
+	struct user_struct *user;
+	struct fs_struct *fs;
+	struct nsproxy *nsproxy;
+#endif
+#endif
+};
+
+struct au_wkinfo {
+	struct work_struct wk;
+	struct vfsmount *mnt;
+
+	unsigned int flags;
+	struct au_cred cred;
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
+#ifdef CONFIG_AUFS_DLGT
+static void cred_store(struct au_cred *cred)
+{
+	cred->umask = current->fs->umask;
+	cred->fsuid = current->fsuid;
+	cred->fsgid = current->fsgid;
+	cred->cap_effective = current->cap_effective;
+	cred->cap_inheritable = current->cap_inheritable;
+	cred->cap_permitted = current->cap_permitted;
+}
+
+static void cred_revert(struct au_cred *cred)
+{
+	AuDebugOn(!au_test_wkq(current));
+	current->fs->umask = cred->umask;
+	current->fsuid = cred->fsuid;
+	current->fsgid = cred->fsgid;
+	current->cap_effective = cred->cap_effective;
+	current->cap_inheritable = cred->cap_inheritable;
+	current->cap_permitted = cred->cap_permitted;
+}
+
+static void cred_switch(struct au_cred *old, struct au_cred *new)
+{
+	cred_store(old);
+	cred_revert(new);
+}
+
+static void dlgt_cred_store(unsigned int flags, struct au_wkinfo *wkinfo)
+{
+	if (unlikely(au_ftest_wkq(flags, DLGT)))
+		cred_store(&wkinfo->cred);
+}
+
+static void dlgt_func(struct au_wkinfo *wkinfo)
+{
+	if (!au_ftest_wkq(wkinfo->flags, DLGT))
+		wkinfo->func(wkinfo->args);
+	else {
+		struct au_cred cred;
+		cred_switch(&cred, &wkinfo->cred);
+		wkinfo->func(wkinfo->args);
+		cred_revert(&cred);
+	}
+}
+#else
+static void dlgt_cred_store(unsigned int flags, struct au_wkinfo *wkinfo)
+{
+	/* empty */
+}
+
+static void dlgt_func(struct au_wkinfo *wkinfo)
+{
+	wkinfo->func(wkinfo->args);
+}
+#endif /* CONFIG_AUFS_DLGT */
+
+/* ---------------------------------------------------------------------- */
+
+static void update_busy(struct au_wkq *wkq, struct au_wkinfo *wkinfo)
+{
+#ifdef CONFIG_AUFS_STAT
+	unsigned int new, old;
+
+	do {
+		new = atomic_read(wkinfo->busyp);
+		old = wkq->max_busy;
+		if (new <= old)
+			break;
+	} while (cmpxchg(&wkq->max_busy, old, new) == old);
+#endif
+}
+
+static int enqueue(struct au_wkq *wkq, struct au_wkinfo *wkinfo)
+{
+	AuTraceEnter();
+	wkinfo->busyp = &wkq->busy;
+	update_busy(wkq, wkinfo);
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
+	AuTraceEnter();
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
+				atomic_dec_return(&au_wkq[i].busy);
+			}
+		} else
+			idle_idx = aufs_nwkq;
+
+		atomic_inc_return(&au_wkq[idle_idx].busy);
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
+	LKTRTrace("wkinfo{0x%x, %p, %p, %p}\n",
+		  wkinfo->flags, wkinfo->func, wkinfo->busyp, wkinfo->comp);
+
+	dlgt_func(wkinfo);
+	atomic_dec_return(wkinfo->busyp);
+	if (au_ftest_wkq(wkinfo->flags, WAIT))
+		complete(wkinfo->comp);
+	else {
+		mntput(wkinfo->mnt);
+		module_put(THIS_MODULE);
+		kfree(wkinfo);
+	}
+}
+
+int au_wkq_run(au_wkq_func_t func, void *args, struct super_block *sb,
+	       unsigned int flags)
+{
+	int err;
+	DECLARE_COMPLETION_ONSTACK(comp);
+	struct au_wkinfo _wkinfo = {
+		.flags	= flags,
+		.func	= func,
+		.args	= args,
+		.comp	= &comp
+	}, *wkinfo = &_wkinfo;
+
+	LKTRTrace("0x%x\n", flags);
+	AuDebugOn(au_test_wkq(current));
+
+	err = 0;
+	if (unlikely(!au_ftest_wkq(flags, WAIT))) {
+		AuDebugOn(!sb);
+		/*
+		 * wkq_func() must free this wkinfo.
+		 * it highly depends upon the implementation of workqueue.
+		 */
+		err = -ENOMEM;
+		wkinfo = kmalloc(sizeof(*wkinfo), GFP_TEMPORARY);
+		if (unlikely(!wkinfo))
+			goto out;
+		err = 0;
+		/* prohibit umount */
+		wkinfo->mnt = au_mntcache_get(sb);
+		wkinfo->flags = flags;
+		wkinfo->func = func;
+		wkinfo->args = args;
+		wkinfo->comp = NULL;
+		__module_get(THIS_MODULE);
+	}
+
+	INIT_WORK(&wkinfo->wk, wkq_func);
+	dlgt_cred_store(flags, wkinfo);
+	do_wkq(wkinfo);
+	if (au_ftest_wkq(flags, WAIT))
+		/* no timeout, no interrupt */
+		wait_for_completion(wkinfo->comp);
+ out:
+	AuTraceErr(err);
+	return err;
+}
+
+/* ---------------------------------------------------------------------- */
+
+void au_wkq_fin(void)
+{
+	int i;
+
+	AuTraceEnter();
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
+	LKTRTrace("%d\n", aufs_nwkq);
+
+	/* '+1' is for accounting  of nowait queue */
+	err = -ENOMEM;
+	au_wkq = kcalloc(aufs_nwkq + 1, sizeof(*au_wkq), GFP_KERNEL);
+	if (unlikely(!au_wkq))
+		goto out;
+
+	err = 0;
+	for (i = 0; i < aufs_nwkq; i++) {
+		au_wkq[i].q = create_singlethread_workqueue(AUFS_WKQ_NAME);
+		if (au_wkq[i].q && !IS_ERR(au_wkq[i].q)) {
+			atomic_set(&au_wkq[i].busy, 0);
+			au_wkq[i].max_busy = 0;
+			continue;
+		}
+
+		err = PTR_ERR(au_wkq[i].q);
+		au_wkq_fin();
+		break;
+	}
+
+	/* nowait accounting */
+	nowaitq = au_wkq + aufs_nwkq;
+	atomic_set(&nowaitq->busy, 0);
+	nowaitq->max_busy = 0;
+	nowaitq->q = NULL;
+	/* smp_mb(); */ /* atomic_set */
+
+ out:
+	AuTraceErr(err);
+	return err;
+}
diff --git a/fs/aufs/wkq.h b/fs/aufs/wkq.h
new file mode 100644
index 0000000..2b9690a
--- /dev/null
+++ b/fs/aufs/wkq.h
@@ -0,0 +1,158 @@
+/*
+ * Copyright (C) 2005-2008 Junjiro Okajima
+ *
+ * This program, aufs is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+/*
+ * workqueue for asynchronous/super-io/delegated operations
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
+/* internal workqueue named AUFS_WKQ_NAME */
+struct au_wkq {
+	struct workqueue_struct	*q;
+
+	/* accounting */
+	atomic_t		busy;
+	unsigned int		max_busy; /* todo: STAT only */
+};
+
+/*
+ * in the next operation, wait for the 'nowait' tasks in system-wide workqueue
+ */
+struct au_nowait_tasks {
+#ifdef CONFIG_AUFS_HINOTIFY
+	/*
+	 * currently, the 'nowait' task which should be waited in the next
+	 * operation is only hinotify.
+	 */
+	atomic_t		nw_len;
+	wait_queue_head_t	nw_wq;
+#endif
+};
+
+/* ---------------------------------------------------------------------- */
+
+extern struct au_wkq *au_wkq;
+typedef void (*au_wkq_func_t)(void *args);
+
+/* wkq flags */
+#define AuWkq_WAIT	1
+#define AuWkq_DLGT	(1 << 1)
+#define au_ftest_wkq(flags, name)	((flags) & AuWkq_##name)
+#define au_fset_wkq(flags, name)	{ (flags) |= AuWkq_##name; }
+#define au_fclr_wkq(flags, name)	{ (flags) &= ~AuWkq_##name; }
+#ifndef CONFIG_AUFS_DLGT
+#undef AuWkq_DLGT
+#define AuWkq_DLGT	0
+#endif
+
+int au_wkq_run(au_wkq_func_t func, void *args, struct super_block *sb,
+	       unsigned int flags);
+int __init au_wkq_init(void);
+void au_wkq_fin(void);
+
+/* ---------------------------------------------------------------------- */
+
+static inline int au_test_wkq(struct task_struct *tsk)
+{
+	return (!tsk->mm && !strcmp(tsk->comm, AUFS_WKQ_NAME));
+#if 0 /* reserved for future use, per-cpu workqueue */
+	return (!tsk->mm
+		&& !memcmp(tsk->comm, AUFS_WKQ_NAME "/",
+			   sizeof(AUFS_WKQ_NAME)));
+#endif
+}
+
+static inline int au_wkq_wait(au_wkq_func_t func, void *args, int dlgt)
+{
+	unsigned int flags = AuWkq_WAIT;
+	if (unlikely(dlgt))
+		au_fset_wkq(flags, DLGT);
+	return au_wkq_run(func, args, /*sb*/NULL, flags);
+}
+
+static inline int au_wkq_nowait(au_wkq_func_t func, void *args,
+				struct super_block *sb, int dlgt)
+{
+	unsigned int flags = !AuWkq_WAIT;
+	if (unlikely(dlgt))
+		au_fset_wkq(flags, DLGT);
+	return au_wkq_run(func, args, sb, flags);
+}
+
+#ifdef CONFIG_AUFS_HINOTIFY
+/* todo: memory barrier? */
+static inline void au_nwt_init(struct au_nowait_tasks *nwt)
+{
+	atomic_set(&nwt->nw_len, 0);
+	smp_mb(); /* atomic_set */
+	init_waitqueue_head(&nwt->nw_wq);
+}
+
+static inline int au_nwt_inc(struct au_nowait_tasks *nwt)
+{
+	return atomic_inc_return(&nwt->nw_len);
+}
+
+static inline int au_nwt_dec(struct au_nowait_tasks *nwt)
+{
+	int ret = atomic_dec_return(&nwt->nw_len);
+	if (!ret)
+		wake_up_all(&nwt->nw_wq);
+	return ret;
+}
+
+static inline int au_nwt_flush(struct au_nowait_tasks *nwt)
+{
+	wait_event(nwt->nw_wq, !atomic_read(&nwt->nw_len));
+	return 0;
+}
+#else
+static inline void au_nwt_init(struct au_nowait_tasks *nwt)
+{
+	/* nothing */
+}
+
+static inline int au_nwt_inc(struct au_nowait_tasks *nwt)
+{
+	return 0;
+}
+
+static inline int au_nwt_dec(struct au_nowait_tasks *nwt)
+{
+	return 0;
+}
+
+static inline int au_nwt_flush(struct au_nowait_tasks *nwt)
+{
+	return 0;
+}
+#endif /* CONFIG_AUFS_HINOTIFY */
+
+#endif /* __KERNEL__ */
+#endif /* __AUFS_WKQ_H__ */
-- 
1.5.5.1.308.g1fbb5.dirty

