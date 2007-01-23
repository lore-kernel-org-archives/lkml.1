Return-Path: <linux-kernel-owner+w=401wt.eu-S965242AbXAWVNH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965242AbXAWVNH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 16:13:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965224AbXAWVNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 16:13:07 -0500
Received: from colo.lackof.org ([198.49.126.79]:37190 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965242AbXAWVNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 16:13:06 -0500
Date: Tue, 23 Jan 2007 14:12:57 -0700
From: dann frazier <dannf@dannf.org>
To: Willy Tarreau <w@1wt.eu>
Cc: Grant Coady <gcoady.lk@gmail.com>,
       Santiago Garcia Mantinan <manty@debian.org>,
       linux-kernel@vger.kernel.org, debian-kernel@lists.debian.org
Subject: Re: problems with latest smbfs changes on 2.4.34 and security backports
Message-ID: <20070123211256.GB26310@colo>
References: <20070117100030.GA11251@clandestino.aytolacoruna.es> <20070117215519.GX24090@1wt.eu> <20070119010040.GR16053@colo> <20070120010544.GY26210@colo> <t1r7r2thimh3gpuhtfc9l3aehjdd6dqkp8@4ax.com> <20070121230321.GC2480@1wt.eu> <lpu7r2lbtpm5cui8v1qpuj2fb5k3vs6f4n@4ax.com> <20070122181942.GJ28073@colo> <20070123054258.GA10301@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070123054258.GA10301@1wt.eu>
User-Agent: mutt-ng/devel-r782 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Users have reported a symlink issue with my recent smbfs backport.
Turns out my backport overlooked a second 2.6 patch w/ the fix:
 http://linux.bkbits.net:8080/linux-2.6/?PAGE=cset&REV=419e7b76CdrmRG_NZ8LKj9DUUBGu1w

This is a backport of Haroldo Gamal's 2.6 patch that fixes the symlink
issue, and also cleans up an unnecessary double assignment. As his
commit message notes, you will need the userspace patches from Samba
Bug #999 in order to use the permission/ownership assigned by the
server.

Signed-off-by: dann frazier <dannf@debian.org>

diff --git a/fs/smbfs/inode.c b/fs/smbfs/inode.c
index be975fe..7fd9b51 100644
--- a/fs/smbfs/inode.c
+++ b/fs/smbfs/inode.c
@@ -513,10 +513,10 @@ smb_read_super(struct super_block *sb, void *raw_data, int silent)
 		mnt->flags = (oldmnt->file_mode >> 9) | SMB_MOUNT_UID |
 			SMB_MOUNT_GID | SMB_MOUNT_FMODE | SMB_MOUNT_DMODE;
 	} else {
-		mnt->file_mode = mnt->dir_mode = S_IRWXU | S_IRGRP | S_IXGRP |
-						S_IROTH | S_IXOTH | S_IFREG;
-		mnt->dir_mode = mnt->dir_mode = S_IRWXU | S_IRGRP | S_IXGRP |
-						S_IROTH | S_IXOTH | S_IFDIR;
+		mnt->file_mode = S_IRWXU | S_IRGRP | S_IXGRP |
+				S_IROTH | S_IXOTH | S_IFREG;
+	        mnt->dir_mode = S_IRWXU | S_IRGRP | S_IXGRP |
+				S_IROTH | S_IXOTH | S_IFDIR;
 		if (parse_options(mnt, raw_data))
 			goto out_bad_option;
 	}
diff --git a/fs/smbfs/proc.c b/fs/smbfs/proc.c
index 7f0794c..5570007 100644
--- a/fs/smbfs/proc.c
+++ b/fs/smbfs/proc.c
@@ -1994,10 +1994,11 @@ void smb_decode_unix_basic(struct smb_fattr *fattr, struct smb_sb_info *server,
 
 	if ( (server->mnt->flags & SMB_MOUNT_DMODE) &&
 	     (S_ISDIR(fattr->f_mode)) )
-		fattr->f_mode = (server->mnt->dir_mode & (S_IRWXU | S_IRWXG | S_IRWXO)) | S_IFDIR;
+		fattr->f_mode = (server->mnt->dir_mode & S_IRWXUGO) | S_IFDIR;
 	else if ( (server->mnt->flags & SMB_MOUNT_FMODE) &&
 	          !(S_ISDIR(fattr->f_mode)) )
-		fattr->f_mode = (server->mnt->file_mode & (S_IRWXU | S_IRWXG | S_IRWXO)) | S_IFREG;
+		fattr->f_mode = (server->mnt->file_mode & S_IRWXUGO) |
+				(fattr->f_mode & S_IFMT);
 
 }
 


-- 
dann frazier

