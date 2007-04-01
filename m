Return-Path: <linux-kernel-owner+w=401wt.eu-S933721AbXDASSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933721AbXDASSQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 14:18:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933769AbXDASSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 14:18:09 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:40174 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933721AbXDASRe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 14:17:34 -0400
Date: Sun, 1 Apr 2007 20:16:49 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Roland Dreier <roland@digitalvampire.org>, Andrew Morton <akpm@osdl.org>
Subject: [PATCH 12/16] cifs-use-mutex.diff
In-Reply-To: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704012009410.12316@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Verbatim copy of original mail:

*>>>
>From http://lkml.org/lkml/2006/9/2/86

The recent change to "allow Windows blocking locks to be cancelled
via a CANCEL_LOCK call" introduced a new semaphore in struct
cifsFileInfo, lock_sem.  However, semaphores used as mutexes are
deprecated these days, and there's no reason to add a new one to the
kernel. Therefore, convert lock_sem to a struct mutex (and also fix
one indentation glitch on one of the lines changed anyway).

Compile tested only, since I don't use CIFS.

Signed-off-by: Roland Dreier <roland@digitalvampire.org>
*<<<


My 2¢:
Compile tested. Runtime tested. Did not break.

From: Roland Dreier <roland@digitalvampire.org>
Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: Roland Dreier <roland@digitalvampire.org>

 cifsglob.h |    2 +-
 dir.c      |    2 +-
 file.c     |   14 +++++++-------
 3 files changed, 9 insertions(+), 9 deletions(-)

Index: linux-2.6.21-rc5/fs/cifs/cifsglob.h
===================================================================
--- linux-2.6.21-rc5.orig/fs/cifs/cifsglob.h
+++ linux-2.6.21-rc5/fs/cifs/cifsglob.h
@@ -311,7 +311,7 @@ struct cifsFileInfo {
 	/* lock scope id (0 if none) */
 	struct file * pfile; /* needed for writepage */
 	struct inode * pInode; /* needed for oplock break */
-	struct semaphore lock_sem;
+	struct mutex lock_mutex;
 	struct list_head llist; /* list of byte range locks we have. */
 	unsigned closePend:1;	/* file is marked to close */
 	unsigned invalidHandle:1;  /* file closed via session abend */
Index: linux-2.6.21-rc5/fs/cifs/dir.c
===================================================================
--- linux-2.6.21-rc5.orig/fs/cifs/dir.c
+++ linux-2.6.21-rc5/fs/cifs/dir.c
@@ -274,7 +274,7 @@ cifs_create(struct inode *inode, struct 
 			pCifsFile->invalidHandle = FALSE;
 			pCifsFile->closePend     = FALSE;
 			init_MUTEX(&pCifsFile->fh_sem);
-			init_MUTEX(&pCifsFile->lock_sem);
+			mutex_init(&pCifsFile->lock_mutex);
 			INIT_LIST_HEAD(&pCifsFile->llist);
 			atomic_set(&pCifsFile->wrtPending,0);
 
Index: linux-2.6.21-rc5/fs/cifs/file.c
===================================================================
--- linux-2.6.21-rc5.orig/fs/cifs/file.c
+++ linux-2.6.21-rc5/fs/cifs/file.c
@@ -48,7 +48,7 @@ static inline struct cifsFileInfo *cifs_
 	private_data->netfid = netfid;
 	private_data->pid = current->tgid;	
 	init_MUTEX(&private_data->fh_sem);
-	init_MUTEX(&private_data->lock_sem);
+	mutex_init(&private_data->lock_mutex);
 	INIT_LIST_HEAD(&private_data->llist);
 	private_data->pfile = file; /* needed for writepage */
 	private_data->pInode = inode;
@@ -508,12 +508,12 @@ int cifs_close(struct inode *inode, stru
 
 		/* Delete any outstanding lock records.
 		   We'll lose them when the file is closed anyway. */
-		down(&pSMBFile->lock_sem);
+		mutex_lock(&pSMBFile->lock_mutex);
 		list_for_each_entry_safe(li, tmp, &pSMBFile->llist, llist) {
 			list_del(&li->llist);
 			kfree(li);
 		}
-		up(&pSMBFile->lock_sem);
+		mutex_unlock(&pSMBFile->lock_mutex);
 
 		write_lock(&GlobalSMBSeslock);
 		list_del(&pSMBFile->flist);
@@ -598,9 +598,9 @@ static int store_file_lock(struct cifsFi
 	li->offset = offset;
 	li->length = len;
 	li->type = lockType;
-	down(&fid->lock_sem);
+	mutex_lock(&fid->lock_mutex);
 	list_add(&li->llist, &fid->llist);
-	up(&fid->lock_sem);
+	mutex_unlock(&fid->lock_mutex);
 	return 0;
 }
 
@@ -757,7 +757,7 @@ int cifs_lock(struct file *file, int cmd
 			struct cifsLockInfo *li, *tmp;
 
 			rc = 0;
-			down(&fid->lock_sem);
+			mutex_lock(&fid->lock_mutex);
 			list_for_each_entry_safe(li, tmp, &fid->llist, llist) {
 				if (pfLock->fl_start <= li->offset &&
 						length >= li->length) {
@@ -771,7 +771,7 @@ int cifs_lock(struct file *file, int cmd
 					kfree(li);
 				}
 			}
-			up(&fid->lock_sem);
+			mutex_unlock(&fid->lock_mutex);
 		}
 	}
 
#<EOF>
