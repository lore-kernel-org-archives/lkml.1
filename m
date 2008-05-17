Return-Path: <linux-kernel-owner+w=401wt.eu-S1754821AbYEQKwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821AbYEQKwW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 06:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752862AbYEQKwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 06:52:14 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:31956 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbYEQKwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 06:52:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:sender;
        b=RXys2ipgr0S+hv3SEY2EyOFxArtmYb6VS6w+0D5JWFPwOzY5IEHFF5j9gsbq7mWfbz0m5H/VsWdpw7TAOzJCKGVdlBQionq5pRgLJjxJUZZ8uA88eb8bxkXjT7WdpaMq3iFKxjHPAQUzUxGHbeKxmm3eDR5jNtPCg4Flv75z8WE=
From: Bryan Wu <cooloney@kernel.org>
To: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       mike@steroidmicros.com
Cc: Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/1] mtd m25p80: fix bug - ATmel spi flash fails to be copied to
Date: Sat, 17 May 2008 18:52:06 +0800
Message-Id: <1211021526-24076-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Atmel serial flash tends to power up with the protection status bits set.
http://blackfin.uclinux.org/gf/project/uclinux-dist/tracker/?action=TrackerItemEdit&tracker_item_id=4089

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/mtd/devices/m25p80.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/devices/m25p80.c b/drivers/mtd/devices/m25p80.c
index 25efd33..b10649b 100644
--- a/drivers/mtd/devices/m25p80.c
+++ b/drivers/mtd/devices/m25p80.c
@@ -33,6 +33,7 @@
 /* Flash opcodes. */
 #define	OPCODE_WREN		0x06	/* Write enable */
 #define	OPCODE_RDSR		0x05	/* Read status register */
+#define	OPCODE_WRSR		0x01	/* Write status register 1 byte */
 #define	OPCODE_NORM_READ	0x03	/* Read data bytes (low frequency) */
 #define	OPCODE_FAST_READ	0x0b	/* Read data bytes (high frequency) */
 #define	OPCODE_PP		0x02	/* Page program (up to 256 bytes) */
@@ -112,6 +113,19 @@ static int read_sr(struct m25p *flash)
 	return val;
 }
 
+/*
+ * Write status register 1 byte
+ * Returns negative if error occurred.
+ */
+static int write_sr(struct m25p *flash, u8 val)
+{
+	flash->command[0] = OPCODE_WRSR;
+	flash->command[1] = val;
+
+	spi_write(flash->spi, flash->command, 2);
+
+	return spi_write(flash->spi, flash->command, 2);
+}
 
 /*
  * Set write enable latch with Write Enable command.
@@ -587,6 +601,16 @@ static int __devinit m25p_probe(struct spi_device *spi)
 	mutex_init(&flash->lock);
 	dev_set_drvdata(&spi->dev, flash);
 
+	/*
+	 * Atmel serial flash tend to power up
+	 * with the software protection bits set
+	 */
+
+	if (info->jedec_id >> 16 == 0x1f) {
+		write_enable(flash);
+		write_sr(flash, 0);
+	}
+
 	if (data && data->name)
 		flash->mtd.name = data->name;
 	else
-- 
1.5.5

