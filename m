Return-Path: <linux-kernel-owner+w=401wt.eu-S1752257Ab0ARG3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257Ab0ARG3n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 01:29:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750995Ab0ARG3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 01:29:43 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:45948 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353Ab0ARG3m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 01:29:42 -0500
Date: Mon, 18 Jan 2010 17:29:38 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Eric Paris <eparis@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: linux-next: manual merge of the fsnotify tree with the vfs tree
Message-Id: <20100118172938.d77c2a9b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta4 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

Today's linux-next merge of the fsnotify tree got a conflict in
include/linux/fsnotify.h between commit
8471c0d4ecfe882d76bcb99f941f6ac7d46e2ec0 ("Lose the first argument of
audit_inode_child()") from the vfs tree and commit
3c33b75b9aa83f6db59f5d880f881807519ad84d ("inotify: remove inotify in
kernel interface") from the fsnotify tree.

Just context changes.  I fixed them up (see below) and can carry the fix
as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/fsnotify.h
index df8fd9a,8db6857..0000000
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@@ -87,24 -96,13 +97,13 @@@ static inline void fsnotify_move(struc
  	fsnotify(old_dir, old_dir_mask, old_dir, FSNOTIFY_EVENT_INODE, old_name, fs_cookie);
  	fsnotify(new_dir, new_dir_mask, new_dir, FSNOTIFY_EVENT_INODE, new_name, fs_cookie);
  
- 	if (target) {
- 		inotify_inode_queue_event(target, IN_DELETE_SELF, 0, NULL, NULL);
- 		inotify_inode_is_dead(target);
- 
- 		/* this is really a link_count change not a removal */
+ 	if (target)
  		fsnotify_link_count(target);
- 	}
  
- 	if (source) {
- 		inotify_inode_queue_event(source, IN_MOVE_SELF, 0, NULL, NULL);
+ 	if (source)
  		fsnotify(source, FS_MOVE_SELF, moved->d_inode, FSNOTIFY_EVENT_INODE, NULL, 0);
- 	}
+ 
 -	audit_inode_child(new_name, moved, new_dir);
 +	audit_inode_child(moved, new_dir);
  }
  
  /*
@@@ -145,9 -148,7 +149,7 @@@ static inline void fsnotify_inoderemove
   */
  static inline void fsnotify_create(struct inode *inode, struct dentry *dentry)
  {
- 	inotify_inode_queue_event(inode, IN_CREATE, 0, dentry->d_name.name,
- 				  dentry->d_inode);
 -	audit_inode_child(dentry->d_name.name, dentry, inode);
 +	audit_inode_child(dentry, inode);
  
  	fsnotify(inode, FS_CREATE, dentry->d_inode, FSNOTIFY_EVENT_INODE, dentry->d_name.name, 0);
  }
@@@ -159,10 -160,8 +161,8 @@@
   */
  static inline void fsnotify_link(struct inode *dir, struct inode *inode, struct dentry *new_dentry)
  {
- 	inotify_inode_queue_event(dir, IN_CREATE, 0, new_dentry->d_name.name,
- 				  inode);
  	fsnotify_link_count(inode);
 -	audit_inode_child(new_dentry->d_name.name, new_dentry, dir);
 +	audit_inode_child(new_dentry, dir);
  
  	fsnotify(dir, FS_CREATE, inode, FSNOTIFY_EVENT_INODE, new_dentry->d_name.name, 0);
  }
@@@ -175,8 -174,7 +175,7 @@@ static inline void fsnotify_mkdir(struc
  	__u32 mask = (FS_CREATE | FS_IN_ISDIR);
  	struct inode *d_inode = dentry->d_inode;
  
- 	inotify_inode_queue_event(inode, mask, 0, dentry->d_name.name, d_inode);
 -	audit_inode_child(dentry->d_name.name, dentry, inode);
 +	audit_inode_child(dentry, inode);
  
  	fsnotify(inode, mask, d_inode, FSNOTIFY_EVENT_INODE, dentry->d_name.name, 0);
  }
