Return-Path: <linux-kernel-owner+w=401wt.eu-S1760283AbXKAXJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760283AbXKAXJs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 19:09:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755303AbXKAXIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 19:08:40 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:33756 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754905AbXKAXIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 19:08:38 -0400
Subject: [PATCH 05/27] rename open_namei() to open_pathname()
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, miklos@szeredi.hu, hch@infradead.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Thu, 01 Nov 2007 16:08:32 -0700
References: <20071101230826.9A4F6E00@kernel>
In-Reply-To: <20071101230826.9A4F6E00@kernel>
Message-Id: <20071101230832.9835ED1E@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


open_namei() no longer touches namei's.  rename it
to something more appropriate: open_pathname().

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 linux-2.6.git-dave/drivers/usb/gadget/file_storage.c |    4 ++--
 linux-2.6.git-dave/fs/exec.c                         |    2 +-
 linux-2.6.git-dave/fs/namei.c                        |    8 ++++----
 linux-2.6.git-dave/fs/open.c                         |    6 ------
 linux-2.6.git-dave/fs/reiserfs/journal.c             |    2 +-
 linux-2.6.git-dave/kernel/acct.c                     |    2 +-
 linux-2.6.git-dave/mm/swapfile.c                     |    4 ++--
 linux-2.6.git-dave/sound/sound_firmware.c            |    2 +-
 8 files changed, 12 insertions(+), 18 deletions(-)

diff -puN drivers/usb/gadget/file_storage.c~rename-open_namei drivers/usb/gadget/file_storage.c
--- linux-2.6.git/drivers/usb/gadget/file_storage.c~rename-open_namei	2007-11-01 14:46:07.000000000 -0700
+++ linux-2.6.git-dave/drivers/usb/gadget/file_storage.c	2007-11-01 14:46:07.000000000 -0700
@@ -3473,12 +3473,12 @@ static int open_backing_file(struct lun 
 	/* R/W if we can, R/O if we must */
 	ro = curlun->ro;
 	if (!ro) {
-		filp = open_namei(AT_FDCWD, filename, O_RDWR | mode, 0);
+		filp = open_pathname(AT_FDCWD, filename, O_RDWR | mode, 0);
 		if (-EROFS == PTR_ERR(filp))
 			ro = 1;
 	}
 	if (ro)
-		filp = open_namei(AT_FDCWD, filename, O_RDONLY | mode, 0);
+		filp = open_pathname(AT_FDCWD, filename, O_RDONLY | mode, 0);
 	if (IS_ERR(filp)) {
 		LINFO(curlun, "unable to open backing file: %s\n", filename);
 		return PTR_ERR(filp);
diff -puN fs/exec.c~rename-open_namei fs/exec.c
--- linux-2.6.git/fs/exec.c~rename-open_namei	2007-11-01 14:46:07.000000000 -0700
+++ linux-2.6.git-dave/fs/exec.c	2007-11-01 14:46:07.000000000 -0700
@@ -1763,7 +1763,7 @@ int do_coredump(long signr, int exit_cod
  			goto fail_unlock;
  		}
  	} else
-		file = open_namei(AT_FDCWD, corename,
+		file = open_pathname(AT_FDCWD, corename,
 				 O_CREAT | 2 | O_NOFOLLOW | O_LARGEFILE | flag,
 				 0600);
 	if (IS_ERR(file))
diff -puN fs/namei.c~rename-open_namei fs/namei.c
--- linux-2.6.git/fs/namei.c~rename-open_namei	2007-11-01 14:46:07.000000000 -0700
+++ linux-2.6.git-dave/fs/namei.c	2007-11-01 14:46:07.000000000 -0700
@@ -81,7 +81,7 @@
  */
 
 /* [16-Dec-97 Kevin Buhr] For security reasons, we change some symlink
- * semantics.  See the comments in "open_namei" and "do_link" below.
+ * semantics.  See the comments in "open_pathname" and "do_link" below.
  *
  * [10-Sep-98 Alan Modra] Another symlink change.
  */
@@ -571,7 +571,7 @@ out:
 	if (nd->depth || res || nd->last_type!=LAST_NORM)
 		return res;
 	/*
-	 * If it is an iterative symlinks resolution in open_namei() we
+	 * If it is an iterative symlinks resolution in open_pathname() we
 	 * have to copy the last component. And all that crap because of
 	 * bloody create() on broken symlinks. Furrfu...
 	 */
@@ -1708,7 +1708,7 @@ static int __open_namei_create(struct na
  *	01 - read-permission
  *	10 - write-permission
  *	11 - read-write
- * for the internal routines (ie open_namei()/follow_link() etc)
+ * for the internal routines (ie open_pathname()/follow_link() etc)
  * This is more logical, and also allows the 00 "no perm needed"
  * to be used for symlinks (where the permissions are checked
  * later).
@@ -1722,7 +1722,7 @@ static inline int sys_open_flags_to_name
 }
 
 /*
- *	open_namei()
+ *	open_pathname()
  *
  * namei for open - this is in fact almost the whole open-routine.
  *
diff -puN fs/open.c~rename-open_namei fs/open.c
--- linux-2.6.git/fs/open.c~rename-open_namei	2007-11-01 14:46:07.000000000 -0700
+++ linux-2.6.git-dave/fs/open.c	2007-11-01 14:46:07.000000000 -0700
@@ -800,12 +800,6 @@ cleanup_file:
 	return ERR_PTR(error);
 }
 
-struct file *filp_open(const char *filename, int flags, int mode)
-{
-	return open_namei(AT_FDCWD, filename, flags, mode);
-}
-EXPORT_SYMBOL(filp_open);
-
 /**
  * lookup_instantiate_filp - instantiates the open intent filp
  * @nd: pointer to nameidata
diff -puN fs/reiserfs/journal.c~rename-open_namei fs/reiserfs/journal.c
--- linux-2.6.git/fs/reiserfs/journal.c~rename-open_namei	2007-11-01 14:46:07.000000000 -0700
+++ linux-2.6.git-dave/fs/reiserfs/journal.c	2007-11-01 14:46:07.000000000 -0700
@@ -2625,7 +2625,7 @@ static int journal_init_dev(struct super
 		return 0;
 	}
 
-	journal->j_dev_file = open_namei(AT_FDCWD, jdev_name, 0, 0);
+	journal->j_dev_file = open_pathname(AT_FDCWD, jdev_name, 0, 0);
 	if (!IS_ERR(journal->j_dev_file)) {
 		struct inode *jdev_inode = journal->j_dev_file->f_mapping->host;
 		if (!S_ISBLK(jdev_inode->i_mode)) {
diff -puN kernel/acct.c~rename-open_namei kernel/acct.c
--- linux-2.6.git/kernel/acct.c~rename-open_namei	2007-11-01 14:46:07.000000000 -0700
+++ linux-2.6.git-dave/kernel/acct.c	2007-11-01 14:46:07.000000000 -0700
@@ -208,7 +208,7 @@ static int acct_on(char *name)
 	int error;
 
 	/* Difference from BSD - they don't do O_APPEND */
-	file = open_namei(AT_FDCWD, name, O_WRONLY|O_APPEND|O_LARGEFILE, 0);
+	file = open_pathname(AT_FDCWD, name, O_WRONLY|O_APPEND|O_LARGEFILE, 0);
 	if (IS_ERR(file))
 		return PTR_ERR(file);
 
diff -puN mm/swapfile.c~rename-open_namei mm/swapfile.c
--- linux-2.6.git/mm/swapfile.c~rename-open_namei	2007-11-01 14:46:07.000000000 -0700
+++ linux-2.6.git-dave/mm/swapfile.c	2007-11-01 14:46:07.000000000 -0700
@@ -1191,7 +1191,7 @@ asmlinkage long sys_swapoff(const char _
 	if (IS_ERR(pathname))
 		goto out;
 
-	victim = open_namei(AT_FDCWD, pathname, O_RDWR|O_LARGEFILE, 0);
+	victim = open_pathname(AT_FDCWD, pathname, O_RDWR|O_LARGEFILE, 0);
 	putname(pathname);
 	err = PTR_ERR(victim);
 	if (IS_ERR(victim))
@@ -1470,7 +1470,7 @@ asmlinkage long sys_swapon(const char __
 		name = NULL;
 		goto bad_swap_2;
 	}
-	swap_file = open_namei(AT_FDCWD, name, O_RDWR|O_LARGEFILE, 0);
+	swap_file = open_pathname(AT_FDCWD, name, O_RDWR|O_LARGEFILE, 0);
 	error = PTR_ERR(swap_file);
 	if (IS_ERR(swap_file)) {
 		swap_file = NULL;
diff -puN sound/sound_firmware.c~rename-open_namei sound/sound_firmware.c
--- linux-2.6.git/sound/sound_firmware.c~rename-open_namei	2007-11-01 14:46:07.000000000 -0700
+++ linux-2.6.git-dave/sound/sound_firmware.c	2007-11-01 14:46:07.000000000 -0700
@@ -14,7 +14,7 @@ static int do_mod_firmware_load(const ch
 	char *dp;
 	loff_t pos;
 
-	filp = open_namei(AT_FDCWD, fn, 0, 0);
+	filp = open_pathname(AT_FDCWD, fn, 0, 0);
 	if (IS_ERR(filp))
 	{
 		printk(KERN_INFO "Unable to load '%s'.\n", fn);
_
