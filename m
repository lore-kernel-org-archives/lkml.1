Return-Path: <linux-kernel-owner+w=401wt.eu-S934598AbZJIX1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934598AbZJIX1J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 19:27:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934594AbZJIX1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 19:27:06 -0400
Received: from kroah.org ([198.145.64.141]:56312 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932741AbZJIX0r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 19:26:47 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Oct  9 16:22:34 2009
Message-Id: <20091009232233.941048286@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 09 Oct 2009 16:21:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Serge Hallyn <serue@us.ibm.com>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       ecryptfs-devel@lists.launchpad.net,
       Tyler Hicks <tyhicks@linux.vnet.ibm.com>,
       Chuck Ebbert <cebbert@redhat.com>
Subject: [4/8] eCryptfs: Prevent lower dentry from going negative during unlink (CVE-2009-2908)
From: gregkh@mini.kroah.org
References: <20091009232123.464253035@mini.kroah.org>
Content-Disposition: inline; filename=ecryptfs-prevent-lower-dentry-from-going-negative-during-unlink.patch
In-Reply-To: <20091009232300.GA403@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ecryptfs/inode.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -443,6 +443,7 @@ static int ecryptfs_unlink(struct inode 
 	struct inode *lower_dir_inode = ecryptfs_inode_to_lower(dir);
 	struct dentry *lower_dir_dentry;
 
+	dget(lower_dentry);
 	lower_dir_dentry = lock_parent(lower_dentry);
 	rc = vfs_unlink(lower_dir_inode, lower_dentry);
 	if (rc) {
@@ -456,6 +457,7 @@ static int ecryptfs_unlink(struct inode 
 	d_drop(dentry);
 out_unlock:
 	unlock_dir(lower_dir_dentry);
+	dput(lower_dentry);
 	return rc;
 }
 


