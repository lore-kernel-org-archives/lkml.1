Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687Ab0CBXei (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:34:38 -0500
Received: from kroah.org ([198.145.64.141]:38670 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754292Ab0CBX3k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:29:40 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 43/62] sysfs: Only take active references on attributes.
Date: Tue,  2 Mar 2010 15:28:42 -0800
Message-Id: <1267572541-410-43-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230933.GA32287@kroah.com>
References: <20100302230933.GA32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

If we exclude directories and symlinks from the set of sysfs
dirents where we need active references we are left with
sysfs attributes (binary or not).

- Tweak sysfs_deactivate to only do something on attributes
- Move lockdep initialization into sysfs_file_add_mode to
  limit it to just attributes.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/dir.c   |    5 ++++-
 fs/sysfs/file.c  |    1 +
 fs/sysfs/sysfs.h |    1 +
 3 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 1bdc42f..481fdec 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -156,6 +156,10 @@ static void sysfs_deactivate(struct sysfs_dirent *sd)
 	int v;
 
 	BUG_ON(sd->s_sibling || !(sd->s_flags & SYSFS_FLAG_REMOVED));
+
+	if (!(sysfs_type(sd) & SYSFS_ACTIVE_REF))
+		return;
+
 	sd->s_sibling = (void *)&wait;
 
 	rwsem_acquire(&sd->dep_map, 0, 0, _RET_IP_);
@@ -315,7 +319,6 @@ struct sysfs_dirent *sysfs_new_dirent(const char *name, umode_t mode, int type)
 
 	atomic_set(&sd->s_count, 1);
 	atomic_set(&sd->s_active, 0);
-	sysfs_dirent_init_lockdep(sd);
 
 	sd->s_name = name;
 	sd->s_mode = mode;
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 4096136..e222b25 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -509,6 +509,7 @@ int sysfs_add_file_mode(struct sysfs_dirent *dir_sd,
 	if (!sd)
 		return -ENOMEM;
 	sd->s_attr.attr = (void *)attr;
+	sysfs_dirent_init_lockdep(sd);
 
 	sysfs_addrm_start(&acxt, dir_sd);
 	rc = sysfs_add_one(&acxt, sd);
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index bb7723c..7db6884 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -79,6 +79,7 @@ struct sysfs_dirent {
 #define SYSFS_KOBJ_BIN_ATTR		0x0004
 #define SYSFS_KOBJ_LINK			0x0008
 #define SYSFS_COPY_NAME			(SYSFS_DIR | SYSFS_KOBJ_LINK)
+#define SYSFS_ACTIVE_REF		(SYSFS_KOBJ_ATTR | SYSFS_KOBJ_BIN_ATTR)
 
 #define SYSFS_FLAG_MASK			~SYSFS_TYPE_MASK
 #define SYSFS_FLAG_REMOVED		0x0200
-- 
1.7.0.1

