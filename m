Return-Path: <linux-kernel-owner+w=401wt.eu-S932944AbYGQXJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932944AbYGQXJm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 19:09:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760527AbYGQXJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 19:09:30 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:52308 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758781AbYGQXJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 19:09:28 -0400
Subject: Re: latest -git: BUG at fs/jfs/namei.c:512 assert(ip->i_nlink)
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: jfs-discussion@lists.sourceforge.net,
       Johannes Weiner <hannes@saeurebad.de>, linux-kernel@vger.kernel.org
In-Reply-To: <19f34abd0807171135m4a3b39e6v4065ed676720ae46@mail.gmail.com>
References: <19f34abd0807171135m4a3b39e6v4065ed676720ae46@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 17 Jul 2008 18:09:24 -0500
Message-Id: <1216336164.32175.3.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-17 at 20:35 +0200, Vegard Nossum wrote:
> Hi,
> 
> I got this on latest -git with an intentionally corrupted filesystem image:
> 
> BUG at fs/jfs/namei.c:512 assert(ip->i_nlink)

This assert shouldn't be here.  It would be better to handle this with
jfs_error(), which will mark the superblock dirty, and take appropriate
action.

> Full log at http://folk.uio.no/vegardno/linux/log-1216318656.txt, but
> I think the preceding messages are just left-overs from previous
> mount/remount attempts. I can test patches.

How about this one?  So far, compile tested only.

JFS: The kernel shouldn't trap when deleting a file with nlink == 0.

Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

diff --git a/fs/jfs/namei.c b/fs/jfs/namei.c
index 2aba823..10340be 100644
--- a/fs/jfs/namei.c
+++ b/fs/jfs/namei.c
@@ -508,33 +508,35 @@ static int jfs_unlink(struct inode *dip, struct dentry *dentry)
 		IWRITE_UNLOCK(ip);
 		goto out1;
 	}
-
-	ASSERT(ip->i_nlink);
-
 	ip->i_ctime = dip->i_ctime = dip->i_mtime = CURRENT_TIME;
 	mark_inode_dirty(dip);
 
-	/* update target's inode */
-	inode_dec_link_count(ip);
+	if (ip->i_nlink == 0)
+		jfs_error(dip->i_sb, "jfs_unlink: i_nlink already zero");
+	else {
+		/* update target's inode */
+		inode_dec_link_count(ip);
 
-	/*
-	 *	commit zero link count object
-	 */
-	if (ip->i_nlink == 0) {
-		assert(!test_cflag(COMMIT_Nolink, ip));
-		/* free block resources */
-		if ((new_size = commitZeroLink(tid, ip)) < 0) {
-			txAbort(tid, 1);	/* Marks FS Dirty */
-			txEnd(tid);
-			mutex_unlock(&JFS_IP(ip)->commit_mutex);
-			mutex_unlock(&JFS_IP(dip)->commit_mutex);
-			IWRITE_UNLOCK(ip);
-			rc = new_size;
-			goto out1;
+		/*
+		 *	commit zero link count object
+		 */
+		if (ip->i_nlink == 0) {
+			assert(!test_cflag(COMMIT_Nolink, ip));
+			/* free block resources */
+			new_size = commitZeroLink(tid, ip);
+			if (new_size < 0) {
+				txAbort(tid, 1);	/* Marks FS Dirty */
+				txEnd(tid);
+				mutex_unlock(&JFS_IP(ip)->commit_mutex);
+				mutex_unlock(&JFS_IP(dip)->commit_mutex);
+				IWRITE_UNLOCK(ip);
+				rc = new_size;
+				goto out1;
+			}
+			tblk = tid_to_tblock(tid);
+			tblk->xflag |= COMMIT_DELETE;
+			tblk->u.ip = ip;
 		}
-		tblk = tid_to_tblock(tid);
-		tblk->xflag |= COMMIT_DELETE;
-		tblk->u.ip = ip;
 	}
 
 	/*

-- 
David Kleikamp
IBM Linux Technology Center

