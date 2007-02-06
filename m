Return-Path: <linux-kernel-owner+w=401wt.eu-S1752114AbXBFNXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114AbXBFNXn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 08:23:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752126AbXBFNXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 08:23:43 -0500
Received: from verein.lst.de ([213.95.11.210]:43734 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114AbXBFNXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 08:23:41 -0500
Date: Tue, 6 Feb 2007 14:23:33 +0100
From: Christoph Hellwig <hch@lst.de>
To: jack@suse.cz, akpm@osdl.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] remove sb->s_files and file_list_lock usage in dquot.c
Message-ID: <20070206132333.GA9919@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Iterate over sb->s_inodes instead of sb->s_files in add_dquot_ref.
This reduces list search and lock hold time aswell as getting rid of
one of the few uses of file_list_lock which Ingo identified as a
scalability problem.

Previously we called dq_op->initialize for every inode handing of
a writeable file that wasn't initialized before.  Now we're calling
it for every inode that has a non-zero i_writecount, aka a writeable
file descriptor refering to it.

Thanks a lot to Jan Kara for running this patch through his quota
test harness.

Note:  this is ontop of '[PATCH] move remove_dquot_ref to dqout.c'
which I sent out yesterday.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/dquot.c
===================================================================
--- linux-2.6.orig/fs/dquot.c	2007-02-05 18:54:36.000000000 +0100
+++ linux-2.6/fs/dquot.c	2007-02-05 18:59:48.000000000 +0100
@@ -689,23 +689,27 @@
 /* This routine is guarded by dqonoff_mutex mutex */
 static void add_dquot_ref(struct super_block *sb, int type)
 {
-	struct list_head *p;
+	struct inode *inode;
 
 restart:
-	file_list_lock();
-	list_for_each(p, &sb->s_files) {
-		struct file *filp = list_entry(p, struct file, f_u.fu_list);
-		struct inode *inode = filp->f_path.dentry->d_inode;
-		if (filp->f_mode & FMODE_WRITE && dqinit_needed(inode, type)) {
-			struct dentry *dentry = dget(filp->f_path.dentry);
-			file_list_unlock();
-			sb->dq_op->initialize(inode, type);
-			dput(dentry);
-			/* As we may have blocked we had better restart... */
-			goto restart;
-		}
+	spin_lock(&inode_lock);
+	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
+		if (!atomic_read(&inode->i_writecount))
+			continue;
+		if (!dqinit_needed(inode, type))
+			continue;
+		if (inode->i_state & (I_FREEING|I_WILL_FREE))
+			continue;
+
+		__iget(inode);
+		spin_unlock(&inode_lock);
+
+		sb->dq_op->initialize(inode, type);
+		iput(inode);
+		/* As we may have blocked we had better restart... */
+		goto restart;
 	}
-	file_list_unlock();
+	spin_unlock(&inode_lock);
 }
 
 /* Return 0 if dqput() won't block (note that 1 doesn't necessarily mean blocking) */
