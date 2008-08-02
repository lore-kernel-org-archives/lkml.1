Return-Path: <linux-kernel-owner+w=401wt.eu-S1754546AbYHBL2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546AbYHBL2l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 07:28:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbYHBL2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 07:28:33 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:34300 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520AbYHBL2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 07:28:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=SJawJJTWOqrxvLMi82chttGAuVY4F7A0z853lcWwOHQeaw8oOQPQX2NSSoLnzYWv3J
         j6pt3WUQKQNFPirPs6rxnx4Iwqi9hiEsdNMekD6CJOzErUNiM3sYIwRrgd6X+nNDseeK
         52bSU3Aa9AoTxtkdER/UHRIPdk0B9xmE+DdWI=
Date: Sat, 2 Aug 2008 15:28:28 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org
Cc: pj@sgi.com, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] Add seq_cpumask(), seq_nodemask()
Message-ID: <20080802112828.GA3536@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Short enough reads from /proc/irq/*/smp_affinity return -EINVAL
for no good reason.

This became noticed with NR_CPUS=4096 patches, when length of printed
representation of cpumask becase 1152, but cat(1) continued to read with
1024-byte chunks. bitmap_scnprintf() in good faith fills buffer, returns
1023, check returns -EINVAL.

Fix it by switching to seq_file, so handler will just fill buffer and
doesn't care about offsets, length, filling EOF and all this crap.

For that add seq_bitmap(), and wrappers around it -- seq_cpumask() and
seq_nodemask().

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/seq_file.c            |   14 ++++++++++++++
 include/linux/bitmap.h   |    1 +
 include/linux/seq_file.h |   12 ++++++++++++
 lib/bitmap.c             |   11 +++++++++++
 4 files changed, 38 insertions(+)

--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -443,6 +443,20 @@ int seq_dentry(struct seq_file *m, struct dentry *dentry, char *esc)
 	return -1;
 }
 
+int seq_bitmap(struct seq_file *m, unsigned long *bits, unsigned int nr_bits)
+{
+	size_t len = bitmap_scnprintf_len(nr_bits);
+
+	if (m->count + len < m->size) {
+		bitmap_scnprintf(m->buf + m->count, m->size - m->count,
+				 bits, nr_bits);
+		m->count += len;
+		return 0;
+	}
+	m->count = m->size;
+	return -1;
+}
+
 static void *single_start(struct seq_file *p, loff_t *pos)
 {
 	return NULL + (*pos == 0);
--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -110,6 +110,7 @@ extern int __bitmap_weight(const unsigned long *bitmap, int bits);
 
 extern int bitmap_scnprintf(char *buf, unsigned int len,
 			const unsigned long *src, int nbits);
+extern int bitmap_scnprintf_len(unsigned int nr_bits);
 extern int __bitmap_parse(const char *buf, unsigned int buflen, int is_user,
 			unsigned long *dst, int nbits);
 extern int bitmap_parse_user(const char __user *ubuf, unsigned int ulen,
--- a/include/linux/seq_file.h
+++ b/include/linux/seq_file.h
@@ -4,6 +4,8 @@
 #include <linux/types.h>
 #include <linux/string.h>
 #include <linux/mutex.h>
+#include <linux/cpumask.h>
+#include <linux/nodemask.h>
 
 struct seq_operations;
 struct file;
@@ -47,6 +49,16 @@ int seq_path(struct seq_file *, struct path *, char *);
 int seq_dentry(struct seq_file *, struct dentry *, char *);
 int seq_path_root(struct seq_file *m, struct path *path, struct path *root,
 		  char *esc);
+int seq_bitmap(struct seq_file *m, unsigned long *bits, unsigned int nr_bits);
+static inline int seq_cpumask(struct seq_file *m, cpumask_t *mask)
+{
+	return seq_bitmap(m, mask->bits, NR_CPUS);
+}
+
+static inline int seq_nodemask(struct seq_file *m, nodemask_t *mask)
+{
+	return seq_bitmap(m, mask->bits, MAX_NUMNODES);
+}
 
 int single_open(struct file *, int (*)(struct seq_file *, void *), void *);
 int single_release(struct inode *, struct file *);
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -316,6 +316,17 @@ int bitmap_scnprintf(char *buf, unsigned int buflen,
 EXPORT_SYMBOL(bitmap_scnprintf);
 
 /**
+ * bitmap_scnprintf_len - return buffer length needed to convert
+ * bitmap to an ASCII hex string
+ * @nr_bits: number of bits to be converted
+ */
+int bitmap_scnprintf_len(unsigned int nr_bits)
+{
+	unsigned int nr_nibbles = ALIGN(nr_bits, 4) / 4;
+	return nr_nibbles + ALIGN(nr_nibbles, CHUNKSZ / 4) / (CHUNKSZ / 4) - 1;
+}
+
+/**
  * __bitmap_parse - convert an ASCII hex string into a bitmap.
  * @buf: pointer to buffer containing string.
  * @buflen: buffer size in bytes.  If string is smaller than this
-- 
1.5.3.7


