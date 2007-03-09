Return-Path: <linux-kernel-owner+w=401wt.eu-S965812AbXCIUtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965812AbXCIUtm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 15:49:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752467AbXCIUtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 15:49:42 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60038 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752449AbXCIUtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 15:49:41 -0500
Date: Fri, 9 Mar 2007 15:49:20 -0500
Message-Id: <200703092049.l29KnKgh009449@dantu.rdu.redhat.com>
From: Jeff Layton <jlayton@redhat.com>
To: linux-cifs-client@lists.samba.org
Cc: linux-kernel@vger.kernel.org, smfrench@austin.rr.com
Subject: [PATCH] CIFS: reset file mode when CIFS client notices that ATTR_READONLY is no longer set
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This problem and patch were discovered and written by Alan Tyson of HP, who
asked that I post this. The problem is this:

When the CIFS client mounts a share that does not have Unix extensions, it
will turn off the "w" bits in the file mode if it sees that ATTR_READONLY is
set. It has no corresponding logic, however, to reenable write permissions if
the ATTR_READONLY flag is later removed. This results in a situation where a
file gets "stuck" as read-only. Steps to reproduce this bug are in the
following samba.org BZ:

https://bugzilla.samba.org/show_bug.cgi?id=4443

The patch below corrects this with the following logic:

If unix extensions were not negotiated for the mount, and the server does not
report ATTR_READONLY being set for the file then check the mode bits on the
inode. If no write bits are set, then assume that ATTR_READONLY was previously
set for this file but is not now, and set any write bits allowed by the
mnt_file_mode.

This logic seems reasonable, but I'm not certain that there aren't cases where
it would fall down. Comments and/or ACK's appreciated...

Signed-off-by: Jeff Layton <jlayton@redhat.com>

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 86b9dbb..e75a844 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -494,6 +494,12 @@ int cifs_get_inode_info(struct inode **pinode,
 			   mode e.g. 555 */
 			if (cifsInfo->cifsAttrs & ATTR_READONLY)
 				inode->i_mode &= ~(S_IWUGO);
+			else if ((inode->i_mode & S_IWUGO) == 0)
+				/* the ATTR_READONLY flag may have been	*/
+				/* changed on server -- set any w bits	*/
+				/* allowed by mnt_file_mode		*/
+				inode->i_mode |= (S_IWUGO &
+						  cifs_sb->mnt_file_mode);
 		/* BB add code here -
 		   validate if device or weird share or device type? */
 		}
diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index 44cfb52..2a374d5 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -219,6 +219,10 @@ static void fill_in_inode(struct inode *tmp_inode, int new_buf_type,
 		tmp_inode->i_mode |= S_IFREG;
 		if (attr & ATTR_READONLY)
 			tmp_inode->i_mode &= ~(S_IWUGO);
+		else if ((tmp_inode->i_mode & S_IWUGO) == 0)
+			/* the ATTR_READONLY flag may have been changed on   */
+		   	/* server -- set any w bits allowed by mnt_file_mode */
+			tmp_inode->i_mode |= (S_IWUGO & cifs_sb->mnt_file_mode);
 	} /* could add code here - to validate if device or weird share type? */
 
 	/* can not fill in nlink here as in qpathinfo version and Unx search */
