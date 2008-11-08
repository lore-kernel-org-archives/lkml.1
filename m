Return-Path: <linux-kernel-owner+w=401wt.eu-S1754095AbYKHLmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095AbYKHLmg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 06:42:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753055AbYKHLm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 06:42:28 -0500
Received: from tservice.ru ([195.178.208.66]:59040 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752959AbYKHLm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 06:42:28 -0500
Date: Sat, 8 Nov 2008 14:42:25 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: linux-kernel@vger.kernel.org
Cc: Robert Love <rlove@rlove.org>, Michael Kerrisk <mtk.manpages@gmail.com>
Subject: [1/1] Use pid in inotify events.
Message-ID: <20081108114225.GA22674@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Attached patch puts pid into unused cookie field in inotify events.
Cookie from move command were not changed.

Having pid of the event origin is very useful for the notification
daemons which have to differentiate 'local' and 'remote' users, i.e.
those which have different policies. One of the examples is libionotify
(an IO notiication library) and POHMELFS server.

Also fixed several whitespace issues.

1. libionotify
http://www.ioremap.net/projects/libionotify

2. POHMELFS
http://www.ioremap.net/projects/pohmelfs

Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>

diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index d4b7c4a..4a10dff 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -55,7 +55,7 @@ static inline void fsnotify_move(struct inode *old_dir, struct inode *new_dir,
 
 	if (isdir)
 		isdir = IN_ISDIR;
-	inotify_inode_queue_event(old_dir, IN_MOVED_FROM|isdir,cookie,old_name,
+	inotify_inode_queue_event(old_dir, IN_MOVED_FROM|isdir,cookie, old_name,
 				  source);
 	inotify_inode_queue_event(new_dir, IN_MOVED_TO|isdir, cookie, new_name,
 				  source);
@@ -79,7 +79,8 @@ static inline void fsnotify_nameremove(struct dentry *dentry, int isdir)
 	if (isdir)
 		isdir = IN_ISDIR;
 	dnotify_parent(dentry, DN_DELETE);
-	inotify_dentry_parent_queue_event(dentry, IN_DELETE|isdir, 0, dentry->d_name.name);
+	inotify_dentry_parent_queue_event(dentry, IN_DELETE|isdir,
+			task_tgid_vnr(current), dentry->d_name.name);
 }
 
 /*
@@ -87,7 +88,8 @@ static inline void fsnotify_nameremove(struct dentry *dentry, int isdir)
  */
 static inline void fsnotify_inoderemove(struct inode *inode)
 {
-	inotify_inode_queue_event(inode, IN_DELETE_SELF, 0, NULL, NULL);
+	inotify_inode_queue_event(inode, IN_DELETE_SELF,
+			task_tgid_vnr(current), NULL, NULL);
 	inotify_inode_is_dead(inode);
 }
 
@@ -96,7 +98,8 @@ static inline void fsnotify_inoderemove(struct inode *inode)
  */
 static inline void fsnotify_link_count(struct inode *inode)
 {
-	inotify_inode_queue_event(inode, IN_ATTRIB, 0, NULL, NULL);
+	inotify_inode_queue_event(inode, IN_ATTRIB,
+			task_tgid_vnr(current), NULL, NULL);
 }
 
 /*
@@ -105,8 +108,8 @@ static inline void fsnotify_link_count(struct inode *inode)
 static inline void fsnotify_create(struct inode *inode, struct dentry *dentry)
 {
 	inode_dir_notify(inode, DN_CREATE);
-	inotify_inode_queue_event(inode, IN_CREATE, 0, dentry->d_name.name,
-				  dentry->d_inode);
+	inotify_inode_queue_event(inode, IN_CREATE, task_tgid_vnr(current),
+			dentry->d_name.name, dentry->d_inode);
 	audit_inode_child(dentry->d_name.name, dentry, inode);
 }
 
@@ -118,8 +121,8 @@ static inline void fsnotify_create(struct inode *inode, struct dentry *dentry)
 static inline void fsnotify_link(struct inode *dir, struct inode *inode, struct dentry *new_dentry)
 {
 	inode_dir_notify(dir, DN_CREATE);
-	inotify_inode_queue_event(dir, IN_CREATE, 0, new_dentry->d_name.name,
-				  inode);
+	inotify_inode_queue_event(dir, IN_CREATE, task_tgid_vnr(current),
+			new_dentry->d_name.name, inode);
 	fsnotify_link_count(inode);
 	audit_inode_child(new_dentry->d_name.name, new_dentry, dir);
 }
@@ -130,8 +133,8 @@ static inline void fsnotify_link(struct inode *dir, struct inode *inode, struct
 static inline void fsnotify_mkdir(struct inode *inode, struct dentry *dentry)
 {
 	inode_dir_notify(inode, DN_CREATE);
-	inotify_inode_queue_event(inode, IN_CREATE | IN_ISDIR, 0, 
-				  dentry->d_name.name, dentry->d_inode);
+	inotify_inode_queue_event(inode, IN_CREATE | IN_ISDIR,
+		task_tgid_vnr(current), dentry->d_name.name, dentry->d_inode);
 	audit_inode_child(dentry->d_name.name, dentry, inode);
 }
 
@@ -147,8 +150,9 @@ static inline void fsnotify_access(struct dentry *dentry)
 		mask |= IN_ISDIR;
 
 	dnotify_parent(dentry, DN_ACCESS);
-	inotify_dentry_parent_queue_event(dentry, mask, 0, dentry->d_name.name);
-	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
+	inotify_dentry_parent_queue_event(dentry, mask,
+			task_tgid_vnr(current), dentry->d_name.name);
+	inotify_inode_queue_event(inode, mask, task_tgid_vnr(current), NULL, NULL);
 }
 
 /*
@@ -163,8 +167,9 @@ static inline void fsnotify_modify(struct dentry *dentry)
 		mask |= IN_ISDIR;
 
 	dnotify_parent(dentry, DN_MODIFY);
-	inotify_dentry_parent_queue_event(dentry, mask, 0, dentry->d_name.name);
-	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
+	inotify_dentry_parent_queue_event(dentry, mask,
+			task_tgid_vnr(current), dentry->d_name.name);
+	inotify_inode_queue_event(inode, mask, task_tgid_vnr(current), NULL, NULL);
 }
 
 /*
@@ -178,8 +183,10 @@ static inline void fsnotify_open(struct dentry *dentry)
 	if (S_ISDIR(inode->i_mode))
 		mask |= IN_ISDIR;
 
-	inotify_dentry_parent_queue_event(dentry, mask, 0, dentry->d_name.name);
-	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
+	inotify_dentry_parent_queue_event(dentry, mask,
+		task_tgid_vnr(current), dentry->d_name.name);
+	inotify_inode_queue_event(inode, mask,
+		task_tgid_vnr(current), NULL, NULL);
 }
 
 /*
@@ -196,8 +203,8 @@ static inline void fsnotify_close(struct file *file)
 	if (S_ISDIR(inode->i_mode))
 		mask |= IN_ISDIR;
 
-	inotify_dentry_parent_queue_event(dentry, mask, 0, name);
-	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
+	inotify_dentry_parent_queue_event(dentry, mask, task_tgid_vnr(current), name);
+	inotify_inode_queue_event(inode, mask, task_tgid_vnr(current), NULL, NULL);
 }
 
 /*
@@ -211,8 +218,10 @@ static inline void fsnotify_xattr(struct dentry *dentry)
 	if (S_ISDIR(inode->i_mode))
 		mask |= IN_ISDIR;
 
-	inotify_dentry_parent_queue_event(dentry, mask, 0, dentry->d_name.name);
-	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
+	inotify_dentry_parent_queue_event(dentry, mask,
+			task_tgid_vnr(current), dentry->d_name.name);
+	inotify_inode_queue_event(inode, mask,
+			task_tgid_vnr(current), NULL, NULL);
 }
 
 /*
@@ -259,9 +268,10 @@ static inline void fsnotify_change(struct dentry *dentry, unsigned int ia_valid)
 	if (in_mask) {
 		if (S_ISDIR(inode->i_mode))
 			in_mask |= IN_ISDIR;
-		inotify_inode_queue_event(inode, in_mask, 0, NULL, NULL);
-		inotify_dentry_parent_queue_event(dentry, in_mask, 0,
-						  dentry->d_name.name);
+		inotify_inode_queue_event(inode, in_mask,
+				task_tgid_vnr(current), NULL, NULL);
+		inotify_dentry_parent_queue_event(dentry, in_mask,
+				task_tgid_vnr(current), dentry->d_name.name);
 	}
 }
 


-- 
	Evgeniy Polyakov
