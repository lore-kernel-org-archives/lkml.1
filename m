Return-Path: <linux-kernel-owner+w=401wt.eu-S1754968Ab0A2UjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968Ab0A2UjY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 15:39:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755145Ab0A2UjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 15:39:21 -0500
Received: from www.tglx.de ([62.245.132.106]:44768 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755103Ab0A2UjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 15:39:17 -0500
Message-Id: <20100129203613.406683294@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 29 Jan 2010 20:38:34 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
       Steve French <sfrench@us.ibm.com>
Subject: [patch 01/10] smbfs: Convert server->sem to mutex
References: <20100129203549.526478432@linutronix.de>
Content-Disposition: inline; filename=smbfs-convert-sema.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The semaphore server->sem is used as mutex. Rename it to server->mutex
and convert it to a real mutex.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jeff Layton <jlayton@redhat.com>
Cc: Steve French <sfrench@us.ibm.com>

---
 fs/smbfs/inode.c          |    2 +-
 include/linux/smb_fs_sb.h |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

Index: linux-2.6-tip/fs/smbfs/inode.c
===================================================================
--- linux-2.6-tip.orig/fs/smbfs/inode.c
+++ linux-2.6-tip/fs/smbfs/inode.c
@@ -530,7 +530,7 @@ static int smb_fill_super(struct super_b
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


