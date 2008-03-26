Return-Path: <linux-kernel-owner+w=401wt.eu-S1758293AbYCZUTF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758293AbYCZUTF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 16:19:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757066AbYCZUNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 16:13:24 -0400
Received: from smtp.nokia.com ([192.100.122.230]:59819 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756623AbYCZUNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 16:13:21 -0400
Message-ID: <47EAAD9A.8080809@indt.org.br>
Date: Wed, 26 Mar 2008 16:10:02 -0400
From: Carlos Aguiar <carlos.aguiar@indt.org.br>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: ext Pierre Ossman <drzeus-list@drzeus.cx>
CC: Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 18/18] MMC: OMAP: Do not busy wait for end of command for
 ever
References: <47DAD39C.90405@indt.org.br> <20080324132631.1e0d2125@mjolnir.drzeus.cx>
In-Reply-To: <20080324132631.1e0d2125@mjolnir.drzeus.cx>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Mar 2008 20:12:44.0843 (UTC) FILETIME=[C0CD67B0:01C88F7D]
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
index b28ae3b..2468e2f 100644
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

