Return-Path: <linux-kernel-owner+w=401wt.eu-S1758175AbYESJOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758175AbYESJOT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 05:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751441AbYESJOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 05:14:12 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:14414 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbYESJOK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 05:14:10 -0400
X-IronPort-AV: E=Sophos;i="4.27,503,1204520400"; 
   d="scan'208";a="53748519"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 1/1] mtd m25p80: fix bug - ATmel spi flash fails to be copied to
Date: Mon, 19 May 2008 10:12:46 +0100
Message-ID: <8A42379416420646B9BFAC9682273B6D0183AE38@limkexm3.ad.analog.com>
In-Reply-To: <1211021526-24076-1-git-send-email-cooloney@kernel.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/1] mtd m25p80: fix bug - ATmel spi flash fails to be copied to
Thread-Index: Aci4DBTTy+rzvUrMRiK1B+KlmB2ogQBhCOjw
References: <1211021526-24076-1-git-send-email-cooloney@kernel.org>
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: "Bryan Wu" <cooloney@kernel.org>, <linux-mtd@lists.infradead.org>,
       <linux-kernel@vger.kernel.org>, <mike@steroidmicros.com>
Cc: "Michael Hennerich" <michael.hennerich@analog.com>
X-OriginalArrivalTime: 19 May 2008 09:12:49.0094 (UTC) FILETIME=[82341660:01C8B990]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>+	spi_write(flash->spi, flash->command, 2);
>+
>+	return spi_write(flash->spi, flash->command, 2);


I just noticed that write_sr contains a duplicated spi_write.
Bryan sends out a new patch.

-Michael

>-----Original Message-----
>From: Bryan Wu [mailto:cooloney.lkml@gmail.com] On Behalf Of Bryan Wu
>Sent: Samstag, 17. Mai 2008 12:52
>To: linux-mtd@lists.infradead.org; linux-kernel@vger.kernel.org;
>mike@steroidmicros.com
>Cc: Michael Hennerich; Bryan Wu
>Subject: [PATCH 1/1] mtd m25p80: fix bug - ATmel spi flash fails to be
>copied to
>
>From: Michael Hennerich <michael.hennerich@analog.com>
>
>Atmel serial flash tends to power up with the protection status bits
set.
>http://blackfin.uclinux.org/gf/project/uclinux-
>dist/tracker/?action=TrackerItemEdit&tracker_item_id=4089
>
>Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
>Signed-off-by: Bryan Wu <cooloney@kernel.org>
>---
> drivers/mtd/devices/m25p80.c |   24 ++++++++++++++++++++++++
> 1 files changed, 24 insertions(+), 0 deletions(-)
>
>diff --git a/drivers/mtd/devices/m25p80.c
b/drivers/mtd/devices/m25p80.c
>index 25efd33..b10649b 100644
>--- a/drivers/mtd/devices/m25p80.c
>+++ b/drivers/mtd/devices/m25p80.c
>@@ -33,6 +33,7 @@
> /* Flash opcodes. */
> #define	OPCODE_WREN		0x06	/* Write enable */
> #define	OPCODE_RDSR		0x05	/* Read status register
*/
>+#define	OPCODE_WRSR		0x01	/* Write status register
1 byte */
> #define	OPCODE_NORM_READ	0x03	/* Read data bytes (low
frequency) */
> #define	OPCODE_FAST_READ	0x0b	/* Read data bytes (high
frequency) */
> #define	OPCODE_PP		0x02	/* Page program (up to
256 bytes) */
>@@ -112,6 +113,19 @@ static int read_sr(struct m25p *flash)
> 	return val;
> }
>
>+/*
>+ * Write status register 1 byte
>+ * Returns negative if error occurred.
>+ */
>+static int write_sr(struct m25p *flash, u8 val)
>+{
>+	flash->command[0] = OPCODE_WRSR;
>+	flash->command[1] = val;
>+
>+	spi_write(flash->spi, flash->command, 2);
>+
>+	return spi_write(flash->spi, flash->command, 2);
>+}
>
> /*
>  * Set write enable latch with Write Enable command.
>@@ -587,6 +601,16 @@ static int __devinit m25p_probe(struct spi_device
>*spi)
> 	mutex_init(&flash->lock);
> 	dev_set_drvdata(&spi->dev, flash);
>
>+	/*
>+	 * Atmel serial flash tend to power up
>+	 * with the software protection bits set
>+	 */
>+
>+	if (info->jedec_id >> 16 == 0x1f) {
>+		write_enable(flash);
>+		write_sr(flash, 0);
>+	}
>+
> 	if (data && data->name)
> 		flash->mtd.name = data->name;
> 	else
>--
>1.5.5
