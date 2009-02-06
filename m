Return-Path: <linux-kernel-owner+w=401wt.eu-S1757002AbZBFAFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757002AbZBFAFl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 19:05:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756111AbZBFAFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 19:05:16 -0500
Received: from tundra.namei.org ([65.99.196.166]:2850 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754289AbZBFAFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 19:05:15 -0500
Date: Fri, 6 Feb 2009 11:05:02 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: Al Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [MERGE] integrity / vfs merge conflict resolved
Message-ID: <alpine.LRH.1.10.0902061103110.13961@tundra.namei.org>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I manually resolved a conflict between Linus and 
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

as follows (please review).

commit cb5629b10d64a8006622ce3a52bc887d91057d69
Merge: 8920d5a... f01d1d5...
Author: James Morris <jmorris@namei.org>
Date:   Fri Feb 6 11:01:45 2009 +1100

    Merge branch 'master' into next
    
    Conflicts:
    	fs/namei.c
    
    Manually merged per:
    
    diff --cc fs/namei.c
    index 734f2b5,bbc15c2..0000000
    --- a/fs/namei.c
    +++ b/fs/namei.c
    @@@ -860,9 -848,8 +849,10 @@@ static int __link_path_walk(const char
      		nd->flags |= LOOKUP_CONTINUE;
      		err = exec_permission_lite(inode);
      		if (err == -EAGAIN)
    - 			err = vfs_permission(nd, MAY_EXEC);
    + 			err = inode_permission(nd->path.dentry->d_inode,
    + 					       MAY_EXEC);
     +		if (!err)
     +			err = ima_path_check(&nd->path, MAY_EXEC);
       		if (err)
      			break;
    
    @@@ -1525,14 -1506,9 +1509,14 @@@ int may_open(struct path *path, int acc
      		flag &= ~O_TRUNC;
      	}
    
    - 	error = vfs_permission(nd, acc_mode);
    + 	error = inode_permission(inode, acc_mode);
      	if (error)
      		return error;
     +
    - 	error = ima_path_check(&nd->path,
    ++	error = ima_path_check(path,
     +			       acc_mode & (MAY_READ | MAY_WRITE | MAY_EXEC));
     +	if (error)
     +		return error;
      	/*
      	 * An append-only file must be opened in append mode for writing.
      	 */
    
    Signed-off-by: James Morris <jmorris@namei.org>

diff --cc fs/exec.c
index 9c789a5,0dd60a0..febfd8e
--- a/fs/exec.c
+++ b/fs/exec.c
@@@ -128,12 -123,10 +124,13 @@@ SYSCALL_DEFINE1(uselib, const char __us
  	if (nd.path.mnt->mnt_flags & MNT_NOEXEC)
  		goto exit;
  
- 	error = vfs_permission(&nd, MAY_READ | MAY_EXEC | MAY_OPEN);
+ 	error = inode_permission(nd.path.dentry->d_inode,
+ 				 MAY_READ | MAY_EXEC | MAY_OPEN);
  	if (error)
  		goto exit;
 +	error = ima_path_check(&nd.path, MAY_READ | MAY_EXEC | MAY_OPEN);
 +	if (error)
 +		goto exit;
  
  	file = nameidata_to_filp(&nd, O_RDONLY|O_LARGEFILE);
  	error = PTR_ERR(file);
@@@ -684,12 -671,9 +675,12 @@@ struct file *open_exec(const char *name
  	if (nd.path.mnt->mnt_flags & MNT_NOEXEC)
  		goto out_path_put;
  
- 	err = vfs_permission(&nd, MAY_EXEC | MAY_OPEN);
+ 	err = inode_permission(nd.path.dentry->d_inode, MAY_EXEC | MAY_OPEN);
  	if (err)
  		goto out_path_put;
 +	err = ima_path_check(&nd.path, MAY_EXEC | MAY_OPEN);
 +	if (err)
 +		goto out_path_put;
  
  	file = nameidata_to_filp(&nd, O_RDONLY|O_LARGEFILE);
  	if (IS_ERR(file))
diff --cc fs/namei.c
index 734f2b5,bbc15c2..1993176
--- a/fs/namei.c
+++ b/fs/namei.c
@@@ -860,9 -848,8 +849,10 @@@ static int __link_path_walk(const char 
  		nd->flags |= LOOKUP_CONTINUE;
  		err = exec_permission_lite(inode);
  		if (err == -EAGAIN)
- 			err = vfs_permission(nd, MAY_EXEC);
+ 			err = inode_permission(nd->path.dentry->d_inode,
+ 					       MAY_EXEC);
 +		if (!err)
 +			err = ima_path_check(&nd->path, MAY_EXEC);
   		if (err)
  			break;
  
@@@ -1525,14 -1506,9 +1509,14 @@@ int may_open(struct path *path, int acc
  		flag &= ~O_TRUNC;
  	}
  
- 	error = vfs_permission(nd, acc_mode);
+ 	error = inode_permission(inode, acc_mode);
  	if (error)
  		return error;
 +
- 	error = ima_path_check(&nd->path,
++	error = ima_path_check(path,
 +			       acc_mode & (MAY_READ | MAY_WRITE | MAY_EXEC));
 +	if (error)
 +		return error;
  	/*
  	 * An append-only file must be opened in append mode for writing.
  	 */


-- 
James Morris
<jmorris@namei.org>
