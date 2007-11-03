Return-Path: <linux-kernel-owner+w=401wt.eu-S1762539AbXKCBYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762539AbXKCBYh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 21:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757085AbXKCBXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 21:23:21 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:35205 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949AbXKCBXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 21:23:15 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 5/8] Unionfs: avoid a deadlock during branch-management on a pivot_root'ed union
Date: Fri,  2 Nov 2007 21:22:46 -0400
Message-Id: <11940529712183-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11940529692937-git-send-email-ezk@cs.sunysb.edu>
References: <11940529692937-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Acked-by: Herton Ronaldo Krzesinski <herton@mandriva.com>
---
 fs/unionfs/union.h |   39 +++++++++++++++++++++++++++++++++------
 1 files changed, 33 insertions(+), 6 deletions(-)

diff --git a/fs/unionfs/union.h b/fs/unionfs/union.h
index 6333488..0476f97 100644
--- a/fs/unionfs/union.h
+++ b/fs/unionfs/union.h
@@ -142,11 +142,18 @@ struct unionfs_sb_info {
 	 * This rwsem is used to make sure that a branch management
 	 * operation...
 	 *   1) will not begin before all currently in-flight operations
-	 *      complete
+	 *      complete.
 	 *   2) any new operations do not execute until the currently
-	 *      running branch management operation completes
+	 *      running branch management operation completes.
+	 *
+	 * The write_lock_owner records the PID of the task which grabbed
+	 * the rw_sem for writing.  If the same task also tries to grab the
+	 * read lock, we allow it.  This prevents a self-deadlock when
+	 * branch-management is used on a pivot_root'ed union, because we
+	 * have to ->lookup paths which belong to the same union.
 	 */
 	struct rw_semaphore rwsem;
+	pid_t write_lock_owner;	/* PID of rw_sem owner (write lock) */
 	int high_branch_id;	/* last unique branch ID given */
 	struct unionfs_data *data;
 };
@@ -234,10 +241,30 @@ static inline off_t rdstate2offset(struct unionfs_dir_state *buf)
 	return tmp;
 }
 
-#define unionfs_read_lock(sb)	 down_read(&UNIONFS_SB(sb)->rwsem)
-#define unionfs_read_unlock(sb)	 up_read(&UNIONFS_SB(sb)->rwsem)
-#define unionfs_write_lock(sb)	 down_write(&UNIONFS_SB(sb)->rwsem)
-#define unionfs_write_unlock(sb) up_write(&UNIONFS_SB(sb)->rwsem)
+static inline void unionfs_read_lock(struct super_block *sb)
+{
+	if (UNIONFS_SB(sb)->write_lock_owner &&
+	    UNIONFS_SB(sb)->write_lock_owner == current->pid)
+		return;
+	down_read(&UNIONFS_SB(sb)->rwsem);
+}
+static inline void unionfs_read_unlock(struct super_block *sb)
+{
+	if (UNIONFS_SB(sb)->write_lock_owner &&
+	    UNIONFS_SB(sb)->write_lock_owner == current->pid)
+		return;
+	up_read(&UNIONFS_SB(sb)->rwsem);
+}
+static inline void unionfs_write_lock(struct super_block *sb)
+{
+	down_write(&UNIONFS_SB(sb)->rwsem);
+	UNIONFS_SB(sb)->write_lock_owner = current->pid;
+}
+static inline void unionfs_write_unlock(struct super_block *sb)
+{
+	up_write(&UNIONFS_SB(sb)->rwsem);
+	UNIONFS_SB(sb)->write_lock_owner = 0;
+}
 
 static inline void unionfs_double_lock_dentry(struct dentry *d1,
 					      struct dentry *d2)
-- 
1.5.2.2

