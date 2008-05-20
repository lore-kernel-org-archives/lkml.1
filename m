Return-Path: <linux-kernel-owner+w=401wt.eu-S933675AbYETSMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933675AbYETSMT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 14:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765244AbYETSG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 14:06:59 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:3977 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932784AbYETSG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 14:06:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=fp+G63pDYzutQFXD+lR1noHTr0rb/AjK7u2me+AWyms8cCcTlT7fTXySGFLc+MExzoO1vIVmhie0Q5/dOxrshScwTRMaVfDwuY/fxp1RO/m6tcCxeyTn0pe4ktammlkocRIV7MITZ8od9zzDLkPD70+FlK7X+wAJKny8jtpUEVE=
Subject: [PATCH 10/21] ntfs: use aligned-endian get/put helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 20 May 2008 11:06:19 -0700
Message-Id: <1211306779.5915.182.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/ntfs/collate.c  |    4 ++--
 fs/ntfs/compress.c |    9 ++++-----
 fs/ntfs/endian.h   |    6 +++---
 fs/ntfs/mst.c      |    2 +-
 fs/ntfs/super.c    |    2 +-
 5 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/fs/ntfs/collate.c b/fs/ntfs/collate.c
index 4a28ab3..d370931 100644
--- a/fs/ntfs/collate.c
+++ b/fs/ntfs/collate.c
@@ -52,8 +52,8 @@ static int ntfs_collate_ntofs_ulong(ntfs_volume *vol,
 	// FIXME:  We don't really want to bug here.
 	BUG_ON(data1_len != data2_len);
 	BUG_ON(data1_len != 4);
-	d1 = le32_to_cpup(data1);
-	d2 = le32_to_cpup(data2);
+	d1 = get_le32(data1);
+	d2 = get_le32(data2);
 	if (d1 < d2)
 		rc = -1;
 	else {
diff --git a/fs/ntfs/compress.c b/fs/ntfs/compress.c
index 33ff314..11ae29b 100644
--- a/fs/ntfs/compress.c
+++ b/fs/ntfs/compress.c
@@ -211,7 +211,7 @@ do_next_sb:
 	 * position in the compression block is one byte before its end so the
 	 * first two checks do not detect it.
 	 */
-	if (cb == cb_end || !le16_to_cpup((le16*)cb) ||
+	if (cb == cb_end || !get_le16(cb) ||
 			(*dest_index == dest_max_index &&
 			*dest_ofs == dest_max_ofs)) {
 		int i;
@@ -261,8 +261,7 @@ return_error:
 
 	/* Setup the current sub-block source pointers and validate range. */
 	cb_sb_start = cb;
-	cb_sb_end = cb_sb_start + (le16_to_cpup((le16*)cb) & NTFS_SB_SIZE_MASK)
-			+ 3;
+	cb_sb_end = cb_sb_start + (get_le16(cb) & NTFS_SB_SIZE_MASK) + 3;
 	if (cb_sb_end > cb_end)
 		goto return_overflow;
 
@@ -283,7 +282,7 @@ return_error:
 	dp_addr = (u8*)page_address(dp) + do_sb_start;
 
 	/* Now, we are ready to process the current sub-block (sb). */
-	if (!(le16_to_cpup((le16*)cb) & NTFS_SB_IS_COMPRESSED)) {
+	if (!(get_le16(cb) & NTFS_SB_IS_COMPRESSED)) {
 		ntfs_debug("Found uncompressed sub-block.");
 		/* This sb is not compressed, just copy it into destination. */
 
@@ -388,7 +387,7 @@ do_next_tag:
 			lg++;
 
 		/* Get the phrase token into i. */
-		pt = le16_to_cpup((le16*)cb);
+		pt = get_le16(cb);
 
 		/*
 		 * Calculate starting position of the byte sequence in
diff --git a/fs/ntfs/endian.h b/fs/ntfs/endian.h
index 927b5bf..7c0eafe 100644
--- a/fs/ntfs/endian.h
+++ b/fs/ntfs/endian.h
@@ -47,17 +47,17 @@ static inline s64 sle64_to_cpu(sle64 x)
 
 static inline s16 sle16_to_cpup(sle16 *x)
 {
-	return le16_to_cpu(*(__force le16*)x);
+	return get_le16(x);
 }
 
 static inline s32 sle32_to_cpup(sle32 *x)
 {
-	return le32_to_cpu(*(__force le32*)x);
+	return get_le32(x);
 }
 
 static inline s64 sle64_to_cpup(sle64 *x)
 {
-	return le64_to_cpu(*(__force le64*)x);
+	return get_le64(x);
 }
 
 static inline sle16 cpu_to_sle16(s16 x)
diff --git a/fs/ntfs/mst.c b/fs/ntfs/mst.c
index 5a858d8..c565d82 100644
--- a/fs/ntfs/mst.c
+++ b/fs/ntfs/mst.c
@@ -146,7 +146,7 @@ int pre_write_mst_fixup(NTFS_RECORD *b, const u32 size)
 	 * Cyclically increment the update sequence number
 	 * (skipping 0 and -1, i.e. 0xffff).
 	 */
-	usn = le16_to_cpup(usa_pos) + 1;
+	usn = get_le16(usa_pos) + 1;
 	if (usn == 0xffff || !usn)
 		usn = 1;
 	le_usn = cpu_to_le16(usn);
diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
index 3e76f3b..21680bc 100644
--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -566,7 +566,7 @@ static bool is_boot_sector_ntfs(const struct super_block *sb,
 		u32 i;
 
 		for (i = 0, u = (le32*)b; u < (le32*)(&b->checksum); ++u)
-			i += le32_to_cpup(u);
+			i += get_le32(u);
 		if (le32_to_cpu(b->checksum) != i)
 			ntfs_warning(sb, "Invalid boot sector checksum.");
 	}
-- 
1.5.5.1.570.g26b5e


