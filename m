Return-Path: <linux-kernel-owner+w=401wt.eu-S933716AbYETSLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933716AbYETSLA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 14:11:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765300AbYETSGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 14:06:45 -0400
Received: from el-out-1112.google.com ([209.85.162.176]:3485 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758482AbYETSGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 14:06:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=bWhMTlg8ealvgUeBjfNersNrUEicXaERlm26yhNOcW3IuDnRQPxzqjR2VRE5lI0qGAaA2kP0z/Mp4oBXZX49jW0cN5dXPrgRlzoVQOgYKAqQ7fBUTuuPEFQX2OC0XJi1jbKeuwc/DeZUn1aRUSdGSNTD9hyyF3f/edARj8jLL9Y=
Subject: [PATCH 16/21] gfs2: use aligned-endian get/put helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 20 May 2008 11:06:17 -0700
Message-Id: <1211306777.5915.179.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/gfs2/bmap.c |    2 +-
 fs/gfs2/lops.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index c19184f..42473ee 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -160,7 +160,7 @@ int gfs2_unstuff_dinode(struct gfs2_inode *ip, struct page *page)
 	gfs2_buffer_clear_tail(dibh, sizeof(struct gfs2_dinode));
 
 	if (ip->i_di.di_size) {
-		*(__be64 *)(di + 1) = cpu_to_be64(block);
+		put_be64(block, di + 1);;
 		gfs2_add_inode_blocks(&ip->i_inode, 1);
 		di->di_blocks = cpu_to_be64(gfs2_get_inode_blocks(&ip->i_inode));
 	}
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 4390f6f..3e7cac3 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -352,7 +352,7 @@ static void revoke_lo_before_commit(struct gfs2_sbd *sdp)
 			offset = sizeof(struct gfs2_meta_header);
 		}
 
-		*(__be64 *)(bh->b_data + offset) = cpu_to_be64(bd->bd_blkno);
+		put_be64(bd->bd_blkno, bh->b_data + offset);
 		kmem_cache_free(gfs2_bufdata_cachep, bd);
 
 		offset += sizeof(u64);
@@ -401,7 +401,7 @@ static int revoke_lo_scan_elements(struct gfs2_jdesc *jd, unsigned int start,
 			gfs2_metatype_check(sdp, bh, GFS2_METATYPE_LB);
 
 		while (offset + sizeof(u64) <= sdp->sd_sb.sb_bsize) {
-			blkno = be64_to_cpu(*(__be64 *)(bh->b_data + offset));
+			blkno = get_be64(bh->b_data + offset);
 
 			error = gfs2_revoke_add(sdp, blkno, start);
 			if (error < 0) {
-- 
1.5.5.1.570.g26b5e


