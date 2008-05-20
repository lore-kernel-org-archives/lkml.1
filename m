Return-Path: <linux-kernel-owner+w=401wt.eu-S933818AbYETSNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933818AbYETSNG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 14:13:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759571AbYETSHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 14:07:09 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:3977 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932329AbYETSHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 14:07:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=CBBX9gDcPV3J43E4bwU2/8hq8rEEPjLRi/2GamG5cUTj1YnJY1AWOsJikWH2tGFSInDH3L+jMe+JTlHxZoCccr9wsqiAK7eRPKyZcg7TBmIdX6pQA53XJM6i7ZyrNSoW9a8dNanhOSb2sKKzBnN4sul0aAUbreyaxovO5t2XR98=
Subject: [PATCH 11/21] affs: use aligned-endian get/put helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 20 May 2008 11:06:20 -0700
Message-Id: <1211306780.5915.184.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/affs/bitmap.c |   14 +++++++-------
 fs/affs/super.c  |    2 +-
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/affs/bitmap.c b/fs/affs/bitmap.c
index c4a5ad0..3df7327 100644
--- a/fs/affs/bitmap.c
+++ b/fs/affs/bitmap.c
@@ -92,14 +92,14 @@ affs_free_block(struct super_block *sb, u32 block)
 	data = (__be32 *)bh->b_data + bit / 32 + 1;
 
 	/* mark block free */
-	tmp = be32_to_cpu(*data);
+	tmp = get_be32(*data);
 	if (tmp & mask)
 		goto err_free;
 	*data = cpu_to_be32(tmp | mask);
 
 	/* fix checksum */
-	tmp = be32_to_cpu(*(__be32 *)bh->b_data);
-	*(__be32 *)bh->b_data = cpu_to_be32(tmp - mask);
+	tmp = get_be32(bh->b_data);
+	put_be32(tmp - mask, bh->b_data);
 
 	mark_buffer_dirty(bh);
 	sb->s_dirt = 1;
@@ -208,7 +208,7 @@ find_bmap_bit:
 	mask = ~0UL << (bit & 31);
 	blk &= ~31UL;
 
-	tmp = be32_to_cpu(*data);
+	tmp = get_be32(data);
 	if (tmp & mask)
 		goto find_bit;
 
@@ -221,7 +221,7 @@ find_bmap_bit:
 			 */
 			goto find_bmap;
 	} while (!*data);
-	tmp = be32_to_cpu(*data);
+	tmp = get_be32(data);
 	mask = ~0;
 
 find_bit:
@@ -243,8 +243,8 @@ find_bit:
 	*data = cpu_to_be32(tmp & ~mask);
 
 	/* fix checksum */
-	tmp = be32_to_cpu(*(__be32 *)bh->b_data);
-	*(__be32 *)bh->b_data = cpu_to_be32(tmp + mask);
+	tmp = get_be32(bh->b_data);
+	put_be32(tmp + mask, bh->b_data);
 
 	mark_buffer_dirty(bh);
 	sb->s_dirt = 1;
diff --git a/fs/affs/super.c b/fs/affs/super.c
index d214837..cd7c1d4 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -379,7 +379,7 @@ got_root:
 	}
 	memcpy(sig, boot_bh->b_data, 4);
 	brelse(boot_bh);
-	chksum = be32_to_cpu(*(__be32 *)sig);
+	chksum = get_be32(sig);
 
 	/* Dircache filesystems are compatible with non-dircache ones
 	 * when reading. As long as they aren't supported, writing is
-- 
1.5.5.1.570.g26b5e


