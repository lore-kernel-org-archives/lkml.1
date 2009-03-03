Return-Path: <linux-kernel-owner+w=401wt.eu-S1753286AbZCCGhS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286AbZCCGhS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 01:37:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756877AbZCCGg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 01:36:59 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:35452 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182AbZCCGg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 01:36:57 -0500
Date: Tue, 03 Mar 2009 15:36:18 +0900
From: Kyungmin Park <kmpark@infradead.org>
Subject: [PATCH 2/3] [MTD] [OneNAND] Add write-while-program support
To: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: ext-adrian.hunter@nokia.com
Message-id: <20090303063618.GA30263@july>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
X-OriginalArrivalTime: 03 Mar 2009 06:36:24.0596 (UTC)
 FILETIME=[5F935540:01C99BCA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's similar with read-while-program method.
but it's write side performance improvement.

Here's brief performance results.
Note: Measured from OMAP3 with async OneNAND mode. (not sync mode)

=================================================================
speedtest: dev = 3
speedtest: Size=16777216  EB size=131072  Write size=2048  EB count=128
                Pages per EB=64  Page size=2048
speedtest: scanning for bad blocks
speedtest: scanned 0
speedtest: scanned 128, found 0 bad
speedtest: erasing
speedtest: erased 0
speedtest: erased 128
speedtest: Testing eraseblock write speed
eraseblock write speed is 2592 KiB/s
speedtest: Testing eraseblock read speed
eraseblock read speed is 16786 KiB/s
speedtest: Testing page write speed
page write speed is 2966 KiB/s
speedtest: Testing page read speed
page read speed is 13277 KiB/s
speedtest: Testing 2 page write speed
2 page write speed is 3182 KiB/s
speedtest: Testing 2 page read speed
2 page read speed is 14773 KiB/s
speedtest: Testing erase speed
erase speed is 192752 KiB/s
speedtest: speedtest finished
=================================================================

Also it's passed all nand-tests.

>From Adrian

I have made a couple of tiny changes and tested this.  I get
a 10% - 25% improvement in write speed when writing more than
1 page.

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
---
 drivers/mtd/onenand/onenand_base.c |  145 ++++++++++++++++++++++++------------
 1 files changed, 96 insertions(+), 49 deletions(-)

diff --git a/drivers/mtd/onenand/onenand_base.c b/drivers/mtd/onenand/onenand_base.c
index 4481df7..7af863a 100644
--- a/drivers/mtd/onenand/onenand_base.c
+++ b/drivers/mtd/onenand/onenand_base.c
@@ -1778,7 +1778,8 @@ static int onenand_write_ops_nolock(struct mtd_info *mtd, loff_t to,
 				struct mtd_oob_ops *ops)
 {
 	struct onenand_chip *this = mtd->priv;
-	int written = 0, column, thislen, subpage;
+	int written = 0, column, thislen = 0, subpage = 0;
+	int prev = 0, prevlen = 0, prev_subpage = 0, first = 1;
 	int oobwritten = 0, oobcolumn, thisooblen, oobsize;
 	size_t len = ops->len;
 	size_t ooblen = ops->ooblen;
@@ -1805,6 +1806,10 @@ static int onenand_write_ops_nolock(struct mtd_info *mtd, loff_t to,
                 return -EINVAL;
         }
 
+	/* Check zero length */
+	if (!len)
+		return 0;
+
 	if (ops->mode == MTD_OOB_AUTO)
 		oobsize = this->ecclayout->oobavail;
 	else
@@ -1815,79 +1820,121 @@ static int onenand_write_ops_nolock(struct mtd_info *mtd, loff_t to,
 	column = to & (mtd->writesize - 1);
 
 	/* Loop until all data write */
-	while (written < len) {
-		u_char *wbuf = (u_char *) buf;
+	while (1) {
+		if (written < len) {
+			u_char *wbuf = (u_char *) buf;
 
-		thislen = min_t(int, mtd->writesize - column, len - written);
-		thisooblen = min_t(int, oobsize - oobcolumn, ooblen - oobwritten);
+			thislen = min_t(int, mtd->writesize - column, len - written);
+			thisooblen = min_t(int, oobsize - oobcolumn, ooblen - oobwritten);
 
-		cond_resched();
+			cond_resched();
 
-		this->command(mtd, ONENAND_CMD_BUFFERRAM, to, thislen);
+			this->command(mtd, ONENAND_CMD_BUFFERRAM, to, thislen);
 
-		/* Partial page write */
-		subpage = thislen < mtd->writesize;
-		if (subpage) {
-			memset(this->page_buf, 0xff, mtd->writesize);
-			memcpy(this->page_buf + column, buf, thislen);
-			wbuf = this->page_buf;
-		}
+			/* Partial page write */
+			subpage = thislen < mtd->writesize;
+			if (subpage) {
+				memset(this->page_buf, 0xff, mtd->writesize);
+				memcpy(this->page_buf + column, buf, thislen);
+				wbuf = this->page_buf;
+			}
 
-		this->write_bufferram(mtd, ONENAND_DATARAM, wbuf, 0, mtd->writesize);
+			this->write_bufferram(mtd, ONENAND_DATARAM, wbuf, 0, mtd->writesize);
 
-		if (oob) {
-			oobbuf = this->oob_buf;
+			if (oob) {
+				oobbuf = this->oob_buf;
 
-			/* We send data to spare ram with oobsize
-			 * to prevent byte access */
-			memset(oobbuf, 0xff, mtd->oobsize);
-			if (ops->mode == MTD_OOB_AUTO)
-				onenand_fill_auto_oob(mtd, oobbuf, oob, oobcolumn, thisooblen);
-			else
-				memcpy(oobbuf + oobcolumn, oob, thisooblen);
+				/* We send data to spare ram with oobsize
+				 * to prevent byte access */
+				memset(oobbuf, 0xff, mtd->oobsize);
+				if (ops->mode == MTD_OOB_AUTO)
+					onenand_fill_auto_oob(mtd, oobbuf, oob, oobcolumn, thisooblen);
+				else
+					memcpy(oobbuf + oobcolumn, oob, thisooblen);
 
-			oobwritten += thisooblen;
-			oob += thisooblen;
-			oobcolumn = 0;
+				oobwritten += thisooblen;
+				oob += thisooblen;
+				oobcolumn = 0;
+			} else
+				oobbuf = (u_char *) ffchars;
+
+			this->write_bufferram(mtd, ONENAND_SPARERAM, oobbuf, 0, mtd->oobsize);
 		} else
-			oobbuf = (u_char *) ffchars;
+			ONENAND_SET_NEXT_BUFFERRAM(this);
 
-		this->write_bufferram(mtd, ONENAND_SPARERAM, oobbuf, 0, mtd->oobsize);
+		/*
+		 * 2 PLANE, MLC, and Flex-OneNAND doesn't support
+		 * write-while-programe feature.
+		 */
+		if (!ONENAND_IS_2PLANE(this) && !first) {
+			ONENAND_SET_PREV_BUFFERRAM(this);
 
-		this->command(mtd, ONENAND_CMD_PROG, to, mtd->writesize);
+			ret = this->wait(mtd, FL_WRITING);
 
-		ret = this->wait(mtd, FL_WRITING);
+			/* In partial page write we don't update bufferram */
+			onenand_update_bufferram(mtd, prev, !ret && !prev_subpage);
+			if (ret) {
+				written -= prevlen;
+				printk(KERN_ERR "onenand_write_ops_nolock: write filaed %d\n", ret);
+				break;
+			}
 
-		/* In partial page write we don't update bufferram */
-		onenand_update_bufferram(mtd, to, !ret && !subpage);
-		if (ONENAND_IS_2PLANE(this)) {
-			ONENAND_SET_BUFFERRAM1(this);
-			onenand_update_bufferram(mtd, to + this->writesize, !ret && !subpage);
-		}
+			if (written == len) {
+				/* Only check verify write turn on */
+				ret = onenand_verify(mtd, buf - len, to - len, len);
+				if (ret)
+					printk(KERN_ERR "onenand_write_ops_nolock: verify failed %d\n", ret);
+				break;
+			}
 
-		if (ret) {
-			printk(KERN_ERR "onenand_write_ops_nolock: write filaed %d\n", ret);
-			break;
+			ONENAND_SET_NEXT_BUFFERRAM(this);
 		}
 
-		/* Only check verify write turn on */
-		ret = onenand_verify(mtd, buf, to, thislen);
-		if (ret) {
-			printk(KERN_ERR "onenand_write_ops_nolock: verify failed %d\n", ret);
-			break;
-		}
+		this->command(mtd, ONENAND_CMD_PROG, to, mtd->writesize);
 
-		written += thislen;
+		/*
+		 * 2 PLANE, MLC, and Flex-OneNAND wait here
+		 */
+		if (ONENAND_IS_2PLANE(this)) {
+			ret = this->wait(mtd, FL_WRITING);
 
-		if (written == len)
-			break;
+			/* In partial page write we don't update bufferram */
+			onenand_update_bufferram(mtd, to, !ret && !subpage);
+			if (ret) {
+				printk(KERN_ERR "onenand_write_ops_nolock: write filaed %d\n", ret);
+				break;
+			}
+
+			/* Only check verify write turn on */
+			ret = onenand_verify(mtd, buf, to, thislen);
+			if (ret) {
+				printk(KERN_ERR "onenand_write_ops_nolock: verify failed %d\n", ret);
+				break;
+			}
+
+			written += thislen;
+
+			if (written == len)
+				break;
+
+		} else
+			written += thislen;
 
 		column = 0;
+		prev_subpage = subpage;
+		prev = to;
+		prevlen = thislen;
 		to += thislen;
 		buf += thislen;
+		first = 0;
 	}
 
+	/* In error case, clear all bufferrams */
+	if (written != len)
+		onenand_invalidate_bufferram(mtd, 0, -1);
+
 	ops->retlen = written;
+	ops->oobretlen = oobwritten;
 
 	return ret;
 }
-- 
1.5.3.3

