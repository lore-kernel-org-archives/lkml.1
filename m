Return-Path: <linux-kernel-owner+w=401wt.eu-S1758372AbYEPOwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758372AbYEPOwn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 10:52:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757281AbYEPOnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 10:43:16 -0400
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:49304 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755025AbYEPOm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 10:42:26 -0400
From: hooanon05@yahoo.co.jp
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Junjiro Okajima <hooanon05@yahoo.co.jp>
Subject: [PATCH 23/67] aufs workqueue for asynchronous/super-io/delegated operations, source
Date: Fri, 16 May 2008 23:32:37 +0900
Message-Id: <12109484012111-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <12109484013559-git-send-email-hooanon05@yahoo.co.jp>
References: <12109484013324-git-send-email-hooanon05@yahoo.co.jp> <12109484012532-git-send-email-hooanon05@yahoo.co.jp> <12109484012997-git-send-email-hooanon05@yahoo.co.jp> <12109484013051-git-send-email-hooanon05@yahoo.co.jp> <12109484013436-git-send-email-hooanon05@yahoo.co.jp> <1210948401415-git-send-email-hooanon05@yahoo.co.jp> <12109484011533-git-send-email-hooanon05@yahoo.co.jp> <1210948401506-git-send-email-hooanon05@yahoo.co.jp> <12109484013156-git-send-email-hooanon05@yahoo.co.jp> <12109484012724-git-send-email-hooanon05@yahoo.co.jp> <12109484013264-git-send-email-hooanon05@yahoo.co.jp> <12109484012658-git-send-email-hooanon05@yahoo.co.jp> <12109484011282-git-send-email-hooanon05@yahoo.co.jp> <12109484012543-git-send-email-hooanon05@yahoo.co.jp> <12109484013834-git-send-email-hooanon05@yahoo.co.jp> <12109484012213-git-send-email-hooanon05@yahoo.co.jp> <12109484012301-git-send-email-hooanon05@yahoo.co.jp> <1210948401175-git-send-email-hooanon05@yahoo.co.jp> <1210948!
 4013702-git-send-email-hooanon05@yahoo.co.jp> <12109484012871-git-send-email-hooanon05@yahoo.co.jp> <12109484013438-git-send-email-hooanon05@yahoo.co.jp> <12109484013559-git-send-email-hooanon05@yahoo.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Junjiro Okajima <hooanon05@yahoo.co.jp>

	initial commit
	aufs workqueue for asynchronous/super-io/delegated operations, source

Signed-off-by: Junjiro Okajima <hooanon05@yahoo.co.jp>
---
 fs/aufs/wkq.c |  321 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 321 insertions(+), 0 deletions(-)

diff --git a/fs/aufs/wkq.c b/fs/aufs/wkq.c
new file mode 100644
index 0000000..965d1e4
--- /dev/null
+++ b/fs/aufs/wkq.c
@@ -0,0 +1,321 @@
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
+ *
+ * $Id: wkq.c,v 1.4 2008/05/04 23:53:38 sfjro Exp $
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
+	//unsigned keep_capabilities:1;
+	//struct user_struct *user;
+	//struct fs_struct *fs;
+	//struct nsproxy *nsproxy;
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
+#if 0 // rfu
+		struct au_sbinfo *sbinfo;
+		sbinfo = au_sbi(wkinfo->mnt->mnt_sb);
+		if (atomic_dec_and_test(&sbinfo->si_wkq_nowait))
+			wake_up_all(&sbinfo->si_wkq_nowait_wq);
+#endif
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
+	//int queued;
+	//struct workqueue_struct *wkq;
+	DECLARE_COMPLETION_ONSTACK(comp);
+	struct au_wkinfo _wkinfo = {
+		//.sb	= sb,
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
+	//smp_mb(); /* atomic_set */
+
+#if 0 // test accouting
+	if (!err) {
+		static void f(void *args)
+		{
+			DbgSleep(1);
+		}
+		int i;
+		//au_debug_on();
+		LKTRTrace("f %p\n", f);
+		for (i = 0; i < 10; i++)
+			au_wkq_nowait(f, NULL, 0);
+		for (i = 0; i < aufs_nwkq; i++)
+			au_wkq_wait(f, NULL, 0);
+		DbgSleep(11);
+		//au_debug_off();
+	}
+#endif
+
+ out:
+	AuTraceErr(err);
+	return err;
+}
-- 
1.4.4.4

