Return-Path: <linux-kernel-owner+w=401wt.eu-S1757560AbZEQCRH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560AbZEQCRH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 22:17:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752328AbZEQCQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 22:16:53 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39150 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752001AbZEQCQw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 22:16:52 -0400
Date: Sat, 16 May 2009 22:16:27 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: Luca Tettamanti <kronos.it@gmail.com>, Shirish@samba.org,
       linux-cifs-client@lists.samba.org, linux-kernel@vger.kernel.org,
       Steve French <smfrench@gmail.com>
Subject: Re: [linux-cifs-client] Re: [2.6.30-rc6] cifs_close: NULL pointer
 dereference
Message-ID: <20090516221627.398e0680@tlielax.poochiereds.net>
In-Reply-To: <20090516221331.0a456cbb@tlielax.poochiereds.net>
References: <20090516162813.GA18098@nb-core2.darkstar.lan>
	<20090516205558.GA20346@nb-core2.darkstar.lan>
	<20090516221331.0a456cbb@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/amU9RW46AX6yJd=+tMWbg0o"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/amU9RW46AX6yJd=+tMWbg0o
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sat, 16 May 2009 22:13:31 -0400
Jeff Layton <jlayton@redhat.com> wrote:

> On Sat, 16 May 2009 22:55:58 +0200
> Luca Tettamanti <kronos.it@gmail.com> wrote:
> 
> > On Sat, May 16, 2009 at 06:28:13PM +0200, Luca Tettamanti wrote:
> > > Hello,
> > > I just hit a NULL pointer dereference in cifs_close while accessing a file on a
> > > remote Samba shared directory.
> > [...]
> > > BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
> > > IP: [<ffffffffa05f105c>] cifs_close+0x1c1/0x2e8 [cifs]
> > 
> > Ok, I've reproduced this on a machine with a serial port :)
> > 
> > 0xffffffff803574e0 in list_del (entry=0xffff8800ac184210)
> > at /home/kronos/src/linux-2.6.git/lib/list_debug.c:46
> > 46              WARN(entry->prev->next != entry,
> > (gdb) bt
> > #0  0xffffffff803574e0 in list_del (entry=0xffff8800ac184210)
> >     at /home/kronos/src/linux-2.6.git/lib/list_debug.c:46
> > #1  0xffffffff80319588 in cifs_close (inode=0xffff8800b8d5f088, file=0xffff8800ad8f6d00)
> >     at /home/kronos/src/linux-2.6.git/fs/cifs/file.c:670
> > #2  0xffffffff8029d95e in __fput (file=0xffff8800ad8f6d00)
> >     at /home/kronos/src/linux-2.6.git/fs/file_table.c:281
> > #3  0xffffffff8029da32 in fput (file=0xffff8800ac184210)
> >     at /home/kronos/src/linux-2.6.git/fs/file_table.c:227
> > #4  0xffffffff8029ad30 in filp_close (filp=0xffff8800ad8f6d00, id=0xffff880037a3e080)
> >     at /home/kronos/src/linux-2.6.git/fs/open.c:1108
> > #5  0xffffffff8029ade0 in sys_close (fd=0) 
> >     at /home/kronos/src/linux-2.6.git/fs/open.c:1137
> > #6  0xffffffff802271e4 in sysenter_dispatch ()
> >     at /home/kronos/src/linux-2.6.git/arch/x86/ia32/ia32entry.S:161
> > #7  0x0000000000000000 in ?? ()
> > 
> > (gdb) f 1
> > #1  0xffffffff80319588 in cifs_close (inode=0xffff8800b8d5f088, file=0xffff8800ad8f6d00)
> >     at /home/kronos/src/linux-2.6.git/fs/cifs/file.c:670
> > 670                     list_del(&pSMBFile->flist);
> > 
> > (gdb) p *&pSMBFile->flist
> > $2 = {next = 0x0, prev = 0x0}
> > 
> > (gdb) p *&pSMBFile->tlist
> > $5 = {next = 0x0, prev = 0x0}
> > 
> > So both flist and tlist were not initilized in cifs_open.
> > 
> > The content of the whole pSMBFile structure:
> > 
> > (gdb) p *pSMBFile
> > $6 = {tlist = {next = 0x0, prev = 0x0}, flist = {next = 0x0, prev = 0x0}, uid = 0, pid = 5322, netfid = 13880,
> >   pfile = 0xffff8800ad8f6d00, pInode = 0xffff8800b8d5f088, lock_mutex = {count = {counter = 1}, wait_lock = {raw_lock = {
> >         slock = 514}, magic = 3735899821, owner_cpu = 4294967295, owner = 0xffffffffffffffff, dep_map = {
> >         key = 0xffffffff806a5c98, class_cache = 0x0, name = 0xffffffff80537308 "&lock->wait_lock"}}, wait_list = {
> >       next = 0xffff8800ac184278, prev = 0xffff8800ac184278}, owner = 0x0, name = 0x0, magic = 0xffff8800ac184240, dep_map = {
> >       key = 0xffffffff80d7ff50, class_cache = 0xffffffff80835400, name = 0xffffffff8054cdfa "&private_data->lock_mutex"}},
> >   llist = {next = 0xffff8800ac1842b8, prev = 0xffff8800ac1842b8}, closePend = true, invalidHandle = false,
> >   messageMode = false, wrtPending = {counter = 0}, fh_mutex = {count = {counter = 1}, wait_lock = {raw_lock = {slock = 0},
> >       magic = 3735899821, owner_cpu = 4294967295, owner = 0xffffffffffffffff, dep_map = {key = 0xffffffff806a5c98,
> >         class_cache = 0x0, name = 0xffffffff80537308 "&lock->wait_lock"}}, wait_list = {next = 0xffff8800ac184308,
> >       prev = 0xffff8800ac184308}, owner = 0x0, name = 0x0, magic = 0xffff8800ac1842d0, dep_map = {key = 0xffffffff80d7ff58,
> >       class_cache = 0x0, name = 0xffffffff8054cde2 "&private_data->fh_mutex"}}, srch_inf = {index_of_last_entry = 0,
> >     entries_in_buffer = 0, info_level = 0, resume_key = 0, ntwrk_buf_start = 0x0, srch_entries_start = 0x0, last_entry = 0x0,
> >     presume_name = 0x0, resume_name_len = 0, endOfSearch = false, emptyDir = false, unicode = false, smallBuf = false}}
> > 
> 
> Luca...thanks for the bug report and analysis. I've been able to
> reproduce this too against 3.3.2. The attached patch reverts the open
> with lookup intent functionality that was added at the beginning of the
> 2.6.30 cycle. This fixes the problem for me.
> 
> Steve and Shirish...given that we've already seen a couple of
> regressions from these patches, I'd like to see them reverted until
> they have been better tested.
> 

Oops, wrong patch...this is the right one.

-- 
Jeff Layton <jlayton@redhat.com>

--MP_/amU9RW46AX6yJd=+tMWbg0o
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename=0001-cifs-revert-patches-to-add-open-on-lookup.patch

>From 7ae9cf299fd28d23d3850ee4a4337e40139a63d7 Mon Sep 17 00:00:00 2001
From: Jeff Layton <jlayton@redhat.com>
Date: Sat, 16 May 2009 22:08:54 -0400
Subject: [PATCH] cifs: revert patches to add open on lookup

This patch reverts the patches for open on lookup functionality
that was added at the beginning of the 2.6.30 cycle. Specifically,
these commits:

a6ce4932fbdbcd8f8e8c6df76812014351c32892
bc8cd4390c9129fbd286b10fa99972dfb68cd069
88dd47fff4891545bfcfdf39146dde8380771766
90e4ee5d311d4e0729daa676b1d7f754265b5874

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/cifs/cifsglob.h |    2 +-
 fs/cifs/dir.c      |  154 ++++++++++++++++++----------------------------------
 fs/cifs/file.c     |   77 ++++++++++++++++----------
 3 files changed, 100 insertions(+), 133 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index a61ab77..f1f858a 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -350,7 +350,7 @@ struct cifsFileInfo {
 	bool invalidHandle:1;	/* file closed via session abend */
 	bool messageMode:1;	/* for pipes: message vs byte mode */
 	atomic_t wrtPending;   /* handle in use - defer close */
-	struct mutex fh_mutex; /* prevents reopen race after dead ses*/
+	struct semaphore fh_sem; /* prevents reopen race after dead ses*/
 	struct cifs_search_info srch_inf;
 };
 
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 11431ed..e457e14 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -129,62 +129,12 @@ cifs_bp_rename_retry:
 	return full_path;
 }
 
-static void
-cifs_fill_fileinfo(struct inode *newinode, __u16 fileHandle,
-			struct cifsTconInfo *tcon, bool write_only)
-{
-	int oplock = 0;
-	struct cifsFileInfo *pCifsFile;
-	struct cifsInodeInfo *pCifsInode;
-
-	pCifsFile = kzalloc(sizeof(struct cifsFileInfo), GFP_KERNEL);
-
-	if (pCifsFile == NULL)
-		return;
-
-	if (oplockEnabled)
-		oplock = REQ_OPLOCK;
-
-	pCifsFile->netfid = fileHandle;
-	pCifsFile->pid = current->tgid;
-	pCifsFile->pInode = newinode;
-	pCifsFile->invalidHandle = false;
-	pCifsFile->closePend = false;
-	mutex_init(&pCifsFile->fh_mutex);
-	mutex_init(&pCifsFile->lock_mutex);
-	INIT_LIST_HEAD(&pCifsFile->llist);
-	atomic_set(&pCifsFile->wrtPending, 0);
-
-	/* set the following in open now
-			pCifsFile->pfile = file; */
-	write_lock(&GlobalSMBSeslock);
-	list_add(&pCifsFile->tlist, &tcon->openFileList);
-	pCifsInode = CIFS_I(newinode);
-	if (pCifsInode) {
-		/* if readable file instance put first in list*/
-		if (write_only)
-			list_add_tail(&pCifsFile->flist,
-				      &pCifsInode->openFileList);
-		else
-			list_add(&pCifsFile->flist, &pCifsInode->openFileList);
-
-		if ((oplock & 0xF) == OPLOCK_EXCLUSIVE) {
-			pCifsInode->clientCanCacheAll = true;
-			pCifsInode->clientCanCacheRead = true;
-			cFYI(1, ("Exclusive Oplock inode %p", newinode));
-		} else if ((oplock & 0xF) == OPLOCK_READ)
-				pCifsInode->clientCanCacheRead = true;
-	}
-	write_unlock(&GlobalSMBSeslock);
-}
-
 int cifs_posix_open(char *full_path, struct inode **pinode,
 		    struct super_block *sb, int mode, int oflags,
 		    int *poplock, __u16 *pnetfid, int xid)
 {
 	int rc;
 	__u32 oplock;
-	bool write_only = false;
 	FILE_UNIX_BASIC_INFO *presp_data;
 	__u32 posix_flags = 0;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
@@ -222,8 +172,6 @@ int cifs_posix_open(char *full_path, struct inode **pinode,
 	if (oflags & O_DIRECT)
 		posix_flags |= SMB_O_DIRECT;
 
-	if (!(oflags & FMODE_READ))
-		write_only = true;
 
 	rc = CIFSPOSIXCreate(xid, cifs_sb->tcon, posix_flags, mode,
 			pnetfid, presp_data, &oplock, full_path,
@@ -252,8 +200,6 @@ int cifs_posix_open(char *full_path, struct inode **pinode,
 
 	posix_fill_in_inode(*pinode, presp_data, 1);
 
-	cifs_fill_fileinfo(*pinode, *pnetfid, cifs_sb->tcon, write_only);
-
 posix_open_ret:
 	kfree(presp_data);
 	return rc;
@@ -281,7 +227,6 @@ cifs_create(struct inode *inode, struct dentry *direntry, int mode,
 	int create_options = CREATE_NOT_DIR;
 	int oplock = 0;
 	int oflags;
-	bool posix_create = false;
 	/*
 	 * BB below access is probably too much for mknod to request
 	 *    but we have to do query and setpathinfo so requesting
@@ -296,6 +241,7 @@ cifs_create(struct inode *inode, struct dentry *direntry, int mode,
 	char *full_path = NULL;
 	FILE_ALL_INFO *buf = NULL;
 	struct inode *newinode = NULL;
+	struct cifsInodeInfo *pCifsInode;
 	int disposition = FILE_OVERWRITE_IF;
 	bool write_only = false;
 
@@ -329,13 +275,11 @@ cifs_create(struct inode *inode, struct dentry *direntry, int mode,
 		   negotation.  EREMOTE indicates DFS junction, which is not
 		   handled in posix open */
 
-		if (rc == 0) {
-			posix_create = true;
-			if (newinode == NULL) /* query inode info */
-				goto cifs_create_get_file_info;
-			else /* success, no need to query */
-				goto cifs_create_set_dentry;
-		} else if ((rc != -EIO) && (rc != -EREMOTE) &&
+		if ((rc == 0) && (newinode == NULL))
+			goto cifs_create_get_file_info; /* query inode info */
+		else if (rc == 0) /* success, no need to query */
+			goto cifs_create_set_dentry;
+		else if ((rc != -EIO) && (rc != -EREMOTE) &&
 			 (rc != -EOPNOTSUPP)) /* path not found or net err */
 			goto cifs_create_out;
 		/* else fallthrough to retry, using older open call, this is
@@ -467,9 +411,45 @@ cifs_create_set_dentry:
 	if ((nd == NULL) || (!(nd->flags & LOOKUP_OPEN))) {
 		/* mknod case - do not leave file open */
 		CIFSSMBClose(xid, tcon, fileHandle);
-	} else if (!(posix_create) && (newinode)) {
-			cifs_fill_fileinfo(newinode, fileHandle,
-					cifs_sb->tcon, write_only);
+	} else if (newinode) {
+		struct cifsFileInfo *pCifsFile =
+			kzalloc(sizeof(struct cifsFileInfo), GFP_KERNEL);
+
+		if (pCifsFile == NULL)
+			goto cifs_create_out;
+		pCifsFile->netfid = fileHandle;
+		pCifsFile->pid = current->tgid;
+		pCifsFile->pInode = newinode;
+		pCifsFile->invalidHandle = false;
+		pCifsFile->closePend     = false;
+		init_MUTEX(&pCifsFile->fh_sem);
+		mutex_init(&pCifsFile->lock_mutex);
+		INIT_LIST_HEAD(&pCifsFile->llist);
+		atomic_set(&pCifsFile->wrtPending, 0);
+
+		/* set the following in open now
+				pCifsFile->pfile = file; */
+		write_lock(&GlobalSMBSeslock);
+		list_add(&pCifsFile->tlist, &tcon->openFileList);
+		pCifsInode = CIFS_I(newinode);
+		if (pCifsInode) {
+			/* if readable file instance put first in list*/
+			if (write_only) {
+				list_add_tail(&pCifsFile->flist,
+					      &pCifsInode->openFileList);
+			} else {
+				list_add(&pCifsFile->flist,
+					 &pCifsInode->openFileList);
+			}
+			if ((oplock & 0xF) == OPLOCK_EXCLUSIVE) {
+				pCifsInode->clientCanCacheAll = true;
+				pCifsInode->clientCanCacheRead = true;
+				cFYI(1, ("Exclusive Oplock inode %p",
+					newinode));
+			} else if ((oplock & 0xF) == OPLOCK_READ)
+				pCifsInode->clientCanCacheRead = true;
+		}
+		write_unlock(&GlobalSMBSeslock);
 	}
 cifs_create_out:
 	kfree(buf);
@@ -602,21 +582,17 @@ int cifs_mknod(struct inode *inode, struct dentry *direntry, int mode,
 	return rc;
 }
 
+
 struct dentry *
 cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 	    struct nameidata *nd)
 {
 	int xid;
 	int rc = 0; /* to get around spurious gcc warning, set to zero here */
-	int oplock = 0;
-	int mode;
-	__u16 fileHandle = 0;
-	bool posix_open = false;
 	struct cifs_sb_info *cifs_sb;
 	struct cifsTconInfo *pTcon;
 	struct inode *newInode = NULL;
 	char *full_path = NULL;
-	struct file *filp;
 
 	xid = GetXid();
 
@@ -658,37 +634,12 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 	}
 	cFYI(1, ("Full path: %s inode = 0x%p", full_path, direntry->d_inode));
 
-	if (pTcon->unix_ext) {
-		if (!(nd->flags & (LOOKUP_PARENT | LOOKUP_DIRECTORY)) &&
-				(nd->flags & LOOKUP_OPEN)) {
-			if (!((nd->intent.open.flags & O_CREAT) &&
-					(nd->intent.open.flags & O_EXCL))) {
-				mode = nd->intent.open.create_mode &
-						~current_umask();
-				rc = cifs_posix_open(full_path, &newInode,
-					parent_dir_inode->i_sb, mode,
-					nd->intent.open.flags, &oplock,
-					&fileHandle, xid);
-				/*
-				 * This code works around a bug in
-				 * samba posix open in samba versions 3.3.1
-				 * and earlier where create works
-				 * but open fails with invalid parameter.
-				 * If either of these error codes are
-				 * returned, follow the normal lookup.
-				 * Otherwise, the error during posix open
-				 * is handled.
-				 */
-				if ((rc != -EINVAL) && (rc != -EOPNOTSUPP))
-					posix_open = true;
-			}
-		}
-		if (!posix_open)
-			rc = cifs_get_inode_info_unix(&newInode, full_path,
-						parent_dir_inode->i_sb, xid);
-	} else
+	if (pTcon->unix_ext)
+		rc = cifs_get_inode_info_unix(&newInode, full_path,
+					      parent_dir_inode->i_sb, xid);
+	else
 		rc = cifs_get_inode_info(&newInode, full_path, NULL,
-				parent_dir_inode->i_sb, xid, NULL);
+					 parent_dir_inode->i_sb, xid, NULL);
 
 	if ((rc == 0) && (newInode != NULL)) {
 		if (pTcon->nocase)
@@ -696,8 +647,7 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 		else
 			direntry->d_op = &cifs_dentry_ops;
 		d_add(direntry, newInode);
-		if (posix_open)
-			filp = lookup_instantiate_filp(nd, direntry, NULL);
+
 		/* since paths are not looked up by component - the parent
 		   directories are presumed to be good here */
 		renew_parental_timestamps(direntry);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 38c06f8..dfd3e6c 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -46,7 +46,7 @@ static inline struct cifsFileInfo *cifs_init_private(
 	memset(private_data, 0, sizeof(struct cifsFileInfo));
 	private_data->netfid = netfid;
 	private_data->pid = current->tgid;
-	mutex_init(&private_data->fh_mutex);
+	init_MUTEX(&private_data->fh_sem);
 	mutex_init(&private_data->lock_mutex);
 	INIT_LIST_HEAD(&private_data->llist);
 	private_data->pfile = file; /* needed for writepage */
@@ -129,12 +129,15 @@ static inline int cifs_posix_open_inode_helper(struct inode *inode,
 			struct file *file, struct cifsInodeInfo *pCifsInode,
 			struct cifsFileInfo *pCifsFile, int oplock, u16 netfid)
 {
+	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+/*	struct timespec temp; */   /* BB REMOVEME BB */
 
 	file->private_data = kmalloc(sizeof(struct cifsFileInfo), GFP_KERNEL);
 	if (file->private_data == NULL)
 		return -ENOMEM;
 	pCifsFile = cifs_init_private(file->private_data, inode, file, netfid);
 	write_lock(&GlobalSMBSeslock);
+	list_add(&pCifsFile->tlist, &cifs_sb->tcon->openFileList);
 
 	pCifsInode = CIFS_I(file->f_path.dentry->d_inode);
 	if (pCifsInode == NULL) {
@@ -142,6 +145,17 @@ static inline int cifs_posix_open_inode_helper(struct inode *inode,
 		return -EINVAL;
 	}
 
+	/* want handles we can use to read with first
+	   in the list so we do not have to walk the
+	   list to search for one in write_begin */
+	if ((file->f_flags & O_ACCMODE) == O_WRONLY) {
+		list_add_tail(&pCifsFile->flist,
+			      &pCifsInode->openFileList);
+	} else {
+		list_add(&pCifsFile->flist,
+			 &pCifsInode->openFileList);
+	}
+
 	if (pCifsInode->clientCanCacheRead) {
 		/* we have the inode open somewhere else
 		   no need to discard cache data */
@@ -270,32 +284,35 @@ int cifs_open(struct inode *inode, struct file *file)
 	cifs_sb = CIFS_SB(inode->i_sb);
 	tcon = cifs_sb->tcon;
 
-	/* search inode for this file and fill in file->private_data */
-	pCifsInode = CIFS_I(file->f_path.dentry->d_inode);
-	read_lock(&GlobalSMBSeslock);
-	list_for_each(tmp, &pCifsInode->openFileList) {
-		pCifsFile = list_entry(tmp, struct cifsFileInfo,
-				       flist);
-		if ((pCifsFile->pfile == NULL) &&
-		    (pCifsFile->pid == current->tgid)) {
-			/* mode set in cifs_create */
-
-			/* needed for writepage */
-			pCifsFile->pfile = file;
-
-			file->private_data = pCifsFile;
-			break;
+	if (file->f_flags & O_CREAT) {
+		/* search inode for this file and fill in file->private_data */
+		pCifsInode = CIFS_I(file->f_path.dentry->d_inode);
+		read_lock(&GlobalSMBSeslock);
+		list_for_each(tmp, &pCifsInode->openFileList) {
+			pCifsFile = list_entry(tmp, struct cifsFileInfo,
+					       flist);
+			if ((pCifsFile->pfile == NULL) &&
+			    (pCifsFile->pid == current->tgid)) {
+				/* mode set in cifs_create */
+
+				/* needed for writepage */
+				pCifsFile->pfile = file;
+
+				file->private_data = pCifsFile;
+				break;
+			}
+		}
+		read_unlock(&GlobalSMBSeslock);
+		if (file->private_data != NULL) {
+			rc = 0;
+			FreeXid(xid);
+			return rc;
+		} else {
+			if (file->f_flags & O_EXCL)
+				cERROR(1, ("could not find file instance for "
+					   "new file %p", file));
 		}
 	}
-	read_unlock(&GlobalSMBSeslock);
-
-	if (file->private_data != NULL) {
-		rc = 0;
-		FreeXid(xid);
-		return rc;
-	} else if ((file->f_flags & O_CREAT) && (file->f_flags & O_EXCL))
-			cERROR(1, ("could not find file instance for "
-				   "new file %p", file));
 
 	full_path = build_path_from_dentry(file->f_path.dentry);
 	if (full_path == NULL) {
@@ -483,9 +500,9 @@ static int cifs_reopen_file(struct file *file, bool can_flush)
 		return -EBADF;
 
 	xid = GetXid();
-	mutex_unlock(&pCifsFile->fh_mutex);
+	down(&pCifsFile->fh_sem);
 	if (!pCifsFile->invalidHandle) {
-		mutex_lock(&pCifsFile->fh_mutex);
+		up(&pCifsFile->fh_sem);
 		FreeXid(xid);
 		return 0;
 	}
@@ -516,7 +533,7 @@ static int cifs_reopen_file(struct file *file, bool can_flush)
 	if (full_path == NULL) {
 		rc = -ENOMEM;
 reopen_error_exit:
-		mutex_lock(&pCifsFile->fh_mutex);
+		up(&pCifsFile->fh_sem);
 		FreeXid(xid);
 		return rc;
 	}
@@ -558,14 +575,14 @@ reopen_error_exit:
 			 cifs_sb->local_nls, cifs_sb->mnt_cifs_flags &
 				CIFS_MOUNT_MAP_SPECIAL_CHR);
 	if (rc) {
-		mutex_lock(&pCifsFile->fh_mutex);
+		up(&pCifsFile->fh_sem);
 		cFYI(1, ("cifs_open returned 0x%x", rc));
 		cFYI(1, ("oplock: %d", oplock));
 	} else {
 reopen_success:
 		pCifsFile->netfid = netfid;
 		pCifsFile->invalidHandle = false;
-		mutex_lock(&pCifsFile->fh_mutex);
+		up(&pCifsFile->fh_sem);
 		pCifsInode = CIFS_I(inode);
 		if (pCifsInode) {
 			if (can_flush) {
-- 
1.6.2.2


--MP_/amU9RW46AX6yJd=+tMWbg0o--
