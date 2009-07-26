Return-Path: <linux-kernel-owner+w=401wt.eu-S1753180AbZGZIYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180AbZGZIYM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 04:24:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752940AbZGZITv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 04:19:51 -0400
Received: from www.tglx.de ([62.245.132.106]:57948 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752252AbZGZITs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 04:19:48 -0400
Message-Id: <20090726081555.354074236@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 26 Jul 2009 08:18:23 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: [Patch RFC 16/37] smbfs: Convert server->sem to mutex
References: <20090726081459.455111897@linutronix.de>
Content-Disposition: inline; filename=convert-smbfs-inode-sem-to-mutex.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

server->sem is used as mutex so make it a mutex.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/smbfs/inode.c          |    2 +-
 include/linux/smb_fs_sb.h |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

Index: linux-2.6-tip/fs/smbfs/inode.c
===================================================================
--- linux-2.6-tip.orig/fs/smbfs/inode.c
+++ linux-2.6-tip/fs/smbfs/inode.c
@@ -536,7 +536,7 @@ static int smb_fill_super(struct super_b
 	server->mnt = NULL;
 	server->sock_file = NULL;
 	init_waitqueue_head(&server->conn_wq);
-	init_MUTEX(&server->sem);
+	mutex_init(&server->mutex);
 	INIT_LIST_HEAD(&server->entry);
 	INIT_LIST_HEAD(&server->xmitq);
 	INIT_LIST_HEAD(&server->recvq);
Index: linux-2.6-tip/include/linux/smb_fs_sb.h
===================================================================
--- linux-2.6-tip.orig/include/linux/smb_fs_sb.h
+++ linux-2.6-tip/include/linux/smb_fs_sb.h
@@ -57,7 +57,7 @@ struct smb_sb_info {
 	struct smb_conn_opt opt;
 	wait_queue_head_t conn_wq;
 	int conn_complete;
-	struct semaphore sem;
+	struct mutex mutex;
 
 	unsigned char      header[SMB_HEADER_LEN + 20*2 + 2];
 	u32                header_len;
@@ -79,19 +79,19 @@ struct smb_sb_info {
 static inline int
 smb_lock_server_interruptible(struct smb_sb_info *server)
 {
-	return down_interruptible(&(server->sem));
+	return mutex_lock_interruptible(&server->mutex);
 }
 
 static inline void
 smb_lock_server(struct smb_sb_info *server)
 {
-	down(&(server->sem));
+	mutex_lock(&server->mutex);
 }
 
 static inline void
 smb_unlock_server(struct smb_sb_info *server)
 {
-	up(&(server->sem));
+	mutex_unlock(&server->mutex);
 }
 
 #endif


