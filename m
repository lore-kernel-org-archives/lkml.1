Return-Path: <linux-kernel-owner+w=401wt.eu-S1755398AbZHTVNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398AbZHTVNq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 17:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754895AbZHTVNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 17:13:45 -0400
Received: from wmproxy1-g27.free.fr ([212.27.42.91]:27814 "EHLO
	wmproxy1-g27.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbZHTVNp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 17:13:45 -0400
Date: Thu, 20 Aug 2009 23:13:46 +0200 (CEST)
From: dimitri.gorokhovik@free.fr
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
       David Woodhouse <David.Woodhouse@intel.com>,
       Tim Gardner <tim.gardner@canonical.com>,
       Scott James Remnant <scott@canonical.com>, Julia Lawall <julia@diku.dk>,
       David Brownell <dbrownell@users.sourceforge.net>,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Message-ID: <420676341.3665461250802826403.JavaMail.root@zimbra3-e1.priv.proxad.net>
In-Reply-To: <20090819163426.fa90cf9f.akpm@linux-foundation.org>
Subject: Re: [PATCH] nftl: fix offset alignments
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [79.85.212.132]
X-Mailer: Zimbra 5.0 (ZimbraWebClient - [unknown] (Linux)/5.0.15_GA_2815.UBUNTU8_64)
X-Authenticated-User: dimitri.gorokhovik@free.fr
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Andrew Morton" <akpm@linux-foundation.org> a écrit :
> On Wed, 19 Aug 2009 00:06:28 +0200 (CEST) dimitri.gorokhovik@free.fr
> wrote:
> ...
> > +	typeof(offs) mask = mtd->writesize - 1;
> 
> I see no reason to use typeof here.  Plain old
> 
> 	loff_t mask = mtd->writesize - 1;
> 
> would be more conventional.

I use typeoff in this way to guard masking code against absent-minded
modifications. 

Attached is a corrected version as suggested. 

Maybe Julia can come up with a clever rule for detecting unusual masking 
operations automatically :-) ? 

---
From: Dimitri Gorokhovik <dimitri.gorokhovik@free.fr>
Subject: nftl: fix offset alignments

Arithmetic conversion in the mask computation makes the upper word
of the second argument passed down to mtd->read_oob(), be always 0
(assuming 'offs' being a 64-bit signed long long type, and
'mtd->writesize' being a 32-bit unsigned int type).

This patch applies over the other one adding masking in nftl_write,
"nftl: write support is broken".

Signed-off-by: Dimitri Gorokhovik <dimitri.gorokhovik@free.fr>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Tim Gardner <tim.gardner@canonical.com>
Cc: Scott James Remnant <scott@canonical.com>
---
 drivers/mtd/nftlcore.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/mtd/nftlcore.c b/drivers/mtd/nftlcore.c
index 665d3eb..1002e18 100644
--- a/drivers/mtd/nftlcore.c
+++ b/drivers/mtd/nftlcore.c
@@ -135,16 +135,17 @@ static void nftl_remove_dev(struct mtd_blktrans_dev *dev)
 int nftl_read_oob(struct mtd_info *mtd, loff_t offs, size_t len,
 		  size_t *retlen, uint8_t *buf)
 {
+	loff_t mask = mtd->writesize - 1;
 	struct mtd_oob_ops ops;
 	int res;
 
 	ops.mode = MTD_OOB_PLACE;
-	ops.ooboffs = offs & (mtd->writesize - 1);
+	ops.ooboffs = offs & mask;
 	ops.ooblen = len;
 	ops.oobbuf = buf;
 	ops.datbuf = NULL;
 
-	res = mtd->read_oob(mtd, offs & ~(mtd->writesize - 1), &ops);
+	res = mtd->read_oob(mtd, offs & ~mask, &ops);
 	*retlen = ops.oobretlen;
 	return res;
 }
@@ -155,16 +156,17 @@ int nftl_read_oob(struct mtd_info *mtd, loff_t offs, size_t len,
 int nftl_write_oob(struct mtd_info *mtd, loff_t offs, size_t len,
 		   size_t *retlen, uint8_t *buf)
 {
+	loff_t mask = mtd->writesize - 1;
 	struct mtd_oob_ops ops;
 	int res;
 
 	ops.mode = MTD_OOB_PLACE;
-	ops.ooboffs = offs & (mtd->writesize - 1);
+	ops.ooboffs = offs & mask;
 	ops.ooblen = len;
 	ops.oobbuf = buf;
 	ops.datbuf = NULL;
 
-	res = mtd->write_oob(mtd, offs & ~(mtd->writesize - 1), &ops);
+	res = mtd->write_oob(mtd, offs & ~mask, &ops);
 	*retlen = ops.oobretlen;
 	return res;
 }
@@ -177,17 +179,18 @@ int nftl_write_oob(struct mtd_info *mtd, loff_t offs, size_t len,
 static int nftl_write(struct mtd_info *mtd, loff_t offs, size_t len,
 		      size_t *retlen, uint8_t *buf, uint8_t *oob)
 {
+	loff_t mask = mtd->writesize - 1;
 	struct mtd_oob_ops ops;
 	int res;
 
 	ops.mode = MTD_OOB_PLACE;
-	ops.ooboffs = offs & (mtd->writesize - 1);
+	ops.ooboffs = offs & mask;
 	ops.ooblen = mtd->oobsize;
 	ops.oobbuf = oob;
 	ops.datbuf = buf;
 	ops.len = len;
 
-	res = mtd->write_oob(mtd, offs & ~(mtd->writesize - 1), &ops);
+	res = mtd->write_oob(mtd, offs & ~mask, &ops);
 	*retlen = ops.retlen;
 	return res;
 }
-- 
1.6.3.3

