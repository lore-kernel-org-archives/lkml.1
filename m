Return-Path: <linux-kernel-owner+w=401wt.eu-S1760567AbZCPHaB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760567AbZCPHaB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 03:30:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755871AbZCPHXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 03:23:55 -0400
Received: from vsmtp01.dti.ne.jp ([202.216.231.136]:35661 "EHLO
	vsmtp01.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754014AbZCPHW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 03:22:58 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: [RFC Aufs2 #2 11/28] aufs sub-dcache
Date: Mon, 16 Mar 2009 16:20:23 +0900
Message-Id: <1237188040-11404-12-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.6.1.284.g5dc13
In-Reply-To: <1237188040-11404-1-git-send-email-hooanon05@yahoo.co.jp>
References: <1237188040-11404-1-git-send-email-hooanon05@yahoo.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

initial commit
sub-routines or simple wrappers for dentry cache

Signed-off-by: J. R. Okajima <hooanon05@yahoo.co.jp>
---
 fs/aufs/dcsub.c |  214 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/aufs/dcsub.h |   43 +++++++++++
 2 files changed, 257 insertions(+), 0 deletions(-)
 create mode 100644 fs/aufs/dcsub.c
 create mode 100644 fs/aufs/dcsub.h

diff --git a/fs/aufs/dcsub.c b/fs/aufs/dcsub.c
new file mode 100644
index 0000000..e4597e4
--- /dev/null
+++ b/fs/aufs/dcsub.c
@@ -0,0 +1,214 @@
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
+ * sub-routines for dentry cache
+ */
+
+#include "aufs.h"
+
+static void au_dpage_free(struct au_dpage *dpage)
+{
+	int i;
+	struct dentry **p;
+
+	p = dpage->dentries;
+	for (i = 0; i < dpage->ndentry; i++)
+		dput(*p++);
+	free_page((unsigned long)dpage->dentries);
+}
+
+int au_dpages_init(struct au_dcsub_pages *dpages, gfp_t gfp)
+{
+	int err;
+	void *p;
+
+	err = -ENOMEM;
+	dpages->dpages = kmalloc(sizeof(*dpages->dpages), gfp);
+	if (unlikely(!dpages->dpages))
+		goto out;
+
+	p = (void *)__get_free_page(gfp);
+	if (unlikely(!p))
+		goto out_dpages;
+
+	dpages->dpages[0].ndentry = 0;
+	dpages->dpages[0].dentries = p;
+	dpages->ndpage = 1;
+	return 0; /* success */
+
+ out_dpages:
+	kfree(dpages->dpages);
+ out:
+	return err;
+}
+
+void au_dpages_free(struct au_dcsub_pages *dpages)
+{
+	int i;
+	struct au_dpage *p;
+
+	p = dpages->dpages;
+	for (i = 0; i < dpages->ndpage; i++)
+		au_dpage_free(p++);
+	kfree(dpages->dpages);
+}
+
+static int au_dpages_append(struct au_dcsub_pages *dpages,
+			    struct dentry *dentry, gfp_t gfp)
+{
+	int err, sz;
+	struct au_dpage *dpage;
+	void *p;
+
+	dpage = dpages->dpages + dpages->ndpage - 1;
+	sz = PAGE_SIZE / sizeof(dentry);
+	if (unlikely(dpage->ndentry >= sz)) {
+		AuLabel(new dpage);
+		err = -ENOMEM;
+		sz = dpages->ndpage * sizeof(*dpages->dpages);
+		p = au_kzrealloc(dpages->dpages, sz,
+				 sz + sizeof(*dpages->dpages), gfp);
+		if (unlikely(!p))
+			goto out;
+
+		dpages->dpages = p;
+		dpage = dpages->dpages + dpages->ndpage;
+		p = (void *)__get_free_page(gfp);
+		if (unlikely(!p))
+			goto out;
+
+		dpage->ndentry = 0;
+		dpage->dentries = p;
+		dpages->ndpage++;
+	}
+
+	dpage->dentries[dpage->ndentry++] = dget(dentry);
+	return 0; /* success */
+
+ out:
+	return err;
+}
+
+int au_dcsub_pages(struct au_dcsub_pages *dpages, struct dentry *root,
+		   au_dpages_test test, void *arg)
+{
+	int err;
+	struct dentry *this_parent = root;
+	struct list_head *next;
+	struct super_block *sb = root->d_sb;
+
+	err = 0;
+	spin_lock(&dcache_lock);
+ repeat:
+	next = this_parent->d_subdirs.next;
+ resume:
+	if (this_parent->d_sb == sb
+	    && !IS_ROOT(this_parent)
+	    && atomic_read(&this_parent->d_count)
+	    && this_parent->d_inode
+	    && (!test || test(this_parent, arg))) {
+		err = au_dpages_append(dpages, this_parent, GFP_ATOMIC);
+		if (unlikely(err))
+			goto out;
+	}
+
+	while (next != &this_parent->d_subdirs) {
+		struct list_head *tmp = next;
+		struct dentry *dentry = list_entry(tmp, struct dentry,
+						   d_u.d_child);
+		next = tmp->next;
+		if (/*d_unhashed(dentry) || */!dentry->d_inode)
+			continue;
+		if (!list_empty(&dentry->d_subdirs)) {
+			this_parent = dentry;
+			goto repeat;
+		}
+		if (dentry->d_sb == sb
+		    && atomic_read(&dentry->d_count)
+		    && (!test || test(dentry, arg))) {
+			err = au_dpages_append(dpages, dentry, GFP_ATOMIC);
+			if (unlikely(err))
+				goto out;
+		}
+	}
+
+	if (this_parent != root) {
+		next = this_parent->d_u.d_child.next;
+		this_parent = this_parent->d_parent; /* dcache_lock is locked */
+		goto resume;
+	}
+ out:
+	spin_unlock(&dcache_lock);
+	return err;
+}
+
+int au_dcsub_pages_rev(struct au_dcsub_pages *dpages, struct dentry *dentry,
+		       int do_include, au_dpages_test test, void *arg)
+{
+	int err;
+
+	err = 0;
+	spin_lock(&dcache_lock);
+	if (do_include && (!test || test(dentry, arg))) {
+		err = au_dpages_append(dpages, dentry, GFP_ATOMIC);
+		if (unlikely(err))
+			goto out;
+	}
+	while (!IS_ROOT(dentry)) {
+		dentry = dentry->d_parent; /* dcache_lock is locked */
+		if (!test || test(dentry, arg)) {
+			err = au_dpages_append(dpages, dentry, GFP_ATOMIC);
+			if (unlikely(err))
+				break;
+		}
+	}
+
+ out:
+	spin_unlock(&dcache_lock);
+
+	return err;
+}
+
+struct dentry *au_test_subdir(struct dentry *d1, struct dentry *d2)
+{
+	struct dentry *trap, **dentries;
+	int err, i, j;
+	struct au_dcsub_pages dpages;
+	struct au_dpage *dpage;
+
+	trap = ERR_PTR(-ENOMEM);
+	err = au_dpages_init(&dpages, GFP_NOFS);
+	if (unlikely(err))
+		goto out;
+	err = au_dcsub_pages_rev(&dpages, d1, /*do_include*/1, NULL, NULL);
+	if (unlikely(err))
+		goto out_dpages;
+
+	trap = d1;
+	for (i = 0; !err && i < dpages.ndpage; i++) {
+		dpage = dpages.dpages + i;
+		dentries = dpage->dentries;
+		for (j = 0; !err && j < dpage->ndentry; j++) {
+			struct dentry *d;
+
+			d = dentries[j];
+			err = (d == d2);
+			if (!err)
+				trap = d;
+		}
+	}
+	if (!err)
+		trap = NULL;
+
+ out_dpages:
+	au_dpages_free(&dpages);
+ out:
+	return trap;
+}
diff --git a/fs/aufs/dcsub.h b/fs/aufs/dcsub.h
new file mode 100644
index 0000000..89a7745
--- /dev/null
+++ b/fs/aufs/dcsub.h
@@ -0,0 +1,43 @@
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
+ * sub-routines for dentry cache
+ */
+
+#ifndef __AUFS_DCSUB_H__
+#define __AUFS_DCSUB_H__
+
+#ifdef __KERNEL__
+
+#include <linux/dcache.h>
+
+struct au_dpage {
+	int ndentry;
+	struct dentry **dentries;
+};
+
+struct au_dcsub_pages {
+	int ndpage;
+	struct au_dpage *dpages;
+};
+
+/* ---------------------------------------------------------------------- */
+
+int au_dpages_init(struct au_dcsub_pages *dpages, gfp_t gfp);
+void au_dpages_free(struct au_dcsub_pages *dpages);
+typedef int (*au_dpages_test)(struct dentry *dentry, void *arg);
+int au_dcsub_pages(struct au_dcsub_pages *dpages, struct dentry *root,
+		   au_dpages_test test, void *arg);
+int au_dcsub_pages_rev(struct au_dcsub_pages *dpages, struct dentry *dentry,
+		       int do_include, au_dpages_test test, void *arg);
+struct dentry *au_test_subdir(struct dentry *d1, struct dentry *d2);
+
+#endif /* __KERNEL__ */
+#endif /* __AUFS_DCSUB_H__ */
-- 
1.6.1.284.g5dc13

