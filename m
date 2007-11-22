Return-Path: <linux-kernel-owner+w=401wt.eu-S1753572AbXKVPe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572AbXKVPe4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 10:34:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751036AbXKVPes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 10:34:48 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:60292 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbXKVPer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 10:34:47 -0500
Date: Thu, 22 Nov 2007 16:34:46 +0100
From: Jan Kara <jack@suse.cz>
To: Morten Welinder <mwelinder@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, rlove@rlove.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Inotify fails to send IN_ATTRIB events
Message-ID: <20071122153446.GA6299@atrey.karlin.mff.cuni.cz>
References: <118833cc0711201911r3684937p38823649639e0a57@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <118833cc0711201911r3684937p38823649639e0a57@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

> I am seeing missing inotify IN_ATTRIB events in the following situation:
> 
> 1. "touch foo"
> 
> 2. Make inotify watch "foo"
> 
> 3. "ln foo bar"
>    --> Link count changed so I should have gotten an IN_ATTRIB.
> 
> 4. "rm foo"
>    --> Link count changed so I should have gotten an IN_ATTRIB.  (Or
> IN_DELETE_SELF;
>    I don't care which.)
> 
> 5. "ln bar foo && rm bar"
>    --> Still no events.
> 
> 6. "mv foo bar"
>    --> I get IN_MOVED_SELF.  Good!
> 
> 7. "mv bar foo"
>    --> I get IN_MOVED_SELF.  Good!
> 
> 
> 3+4 is pretty much the same as 6, so I really ought to be told that my
> file has changed
> name.  I don't really care much about getting notified about 3, but
> for completeness
> it ought to be handled.
> 
> As far as I can see, the only way to be told about 4 is to put a watch
> on the directory in
> which foo resides.  That is inelegant and has an inherent race condition.
  It looks sensible what you ask for ;) Wanna try the patch below?
Anybody has some objection to it?

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs

---

Send inotify events to the inode itself when its link count has changed.

Signed-off-by: Jan Kara <jack@suse.cz>

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
