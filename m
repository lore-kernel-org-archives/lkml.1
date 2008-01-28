Return-Path: <linux-kernel-owner+w=401wt.eu-S1763567AbYA1TPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763567AbYA1TPo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 14:15:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762248AbYA1TKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 14:10:33 -0500
Received: from smtp.nokia.com ([192.100.122.230]:62435 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762228AbYA1TKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 14:10:31 -0500
Message-ID: <479E2821.8030609@indt.org.br>
Date: Mon, 28 Jan 2008 15:08:17 -0400
From: Carlos Aguiar <carlos.aguiar@indt.org.br>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 18/18] MMC: OMAP: Do not busy wait for end of command for
 ever
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Jan 2008 19:10:02.0946 (UTC) FILETIME=[6293FA20:01C861E1]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jarkko Lavinen <jarkko.lavinen@nokia.com>

The limit was a fixed 100k limit in the busy loop, which is not
accurate. It would better to have time limit for the worst case
which occurs when sending 80 cycles at 400 kHz and takes about
200 microseconds, so limit the max time spend in the busy loop
for some 250 microseconds.

Signed-off-by: Jarkko Lavinen <jarkko.lavinen@nokia.com>
---
 drivers/mmc/host/omap.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/omap.c b/drivers/mmc/host/omap.c
index 5349f9f..c52815b 100644
--- a/drivers/mmc/host/omap.c
+++ b/drivers/mmc/host/omap.c
@@ -1294,11 +1294,17 @@ static void mmc_omap_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 		OMAP_MMC_WRITE(host, CON, dsor);
 	slot->saved_con = dsor;
 	if (ios->power_mode == MMC_POWER_ON) {
+		/* worst case at 400kHz, 80 cycles makes 200 microsecs */
+		int usecs = 250;
+
 		/* Send clock cycles, poll completion */
 		OMAP_MMC_WRITE(host, IE, 0);
 		OMAP_MMC_WRITE(host, STAT, 0xffff);
 		OMAP_MMC_WRITE(host, CMD, 1 << 7);
-		while ((OMAP_MMC_READ(host, STAT) & 1) == 0);
+		while (usecs > 0 && (OMAP_MMC_READ(host, STAT) & 1) == 0) {
+			udelay(1);
+			usecs--;
+		}
 		OMAP_MMC_WRITE(host, STAT, 1);
 	}
 
-- 1.5.3.GIT

