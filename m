Return-Path: <linux-kernel-owner+w=401wt.eu-S1756023AbXJ3JTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023AbXJ3JTs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 05:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753834AbXJ3JST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 05:18:19 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:42181 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155AbXJ3JSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 05:18:15 -0400
X-IronPort-AV: i="4.21,346,1188792000"; 
   d="scan'208"; a="55175267:sNHT32152736"
From: Bryan Wu <bryan.wu@analog.com>
To: dbrownell@users.sourceforge.net, spi-devel-general@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org,
       Mike Frysinger <michael.frysinger@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 05/14] Blackfin SPI driver: prevent people from setting bits in ctl_reg
Date: Tue, 30 Oct 2007 17:17:56 +0800
Message-Id: <1193735885-8202-6-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1193735885-8202-1-git-send-email-bryan.wu@analog.com>
References: <1193735885-8202-1-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <michael.frysinger@analog.com>

Prevent people from setting bits in ctl_reg that the SPI
framework already handles, hopefully we can one day drop
ctl_reg completely

Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/spi/spi_bfin5xx.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index 1a55aa7..e4d64a0 100644
--- a/drivers/spi/spi_bfin5xx.c
+++ b/drivers/spi/spi_bfin5xx.c
@@ -996,6 +996,16 @@ static int setup(struct spi_device *spi)
 
 	/* chip_info isn't always needed */
 	if (chip_info) {
+		/* Make sure people stop trying to set fields via ctl_reg when they
+		 * should actually be using common SPI framework.  Currently we let
+		 * through: WOM EMISO PSSE GM SZ TIMOD.  Not sure if a user actually
+		 * needs/uses any of these, but let's assume (for now) they do.
+		 */
+		if (chip_info->ctl_reg & (SPE | MSTR | CPOL | CPHA | LSBF | SIZE)) {
+			dev_err(&spi->dev, "do not set bits in ctl_reg that the SPI framework provides\n");
+			return -EINVAL;
+		}
+
 		chip->enable_dma = chip_info->enable_dma != 0
 		    && drv_data->master_info->enable_dma;
 		chip->ctl_reg = chip_info->ctl_reg;
-- 
1.5.3.4
