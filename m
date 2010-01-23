Return-Path: <linux-kernel-owner+w=401wt.eu-S1756410Ab0AWA1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756410Ab0AWA1d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 19:27:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755621Ab0AWA1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 19:27:25 -0500
Received: from kroah.org ([198.145.64.141]:35033 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754867Ab0AWASp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 19:18:45 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Jan 22 16:11:11 2010
Message-Id: <20100123001111.126782344@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 22 Jan 2010 16:09:51 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Duckjin Kang <fromdj2k@gmail.com>, Erez Zadok <ezk@cs.sunysb.edu>,
       Dustin Kirkland <kirkland@canonical.com>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Subject: [07/29] ecryptfs: initialize private persistent file before dereferencing pointer
In-Reply-To: <20100123001145.GA7391@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

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
@@ -191,13 +191,6 @@ static int ecryptfs_open(struct inode *i
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
@@ -208,6 +201,13 @@ static int ecryptfs_open(struct inode *i
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


