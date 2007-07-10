Return-Path: <linux-kernel-owner+w=401wt.eu-S1760521AbXGJTeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760521AbXGJTeV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 15:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755451AbXGJTeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 15:34:14 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:41398 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754942AbXGJTeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 15:34:14 -0400
Subject: [PATCH] mtd: Add sync/unblank function to mtdoops
From: Richard Purdie <rpurdie@openedhand.com>
To: David Woodhouse <dwmw2@infradead.org>,
       linux-mtd <linux-mtd@lists.infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Jarkko Lavinen <jarkko.lavinen@nokia.com>
Content-Type: text/plain
Date: Tue, 10 Jul 2007 20:33:54 +0100
Message-Id: <1184096034.6435.82.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

mtdoops wasn't ensuring data was flushed to flash in crash situations
after recent changes in mainline kernels as tracking the
oops_in_progress variable was no longer enough. We can use the "unblank"
console call as a sync call to tell us to write out the buffer though.

Therefore add a sync function to mtdoops and call this when console
unblank events occur.

Signed-off-by: Richard Purdie <rpurdie@openedhand.com>

Index: linux/drivers/mtd/mtdoops.c
===================================================================
--- linux.orig/drivers/mtd/mtdoops.c	2007-07-10 20:01:34.000000000 +0100
+++ linux/drivers/mtd/mtdoops.c	2007-07-10 20:23:09.000000000 +0100
@@ -271,40 +271,50 @@ static void mtdoops_notify_remove(struct
 	flush_scheduled_work();
 }
 
-
-static void
-mtdoops_console_write(struct console *co, const char *s, unsigned int count)
+static void mtdoops_console_sync(void)
 {
-	struct mtdoops_context *cxt = co->data;
+	struct mtdoops_context *cxt = &oops_cxt;
 	struct mtd_info *mtd = cxt->mtd;
-	int i, ret;
+	size_t retlen;
+	int ret;
 
 	if (!cxt->ready || !mtd)
 		return;
 
-	if (!oops_in_progress && cxt->writecount != 0) {
-		size_t retlen;
-		if (cxt->writecount < OOPS_PAGE_SIZE)
-			memset(cxt->oops_buf + cxt->writecount, 0xff,
+	if (cxt->writecount == 0)
+		return;
+
+	if (cxt->writecount < OOPS_PAGE_SIZE)
+		memset(cxt->oops_buf + cxt->writecount, 0xff,
 					OOPS_PAGE_SIZE - cxt->writecount);
 
-		ret = mtd->write(mtd, cxt->nextpage * OOPS_PAGE_SIZE,
+	ret = mtd->write(mtd, cxt->nextpage * OOPS_PAGE_SIZE,
 					OOPS_PAGE_SIZE, &retlen, cxt->oops_buf);
-		cxt->ready = 0;
-		cxt->writecount = 0;
+	cxt->ready = 0;
+	cxt->writecount = 0;
 
-		if ((retlen != OOPS_PAGE_SIZE) || (ret < 0))
-			printk(KERN_ERR "mtdoops: Write failure at %d (%d of %d"
-				" written), err %d.\n",
-				cxt->nextpage * OOPS_PAGE_SIZE, retlen,
-				OOPS_PAGE_SIZE, ret);
+	if ((retlen != OOPS_PAGE_SIZE) || (ret < 0))
+		printk(KERN_ERR "mtdoops: Write failure at %d (%d of %d written), err %d.\n",
+			cxt->nextpage * OOPS_PAGE_SIZE, retlen,	OOPS_PAGE_SIZE, ret);
 
-		ret = mtdoops_inc_counter(cxt);
-		if (ret == 1)
-			schedule_work(&cxt->work);
+	ret = mtdoops_inc_counter(cxt);
+	if (ret == 1)
+		schedule_work(&cxt->work);
+}
+
+static void
+mtdoops_console_write(struct console *co, const char *s, unsigned int count)
+{
+	struct mtdoops_context *cxt = co->data;
+	struct mtd_info *mtd = cxt->mtd;
+	int i;
+
+	if (!oops_in_progress) {
+		mtdoops_console_sync();
+		return;
 	}
 
-	if (!oops_in_progress)
+	if (!cxt->ready || !mtd)
 		return;
 
 	if (cxt->writecount == 0) {
@@ -344,6 +354,7 @@ static struct console mtdoops_console = 
 	.name		= "ttyMTD",
 	.write		= mtdoops_console_write,
 	.setup		= mtdoops_console_setup,
+	.unblank	= mtdoops_console_sync,
 	.flags		= CON_PRINTBUFFER,
 	.index		= -1,
 	.data		= &oops_cxt,

