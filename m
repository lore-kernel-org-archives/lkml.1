Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935981Ab0BZMOl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 07:14:41 -0500
Received: from hera.kernel.org ([140.211.167.34]:43366 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935936Ab0BZMOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 07:14:33 -0500
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org,
       oleg@redhat.com
Cc: Tejun Heo <tj@kernel.org>, Steve French <sfrench@samba.org>
Subject: [PATCH 41/43] cifs: use workqueue instead of slow-work
Date: Fri, 26 Feb 2010 21:23:18 +0900
Message-Id: <1267187000-18791-42-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1267187000-18791-1-git-send-email-tj@kernel.org>
References: <1267187000-18791-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Feb 2010 12:13:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Workqueue can now handle high concurrency.  Use system_single_wq
instead of slow-work.

* Updated is_valid_oplock_break() to not call cifs_oplock_break_put()
  as advised by Steve French.  It might cause deadlock.  Instead,
  reference is increased after queueing succeeded and
  cifs_oplock_break() briefly grabs GlobalSMBSeslock before putting
  the cfile to make sure it doesn't put before the matching get is
  finished.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Steve French <sfrench@samba.org>
---
 fs/cifs/Kconfig    |    1 -
 fs/cifs/cifsfs.c   |    6 +-----
 fs/cifs/cifsglob.h |    8 +++++---
 fs/cifs/dir.c      |    2 +-
 fs/cifs/file.c     |   30 +++++++++++++-----------------
 fs/cifs/misc.c     |   20 ++++++++++++--------
 6 files changed, 32 insertions(+), 35 deletions(-)

diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
index 80f3525..6994a0f 100644
--- a/fs/cifs/Kconfig
+++ b/fs/cifs/Kconfig
@@ -2,7 +2,6 @@ config CIFS
 	tristate "CIFS support (advanced network filesystem, SMBFS successor)"
 	depends on INET
 	select NLS
-	select SLOW_WORK
 	help
 	  This is the client VFS module for the Common Internet File System
 	  (CIFS) protocol which is the successor to the Server Message Block
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 8c6a036..461a3a7 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1038,15 +1038,10 @@ init_cifs(void)
 	if (rc)
 		goto out_unregister_key_type;
 #endif
-	rc = slow_work_register_user(THIS_MODULE);
-	if (rc)
-		goto out_unregister_resolver_key;
 
 	return 0;
 
- out_unregister_resolver_key:
 #ifdef CONFIG_CIFS_DFS_UPCALL
-	unregister_key_type(&key_type_dns_resolver);
  out_unregister_key_type:
 #endif
 #ifdef CONFIG_CIFS_UPCALL
@@ -1069,6 +1064,7 @@ static void __exit
 exit_cifs(void)
 {
 	cFYI(DBG2, ("exit_cifs"));
+	flush_workqueue(system_single_wq);
 	cifs_proc_clean();
 #ifdef CONFIG_CIFS_DFS_UPCALL
 	cifs_dfs_release_automount_timer();
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index ed751bb..0a915d2 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -18,7 +18,7 @@
  */
 #include <linux/in.h>
 #include <linux/in6.h>
-#include <linux/slow-work.h>
+#include <linux/workqueue.h>
 #include "cifs_fs_sb.h"
 #include "cifsacl.h"
 /*
@@ -357,7 +357,7 @@ struct cifsFileInfo {
 	atomic_t count;		/* reference count */
 	struct mutex fh_mutex; /* prevents reopen race after dead ses*/
 	struct cifs_search_info srch_inf;
-	struct slow_work oplock_break; /* slow_work job for oplock breaks */
+	struct work_struct oplock_break; /* work for oplock breaks */
 };
 
 /* Take a reference on the file private data */
@@ -724,4 +724,6 @@ GLOBAL_EXTERN unsigned int cifs_min_rcv;    /* min size of big ntwrk buf pool */
 GLOBAL_EXTERN unsigned int cifs_min_small;  /* min size of small buf pool */
 GLOBAL_EXTERN unsigned int cifs_max_pending; /* MAX requests at once to server*/
 
-extern const struct slow_work_ops cifs_oplock_break_ops;
+void cifs_oplock_break(struct work_struct *work);
+void cifs_oplock_break_get(struct cifsFileInfo *cfile);
+void cifs_oplock_break_put(struct cifsFileInfo *cfile);
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 6ccf726..3c6f9b2 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -157,7 +157,7 @@ cifs_new_fileinfo(struct inode *newinode, __u16 fileHandle,
 	mutex_init(&pCifsFile->lock_mutex);
 	INIT_LIST_HEAD(&pCifsFile->llist);
 	atomic_set(&pCifsFile->count, 1);
-	slow_work_init(&pCifsFile->oplock_break, &cifs_oplock_break_ops);
+	INIT_WORK(&pCifsFile->oplock_break, cifs_oplock_break);
 
 	write_lock(&GlobalSMBSeslock);
 	list_add(&pCifsFile->tlist, &cifs_sb->tcon->openFileList);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 057e1da..e151ac5 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2276,8 +2276,7 @@ out:
 	return rc;
 }
 
-static void
-cifs_oplock_break(struct slow_work *work)
+void cifs_oplock_break(struct work_struct *work)
 {
 	struct cifsFileInfo *cfile = container_of(work, struct cifsFileInfo,
 						  oplock_break);
@@ -2316,33 +2315,30 @@ cifs_oplock_break(struct slow_work *work)
 				 LOCKING_ANDX_OPLOCK_RELEASE, false);
 		cFYI(1, ("Oplock release rc = %d", rc));
 	}
+
+	/*
+	 * We might have kicked in before is_valid_oplock_break()
+	 * finished grabbing reference for us.  Make sure it's done by
+	 * waiting for GlobalSMSSeslock.
+	 */
+	write_lock(&GlobalSMBSeslock);
+	write_unlock(&GlobalSMBSeslock);
+
+	cifs_oplock_break_put(cfile);
 }
 
-static int
-cifs_oplock_break_get(struct slow_work *work)
+void cifs_oplock_break_get(struct cifsFileInfo *cfile)
 {
-	struct cifsFileInfo *cfile = container_of(work, struct cifsFileInfo,
-						  oplock_break);
 	mntget(cfile->mnt);
 	cifsFileInfo_get(cfile);
-	return 0;
 }
 
-static void
-cifs_oplock_break_put(struct slow_work *work)
+void cifs_oplock_break_put(struct cifsFileInfo *cfile)
 {
-	struct cifsFileInfo *cfile = container_of(work, struct cifsFileInfo,
-						  oplock_break);
 	mntput(cfile->mnt);
 	cifsFileInfo_put(cfile);
 }
 
-const struct slow_work_ops cifs_oplock_break_ops = {
-	.get_ref	= cifs_oplock_break_get,
-	.put_ref	= cifs_oplock_break_put,
-	.execute	= cifs_oplock_break,
-};
-
 const struct address_space_operations cifs_addr_ops = {
 	.readpage = cifs_readpage,
 	.readpages = cifs_readpages,
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index d27d4ec..d9e6ce8 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -499,7 +499,6 @@ is_valid_oplock_break(struct smb_hdr *buf, struct TCP_Server_Info *srv)
 	struct cifsTconInfo *tcon;
 	struct cifsInodeInfo *pCifsInode;
 	struct cifsFileInfo *netfile;
-	int rc;
 
 	cFYI(1, ("Checking for oplock break or dnotify response"));
 	if ((pSMB->hdr.Command == SMB_COM_NT_TRANSACT) &&
@@ -584,13 +583,18 @@ is_valid_oplock_break(struct smb_hdr *buf, struct TCP_Server_Info *srv)
 				pCifsInode->clientCanCacheAll = false;
 				if (pSMB->OplockLevel == 0)
 					pCifsInode->clientCanCacheRead = false;
-				rc = slow_work_enqueue(&netfile->oplock_break);
-				if (rc) {
-					cERROR(1, ("failed to enqueue oplock "
-						   "break: %d\n", rc));
-				} else {
-					netfile->oplock_break_cancelled = false;
-				}
+
+				/*
+				 * cifs_oplock_break_put() can't be called
+				 * from here.  Get reference after queueing
+				 * succeeded.  cifs_oplock_break() will
+				 * synchronize using GlobalSMSSeslock.
+				 */
+				if (queue_work(system_single_wq,
+					       &netfile->oplock_break))
+					cifs_oplock_break_get(netfile);
+				netfile->oplock_break_cancelled = false;
+
 				read_unlock(&GlobalSMBSeslock);
 				read_unlock(&cifs_tcp_ses_lock);
 				return true;
-- 
1.6.4.2

