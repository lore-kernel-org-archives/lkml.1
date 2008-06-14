Return-Path: <linux-kernel-owner+w=401wt.eu-S1762316AbYFNAPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762316AbYFNAPm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 20:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760653AbYFNAMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 20:12:54 -0400
Received: from cantor.suse.de ([195.135.220.2]:34181 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760609AbYFNAMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 20:12:53 -0400
Date: Fri, 13 Jun 2008 17:10:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, hch@infradead.org, mszeredi@suse.cz,
       mhalcrow@us.ibm.com, Chris Wright <chrisw@sous-sol.org>
Subject: [patch 10/47] ecryptfs: clean up (un)lock_parent
Message-ID: <20080614001039.GJ24698@suse.de>
References: <20080613234753.235721454@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ecryptfs-clean-up-lock_parent.patch"
In-Reply-To: <20080614000840.GA24659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Miklos Szeredi <mszeredi@suse.cz>

upstream commit: 8dc4e37362a5dc910d704d52ac6542bfd49ddc2f

dget(dentry->d_parent) --> dget_parent(dentry)

unlock_parent() is racy and unnecessary.  Replace single caller with
unlock_dir().

There are several other suspect uses of ->d_parent in ecryptfs...

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 fs/ecryptfs/inode.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -37,17 +37,11 @@ static struct dentry *lock_parent(struct
 {
 	struct dentry *dir;
 
-	dir = dget(dentry->d_parent);
+	dir = dget_parent(dentry);
 	mutex_lock_nested(&(dir->d_inode->i_mutex), I_MUTEX_PARENT);
 	return dir;
 }
 
-static void unlock_parent(struct dentry *dentry)
-{
-	mutex_unlock(&(dentry->d_parent->d_inode->i_mutex));
-	dput(dentry->d_parent);
-}
-
 static void unlock_dir(struct dentry *dir)
 {
 	mutex_unlock(&dir->d_inode->i_mutex);
@@ -426,8 +420,9 @@ static int ecryptfs_unlink(struct inode 
 	int rc = 0;
 	struct dentry *lower_dentry = ecryptfs_dentry_to_lower(dentry);
 	struct inode *lower_dir_inode = ecryptfs_inode_to_lower(dir);
+	struct dentry *lower_dir_dentry;
 
-	lock_parent(lower_dentry);
+	lower_dir_dentry = lock_parent(lower_dentry);
 	rc = vfs_unlink(lower_dir_inode, lower_dentry);
 	if (rc) {
 		printk(KERN_ERR "Error in vfs_unlink; rc = [%d]\n", rc);
@@ -439,7 +434,7 @@ static int ecryptfs_unlink(struct inode 
 	dentry->d_inode->i_ctime = dir->i_ctime;
 	d_drop(dentry);
 out_unlock:
-	unlock_parent(lower_dentry);
+	unlock_dir(lower_dir_dentry);
 	return rc;
 }
 

-- 
