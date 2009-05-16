Return-Path: <linux-kernel-owner+w=401wt.eu-S1756425AbZEPSCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425AbZEPSCj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 14:02:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754786AbZEPSCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 14:02:09 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:43689 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820AbZEPSCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 14:02:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=RWys2kciqEM1e/6/3TIogqhFqRlCfPz5PAx7O+9lz3jDXGdChGRYXWTJYcc1F4PMUt
         hZlzvCp4KaYNgfIgdbZRX/ZpBA8JvAqLrfDyOFgwfuHMCSIAw94lRDwRbolQI4MJ0hjA
         G9U280OoqhMX15wMDDPAUtsVzmALIKl8+Ywvw=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Reiserfs <reiserfs-devel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Jeff Mahoney <jeffm@suse.com>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH 1/2] kill-the-bkl/reiserfs: acquire the inode mutex safely
Date: Sat, 16 May 2009 20:02:01 +0200
Message-Id: <1242496922-6330-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1242496922-6330-1-git-send-email-fweisbec@gmail.com>
References: <1242496922-6330-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While searching a pathname, an inode mutex can be acquired
in do_lookup() which calls reiserfs_lookup() which in turn
acquires the write lock.

On the other side reiserfs_fill_super() can acquire the write_lock
and then call reiserfs_lookup_privroot() which can acquire an
inode mutex (the root of the mount point).

So we theoretically risk an AB - BA lock inversion that could lead
to a deadlock.

As for other lock dependencies found since the bkl to mutex
conversion, the fix is to use reiserfs_mutex_lock_safe() which
drops the lock dependency to the write lock.

[ Impact: fix a possible deadlock with reiserfs ]

Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Alexander Beregalov <a.beregalov@gmail.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 fs/reiserfs/journal.c       |   34 ----------------------------------
 fs/reiserfs/xattr.c         |    4 ++--
 include/linux/reiserfs_fs.h |   35 +++++++++++++++++++++++++++++++++++
 3 files changed, 37 insertions(+), 36 deletions(-)

diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
index 3c3e00d..86c1ff4 100644
--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -537,40 +537,6 @@ static inline void insert_journal_hash(struct reiserfs_journal_cnode **table,
 	journal_hash(table, cn->sb, cn->blocknr) = cn;
 }
 
-/*
- * Several mutexes depend on the write lock.
- * However sometimes we want to relax the write lock while we hold
- * these mutexes, according to the release/reacquire on schedule()
- * properties of the Bkl that were used.
- * Reiserfs performances and locking were based on this scheme.
- * Now that the write lock is a mutex and not the bkl anymore, doing so
- * may result in a deadlock:
- *
- * A acquire write_lock
- * A acquire j_commit_mutex
- * A release write_lock and wait for something
- * B acquire write_lock
- * B can't acquire j_commit_mutex and sleep
- * A can't acquire write lock anymore
- * deadlock
- *
- * What we do here is avoiding such deadlock by playing the same game
- * than the Bkl: if we can't acquire a mutex that depends on the write lock,
- * we release the write lock, wait a bit and then retry.
- *
- * The mutexes concerned by this hack are:
- * - The commit mutex of a journal list
- * - The flush mutex
- * - The journal lock
- */
-static inline void reiserfs_mutex_lock_safe(struct mutex *m,
-			       struct super_block *s)
-{
-	reiserfs_write_unlock(s);
-	mutex_lock(m);
-	reiserfs_write_lock(s);
-}
-
 /* lock the current transaction */
 static inline void lock_journal(struct super_block *sb)
 {
diff --git a/fs/reiserfs/xattr.c b/fs/reiserfs/xattr.c
index 2237e10..b4f74e5 100644
--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -969,7 +969,7 @@ int reiserfs_lookup_privroot(struct super_block *s)
 	int err = 0;
 
 	/* If we don't have the privroot located yet - go find it */
-	mutex_lock(&s->s_root->d_inode->i_mutex);
+	reiserfs_mutex_lock_safe(&s->s_root->d_inode->i_mutex, s);
 	dentry = lookup_one_len(PRIVROOT_NAME, s->s_root,
 				strlen(PRIVROOT_NAME));
 	if (!IS_ERR(dentry)) {
@@ -1005,7 +1005,7 @@ int reiserfs_xattr_init(struct super_block *s, int mount_flags)
 
 	if (privroot->d_inode) {
 		s->s_xattr = reiserfs_xattr_handlers;
-		mutex_lock(&privroot->d_inode->i_mutex);
+		reiserfs_mutex_lock_safe(&privroot->d_inode->i_mutex, s);
 		if (!REISERFS_SB(s)->xattr_root) {
 			struct dentry *dentry;
 			dentry = lookup_one_len(XAROOT_NAME, privroot,
diff --git a/include/linux/reiserfs_fs.h b/include/linux/reiserfs_fs.h
index 39bd4ea..7665f41 100644
--- a/include/linux/reiserfs_fs.h
+++ b/include/linux/reiserfs_fs.h
@@ -63,6 +63,41 @@ int reiserfs_write_lock_once(struct super_block *s);
 void reiserfs_write_unlock_once(struct super_block *s, int lock_depth);
 
 /*
+ * Several mutexes depend on the write lock.
+ * However sometimes we want to relax the write lock while we hold
+ * these mutexes, according to the release/reacquire on schedule()
+ * properties of the Bkl that were used.
+ * Reiserfs performances and locking were based on this scheme.
+ * Now that the write lock is a mutex and not the bkl anymore, doing so
+ * may result in a deadlock:
+ *
+ * A acquire write_lock
+ * A acquire j_commit_mutex
+ * A release write_lock and wait for something
+ * B acquire write_lock
+ * B can't acquire j_commit_mutex and sleep
+ * A can't acquire write lock anymore
+ * deadlock
+ *
+ * What we do here is avoiding such deadlock by playing the same game
+ * than the Bkl: if we can't acquire a mutex that depends on the write lock,
+ * we release the write lock, wait a bit and then retry.
+ *
+ * The mutexes concerned by this hack are:
+ * - The commit mutex of a journal list
+ * - The flush mutex
+ * - The journal lock
+ * - The inode mutex
+ */
+static inline void reiserfs_mutex_lock_safe(struct mutex *m,
+			       struct super_block *s)
+{
+	reiserfs_write_unlock(s);
+	mutex_lock(m);
+	reiserfs_write_lock(s);
+}
+
+/*
  * When we schedule, we usually want to also release the write lock,
  * according to the previous bkl based locking scheme of reiserfs.
  */
-- 
1.6.2.3

