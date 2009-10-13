Return-Path: <linux-kernel-owner+w=401wt.eu-S1759873AbZJMNWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759873AbZJMNWt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 09:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759865AbZJMNWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 09:22:49 -0400
Received: from ernst.netinsight.se ([194.16.221.21]:35580 "HELO
	ernst.netinsight.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759856AbZJMNWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 09:22:48 -0400
Date: Tue, 13 Oct 2009 15:21:58 +0200
From: Simon Kagstrom <simon.kagstrom@netinsight.net>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-mtd <linux-mtd@lists.infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Artem Bityutskiy <dedekind1@gmail.com>,
       David Woodhouse <dwmw2@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Koskinen Aaro (Nokia-D/Helsinki)" <aaro.koskinen@nokia.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH/RFC v5 1/5]: mtdoops: avoid erasing already empty areas
Message-ID: <20091013152158.558df8e9@marrow.netinsight.se>
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

After having scanned the entire mtdoops area, mtdoops will erase it if
there are no mtdoops headers in it. However, empty and already erased
areas (i.e., without mtdoops headers) will therefore also be erased at
each startup.

This patch counts the number of unclean pages (neither empty nor with
the mtdoops header) and only erases if no headers are found and the area
is still unclean.

Signed-off-by: Simon Kagstrom <simon.kagstrom@netinsight.net>
---
 drivers/mtd/mtdoops.c |   18 ++++++++++++++----
 1 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/mtdoops.c b/drivers/mtd/mtdoops.c
index 18c6c96..c785e1a 100644
--- a/drivers/mtd/mtdoops.c
+++ b/drivers/mtd/mtdoops.c
@@ -225,7 +225,7 @@ static void mtdoops_workfunc_write(struct work_struct *work)
 static void find_next_position(struct mtdoops_context *cxt)
 {
 	struct mtd_info *mtd = cxt->mtd;
-	int ret, page, maxpos = 0;
+	int ret, page, maxpos = 0, unclean_pages = 0;
 	u32 count[2], maxcount = 0xffffffff;
 	size_t retlen;
 
@@ -237,10 +237,13 @@ static void find_next_position(struct mtdoops_context *cxt)
 			continue;
 		}
 
-		if (count[1] != MTDOOPS_KERNMSG_MAGIC)
-			continue;
 		if (count[0] == 0xffffffff)
 			continue;
+		if (count[1] != MTDOOPS_KERNMSG_MAGIC) {
+			/* Page is neither clean nor empty */
+			unclean_pages++;
+			continue;
+		}
 		if (maxcount == 0xffffffff) {
 			maxcount = count[0];
 			maxpos = page;
@@ -259,7 +262,14 @@ static void find_next_position(struct mtdoops_context *cxt)
 	if (maxcount == 0xffffffff) {
 		cxt->nextpage = 0;
 		cxt->nextcount = 1;
-		schedule_work(&cxt->work_erase);
+		if (unclean_pages != 0) {
+			printk(KERN_INFO "mtdoops: cleaning area\n");
+			schedule_work(&cxt->work_erase);
+		} else {
+			printk(KERN_DEBUG "mtdoops: ready %d, %d (clean)\n",
+			       cxt->nextpage, cxt->nextcount);
+			cxt->ready = 1;
+		}
 		return;
 	}
 
-- 
1.6.0.4

