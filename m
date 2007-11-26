Return-Path: <linux-kernel-owner+w=401wt.eu-S1756854AbXKZQ2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854AbXKZQ2S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 11:28:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753189AbXKZQ2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 11:28:01 -0500
Received: from styx.suse.cz ([82.119.242.94]:43032 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753093AbXKZQ2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 11:28:00 -0500
Date: Mon, 26 Nov 2007 17:27:58 +0100
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Morten Welinder <mwelinder@gmail.com>, rlove@rlove.org
Subject: [PATCH] Send IN_ATTRIB events when link count changes
Message-ID: <20071126162758.GA856@duck.suse.cz>
References: <118833cc0711201911r3684937p38823649639e0a57@mail.gmail.com> <118833cc0711231154i588cf7c1gb99e050999af8632@mail.gmail.com> <20071126160043.GA5647@atrey.karlin.mff.cuni.cz> <118833cc0711260806x69fc2bb6n572f1e1253a201ef@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <118833cc0711260806x69fc2bb6n572f1e1253a201ef@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi Andrew,

  would you pick up this patch for testing in -mm? Thanks.

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

---

Send inotify events to the inode itself when its link count has changed.

Signed-off-by: Jan Kara <jack@suse.cz>
Acked-by: Morten Welinder <mwelinder@gmail.com>

diff --git a/fs/namei.c b/fs/namei.c
index 3b993db..9a91130 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2188,6 +2188,7 @@ int vfs_unlink(struct inode *dir, struct
 
 	/* We don't d_delete() NFS sillyrenamed files--they still exist. */
 	if (!error && !(dentry->d_flags & DCACHE_NFSFS_RENAMED)) {
+		fsnotify_link_count(dentry->d_inode);
 		d_delete(dentry);
 	}
 
@@ -2360,7 +2361,7 @@ int vfs_link(struct dentry *old_dentry,
 	error = dir->i_op->link(old_dentry, dir, new_dentry);
 	mutex_unlock(&old_dentry->d_inode->i_mutex);
 	if (!error)
-		fsnotify_create(dir, new_dentry);
+		fsnotify_link(dir, new_dentry);
 	return error;
 }
 
diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index 2bd31fa..b21b818 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -92,6 +92,14 @@ static inline void fsnotify_inoderemove(
 }
 
 /*
+ * fsnotify_link_count - inode's link count changed
+ */
+static inline void fsnotify_link_count(struct inode *inode)
+{
+	inotify_inode_queue_event(inode, IN_ATTRIB, 0, NULL, NULL);
+}
+
+/*
  * fsnotify_create - 'name' was linked in
  */
 static inline void fsnotify_create(struct inode *inode, struct dentry *dentry)
@@ -103,6 +111,18 @@ static inline void fsnotify_create(struc
 }
 
 /*
+ * fsnotify_link - new hardlink in 'inode' directory
+ */
+static inline void fsnotify_link(struct inode *inode, struct dentry *new_dentry)
+{
+	inode_dir_notify(inode, DN_CREATE);
+	inotify_inode_queue_event(inode, IN_CREATE, 0, new_dentry->d_name.name,
+				  new_dentry->d_inode);
+	fsnotify_link_count(new_dentry->d_inode);
+	audit_inode_child(new_dentry->d_name.name, new_dentry, inode);
+}
+
+/*
  * fsnotify_mkdir - directory 'name' was created
  */
 static inline void fsnotify_mkdir(struct inode *inode, struct dentry *dentry)
