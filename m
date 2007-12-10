Return-Path: <linux-kernel-owner+w=401wt.eu-S1755499AbXLJCsH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499AbXLJCsH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 21:48:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754849AbXLJCnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 21:43:22 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:49786 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754718AbXLJCnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 21:43:14 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: hch@infradead.org, viro@ftp.linux.org.uk, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 28/42] Unionfs: async I/O queue operations
Date: Sun,  9 Dec 2007 21:42:01 -0500
Message-Id: <119725455240-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11972545353262-git-send-email-ezk@cs.sunysb.edu>
References: <11972545353262-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/sioq.c |  119 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 119 insertions(+), 0 deletions(-)
 create mode 100644 fs/unionfs/sioq.c

diff --git a/fs/unionfs/sioq.c b/fs/unionfs/sioq.c
new file mode 100644
index 0000000..2a8c88e
--- /dev/null
+++ b/fs/unionfs/sioq.c
@@ -0,0 +1,119 @@
+/*
+ * Copyright (c) 2006-2007 Erez Zadok
+ * Copyright (c) 2006      Charles P. Wright
+ * Copyright (c) 2006-2007 Josef 'Jeff' Sipek
+ * Copyright (c) 2006      Junjiro Okajima
+ * Copyright (c) 2006      David P. Quigley
+ * Copyright (c) 2006-2007 Stony Brook University
+ * Copyright (c) 2006-2007 The Research Foundation of SUNY
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include "union.h"
+
+/*
+ * Super-user IO work Queue - sometimes we need to perform actions which
+ * would fail due to the unix permissions on the parent directory (e.g.,
+ * rmdir a directory which appears empty, but in reality contains
+ * whiteouts).
+ */
+
+static struct workqueue_struct *superio_workqueue;
+
+int __init init_sioq(void)
+{
+	int err;
+
+	superio_workqueue = create_workqueue("unionfs_siod");
+	if (!IS_ERR(superio_workqueue))
+		return 0;
+
+	err = PTR_ERR(superio_workqueue);
+	printk(KERN_ERR "unionfs: create_workqueue failed %d\n", err);
+	superio_workqueue = NULL;
+	return err;
+}
+
+void stop_sioq(void)
+{
+	if (superio_workqueue)
+		destroy_workqueue(superio_workqueue);
+}
+
+void run_sioq(work_func_t func, struct sioq_args *args)
+{
+	INIT_WORK(&args->work, func);
+
+	init_completion(&args->comp);
+	while (!queue_work(superio_workqueue, &args->work)) {
+		/* TODO: do accounting if needed */
+		schedule();
+	}
+	wait_for_completion(&args->comp);
+}
+
+void __unionfs_create(struct work_struct *work)
+{
+	struct sioq_args *args = container_of(work, struct sioq_args, work);
+	struct create_args *c = &args->create;
+
+	args->err = vfs_create(c->parent, c->dentry, c->mode, c->nd);
+	complete(&args->comp);
+}
+
+void __unionfs_mkdir(struct work_struct *work)
+{
+	struct sioq_args *args = container_of(work, struct sioq_args, work);
+	struct mkdir_args *m = &args->mkdir;
+
+	args->err = vfs_mkdir(m->parent, m->dentry, m->mode);
+	complete(&args->comp);
+}
+
+void __unionfs_mknod(struct work_struct *work)
+{
+	struct sioq_args *args = container_of(work, struct sioq_args, work);
+	struct mknod_args *m = &args->mknod;
+
+	args->err = vfs_mknod(m->parent, m->dentry, m->mode, m->dev);
+	complete(&args->comp);
+}
+
+void __unionfs_symlink(struct work_struct *work)
+{
+	struct sioq_args *args = container_of(work, struct sioq_args, work);
+	struct symlink_args *s = &args->symlink;
+
+	args->err = vfs_symlink(s->parent, s->dentry, s->symbuf, s->mode);
+	complete(&args->comp);
+}
+
+void __unionfs_unlink(struct work_struct *work)
+{
+	struct sioq_args *args = container_of(work, struct sioq_args, work);
+	struct unlink_args *u = &args->unlink;
+
+	args->err = vfs_unlink(u->parent, u->dentry);
+	complete(&args->comp);
+}
+
+void __delete_whiteouts(struct work_struct *work)
+{
+	struct sioq_args *args = container_of(work, struct sioq_args, work);
+	struct deletewh_args *d = &args->deletewh;
+
+	args->err = do_delete_whiteouts(d->dentry, d->bindex, d->namelist);
+	complete(&args->comp);
+}
+
+void __is_opaque_dir(struct work_struct *work)
+{
+	struct sioq_args *args = container_of(work, struct sioq_args, work);
+
+	args->ret = lookup_one_len(UNIONFS_DIR_OPAQUE, args->is_opaque.dentry,
+				   sizeof(UNIONFS_DIR_OPAQUE) - 1);
+	complete(&args->comp);
+}
-- 
1.5.2.2

