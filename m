Return-Path: <linux-kernel-owner+w=401wt.eu-S938284AbZDJHU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938284AbZDJHU5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 03:20:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938059AbZDJHR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 03:17:26 -0400
Received: from mfbichi12.ns.itscom.net ([219.110.2.190]:35984 "EHLO
	mfbichi12.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938058AbZDJHRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 03:17:23 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
To: linux-kernel@vger.kernel.org
Cc: greg@kroah.com, linux-fsdevel@vger.kernel.org,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: [RFC Aufs2 #5 19/29] aufs ioctl
Date: Fri, 10 Apr 2009 16:02:33 +0900
Message-Id: <1239346963-30953-20-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.6.1.284.g5dc13
In-Reply-To: <1239346963-30953-1-git-send-email-hooanon05@yahoo.co.jp>
References: <1239346963-30953-1-git-send-email-hooanon05@yahoo.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

initial commit
currently for maintenance only

Signed-off-by: J. R. Okajima <hooanon05@yahoo.co.jp>
---
 fs/aufs/ioctl.c |   54 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 54 insertions(+), 0 deletions(-)
 create mode 100644 fs/aufs/ioctl.c

diff --git a/fs/aufs/ioctl.c b/fs/aufs/ioctl.c
new file mode 100644
index 0000000..ff17d77
--- /dev/null
+++ b/fs/aufs/ioctl.c
@@ -0,0 +1,54 @@
+/*
+ * Copyright (C) 2005-2009 Junjiro R. Okajima
+ *
+ * This program, aufs is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/uaccess.h>
+#include "aufs.h"
+
+long aufs_ioctl_dir(struct file *file, unsigned int cmd,
+		    unsigned long arg __maybe_unused)
+{
+	long err;
+	struct super_block *sb;
+	struct au_sbinfo *sbinfo;
+
+	err = -EACCES;
+	if (!capable(CAP_SYS_ADMIN))
+		goto out;
+
+	err = 0;
+	sb = file->f_dentry->d_sb;
+	sbinfo = au_sbi(sb);
+	switch (cmd) {
+	case AUFS_CTL_PLINK_MAINT:
+		/*
+		 * pseudo-link maintenance mode,
+		 * cleared by aufs_release_dir()
+		 */
+		si_write_lock(sb);
+		if (!au_ftest_si(sbinfo, MAINTAIN_PLINK)) {
+			au_fset_si(sbinfo, MAINTAIN_PLINK);
+			au_fi(file)->fi_maintain_plink = 1;
+		} else
+			err = -EBUSY;
+		si_write_unlock(sb);
+		break;
+	case AUFS_CTL_PLINK_CLEAN:
+		if (au_opt_test(sbinfo->si_mntflags, PLINK)) {
+			aufs_write_lock(sb->s_root);
+			au_plink_put(sb);
+			aufs_write_unlock(sb->s_root);
+		}
+		break;
+	default:
+		err = -EINVAL;
+	}
+
+ out:
+	return err;
+}
-- 
1.6.1.284.g5dc13

