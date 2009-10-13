Return-Path: <linux-kernel-owner+w=401wt.eu-S1759887AbZJMNXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759887AbZJMNXQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 09:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751147AbZJMNXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 09:23:15 -0400
Received: from ernst.netinsight.se ([194.16.221.21]:35580 "HELO
	ernst.netinsight.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759863AbZJMNXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 09:23:15 -0400
Date: Tue, 13 Oct 2009 15:22:14 +0200
From: Simon Kagstrom <simon.kagstrom@netinsight.net>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-mtd <linux-mtd@lists.infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Artem Bityutskiy <dedekind1@gmail.com>,
       David Woodhouse <dwmw2@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Koskinen Aaro (Nokia-D/Helsinki)" <aaro.koskinen@nokia.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH/RFC v5 2/5]: mtdoops: Keep track of used/unused mtdoops
 pages in an array
Message-ID: <20091013152214.4f7145ab@marrow.netinsight.se>
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

This patch makes mtdoops keep track of used/unused pages in an array
instead of scanning the flash after a write. The advantage with this
approach is that it avoids calling mtd->read on a panic, which is not
possible for all mtd drivers.

Signed-off-by: Simon Kagstrom <simon.kagstrom@netinsight.net>
---
 drivers/mtd/mtdoops.c |   72 ++++++++++++++++++++++++++++++++++++------------
 1 files changed, 54 insertions(+), 18 deletions(-)

diff --git a/drivers/mtd/mtdoops.c b/drivers/mtd/mtdoops.c
index c785e1a..6af340e 100644
--- a/drivers/mtd/mtdoops.c
+++ b/drivers/mtd/mtdoops.c
@@ -44,6 +44,7 @@ static struct mtdoops_context {
 	int oops_pages;
 	int nextpage;
 	int nextcount;
+	u32 *oops_page_used;
 	char *name;
 
 	void *oops_buf;
@@ -54,18 +55,47 @@ static struct mtdoops_context {
 	int writecount;
 } oops_cxt;
 
+static void mark_page_used(struct mtdoops_context *cxt, int page)
+{
+	u32 *p = cxt->oops_page_used + page / (8 * sizeof(u32));
+	u32 idx = page % (8 * sizeof(u32));
+
+	*p = *p | (1 << idx);
+}
+
+static void mark_page_unused(struct mtdoops_context *cxt, int page)
+{
+	u32 *p = cxt->oops_page_used + page / (8 * sizeof(u32));
+	u32 idx = page % (8 * sizeof(u32));
+
+	*p = *p & ~(1 << idx);
+}
+
+static int page_is_used(struct mtdoops_context *cxt, int page)
+{
+	u32 *p = cxt->oops_page_used + page / (8 * sizeof(u32));
+	u32 idx = page % (8 * sizeof(u32));
+
+	return *p & (1 << idx);
+}
+
 static void mtdoops_erase_callback(struct erase_info *done)
 {
 	wait_queue_head_t *wait_q = (wait_queue_head_t *)done->priv;
 	wake_up(wait_q);
 }
 
-static int mtdoops_erase_block(struct mtd_info *mtd, int offset)
+static int mtdoops_erase_block(struct mtdoops_context *cxt, int offset)
 {
+	struct mtd_info *mtd = cxt->mtd;
+	u32 start_page_offset = mtd_div_by_eb(offset, mtd) * mtd->erasesize;
+	u32 start_page = start_page_offset / OOPS_PAGE_SIZE;
+	u32 erase_pages = mtd->erasesize / OOPS_PAGE_SIZE;
 	struct erase_info erase;
 	DECLARE_WAITQUEUE(wait, current);
 	wait_queue_head_t wait_q;
 	int ret;
+	int page;
 
 	init_waitqueue_head(&wait_q);
 	erase.mtd = mtd;
@@ -90,16 +120,15 @@ static int mtdoops_erase_block(struct mtd_info *mtd, int offset)
 	schedule();  /* Wait for erase to finish. */
 	remove_wait_queue(&wait_q, &wait);
 
+	/* Mark pages as unused */
+	for (page = start_page; page < start_page + erase_pages; page++)
+		mark_page_unused(cxt, page);
+
 	return 0;
 }
 
 static void mtdoops_inc_counter(struct mtdoops_context *cxt)
 {
-	struct mtd_info *mtd = cxt->mtd;
-	size_t retlen;
-	u32 count;
-	int ret;
-
 	cxt->nextpage++;
 	if (cxt->nextpage >= cxt->oops_pages)
 		cxt->nextpage = 0;
@@ -107,17 +136,7 @@ static void mtdoops_inc_counter(struct mtdoops_context *cxt)
 	if (cxt->nextcount == 0xffffffff)
 		cxt->nextcount = 0;
 
-	ret = mtd->read(mtd, cxt->nextpage * OOPS_PAGE_SIZE, 4,
-			&retlen, (u_char *) &count);
-	if (retlen != 4 || (ret < 0 && ret != -EUCLEAN)) {
-		printk(KERN_ERR "mtdoops: read failure at %d (%td of 4 read), err %d\n",
-		       cxt->nextpage * OOPS_PAGE_SIZE, retlen, ret);
-		schedule_work(&cxt->work_erase);
-		return;
-	}
-
-	/* See if we need to erase the next block */
-	if (count != 0xffffffff) {
+	if (page_is_used(cxt, cxt->nextpage)) {
 		schedule_work(&cxt->work_erase);
 		return;
 	}
@@ -168,7 +187,7 @@ badblock:
 	}
 
 	for (j = 0, ret = -1; (j < 3) && (ret < 0); j++)
-		ret = mtdoops_erase_block(mtd, cxt->nextpage * OOPS_PAGE_SIZE);
+		ret = mtdoops_erase_block(cxt, cxt->nextpage * OOPS_PAGE_SIZE);
 
 	if (ret >= 0) {
 		printk(KERN_DEBUG "mtdoops: ready %d, %d\n",
@@ -209,6 +228,7 @@ static void mtdoops_write(struct mtdoops_context *cxt, int panic)
 	if (retlen != OOPS_PAGE_SIZE || ret < 0)
 		printk(KERN_ERR "mtdoops: write failure at %d (%td of %d written), error %d\n",
 		       cxt->nextpage * OOPS_PAGE_SIZE, retlen, OOPS_PAGE_SIZE, ret);
+	mark_page_used(cxt, cxt->nextpage);
 
 	mtdoops_inc_counter(cxt);
 }
@@ -230,6 +250,8 @@ static void find_next_position(struct mtdoops_context *cxt)
 	size_t retlen;
 
 	for (page = 0; page < cxt->oops_pages; page++) {
+		/* Assume the page is used */
+		mark_page_used(cxt, page);
 		ret = mtd->read(mtd, page * OOPS_PAGE_SIZE, 8, &retlen, (u_char *) &count[0]);
 		if (retlen != 8 || (ret < 0 && ret != -EUCLEAN)) {
 			printk(KERN_ERR "mtdoops: read failure at %d (%td of 8 read), err %d\n",
@@ -237,6 +259,8 @@ static void find_next_position(struct mtdoops_context *cxt)
 			continue;
 		}
 
+		if (count[0] == 0xffffffff && count[1] == 0xffffffff)
+			mark_page_unused(cxt, page);
 		if (count[0] == 0xffffffff)
 			continue;
 		if (count[1] != MTDOOPS_KERNMSG_MAGIC) {
@@ -283,6 +307,9 @@ static void find_next_position(struct mtdoops_context *cxt)
 static void mtdoops_notify_add(struct mtd_info *mtd)
 {
 	struct mtdoops_context *cxt = &oops_cxt;
+	u64 mtdoops_pages = mtd->size;
+
+	do_div(mtdoops_pages, OOPS_PAGE_SIZE);
 
 	if (cxt->name && !strcmp(mtd->name, cxt->name))
 		cxt->mtd_index = mtd->index;
@@ -302,6 +329,13 @@ static void mtdoops_notify_add(struct mtd_info *mtd)
 		return;
 	}
 
+	/* oops_page_used is a bit field */
+	cxt->oops_page_used = vmalloc(DIV_ROUND_UP(mtdoops_pages,
+			8 * sizeof(u32)));
+	if (!cxt->oops_page_used) {
+		printk(KERN_ERR "Could not allocate page array\n");
+		return;
+	}
 	cxt->mtd = mtd;
 	if (mtd->size > INT_MAX)
 		cxt->oops_pages = INT_MAX / OOPS_PAGE_SIZE;
@@ -454,6 +488,8 @@ static void __exit mtdoops_console_exit(void)
 	unregister_console(&mtdoops_console);
 	kfree(cxt->name);
 	vfree(cxt->oops_buf);
+	if (cxt->oops_page_used)
+		vfree(cxt->oops_page_used);
 }
 
 
-- 
1.6.0.4

