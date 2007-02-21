Return-Path: <linux-kernel-owner+w=401wt.eu-S1161206AbXBUKHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161206AbXBUKHq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 05:07:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161214AbXBUKHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 05:07:45 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:45821 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161206AbXBUKHo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 05:07:44 -0500
To: linux-kernel@vger.kernel.org
CC: ecryptfs-devel@lists.sourceforge.net, devel@openvz.org
Subject: [PATCH] ecryptfs lower_file largefile issue
From: Dmitriy Monakhov <dmonakhov@sw.ru>
Date: Wed, 21 Feb 2007 13:07:22 +0300
Message-ID: <871wkju8md.fsf@sw.ru>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

Where is largefile issue in ecryptfs.
Even if we want open file on ia32 with explicit O_LARGEFILE, lower_file will
be opened without O_LARGEFILE flag  this result in various errors in dmesg
and data corruption.
Testcase:
  #### write 'a' chars beyond 2Gb
  # strace ./writer_test root/file
  open("root/file", O_WRONLY|O_CREAT|O_LARGEFILE, 0666) = 3
  lseek(3, 2147483640, SEEK_SET)          = 2147483640
  write(3, "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"..., 10240) = 10240
  ##check content
  # hexdump root/file4 
  0000000 0000 0000 0000 0000 0000 0000 0000 0000
  *
  7ffffff0 0000 0000 0000 0000 6161 6161 6161 6161
  80000000 6161 6161 6161 6161 6161 6161 6161 6161
  *
  800027f0 6161 6161 6161 6161                    
  800027f8
  
  #umount root 
  # mount -tecryptfs pr/dir/ root/  -ocipher=aes
  ## check content after remount
  # hexdump root/file4 
  0000000 0000 0000 0000 0000 0000 0000 0000 0000
  *
  7ffffff0 0000 0000 0000 0000 6161 6161 6161 6161
  80000000 6161 6161 6161 6161 6161 6161 6161 6161
  *
  800027f0 6161 6161 6161 6161 0000 0000 0000 0000
  80002800 0000 0000 0000 0000 0000 0000 0000 0000
  *
  80003000 ee3d e793 c410 3bd4 c642 5774 ad71 7932
  80003010 17a6 443c 4621 9e4a cf15 babd 19d0 f5e7
  *
  80004000 ce32 49ed 217c f87d 5539 3e96 517c 961c
  80004010 17a6 443c 4621 9e4a cf15 babd 19d0 f5e7
  *
  80005000  
  ### Wow content was changed, kernel complain with folowing messages:
  Error opening lower file for lower_dentry [0xf73a111c], lower_mnt [0xf7d8b1c0], and flags [0x0]
  Error opening lower_file to read header region
  Error attempting to read the [user.ecryptfs] xattr from the lower file; return value = [4294967201]
  Valid metadata not found in header region or xattr region; treating file as unencrypted
  
Lets explicitly add O_LARGEFILE to opened lower file flags as it done in unionfs
and nfsd. Also remove unnecessery #define from ecryptfs_initialize_file().
Signed-off-by: Dmitriy Monakhov <dmonakhov@openvz.org>


--=-=-=
Content-Disposition: inline; filename=diff-mm-ecryptfs-largefile-fix

diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
index bd969ad..7a7d25d 100644
--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -205,6 +205,7 @@ int ecryptfs_open_lower_file(struct file **lower_file,
 {
 	int rc = 0;
 
+	flags |= O_LARGEFILE;
 	dget(lower_dentry);
 	mntget(lower_mnt);
 	*lower_file = dentry_open(lower_dentry, lower_mnt, flags);
diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 27fd14a..a1fe8b4 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -200,9 +200,6 @@ static int ecryptfs_initialize_file(struct dentry *ecryptfs_dentry)
 	inode = ecryptfs_dentry->d_inode;
 	crypt_stat = &ecryptfs_inode_to_private(inode)->crypt_stat;
 	lower_flags = ((O_CREAT | O_TRUNC) & O_ACCMODE) | O_RDWR;
-#if BITS_PER_LONG != 32
-	lower_flags |= O_LARGEFILE;
-#endif
 	lower_mnt = ecryptfs_dentry_to_lower_mnt(ecryptfs_dentry);
 	/* Corresponding fput() at end of this function */
 	if ((rc = ecryptfs_open_lower_file(&lower_file, lower_dentry, lower_mnt,

--=-=-=--

