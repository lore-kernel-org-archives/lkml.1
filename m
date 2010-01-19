Return-Path: <linux-kernel-owner+w=401wt.eu-S1755349Ab0ASICh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab0ASICh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 03:02:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755308Ab0ASICe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 03:02:34 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:57436 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755114Ab0ASICd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 03:02:33 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: linux-mmc@vger.kernel.org, Adrian Hunter <adrian.hunter@nokia.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Cliff Cai <cliff.cai@analog.com>
Subject: [PATCH 3/3] mmc: bfin_sdh: set timeout based on actual card data
Date: Tue, 19 Jan 2010 03:02:11 -0500
Message-Id: <1263888131-25656-3-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1263888131-25656-1-git-send-email-vapier@gentoo.org>
References: <1263888131-25656-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Cai <cliff.cai@analog.com>

The hardcoded value doesn't really work for all cards.

Signed-off-by: Cliff Cai <cliff.cai@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/mmc/host/bfin_sdh.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/bfin_sdh.c b/drivers/mmc/host/bfin_sdh.c
index f218a99..56f7b44 100644
--- a/drivers/mmc/host/bfin_sdh.c
+++ b/drivers/mmc/host/bfin_sdh.c
@@ -115,6 +115,7 @@ static int sdh_setup_data(struct sdh_host *host, struct mmc_data *data)
 	unsigned int length;
 	unsigned int data_ctl;
 	unsigned int dma_cfg;
+	unsigned int cycle_ns, timeout;
 
 	dev_dbg(mmc_dev(host->mmc), "%s enter flags: 0x%x\n", __func__, data->flags);
 	host->data = data;
@@ -135,8 +136,11 @@ static int sdh_setup_data(struct sdh_host *host, struct mmc_data *data)
 	data_ctl |= ((ffs(data->blksz) - 1) << 4);
 
 	bfin_write_SDH_DATA_CTL(data_ctl);
-
-	bfin_write_SDH_DATA_TIMER(0xFFFF);
+	/* the time of a host clock period in ns */
+	cycle_ns = 1000000000 / (get_sclk() / (2 * (host->clk_div + 1)));
+	timeout = data->timeout_ns / cycle_ns;
+	timeout += data->timeout_clks;
+	bfin_write_SDH_DATA_TIMER(timeout);
 	SSYNC();
 
 	if (data->flags & MMC_DATA_READ) {
-- 
1.6.6

