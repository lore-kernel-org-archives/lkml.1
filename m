Return-Path: <linux-kernel-owner+w=401wt.eu-S1761112AbZGABJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761112AbZGABJf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 21:09:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761528AbZGAAf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:35:28 -0400
Received: from kroah.org ([198.145.64.141]:60577 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761529AbZGAAfU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:35:20 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:38 2009
Message-Id: <20090701002437.962186526@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:24:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jeff Layton <jlayton@redhat.com>,
       Shirish Pargaonkar <shirishp@us.ibm.com>,
       Steve French <sfrench@us.ibm.com>
Subject: [patch 078/108] cifs: fix fh_mutex locking in cifs_reopen_file
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=cifs-fix-fh_mutex-locking-in-cifs_reopen_file.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit f0a71eb820596bd8f6abf64beb4cb181edaa2341 upstream.

Fixes a regression caused by commit a6ce4932fbdbcd8f8e8c6df76812014351c32892

When this lock was converted to a mutex, the locks were turned into
unlocks and vice-versa.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Acked-by: Shirish Pargaonkar <shirishp@us.ibm.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/file.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -491,9 +491,9 @@ static int cifs_reopen_file(struct file 
 		return -EBADF;
 
 	xid = GetXid();
-	mutex_unlock(&pCifsFile->fh_mutex);
+	mutex_lock(&pCifsFile->fh_mutex);
 	if (!pCifsFile->invalidHandle) {
-		mutex_lock(&pCifsFile->fh_mutex);
+		mutex_unlock(&pCifsFile->fh_mutex);
 		FreeXid(xid);
 		return 0;
 	}
@@ -524,7 +524,7 @@ static int cifs_reopen_file(struct file 
 	if (full_path == NULL) {
 		rc = -ENOMEM;
 reopen_error_exit:
-		mutex_lock(&pCifsFile->fh_mutex);
+		mutex_unlock(&pCifsFile->fh_mutex);
 		FreeXid(xid);
 		return rc;
 	}
@@ -566,14 +566,14 @@ reopen_error_exit:
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


