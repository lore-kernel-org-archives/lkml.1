Return-Path: <linux-kernel-owner+w=401wt.eu-S1758136AbZF0Fh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758136AbZF0Fh0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 01:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbZF0FhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 01:37:19 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:33024 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055AbZF0FhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 01:37:18 -0400
Message-ID: <63536.192.168.10.89.1246081026.squirrel@dbdmail.itg.ti.com>
In-Reply-To: <57946.192.168.10.89.1246035774.squirrel@dbdmail.itg.ti.com>
References: <53729.192.168.10.89.1246035472.squirrel@dbdmail.itg.ti.com>
    <57946.192.168.10.89.1246035774.squirrel@dbdmail.itg.ti.com>
Date: Sat, 27 Jun 2009 11:07:06 +0530 (IST)
Subject: Re: [PATCH][MTD][NAND]: fix omap2.c compile failure and warning
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

> The 'status' you return in the case that you _have_ gone through the
> loop is still wrong though, isn't it?
Yes, I have corrected that in below patch. Its my bad, I did not fix it
previously.

Signed-off-by: Vimal Singh <vimalsingh at ti.com>
Signed-off-by: Ming Lei <tom.leiming at gmail.com>
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


