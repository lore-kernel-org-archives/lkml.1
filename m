Return-Path: <linux-kernel-owner+w=401wt.eu-S1751747AbYBKBMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747AbYBKBMh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 20:12:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755989AbYBKBM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 20:12:26 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41518
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755969AbYBKBMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 20:12:25 -0500
Date: Sun, 10 Feb 2008 17:12:57 -0800 (PST)
Message-Id: <20080210.171257.233096646.davem@davemloft.net>
To: chris.mason@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       btrfs-devel@oss.oracle.com
Subject: Re: [ANNOUNCE] Btrfs v0.12 released
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

I couldn't even make a filesystem on sparc64 without the following
patch.

The first problem is that these SETGET macros lose typing information,
and therefore can't see the 'packed' attribute and therefore take
unaligned access SIGBUS signals on sparc64 when trying to derefernce
the member.

The next problem is a similar issue in btrfs_name_hash().  This gets
passed things like &key.offset which is a member of a packed
structure, losing this packed'ness information btrfs_name_hash()
performs a potentially unaligned memory access, again resulting in a
SIGBUS.

This function never returns an error, so the simplest fix was to
return the hash value which avoids all of the issues.  In attempting
other schemes to fix this, I found it very difficult to give gcc
a packed attribute for that "u64 *" argument other than to create
some new pseudo structure which would have been ugly.

Similar code lives in the btrfs kernel code too, I'll try to get a
partition at least mounted and working minimally and if successful
I'll send you patches for that too.

diff -up --recursive --new-file vanilla/btrfs-progs-0.12/ctree.h btrfs-progs-0.12/ctree.h
--- vanilla/btrfs-progs-0.12/ctree.h	2008-02-06 08:37:45.000000000 -0800
+++ btrfs-progs-0.12/ctree.h	2008-02-10 16:53:24.000000000 -0800
@@ -451,18 +451,16 @@ static inline void btrfs_set_##name(stru
 static inline u##bits btrfs_##name(struct extent_buffer *eb,		\
 				   type *s)				\
 {									\
-	unsigned long offset = (unsigned long)s +			\
-				offsetof(type, member);			\
-	__le##bits *tmp = (__le##bits *)(eb->data + offset);		\
-	return le##bits##_to_cpu(*tmp);					\
+	unsigned long offset = (unsigned long)s;			\
+	type *p = (type *) (eb->data + offset);				\
+	return le##bits##_to_cpu(p->member);				\
 }									\
 static inline void btrfs_set_##name(struct extent_buffer *eb,		\
 				    type *s, u##bits val)		\
 {									\
-	unsigned long offset = (unsigned long)s +			\
-				offsetof(type, member);			\
-	__le##bits *tmp = (__le##bits *)(eb->data + offset);		\
-	*tmp = cpu_to_le##bits(val);					\
+	unsigned long offset = (unsigned long)s;			\
+	type *p = (type *) (eb->data + offset);				\
+	p->member = cpu_to_le##bits(val);				\
 }
 
 #define BTRFS_SETGET_STACK_FUNCS(name, type, member, bits)		\
diff -up --recursive --new-file vanilla/btrfs-progs-0.12/dir-item.c btrfs-progs-0.12/dir-item.c
--- vanilla/btrfs-progs-0.12/dir-item.c	2008-02-06 08:37:45.000000000 -0800
+++ btrfs-progs-0.12/dir-item.c	2008-02-10 17:03:34.000000000 -0800
@@ -71,8 +71,7 @@ int btrfs_insert_xattr_item(struct btrfs
 
 	key.objectid = dir;
 	btrfs_set_key_type(&key, BTRFS_XATTR_ITEM_KEY);
-	ret = btrfs_name_hash(name, name_len, &key.offset);
-	BUG_ON(ret);
+	key.offset = btrfs_name_hash(name, name_len);
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
@@ -122,8 +121,7 @@ int btrfs_insert_dir_item(struct btrfs_t
 
 	key.objectid = dir;
 	btrfs_set_key_type(&key, BTRFS_DIR_ITEM_KEY);
-	ret = btrfs_name_hash(name, name_len, &key.offset);
-	BUG_ON(ret);
+	key.offset = btrfs_name_hash(name, name_len);
 	path = btrfs_alloc_path();
 	data_size = sizeof(*dir_item) + name_len;
 	dir_item = insert_with_overflow(trans, root, path, &key, data_size,
@@ -196,8 +194,7 @@ struct btrfs_dir_item *btrfs_lookup_dir_
 	key.objectid = dir;
 	btrfs_set_key_type(&key, BTRFS_DIR_ITEM_KEY);
 
-	ret = btrfs_name_hash(name, name_len, &key.offset);
-	BUG_ON(ret);
+	key.offset = btrfs_name_hash(name, name_len);
 
 	ret = btrfs_search_slot(trans, root, &key, path, ins_len, cow);
 	if (ret < 0)
@@ -258,8 +255,7 @@ struct btrfs_dir_item *btrfs_lookup_xatt
 
 	key.objectid = dir;
 	btrfs_set_key_type(&key, BTRFS_XATTR_ITEM_KEY);
-	ret = btrfs_name_hash(name, name_len, &key.offset);
-	BUG_ON(ret);
+	key.offset = btrfs_name_hash(name, name_len);
 	ret = btrfs_search_slot(trans, root, &key, path, ins_len, cow);
 	if (ret < 0)
 		return ERR_PTR(ret);
diff -up --recursive --new-file vanilla/btrfs-progs-0.12/dir-test.c btrfs-progs-0.12/dir-test.c
--- vanilla/btrfs-progs-0.12/dir-test.c	2008-02-06 08:37:45.000000000 -0800
+++ btrfs-progs-0.12/dir-test.c	2008-02-10 17:03:49.000000000 -0800
@@ -129,8 +129,8 @@ error:
 				    struct btrfs_dir_item);
 		found = (char *)(di + 1);
 		found_len = btrfs_dir_name_len(di);
-		btrfs_name_hash(buf, strlen(buf), &myhash);
-		btrfs_name_hash(found, found_len, &foundhash);
+		myhash = btrfs_name_hash(buf, strlen(buf));
+		foundhash = btrfs_name_hash(found, found_len);
 		if (myhash != foundhash)
 			goto fatal_release;
 		btrfs_release_path(root, &path);
diff -up --recursive --new-file vanilla/btrfs-progs-0.12/hash.c btrfs-progs-0.12/hash.c
--- vanilla/btrfs-progs-0.12/hash.c	2008-02-06 08:37:45.000000000 -0800
+++ btrfs-progs-0.12/hash.c	2008-02-10 17:02:36.000000000 -0800
@@ -75,12 +75,13 @@ static void str2hashbuf(const char *msg,
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
 
 	/* Initialize the default seed for the hash checksum functions */
 	buf[0] = 0x67452301;
@@ -97,8 +98,8 @@ int btrfs_name_hash(const char *name, in
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
diff -up --recursive --new-file vanilla/btrfs-progs-0.12/hash.h btrfs-progs-0.12/hash.h
--- vanilla/btrfs-progs-0.12/hash.h	2008-02-06 08:37:45.000000000 -0800
+++ btrfs-progs-0.12/hash.h	2008-02-10 17:02:21.000000000 -0800
@@ -18,5 +18,5 @@
 
 #ifndef __HASH__
 #define __HASH__
-int btrfs_name_hash(const char *name, int len, u64 *hash_result);
+u64 btrfs_name_hash(const char *name, int len);
 #endif
diff -up --recursive --new-file vanilla/btrfs-progs-0.12/hasher.c btrfs-progs-0.12/hasher.c
--- vanilla/btrfs-progs-0.12/hasher.c	2008-02-06 08:37:45.000000000 -0800
+++ btrfs-progs-0.12/hasher.c	2008-02-10 17:04:04.000000000 -0800
@@ -35,8 +35,7 @@ int main() {
 			continue;
 		if (line[strlen(line)-1] == '\n')
 			line[strlen(line)-1] = '\0';
-		ret = btrfs_name_hash(line, strlen(line), &result);
-		BUG_ON(ret);
+		result = btrfs_name_hash(line, strlen(line));
 		printf("hash returns %llu\n", (unsigned long long)result);
 	}
 	return 0;
