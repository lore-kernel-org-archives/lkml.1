Return-Path: <linux-kernel-owner+w=401wt.eu-S934701AbZKYNa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934701AbZKYNa3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 08:30:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933159AbZKYNa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 08:30:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38115 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964845AbZKYN2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 08:28:21 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 11/30] GFS2: Hook gfs2_quota_sync into VFS via gfs2_quotactl_ops
Date: Wed, 25 Nov 2009 14:22:36 +0000
Message-Id: <1259158975-28499-12-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1259158975-28499-11-git-send-email-swhiteho@redhat.com>
References: <1259158975-28499-1-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-2-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-3-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-4-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-5-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-6-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-7-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-8-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-9-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-10-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-11-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The plan is to add further operations to the gfs2_quotactl_ops
in future patches. The sync operation is easy, so we start with
that one.

We plan to use the XFS quota control functions because they more
closely match the GFS2 ones.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/Kconfig      |    2 ++
 fs/gfs2/ops_fstype.c |    3 +++
 fs/gfs2/quota.c      |    4 ++++
 fs/gfs2/quota.h      |    1 +
 4 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/fs/gfs2/Kconfig b/fs/gfs2/Kconfig
index 5971359..4dcddf8 100644
--- a/fs/gfs2/Kconfig
+++ b/fs/gfs2/Kconfig
@@ -8,6 +8,8 @@ config GFS2_FS
 	select FS_POSIX_ACL
 	select CRC32
 	select SLOW_WORK
+	select QUOTA
+	select QUOTACTL
 	help
 	  A cluster filesystem.
 
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index e5ee062..36b11cb 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -18,6 +18,7 @@
 #include <linux/mount.h>
 #include <linux/gfs2_ondisk.h>
 #include <linux/slow-work.h>
+#include <linux/quotaops.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -1138,6 +1139,8 @@ static int fill_super(struct super_block *sb, struct gfs2_args *args, int silent
 	sb->s_op = &gfs2_super_ops;
 	sb->s_export_op = &gfs2_export_ops;
 	sb->s_xattr = gfs2_xattr_handlers;
+	sb->s_qcop = &gfs2_quotactl_ops;
+	sb_dqopt(sb)->flags |= DQUOT_QUOTA_SYS_FILE;
 	sb->s_time_gran = 1;
 	sb->s_maxbytes = MAX_LFS_FILESIZE;
 
diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index ed9e197..73a43ce 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -1378,3 +1378,7 @@ int gfs2_quotad(void *data)
 	return 0;
 }
 
+const struct quotactl_ops gfs2_quotactl_ops = {
+	.quota_sync     = gfs2_quota_sync,
+};
+
diff --git a/fs/gfs2/quota.h b/fs/gfs2/quota.h
index 437afa7..025d15b 100644
--- a/fs/gfs2/quota.h
+++ b/fs/gfs2/quota.h
@@ -50,5 +50,6 @@ static inline int gfs2_quota_lock_check(struct gfs2_inode *ip)
 }
 
 extern int gfs2_shrink_qd_memory(int nr, gfp_t gfp_mask);
+extern const struct quotactl_ops gfs2_quotactl_ops;
 
 #endif /* __QUOTA_DOT_H__ */
-- 
1.6.2.5

