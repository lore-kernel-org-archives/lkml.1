Return-Path: <linux-kernel-owner+w=401wt.eu-S964959AbXCSAc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964959AbXCSAc0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 20:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965029AbXCSAc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 20:32:26 -0400
Received: from canuck.infradead.org ([209.217.80.40]:38730 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964959AbXCSAcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 20:32:25 -0400
Reply-To: <kmpark@infradead.org>
From: "Kyungmin Park" <kmpark@infradead.org>
To: <linux-mtd@lists.infradead.org>
Cc: "'David Woodhouse'" <dwmw2@infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH/RFC] [JFFS2] Implement block trace features in JFFS2
Date: Mon, 19 Mar 2007 09:32:14 +0900
Message-ID: <00ee01c769be$0e54a700$c7a3580a@swcenter.sec.samsung.co.kr>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="ks_c_5601-1987"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-index: AcdpvgoaKzgnaTWAQaCgCZxp666ImQ==
X-MIMEOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] [JFFS2] Implement block trace features in JFFS2

As JFFS2 don't use the block layer. We can't use block trace features.
Now we hook the mtd functions to implement block trace in JFFS2

With this feature, we can measure the real I/O time in MTD and JFFS2 behavior

The concept is simple. When we use jffs2 on mtd partition. we don't use the
mtdblock. So we create block trace data at mtdblock.

E.g.,
# blktrace -d /dev/mtdblock4 ... 
# mount -t jffs2 /dev/mtdblock4 /mnt/jffs2
# do somethings

There are some issues.
1. Basically JFFS2 reads some small chucks (<512) so the request size of read
is not fit for sector
2. I don't see block trace APIs for the synchonous I/O such as MTD. So I'm not
sure how to define it's queue behavior. Now I just defined like this.
/*
 * Legends
 *
 * Read/Write:	ISSUE(D) -> COMPLETE(C)
 * OOB :	QUEUE(Q) -> ISSUE(D)
 * Erase :	PLUG(P) -> UNPLUG_IO(U)
 */
If I was wrong, please let me know.
3. This patch is based on http://lists.infradead.org/pipermail/linux-mtd/2007-
March/017714.html

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 fs/Kconfig          |    9 ++++
 fs/jffs2/Makefile   |    1 +
 fs/jffs2/blktrace.c |  127 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/jffs2/blktrace.h |   32 +++++++++++++
 fs/jffs2/erase.c    |    3 +-
 fs/jffs2/os-linux.h |    6 +-
 fs/jffs2/wbuf.c     |   24 +++++-----
 fs/jffs2/writev.c   |    7 ++-
 8 files changed, 190 insertions(+), 19 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index 3c4886b..38c8066 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -1245,6 +1245,15 @@ config JFFS2_SUMMARY
 
 	  If unsure, say 'N'.
 
+config JFFS2_BLKTRACE
+	bool "JFFS2 Block Trace Support (EXPERIMENTAL)"
+	depends on JFFS2_FS && BLK_DEV_IO_TRACE && EXPERIMENTAL
+	default n
+	help
+	  This feature makes it possible to use block trace.
+
+	  If unsure, say 'N'.
+
 config JFFS2_FS_XATTR
 	bool "JFFS2 XATTR support (EXPERIMENTAL)"
 	depends on JFFS2_FS && EXPERIMENTAL
diff --git a/fs/jffs2/Makefile b/fs/jffs2/Makefile
index 7f28ee0..e6d8311 100644
--- a/fs/jffs2/Makefile
+++ b/fs/jffs2/Makefile
@@ -11,6 +11,7 @@ jffs2-y	+= read.o nodemgmt.o readinode.o write.o scan.o
gc.o
 jffs2-y	+= symlink.o build.o erase.o background.o fs.o writev.o
 jffs2-y	+= super.o debug.o
 
+jffs2-$(CONFIG_JFFS2_BLKTRACE)		+= blktrace.o
 jffs2-$(CONFIG_JFFS2_FS_WRITEBUFFER)	+= wbuf.o
 jffs2-$(CONFIG_JFFS2_FS_XATTR)		+= xattr.o xattr_trusted.o xattr_user.o
 jffs2-$(CONFIG_JFFS2_FS_SECURITY)	+= security.o
diff --git a/fs/jffs2/blktrace.c b/fs/jffs2/blktrace.c
new file mode 100644
index 0000000..5396929
--- /dev/null
+++ b/fs/jffs2/blktrace.c
@@ -0,0 +1,127 @@
+/*
+ * JFFS2 -- Journalling Flash File System, Version 2.
+ *
+ * MTD I/O functions for block trace
+ *
+ * Copyright (C) 2007 Samsung Electronics
+ * Kyungmin Park <kyungmin.park@samsung.com>
+ *
+ *  For licensing information, see the file 'LICENCE' in this directory.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/jffs2.h>
+#include <linux/blkdev.h>
+#include <linux/blktrace_api.h>
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/blktrans.h>
+
+#define JFFS2_READ		0
+#define JFFS2_WRITE		1
+
+#define SECTOR_ROUNDUP(x)	((((x) + (512 - 1)) >> 9) << 9) 
+
+/*
+ * Legends
+ *
+ * Read/Write:	ISSUE(D) -> COMPLETE(C)
+ * OOB :	QUEUE(Q) -> ISSUE(D)
+ * Erase :	PLUG(P) -> UNPLUG_IO(U)
+ */
+
+static inline void blk_add_trace_jffs2(struct mtd_info *mtd,
+		loff_t off, size_t len, int rw, u32 what)
+{
+	struct request_queue *q = get_mtd_blktrans_rq(mtd, MTD_BLOCK_MAJOR);
+	struct blk_trace *bt;
+
+	if (unlikely(!q))
+		return;
+
+	bt = q->blk_trace;
+	if (likely(!bt))
+		return;
+
+	/* To comply with blktrace syntax */
+	len = SECTOR_ROUNDUP(len);
+
+	__blk_add_trace(bt, off >> 9, len, rw, what, 0, 0, NULL);
+}
+
+int jffs2_mtd_read(struct mtd_info *mtd, loff_t from, size_t len,
+				size_t *retlen, u_char *buf)
+{
+	int ret;
+
+	blk_add_trace_jffs2(mtd, from, len, JFFS2_READ, BLK_TA_ISSUE);
+	ret = mtd->read(mtd, from, len, retlen, buf);
+	blk_add_trace_jffs2(mtd, from, len, JFFS2_READ, BLK_TA_COMPLETE);
+
+	return ret;
+}
+
+int jffs2_mtd_read_oob(struct mtd_info *mtd, loff_t from, 
+				struct mtd_oob_ops *ops)
+{
+	int ret;
+
+	blk_add_trace_jffs2(mtd, from, ops->ooblen, JFFS2_READ, BLK_TA_QUEUE);
+	ret = mtd->read_oob(mtd, from, ops);
+	blk_add_trace_jffs2(mtd, from, ops->ooblen, JFFS2_READ, BLK_TA_ISSUE);
+
+	return ret;
+}
+
+int jffs2_mtd_write(struct mtd_info *mtd, loff_t to, size_t len,
+			        size_t *retlen, const u_char *buf)
+{
+	int ret; 
+
+	blk_add_trace_jffs2(mtd, to, len, JFFS2_WRITE, BLK_TA_ISSUE);
+	ret = mtd->write(mtd, to, len, retlen, buf);
+	blk_add_trace_jffs2(mtd, to, len, JFFS2_WRITE, BLK_TA_COMPLETE);
+
+	return ret;
+}
+
+int jffs2_mtd_write_oob(struct mtd_info *mtd, loff_t to, 
+				struct mtd_oob_ops *ops)
+{
+	int ret;
+
+	blk_add_trace_jffs2(mtd, to, ops->ooblen, JFFS2_WRITE, BLK_TA_QUEUE);
+	ret = mtd->write_oob(mtd, to, ops);
+	blk_add_trace_jffs2(mtd, to, ops->ooblen, JFFS2_WRITE, BLK_TA_ISSUE);
+
+	return ret;
+}
+
+int jffs2_mtd_writev(struct mtd_info *mtd, const struct kvec *vecs,
+				unsigned long count, loff_t to, size_t *retlen)
+{
+	unsigned long seg;
+	size_t len = 0;
+	int ret;
+	
+	for (seg = 0; seg < count; seg++)
+		len += vecs[seg].iov_len;
+
+	blk_add_trace_jffs2(mtd, to, len, JFFS2_WRITE, BLK_TA_ISSUE);
+	ret = mtd->writev(mtd, vecs, count, to, retlen);
+	blk_add_trace_jffs2(mtd, to, len, JFFS2_WRITE, BLK_TA_COMPLETE);
+
+	return ret;
+}
+
+int jffs2_mtd_erase(struct mtd_info *mtd, struct erase_info *instr)
+{
+	int ret;
+
+	blk_add_trace_jffs2(mtd, 0, 0, JFFS2_WRITE, BLK_TA_PLUG);
+	ret = mtd->erase(mtd, instr);
+	blk_add_trace_jffs2(mtd, 0, 0, JFFS2_WRITE, BLK_TA_UNPLUG_IO);
+
+	return ret;
+}
diff --git a/fs/jffs2/blktrace.h b/fs/jffs2/blktrace.h
new file mode 100644
index 0000000..456a2f5
--- /dev/null
+++ b/fs/jffs2/blktrace.h
@@ -0,0 +1,32 @@
+#ifndef __JFFS2_BLKTRACE_H
+#define __JFFS2_BLKTRACE_H
+
+#ifdef CONFIG_JFFS2_BLKTRACE
+
+extern int jffs2_mtd_read(struct mtd_info *mtd, loff_t from, size_t len,
+                                size_t *retlen, u_char *buf);
+extern int jffs2_mtd_read_oob(struct mtd_info *mtd, loff_t from,
+                                struct mtd_oob_ops *ops);
+extern int jffs2_mtd_write(struct mtd_info *mtd, loff_t to, size_t len,
+                                size_t *retlen, const u_char *buf);
+extern int jffs2_mtd_write_oob(struct mtd_info *mtd, loff_t to,
+                                struct mtd_oob_ops *ops);
+extern int jffs2_mtd_writev(struct mtd_info *mtd, const struct kvec *vecs,
+				unsigned long count, loff_t to, size_t *retlen);
+extern int jffs2_mtd_erase(struct mtd_info *mtd, struct erase_info *instr);
+#else
+#define jffs2_mtd_read(mtd, from, len, retlen, buf)                     \
+	(mtd->read(mtd, from, len, retlen, buf))
+#define jffs2_mtd_read_oob(mtd, from, ops)                              \
+	(mtd->read_oob(mtd, from, ops))
+#define jffs2_mtd_write(mtd, to, len, retlen, buf)                      \
+	(mtd->write(mtd, to, len, retlen, buf))
+#define jffs2_mtd_write_oob(mtd, to, ops)                               \
+	(mtd->write_oob(mtd, to, ops))
+#define jffs2_mtd_writev(mtd, vecs, count, to retlen)			\
+	(mtd->writev(mtd, vecs, count, to, retlen));
+#define jffs2_mtd_erase(mtd, instr)					\
+	(mtd->erase(mtd, instr))
+#endif	/* CONFIG_JFFS2_BLKTRACE */
+
+#endif
diff --git a/fs/jffs2/erase.c b/fs/jffs2/erase.c
index ad01210..ad26131 100644
--- a/fs/jffs2/erase.c
+++ b/fs/jffs2/erase.c
@@ -19,6 +19,7 @@
 #include <linux/sched.h>
 #include <linux/pagemap.h>
 #include "nodelist.h"
+#include "blktrace.h"
 
 struct erase_priv_struct {
 	struct jffs2_eraseblock *jeb;
@@ -73,7 +74,7 @@ static void jffs2_erase_block(struct jffs2_sb_info *c,
 	((struct erase_priv_struct *)instr->priv)->jeb = jeb;
 	((struct erase_priv_struct *)instr->priv)->c = c;
 
-	ret = c->mtd->erase(c->mtd, instr);
+	ret = jffs2_mtd_erase(c->mtd, instr);
 	if (!ret)
 		return;
 
diff --git a/fs/jffs2/os-linux.h b/fs/jffs2/os-linux.h
index e07a0ed..44e3638 100644
--- a/fs/jffs2/os-linux.h
+++ b/fs/jffs2/os-linux.h
@@ -82,7 +82,7 @@ static inline void jffs2_init_inode_info(struct
jffs2_inode_info *f)
 #define jffs2_write_nand_cleanmarker(c,jeb) (-EIO)
 
 #define jffs2_flash_write(c, ofs, len, retlen, buf)
jffs2_flash_direct_write(c, ofs, len, retlen, buf)
-#define jffs2_flash_read(c, ofs, len, retlen, buf) ((c)->mtd->read((c)->mtd,
ofs, len, retlen, buf))
+#define jffs2_flash_read(c, ofs, len, retlen, buf) (jffs2_mtd_read((c)->mtd,
ofs, len, retlen, buf))
 #define jffs2_flush_wbuf_pad(c) ({ do{} while(0); (void)(c), 0; })
 #define jffs2_flush_wbuf_gc(c, i) ({ do{} while(0); (void)(c), (void) i, 0; })
 #define jffs2_write_nand_badblock(c,jeb,bad_offset) (1)
@@ -111,8 +111,8 @@ static inline void jffs2_init_inode_info(struct
jffs2_inode_info *f)
 
 #define jffs2_cleanmarker_oob(c) (c->mtd->type == MTD_NANDFLASH)
 
-#define jffs2_flash_write_oob(c, ofs, len, retlen, buf) ((c)->mtd-
>write_oob((c)->mtd, ofs, len, retlen, buf))
-#define jffs2_flash_read_oob(c, ofs, len, retlen, buf) ((c)->mtd->read_oob((c)-
>mtd, ofs, len, retlen, buf))
+#define jffs2_flash_write_oob(c, ofs, len, retlen, buf)
(jffs2_mtd_write_oob((c)->mtd, ofs, len, retlen, buf))
+#define jffs2_flash_read_oob(c, ofs, len, retlen, buf) (jffs2_mtd_read_oob((c)-
>mtd, ofs, len, retlen, buf))
 #define jffs2_wbuf_dirty(c) (!!(c)->wbuf_len)
 
 /* wbuf.c */
diff --git a/fs/jffs2/wbuf.c b/fs/jffs2/wbuf.c
index 4fac6dd..9532c9c 100644
--- a/fs/jffs2/wbuf.c
+++ b/fs/jffs2/wbuf.c
@@ -22,6 +22,7 @@
 #include <linux/sched.h>
 
 #include "nodelist.h"
+#include "blktrace.h"
 
 /* For testing write failures */
 #undef BREAKME
@@ -298,7 +299,7 @@ static void jffs2_wbuf_recover(struct jffs2_sb_info *c)
 		}
 
 		/* Do the read... */
-		ret = c->mtd->read(c->mtd, start, c->wbuf_ofs - start, &retlen,
buf);
+		ret = jffs2_mtd_read(c->mtd, start, c->wbuf_ofs - start,
&retlen, buf);
 
 		/* ECC recovered ? */
 		if ((ret == -EUCLEAN || ret == -EBADMSG) &&
@@ -371,12 +372,11 @@ static void jffs2_wbuf_recover(struct jffs2_sb_info *c)
 		if (breakme++ == 20) {
 			printk(KERN_NOTICE "Faking write error at 0x%08x\n",
ofs);
 			breakme = 0;
-			c->mtd->write(c->mtd, ofs, towrite, &retlen,
-				      brokenbuf);
+			jffs2_mtd_write(c->mtd, ofs, towrite, &retlen,
brokenbuf);
 			ret = -EIO;
 		} else
 #endif
-			ret = c->mtd->write(c->mtd, ofs, towrite, &retlen,
+			ret = jffs2_mtd_write(c->mtd, ofs, towrite, &retlen,
 					    rewrite_buf);
 
 		if (ret || retlen != towrite) {
@@ -578,13 +578,13 @@ static int __jffs2_flush_wbuf(struct jffs2_sb_info *c,
int pad)
 	if (breakme++ == 20) {
 		printk(KERN_NOTICE "Faking write error at 0x%08x\n", c-
>wbuf_ofs);
 		breakme = 0;
-		c->mtd->write(c->mtd, c->wbuf_ofs, c->wbuf_pagesize, &retlen,
+		jffs2_mtd_write(c->mtd, c->wbuf_ofs, c->wbuf_pagesize, &retlen,
 			      brokenbuf);
 		ret = -EIO;
 	} else
 #endif
 
-		ret = c->mtd->write(c->mtd, c->wbuf_ofs, c->wbuf_pagesize,
&retlen, c->wbuf);
+		ret = jffs2_mtd_write(c->mtd, c->wbuf_ofs, c->wbuf_pagesize,
&retlen, c->wbuf);
 
 	if (ret || retlen != c->wbuf_pagesize) {
 		if (ret)
@@ -819,7 +819,7 @@ int jffs2_flash_writev(struct jffs2_sb_info *c, const
struct kvec *invecs,
 		v += wbuf_retlen;
 
 		if (vlen >= c->wbuf_pagesize) {
-			ret = c->mtd->write(c->mtd, outvec_to, PAGE_DIV(vlen),
+			ret = jffs2_mtd_write(c->mtd, outvec_to, PAGE_DIV(vlen),
 					    &wbuf_retlen, v);
 			if (ret < 0 || wbuf_retlen != PAGE_DIV(vlen))
 				goto outfile;
@@ -906,11 +906,11 @@ int jffs2_flash_read(struct jffs2_sb_info *c, loff_t ofs,
size_t len, size_t *re
 	int	ret;
 
 	if (!jffs2_is_writebuffered(c))
-		return c->mtd->read(c->mtd, ofs, len, retlen, buf);
+		return jffs2_mtd_read(c->mtd, ofs, len, retlen, buf);
 
 	/* Read flash */
 	down_read(&c->wbuf_sem);
-	ret = c->mtd->read(c->mtd, ofs, len, retlen, buf);
+	ret = jffs2_mtd_read(c->mtd, ofs, len, retlen, buf);
 
 	if ( (ret == -EBADMSG || ret == -EUCLEAN) && (*retlen == len) ) {
 		if (ret == -EBADMSG)
@@ -989,7 +989,7 @@ int jffs2_check_oob_empty(struct jffs2_sb_info *c,
 	ops.len = ops.ooboffs = ops.retlen = ops.oobretlen = 0;
 	ops.datbuf = NULL;
 
-	ret = c->mtd->read_oob(c->mtd, jeb->offset, &ops);
+	ret = jffs2_mtd_read_oob(c->mtd, jeb->offset, &ops);
 	if (ret || ops.oobretlen != ops.ooblen) {
 		printk(KERN_ERR "cannot read OOB for EB at %08x, requested %zd"
 				" bytes, read %zd bytes, error %d\n",
@@ -1032,7 +1032,7 @@ int jffs2_check_nand_cleanmarker(struct jffs2_sb_info *c,
 	ops.len = ops.ooboffs = ops.retlen = ops.oobretlen = 0;
 	ops.datbuf = NULL;
 
-	ret = c->mtd->read_oob(c->mtd, jeb->offset, &ops);
+	ret = jffs2_mtd_read_oob(c->mtd, jeb->offset, &ops);
 	if (ret || ops.oobretlen != ops.ooblen) {
 		printk(KERN_ERR "cannot read OOB for EB at %08x, requested %zd"
 				" bytes, read %zd bytes, error %d\n",
@@ -1058,7 +1058,7 @@ int jffs2_write_nand_cleanmarker(struct jffs2_sb_info *c,
 	ops.len = ops.ooboffs = ops.retlen = ops.oobretlen = 0;
 	ops.datbuf = NULL;
 
-	ret = c->mtd->write_oob(c->mtd, jeb->offset, &ops);
+	ret = jffs2_mtd_write_oob(c->mtd, jeb->offset, &ops);
 	if (ret || ops.oobretlen != ops.ooblen) {
 		printk(KERN_ERR "cannot write OOB for EB at %08x, requested %zd"
 				" bytes, read %zd bytes, error %d\n",
diff --git a/fs/jffs2/writev.c b/fs/jffs2/writev.c
index c638ae1..181e830 100644
--- a/fs/jffs2/writev.c
+++ b/fs/jffs2/writev.c
@@ -14,6 +14,7 @@
 #include <linux/kernel.h>
 #include <linux/mtd/mtd.h>
 #include "nodelist.h"
+#include "blktrace.h"
 
 /* This ought to be in core MTD code. All registered MTD devices
    without writev should have this put in place. Bug the MTD
@@ -28,7 +29,7 @@ static inline int mtd_fake_writev(struct mtd_info *mtd, const
struct kvec *vecs,
 	for (i=0; i<count; i++) {
 		if (!vecs[i].iov_len)
 			continue;
-		ret = mtd->write(mtd, to, vecs[i].iov_len, &thislen,
vecs[i].iov_base);
+		ret = jffs2_mtd_write(mtd, to, vecs[i].iov_len, &thislen,
vecs[i].iov_base);
 		totlen += thislen;
 		if (ret || thislen != vecs[i].iov_len)
 			break;
@@ -53,7 +54,7 @@ int jffs2_flash_direct_writev(struct jffs2_sb_info *c, const
struct kvec *vecs,
 	}
 
 	if (c->mtd->writev)
-		return c->mtd->writev(c->mtd, vecs, count, to, retlen);
+		return jffs2_mtd_writev(c->mtd, vecs, count, to, retlen);
 	else {
 		return mtd_fake_writev(c->mtd, vecs, count, to, retlen);
 	}
@@ -63,7 +64,7 @@ int jffs2_flash_direct_write(struct jffs2_sb_info *c, loff_t
ofs, size_t len,
 			size_t *retlen, const u_char *buf)
 {
 	int ret;
-	ret = c->mtd->write(c->mtd, ofs, len, retlen, buf);
+	ret = jffs2_mtd_write(c->mtd, ofs, len, retlen, buf);
 
 	if (jffs2_sum_active()) {
 		struct kvec vecs[1];
-- 
1.4.4.2

