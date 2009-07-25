Return-Path: <linux-kernel-owner+w=401wt.eu-S1752786AbZGYXwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786AbZGYXwR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 19:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752434AbZGYXwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 19:52:16 -0400
Received: from cs20.apochromatic.org ([204.152.189.161]:52717 "EHLO
	cs20.apochromatic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242AbZGYXwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 19:52:15 -0400
Date: Sun, 26 Jul 2009 00:51:50 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Adrian Hunter <adrian.hunter@nokia.com>
Cc: Pierre Ossman <pierre@ossman.eu>,
       "Lavinen Jarkko (Nokia-D/Helsinki)" <jarkko.lavinen@nokia.com>,
       "Karpov Denis.2 (EXT-Teleca/Helsinki)" <ext-denis.2.karpov@nokia.com>,
       linux-omap Mailing List <linux-omap@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 7/32] mmc: add host capabilities for SD only and MMC
	only
Message-ID: <20090725235150.GD12665@console-pimps.org>
References: <20090710124004.1262.10422.sendpatchset@ahunter-tower> <20090710124054.1262.18902.sendpatchset@ahunter-tower> <20090725155336.GA12665@console-pimps.org> <4A6B300A.10706@nokia.com> <20090725184030.GB12665@console-pimps.org> <4A6B60C3.3070609@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A6B60C3.3070609@nokia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 25, 2009 at 10:45:07PM +0300, Adrian Hunter wrote:
>
> I have no objections if you write such a patch :-)

See also my change to [PATCH 32/32] of this series.

I don't have hardware to test all of the affected drivers but I was
thinking of something along the lines of,

---

mmc: add host capabilities for SD only and MMC only

Some hosts can accept only certain types of cards.  For example, an eMMC
is MMC only and a uSD slot may be SD only.  However the MMC card scanning
logic checks for all card types one by one.

Add host capabilities to specify which card types can be used, and amend
the card scanning logic to skip scanning for those types which cannot be
used.

Signed-off-by: Matt Fleming <matt@console-pimps.org>
Cc: Adrian Hunter <adrian.hunter@nokia.com>
Cc: Ian Molton <ian@mnementh.co.uk>
Cc: "Roberto A. Foglietta" <roberto.foglietta@gmail.com>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Cc: Denis Karpov <ext-denis.2.karpov@nokia.com>
Cc: Pierre Ossman <pierre@ossman.eu>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/mmc/core/core.c       |   16 +++++++++++++++-
 drivers/mmc/host/at91_mci.c   |    2 +-
 drivers/mmc/host/atmel-mci.c  |    1 +
 drivers/mmc/host/au1xmmc.c    |    3 ++-
 drivers/mmc/host/cb710-mmc.c  |    3 ++-
 drivers/mmc/host/imxmmc.c     |    3 ++-
 drivers/mmc/host/mmc_spi.c    |    2 +-
 drivers/mmc/host/mmci.c       |    2 ++
 drivers/mmc/host/mvsdio.c     |    3 ++-
 drivers/mmc/host/mxcmmc.c     |    3 ++-
 drivers/mmc/host/omap.c       |    2 +-
 drivers/mmc/host/pxamci.c     |    2 +-
 drivers/mmc/host/s3cmci.c     |    3 ++-
 drivers/mmc/host/sdhci.c      |    2 +-
 drivers/mmc/host/sdricoh_cs.c |    3 ++-
 drivers/mmc/host/tifm_sd.c    |    3 ++-
 drivers/mmc/host/tmio_mmc.c   |    3 ++-
 drivers/mmc/host/via-sdmmc.c  |    3 ++-
 drivers/mmc/host/wbsd.c       |    3 ++-
 include/linux/mmc/host.h      |    3 +++
 20 files changed, 48 insertions(+), 17 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index c5a7857..7d905f9 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -1066,7 +1066,11 @@ void mmc_rescan(struct work_struct *work)
 	mmc_power_up(host);
 	mmc_go_idle(host);
 
-	mmc_send_if_cond(host, host->ocr_avail);
+	if ((host->caps & MMC_CAP_SDIO) || (host->caps & MMC_CAP_SD))
+		mmc_send_if_cond(host, host->ocr_avail);
+
+	if (!(host->caps & MMC_CAP_SDIO))
+		goto not_sdio;
 
 	/*
 	 * First we search for SDIO...
@@ -1078,6 +1082,10 @@ void mmc_rescan(struct work_struct *work)
 		goto out;
 	}
 
+not_sdio:
+	if (!(host->caps & MMC_CAP_SD))
+		goto not_sd;
+
 	/*
 	 * ...then normal SD...
 	 */
@@ -1088,6 +1096,10 @@ void mmc_rescan(struct work_struct *work)
 		goto out;
 	}
 
+not_sd:
+	if (!(host->caps & MMC_CAP_MMC))
+		goto not_mmc;
+
 	/*
 	 * ...and finally MMC.
 	 */
@@ -1098,6 +1110,8 @@ void mmc_rescan(struct work_struct *work)
 		goto out;
 	}
 
+not_mmc:
+
 	mmc_release_host(host);
 	mmc_power_off(host);
 
diff --git a/drivers/mmc/host/at91_mci.c b/drivers/mmc/host/at91_mci.c
index e556d42..aa541a5 100644
--- a/drivers/mmc/host/at91_mci.c
+++ b/drivers/mmc/host/at91_mci.c
@@ -1007,7 +1007,7 @@ static int __init at91_mci_probe(struct platform_device *pdev)
 	mmc->f_min = 375000;
 	mmc->f_max = 25000000;
 	mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;
-	mmc->caps = MMC_CAP_SDIO_IRQ;
+	mmc->caps = MMC_CAP_SDIO_IRQ | MMC_CAP_SDIO | MMC_CAP_SD | MMC_CAP_MMC;
 
 	mmc->max_blk_size = 4095;
 	mmc->max_blk_count = mmc->max_req_size;
diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index 7b603e4..907841a 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -1467,6 +1467,7 @@ static int __init atmci_init_slot(struct atmel_mci *host,
 	mmc->f_min = DIV_ROUND_UP(host->bus_hz, 512);
 	mmc->f_max = host->bus_hz / 2;
 	mmc->ocr_avail	= MMC_VDD_32_33 | MMC_VDD_33_34;
+	mmc->caps = MMC_CAP_SDIO | MMC_CAP_SD | MMC_CAP_MMC;
 	if (slot_data->bus_width >= 4)
 		mmc->caps |= MMC_CAP_4_BIT_DATA;
 
diff --git a/drivers/mmc/host/au1xmmc.c b/drivers/mmc/host/au1xmmc.c
index d3f5561..4aae609 100644
--- a/drivers/mmc/host/au1xmmc.c
+++ b/drivers/mmc/host/au1xmmc.c
@@ -1003,7 +1003,8 @@ static int __devinit au1xmmc_probe(struct platform_device *pdev)
 	mmc->max_blk_count = 512;
 
 	mmc->ocr_avail = AU1XMMC_OCR;
-	mmc->caps = MMC_CAP_4_BIT_DATA | MMC_CAP_SDIO_IRQ;
+	mmc->caps = MMC_CAP_4_BIT_DATA | MMC_CAP_SDIO_IRQ |
+		MMC_CAP_SDIO | MMC_CAP_SD | MMC_CAP_MMC;
 
 	host->status = HOST_S_IDLE;
 
diff --git a/drivers/mmc/host/cb710-mmc.c b/drivers/mmc/host/cb710-mmc.c
index 11efefb..622b420 100644
--- a/drivers/mmc/host/cb710-mmc.c
+++ b/drivers/mmc/host/cb710-mmc.c
@@ -721,7 +721,8 @@ static int __devinit cb710_mmc_init(struct platform_device *pdev)
 	mmc->f_max = val;
 	mmc->f_min = val >> cb710_clock_divider_log2[CB710_MAX_DIVIDER_IDX];
 	mmc->ocr_avail = MMC_VDD_32_33|MMC_VDD_33_34;
-	mmc->caps = MMC_CAP_4_BIT_DATA;
+	mmc->caps = MMC_CAP_4_BIT_DATA | MMC_CAP_SDIO |
+		MMC_CAP_SD | MMC_CAP_MMC;
 
 	reader = mmc_priv(mmc);
 
diff --git a/drivers/mmc/host/imxmmc.c b/drivers/mmc/host/imxmmc.c
index e0be21a..b6653ba 100644
--- a/drivers/mmc/host/imxmmc.c
+++ b/drivers/mmc/host/imxmmc.c
@@ -962,7 +962,8 @@ static int __init imxmci_probe(struct platform_device *pdev)
 	mmc->f_min = 150000;
 	mmc->f_max = CLK_RATE/2;
 	mmc->ocr_avail = MMC_VDD_32_33;
-	mmc->caps = MMC_CAP_4_BIT_DATA;
+	mmc->caps = MMC_CAP_4_BIT_DATA | MMC_CAP_SDIO |
+		MMC_CAP_SD | MMC_CAP_MMC;
 
 	/* MMC core transfer sizes tunable parameters */
 	mmc->max_hw_segs = 64;
diff --git a/drivers/mmc/host/mmc_spi.c b/drivers/mmc/host/mmc_spi.c
index a461017..e1a3c7f 100644
--- a/drivers/mmc/host/mmc_spi.c
+++ b/drivers/mmc/host/mmc_spi.c
@@ -1386,7 +1386,7 @@ static int mmc_spi_probe(struct spi_device *spi)
 	mmc->max_req_size = MMC_SPI_BLOCKSATONCE * MMC_SPI_BLOCKSIZE;
 	mmc->max_blk_count = MMC_SPI_BLOCKSATONCE;
 
-	mmc->caps = MMC_CAP_SPI;
+	mmc->caps = MMC_CAP_SPI | MMC_CAP_SDIO | MMC_CAP_SD | MMC_CAP_MMC;
 
 	/* SPI doesn't need the lowspeed device identification thing for
 	 * MMC or SD cards, since it never comes up in open drain mode.
diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index e1aa847..55e882b 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -557,6 +557,8 @@ static int __devinit mmci_probe(struct amba_device *dev, struct amba_id *id)
 	mmc->f_max = min(host->mclk, fmax);
 	mmc->ocr_avail = plat->ocr_mask;
 
+	mmc->caps = MMC_CAP_SDIO | MMC_CAP_SD | MMC_CAP_MMC;
+
 	/*
 	 * We can do SGIO
 	 */
diff --git a/drivers/mmc/host/mvsdio.c b/drivers/mmc/host/mvsdio.c
index 34e2348..1c3f4aa 100644
--- a/drivers/mmc/host/mvsdio.c
+++ b/drivers/mmc/host/mvsdio.c
@@ -734,7 +734,8 @@ static int __init mvsd_probe(struct platform_device *pdev)
 
 	mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;
 	mmc->caps = MMC_CAP_4_BIT_DATA | MMC_CAP_SDIO_IRQ |
-		    MMC_CAP_SD_HIGHSPEED | MMC_CAP_MMC_HIGHSPEED;
+		    MMC_CAP_SD_HIGHSPEED | MMC_CAP_MMC_HIGHSPEED |
+		    MMC_CAP_SDIO | MMC_CAP_SD | MMC_CAP_MMC;
 
 	mmc->f_min = DIV_ROUND_UP(host->base_clock, MVSD_BASE_DIV_MAX);
 	mmc->f_max = maxfreq;
diff --git a/drivers/mmc/host/mxcmmc.c b/drivers/mmc/host/mxcmmc.c
index bc14bb1..d67d639 100644
--- a/drivers/mmc/host/mxcmmc.c
+++ b/drivers/mmc/host/mxcmmc.c
@@ -700,7 +700,8 @@ static int mxcmci_probe(struct platform_device *pdev)
 	}
 
 	mmc->ops = &mxcmci_ops;
-	mmc->caps = MMC_CAP_4_BIT_DATA;
+	mmc->caps = MMC_CAP_4_BIT_DATA | MMC_CAP_MMC |
+		MMC_CAP_SD | MMC_CAP_SDIO;
 
 	/* MMC core transfer sizes tunable parameters */
 	mmc->max_hw_segs = 64;
diff --git a/drivers/mmc/host/omap.c b/drivers/mmc/host/omap.c
index e7a331d..d6d23e5 100644
--- a/drivers/mmc/host/omap.c
+++ b/drivers/mmc/host/omap.c
@@ -1314,7 +1314,7 @@ static int __init mmc_omap_new_slot(struct mmc_omap_host *host, int id)
 
 	host->slots[id] = slot;
 
-	mmc->caps = 0;
+	mmc->caps = MMC_CAP_SDIO | MMC_CAP_SD | MMC_CAP_MMC;
 	if (host->pdata->slots[id].wires >= 4)
 		mmc->caps |= MMC_CAP_4_BIT_DATA;
 
diff --git a/drivers/mmc/host/pxamci.c b/drivers/mmc/host/pxamci.c
index e55ac79..1a71da3 100644
--- a/drivers/mmc/host/pxamci.c
+++ b/drivers/mmc/host/pxamci.c
@@ -598,7 +598,7 @@ static int pxamci_probe(struct platform_device *pdev)
 
 	pxamci_init_ocr(host);
 
-	mmc->caps = 0;
+	mmc->caps = MMC_CAP_SDIO | MMC_CAP_SD | MMC_CAP_MMC;
 	host->cmdat = 0;
 	if (!cpu_is_pxa25x()) {
 		mmc->caps |= MMC_CAP_4_BIT_DATA | MMC_CAP_SDIO_IRQ;
diff --git a/drivers/mmc/host/s3cmci.c b/drivers/mmc/host/s3cmci.c
index 8c08cd7..9d73289 100644
--- a/drivers/mmc/host/s3cmci.c
+++ b/drivers/mmc/host/s3cmci.c
@@ -1376,7 +1376,8 @@ static int __devinit s3cmci_probe(struct platform_device *pdev, int is2440)
 
 	mmc->ops 	= &s3cmci_ops;
 	mmc->ocr_avail	= MMC_VDD_32_33 | MMC_VDD_33_34;
-	mmc->caps	= MMC_CAP_4_BIT_DATA;
+	mmc->caps	= MMC_CAP_4_BIT_DATA | MMC_CAP_SDIO |
+			  MMC_CAP_SD | MMC_CAP_MMC;
 	mmc->f_min 	= host->clk_rate / (host->clk_div * 256);
 	mmc->f_max 	= host->clk_rate / host->clk_div;
 
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 6779b4e..6334938 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1768,7 +1768,7 @@ int sdhci_add_host(struct sdhci_host *host)
 	mmc->ops = &sdhci_ops;
 	mmc->f_min = host->max_clk / 256;
 	mmc->f_max = host->max_clk;
-	mmc->caps = MMC_CAP_SDIO_IRQ;
+	mmc->caps = MMC_CAP_SDIO_IRQ | MMC_CAP_SDIO | MMC_CAP_SD | MMC_CAP_MMC;
 
 	if (!(host->quirks & SDHCI_QUIRK_FORCE_1_BIT_DATA))
 		mmc->caps |= MMC_CAP_4_BIT_DATA;
diff --git a/drivers/mmc/host/sdricoh_cs.c b/drivers/mmc/host/sdricoh_cs.c
index cb41e9c..7a24bb1 100644
--- a/drivers/mmc/host/sdricoh_cs.c
+++ b/drivers/mmc/host/sdricoh_cs.c
@@ -443,7 +443,8 @@ static int sdricoh_init_mmc(struct pci_dev *pci_dev,
 	mmc->f_min = 450000;
 	mmc->f_max = 24000000;
 	mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;
-	mmc->caps |= MMC_CAP_4_BIT_DATA;
+	mmc->caps |= MMC_CAP_4_BIT_DATA | MMC_CAP_SDIO |
+		MMC_CAP_SD | MMC_CAP_MMC;
 
 	mmc->max_seg_size = 1024 * 512;
 	mmc->max_blk_size = 512;
diff --git a/drivers/mmc/host/tifm_sd.c b/drivers/mmc/host/tifm_sd.c
index 82554dd..cb170d5 100644
--- a/drivers/mmc/host/tifm_sd.c
+++ b/drivers/mmc/host/tifm_sd.c
@@ -973,7 +973,8 @@ static int tifm_sd_probe(struct tifm_dev *sock)
 
 	mmc->ops = &tifm_sd_ops;
 	mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;
-	mmc->caps = MMC_CAP_4_BIT_DATA;
+	mmc->caps = MMC_CAP_4_BIT_DATA | MMC_CAP_SDIO |
+		MMC_CAP_SD | MMC_CAP_MMC;
 	mmc->f_min = 20000000 / 60;
 	mmc->f_max = 24000000;
 
diff --git a/drivers/mmc/host/tmio_mmc.c b/drivers/mmc/host/tmio_mmc.c
index c246191..a14d1af 100644
--- a/drivers/mmc/host/tmio_mmc.c
+++ b/drivers/mmc/host/tmio_mmc.c
@@ -555,7 +555,8 @@ static int __devinit tmio_mmc_probe(struct platform_device *dev)
 	}
 
 	mmc->ops = &tmio_mmc_ops;
-	mmc->caps = MMC_CAP_4_BIT_DATA;
+	mmc->caps = MMC_CAP_4_BIT_DATA | MMC_CAP_SDIO |
+		MMC_CAP_SD | MMC_CAP_MMC;
 	mmc->f_max = pdata->hclk;
 	mmc->f_min = mmc->f_max / 512;
 	mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;
diff --git a/drivers/mmc/host/via-sdmmc.c b/drivers/mmc/host/via-sdmmc.c
index 632858a..c6c652a 100644
--- a/drivers/mmc/host/via-sdmmc.c
+++ b/drivers/mmc/host/via-sdmmc.c
@@ -1046,7 +1046,8 @@ static void via_init_mmc_host(struct via_crdr_mmc_host *host)
 	mmc->f_min = VIA_CRDR_MIN_CLOCK;
 	mmc->f_max = VIA_CRDR_MAX_CLOCK;
 	mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34 | MMC_VDD_165_195;
-	mmc->caps = MMC_CAP_4_BIT_DATA | MMC_CAP_SD_HIGHSPEED;
+	mmc->caps = MMC_CAP_4_BIT_DATA | MMC_CAP_SD_HIGHSPEED |
+		MMC_CAP_SDIO | MMC_CAP_SD | MMC_CAP_MMC;
 	mmc->ops = &via_sdc_ops;
 
 	/*Hardware cannot do scatter lists*/
diff --git a/drivers/mmc/host/wbsd.c b/drivers/mmc/host/wbsd.c
index 89bf8cd..16f0e5b 100644
--- a/drivers/mmc/host/wbsd.c
+++ b/drivers/mmc/host/wbsd.c
@@ -1219,7 +1219,8 @@ static int __devinit wbsd_alloc_mmc(struct device *dev)
 	mmc->f_min = 375000;
 	mmc->f_max = 24000000;
 	mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;
-	mmc->caps = MMC_CAP_4_BIT_DATA;
+	mmc->caps = MMC_CAP_4_BIT_DATA | MMC_CAP_SDIO |
+		MMC_CAP_SD | MMC_CAP_MMC;
 
 	spin_lock_init(&host->lock);
 
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 4ae5766..3902c5c 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -150,6 +150,9 @@ struct mmc_host {
 #define MMC_CAP_DISABLE		(1 << 7)	/* Can the host be disabled */
 #define MMC_CAP_NONREMOVABLE	(1 << 8)	/* Nonremovable e.g. eMMC */
 #define MMC_CAP_WAIT_WHILE_BUSY	(1 << 9)	/* Waits while card is busy */
+#define MMC_CAP_SDIO		(1 << 10)	/* Card can be SDIO */
+#define MMC_CAP_SD		(1 << 11)	/* Card can be SD */
+#define MMC_CAP_MMC		(1 << 12)	/* Card can be MMC */
 
 	/* host specific block data */
 	unsigned int		max_seg_size;	/* see blk_queue_max_segment_size */
-- 
1.6.4.rc0

