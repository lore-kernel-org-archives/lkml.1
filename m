Return-Path: <linux-kernel-owner+w=401wt.eu-S1751919AbZL1IPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919AbZL1IPy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 03:15:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751176AbZL1IPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 03:15:53 -0500
Received: from relay.atmel.no ([80.232.32.139]:61558 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389AbZL1IPw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 03:15:52 -0500
Date: Mon, 28 Dec 2009 09:13:18 +0100
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: Peter Huewe <PeterHuewe@gmx.de>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Ma <pma@mediamatech.com>, linux-kernel@vger.kernel.org,
       linux-mmc@vger.kernel.org, peterhuewe@gmx.de
Subject: Re: [PATCH] arch/avr32: Fix build failure for avr32 caused by typo
Message-ID: <20091228091318.454c4713@hcegtvedt.norway.atmel.com>
In-Reply-To: <200912252008.45602.PeterHuewe@gmx.de>
References: <200912252008.45602.PeterHuewe@gmx.de>
Organization: Atmel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Dec 2009 20:08:45 +0100
Peter Huewe <PeterHuewe@gmx.de> wrote:

> This patch fixes a build failure introduced by the patch
>   atmel-mci: change use of dma slave interface by Nicolas Ferre
> by changing mci_dma_slave to the correct name of mci_dma_data
> 
> This should make the avr32 tree build again.
> 

Ah, great, I have not gotten around to test this yet. Thanks for the
patch. I've done some minor changes and also fixed the kzalloc/kfree
error handling. Please see the inlined patch below.

>From c8d4b6c01b19044467867b24e218b8a59ed04291 Mon Sep 17 00:00:00 2001
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Date: Mon, 28 Dec 2009 09:08:00 +0100
Subject: [PATCH] avr32: Fix build failure when using atmel-mci caused by typo

This patch fixes a build failure introduced by the patch atmel-mci: change use
of dma slave interface by Nicolas Ferre by changing mci_dma_slave to the
correct name of mci_dma_data.

It also will only free the struct mci_dma_data if it has been allocated.

This should make the avr32 tree build again.

References:
http://kisskb.ellerman.id.au/kisskb/buildresult/1893610/
http://git.kernel.org/?p=linux/kernel/git/sfr/linux-next.git;a=commitdiff;h=2635d1ba711560d521f6218c585a3e0401f566e1

Patch against Linus' tree.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
Signed-off-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
---
 arch/avr32/mach-at32ap/at32ap700x.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/avr32/mach-at32ap/at32ap700x.c b/arch/avr32/mach-at32ap/at32ap700x.c
index 1aa1ea5..6e093c3 100644
--- a/arch/avr32/mach-at32ap/at32ap700x.c
+++ b/arch/avr32/mach-at32ap/at32ap700x.c
@@ -1325,7 +1325,7 @@ struct platform_device *__init
 at32_add_device_mci(unsigned int id, struct mci_platform_data *data)
 {
 	struct platform_device		*pdev;
-	struct mci_dma_slave		*slave;
+	struct mci_dma_data		*slave;
 	u32				pioa_mask;
 	u32				piob_mask;
 
@@ -1344,7 +1344,7 @@ at32_add_device_mci(unsigned int id, struct mci_platform_data *data)
 				ARRAY_SIZE(atmel_mci0_resource)))
 		goto fail;
 
-	slave = kzalloc(sizeof(struct mci_dma_slave), GFP_KERNEL);
+	slave = kzalloc(sizeof(struct mci_dma_data), GFP_KERNEL);
 
 	slave->sdata.dma_dev = &dw_dmac0_device.dev;
 	slave->sdata.reg_width = DW_DMA_SLAVE_WIDTH_32BIT;
@@ -1357,7 +1357,7 @@ at32_add_device_mci(unsigned int id, struct mci_platform_data *data)
 
 	if (platform_device_add_data(pdev, data,
 				sizeof(struct mci_platform_data)))
-		goto fail;
+		goto fail_free;
 
 	/* CLK line is common to both slots */
 	pioa_mask = 1 << 10;
@@ -1381,7 +1381,7 @@ at32_add_device_mci(unsigned int id, struct mci_platform_data *data)
 		/* Slot is unused */
 		break;
 	default:
-		goto fail;
+		goto fail_free;
 	}
 
 	select_peripheral(PIOA, pioa_mask, PERIPH_A, 0);
@@ -1408,7 +1408,7 @@ at32_add_device_mci(unsigned int id, struct mci_platform_data *data)
 		break;
 	default:
 		if (!data->slot[0].bus_width)
-			goto fail;
+			goto fail_free;
 
 		data->slot[1].bus_width = 0;
 		break;
@@ -1419,9 +1419,10 @@ at32_add_device_mci(unsigned int id, struct mci_platform_data *data)
 	platform_device_add(pdev);
 	return pdev;
 
+fail_free:
+	kfree(slave);
 fail:
 	data->dma_slave = NULL;
-	kfree(slave);
 	platform_device_put(pdev);
 	return NULL;
 }
-- 
1.6.0.4

-- 
Best regards,
Hans-Christian Egtvedt
