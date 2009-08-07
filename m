Return-Path: <linux-kernel-owner+w=401wt.eu-S933450AbZHGT7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933450AbZHGT7J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 15:59:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933313AbZHGT7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 15:59:08 -0400
Received: from ru.mvista.com ([213.79.90.228]:2240 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S933297AbZHGT6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 15:58:06 -0400
Date: Fri, 7 Aug 2009 23:58:06 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pierre Ossman <pierre@ossman.eu>, Kumar Gala <galak@kernel.crashing.org>,
       David Vrabel <david.vrabel@csr.com>, Ben Dooks <ben@fluff.org>,
       Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
       sdhci-devel@lists.ossman.eu, linuxppc-dev@ozlabs.org
Subject: [PATCH 2/7] sdhci-of: Avoid writing reserved bits into host
 control register
Message-ID: <20090807195806.GB2735@oksana.dev.rtsoft.ru>
References: <20090807195724.GA24020@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090807195724.GA24020@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SDHCI core tries to write HISPD bit into the host control register,
but the eSDHC controllers don't have that bit, and that causes
all sorts of misbehaviour when using 4-bit mode capable SD cards.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/mmc/host/sdhci-of.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/sdhci-of.c b/drivers/mmc/host/sdhci-of.c
index 92b5667..8440fd9 100644
--- a/drivers/mmc/host/sdhci-of.c
+++ b/drivers/mmc/host/sdhci-of.c
@@ -48,6 +48,8 @@ struct sdhci_of_host {
 #define ESDHC_CLOCK_HCKEN	0x00000002
 #define ESDHC_CLOCK_IPGEN	0x00000001
 
+#define ESDHC_HOST_CONTROL_RES	0x05
+
 static u32 esdhc_readl(struct sdhci_host *host, int reg)
 {
 	return in_be32(host->ioaddr + reg);
@@ -109,6 +111,10 @@ static void esdhc_writeb(struct sdhci_host *host, u8 val, int reg)
 	int base = reg & ~0x3;
 	int shift = (reg & 0x3) * 8;
 
+	/* Prevent SDHCI core from writing reserved bits (e.g. HISPD). */
+	if (reg == SDHCI_HOST_CONTROL)
+		val &= ~ESDHC_HOST_CONTROL_RES;
+
 	clrsetbits_be32(host->ioaddr + base , 0xff << shift, val << shift);
 }
 
-- 
1.6.3.3

