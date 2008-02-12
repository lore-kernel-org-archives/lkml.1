Return-Path: <linux-kernel-owner+w=401wt.eu-S1754699AbYBLVz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699AbYBLVz3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 16:55:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbYBLVzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 16:55:19 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36830
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751498AbYBLVzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 16:55:16 -0500
Date: Tue, 12 Feb 2008 13:55:47 -0800 (PST)
Message-Id: <20080212.135547.82632980.davem@davemloft.net>
To: chris.mason@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       btrfs-devel@oss.oracle.com
Subject: BTRFS only works with PAGE_SIZE <= 4K
From: David Miller <davem@davemloft.net>
In-Reply-To: <200802061200.14690.chris.mason@oracle.com>
References: <200802061200.14690.chris.mason@oracle.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Mason <chris.mason@oracle.com>
Date: Wed, 6 Feb 2008 12:00:13 -0500

> So, here's v0.12.

Any page size larger than 4K will not work with btrfs.  All of the
extent stuff assumes that PAGE_SIZE <= sectorsize.

I confirmed this by forcing mkfs.btrfs to use an 8K sectorsize on
sparc64 and I was finally able to successfully mount a partition.

With 4K there are zero's in the root tree node header, because it's
extent's location on disk is at a sub-PAGE_SIZE multiple and the
extent code doesn't handle that.

You really need to start validating this stuff on other platforms.
Something that isn't little endian and something that doesn't use 4K
pages.  I'm sure you have some powerpc parts around somewhere. :)

Anyways, here is a patch for the kernel bits which fixes most of the
unaligned accesses on sparc64.

diff -u --recursive --new-file vanilla/btrfs-0.12/ctree.h btrfs-0.12/ctree.h
--- vanilla/btrfs-0.12/ctree.h	2008-02-06 08:37:39.000000000 -0800
+++ btrfs-0.12/ctree.h	2008-02-10 17:17:49.000000000 -0800
@@ -495,22 +495,17 @@
 #define BTRFS_SETGET_HEADER_FUNCS(name, type, member, bits)		\
 static inline u##bits btrfs_##name(struct extent_buffer *eb)		\
 {									\
-	char *kaddr = kmap_atomic(eb->first_page, KM_USER0);		\
-	unsigned long offset = offsetof(type, member);			\
-	u##bits res;							\
-	__le##bits *tmp = (__le##bits *)(kaddr + offset);		\
-	res = le##bits##_to_cpu(*tmp);					\
-	kunmap_atomic(kaddr, KM_USER0);					\
+	type *p = kmap_atomic(eb->first_page, KM_USER0);		\
+	u##bits res = le##bits##_to_cpu(p->member);			\
+	kunmap_atomic(p, KM_USER0);					\
 	return res;							\
 }									\
 static inline void btrfs_set_##name(struct extent_buffer *eb,		\
 				    u##bits val)			\
 {									\
-	char *kaddr = kmap_atomic(eb->first_page, KM_USER0);		\
-	unsigned long offset = offsetof(type, member);			\
-	__le##bits *tmp = (__le##bits *)(kaddr + offset);		\
-	*tmp = cpu_to_le##bits(val);					\
-	kunmap_atomic(kaddr, KM_USER0);					\
+	type *p = kmap_atomic(eb->first_page, KM_USER0);		\
+	p->member = cpu_to_le##bits(val);				\
+	kunmap_atomic(p, KM_USER0);					\
 }
 
 #define BTRFS_SETGET_STACK_FUNCS(name, type, member, bits)		\
diff -u --recursive --new-file vanilla/btrfs-0.12/dir-item.c btrfs-0.12/dir-item.c
--- vanilla/btrfs-0.12/dir-item.c	2008-02-06 08:37:39.000000000 -0800
+++ btrfs-0.12/dir-item.c	2008-02-10 17:20:00.000000000 -0800
@@ -71,8 +71,7 @@
 
 	key.objectid = dir;
 	btrfs_set_key_type(&key, BTRFS_XATTR_ITEM_KEY);
-	ret = btrfs_name_hash(name, name_len, &key.offset);
-	BUG_ON(ret);
+	key.offset = btrfs_name_hash(name, name_len);
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
@@ -125,8 +124,7 @@
 
 	key.objectid = dir;
 	btrfs_set_key_type(&key, BTRFS_DIR_ITEM_KEY);
-	ret = btrfs_name_hash(name, name_len, &key.offset);
-	BUG_ON(ret);
+	key.offset = btrfs_name_hash(name, name_len);
 	path = btrfs_alloc_path();
 	data_size = sizeof(*dir_item) + name_len;
 	dir_item = insert_with_overflow(trans, root, path, &key, data_size,
@@ -199,8 +197,7 @@
 	key.objectid = dir;
 	btrfs_set_key_type(&key, BTRFS_DIR_ITEM_KEY);
 
-	ret = btrfs_name_hash(name, name_len, &key.offset);
-	BUG_ON(ret);
+	key.offset = btrfs_name_hash(name, name_len);
 
 	ret = btrfs_search_slot(trans, root, &key, path, ins_len, cow);
 	if (ret < 0)
@@ -261,8 +258,7 @@
 
 	key.objectid = dir;
 	btrfs_set_key_type(&key, BTRFS_XATTR_ITEM_KEY);
-	ret = btrfs_name_hash(name, name_len, &key.offset);
-	BUG_ON(ret);
+	key.offset = btrfs_name_hash(name, name_len);
 	ret = btrfs_search_slot(trans, root, &key, path, ins_len, cow);
 	if (ret < 0)
 		return ERR_PTR(ret);
diff -u --recursive --new-file vanilla/btrfs-0.12/hash.c btrfs-0.12/hash.c
--- vanilla/btrfs-0.12/hash.c	2008-02-06 08:37:39.000000000 -0800
+++ btrfs-0.12/hash.c	2008-02-10 17:19:19.000000000 -0800
@@ -76,19 +76,18 @@
 		*buf++ = pad;
 }
 
-int btrfs_name_hash(const char *name, int len, u64 *hash_result)
+u64 btrfs_name_hash(const char *name, int len)
 {
 	__u32	hash;
 	__u32	minor_hash = 0;
 	const char	*p;
 	__u32		in[8], buf[2];
+	u64		hash_result;
 
 	if (len == 1 && *name == '.') {
-		*hash_result = 1;
-		return 0;
+		return 1;
 	} else if (len == 2 && name[0] == '.' && name[1] == '.') {
-		*hash_result = 2;
-		return 0;
+		return 2;
 	}
 
 	/* Initialize the default seed for the hash checksum functions */
@@ -106,8 +105,8 @@
 	}
 	hash = buf[0];
 	minor_hash = buf[1];
-	*hash_result = buf[0];
-	*hash_result <<= 32;
-	*hash_result |= buf[1];
-	return 0;
+	hash_result = buf[0];
+	hash_result <<= 32;
+	hash_result |= buf[1];
+	return hash_result;
 }
diff -u --recursive --new-file vanilla/btrfs-0.12/hash.h btrfs-0.12/hash.h
--- vanilla/btrfs-0.12/hash.h	2008-02-06 08:37:39.000000000 -0800
+++ btrfs-0.12/hash.h	2008-02-10 17:19:25.000000000 -0800
@@ -18,5 +18,5 @@
 
 #ifndef __HASH__
 #define __HASH__
-int btrfs_name_hash(const char *name, int len, u64 *hash_result);
+u64 btrfs_name_hash(const char *name, int len);
 #endif
diff -u --recursive --new-file vanilla/btrfs-0.12/struct-funcs.c btrfs-0.12/struct-funcs.c
--- vanilla/btrfs-0.12/struct-funcs.c	2008-02-06 08:37:39.000000000 -0800
+++ btrfs-0.12/struct-funcs.c	2008-02-11 22:50:46.000000000 -0800
@@ -21,16 +21,15 @@
 u##bits btrfs_##name(struct extent_buffer *eb,				\
 				   type *s)				\
 {									\
-	unsigned long offset = (unsigned long)s +			\
-				offsetof(type, member);			\
-	__le##bits *tmp;						\
+	unsigned long part_offset = (unsigned long)s;			\
+	unsigned long offset = part_offset + offsetof(type, member);	\
+	type *p;							\
 	/* ugly, but we want the fast path here */			\
 	if (eb->map_token && offset >= eb->map_start &&			\
 	    offset + sizeof(((type *)0)->member) <= eb->map_start +	\
 	    eb->map_len) {						\
-		tmp = (__le##bits *)(eb->kaddr + offset -		\
-				     eb->map_start);			\
-		return le##bits##_to_cpu(*tmp);				\
+		p = (type *)(eb->kaddr + part_offset - eb->map_start);	\
+		return le##bits##_to_cpu(p->member);			\
 	}								\
 	{								\
 		int err;						\
@@ -48,8 +47,8 @@
 			read_eb_member(eb, s, type, member, &res);	\
 			return le##bits##_to_cpu(res);			\
 		}							\
-		tmp = (__le##bits *)(kaddr + offset - map_start);	\
-		res = le##bits##_to_cpu(*tmp);				\
+		p = (type *)(kaddr + part_offset - map_start);		\
+		res = le##bits##_to_cpu(p->member);			\
 		if (unmap_on_exit)					\
 			unmap_extent_buffer(eb, map_token, KM_USER1);	\
 		return res;						\
@@ -58,16 +57,15 @@
 void btrfs_set_##name(struct extent_buffer *eb,				\
 				    type *s, u##bits val)		\
 {									\
-	unsigned long offset = (unsigned long)s +			\
-				offsetof(type, member);			\
-	__le##bits *tmp;						\
+	unsigned long part_offset = (unsigned long)s;			\
+	unsigned long offset = part_offset + offsetof(type, member);	\
+	type *p;							\
 	/* ugly, but we want the fast path here */			\
 	if (eb->map_token && offset >= eb->map_start &&			\
 	    offset + sizeof(((type *)0)->member) <= eb->map_start +	\
 	    eb->map_len) {						\
-		tmp = (__le##bits *)(eb->kaddr + offset -		\
-				     eb->map_start);			\
-		*tmp = cpu_to_le##bits(val);				\
+		p = (type *)(eb->kaddr + part_offset - eb->map_start);	\
+		p->member = cpu_to_le##bits(val);			\
 		return;							\
 	}								\
 	{								\
@@ -86,8 +84,8 @@
 			write_eb_member(eb, s, type, member, &val);	\
 			return;						\
 		}							\
-		tmp = (__le##bits *)(kaddr + offset - map_start);	\
-		*tmp = cpu_to_le##bits(val);				\
+		p = (type *)(kaddr + part_offset - map_start);		\
+		p->member = cpu_to_le##bits(val);			\
 		if (unmap_on_exit)					\
 			unmap_extent_buffer(eb, map_token, KM_USER1);	\
 	}								\
