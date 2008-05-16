Return-Path: <linux-kernel-owner+w=401wt.eu-S1759525AbYEPOqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759525AbYEPOqp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 10:46:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757215AbYEPOm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 10:42:26 -0400
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:49249 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbYEPOmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 10:42:14 -0400
From: hooanon05@yahoo.co.jp
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Junjiro Okajima <hooanon05@yahoo.co.jp>
Subject: [PATCH 22/67] aufs workqueue for asynchronous/super-io/delegated operations, header
Date: Fri, 16 May 2008 23:32:36 +0900
Message-Id: <12109484013559-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <12109484013438-git-send-email-hooanon05@yahoo.co.jp>
References: <12109484013324-git-send-email-hooanon05@yahoo.co.jp> <12109484012532-git-send-email-hooanon05@yahoo.co.jp> <12109484012997-git-send-email-hooanon05@yahoo.co.jp> <12109484013051-git-send-email-hooanon05@yahoo.co.jp> <12109484013436-git-send-email-hooanon05@yahoo.co.jp> <1210948401415-git-send-email-hooanon05@yahoo.co.jp> <12109484011533-git-send-email-hooanon05@yahoo.co.jp> <1210948401506-git-send-email-hooanon05@yahoo.co.jp> <12109484013156-git-send-email-hooanon05@yahoo.co.jp> <12109484012724-git-send-email-hooanon05@yahoo.co.jp> <12109484013264-git-send-email-hooanon05@yahoo.co.jp> <12109484012658-git-send-email-hooanon05@yahoo.co.jp> <12109484011282-git-send-email-hooanon05@yahoo.co.jp> <12109484012543-git-send-email-hooanon05@yahoo.co.jp> <12109484013834-git-send-email-hooanon05@yahoo.co.jp> <12109484012213-git-send-email-hooanon05@yahoo.co.jp> <12109484012301-git-send-email-hooanon05@yahoo.co.jp> <1210948401175-git-send-email-hooanon05@yahoo.co.jp> <1210948!
 4013702-git-send-email-hooanon05@yahoo.co.jp> <12109484012871-git-send-email-hooanon05@yahoo.co.jp> <12109484013438-git-send-email-hooanon05@yahoo.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Junjiro Okajima <hooanon05@yahoo.co.jp>

	initial commit
	aufs workqueue for asynchronous/super-io/delegated operations, header

Signed-off-by: Junjiro Okajima <hooanon05@yahoo.co.jp>
---
 fs/aufs/wkq.h |  160 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 160 insertions(+), 0 deletions(-)

diff --git a/fs/aufs/wkq.h b/fs/aufs/wkq.h
new file mode 100644
index 0000000..b9e2edd
--- /dev/null
+++ b/fs/aufs/wkq.h
@@ -0,0 +1,160 @@
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
+ * $Id: wkq.h,v 1.3 2008/04/28 03:18:21 sfjro Exp $
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
+	unsigned int		max_busy; // todo: STAT only
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
+#if 0 // per-cpu workqueue
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
+//todo: memory barrier?
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
1.4.4.4

