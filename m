Return-Path: <linux-kernel-owner+w=401wt.eu-S934258AbYEUDfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934258AbYEUDfT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 23:35:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761646AbYEUDdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 23:33:00 -0400
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:44076 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757168AbYEUDcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 23:32:54 -0400
From: hooanon05@yahoo.co.jp
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Junjiro Okajima <hooanon05@yahoo.co.jp>
Subject: [AUFS PATCH v2.6.26-rc2-mm1 33/39] aufs robr-mode
Date: Wed, 21 May 2008 12:23:03 +0900
Message-Id: <1211340189-11813-34-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.5.5.1.308.g1fbb5.dirty
In-Reply-To: <1211340189-11813-1-git-send-email-hooanon05@yahoo.co.jp>
References: <1211340189-11813-1-git-send-email-hooanon05@yahoo.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Junjiro Okajima <hooanon05@yahoo.co.jp>

initial commit
aufs as a readonly branch of another aufs

Signed-off-by: Junjiro Okajima <hooanon05@yahoo.co.jp>
---
 fs/aufs/robr.c |  109 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 109 insertions(+), 0 deletions(-)
 create mode 100644 fs/aufs/robr.c

diff --git a/fs/aufs/robr.c b/fs/aufs/robr.c
new file mode 100644
index 0000000..64ec128
--- /dev/null
+++ b/fs/aufs/robr.c
@@ -0,0 +1,109 @@
+/*
+ * Copyright (C) 2008 Junjiro Okajima
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
+ * 'robr', aufs as readonly branch of another aufs
+ */
+
+#include "aufs.h"
+
+/* ---------------------------------------------------------------------- */
+
+int au_test_robr_wh(struct qstr *name, struct dentry *h_parent,
+		    struct qstr *wh_name, int try_sio, struct au_ndx *ndx)
+{
+	if (strncmp(name->name, AUFS_WH_PFX, AUFS_WH_PFX_LEN))
+		return au_wh_test(h_parent, wh_name, try_sio, ndx);
+	return -EPERM;
+}
+
+int au_test_robr_shwh(struct super_block *sb, const struct qstr *name)
+{
+	return 0;
+}
+
+/* ---------------------------------------------------------------------- */
+
+struct au_robr_lvma {
+	struct list_head list;
+	struct vm_area_struct *vma;
+};
+
+struct file *au_robr_safe_file(struct vm_area_struct *vma)
+{
+	struct file *file = vma->vm_file;
+	struct super_block *sb = file->f_dentry->d_sb;
+	struct au_robr_lvma *lvma, *entry;
+	struct au_sbinfo *sbinfo;
+	int found, warn;
+
+	AuTraceEnter();
+	AuDebugOn(!au_test_aufs(sb));
+
+	warn = 0;
+	found = 0;
+	sbinfo = au_sbi(sb);
+	spin_lock(&sbinfo->si_lvma_lock);
+	list_for_each_entry(entry, &sbinfo->si_lvma, list) {
+		found = (entry->vma == vma);
+		if (unlikely(found))
+			break;
+	}
+	if (!found) {
+		lvma = kmalloc(sizeof(*lvma), GFP_ATOMIC);
+		if (lvma) {
+			lvma->vma = vma;
+			list_add(&lvma->list, &sbinfo->si_lvma);
+		} else {
+			warn = 1;
+			file = NULL;
+		}
+	} else
+		file = NULL;
+	spin_unlock(&sbinfo->si_lvma_lock);
+
+	if (unlikely(warn))
+		AuWarn1("no memory for lvma\n");
+	return file;
+}
+
+void au_robr_reset_file(struct vm_area_struct *vma, struct file *file)
+{
+	struct super_block *sb = file->f_dentry->d_sb;
+	struct au_robr_lvma *entry, *found;
+	struct au_sbinfo *sbinfo;
+
+	AuTraceEnter();
+	AuDebugOn(!au_test_aufs(sb));
+
+	vma->vm_file = file;
+	/* smp_mb(); */ /* flush vm_file */
+
+	found = NULL;
+	sbinfo = au_sbi(sb);
+	spin_lock(&sbinfo->si_lvma_lock);
+	list_for_each_entry(entry, &sbinfo->si_lvma, list)
+		if (entry->vma == vma) {
+			found = entry;
+			break;
+		}
+	AuDebugOn(!found);
+	list_del(&found->list);
+	spin_unlock(&sbinfo->si_lvma_lock);
+	kfree(found);
+}
-- 
1.5.5.1.308.g1fbb5.dirty

