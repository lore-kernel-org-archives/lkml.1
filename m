Return-Path: <linux-kernel-owner+w=401wt.eu-S1753741AbZJ1NVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741AbZJ1NVr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 09:21:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753723AbZJ1NVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 09:21:46 -0400
Received: from bar.sig21.net ([80.81.252.164]:43622 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753718AbZJ1NVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 09:21:45 -0400
Date: Wed, 28 Oct 2009 14:21:37 +0100
From: Johannes Stezenbach <js@sig21.net>
To: David Woodhouse <dwmw2@infradead.org>,
       David Brownell <dbrownell@users.sourceforge.net>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mtd: m25p80: make command buffer DMA-safe
Message-ID: <20091028132137.GA17813@sig21.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-21-Score: -2.6 (--)
X-Spam-21-Report: No, score=-2.6 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=-0.076,BAYES_20=-0.74 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

spi_write() requires the buffer to be DMA-safe, kmalloc()
it seperately to ensure this.

Signed-off-by: Johannes Stezenbach <js@sig21.net>


diff --git a/drivers/mtd/devices/m25p80.c b/drivers/mtd/devices/m25p80.c
index 4c19269..21dd4d9 100644
--- a/drivers/mtd/devices/m25p80.c
+++ b/drivers/mtd/devices/m25p80.c
@@ -79,7 +79,7 @@ struct m25p {
 	struct mtd_info		mtd;
 	unsigned		partitioned:1;
 	u8			erase_opcode;
-	u8			command[CMD_SIZE + FAST_READ_DUMMY_BYTE];
+	u8			*command;
 };
 
 static inline struct m25p *mtd_to_m25p(struct mtd_info *mtd)
@@ -770,6 +770,11 @@ static int __devinit m25p_probe(struct spi_device *spi)
 	flash = kzalloc(sizeof *flash, GFP_KERNEL);
 	if (!flash)
 		return -ENOMEM;
+	flash->command = kmalloc(CMD_SIZE + FAST_READ_DUMMY_BYTE, GFP_KERNEL);
+	if (!flash->command) {
+		kfree(flash);
+		return -ENOMEM;
+	}
 
 	flash->spi = spi;
 	mutex_init(&flash->lock);
@@ -888,8 +893,10 @@ static int __devexit m25p_remove(struct spi_device *spi)
 		status = del_mtd_partitions(&flash->mtd);
 	else
 		status = del_mtd_device(&flash->mtd);
-	if (status == 0)
+	if (status == 0) {
+		kfree(flash->command);
 		kfree(flash);
+	}
 	return 0;
 }
 
