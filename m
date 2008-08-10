Return-Path: <linux-kernel-owner+w=401wt.eu-S1754333AbYHKACi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333AbYHKACi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 20:02:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752612AbYHKACa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 20:02:30 -0400
Received: from tundra.namei.org ([65.99.196.166]:56669 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752534AbYHKAC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 20:02:29 -0400
Date: Mon, 11 Aug 2008 09:57:44 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>,
       Steve French <sfrench@us.ibm.com>
Subject: Resolved merge conflicts in next-creds
Message-ID: <alpine.LRH.1.10.0808110950530.3636@tundra.namei.org>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I manually resolved the following conflicts in

git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next-creds

when merging with latest Linus.  (This branch holds the creds API changes
from David Howells and is being pulled into linux-next).

commit 293f28d5b02efe4504d5976f6f5889458ed56539
Merge: ea40dc0... 796aade...
Author: James Morris <jmorris@namei.org>
Date:   Mon Aug 11 09:22:10 2008 +1000

    Merge branch 'master' into next-creds
    
    Conflicts:
    
        arch/sparc64/kernel/sys_sparc32.c
        fs/cifs/dir.c
        fs/cifs/inode.c
    
---

The Sparc conflicts were from a bunch of code which Adrian Bunk removed in 
ea771bd51c3b9b9683860515d93e6155a345fa2f, and should not be able to cause 
problems.

The CIFS conflicts were collisions with API changes.  I'm not sure how 
best to extract this information from git.  'git-rerere' doesn't seem to 
do anythig, even with:

$ git-config --list
rerere.enabled=1

A git-show on the merge ID produces the following:


commit 293f28d5b02efe4504d5976f6f5889458ed56539
Merge: ea40dc0... 796aade...
Author: James Morris <jmorris@namei.org>
Date:   Mon Aug 11 09:22:10 2008 +1000

    Merge branch 'master' into next-creds
    
    Conflicts:
    
    	arch/sparc64/kernel/sys_sparc32.c
    	fs/cifs/dir.c
    	fs/cifs/inode.c
    
    Signed-off-by: James Morris <jmorris@namei.org>

diff --cc fs/cifs/dir.c
index a2d4a2b,e962e75..2f02c52
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@@ -226,23 -226,28 +226,28 @@@ cifs_create(struct inode *inode, struc
  		/* If Open reported that we actually created a file
  		then we now have to set the mode if possible */
  		if ((pTcon->unix_ext) && (oplock & CIFS_CREATE_ACTION)) {
+ 			struct cifs_unix_set_info_args args = {
+ 				.mode	= mode,
+ 				.ctime	= NO_CHANGE_64,
+ 				.atime	= NO_CHANGE_64,
+ 				.mtime	= NO_CHANGE_64,
+ 				.device	= 0,
+ 			};
+ 
  			if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID) {
- 				CIFSSMBUnixSetPerms(xid, pTcon, full_path, mode,
- 					(__u64)current_fsuid(),
- 					(__u64)current_fsgid(),
- 					0 /* dev */,
- 					cifs_sb->local_nls,
- 					cifs_sb->mnt_cifs_flags &
- 						CIFS_MOUNT_MAP_SPECIAL_CHR);
 -				args.uid = (__u64) current->fsuid;
++				args.uid = (__u64) current_fsuid();
+ 				if (inode->i_mode & S_ISGID)
+ 					args.gid = (__u64) inode->i_gid;
+ 				else
 -					args.gid = (__u64) current->fsgid;
++					args.gid = (__u64) current_fsgid();
  			} else {
- 				CIFSSMBUnixSetPerms(xid, pTcon, full_path, mode,
- 					(__u64)-1,
- 					(__u64)-1,
- 					0 /* dev */,
- 					cifs_sb->local_nls,
- 					cifs_sb->mnt_cifs_flags &
- 						CIFS_MOUNT_MAP_SPECIAL_CHR);
+ 				args.uid = NO_CHANGE_64;
+ 				args.gid = NO_CHANGE_64;
  			}
+ 			CIFSSMBUnixSetInfo(xid, pTcon, full_path, &args,
+ 				cifs_sb->local_nls,
+ 				cifs_sb->mnt_cifs_flags &
+ 					CIFS_MOUNT_MAP_SPECIAL_CHR);
  		} else {
  			/* BB implement mode setting via Windows security
  			   descriptors e.g. */
@@@ -266,8 -271,13 +271,13 @@@
  				if ((oplock & CIFS_CREATE_ACTION) &&
  				    (cifs_sb->mnt_cifs_flags &
  				     CIFS_MOUNT_SET_UID)) {
 -					newinode->i_uid = current->fsuid;
 +					newinode->i_uid = current_fsuid();
- 					newinode->i_gid = current_fsgid();
+ 					if (inode->i_mode & S_ISGID)
+ 						newinode->i_gid =
+ 							inode->i_gid;
+ 					else
+ 						newinode->i_gid =
 -							current->fsgid;
++							current_fsgid();
  				}
  			}
  		}
@@@ -357,21 -367,24 +367,24 @@@ int cifs_mknod(struct inode *inode, str
  	if (full_path == NULL)
  		rc = -ENOMEM;
  	else if (pTcon->unix_ext) {
- 		mode &= ~current->fs->umask;
+ 		struct cifs_unix_set_info_args args = {
+ 			.mode	= mode & ~current->fs->umask,
+ 			.ctime	= NO_CHANGE_64,
+ 			.atime	= NO_CHANGE_64,
+ 			.mtime	= NO_CHANGE_64,
+ 			.device	= device_number,
+ 		};
  		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID) {
- 			rc = CIFSSMBUnixSetPerms(xid, pTcon, full_path,
- 				mode, (__u64)current_fsuid(),
- 				(__u64)current_fsgid(),
- 				device_number, cifs_sb->local_nls,
- 				cifs_sb->mnt_cifs_flags &
- 					CIFS_MOUNT_MAP_SPECIAL_CHR);
 -			args.uid = (__u64) current->fsuid;
 -			args.gid = (__u64) current->fsgid;
++			args.uid = (__u64) current_fsuid();
++			args.gid = (__u64) current_fsgid();
  		} else {
- 			rc = CIFSSMBUnixSetPerms(xid, pTcon,
- 				full_path, mode, (__u64)-1, (__u64)-1,
- 				device_number, cifs_sb->local_nls,
- 				cifs_sb->mnt_cifs_flags &
- 					CIFS_MOUNT_MAP_SPECIAL_CHR);
+ 			args.uid = NO_CHANGE_64;
+ 			args.gid = NO_CHANGE_64;
  		}
+ 		rc = CIFSSMBUnixSetInfo(xid, pTcon, full_path,
+ 			&args, cifs_sb->local_nls,
+ 			cifs_sb->mnt_cifs_flags &
+ 				CIFS_MOUNT_MAP_SPECIAL_CHR);
  
  		if (!rc) {
  			rc = cifs_get_inode_info_unix(&newinode, full_path,
diff --cc fs/cifs/inode.c
index 4857f15,28a2209..e18ce20
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@@ -984,25 -985,34 +985,34 @@@ mkdir_get_info
  		  * failed to get it from the server or was set bogus */
  		if ((direntry->d_inode) && (direntry->d_inode->i_nlink < 2))
  				direntry->d_inode->i_nlink = 2;
+ 
  		mode &= ~current->fs->umask;
+ 		/* must turn on setgid bit if parent dir has it */
+ 		if (inode->i_mode & S_ISGID)
+ 			mode |= S_ISGID;
+ 
  		if (pTcon->unix_ext) {
+ 			struct cifs_unix_set_info_args args = {
+ 				.mode	= mode,
+ 				.ctime	= NO_CHANGE_64,
+ 				.atime	= NO_CHANGE_64,
+ 				.mtime	= NO_CHANGE_64,
+ 				.device	= 0,
+ 			};
  			if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID) {
- 				CIFSSMBUnixSetPerms(xid, pTcon, full_path,
- 						    mode,
- 						    (__u64)current_fsuid(),
- 						    (__u64)current_fsgid(),
- 						    0 /* dev_t */,
- 						    cifs_sb->local_nls,
- 						    cifs_sb->mnt_cifs_flags &
- 						    CIFS_MOUNT_MAP_SPECIAL_CHR);
 -				args.uid = (__u64)current->fsuid;
++				args.uid = (__u64)current_fsuid();
+ 				if (inode->i_mode & S_ISGID)
+ 					args.gid = (__u64)inode->i_gid;
+ 				else
 -					args.gid = (__u64)current->fsgid;
++					args.gid = (__u64)current_fsgid();
  			} else {
- 				CIFSSMBUnixSetPerms(xid, pTcon, full_path,
- 						    mode, (__u64)-1,
- 						    (__u64)-1, 0 /* dev_t */,
- 						    cifs_sb->local_nls,
- 						    cifs_sb->mnt_cifs_flags &
- 						    CIFS_MOUNT_MAP_SPECIAL_CHR);
+ 				args.uid = NO_CHANGE_64;
+ 				args.gid = NO_CHANGE_64;
  			}
+ 			CIFSSMBUnixSetInfo(xid, pTcon, full_path, &args,
+ 					    cifs_sb->local_nls,
+ 					    cifs_sb->mnt_cifs_flags &
+ 					    CIFS_MOUNT_MAP_SPECIAL_CHR);
  		} else {
  			if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) &&
  			    (mode & S_IWUGO) == 0) {
@@@ -1023,9 -1033,13 +1033,13 @@@
  				if (cifs_sb->mnt_cifs_flags &
  				     CIFS_MOUNT_SET_UID) {
  					direntry->d_inode->i_uid =
 -						current->fsuid;
 +						current_fsuid();
- 					direntry->d_inode->i_gid =
- 						current_fsgid();
+ 					if (inode->i_mode & S_ISGID)
+ 						direntry->d_inode->i_gid =
+ 							inode->i_gid;
+ 					else
+ 						direntry->d_inode->i_gid =
 -							current->fsgid;
++							current_fsgid();
  				}
  			}
  		}


----

The code compiles ok -- let me know if anything seems wrong.


-- 
James Morris
<jmorris@namei.org>
