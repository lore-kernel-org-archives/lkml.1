Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147Ab0CNKjN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 06:39:13 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:52898 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757344Ab0CNKi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 06:38:56 -0400
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, mitake@dcl.info.waseda.ac.jp,
       h.mitake@gmail.com, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>, Jason Baron <jbaron@redhat.com>
Subject: [PATCH RFC 11/11] Very dirty temporal solution for testing lock monitor
Date: Sun, 14 Mar 2010 19:38:48 +0900
Message-Id: <1268563128-6486-12-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1268563128-6486-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1268563128-6486-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch does some very dirty temporal fix for testing lock monitor.
fs/inode.c, fs/sysfs/dir.c and net/core/sock.c do some special lockdep using,
conflict with lock monitor.

This patch is only for testing!

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Jason Baron <jbaron@redhat.com>
---
 fs/inode.c      |    1 -
 fs/sysfs/dir.c  |   24 ++++++++++++++++++++----
 net/core/sock.c |   15 +++++++++++++++
 3 files changed, 35 insertions(+), 5 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 03dfeb2..f6180eb 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -158,7 +158,6 @@ int inode_init_always(struct super_block *sb, struct inode *inode)
 		goto out;
 	spin_lock_init(&inode->i_lock);
 	lockdep_set_class(&inode->i_lock, &sb->s_type->i_lock_key);
-
 	mutex_init(&inode->i_mutex);
 	lockdep_set_class(&inode->i_mutex, &sb->s_type->i_mutex_key);
 
diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 699f371..ba5f492 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -24,6 +24,22 @@
 #include <linux/security.h>
 #include "sysfs.h"
 
+/* FIXME: temporal solution */
+#undef rwsem_acquire
+#undef rwsem_acquire_read
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+# ifdef CONFIG_PROVE_LOCKING
+#  define rwsem_acquire(l, s, t, i)		lockdep_acquire(l, s, t, 0, 2, NULL, i)
+#  define rwsem_acquire_read(l, s, t, i)	lockdep_acquire(l, s, t, 1, 2, NULL, i)
+# else
+#  define rwsem_acquire(l, s, t, i)		lockdep_acquire(l, s, t, 0, 1, NULL, i)
+#  define rwsem_acquire_read(l, s, t, i)	lockdep_acquire(l, s, t, 1, 1, NULL, i)
+# endif
+#else
+# define rwsem_acquire(l, s, t, i)		do { } while (0)
+# define rwsem_acquire_read(l, s, t, i)		do { } while (0)
+#endif
+
 DEFINE_MUTEX(sysfs_mutex);
 DEFINE_SPINLOCK(sysfs_assoc_lock);
 
@@ -132,7 +148,7 @@ static void sysfs_put_active(struct sysfs_dirent *sd)
 	if (unlikely(!sd))
 		return;
 
-	rwsem_release(&sd->dep_map, 1, _RET_IP_);
+	lockdep_release(&sd->dep_map, 1, _RET_IP_);
 	v = atomic_dec_return(&sd->s_active);
 	if (likely(v != SD_DEACTIVATED_BIAS))
 		return;
@@ -204,14 +220,14 @@ static void sysfs_deactivate(struct sysfs_dirent *sd)
 	v = atomic_add_return(SD_DEACTIVATED_BIAS, &sd->s_active);
 
 	if (v != SD_DEACTIVATED_BIAS) {
-		lock_contended(&sd->dep_map, _RET_IP_);
+		lockdep_contended(&sd->dep_map, _RET_IP_);
 		wait_for_completion(&wait);
 	}
 
 	sd->s_sibling = NULL;
 
-	lock_acquired(&sd->dep_map, _RET_IP_);
-	rwsem_release(&sd->dep_map, 1, _RET_IP_);
+	lockdep_acquired(&sd->dep_map, _RET_IP_);
+	lockdep_release(&sd->dep_map, 1, _RET_IP_);
 }
 
 static int sysfs_alloc_ino(ino_t *pino)
diff --git a/net/core/sock.c b/net/core/sock.c
index e1f6f22..332bc1d 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -130,6 +130,21 @@
 #include <net/tcp.h>
 #endif
 
+/* FIXME: temporal solution */
+#undef mutex_acquire
+#undef mutex_release
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+# ifdef CONFIG_PROVE_LOCKING
+#  define mutex_acquire(l, s, t, i)		lockdep_acquire(l, s, t, 0, 2, NULL, i)
+# else
+#  define mutex_acquire(l, s, t, i)		lockdep_acquire(l, s, t, 0, 1, NULL, i)
+# endif
+# define mutex_release(l, n, i)			lockdep_release(l, n, i)
+#else
+# define mutex_acquire(l, s, t, i)		do { } while (0)
+# define mutex_release(l, n, i)			do { } while (0)
+#endif
+
 /*
  * Each address family might have different locking rules, so we have
  * one slock key per address family:
-- 
1.6.5.2

