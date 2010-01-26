Return-Path: <linux-kernel-owner+w=401wt.eu-S1755118Ab0AZT3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118Ab0AZT3T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 14:29:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755092Ab0AZT3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 14:29:08 -0500
Received: from kroah.org ([198.145.64.141]:33584 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755070Ab0AZT3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 14:29:01 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 11:16:24 2010
Message-Id: <20100126191624.282924254@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 11:14:40 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Duckjin Kang <fromdj2k@gmail.com>, Erez Zadok <ezk@cs.sunysb.edu>,
       Dustin Kirkland <kirkland@canonical.com>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Subject: [04/11] ecryptfs: initialize private persistent file before dereferencing pointer
In-Reply-To: <20100126191730.GA20872@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Erez Zadok <ezk@cs.sunysb.edu>

commit e27759d7a333d1f25d628c4f7caf845c51be51c2 upstream.

Ecryptfs_open dereferences a pointer to the private lower file (the one
stored in the ecryptfs inode), without checking if the pointer is NULL.
Right afterward, it initializes that pointer if it is NULL.  Swap order of
statements to first initialize.  Bug discovered by Duckjin Kang.

Signed-off-by: Duckjin Kang <fromdj2k@gmail.com>
Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Cc: Dustin Kirkland <kirkland@canonical.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ecryptfs/file.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -192,13 +192,6 @@ static int ecryptfs_open(struct inode *i
 				      | ECRYPTFS_ENCRYPTED);
 	}
 	mutex_unlock(&crypt_stat->cs_mutex);
-	if ((ecryptfs_inode_to_private(inode)->lower_file->f_flags & O_RDONLY)
-	    && !(file->f_flags & O_RDONLY)) {
-		rc = -EPERM;
-		printk(KERN_WARNING "%s: Lower persistent file is RO; eCryptfs "
-		       "file must hence be opened RO\n", __func__);
-		goto out;
-	}
 	if (!ecryptfs_inode_to_private(inode)->lower_file) {
 		rc = ecryptfs_init_persistent_file(ecryptfs_dentry);
 		if (rc) {
@@ -209,6 +202,13 @@ static int ecryptfs_open(struct inode *i
 			goto out;
 		}
 	}
+	if ((ecryptfs_inode_to_private(inode)->lower_file->f_flags & O_RDONLY)
+	    && !(file->f_flags & O_RDONLY)) {
+		rc = -EPERM;
+		printk(KERN_WARNING "%s: Lower persistent file is RO; eCryptfs "
+		       "file must hence be opened RO\n", __func__);
+		goto out;
+	}
 	ecryptfs_set_file_lower(
 		file, ecryptfs_inode_to_private(inode)->lower_file);
 	if (S_ISDIR(ecryptfs_dentry->d_inode->i_mode)) {


