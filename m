Return-Path: <linux-kernel-owner+w=401wt.eu-S1759896AbZJMNXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759896AbZJMNXm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 09:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759869AbZJMNXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 09:23:42 -0400
Received: from ernst.netinsight.se ([194.16.221.21]:35580 "HELO
	ernst.netinsight.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759868AbZJMNXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 09:23:41 -0400
Date: Tue, 13 Oct 2009 15:22:19 +0200
From: Simon Kagstrom <simon.kagstrom@netinsight.net>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-mtd <linux-mtd@lists.infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Artem Bityutskiy <dedekind1@gmail.com>,
       David Woodhouse <dwmw2@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Koskinen Aaro (Nokia-D/Helsinki)" <aaro.koskinen@nokia.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH/RFC v5 3/5]: mtdoops: Make page (record) size configurable
Message-ID: <20091013152219.515502c8@marrow.netinsight.se>
In-Reply-To: <20091013151751.59e217a7@marrow.netinsight.se>
References: <20091012113758.GB11035@elte.hu>
	<20091012140149.6789efab@marrow.netinsight.se>
	<20091012120951.GA16799@elte.hu>
	<1255349748.10605.13.camel@macbook.infradead.org>
	<20091012122023.GA19365@elte.hu>
	<20091012150650.51a4b4dc@marrow.netinsight.se>
	<20091012131528.GC25464@elte.hu>
	<20091012153937.0dcd73e5@marrow.netinsight.se>
	<alpine.LFD.2.01.0910120828390.3438@localhost.localdomain>
	<20091012110954.67d7d8d8.akpm@linux-foundation.org>
	<20091012182346.GH17138@elte.hu>
	<alpine.LFD.2.01.0910121130190.3438@localhost.localdomain>
	<20091013151751.59e217a7@marrow.netinsight.se>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The main justification for this is to allow catching long messages
during a panic, where the top part might otherwise be lost since moving
to the next block can require a flash erase.

Signed-off-by: Simon Kagstrom <simon.kagstrom@netinsight.net>
---
 drivers/mtd/mtdoops.c |   77 ++++++++++++++++++++++++++++--------------------
 1 files changed, 45 insertions(+), 32 deletions(-)

diff --git a/drivers/mtd/mtdoops.c b/drivers/mtd/mtdoops.c
index 6af340e..c2a3b5c 100644
--- a/drivers/mtd/mtdoops.c
+++ b/drivers/mtd/mtdoops.c
@@ -32,9 +32,14 @@
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>
 #include <linux/mtd/mtd.h>
+#include <linux/log2.h>
 
 #define MTDOOPS_KERNMSG_MAGIC 0x5d005d00
-#define OOPS_PAGE_SIZE 4096
+
+static unsigned long record_size = 4096;
+module_param(record_size, ulong, 0);
+MODULE_PARM_DESC(record_size,
+		"record size for MTD OOPS pages in bytes (default 4096)");
 
 static struct mtdoops_context {
 	int mtd_index;
@@ -89,8 +94,8 @@ static int mtdoops_erase_block(struct mtdoops_context *cxt, int offset)
 {
 	struct mtd_info *mtd = cxt->mtd;
 	u32 start_page_offset = mtd_div_by_eb(offset, mtd) * mtd->erasesize;
-	u32 start_page = start_page_offset / OOPS_PAGE_SIZE;
-	u32 erase_pages = mtd->erasesize / OOPS_PAGE_SIZE;
+	u32 start_page = start_page_offset / record_size;
+	u32 erase_pages = mtd->erasesize / record_size;
 	struct erase_info erase;
 	DECLARE_WAITQUEUE(wait, current);
 	wait_queue_head_t wait_q;
@@ -158,15 +163,15 @@ static void mtdoops_workfunc_erase(struct work_struct *work)
 	if (!mtd)
 		return;
 
-	mod = (cxt->nextpage * OOPS_PAGE_SIZE) % mtd->erasesize;
+	mod = (cxt->nextpage * record_size) % mtd->erasesize;
 	if (mod != 0) {
-		cxt->nextpage = cxt->nextpage + ((mtd->erasesize - mod) / OOPS_PAGE_SIZE);
+		cxt->nextpage = cxt->nextpage + ((mtd->erasesize - mod) / record_size);
 		if (cxt->nextpage >= cxt->oops_pages)
 			cxt->nextpage = 0;
 	}
 
 	while (mtd->block_isbad) {
-		ret = mtd->block_isbad(mtd, cxt->nextpage * OOPS_PAGE_SIZE);
+		ret = mtd->block_isbad(mtd, cxt->nextpage * record_size);
 		if (!ret)
 			break;
 		if (ret < 0) {
@@ -174,20 +179,20 @@ static void mtdoops_workfunc_erase(struct work_struct *work)
 			return;
 		}
 badblock:
-		printk(KERN_WARNING "mtdoops: bad block at %08x\n",
-		       cxt->nextpage * OOPS_PAGE_SIZE);
+		printk(KERN_WARNING "mtdoops: bad block at %08lx\n",
+		       cxt->nextpage * record_size);
 		i++;
-		cxt->nextpage = cxt->nextpage + (mtd->erasesize / OOPS_PAGE_SIZE);
+		cxt->nextpage = cxt->nextpage + (mtd->erasesize / record_size);
 		if (cxt->nextpage >= cxt->oops_pages)
 			cxt->nextpage = 0;
-		if (i == cxt->oops_pages / (mtd->erasesize / OOPS_PAGE_SIZE)) {
+		if (i == cxt->oops_pages / (mtd->erasesize / record_size)) {
 			printk(KERN_ERR "mtdoops: all blocks bad!\n");
 			return;
 		}
 	}
 
 	for (j = 0, ret = -1; (j < 3) && (ret < 0); j++)
-		ret = mtdoops_erase_block(cxt, cxt->nextpage * OOPS_PAGE_SIZE);
+		ret = mtdoops_erase_block(cxt, cxt->nextpage * record_size);
 
 	if (ret >= 0) {
 		printk(KERN_DEBUG "mtdoops: ready %d, %d\n",
@@ -197,7 +202,7 @@ badblock:
 	}
 
 	if (mtd->block_markbad && ret == -EIO) {
-		ret = mtd->block_markbad(mtd, cxt->nextpage * OOPS_PAGE_SIZE);
+		ret = mtd->block_markbad(mtd, cxt->nextpage * record_size);
 		if (ret < 0) {
 			printk(KERN_ERR "mtdoops: block_markbad failed, aborting\n");
 			return;
@@ -212,22 +217,22 @@ static void mtdoops_write(struct mtdoops_context *cxt, int panic)
 	size_t retlen;
 	int ret;
 
-	if (cxt->writecount < OOPS_PAGE_SIZE)
+	if (cxt->writecount < record_size)
 		memset(cxt->oops_buf + cxt->writecount, 0xff,
-					OOPS_PAGE_SIZE - cxt->writecount);
+					record_size - cxt->writecount);
 
 	if (panic)
-		ret = mtd->panic_write(mtd, cxt->nextpage * OOPS_PAGE_SIZE,
-					OOPS_PAGE_SIZE, &retlen, cxt->oops_buf);
+		ret = mtd->panic_write(mtd, cxt->nextpage * record_size,
+					record_size, &retlen, cxt->oops_buf);
 	else
-		ret = mtd->write(mtd, cxt->nextpage * OOPS_PAGE_SIZE,
-					OOPS_PAGE_SIZE, &retlen, cxt->oops_buf);
+		ret = mtd->write(mtd, cxt->nextpage * record_size,
+					record_size, &retlen, cxt->oops_buf);
 
 	cxt->writecount = 0;
 
-	if (retlen != OOPS_PAGE_SIZE || ret < 0)
-		printk(KERN_ERR "mtdoops: write failure at %d (%td of %d written), error %d\n",
-		       cxt->nextpage * OOPS_PAGE_SIZE, retlen, OOPS_PAGE_SIZE, ret);
+	if (retlen != record_size || ret < 0)
+		printk(KERN_ERR "mtdoops: write failure at %ld (%td of %ld written), error %d\n",
+		       cxt->nextpage * record_size, retlen, record_size, ret);
 	mark_page_used(cxt, cxt->nextpage);
 
 	mtdoops_inc_counter(cxt);
@@ -252,10 +257,10 @@ static void find_next_position(struct mtdoops_context *cxt)
 	for (page = 0; page < cxt->oops_pages; page++) {
 		/* Assume the page is used */
 		mark_page_used(cxt, page);
-		ret = mtd->read(mtd, page * OOPS_PAGE_SIZE, 8, &retlen, (u_char *) &count[0]);
+		ret = mtd->read(mtd, page * record_size, 8, &retlen, (u_char *) &count[0]);
 		if (retlen != 8 || (ret < 0 && ret != -EUCLEAN)) {
-			printk(KERN_ERR "mtdoops: read failure at %d (%td of 8 read), err %d\n",
-			       page * OOPS_PAGE_SIZE, retlen, ret);
+			printk(KERN_ERR "mtdoops: read failure at %ld (%td of 8 read), err %d\n",
+			       page * record_size, retlen, ret);
 			continue;
 		}
 
@@ -309,7 +314,7 @@ static void mtdoops_notify_add(struct mtd_info *mtd)
 	struct mtdoops_context *cxt = &oops_cxt;
 	u64 mtdoops_pages = mtd->size;
 
-	do_div(mtdoops_pages, OOPS_PAGE_SIZE);
+	do_div(mtdoops_pages, record_size);
 
 	if (cxt->name && !strcmp(mtd->name, cxt->name))
 		cxt->mtd_index = mtd->index;
@@ -323,7 +328,7 @@ static void mtdoops_notify_add(struct mtd_info *mtd)
 		return;
 	}
 
-	if (mtd->erasesize < OOPS_PAGE_SIZE) {
+	if (mtd->erasesize < record_size) {
 		printk(KERN_ERR "mtdoops: eraseblock size of MTD partition %d too small\n",
 		       mtd->index);
 		return;
@@ -338,9 +343,9 @@ static void mtdoops_notify_add(struct mtd_info *mtd)
 	}
 	cxt->mtd = mtd;
 	if (mtd->size > INT_MAX)
-		cxt->oops_pages = INT_MAX / OOPS_PAGE_SIZE;
+		cxt->oops_pages = INT_MAX / record_size;
 	else
-		cxt->oops_pages = (int)mtd->size / OOPS_PAGE_SIZE;
+		cxt->oops_pages = (int)mtd->size / record_size;
 
 	find_next_position(cxt);
 
@@ -417,15 +422,15 @@ mtdoops_console_write(struct console *co, const char *s, unsigned int count)
 		cxt->writecount = 8;
 	}
 
-	if (count + cxt->writecount > OOPS_PAGE_SIZE)
-		count = OOPS_PAGE_SIZE - cxt->writecount;
+	if (count + cxt->writecount > record_size)
+		count = record_size - cxt->writecount;
 
 	memcpy(cxt->oops_buf + cxt->writecount, s, count);
 	cxt->writecount += count;
 
 	spin_unlock_irqrestore(&cxt->writecount_lock, flags);
 
-	if (cxt->writecount == OOPS_PAGE_SIZE)
+	if (cxt->writecount == record_size)
 		mtdoops_console_sync();
 }
 
@@ -464,8 +469,16 @@ static int __init mtdoops_console_init(void)
 {
 	struct mtdoops_context *cxt = &oops_cxt;
 
+	if (!is_power_of_2(record_size)) {
+		printk(KERN_ERR "mtdoops: record_size must be a power of two\n");
+		return -EINVAL;
+	}
+	if (record_size < 4096) {
+		printk(KERN_ERR "mtdoops: record_size must be over 4096 bytes\n");
+		return -EINVAL;
+	}
 	cxt->mtd_index = -1;
-	cxt->oops_buf = vmalloc(OOPS_PAGE_SIZE);
+	cxt->oops_buf = vmalloc(record_size);
 	if (!cxt->oops_buf) {
 		printk(KERN_ERR "mtdoops: failed to allocate buffer workspace\n");
 		return -ENOMEM;
-- 
1.6.0.4

