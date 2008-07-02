Return-Path: <linux-kernel-owner+w=401wt.eu-S932190AbYGBJ6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190AbYGBJ6r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 05:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758872AbYGBJ6D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 05:58:03 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56994 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753480AbYGBJ5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 05:57:52 -0400
From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH] [CIFS] fix inode leak in cifs_get_inode_info_unix
To: smfrench@gmail.com
Cc: niallain@gmail.com, linux-cifs-client@lists.samba.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 02 Jul 2008 05:57:38 -0400
Message-ID: <20080702095734.31936.79354.stgit@dantu.usersys.redhat.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Try this:

    mount a share with unix extensions
    create a file on it
    umount the share

You'll get the following message in the ring buffer:

VFS: Busy inodes after unmount of cifs. Self-destruct in 5 seconds.  Have a
nice day...

...the problem is that cifs_get_inode_info_unix is creating and hashing
a new inode even when it's going to return error anyway. The first
lookup when creating a file returns an error so we end up leaking this
inode before we do the actual create. This appears to be a regression
caused by commit 0e4bbde94fdc33f5b3d793166b21bf768ca3e098.

The following patch seems to fix it for me, and fixes a minor
formatting nit as well.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---

 fs/cifs/inode.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 722be54..2e904bd 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -219,15 +219,15 @@ int cifs_get_inode_info_unix(struct inode **pinode,
 	rc = CIFSSMBUnixQPathInfo(xid, pTcon, full_path, &find_data,
 				  cifs_sb->local_nls, cifs_sb->mnt_cifs_flags &
 					CIFS_MOUNT_MAP_SPECIAL_CHR);
-	if (rc) {
-		if (rc == -EREMOTE && !is_dfs_referral) {
-			is_dfs_referral = true;
-			cFYI(DBG2, ("DFS ref"));
-			/* for DFS, server does not give us real inode data */
-			fill_fake_finddataunix(&find_data, sb);
-			rc = 0;
-		}
-	}
+	if (rc == -EREMOTE && !is_dfs_referral) {
+		is_dfs_referral = true;
+		cFYI(DBG2, ("DFS ref"));
+		/* for DFS, server does not give us real inode data */
+		fill_fake_finddataunix(&find_data, sb);
+		rc = 0;
+	} else if (rc)
+		goto cgiiu_exit;
+
 	num_of_bytes = le64_to_cpu(find_data.NumOfBytes);
 	end_of_file = le64_to_cpu(find_data.EndOfFile);
 
@@ -236,7 +236,7 @@ int cifs_get_inode_info_unix(struct inode **pinode,
 		*pinode = new_inode(sb);
 		if (*pinode == NULL) {
 			rc = -ENOMEM;
-		goto cgiiu_exit;
+			goto cgiiu_exit;
 		}
 		/* Is an i_ino of zero legal? */
 		/* note ino incremented to unique num in new_inode */

