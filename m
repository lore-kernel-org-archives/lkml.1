Return-Path: <linux-kernel-owner+w=401wt.eu-S1758358AbZFZQ6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758358AbZFZQ6R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 12:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755133AbZFZQ6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 12:58:06 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:60873 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755005AbZFZQ6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 12:58:06 -0400
Message-ID: <53729.192.168.10.89.1246035471.squirrel@dbdmail.itg.ti.com>
Date: Fri, 26 Jun 2009 22:27:51 +0530 (IST)
Subject: Re: [PATCH][MTD]: fix omap2.c compile failure and warning
From: "vimal singh" <vimalsingh@ti.com>
To: "David Woodhouse" <dwmw2@infradead.org>
Cc: "tom.leiming@gmail.com" <tom.leiming@gmail.com>,
       "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "david-b@pacbell.net" <david-b@pacbell.net>
User-Agent: SquirrelMail/1.4.3a
X-Mailer: SquirrelMail/1.4.3a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Somehow I do not see below errors on compilation:
drivers/mtd/nand/omap2.c: In function 'omap_wait':
drivers/mtd/nand/omap2.c:543: error: 'jiffies' undeclared (first use in this
function)
drivers/mtd/nand/omap2.c:543: error: (Each undeclared identifier is reported
only once
drivers/mtd/nand/omap2.c:543: error: for each function it appears in.)
drivers/mtd/nand/omap2.c:557: error: implicit declaration of function
'time_before'

But still including 'linux/jiffies.h'.

Below is the patch.

Signed-off-by: Vimal Singh <vimalsingh@ti.com>
Signed-off-by: Ming Lei <tom.leiming@gmail.com>

diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
index 0cd76f8..3b6e6ad 100644
--- a/drivers/mtd/nand/omap2.c
+++ b/drivers/mtd/nand/omap2.c
@@ -11,6 +11,8 @@
 #include <linux/platform_device.h>
 #include <linux/dma-mapping.h>
 #include <linux/delay.h>
+#include <linux/jiffies.h>
+#include <linux/sched.h>
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/nand.h>
 #include <linux/mtd/partitions.h>
@@ -541,7 +543,7 @@ static int omap_wait(struct mtd_info *mtd, struct nand_chip
*chip)
 	struct omap_nand_info *info = container_of(mtd, struct omap_nand_info,
 							mtd);
 	unsigned long timeo = jiffies;
-	int status, state = this->state;
+	int status = NAND_STATUS_FAIL, state = this->state;

 	if (state == FL_ERASING)
 		timeo += (HZ * 400) / 1000;
@@ -558,6 +560,7 @@ static int omap_wait(struct mtd_info *mtd, struct nand_chip
*chip)
 		status = __raw_readb(this->IO_ADDR_R);
 		if (!(status & 0x40))
 			break;
+		cond_resched();
 	}
 	return status;
 }



