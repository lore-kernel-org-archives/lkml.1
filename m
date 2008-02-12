Return-Path: <linux-kernel-owner+w=401wt.eu-S1762262AbYBLXLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762262AbYBLXLh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 18:11:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759051AbYBLXKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 18:10:40 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:8053 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761155AbYBLXKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 18:10:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=P4xKGENunh7/bVpb3CDqgz/GBobErxrl4o3xEe5KZ5BPsBerwtBZJjaXamna4JZ5vBmT7eXM/J4CWUS3lm9M+amAqDYNFhQFeoDv7e+dSAYezFH+r7kCbn8pddEKJftUTW4/VJHvZ7bBcTwuLgUzHS3doCkiNcl08pN9DuER0J0=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>, shaggy@austin.ibm.com,
       jfs-discussion@lists.sourceforge.net
Subject: [PATCH] jfs: le*_add_cpu conversion
Date: Wed, 13 Feb 2008 00:06:16 +0100
Message-Id: <1202857582-15450-12-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1202857582-15450-1-git-send-email-marcin.slusarz@gmail.com>
References: <1202857582-15450-1-git-send-email-marcin.slusarz@gmail.com>
From: marcin.slusarz@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcin Slusarz <marcin.slusarz@gmail.com>

replace all:
little_endian_variable = cpu_to_leX(leX_to_cpu(little_endian_variable) +
					expression_in_cpu_byteorder);
with:
	leX_add_cpu(&little_endian_variable, expression_in_cpu_byteorder);
generated with semantic patch

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: shaggy@austin.ibm.com
Cc: jfs-discussion@lists.sourceforge.net
---
 fs/jfs/jfs_dmap.c  |   11 +++++------
 fs/jfs/jfs_imap.c  |   15 ++++++---------
 fs/jfs/jfs_xtree.c |   26 ++++++++------------------
 3 files changed, 19 insertions(+), 33 deletions(-)

diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
index e198506..2bc7d8a 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -2172,7 +2172,7 @@ static void dbAllocBits(struct bmap * bmp, struct dmap * dp, s64 blkno,
 	}
 
 	/* update the free count for this dmap */
-	dp->nfree = cpu_to_le32(le32_to_cpu(dp->nfree) - nblocks);
+	le32_add_cpu(&dp->nfree, -nblocks);
 
 	BMAP_LOCK(bmp);
 
@@ -2316,7 +2316,7 @@ static int dbFreeBits(struct bmap * bmp, struct dmap * dp, s64 blkno,
 
 	/* update the free count for this dmap.
 	 */
-	dp->nfree = cpu_to_le32(le32_to_cpu(dp->nfree) + nblocks);
+	le32_add_cpu(&dp->nfree, nblocks);
 
 	BMAP_LOCK(bmp);
 
@@ -3226,7 +3226,7 @@ static int dbAllocDmapBU(struct bmap * bmp, struct dmap * dp, s64 blkno,
 	}
 
 	/* update the free count for this dmap */
-	dp->nfree = cpu_to_le32(le32_to_cpu(dp->nfree) - nblocks);
+	le32_add_cpu(&dp->nfree, -nblocks);
 
 	/* reconstruct summary tree */
 	dbInitDmapTree(dp);
@@ -3660,9 +3660,8 @@ static int dbInitDmap(struct dmap * dp, s64 Blkno, int nblocks)
 			goto initTree;
 		}
 	} else {
-		dp->nblocks =
-		    cpu_to_le32(le32_to_cpu(dp->nblocks) + nblocks);
-		dp->nfree = cpu_to_le32(le32_to_cpu(dp->nfree) + nblocks);
+		le32_add_cpu(&dp->nblocks, nblocks);
+		le32_add_cpu(&dp->nfree, nblocks);
 	}
 
 	/* word number containing start block number */
diff --git a/fs/jfs/jfs_imap.c b/fs/jfs/jfs_imap.c
index 9bf29f7..734ec91 100644
--- a/fs/jfs/jfs_imap.c
+++ b/fs/jfs/jfs_imap.c
@@ -1019,8 +1019,7 @@ int diFree(struct inode *ip)
 		/* update the free inode counts at the iag, ag and
 		 * map level.
 		 */
-		iagp->nfreeinos =
-		    cpu_to_le32(le32_to_cpu(iagp->nfreeinos) + 1);
+		le32_add_cpu(&iagp->nfreeinos, 1);
 		imap->im_agctl[agno].numfree += 1;
 		atomic_inc(&imap->im_numfree);
 
@@ -1219,9 +1218,8 @@ int diFree(struct inode *ip)
 	/* update the number of free inodes and number of free extents
 	 * for the iag.
 	 */
-	iagp->nfreeinos = cpu_to_le32(le32_to_cpu(iagp->nfreeinos) -
-				      (INOSPEREXT - 1));
-	iagp->nfreeexts = cpu_to_le32(le32_to_cpu(iagp->nfreeexts) + 1);
+	le32_add_cpu(&iagp->nfreeinos, -(INOSPEREXT - 1));
+	le32_add_cpu(&iagp->nfreeexts, 1);
 
 	/* update the number of free inodes and backed inodes
 	 * at the ag and inode map level.
@@ -2124,7 +2122,7 @@ static int diAllocBit(struct inomap * imap, struct iag * iagp, int ino)
 	/* update the free inode count at the iag, ag, inode
 	 * map levels.
 	 */
-	iagp->nfreeinos = cpu_to_le32(le32_to_cpu(iagp->nfreeinos) - 1);
+	le32_add_cpu(&iagp->nfreeinos, -1);
 	imap->im_agctl[agno].numfree -= 1;
 	atomic_dec(&imap->im_numfree);
 
@@ -2378,9 +2376,8 @@ static int diNewExt(struct inomap * imap, struct iag * iagp, int extno)
 	/* update the free inode and free extent counts for the
 	 * iag.
 	 */
-	iagp->nfreeinos = cpu_to_le32(le32_to_cpu(iagp->nfreeinos) +
-				      (INOSPEREXT - 1));
-	iagp->nfreeexts = cpu_to_le32(le32_to_cpu(iagp->nfreeexts) - 1);
+	le32_add_cpu(&iagp->nfreeinos, (INOSPEREXT - 1));
+	le32_add_cpu(&iagp->nfreeexts, -1);
 
 	/* update the free and backed inode counts for the ag.
 	 */
diff --git a/fs/jfs/jfs_xtree.c b/fs/jfs/jfs_xtree.c
index a000aaa..5a61ebf 100644
--- a/fs/jfs/jfs_xtree.c
+++ b/fs/jfs/jfs_xtree.c
@@ -905,8 +905,7 @@ int xtInsert(tid_t tid,		/* transaction id */
 	XT_PUTENTRY(xad, xflag, xoff, xlen, xaddr);
 
 	/* advance next available entry index */
-	p->header.nextindex =
-	    cpu_to_le16(le16_to_cpu(p->header.nextindex) + 1);
+	le16_add_cpu(&p->header.nextindex, 1);
 
 	/* Don't log it if there are no links to the file */
 	if (!test_cflag(COMMIT_Nolink, ip)) {
@@ -997,8 +996,7 @@ xtSplitUp(tid_t tid,
 			    split->addr);
 
 		/* advance next available entry index */
-		sp->header.nextindex =
-		    cpu_to_le16(le16_to_cpu(sp->header.nextindex) + 1);
+		le16_add_cpu(&sp->header.nextindex, 1);
 
 		/* Don't log it if there are no links to the file */
 		if (!test_cflag(COMMIT_Nolink, ip)) {
@@ -1167,9 +1165,7 @@ xtSplitUp(tid_t tid,
 				    JFS_SBI(ip->i_sb)->nbperpage, rcbn);
 
 			/* advance next available entry index. */
-			sp->header.nextindex =
-			    cpu_to_le16(le16_to_cpu(sp->header.nextindex) +
-					1);
+			le16_add_cpu(&sp->header.nextindex, 1);
 
 			/* Don't log it if there are no links to the file */
 			if (!test_cflag(COMMIT_Nolink, ip)) {
@@ -1738,8 +1734,7 @@ int xtExtend(tid_t tid,		/* transaction id */
 		XT_PUTENTRY(xad, XAD_NEW, xoff, len, xaddr);
 
 		/* advance next available entry index */
-		p->header.nextindex =
-		    cpu_to_le16(le16_to_cpu(p->header.nextindex) + 1);
+		le16_add_cpu(&p->header.nextindex, 1);
 	}
 
 	/* get back old entry */
@@ -1905,8 +1900,7 @@ printf("xtTailgate: xoff:0x%lx xlen:0x%x xaddr:0x%lx\n",
 		XT_PUTENTRY(xad, XAD_NEW, xoff, xlen, xaddr);
 
 		/* advance next available entry index */
-		p->header.nextindex =
-		    cpu_to_le16(le16_to_cpu(p->header.nextindex) + 1);
+		le16_add_cpu(&p->header.nextindex, 1);
 	}
 
 	/* get back old XAD */
@@ -2567,8 +2561,7 @@ int xtAppend(tid_t tid,		/* transaction id */
 	XT_PUTENTRY(xad, xflag, xoff, xlen, xaddr);
 
 	/* advance next available entry index */
-	p->header.nextindex =
-	    cpu_to_le16(le16_to_cpu(p->header.nextindex) + 1);
+	le16_add_cpu(&p->header.nextindex, 1);
 
 	xtlck->lwm.offset =
 	    (xtlck->lwm.offset) ? min(index,(int) xtlck->lwm.offset) : index;
@@ -2631,8 +2624,7 @@ int xtDelete(tid_t tid, struct inode *ip, s64 xoff, s32 xlen, int flag)
 	 * delete the entry from the leaf page
 	 */
 	nextindex = le16_to_cpu(p->header.nextindex);
-	p->header.nextindex =
-	    cpu_to_le16(le16_to_cpu(p->header.nextindex) - 1);
+	le16_add_cpu(&p->header.nextindex, -1);
 
 	/*
 	 * if the leaf page bocome empty, free the page
@@ -2795,9 +2787,7 @@ xtDeleteUp(tid_t tid, struct inode *ip,
 					(nextindex - index -
 					 1) << L2XTSLOTSIZE);
 
-			p->header.nextindex =
-			    cpu_to_le16(le16_to_cpu(p->header.nextindex) -
-					1);
+			le16_add_cpu(&p->header.nextindex, -1);
 			jfs_info("xtDeleteUp(entry): 0x%lx[%d]",
 				 (ulong) parent->bn, index);
 		}
-- 
1.5.3.7

