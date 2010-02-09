Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472Ab0BIFhV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 00:37:21 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:34994 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855Ab0BIFhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 00:37:17 -0500
Date: Tue, 9 Feb 2010 16:37:16 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Eric Paris <eparis@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: linux-next: manual merge of the fsnotify tree with the vfs tree
Message-Id: <20100209163716.8bd4e6c6.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta7 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

Today's linux-next merge of the fsnotify tree got a conflict in
include/linux/fsnotify.h between commits
123df2944c436c80640c4281c5bc9c7950b18687 ("Lose the new_name argument of
fsnotify_move()") and cccc6bba3f771ef29b33e4f79e70ebc3dba245b0 ("Lose the
first argument of audit_inode_child()") from the vfs tree and commits
8b37e6e1cdff433157a7ac8448789e23d0f581b9 ("inotify: remove inotify in
kernel interface") and 2df5764e29a813f6ba63be094ab8aadc704a78fd
("fsnotify: use unsigned char * for dentry->d_name.name") from the
fsnotify tree.

I fixed it up (see below) and can carry the fixes as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/fsnotify.h
index df8fd9a,bd99bf5..0000000
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@@ -65,11 -77,12 +77,10 @@@ static inline void fsnotify_link_count(
   * fsnotify_move - file old_name at old_dir was moved to new_name at new_dir
   */
  static inline void fsnotify_move(struct inode *old_dir, struct inode *new_dir,
- 				 const char *old_name,
+ 				 const unsigned char *old_name,
 -				 const unsigned char *new_name,
 -				 int isdir, struct inode *target,
 -				 struct dentry *moved)
 +				 int isdir, struct inode *target, struct dentry *moved)
  {
  	struct inode *source = moved->d_inode;
- 	u32 in_cookie = inotify_get_cookie();
  	u32 fs_cookie = fsnotify_get_cookie();
  	__u32 old_dir_mask = (FS_EVENT_ON_CHILD | FS_MOVED_FROM);
  	__u32 new_dir_mask = (FS_EVENT_ON_CHILD | FS_MOVED_TO);
@@@ -87,24 -98,13 +97,12 @@@
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
 -
 -	audit_inode_child(new_name, moved, new_dir);
 +	audit_inode_child(moved, new_dir);
  }
  
  /*
@@@ -145,9 -150,7 +148,7 @@@ static inline void fsnotify_inoderemove
   */
  static inline void fsnotify_create(struct inode *inode, struct dentry *dentry)
  {
- 	inotify_inode_queue_event(inode, IN_CREATE, 0, dentry->d_name.name,
- 				  dentry->d_inode);
 -	audit_inode_child(dentry->d_name.name, dentry, inode);
 +	audit_inode_child(dentry, inode);
  
  	fsnotify(inode, FS_CREATE, dentry->d_inode, FSNOTIFY_EVENT_INODE, dentry->d_name.name, 0);
  }
@@@ -159,10 -162,8 +160,8 @@@
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
@@@ -175,8 -176,7 +174,7 @@@ static inline void fsnotify_mkdir(struc
  	__u32 mask = (FS_CREATE | FS_IN_ISDIR);
  	struct inode *d_inode = dentry->d_inode;
  
- 	inotify_inode_queue_event(inode, mask, 0, dentry->d_name.name, d_inode);
 -	audit_inode_child(dentry->d_name.name, dentry, inode);
 +	audit_inode_child(dentry, inode);
  
  	fsnotify(inode, mask, d_inode, FSNOTIFY_EVENT_INODE, dentry->d_name.name, 0);
  }
