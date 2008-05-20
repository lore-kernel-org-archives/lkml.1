Return-Path: <linux-kernel-owner+w=401wt.eu-S933454AbYETSJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933454AbYETSJj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 14:09:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762616AbYETSGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 14:06:32 -0400
Received: from rn-out-0910.google.com ([64.233.170.188]:36158 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932470AbYETSGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 14:06:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=xZveQTjGZ4eQ9JJpzQUE88QRzm5N6CZLu4eH60FFZZOkHSJsdq+eDG5cOapitSOLeapSI7400NHzmi76i+c5GqNLLZWM0TFP96igthgmkNUvnSbrkARMM3UTR24agVR+d6IJsze7ibRE5GJyuXvkEPzaPPj6Zp+E3S5Y+cTRHck=
Subject: [PATCH 09/21] xfs: use aligned-endian get/put helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 20 May 2008 11:06:14 -0700
Message-Id: <1211306774.5915.176.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/xfs/xfs_log.c         |    4 ++--
 fs/xfs/xfs_log_priv.h    |    6 +++---
 fs/xfs/xfs_log_recover.c |    9 ++++-----
 fs/xfs/xfs_mount.c       |   12 ++++++------
 4 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index afaee30..b90325d 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1529,7 +1529,7 @@ xlog_sync(xlog_t		*log,
 		 */
 		for (i = 0; i < split; i += BBSIZE) {
 			be32_add_cpu((__be32 *)dptr, 1);
-			if (be32_to_cpu(*(__be32 *)dptr) == XLOG_HEADER_MAGIC_NUM)
+			if (get_be32(dptr) == XLOG_HEADER_MAGIC_NUM)
 				be32_add_cpu((__be32 *)dptr, 1);
 			dptr += BBSIZE;
 		}
@@ -3387,7 +3387,7 @@ xlog_verify_iclog(xlog_t	 *log,
 	ptr = (xfs_caddr_t) &iclog->ic_header;
 	for (ptr += BBSIZE; ptr < ((xfs_caddr_t)&iclog->ic_header) + count;
 	     ptr += BBSIZE) {
-		if (be32_to_cpu(*(__be32 *)ptr) == XLOG_HEADER_MAGIC_NUM)
+		if (get_be32(ptr) == XLOG_HEADER_MAGIC_NUM)
 			xlog_panic("xlog_verify_iclog: unexpected magic num");
 	}
 
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 8952a39..858f8d4 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -63,10 +63,10 @@ static inline xfs_lsn_t xlog_assign_lsn(uint cycle, uint block)
 
 static inline uint xlog_get_cycle(char *ptr)
 {
-	if (be32_to_cpu(*(__be32 *)ptr) == XLOG_HEADER_MAGIC_NUM)
-		return be32_to_cpu(*((__be32 *)ptr + 1));
+	if (get_be32(ptr) == XLOG_HEADER_MAGIC_NUM)
+		return get_be32((__be32 *)ptr + 1);
 	else
-		return be32_to_cpu(*(__be32 *)ptr);
+		return get_be32(ptr);
 }
 
 #define BLK_AVG(blk1, blk2)	((blk1+blk2) >> 1)
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index e65ab4a..1b710c1 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -824,7 +824,7 @@ xlog_find_tail(
 		if ((error = xlog_bread(log, i, 1, bp)))
 			goto bread_err;
 		offset = xlog_align(log, i, 1, bp);
-		if (XLOG_HEADER_MAGIC_NUM == be32_to_cpu(*(__be32 *)offset)) {
+		if (XLOG_HEADER_MAGIC_NUM == get_be32(offset)) {
 			found = 1;
 			break;
 		}
@@ -840,8 +840,7 @@ xlog_find_tail(
 			if ((error = xlog_bread(log, i, 1, bp)))
 				goto bread_err;
 			offset = xlog_align(log, i, 1, bp);
-			if (XLOG_HEADER_MAGIC_NUM ==
-			    be32_to_cpu(*(__be32 *)offset)) {
+			if (XLOG_HEADER_MAGIC_NUM == get_be32(offset)) {
 				found = 2;
 				break;
 			}
@@ -3342,7 +3341,7 @@ xlog_pack_data_checksum(
 	up = (__be32 *)iclog->ic_datap;
 	/* divide length by 4 to get # words */
 	for (i = 0; i < (size >> 2); i++) {
-		chksum ^= be32_to_cpu(*up);
+		chksum ^= get_be32(up);
 		up++;
 	}
 	iclog->ic_header.h_chksum = cpu_to_be32(chksum);
@@ -3407,7 +3406,7 @@ xlog_unpack_data_checksum(
 
 	/* divide length by 4 to get # words */
 	for (i=0; i < be32_to_cpu(rhead->h_len) >> 2; i++) {
-		chksum ^= be32_to_cpu(*up);
+		chksum ^= get_be32(up);
 		up++;
 	}
 	if (chksum != be32_to_cpu(rhead->h_chksum)) {
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index da39884..e946b95 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -488,16 +488,16 @@ xfs_sb_to_disk(
 		} else {
 			switch (size) {
 			case 2:
-				*(__be16 *)(to_ptr + first) =
-					cpu_to_be16(*(__u16 *)(from_ptr + first));
+				put_be16(*(__u16 *)(from_ptr + first),
+					 to_ptr + first);
 				break;
 			case 4:
-				*(__be32 *)(to_ptr + first) =
-					cpu_to_be32(*(__u32 *)(from_ptr + first));
+				put_be32(*(__u32 *)(from_ptr + first),
+					 to_ptr + first);
 				break;
 			case 8:
-				*(__be64 *)(to_ptr + first) =
-					cpu_to_be64(*(__u64 *)(from_ptr + first));
+				put_be64(*(__u64 *)(from_ptr + first),
+					 to_ptr + first);
 				break;
 			default:
 				ASSERT(0);
-- 
1.5.5.1.570.g26b5e


