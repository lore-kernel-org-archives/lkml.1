Return-Path: <linux-kernel-owner+w=401wt.eu-S1756754AbZEQCNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754AbZEQCNw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 22:13:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752176AbZEQCNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 22:13:42 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50931 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752001AbZEQCNl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 22:13:41 -0400
Date: Sat, 16 May 2009 22:13:31 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Luca Tettamanti <kronos.it@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-cifs-client@lists.samba.org,
       Shirish Pargaonkar <shirishpargaonkar@gmail.com>,
       Steve French <smfrench@gmail.com>
Subject: Re: [linux-cifs-client] Re: [2.6.30-rc6] cifs_close: NULL pointer
 dereference
Message-ID: <20090516221331.0a456cbb@tlielax.poochiereds.net>
In-Reply-To: <20090516205558.GA20346@nb-core2.darkstar.lan>
References: <20090516162813.GA18098@nb-core2.darkstar.lan>
	<20090516205558.GA20346@nb-core2.darkstar.lan>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/vTKMz55mR12wc1/keQTr9dT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/vTKMz55mR12wc1/keQTr9dT
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sat, 16 May 2009 22:55:58 +0200
Luca Tettamanti <kronos.it@gmail.com> wrote:

> On Sat, May 16, 2009 at 06:28:13PM +0200, Luca Tettamanti wrote:
> > Hello,
> > I just hit a NULL pointer dereference in cifs_close while accessing a file on a
> > remote Samba shared directory.
> [...]
> > BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
> > IP: [<ffffffffa05f105c>] cifs_close+0x1c1/0x2e8 [cifs]
> 
> Ok, I've reproduced this on a machine with a serial port :)
> 
> 0xffffffff803574e0 in list_del (entry=0xffff8800ac184210)
> at /home/kronos/src/linux-2.6.git/lib/list_debug.c:46
> 46              WARN(entry->prev->next != entry,
> (gdb) bt
> #0  0xffffffff803574e0 in list_del (entry=0xffff8800ac184210)
>     at /home/kronos/src/linux-2.6.git/lib/list_debug.c:46
> #1  0xffffffff80319588 in cifs_close (inode=0xffff8800b8d5f088, file=0xffff8800ad8f6d00)
>     at /home/kronos/src/linux-2.6.git/fs/cifs/file.c:670
> #2  0xffffffff8029d95e in __fput (file=0xffff8800ad8f6d00)
>     at /home/kronos/src/linux-2.6.git/fs/file_table.c:281
> #3  0xffffffff8029da32 in fput (file=0xffff8800ac184210)
>     at /home/kronos/src/linux-2.6.git/fs/file_table.c:227
> #4  0xffffffff8029ad30 in filp_close (filp=0xffff8800ad8f6d00, id=0xffff880037a3e080)
>     at /home/kronos/src/linux-2.6.git/fs/open.c:1108
> #5  0xffffffff8029ade0 in sys_close (fd=0) 
>     at /home/kronos/src/linux-2.6.git/fs/open.c:1137
> #6  0xffffffff802271e4 in sysenter_dispatch ()
>     at /home/kronos/src/linux-2.6.git/arch/x86/ia32/ia32entry.S:161
> #7  0x0000000000000000 in ?? ()
> 
> (gdb) f 1
> #1  0xffffffff80319588 in cifs_close (inode=0xffff8800b8d5f088, file=0xffff8800ad8f6d00)
>     at /home/kronos/src/linux-2.6.git/fs/cifs/file.c:670
> 670                     list_del(&pSMBFile->flist);
> 
> (gdb) p *&pSMBFile->flist
> $2 = {next = 0x0, prev = 0x0}
> 
> (gdb) p *&pSMBFile->tlist
> $5 = {next = 0x0, prev = 0x0}
> 
> So both flist and tlist were not initilized in cifs_open.
> 
> The content of the whole pSMBFile structure:
> 
> (gdb) p *pSMBFile
> $6 = {tlist = {next = 0x0, prev = 0x0}, flist = {next = 0x0, prev = 0x0}, uid = 0, pid = 5322, netfid = 13880,
>   pfile = 0xffff8800ad8f6d00, pInode = 0xffff8800b8d5f088, lock_mutex = {count = {counter = 1}, wait_lock = {raw_lock = {
>         slock = 514}, magic = 3735899821, owner_cpu = 4294967295, owner = 0xffffffffffffffff, dep_map = {
>         key = 0xffffffff806a5c98, class_cache = 0x0, name = 0xffffffff80537308 "&lock->wait_lock"}}, wait_list = {
>       next = 0xffff8800ac184278, prev = 0xffff8800ac184278}, owner = 0x0, name = 0x0, magic = 0xffff8800ac184240, dep_map = {
>       key = 0xffffffff80d7ff50, class_cache = 0xffffffff80835400, name = 0xffffffff8054cdfa "&private_data->lock_mutex"}},
>   llist = {next = 0xffff8800ac1842b8, prev = 0xffff8800ac1842b8}, closePend = true, invalidHandle = false,
>   messageMode = false, wrtPending = {counter = 0}, fh_mutex = {count = {counter = 1}, wait_lock = {raw_lock = {slock = 0},
>       magic = 3735899821, owner_cpu = 4294967295, owner = 0xffffffffffffffff, dep_map = {key = 0xffffffff806a5c98,
>         class_cache = 0x0, name = 0xffffffff80537308 "&lock->wait_lock"}}, wait_list = {next = 0xffff8800ac184308,
>       prev = 0xffff8800ac184308}, owner = 0x0, name = 0x0, magic = 0xffff8800ac1842d0, dep_map = {key = 0xffffffff80d7ff58,
>       class_cache = 0x0, name = 0xffffffff8054cde2 "&private_data->fh_mutex"}}, srch_inf = {index_of_last_entry = 0,
>     entries_in_buffer = 0, info_level = 0, resume_key = 0, ntwrk_buf_start = 0x0, srch_entries_start = 0x0, last_entry = 0x0,
>     presume_name = 0x0, resume_name_len = 0, endOfSearch = false, emptyDir = false, unicode = false, smallBuf = false}}
> 

Luca...thanks for the bug report and analysis. I've been able to
reproduce this too against 3.3.2. The attached patch reverts the open
with lookup intent functionality that was added at the beginning of the
2.6.30 cycle. This fixes the problem for me.

Steve and Shirish...given that we've already seen a couple of
regressions from these patches, I'd like to see them reverted until
they have been better tested.

-- 
Jeff Layton <jlayton@redhat.com>

--MP_/vTKMz55mR12wc1/keQTr9dT
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename=0001--CIFS-Fix-double-list-addition-in-cifs-posix-open-c.patch

>From 90e4ee5d311d4e0729daa676b1d7f754265b5874 Mon Sep 17 00:00:00 2001
From: Steve French <sfrench@us.ibm.com>
Date: Fri, 8 May 2009 03:04:30 +0000
Subject: [PATCH] [CIFS] Fix double list addition in cifs posix open code

Remove adding open file entry twice to lists in the file
Do not fill file info twice in case of posix opens and creates

Signed-off-by: Shirish Pargaonkar <shirishp@us.ibm.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
---
 fs/cifs/dir.c  |   15 +++++++++------
 fs/cifs/file.c |   14 --------------
 2 files changed, 9 insertions(+), 20 deletions(-)

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 461750e..11431ed 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -281,6 +281,7 @@ cifs_create(struct inode *inode, struct dentry *direntry, int mode,
 	int create_options = CREATE_NOT_DIR;
 	int oplock = 0;
 	int oflags;
+	bool posix_create = false;
 	/*
 	 * BB below access is probably too much for mknod to request
 	 *    but we have to do query and setpathinfo so requesting
@@ -328,11 +329,13 @@ cifs_create(struct inode *inode, struct dentry *direntry, int mode,
 		   negotation.  EREMOTE indicates DFS junction, which is not
 		   handled in posix open */
 
-		if ((rc == 0) && (newinode == NULL))
-			goto cifs_create_get_file_info; /* query inode info */
-		else if (rc == 0) /* success, no need to query */
-			goto cifs_create_set_dentry;
-		else if ((rc != -EIO) && (rc != -EREMOTE) &&
+		if (rc == 0) {
+			posix_create = true;
+			if (newinode == NULL) /* query inode info */
+				goto cifs_create_get_file_info;
+			else /* success, no need to query */
+				goto cifs_create_set_dentry;
+		} else if ((rc != -EIO) && (rc != -EREMOTE) &&
 			 (rc != -EOPNOTSUPP)) /* path not found or net err */
 			goto cifs_create_out;
 		/* else fallthrough to retry, using older open call, this is
@@ -464,7 +467,7 @@ cifs_create_set_dentry:
 	if ((nd == NULL) || (!(nd->flags & LOOKUP_OPEN))) {
 		/* mknod case - do not leave file open */
 		CIFSSMBClose(xid, tcon, fileHandle);
-	} else if (newinode) {
+	} else if (!(posix_create) && (newinode)) {
 			cifs_fill_fileinfo(newinode, fileHandle,
 					cifs_sb->tcon, write_only);
 	}
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 50ca088..38c06f8 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -129,15 +129,12 @@ static inline int cifs_posix_open_inode_helper(struct inode *inode,
 			struct file *file, struct cifsInodeInfo *pCifsInode,
 			struct cifsFileInfo *pCifsFile, int oplock, u16 netfid)
 {
-	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
-/*	struct timespec temp; */   /* BB REMOVEME BB */
 
 	file->private_data = kmalloc(sizeof(struct cifsFileInfo), GFP_KERNEL);
 	if (file->private_data == NULL)
 		return -ENOMEM;
 	pCifsFile = cifs_init_private(file->private_data, inode, file, netfid);
 	write_lock(&GlobalSMBSeslock);
-	list_add(&pCifsFile->tlist, &cifs_sb->tcon->openFileList);
 
 	pCifsInode = CIFS_I(file->f_path.dentry->d_inode);
 	if (pCifsInode == NULL) {
@@ -145,17 +142,6 @@ static inline int cifs_posix_open_inode_helper(struct inode *inode,
 		return -EINVAL;
 	}
 
-	/* want handles we can use to read with first
-	   in the list so we do not have to walk the
-	   list to search for one in write_begin */
-	if ((file->f_flags & O_ACCMODE) == O_WRONLY) {
-		list_add_tail(&pCifsFile->flist,
-			      &pCifsInode->openFileList);
-	} else {
-		list_add(&pCifsFile->flist,
-			 &pCifsInode->openFileList);
-	}
-
 	if (pCifsInode->clientCanCacheRead) {
 		/* we have the inode open somewhere else
 		   no need to discard cache data */
-- 
1.6.0.6


--MP_/vTKMz55mR12wc1/keQTr9dT--
