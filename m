Return-Path: <linux-kernel-owner+w=401wt.eu-S1757464AbZLFUAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464AbZLFUAA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 15:00:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752278AbZLFT77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 14:59:59 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37159 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbZLFT76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 14:59:58 -0500
Date: Sun, 6 Dec 2009 20:59:54 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>,
       Daniel Walker <dwalker@codeaurora.org>,
       Iliyan Malchev <malchev@google.com>
Subject: HTC Dream: mmc compilation fixes
Message-ID: <20091206195953.GA26863@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing include for msm_sdcc compilation, and remove pwrsink
support that is not mainline, yet.

Signed-off-by: Pavel Machek <pavel@ucw.cz>


diff --git a/arch/arm/mach-msm/include/mach/mmc.h b/arch/arm/mach-msm/include/mach/mmc.h
new file mode 100644
index 0000000..8948dec
--- /dev/null
+++ b/arch/arm/mach-msm/include/mach/mmc.h
@@ -0,0 +1,26 @@
+/*
+ *  arch/arm/include/asm/mach/mmc.h
+ */
+#ifndef ASMARM_MACH_MMC_H
+#define ASMARM_MACH_MMC_H
+
+#include <linux/mmc/host.h>
+#include <linux/mmc/card.h>
+#include <linux/mmc/sdio_func.h>
+
+struct embedded_sdio_data {
+        struct sdio_cis cis;
+        struct sdio_cccr cccr;
+        struct sdio_embedded_func *funcs;
+        int num_funcs;
+};
+
+struct mmc_platform_data {
+	unsigned int ocr_mask;			/* available voltages */
+	u32 (*translate_vdd)(struct device *, unsigned int);
+	unsigned int (*status)(struct device *);
+	struct embedded_sdio_data *embedded_sdio;
+	int (*register_status_notify)(void (*callback)(int card_present, void *dev_id), void *dev_id);
+};
+
+#endif
diff --git a/drivers/mmc/host/msm_sdcc.c b/drivers/mmc/host/msm_sdcc.c
index dba4600..b31946e 100644
--- a/drivers/mmc/host/msm_sdcc.c
+++ b/drivers/mmc/host/msm_sdcc.c
@@ -38,10 +38,9 @@
 #include <asm/div64.h>
 #include <asm/sizes.h>
 
-#include <asm/mach/mmc.h>
+#include <mach/mmc.h>
 #include <mach/msm_iomap.h>
 #include <mach/dma.h>
-#include <mach/htc_pwrsink.h>
 
 #include "msm_sdcc.h"
 
@@ -775,13 +774,11 @@ msmsdcc_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 
 	switch (ios->power_mode) {
 	case MMC_POWER_OFF:
-		htc_pwrsink_set(PWRSINK_SDCARD, 0);
 		break;
 	case MMC_POWER_UP:
 		pwr |= MCI_PWR_UP;
 		break;
 	case MMC_POWER_ON:
-		htc_pwrsink_set(PWRSINK_SDCARD, 100);
 		pwr |= MCI_PWR_ON;
 		break;
 	}

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
