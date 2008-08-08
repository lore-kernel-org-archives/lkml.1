Return-Path: <linux-kernel-owner+w=401wt.eu-S1761283AbYHHVDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761283AbYHHVDf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 17:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759522AbYHHVD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 17:03:26 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:44403 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464AbYHHVDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 17:03:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=XNd4ZdcobjOCJmcI/JPYq7LpwfUFOYTzv88IHV2hipDYSk7nq+lNpdy8mw5KJlvJnQ
         l7MVXu829eXQkVycvKm2b9yU+iuAt2pEnN4iBUHgw8Hp+3aVNF6waqk+Y5DJPw5pKCFZ
         QXAS9Wy38ogthMkNdZ1j8kuqNiQpFHz9A+JbM=
Date: Sat, 9 Aug 2008 01:03:18 +0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: joern@logfs.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH -mm] logfs: fix printk format warnings
Message-ID: <20080808210318.GA5093@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Beregalov <a.beregalov@gmail.com>

LogFS: Fix printk format warnings


Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 fs/logfs/dir.c     |    5 +++--
 fs/logfs/gc.c      |    9 +++++----
 fs/logfs/segment.c |   24 +++++++++++++++---------
 3 files changed, 23 insertions(+), 15 deletions(-)

diff --git a/fs/logfs/dir.c b/fs/logfs/dir.c
index f0cf832..2323208 100644
--- a/fs/logfs/dir.c
+++ b/fs/logfs/dir.c
@@ -700,7 +700,8 @@ int logfs_replay_journal(struct super_block *sb)
 	if (super->s_victim_ino) {
 		/* delete victim inode */
 		ino = super->s_victim_ino;
-		printk(KERN_INFO"LogFS: delete unmapped inode #%llx\n", ino);
+		printk(KERN_INFO"LogFS: delete unmapped inode #%llx\n",
+				(unsigned long long)ino);
 		inode = logfs_iget(sb, ino);
 		if (!inode)
 			goto fail;
@@ -719,7 +720,7 @@ int logfs_replay_journal(struct super_block *sb)
 		ino = super->s_rename_dir;
 		pos = super->s_rename_pos;
 		printk(KERN_INFO"LogFS: delete unbacked dentry (%llx, %llx)\n",
-				ino, pos);
+				(unsigned long long)ino, (unsigned long long)pos);
 		inode = logfs_iget(sb, ino);
 		if (!inode)
 			goto fail;
diff --git a/fs/logfs/gc.c b/fs/logfs/gc.c
index 0767345..037e588 100644
--- a/fs/logfs/gc.c
+++ b/fs/logfs/gc.c
@@ -565,7 +565,8 @@ static int logfs_gc_once(struct super_block *sb)
 	pr_debug("GC segment #%02x at %x, %x required, %x free, %x valid, %llx free, %llx reserve\n",
 			segno, segno << super->s_segshift,
 			dist, super->s_free_list.count, valid,
-			super->s_free_bytes, super->s_gc_reserve);
+			(unsigned long long)super->s_free_bytes,
+			(unsigned long long)super->s_gc_reserve);
 	cleaned = logfs_gc_segment(sb, segno, dist);
 	pr_debug("GC segment #%02x complete\n", segno);
 	add_candidate(sb, segno, valid - cleaned, ec, dist, segment_gec);
@@ -654,20 +655,20 @@ static int check_area(struct super_block *sb, int i)
 		crc = logfs_crc32(&h, sizeof(h) - 4, 4);
 		if (crc != h.crc) {
 			printk(KERN_INFO "interrupted header at %llx\n",
-					dev_ofs(sb, segno, ofs));
+					(unsigned long long)dev_ofs(sb, segno, ofs));
 			return 0;
 		}
 	}
 	if (ofs > super->s_segsize - LOGFS_MAX_OBJECTSIZE) {
 		printk(KERN_INFO "%x bytes unaccounted data found at %llx - closing it\n",
 				ofs - area->a_used_bytes,
-				dev_ofs(sb, segno, ofs));
+				(unsigned long long)dev_ofs(sb, segno, ofs));
 		area->a_segno = 0;
 		area->a_is_open = 0;
 	} else if (ofs != area->a_used_bytes) {
 		printk(KERN_INFO "%x bytes unaccounted data found at %llx\n",
 				ofs - area->a_used_bytes,
-				dev_ofs(sb, segno, ofs));
+				(unsigned long long)dev_ofs(sb, segno, ofs));
 		area->a_used_bytes = ofs;
 	}
 	return 0;
diff --git a/fs/logfs/segment.c b/fs/logfs/segment.c
index 13d4301..4851aa5 100644
--- a/fs/logfs/segment.c
+++ b/fs/logfs/segment.c
@@ -111,8 +111,9 @@ static int __logfs_segment_write(struct inode *inode, void *buf,
 	shadow->new_ofs = ofs;
 	shadow->new_len = acc_len + LOGFS_HEADERSIZE;
 
-	pr_debug("write(%lx, %llx, %x) to %llx\n", inode->i_ino, shadow->bix,
-			area->a_level, ofs);
+	pr_debug("write(%lx, %llx, %x) to %llx\n", inode->i_ino,
+			(unsigned long long)shadow->bix,
+			area->a_level, (unsigned long long)ofs);
 	pr_debug("%2x %2x\n", area->a_level, area->a_segno);
 	/* FIXME merge with open_area */
 	logfs_close_area(area);
@@ -267,8 +268,8 @@ static int __logfs_segment_read(struct inode *inode, void *buf,
 	crc = logfs_crc32(&h, sizeof(h) - 4, 4);
 	if (crc != h.crc) {
 		printk(KERN_ERR"LOGFS: header crc error at %llx: expected %x, "
-				"got %x\n", ofs, be32_to_cpu(h.crc),
-				be32_to_cpu(crc));
+				"got %x\n", (unsigned long long)ofs,
+				be32_to_cpu(h.crc), be32_to_cpu(crc));
 		goto out_err;
 	}
 
@@ -276,8 +277,10 @@ static int __logfs_segment_read(struct inode *inode, void *buf,
 			|| check_pos(sb, be64_to_cpu(h.bix), bix, level)) {
 		printk(KERN_ERR"LOGFS: (ino, bix) don't match at %llx: "
 				"expected (%lx, %llx), got %llx, %llx)\n",
-				ofs, inode->i_ino, bix,
-				be64_to_cpu(h.ino), be64_to_cpu(h.bix));
+				(unsigned long long)ofs, inode->i_ino,
+				(unsigned long long)bix,
+				(unsigned long long)be64_to_cpu(h.ino),
+				(unsigned long long)be64_to_cpu(h.bix));
 		goto out_err;
 	}
 
@@ -291,7 +294,8 @@ static int __logfs_segment_read(struct inode *inode, void *buf,
 		crc = logfs_crc32(buf, len, 0);
 		if (crc != h.data_crc) {
 			printk(KERN_ERR"LOGFS: uncompressed data crc error at "
-					"%llx: expected %x, got %x\n", ofs,
+					"%llx: expected %x, got %x\n",
+					(unsigned long long)ofs,
 					be32_to_cpu(h.data_crc),
 					be32_to_cpu(crc));
 			goto out_err;
@@ -307,7 +311,8 @@ static int __logfs_segment_read(struct inode *inode, void *buf,
 		crc = logfs_crc32(compressor_buf, len, 0);
 		if (crc != h.data_crc) {
 			printk(KERN_ERR"LOGFS: compressed data crc error at "
-					"%llx: expected %x, got %x\n", ofs,
+					"%llx: expected %x, got %x\n",
+					(unsigned long long)ofs,
 					be32_to_cpu(h.data_crc),
 					be32_to_cpu(crc));
 			mutex_unlock(&logfs_super(sb)->s_journal_mutex);
@@ -316,7 +321,8 @@ static int __logfs_segment_read(struct inode *inode, void *buf,
 		err = logfs_uncompress(compressor_buf, buf, len, bs);
 		mutex_unlock(&logfs_super(sb)->s_journal_mutex);
 		if (err) {
-			printk(KERN_ERR"LOGFS: uncompress error at %llx\n", ofs);
+			printk(KERN_ERR"LOGFS: uncompress error at %llx\n",
+					(unsigned long long)ofs);
 			goto out_err;
 		}
 		break;
