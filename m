Return-Path: <linux-kernel-owner+w=401wt.eu-S1756062AbXK0EuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062AbXK0EuU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 23:50:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753609AbXK0EuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 23:50:08 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:17722 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432AbXK0EuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 23:50:07 -0500
X-IronPort-AV: i="4.23,217,1194238800"; 
   d="scan'208"; a="57076401:sNHT27193236"
Subject: [PATCH] [libata] Set proper ATA UDMA mode for bf548 according to
	system clock.
From: sonic zhang <sonic.adi@gmail.com>
To: Linux IDE <linux-ide@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Jeff Garzik <jeff@garzik.org>
Content-Type: text/plain
Date: Tue, 27 Nov 2007 12:47:39 +0800
Message-Id: <1196138859.6974.2.camel@eight.analog.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

UDMA Mode - Frequency compatibility

UDMA5 - 100 MB/s   - SCLK  = 133 MHz
UDMA4 - 66 MB/s    - SCLK >=  80 MHz
UDMA3 - 44.4 MB/s  - SCLK >=  50 MHz
UDMA2 - 33 MB/s    - SCLK >=  40 MHz


Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
---
 drivers/ata/pata_bf54x.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/pata_bf54x.c b/drivers/ata/pata_bf54x.c
index 81db405..088a41f 100644
--- a/drivers/ata/pata_bf54x.c
+++ b/drivers/ata/pata_bf54x.c
@@ -1489,6 +1489,8 @@ static int __devinit bfin_atapi_probe(st
 	int board_idx = 0;
 	struct resource *res;
 	struct ata_host *host;
+	unsigned int fsclk = get_sclk();
+	int udma_mode = 5;
 	const struct ata_port_info *ppi[] =
 		{ &bfin_port_info[board_idx], NULL };
 
@@ -1507,6 +1509,11 @@ static int __devinit bfin_atapi_probe(st
 	if (res == NULL)
 		return -EINVAL;
 
+	while (bfin_port_info[board_idx].udma_mask>0 && udma_fsclk[udma_mode] > fsclk) {
+		udma_mode--;
+		bfin_port_info[board_idx].udma_mask >>= 1;
+	}
+
 	/*
 	 * Now that that's out of the way, wire up the port..
 	 */
-- 
1.4.3.4


