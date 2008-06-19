Return-Path: <linux-kernel-owner+w=401wt.eu-S1757962AbYFSBGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757962AbYFSBGm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 21:06:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755698AbYFSBGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 21:06:35 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:39841 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755645AbYFSBGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 21:06:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=LpOudoRrnJM46zFi2R4z6MWr4pkJISLACW+UKQtC3PVPNjYDtidgihC7D1l5XySAkE
         YzGlH8FkFugCtJHtc8uidGbxZKDO2nya5rR5xl615d+DcGHGVLMwHrd9xI9FUgFiq7Hx
         s856b6HD7hS0Je64LD4BpstI56VIntvhM7Ayw=
Subject: [PATCH] ecryptfs: Use unaligned byteswapping helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Pavel Roskin <proski@gnu.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 18 Jun 2008 18:06:35 -0700
Message-Id: <1213837595.2125.36.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than memcpy and cpu_to_be16/32.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/ecryptfs/crypto.c |   37 +++++++++++++++++--------------------
 1 files changed, 17 insertions(+), 20 deletions(-)

diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index e2832bc..c6d4448 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -33,6 +33,7 @@
 #include <linux/crypto.h>
 #include <linux/file.h>
 #include <linux/scatterlist.h>
+#include <asm/unaligned.h>
 #include "ecryptfs_kernel.h"
 
 static int
@@ -1032,10 +1033,9 @@ static int contains_ecryptfs_marker(char *data)
 {
 	u32 m_1, m_2;
 
-	memcpy(&m_1, data, 4);
-	m_1 = be32_to_cpu(m_1);
-	memcpy(&m_2, (data + 4), 4);
-	m_2 = be32_to_cpu(m_2);
+	m_1 = get_unaligned_be32(data);
+	m_2 = get_unaligned_be32(data + 4);
+
 	if ((m_1 ^ MAGIC_ECRYPTFS_MARKER) == m_2)
 		return 1;
 	ecryptfs_printk(KERN_DEBUG, "m_1 = [0x%.8x]; m_2 = [0x%.8x]; "
@@ -1073,8 +1073,8 @@ static int ecryptfs_process_flags(struct ecryptfs_crypt_stat *crypt_stat,
 	int i;
 	u32 flags;
 
-	memcpy(&flags, page_virt, 4);
-	flags = be32_to_cpu(flags);
+	flags = get_unaligned_be32(page_virt);
+
 	for (i = 0; i < ((sizeof(ecryptfs_flag_map)
 			  / sizeof(struct ecryptfs_flag_map_elem))); i++)
 		if (flags & ecryptfs_flag_map[i].file_flag) {
@@ -1100,9 +1100,9 @@ static void write_ecryptfs_marker(char *page_virt, size_t *written)
 
 	get_random_bytes(&m_1, (MAGIC_ECRYPTFS_MARKER_SIZE_BYTES / 2));
 	m_2 = (m_1 ^ MAGIC_ECRYPTFS_MARKER);
-	m_1 = cpu_to_be32(m_1);
+	cpu_to_be32s(&m_1);
 	memcpy(page_virt, &m_1, (MAGIC_ECRYPTFS_MARKER_SIZE_BYTES / 2));
-	m_2 = cpu_to_be32(m_2);
+	cpu_to_be32s(&m_2);
 	memcpy(page_virt + (MAGIC_ECRYPTFS_MARKER_SIZE_BYTES / 2), &m_2,
 	       (MAGIC_ECRYPTFS_MARKER_SIZE_BYTES / 2));
 	(*written) = MAGIC_ECRYPTFS_MARKER_SIZE_BYTES;
@@ -1121,8 +1121,7 @@ write_ecryptfs_flags(char *page_virt, struct ecryptfs_crypt_stat *crypt_stat,
 			flags |= ecryptfs_flag_map[i].file_flag;
 	/* Version is in top 8 bits of the 32-bit flag vector */
 	flags |= ((((u8)crypt_stat->file_version) << 24) & 0xFF000000);
-	flags = cpu_to_be32(flags);
-	memcpy(page_virt, &flags, 4);
+	put_unaligned_be32(flags, page_virt);
 	(*written) = 4;
 }
 
@@ -1238,11 +1237,9 @@ ecryptfs_write_header_metadata(char *virt,
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
 
@@ -1410,15 +1407,15 @@ static int parse_header_metadata(struct ecryptfs_crypt_stat *crypt_stat,
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
+	virt += sizeof(__be16);
+
 	crypt_stat->num_header_bytes_at_front =
 		(((size_t)num_header_extents_at_front
 		  * (size_t)header_extent_size));
-	(*bytes_read) = (sizeof(u32) + sizeof(u16));
+	(*bytes_read) = (sizeof(__be32) + sizeof(__be16));
 	if ((validate_header_size == ECRYPTFS_VALIDATE_HEADER_SIZE)
 	    && (crypt_stat->num_header_bytes_at_front
 		< ECRYPTFS_MINIMUM_HEADER_EXTENT_SIZE)) {
-- 
1.5.6.rc3.295.gdca2e



