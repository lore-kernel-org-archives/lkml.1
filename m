Return-Path: <linux-kernel-owner+w=401wt.eu-S1755482AbZJBB60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482AbZJBB60 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755130AbZJBBcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:32:47 -0400
Received: from kroah.org ([198.145.64.141]:32964 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754951AbZJBBcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:32:43 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:09 2009
Message-Id: <20091002012409.243140443@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:16:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Serge Hallyn <serue@us.ibm.com>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       ecryptfs-devel@lists.launchpad.net,
       Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Subject: [023/136] eCryptfs: Prevent lower dentry from going negative during unlink
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=ecryptfs-prevent-lower-dentry-from-going-negative-during-unlink.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>

commit 9c2d2056647790c5034d722bd24e9d913ebca73c upstream.

When calling vfs_unlink() on the lower dentry, d_delete() turns the
dentry into a negative dentry when the d_count is 1.  This eventually
caused a NULL pointer deref when a read() or write() was done and the
negative dentry's d_inode was dereferenced in
ecryptfs_read_update_atime() or ecryptfs_getxattr().

Placing mutt's tmpdir in an eCryptfs mount is what initially triggered
the oops and I was able to reproduce it with the following sequence:

open("/tmp/upper/foo", O_RDWR|O_CREAT|O_EXCL|O_NOFOLLOW, 0600) = 3
link("/tmp/upper/foo", "/tmp/upper/bar") = 0
unlink("/tmp/upper/foo")                = 0
open("/tmp/upper/bar", O_RDWR|O_CREAT|O_NOFOLLOW, 0600) = 4
unlink("/tmp/upper/bar")                = 0
write(4, "eCryptfs test\n"..., 14 <unfinished ...>
+++ killed by SIGKILL +++

https://bugs.launchpad.net/ecryptfs/+bug/387073

Reported-by: Loïc Minier <loic.minier@canonical.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: ecryptfs-devel@lists.launchpad.net
Signed-off-by: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ecryptfs/inode.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -476,6 +476,7 @@ static int ecryptfs_unlink(struct inode 
 	struct inode *lower_dir_inode = ecryptfs_inode_to_lower(dir);
 	struct dentry *lower_dir_dentry;
 
+	dget(lower_dentry);
 	lower_dir_dentry = lock_parent(lower_dentry);
 	rc = vfs_unlink(lower_dir_inode, lower_dentry);
 	if (rc) {
@@ -489,6 +490,7 @@ static int ecryptfs_unlink(struct inode 
 	d_drop(dentry);
 out_unlock:
 	unlock_dir(lower_dir_dentry);
+	dput(lower_dentry);
 	return rc;
 }
 


