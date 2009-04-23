Return-Path: <linux-kernel-owner+w=401wt.eu-S1753844AbZDWPnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbZDWPnz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 11:43:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173AbZDWPnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 11:43:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33967 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152AbZDWPn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 11:43:29 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/2] ROMFS: romfs_lookup() shouldn't be doing a partial name
	comparison
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: dhowells@redhat.com, monstr@monstr.eu, linux-kernel@vger.kernel.org
Date: Thu, 23 Apr 2009 16:41:13 +0100
Message-ID: <20090423154113.20265.38838.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

romfs_lookup() should be using a routine akin to strcmp() on the backing store,
rather than one akin to strncmp().  If it uses the latter, it's liable to match
/bin/shutdown when looking up /bin/sh.

Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: Michal Simek <monstr@monstr.eu>
---

 fs/romfs/internal.h |    4 ++-
 fs/romfs/storage.c  |   67 +++++++++++++++++++++++++++++++++++++--------------
 fs/romfs/super.c    |    4 ++-
 3 files changed, 53 insertions(+), 22 deletions(-)


diff --git a/fs/romfs/internal.h b/fs/romfs/internal.h
index 06044a9..95217b8 100644
--- a/fs/romfs/internal.h
+++ b/fs/romfs/internal.h
@@ -43,5 +43,5 @@ extern int romfs_dev_read(struct super_block *sb, unsigned long pos,
 			  void *buf, size_t buflen);
 extern ssize_t romfs_dev_strnlen(struct super_block *sb,
 				 unsigned long pos, size_t maxlen);
-extern int romfs_dev_strncmp(struct super_block *sb, unsigned long pos,
-			     const char *str, size_t size);
+extern int romfs_dev_strcmp(struct super_block *sb, unsigned long pos,
+			    const char *str, size_t size);
diff --git a/fs/romfs/storage.c b/fs/romfs/storage.c
index 7e3e1e1..66ce9dd 100644
--- a/fs/romfs/storage.c
+++ b/fs/romfs/storage.c
@@ -67,26 +67,35 @@ static ssize_t romfs_mtd_strnlen(struct super_block *sb,
  * compare a string to one in a romfs image on MTD
  * - return 1 if matched, 0 if differ, -ve if error
  */
-static int romfs_mtd_strncmp(struct super_block *sb, unsigned long pos,
-			     const char *str, size_t size)
+static int romfs_mtd_strcmp(struct super_block *sb, unsigned long pos,
+			    const char *str, size_t size)
 {
-	u_char buf[16];
+	u_char buf[17];
 	size_t len, segment;
 	int ret;
 
-	/* scan the string up to 16 bytes at a time */
+	/* scan the string up to 16 bytes at a time, and attempt to grab the
+	 * trailing NUL whilst we're at it */
+	buf[0] = 0xff;
+
 	while (size > 0) {
-		segment = min_t(size_t, size, 16);
+		segment = min_t(size_t, size + 1, 17);
 		ret = ROMFS_MTD_READ(sb, pos, segment, &len, buf);
 		if (ret < 0)
 			return ret;
+		len--;
 		if (memcmp(buf, str, len) != 0)
 			return 0;
+		buf[0] = buf[len];
 		size -= len;
 		pos += len;
 		str += len;
 	}
 
+	/* check the trailing NUL was */
+	if (buf[0])
+		return 0;
+
 	return 1;
 }
 #endif /* CONFIG_ROMFS_ON_MTD */
@@ -154,28 +163,48 @@ static ssize_t romfs_blk_strnlen(struct super_block *sb,
  * compare a string to one in a romfs image on a block device
  * - return 1 if matched, 0 if differ, -ve if error
  */
-static int romfs_blk_strncmp(struct super_block *sb, unsigned long pos,
-			     const char *str, size_t size)
+static int romfs_blk_strcmp(struct super_block *sb, unsigned long pos,
+			    const char *str, size_t size)
 {
 	struct buffer_head *bh;
 	unsigned long offset;
 	size_t segment;
-	bool x;
+	bool matched, terminated = false;
 
-	/* scan the string up to 16 bytes at a time */
+	/* compare string up to a block at a time */
 	while (size > 0) {
 		offset = pos & (ROMBSIZE - 1);
 		segment = min_t(size_t, size, ROMBSIZE - offset);
 		bh = sb_bread(sb, pos >> ROMBSBITS);
 		if (!bh)
 			return -EIO;
-		x = (memcmp(bh->b_data + offset, str, segment) != 0);
-		brelse(bh);
-		if (x)
-			return 0;
+		matched = (memcmp(bh->b_data + offset, str, segment) == 0);
+
 		size -= segment;
 		pos += segment;
 		str += segment;
+		if (matched && size == 0 && offset + segment < ROMBSIZE) {
+			if (!bh->b_data[offset + segment])
+				terminated = true;
+			else
+				matched = false;
+		}
+		brelse(bh);
+		if (!matched)
+			return 0;
+	}
+
+	if (!terminated) {
+		/* the terminating NUL must be on the first byte of the next
+		 * block */
+		BUG_ON((pos & (ROMBSIZE - 1)) != 0);
+		bh = sb_bread(sb, pos >> ROMBSBITS);
+		if (!bh)
+			return -EIO;
+		matched = !bh->b_data[0];
+		brelse(bh);
+		if (!matched)
+			return 0;
 	}
 
 	return 1;
@@ -234,10 +263,12 @@ ssize_t romfs_dev_strnlen(struct super_block *sb,
 
 /*
  * compare a string to one in romfs
+ * - the string to be compared to, str, may not be NUL-terminated; instead the
+ *   string is of the specified size
  * - return 1 if matched, 0 if differ, -ve if error
  */
-int romfs_dev_strncmp(struct super_block *sb, unsigned long pos,
-		      const char *str, size_t size)
+int romfs_dev_strcmp(struct super_block *sb, unsigned long pos,
+		     const char *str, size_t size)
 {
 	size_t limit;
 
@@ -246,16 +277,16 @@ int romfs_dev_strncmp(struct super_block *sb, unsigned long pos,
 		return -EIO;
 	if (size > ROMFS_MAXFN)
 		return -ENAMETOOLONG;
-	if (size > limit - pos)
+	if (size + 1 > limit - pos)
 		return -EIO;
 
 #ifdef CONFIG_ROMFS_ON_MTD
 	if (sb->s_mtd)
-		return romfs_mtd_strncmp(sb, pos, str, size);
+		return romfs_mtd_strcmp(sb, pos, str, size);
 #endif
 #ifdef CONFIG_ROMFS_ON_BLOCK
 	if (sb->s_bdev)
-		return romfs_blk_strncmp(sb, pos, str, size);
+		return romfs_blk_strcmp(sb, pos, str, size);
 #endif
 	return -EIO;
 }
diff --git a/fs/romfs/super.c b/fs/romfs/super.c
index 10ca7d9..c53b5ef 100644
--- a/fs/romfs/super.c
+++ b/fs/romfs/super.c
@@ -240,8 +240,8 @@ static struct dentry *romfs_lookup(struct inode *dir, struct dentry *dentry,
 			goto error;
 
 		/* try to match the first 16 bytes of name */
-		ret = romfs_dev_strncmp(dir->i_sb, offset + ROMFH_SIZE, name,
-					len);
+		ret = romfs_dev_strcmp(dir->i_sb, offset + ROMFH_SIZE, name,
+				       len);
 		if (ret < 0)
 			goto error;
 		if (ret == 1)

