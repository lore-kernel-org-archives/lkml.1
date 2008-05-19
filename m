Return-Path: <linux-kernel-owner+w=401wt.eu-S1758940AbYESIJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758940AbYESIJR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 04:09:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757638AbYESIIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 04:08:43 -0400
Received: from fnoeppeil48.netpark.at ([217.175.205.176]:42277 "EHLO
	roarinelk.homelinux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758795AbYESIIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 04:08:39 -0400
Date: Mon, 19 May 2008 10:08:37 +0200
From: Manuel Lauss <mano@roarinelk.homelinux.net>
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org, drzeus@drzeus.cx,
       sshtylyov@ru.mvista.com
Subject: [PATCH 9/9] au1xmmc: Add back PB1200/DB1200 MMC activity LED
	support
Message-ID: <20080519080837.GJ21985@roarinelk.homelinux.net>
References: <20080519080339.GA21985@roarinelk.homelinux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080519080339.GA21985@roarinelk.homelinux.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 5747bd6933bb212ab83044fa79adf185d248513f Mon Sep 17 00:00:00 2001
From: Manuel Lauss <mlau@msc-ge.com>
Date: Sun, 18 May 2008 16:05:56 +0200
Subject: [PATCH] au1xmmc: Add back PB1200/DB1200 MMC activity LED support.

Add back PB1200/DB1200 MMC activity LED support just the way
it was done in the original driver source.

Signed-off-by: Manuel Lauss <mano@roarinelk.homelinux.net>
---
 arch/mips/au1000/pb1200/platform.c        |   15 +++++++++++++++
 drivers/mmc/host/au1xmmc.c                |   10 ++++++++++
 include/asm-mips/mach-au1x00/au1100_mmc.h |    1 +
 3 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/arch/mips/au1000/pb1200/platform.c b/arch/mips/au1000/pb1200/platform.c
index f329a38..f48723c 100644
--- a/arch/mips/au1000/pb1200/platform.c
+++ b/arch/mips/au1000/pb1200/platform.c
@@ -24,6 +24,8 @@
 #include <asm/mach-au1x00/au1xxx.h>
 #include <asm/mach-au1x00/au1100_mmc.h>
 
+static int mmc_activity = 0;
+
 static void pb1200mmc0_set_power(void *mmc_host, int state)
 {
 	if (state)
@@ -44,6 +46,17 @@ static int pb1200mmc0_card_inserted(void *mmc_host)
 	return (bcsr->sig_status & BCSR_INT_SD0INSERT) ? 1 : 0;
 }
 
+static void pb1200mmc_activity(int on)
+{
+	if (on) {
+		if (++mmc_activity == 1)
+			bcsr->disk_leds &= ~(1 << 8);
+	} else {
+		if (--mmc_activity == 0)
+			bcsr->disk_leds |= (1 << 8);
+	}
+}
+
 #ifndef CONFIG_MIPS_DB1200
 static void pb1200mmc1_set_power(void *mmc_host, int state)
 {
@@ -72,6 +85,7 @@ const struct au1xmmc_platform_data au1xmmc_platdata[2] = {
 		.card_inserted	= pb1200mmc0_card_inserted,
 		.card_readonly	= pb1200mmc0_card_readonly,
 		.cd_setup	= NULL,		/* use poll-timer in driver */
+		.activity	= pb1200mmc_activity,
 	},
 #ifndef CONFIG_MIPS_DB1200
 	[1] = {
@@ -79,6 +93,7 @@ const struct au1xmmc_platform_data au1xmmc_platdata[2] = {
 		.card_inserted	= pb1200mmc1_card_inserted,
 		.card_readonly	= pb1200mmc1_card_readonly,
 		.cd_setup	= NULL,		/* use poll-timer in driver */
+		.activity	= pb1200mmc_activity,
 	},
 #endif
 };
diff --git a/drivers/mmc/host/au1xmmc.c b/drivers/mmc/host/au1xmmc.c
index 0b30582..67df6fe 100644
--- a/drivers/mmc/host/au1xmmc.c
+++ b/drivers/mmc/host/au1xmmc.c
@@ -224,6 +224,12 @@ static int au1xmmc_card_readonly(struct mmc_host *mmc)
 	return ret;
 }
 
+static inline void au1xmmc_activity(struct au1xmmc_host *host, int on)
+{
+	if (host->platdata && host->platdata->activity)
+		host->platdata->activity(on);
+}
+
 static void au1xmmc_finish_request(struct au1xmmc_host *host)
 {
 	struct mmc_request *mrq = host->mrq;
@@ -240,6 +246,8 @@ static void au1xmmc_finish_request(struct au1xmmc_host *host)
 
 	host->status = HOST_S_IDLE;
 
+	au1xmmc_activity(host, 0);
+
 	mmc_request_done(host->mmc, mrq);
 }
 
@@ -696,6 +704,8 @@ static void au1xmmc_request(struct mmc_host *mmc, struct mmc_request *mrq)
 		return;
 	}
 
+	au1xmmc_activity(host, 1);
+
 	if (mrq->data) {
 		FLUSH_FIFO(host);
 		ret = au1xmmc_prepare_data(host, mrq->data);
diff --git a/include/asm-mips/mach-au1x00/au1100_mmc.h b/include/asm-mips/mach-au1x00/au1100_mmc.h
index c79dec1..6433b19 100644
--- a/include/asm-mips/mach-au1x00/au1100_mmc.h
+++ b/include/asm-mips/mach-au1x00/au1100_mmc.h
@@ -43,6 +43,7 @@ struct au1xmmc_platform_data {
 	int(*card_inserted)(void *mmc_host);
 	int(*card_readonly)(void *mmc_host);
 	void(*set_power)(void *mmc_host, int state);
+	void(*activity)(int on);
 };
 
 #define SD0_BASE	0xB0600000
-- 
1.5.5.1

