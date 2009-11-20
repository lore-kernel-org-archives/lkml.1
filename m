Return-Path: <linux-kernel-owner+w=401wt.eu-S1754551AbZKTQmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551AbZKTQmP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 11:42:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754466AbZKTQmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 11:42:13 -0500
Received: from cantor.suse.de ([195.135.220.2]:41560 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754266AbZKTQlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 11:41:09 -0500
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, jkacur@redhat.com,
       Arnd Bergmann <arnd@arndb.de>,
       =?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Jamie Lokier <jamie@shareable.org>, Jan Blunck <jblunck@suse.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@infradead.org>,
       Petr Vandrovec <vandrove@vc.cvut.cz>, Anders Larsen <al@alarsen.net>,
       Jan Kara <jack@suse.cz>
Subject: [PATCH 13/15] Do not fallback to default_llseek() when readdir() uses BKL
Date: Fri, 20 Nov 2009 17:40:43 +0100
Message-Id: <1258735245-25826-14-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1258735245-25826-1-git-send-email-jblunck@suse.de>
References: <1258735245-25826-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not use the fallback default_llseek() if the readdir operation of the
filesystem still uses the big kernel lock. Since llseek() modifies
file->f_pos of the directory directly it may need locking to not confuse
readdir which usually uses file->f_pos directly as well. Since the special
characteristics of the BKL (unlocked on schedule) are not necessary in this
case, the inode mutex can be used for locking as provided by
generic_file_llseek(). This is only possible since all filesystems, except
reiserfs, either use a directory as a flat file or with disk address
offsets. Reiserfs on the other hand uses a 32bit hash off the filename as
the offset so generic_file_llseek() can get used as well since the hash is
always smaller than sb->s_maxbytes (= (512 << 32) - blocksize).

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/autofs/root.c          |    1 +
 fs/freevxfs/vxfs_lookup.c |    2 ++
 fs/isofs/dir.c            |    1 +
 fs/ncpfs/dir.c            |    1 +
 fs/qnx4/dir.c             |    1 +
 fs/reiserfs/dir.c         |    1 +
 fs/smbfs/dir.c            |    1 +
 fs/udf/dir.c              |    1 +
 8 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/fs/autofs/root.c b/fs/autofs/root.c
index 4a1401c..d3aec77 100644
--- a/fs/autofs/root.c
+++ b/fs/autofs/root.c
@@ -30,6 +30,7 @@ const struct file_operations autofs_root_operations = {
 	.read		= generic_read_dir,
 	.readdir	= autofs_root_readdir,
 	.ioctl		= autofs_root_ioctl,
+	.llseek		= generic_file_llseek,
 };
 
 const struct inode_operations autofs_root_inode_operations = {
diff --git a/fs/freevxfs/vxfs_lookup.c b/fs/freevxfs/vxfs_lookup.c
index aee049c..0ec7bb2 100644
--- a/fs/freevxfs/vxfs_lookup.c
+++ b/fs/freevxfs/vxfs_lookup.c
@@ -57,6 +57,8 @@ const struct inode_operations vxfs_dir_inode_ops = {
 };
 
 const struct file_operations vxfs_dir_operations = {
+	.llseek =		generic_file_llseek,
+	.read =			generic_read_dir,
 	.readdir =		vxfs_readdir,
 };
 
diff --git a/fs/isofs/dir.c b/fs/isofs/dir.c
index 8ba5441..4816bd3 100644
--- a/fs/isofs/dir.c
+++ b/fs/isofs/dir.c
@@ -271,6 +271,7 @@ static int isofs_readdir(struct file *filp,
 
 const struct file_operations isofs_dir_operations =
 {
+	.llseek = generic_file_llseek,
 	.read = generic_read_dir,
 	.readdir = isofs_readdir,
 };
diff --git a/fs/ncpfs/dir.c b/fs/ncpfs/dir.c
index b8b5b30..c9cad9a 100644
--- a/fs/ncpfs/dir.c
+++ b/fs/ncpfs/dir.c
@@ -50,6 +50,7 @@ extern int ncp_symlink(struct inode *, struct dentry *, const char *);
 		      
 const struct file_operations ncp_dir_operations =
 {
+	.llseek		= generic_file_llseek,
 	.read		= generic_read_dir,
 	.readdir	= ncp_readdir,
 	.ioctl		= ncp_ioctl,
diff --git a/fs/qnx4/dir.c b/fs/qnx4/dir.c
index 86cc39c..da40f9b 100644
--- a/fs/qnx4/dir.c
+++ b/fs/qnx4/dir.c
@@ -77,6 +77,7 @@ out:
 
 const struct file_operations qnx4_dir_operations =
 {
+	.llseek		= generic_file_llseek,
 	.read		= generic_read_dir,
 	.readdir	= qnx4_readdir,
 	.fsync		= simple_fsync,
diff --git a/fs/reiserfs/dir.c b/fs/reiserfs/dir.c
index 6d2668f..fa616a1 100644
--- a/fs/reiserfs/dir.c
+++ b/fs/reiserfs/dir.c
@@ -17,6 +17,7 @@ static int reiserfs_dir_fsync(struct file *filp, struct dentry *dentry,
 			      int datasync);
 
 const struct file_operations reiserfs_dir_operations = {
+	.llseek = generic_file_llseek,
 	.read = generic_read_dir,
 	.readdir = reiserfs_readdir,
 	.fsync = reiserfs_dir_fsync,
diff --git a/fs/smbfs/dir.c b/fs/smbfs/dir.c
index 3e4803b..cd11c54 100644
--- a/fs/smbfs/dir.c
+++ b/fs/smbfs/dir.c
@@ -37,6 +37,7 @@ static int smb_link(struct dentry *, struct inode *, struct dentry *);
 
 const struct file_operations smb_dir_operations =
 {
+	.llseek		= generic_file_llseek,
 	.read		= generic_read_dir,
 	.readdir	= smb_readdir,
 	.ioctl		= smb_ioctl,
diff --git a/fs/udf/dir.c b/fs/udf/dir.c
index 61d9a76..475cc49 100644
--- a/fs/udf/dir.c
+++ b/fs/udf/dir.c
@@ -207,6 +207,7 @@ static int udf_readdir(struct file *filp, void *dirent, filldir_t filldir)
 
 /* readdir and lookup functions */
 const struct file_operations udf_dir_operations = {
+	.llseek			= generic_file_llseek,
 	.read			= generic_read_dir,
 	.readdir		= udf_readdir,
 	.ioctl			= udf_ioctl,
-- 
1.6.4.2

