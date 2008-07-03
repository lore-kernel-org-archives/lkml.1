Return-Path: <linux-kernel-owner+w=401wt.eu-S1755269AbYGCUcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269AbYGCUcS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 16:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752708AbYGCUcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 16:32:07 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:32786 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697AbYGCUcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 16:32:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=qaQuhfakdcytqFjuaCpCuQCqp2yNTN5VL/vClK3hRO/hEPPJCUPtoNGoCyVX3Hhi+0
         gGVqq7cReVloc+mteE8caz2dED/sTXijXE6K15CMqU4fkqtzSbsqXhvR/XaU3U2hegHv
         ZGvoNjajtpNAAetGuOH1FaQwQF0yo+TQ/DmS8=
Subject: [PATCH 1/2] ecryptfs: crypto.c use unaligned byteorder helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Mike Halcrow <mhalcrow@us.ibm.com>,
       Phillip Hellewell <phillip@hellewell.homeip.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 03 Jul 2008 13:31:23 -0700
Message-Id: <1215117084.16647.19.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the following sparse warnings:
fs/ecryptfs/crypto.c:1036:8: warning: cast to restricted __be32
fs/ecryptfs/crypto.c:1038:8: warning: cast to restricted __be32
fs/ecryptfs/crypto.c:1077:10: warning: cast to restricted __be32
fs/ecryptfs/crypto.c:1103:6: warning: incorrect type in assignment (different base types)
fs/ecryptfs/crypto.c:1105:6: warning: incorrect type in assignment (different base types)
fs/ecryptfs/crypto.c:1124:8: warning: incorrect type in assignment (different base types)
fs/ecryptfs/crypto.c:1241:21: warning: incorrect type in assignment (different base types)
fs/ecryptfs/crypto.c:1244:30: warning: incorrect type in assignment (different base types)
fs/ecryptfs/crypto.c:1414:23: warning: cast to restricted __be32
fs/ecryptfs/crypto.c:1417:32: warning: cast to restricted __be16

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/ecryptfs/crypto.c |   37 ++++++++++++++-----------------------
 1 files changed, 14 insertions(+), 23 deletions(-)

diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index e2832bc..7b99917 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -33,6 +33,7 @@
 #include <linux/crypto.h>
 #include <linux/file.h>
 #include <linux/scatterlist.h>
+#include <asm/unaligned.h>
 #include "ecryptfs_kernel.h"
 
 static int
@@ -1032,10 +1033,8 @@ static int contains_ecryptfs_marker(char *data)
 {
 	u32 m_1, m_2;
 
-	memcpy(&m_1, data, 4);
-	m_1 = be32_to_cpu(m_1);
-	memcpy(&m_2, (data + 4), 4);
-	m_2 = be32_to_cpu(m_2);
+	m_1 = get_unaligned_be32(data);
+	m_2 = get_unaligned_be32(data + 4);
 	if ((m_1 ^ MAGIC_ECRYPTFS_MARKER) == m_2)
 		return 1;
 	ecryptfs_printk(KERN_DEBUG, "m_1 = [0x%.8x]; m_2 = [0x%.8x]; "
@@ -1073,8 +1072,7 @@ static int ecryptfs_process_flags(struct ecryptfs_crypt_stat *crypt_stat,
 	int i;
 	u32 flags;
 
-	memcpy(&flags, page_virt, 4);
-	flags = be32_to_cpu(flags);
+	flags = get_unaligned_be32(page_virt);
 	for (i = 0; i < ((sizeof(ecryptfs_flag_map)
 			  / sizeof(struct ecryptfs_flag_map_elem))); i++)
 		if (flags & ecryptfs_flag_map[i].file_flag) {
@@ -1100,11 +1098,9 @@ static void write_ecryptfs_marker(char *page_virt, size_t *written)
 
 	get_random_bytes(&m_1, (MAGIC_ECRYPTFS_MARKER_SIZE_BYTES / 2));
 	m_2 = (m_1 ^ MAGIC_ECRYPTFS_MARKER);
-	m_1 = cpu_to_be32(m_1);
-	memcpy(page_virt, &m_1, (MAGIC_ECRYPTFS_MARKER_SIZE_BYTES / 2));
-	m_2 = cpu_to_be32(m_2);
-	memcpy(page_virt + (MAGIC_ECRYPTFS_MARKER_SIZE_BYTES / 2), &m_2,
-	       (MAGIC_ECRYPTFS_MARKER_SIZE_BYTES / 2));
+	put_unaligned_be32(m_1, page_virt);
+	page_virt += (MAGIC_ECRYPTFS_MARKER_SIZE_BYTES / 2);
+	put_unaligned_be32(m_2, page_virt);
 	(*written) = MAGIC_ECRYPTFS_MARKER_SIZE_BYTES;
 }
 
@@ -1121,8 +1117,7 @@ write_ecryptfs_flags(char *page_virt, struct ecryptfs_crypt_stat *crypt_stat,
 			flags |= ecryptfs_flag_map[i].file_flag;
 	/* Version is in top 8 bits of the 32-bit flag vector */
 	flags |= ((((u8)crypt_stat->file_version) << 24) & 0xFF000000);
-	flags = cpu_to_be32(flags);
-	memcpy(page_virt, &flags, 4);
+	put_unaligned_be32(flags, page_virt);
 	(*written) = 4;
 }
 
@@ -1238,11 +1233,9 @@ ecryptfs_write_header_metadata(char *virt,
 	num_header_extents_at_front =
 		(u16)(crypt_stat->num_header_bytes_at_front
 		      / crypt_stat->extent_size);
-	header_extent_size = cpu_to_be32(header_extent_size);
-	memcpy(virt, &header_extent_size, 4);
+	put_unaligned_be32(header_extent_size, virt);
 	virt += 4;
-	num_header_extents_at_front = cpu_to_be16(num_header_extents_at_front);
-	memcpy(virt, &num_header_extents_at_front, 2);
+	put_unaligned_be16(num_header_extents_at_front, virt);
 	(*written) = 6;
 }
 
@@ -1410,15 +1403,13 @@ static int parse_header_metadata(struct ecryptfs_crypt_stat *crypt_stat,
 	u32 header_extent_size;
 	u16 num_header_extents_at_front;
 
-	memcpy(&header_extent_size, virt, sizeof(u32));
-	header_extent_size = be32_to_cpu(header_extent_size);
-	virt += sizeof(u32);
-	memcpy(&num_header_extents_at_front, virt, sizeof(u16));
-	num_header_extents_at_front = be16_to_cpu(num_header_extents_at_front);
+	header_extent_size = get_unaligned_be32(virt);
+	virt += sizeof(__be32);
+	num_header_extents_at_front = get_unaligned_be16(virt);
 	crypt_stat->num_header_bytes_at_front =
 		(((size_t)num_header_extents_at_front
 		  * (size_t)header_extent_size));
-	(*bytes_read) = (sizeof(u32) + sizeof(u16));
+	(*bytes_read) = (sizeof(__be32) + sizeof(__be16));
 	if ((validate_header_size == ECRYPTFS_VALIDATE_HEADER_SIZE)
 	    && (crypt_stat->num_header_bytes_at_front
 		< ECRYPTFS_MINIMUM_HEADER_EXTENT_SIZE)) {
-- 
1.5.6.1.281.g1087e


