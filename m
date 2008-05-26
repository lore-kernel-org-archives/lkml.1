Return-Path: <linux-kernel-owner+w=401wt.eu-S1756717AbYEZM2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717AbYEZM2M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 08:28:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755702AbYEZMYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 08:24:01 -0400
Received: from smtp.nokia.com ([192.100.122.233]:49597 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755248AbYEZMXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 08:23:51 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [PATCH take 3 12/29] UBIFS: add key helpers
Date: Mon, 26 May 2008 17:05:26 +0300
Message-Id: <1211810743-18936-13-git-send-email-Artem.Bityutskiy@nokia.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1211810743-18936-1-git-send-email-Artem.Bityutskiy@nokia.com>
References: <1211810743-18936-1-git-send-email-Artem.Bityutskiy@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 26 May 2008 12:23:46.0432 (UTC) FILETIME=[58336000:01C8BF2B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This file implement various helper functions to work with UBIFS keys.
The keys are part of the UBIFS index which is a B-tree. For example,
directory entry key consists of the parent inode number and directory
entry hash.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
---
 fs/ubifs/key.h |  532 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 532 insertions(+), 0 deletions(-)

diff --git a/fs/ubifs/key.h b/fs/ubifs/key.h
new file mode 100644
index 0000000..e4d33d7
--- /dev/null
+++ b/fs/ubifs/key.h
@@ -0,0 +1,532 @@
+/*
+ * This file is part of UBIFS.
+ *
+ * Copyright (C) 2006-2008 Nokia Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 51
+ * Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
+ *
+ * Authors: Artem Bityutskiy (Битюцкий Артём)
+ *          Adrian Hunter
+ */
+
+/*
+ * This header contains various key-related definitions and helper function.
+ * UBIFS allows several key schemes, so we access key fields only via these
+ * helpers. At the moment only one key scheme is supported.
+ *
+ * Simple key scheme
+ * ~~~~~~~~~~~~~~~~~
+ *
+ * Keys are 64-bits long. First 32-bits are inode number (parent inode number
+ * in case of direntry key). Next 3 bits are node type. The last 29 bits are
+ * 4KiB offset in case of inode node, and direntry hash in case of a direntry
+ * node. We use "r5" hash borrowed from reiserfs.
+ */
+
+#ifndef __UBIFS_KEY_H__
+#define __UBIFS_KEY_H__
+
+/**
+ * key_r5_hash - R5 hash function (borrowed from reiserfs).
+ * @s: direntry name
+ * @len: name length
+ */
+static inline uint32_t key_r5_hash(const char *s, int len)
+{
+	uint32_t a = 0;
+	const signed char *str = (const signed char *)s;
+
+	while (*str) {
+		a += *str << 4;
+		a += *str >> 4;
+		a *= 11;
+		str++;
+	}
+
+	a &= UBIFS_S_KEY_HASH_MASK;
+
+	/*
+	 * We use hash values as offset in directories, so values %0 and %1 are
+	 * reserved for "." and "..". %2 is reserved for possible future use.
+	 */
+	if (unlikely(a >= 0 && a <= 2))
+		a += 3;
+	return a;
+}
+
+/**
+ * key_test_hash - testing hash function.
+ * @str: direntry name
+ * @len: name length
+ */
+static inline uint32_t key_test_hash(const char *str, int len)
+{
+	uint32_t a = 0;
+
+	len = min_t(uint32_t, len, 4);
+	memcpy(&a, str, len);
+	a &= UBIFS_S_KEY_HASH_MASK;
+	if (unlikely(a >= 0 && a <= 2))
+		a += 3;
+	return a;
+}
+
+/**
+ * ino_key_init - initialize inode key.
+ * @c: UBIFS file-system description object
+ * @key: key to initialize
+ * @inum: inode number
+ */
+static inline void ino_key_init(const struct ubifs_info *c,
+				union ubifs_key *key, ino_t inum)
+{
+	key->u32[0] = inum;
+	key->u32[1] = UBIFS_INO_KEY << UBIFS_S_KEY_BLOCK_BITS;
+}
+
+/**
+ * ino_key_init_flash - initialize on-flash inode key.
+ * @c: UBIFS file-system description object
+ * @k: key to initialize
+ * @inum: inode number
+ */
+static inline void ino_key_init_flash(const struct ubifs_info *c, void *k,
+				      ino_t inum)
+{
+	union ubifs_key *key = k;
+
+	key->j32[0] = cpu_to_le32(inum);
+	key->j32[1] = cpu_to_le32(UBIFS_INO_KEY << UBIFS_S_KEY_BLOCK_BITS);
+	memset(k + 8, 0, UBIFS_MAX_KEY_LEN - 8);
+}
+
+/**
+ * lowest_ino_key - get the lowest possible inode key.
+ * @c: UBIFS file-system description object
+ * @key: key to initialize
+ * @inum: inode number
+ */
+static inline void lowest_ino_key(const struct ubifs_info *c,
+				union ubifs_key *key, ino_t inum)
+{
+	key->u32[0] = inum;
+	key->u32[1] = 0;
+}
+
+/**
+ * highest_ino_key - get the highest possible inode key.
+ * @c: UBIFS file-system description object
+ * @key: key to initialize
+ * @inum: inode number
+ */
+static inline void highest_ino_key(const struct ubifs_info *c,
+				union ubifs_key *key, ino_t inum)
+{
+	key->u32[0] = inum;
+	key->u32[1] = 0xffffffff;
+}
+
+/**
+ * dent_key_init - initialize directory entry key.
+ * @c: UBIFS file-system description object
+ * @key: key to initialize
+ * @inum: parent inode number
+ * @nm: direntry name and length
+ */
+static inline void dent_key_init(const struct ubifs_info *c,
+				 union ubifs_key *key, ino_t inum,
+				 const struct qstr *nm)
+{
+	uint32_t hash = c->key_hash(nm->name, nm->len);
+
+	ubifs_assert(!(hash & ~UBIFS_S_KEY_HASH_MASK));
+	key->u32[0] = inum;
+	key->u32[1] = hash | (UBIFS_DENT_KEY << UBIFS_S_KEY_HASH_BITS);
+}
+
+/**
+ * dent_key_init_hash - initialize directory entry key without re-calculating
+ *                      hash function.
+ * @c: UBIFS file-system description object
+ * @key: key to initialize
+ * @inum: parent inode number
+ * @hash: direntry name hash
+ */
+static inline void dent_key_init_hash(const struct ubifs_info *c,
+				      union ubifs_key *key, ino_t inum,
+				      uint32_t hash)
+{
+	ubifs_assert(!(hash & ~UBIFS_S_KEY_HASH_MASK));
+	key->u32[0] = inum;
+	key->u32[1] = hash | (UBIFS_DENT_KEY << UBIFS_S_KEY_HASH_BITS);
+}
+
+/**
+ * dent_key_init_flash - initialize on-flash directory entry key.
+ * @c: UBIFS file-system description object
+ * @k: key to initialize
+ * @inum: parent inode number
+ * @nm: direntry name and length
+ */
+static inline void dent_key_init_flash(const struct ubifs_info *c, void *k,
+				       ino_t inum, const struct qstr *nm)
+{
+	union ubifs_key *key = k;
+	uint32_t hash = c->key_hash(nm->name, nm->len);
+
+	ubifs_assert(!(hash & ~UBIFS_S_KEY_HASH_MASK));
+	key->j32[0] = cpu_to_le32(inum);
+	key->j32[1] = cpu_to_le32(hash |
+				  (UBIFS_DENT_KEY << UBIFS_S_KEY_HASH_BITS));
+	memset(k + 8, 0, UBIFS_MAX_KEY_LEN - 8);
+}
+
+/**
+ * lowest_dent_key - get the lowest possible directory entry key.
+ * @c: UBIFS file-system description object
+ * @key: where to store the lowest key
+ * @inum: parent inode number
+ */
+static inline void lowest_dent_key(const struct ubifs_info *c,
+				   union ubifs_key *key, ino_t inum)
+{
+	key->u32[0] = inum;
+	key->u32[1] = UBIFS_DENT_KEY << UBIFS_S_KEY_HASH_BITS;
+}
+
+/**
+ * xent_key_init - initialize extended attribute entry key.
+ * @c: UBIFS file-system description object
+ * @key: key to initialize
+ * @inum: host inode number
+ * @nm: extended attribute entry name and length
+ */
+static inline void xent_key_init(const struct ubifs_info *c,
+				 union ubifs_key *key, ino_t inum,
+				 const struct qstr *nm)
+{
+	uint32_t hash = c->key_hash(nm->name, nm->len);
+
+	ubifs_assert(!(hash & ~UBIFS_S_KEY_HASH_MASK));
+	key->u32[0] = inum;
+	key->u32[1] = hash | (UBIFS_XENT_KEY << UBIFS_S_KEY_HASH_BITS);
+}
+
+/**
+ * xent_key_init_hash - initialize extended attribute entry key without
+ *                      re-calculating hash function.
+ * @c: UBIFS file-system description object
+ * @key: key to initialize
+ * @inum: host inode number
+ * @hash: extended attribute entry name hash
+ */
+static inline void xent_key_init_hash(const struct ubifs_info *c,
+				      union ubifs_key *key, ino_t inum,
+				      uint32_t hash)
+{
+	ubifs_assert(!(hash & ~UBIFS_S_KEY_HASH_MASK));
+	key->u32[0] = inum;
+	key->u32[1] = hash | (UBIFS_XENT_KEY << UBIFS_S_KEY_HASH_BITS);
+}
+
+/**
+ * xent_key_init_flash - initialize on-flash extended attribute entry key.
+ * @c: UBIFS file-system description object
+ * @k: key to initialize
+ * @inum: host inode number
+ * @nm: extended attribute entry name and length
+ */
+static inline void xent_key_init_flash(const struct ubifs_info *c, void *k,
+				       ino_t inum, const struct qstr *nm)
+{
+	union ubifs_key *key = k;
+	uint32_t hash = c->key_hash(nm->name, nm->len);
+
+	ubifs_assert(!(hash & ~UBIFS_S_KEY_HASH_MASK));
+	key->j32[0] = cpu_to_le32(inum);
+	key->j32[1] = cpu_to_le32(hash |
+				  (UBIFS_XENT_KEY << UBIFS_S_KEY_HASH_BITS));
+	memset(k + 8, 0, UBIFS_MAX_KEY_LEN - 8);
+}
+
+/**
+ * lowest_xent_key - get the lowest possible extended attribute entry key.
+ * @c: UBIFS file-system description object
+ * @key: where to store the lowest key
+ * @inum: host inode number
+ */
+static inline void lowest_xent_key(const struct ubifs_info *c,
+				   union ubifs_key *key, ino_t inum)
+{
+	key->u32[0] = inum;
+	key->u32[1] = UBIFS_XENT_KEY << UBIFS_S_KEY_HASH_BITS;
+}
+
+/**
+ * data_key_init - initialize data key.
+ * @c: UBIFS file-system description object
+ * @key: key to initialize
+ * @inum: inode number
+ * @block: block number
+ */
+static inline void data_key_init(const struct ubifs_info *c,
+				 union ubifs_key *key, ino_t inum,
+				 unsigned int block)
+{
+	ubifs_assert(!(block & ~UBIFS_S_KEY_BLOCK_MASK));
+	key->u32[0] = inum;
+	key->u32[1] = block | (UBIFS_DATA_KEY << UBIFS_S_KEY_BLOCK_BITS);
+}
+
+/**
+ * data_key_init_flash - initialize on-flash data key.
+ * @c: UBIFS file-system description object
+ * @k: key to initialize
+ * @inum: inode number
+ * @block: block number
+ */
+static inline void data_key_init_flash(const struct ubifs_info *c, void *k,
+				       ino_t inum, unsigned int block)
+{
+	union ubifs_key *key = k;
+
+	ubifs_assert(!(block & ~UBIFS_S_KEY_BLOCK_MASK));
+	key->j32[0] = cpu_to_le32(inum);
+	key->j32[1] = cpu_to_le32(block |
+				  (UBIFS_DATA_KEY << UBIFS_S_KEY_BLOCK_BITS));
+	memset(k + 8, 0, UBIFS_MAX_KEY_LEN - 8);
+}
+
+/**
+ * trun_key_init - initialize truncation node key.
+ * @c: UBIFS file-system description object
+ * @key: key to initialize
+ * @inum: inode number
+ */
+static inline void trun_key_init(const struct ubifs_info *c,
+				 union ubifs_key *key, ino_t inum)
+{
+	key->u32[0] = inum;
+	key->u32[1] = UBIFS_TRUN_KEY << UBIFS_S_KEY_BLOCK_BITS;
+}
+
+/**
+ * trun_key_init_flash - initialize on-flash truncation node key.
+ * @c: UBIFS file-system description object
+ * @k: key to initialize
+ * @inum: inode number
+ */
+static inline void trun_key_init_flash(const struct ubifs_info *c, void *k,
+				       ino_t inum)
+{
+	union ubifs_key *key = k;
+
+	key->j32[0] = cpu_to_le32(inum);
+	key->j32[1] = cpu_to_le32(UBIFS_TRUN_KEY << UBIFS_S_KEY_BLOCK_BITS);
+	memset(k + 8, 0, UBIFS_MAX_KEY_LEN - 8);
+}
+
+/**
+ * key_type - get key type.
+ * @c: UBIFS file-system description object
+ * @key: key to get type of
+ */
+static inline int key_type(const struct ubifs_info *c,
+			   const union ubifs_key *key)
+{
+	return key->u32[1] >> UBIFS_S_KEY_BLOCK_BITS;
+}
+
+/**
+ * key_type_flash - get type of a on-flash formatted key.
+ * @c: UBIFS file-system description object
+ * @k: key to get type of
+ */
+static inline int key_type_flash(const struct ubifs_info *c, const void *k)
+{
+	const union ubifs_key *key = k;
+
+	return le32_to_cpu(key->u32[1]) >> UBIFS_S_KEY_BLOCK_BITS;
+}
+
+/**
+ * key_ino - fetch inode number from key.
+ * @c: UBIFS file-system description object
+ * @k: key to fetch inode number from
+ */
+static inline ino_t key_ino(const struct ubifs_info *c, const void *k)
+{
+	const union ubifs_key *key = k;
+
+	return key->u32[0];
+}
+
+/**
+ * key_ino_flash - fetch inode number from an on-flash formatted key.
+ * @c: UBIFS file-system description object
+ * @k: key to fetch inode number from
+ */
+static inline ino_t key_ino_flash(const struct ubifs_info *c, const void *k)
+{
+	const union ubifs_key *key = k;
+
+	return le32_to_cpu(key->j32[0]);
+}
+
+/**
+ * key_hash - get directory entry hash.
+ * @c: UBIFS file-system description object
+ * @key: the key to get hash from
+ */
+static inline int key_hash(const struct ubifs_info *c,
+			   const union ubifs_key *key)
+{
+	return key->u32[1] & UBIFS_S_KEY_HASH_MASK;
+}
+
+/**
+ * key_hash_flash - get directory entry hash from an on-flash formatted key.
+ * @c: UBIFS file-system description object
+ * @k: the key to get hash from
+ */
+static inline int key_hash_flash(const struct ubifs_info *c, const void *k)
+{
+	const union ubifs_key *key = k;
+
+	return le32_to_cpu(key->j32[1]) & UBIFS_S_KEY_HASH_MASK;
+}
+
+/**
+ * key_block - get data block number.
+ * @c: UBIFS file-system description object
+ * @key: the key to get the block number from
+ */
+static inline unsigned int key_block(const struct ubifs_info *c,
+				     const union ubifs_key *key)
+{
+	return key->u32[1] & UBIFS_S_KEY_BLOCK_MASK;
+}
+
+/**
+ * key_read - transform a key to in-memory format.
+ * @c: UBIFS file-system description object
+ * @from: the key to transform
+ * @to: the key to store the result
+ */
+static inline void key_read(const struct ubifs_info *c, const void *from,
+			    union ubifs_key *to)
+{
+	const union ubifs_key *f = from;
+
+	to->u32[0] = le32_to_cpu(f->j32[0]);
+	to->u32[1] = le32_to_cpu(f->j32[1]);
+}
+
+/**
+ * key_write - transform a key from in-memory format.
+ * @c: UBIFS file-system description object
+ * @from: the key to transform
+ * @to: the key to store the result
+ */
+static inline void key_write(const struct ubifs_info *c,
+			     const union ubifs_key *from, void *to)
+{
+	union ubifs_key *t = to;
+
+	t->j32[0] = cpu_to_le32(from->u32[0]);
+	t->j32[1] = cpu_to_le32(from->u32[1]);
+	memset(to + 8, 0, UBIFS_MAX_KEY_LEN - 8);
+}
+
+/**
+ * key_write_idx - transform a key from in-memory format for the index.
+ * @c: UBIFS file-system description object
+ * @from: the key to transform
+ * @to: the key to store the result
+ */
+static inline void key_write_idx(const struct ubifs_info *c,
+				 const union ubifs_key *from, void *to)
+{
+	union ubifs_key *t = to;
+
+	t->j32[0] = cpu_to_le32(from->u32[0]);
+	t->j32[1] = cpu_to_le32(from->u32[1]);
+}
+
+/**
+ * key_copy - copy a key.
+ * @c: UBIFS file-system description object
+ * @from: the key to copy from
+ * @to: the key to copy to
+ */
+static inline void key_copy(const struct ubifs_info *c,
+			    const union ubifs_key *from, union ubifs_key *to)
+{
+	to->u64[0] = from->u64[0];
+}
+
+/**
+ * keys_cmp - compare keys.
+ * @c: UBIFS file-system description object
+ * @key1: the first key to compare
+ * @key2: the second key to compare
+ *
+ * This function compares 2 keys and returns %-1 if @key1 is less than
+ * @key2, 0 if the keys are equivalent and %1 if @key1 is greater than @key2.
+ */
+static inline int keys_cmp(const struct ubifs_info *c,
+			   const union ubifs_key *key1,
+			   const union ubifs_key *key2)
+{
+	if (key1->u32[0] < key2->u32[0])
+		return -1;
+	if (key1->u32[0] > key2->u32[0])
+		return 1;
+	if (key1->u32[1] < key2->u32[1])
+		return -1;
+	if (key1->u32[1] > key2->u32[1])
+		return 1;
+
+	return 0;
+}
+
+/**
+ * is_hash_key - is a key vulnerable to hash collisions.
+ * @c: UBIFS file-system description object
+ * @key: key
+ *
+ * This function returns %1 if @key is a hashed key or %0 otherwise.
+ */
+static inline int is_hash_key(const struct ubifs_info *c,
+			      const union ubifs_key *key)
+{
+	int type = key_type(c, key);
+
+	return type == UBIFS_DENT_KEY || type == UBIFS_XENT_KEY;
+}
+
+/**
+ * key_max_inode_size - get maximum file size allowed by current key format.
+ * @c: UBIFS file-system description object
+ */
+static inline unsigned long long key_max_inode_size(const struct ubifs_info *c)
+{
+	switch (c->key_fmt) {
+	case UBIFS_SIMPLE_KEY_FMT:
+		return (1ULL << UBIFS_S_KEY_BLOCK_BITS) * UBIFS_BLOCK_SIZE;
+	default:
+		return 0;
+	}
+}
+#endif /* !__UBIFS_KEY_H__ */
-- 
1.5.4.1

