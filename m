Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250Ab0CJVP2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 16:15:28 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:46792 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757239Ab0CJVPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 16:15:21 -0500
Date: Wed, 10 Mar 2010 22:15:19 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Joern Engel <joern@lazybastard.org>, David Woodhouse <dwmw2@infradead.org>,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 2/6] drivers/mtd: Use kasprintf
Message-ID: <Pine.LNX.4.64.1003102215020.1672@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

kasprintf combines kmalloc and sprintf, and takes care of the size
calculation itself.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression a,flag;
expression list args;
statement S;
@@

  a =
-  \(kmalloc\|kzalloc\)(...,flag)
+  kasprintf(flag,args)
  <... when != a
  if (a == NULL || ...) S
  ...>
- sprintf(a,args);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/mtd/devices/block2mtd.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -u -p a/drivers/mtd/devices/block2mtd.c b/drivers/mtd/devices/block2mtd.c
--- a/drivers/mtd/devices/block2mtd.c
+++ b/drivers/mtd/devices/block2mtd.c
@@ -275,12 +275,10 @@ static struct block2mtd_dev *add_device(
 
 	/* Setup the MTD structure */
 	/* make the name contain the block device in */
-	name = kmalloc(sizeof("block2mtd: ") + strlen(devname) + 1,
-			GFP_KERNEL);
+	name = kasprintf(GFP_KERNEL, "block2mtd: %s", devname);
 	if (!name)
 		goto devinit_err;
 
-	sprintf(name, "block2mtd: %s", devname);
 	dev->mtd.name = name;
 
 	dev->mtd.size = dev->blkdev->bd_inode->i_size & PAGE_MASK;
