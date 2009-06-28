Return-Path: <linux-kernel-owner+w=401wt.eu-S1754144AbZF1FlK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144AbZF1FlK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 01:41:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751448AbZF1Fk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 01:40:58 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:35867 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751430AbZF1Fk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 01:40:58 -0400
Message-ID: <59240.192.168.10.88.1246167644.squirrel@dbdmail.itg.ti.com>
Date: Sun, 28 Jun 2009 11:10:44 +0530 (IST)
Subject: Re: [PATCH][MTD][NAND]: fix omap2.c compile failure and warning
From: "vimal singh" <vimalsingh@ti.com>
To: "David Woodhouse" <dwmw2@infradead.org>
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

> Er, did he? And please put proper email addresses in. If you can't find
> an @ sign on your keyboard, cut and paste it from elsewhere.
Corrected this.

>> -             if (!(status & 0x40))
>> +             if (status & NAND_STATUS_READY)
>>                       break;
>
> Hm... now you're polling the PASS/FAIL bit in the status, not the
> READY/BUSY bit. I suspect that's not going to work too well...
>
Value of macro 'NAND_STATUS_READY' is '0x40' only. And AFAIK this is the bit
for ready/busy, isn't it?


Signed-off-by: Vimal Singh <vimalsingh@ti.com>
---

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
 	struct omap_nand_info *info = container_of(mtd, struct omap_nand_info,
 							mtd);
 	unsigned long timeo = jiffies;
-	int status, state = this->state;
+	int status = NAND_STATUS_FAIL, state = this->state;

 	if (state == FL_ERASING)
 		timeo += (HZ * 400) / 1000;
@@ -558,6 +560,7 @@ static int omap_wait(struct mtd_info *mtd, struct nand_chip
 		status = __raw_readb(this->IO_ADDR_R);
-		if (!(status & 0x40))
+		if (status & NAND_STATUS_READY)
 			break;
+		cond_resched();
 	}
 	return status;
 }

