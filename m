Return-Path: <linux-kernel-owner+w=401wt.eu-S1755450Ab0A2HEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450Ab0A2HEi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 02:04:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750950Ab0A2HEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 02:04:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29465 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753167Ab0A2HEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 02:04:34 -0500
Date: Fri, 29 Jan 2010 02:02:15 -0500
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Miles Lane <miles.lane@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Amerigo Wang <amwang@redhat.com>, akpm@linux-foundation.org
Message-Id: <20100129070537.4058.42197.sendpatchset@localhost.localdomain>
In-Reply-To: <20100129070516.4058.77227.sendpatchset@localhost.localdomain>
References: <20100129070516.4058.77227.sendpatchset@localhost.localdomain>
Subject: [PATCH 2/2] sysfs: fix the incomplete part of subclass support for s_active
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amerigo Wang <amwang@redhat.com>
Date: Fri, 29 Jan 2010 14:18:58 +0800
Subject: [PATCH 2/2] sysfs: fix the incomplete part of subclass support for s_active

Patch 1/2 missed the initialization part for subclass, which I think
is the reason why it still can't stop the lockdep warning. This depends
on patch 1/2.

Compile test only.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/sysfs/dir.c   |    1 -
 fs/sysfs/file.c  |    2 ++
 fs/sysfs/sysfs.h |    6 +++---
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index e0cd4a0..6b63198 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -364,7 +364,6 @@ struct sysfs_dirent *sysfs_new_dirent(const char *name, umode_t mode, int type)
 
 	atomic_set(&sd->s_count, 1);
 	atomic_set(&sd->s_active, 0);
-	sysfs_dirent_init_lockdep(sd);
 
 	sd->s_name = name;
 	sd->s_mode = mode;
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index dc30d9e..abf30d7 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -509,6 +509,8 @@ int sysfs_add_file_mode(struct sysfs_dirent *dir_sd,
 	if (!sd)
 		return -ENOMEM;
 	sd->s_attr.attr = (void *)attr;
+	if ((type & SYSFS_TYPE_MASK) == SYSFS_KOBJ_ATTR)
+		sysfs_dirent_init_lockdep(sd, sd->s_attr.attr->subclass);
 
 	sysfs_addrm_start(&acxt, dir_sd);
 	rc = sysfs_add_one(&acxt, sd);
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index cdd9377..7e78f2e 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -89,14 +89,14 @@ static inline unsigned int sysfs_type(struct sysfs_dirent *sd)
 }
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
-#define sysfs_dirent_init_lockdep(sd)				\
+#define sysfs_dirent_init_lockdep(sd, c)			\
 do {								\
 	static struct lock_class_key __key;			\
 								\
-	lockdep_init_map(&sd->dep_map, "s_active", &__key, 0);	\
+	lockdep_init_map(&sd->dep_map, "s_active", &__key, c);	\
 } while(0)
 #else
-#define sysfs_dirent_init_lockdep(sd) do {} while(0)
+#define sysfs_dirent_init_lockdep(sd, c) do {} while(0)
 #endif
 
 /*
-- 
1.5.5.6

