Return-Path: <linux-kernel-owner+w=401wt.eu-S1753338AbZF0LFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbZF0LFH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 07:05:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751216AbZF0LE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 07:04:56 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.123]:63462 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbZF0LEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 07:04:55 -0400
From: Jeff Layton <jlayton@redhat.com>
To: linux-cifs-client@lists.samba.org
Cc: smfrench@gmail.com, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] cifs: fix fh_mutex locking in cifs_reopen_file
Date: Sat, 27 Jun 2009 07:04:55 -0400
Message-Id: <1246100695-10344-1-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes a regression caused by commit a6ce4932fbdbcd8f8e8c6df76812014351c32892

When this lock was converted to a mutex, the locks were turned into
unlocks and vice-versa.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Cc: Stable Tree <stable@kernel.org>
---
 fs/cifs/file.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index ebdbe62..97ce4bf 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -493,9 +493,9 @@ static int cifs_reopen_file(struct file *file, bool can_flush)
 		return -EBADF;
 
 	xid = GetXid();
-	mutex_unlock(&pCifsFile->fh_mutex);
+	mutex_lock(&pCifsFile->fh_mutex);
 	if (!pCifsFile->invalidHandle) {
-		mutex_lock(&pCifsFile->fh_mutex);
+		mutex_unlock(&pCifsFile->fh_mutex);
 		rc = 0;
 		FreeXid(xid);
 		return rc;
@@ -527,7 +527,7 @@ static int cifs_reopen_file(struct file *file, bool can_flush)
 	if (full_path == NULL) {
 		rc = -ENOMEM;
 reopen_error_exit:
-		mutex_lock(&pCifsFile->fh_mutex);
+		mutex_unlock(&pCifsFile->fh_mutex);
 		FreeXid(xid);
 		return rc;
 	}
@@ -569,14 +569,14 @@ reopen_error_exit:
 			 cifs_sb->local_nls, cifs_sb->mnt_cifs_flags &
 				CIFS_MOUNT_MAP_SPECIAL_CHR);
 	if (rc) {
-		mutex_lock(&pCifsFile->fh_mutex);
+		mutex_unlock(&pCifsFile->fh_mutex);
 		cFYI(1, ("cifs_open returned 0x%x", rc));
 		cFYI(1, ("oplock: %d", oplock));
 	} else {
 reopen_success:
 		pCifsFile->netfid = netfid;
 		pCifsFile->invalidHandle = false;
-		mutex_lock(&pCifsFile->fh_mutex);
+		mutex_unlock(&pCifsFile->fh_mutex);
 		pCifsInode = CIFS_I(inode);
 		if (pCifsInode) {
 			if (can_flush) {
-- 
1.6.0.6

