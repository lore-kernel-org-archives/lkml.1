Return-Path: <linux-kernel-owner+w=401wt.eu-S932784AbYETSIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932784AbYETSIu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 14:08:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757629AbYETSG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 14:06:28 -0400
Received: from rn-out-0910.google.com ([64.233.170.188]:36158 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932451AbYETSG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 14:06:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=hwyiet4EjUNCA/jOhxGkgCF/vFkCY0LgwmESV5k9ldYHWjJeSs6ehUzTDUrWVrt2jBdcX+FyI8YAmdV+d06jGuaivBQP67GBdYydNYjFNAVhtuP6QykCYDhdYJTSDi6ZXpVLOxZRgwYXM9fadQKLQNivmsiRPqRs8bOf5hQ3o4M=
Subject: [PATCH 17/21] fs: remaining users of aligned-endian get/put helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 20 May 2008 11:06:13 -0700
Message-Id: <1211306773.5915.174.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/hfsplus/wrapper.c  |    6 +++---
 fs/isofs/compress.c   |    4 ++--
 fs/partitions/acorn.c |    2 +-
 fs/qnx4/inode.c       |    2 +-
 fs/reiserfs/super.c   |    2 +-
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/hfsplus/wrapper.c b/fs/hfsplus/wrapper.c
index 175d08e..0e2fd86 100644
--- a/fs/hfsplus/wrapper.c
+++ b/fs/hfsplus/wrapper.c
@@ -35,17 +35,17 @@ static int hfsplus_read_mdb(void *bufptr, struct hfsplus_wd *wd)
 	    sig != cpu_to_be16(HFSPLUS_VOLHEAD_SIGX))
 		return 0;
 
-	attrib = be16_to_cpu(*(__be16 *)(bufptr + HFSP_WRAPOFF_ATTRIB));
+	attrib = get_be16(bufptr + HFSP_WRAPOFF_ATTRIB);
 	if (!(attrib & HFSP_WRAP_ATTRIB_SLOCK) ||
 	   !(attrib & HFSP_WRAP_ATTRIB_SPARED))
 		return 0;
 
-	wd->ablk_size = be32_to_cpu(*(__be32 *)(bufptr + HFSP_WRAPOFF_ABLKSIZE));
+	wd->ablk_size = get_be32(bufptr + HFSP_WRAPOFF_ABLKSIZE);
 	if (wd->ablk_size < HFSPLUS_SECTOR_SIZE)
 		return 0;
 	if (wd->ablk_size % HFSPLUS_SECTOR_SIZE)
 		return 0;
-	wd->ablk_start = be16_to_cpu(*(__be16 *)(bufptr + HFSP_WRAPOFF_ABLKSTART));
+	wd->ablk_start = get_be16(bufptr + HFSP_WRAPOFF_ABLKSTART);
 
 	extent = get_unaligned_be32(bufptr + HFSP_WRAPOFF_EMBEDEXT);
 	wd->embed_start = (extent >> 16) & 0xFFFF;
diff --git a/fs/isofs/compress.c b/fs/isofs/compress.c
index defb932..d6b9f47 100644
--- a/fs/isofs/compress.c
+++ b/fs/isofs/compress.c
@@ -124,7 +124,7 @@ static int zisofs_readpage(struct file *file, struct page *page)
 			brelse(ptrbh[1]);
 		goto eio;
 	}
-	cstart = le32_to_cpu(*(__le32 *)(bh->b_data + (blockptr & bufmask)));
+	cstart = get_le32(bh->b_data + (blockptr & bufmask));
 
 	if ( indexblocks == 2 ) {
 		/* We just crossed a block boundary.  Switch to the next block */
@@ -136,7 +136,7 @@ static int zisofs_readpage(struct file *file, struct page *page)
 			goto eio;
 		}
 	}
-	cend = le32_to_cpu(*(__le32 *)(bh->b_data + (blockendptr & bufmask)));
+	cend = get_le32(bh->b_data + (blockendptr & bufmask));
 	brelse(bh);
 
 	if (cstart > cend)
diff --git a/fs/partitions/acorn.c b/fs/partitions/acorn.c
index 3d3e166..45cbb3a 100644
--- a/fs/partitions/acorn.c
+++ b/fs/partitions/acorn.c
@@ -344,7 +344,7 @@ static inline int valid_ics_sector(const unsigned char *data)
 	for (i = 0, sum = 0x50617274; i < 508; i++)
 		sum += data[i];
 
-	sum -= le32_to_cpu(*(__le32 *)(&data[508]));
+	sum -= get_le32(&data[508]);
 
 	return sum == 0;
 }
diff --git a/fs/qnx4/inode.c b/fs/qnx4/inode.c
index b31ab78..80872f5 100644
--- a/fs/qnx4/inode.c
+++ b/fs/qnx4/inode.c
@@ -372,7 +372,7 @@ static int qnx4_fill_super(struct super_block *s, void *data, int silent)
 		printk("qnx4: unable to read the superblock\n");
 		goto outnobh;
 	}
-	if ( le32_to_cpup((__le32*) bh->b_data) != QNX4_SUPER_MAGIC ) {
+	if (get_le32(bh->b_data) != QNX4_SUPER_MAGIC) {
 		if (!silent)
 			printk("qnx4: wrong fsid in superblock.\n");
 		goto out;
diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index ed424d7..d7b0215 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -221,7 +221,7 @@ static int finish_unfinished(struct super_block *s)
 
 		/* reiserfs_iget needs k_dirid and k_objectid only */
 		item = B_I_PITEM(bh, ih);
-		obj_key.on_disk_key.k_dir_id = le32_to_cpu(*(__le32 *) item);
+		obj_key.on_disk_key.k_dir_id = get_le32(item);
 		obj_key.on_disk_key.k_objectid =
 		    le32_to_cpu(ih->ih_key.k_objectid);
 		obj_key.on_disk_key.k_offset = 0;
-- 
1.5.5.1.570.g26b5e


