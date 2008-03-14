Return-Path: <linux-kernel-owner+w=401wt.eu-S1760447AbYCNTpN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760447AbYCNTpN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 15:45:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759493AbYCNTmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 15:42:10 -0400
Received: from smtp.nokia.com ([192.100.105.134]:36403 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759490AbYCNTmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 15:42:08 -0400
Message-ID: <47DAD3E1.2010100@indt.org.br>
Date: Fri, 14 Mar 2008 15:37:05 -0400
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
X-OriginalArrivalTime: 14 Mar 2008 19:39:45.0477 (UTC) FILETIME=[280D1F50:01C8860B]
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
index cb7cb34..0f18b3b 100644
--- a/drivers/mmc/host/omap.c
+++ b/drivers/mmc/host/omap.c
@@ -1276,11 +1276,17 @@ static void mmc_omap_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
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

