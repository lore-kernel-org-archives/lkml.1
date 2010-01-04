Return-Path: <linux-kernel-owner+w=401wt.eu-S1753946Ab0ADWBI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946Ab0ADWBI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 17:01:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753696Ab0ADWBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 17:01:05 -0500
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1070 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517Ab0ADWBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 17:01:01 -0500
Message-ID: <4B42648A.2040305@yahoo.es>
Date: Tue, 05 Jan 2010 05:58:34 +0800
From: Hein_Tibosch <hein_tibosch@yahoo.es>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Pierre Ossman <pierre@ossman.eu>
CC: Ben Nizette <bn@niasdigital.com>, Sascha Hauer <s.hauer@pengutronix.de>,
       Adrian Hunter <adrian.hunter@nokia.com>, linux-mmc@vger.kernel.org,
       linux-kernel@vger.kernel.org, Matt Fleming <matt@console-pimps.org>
Subject: Re: [PATCH v3] mmc: Make ID freq configurable
References: <1246492196.2980.17.camel@linux-51e8.site>	<20090702135849.21370282@hskinnemoen-d830>	<1246537056.2980.60.camel@linux-51e8.site>	<4B3E570C.2060602@yahoo.es>	<63809451-ED1D-487A-AE63-F72B23D136D8@niasdigital.com>	<4B3F019F.6010306@yahoo.es>	<49985427-DCB9-40E1-815B-43C812B41DE3@niasdigital.com>	<20100102130809.121b7e10@mjolnir.ossman.eu>	<AD8E15FA-A476-4275-A750-5EB587A93CEC@niasdigital.com> <20100103003804.66021fe9@mjolnir.ossman.eu>
In-Reply-To: <20100103003804.66021fe9@mjolnir.ossman.eu>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In my last mail the spaces in the patch were mistreated, sorry for that.

Below a patch which tries mmc-initialization using several frequencies
from an array 400, 300, 200 and 100.


Signed-off-by: Hein Tibosch <hein_tibosch@yahoo.es>

---
diff -Nurp a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -891,12 +891,7 @@ static void mmc_power_up(struct mmc_host
 	 */
 	mmc_delay(10);

-	if (host->f_min > 400000) {
-		pr_warning("%s: Minimum clock frequency too high for "
-				"identification mode\n", mmc_hostname(host));
-		host->ios.clock = host->f_min;
-	} else
-		host->ios.clock = 400000;
+	host->ios.clock = host->f_init;

 	host->ios.power_mode = MMC_POWER_ON;
 	mmc_set_ios(host);
@@ -1041,6 +1036,8 @@ void mmc_rescan(struct work_struct *work
 		container_of(work, struct mmc_host, detect.work);
 	u32 ocr;
 	int err;
+	int i;
+	unsigned freqs[] = { 400000, 300000, 200000, 100000 };

 	mmc_bus_get(host);

@@ -1070,46 +1067,55 @@ void mmc_rescan(struct work_struct *work
 	if (host->ops->get_cd && host->ops->get_cd(host) == 0)
 		goto out;

-	mmc_claim_host(host);
+	for (i = 0; i < ARRAY_SIZE(freqs); i++) {
+		mmc_claim_host(host);

-	mmc_power_up(host);
-	mmc_go_idle(host);
+		if (freqs[i] >= host->f_min)
+			host->f_init = freqs[i];
+		else if (i && freqs[i-1] <= host->f_min)
+			goto out;
+		else
+			host->f_init = host->f_min;

-	mmc_send_if_cond(host, host->ocr_avail);
+		printk ("mmc_rescan: trying %u Hz\n", host->f_init);
+		mmc_power_up(host);
+		mmc_go_idle(host);

-	/*
-	 * First we search for SDIO...
-	 */
-	err = mmc_send_io_op_cond(host, 0, &ocr);
-	if (!err) {
-		if (mmc_attach_sdio(host, ocr))
-			mmc_power_off(host);
-		goto out;
-	}
+		mmc_send_if_cond(host, host->ocr_avail);

-	/*
-	 * ...then normal SD...
-	 */
-	err = mmc_send_app_op_cond(host, 0, &ocr);
-	if (!err) {
-		if (mmc_attach_sd(host, ocr))
-			mmc_power_off(host);
-		goto out;
-	}
+		/*
+		 * First we search for SDIO...
+		 */
+		err = mmc_send_io_op_cond(host, 0, &ocr);
+		if (!err) {
+			if (mmc_attach_sdio(host, ocr))
+				mmc_power_off(host);
+			goto out;
+		}

-	/*
-	 * ...and finally MMC.
-	 */
-	err = mmc_send_op_cond(host, 0, &ocr);
-	if (!err) {
-		if (mmc_attach_mmc(host, ocr))
-			mmc_power_off(host);
-		goto out;
-	}
+		/*
+		 * ...then normal SD...
+		 */
+		err = mmc_send_app_op_cond(host, 0, &ocr);
+		if (!err) {
+			if (mmc_attach_sd(host, ocr))
+				mmc_power_off(host);
+			goto out;
+		}

-	mmc_release_host(host);
-	mmc_power_off(host);
+		/*
+		 * ...and finally MMC.
+		 */
+		err = mmc_send_op_cond(host, 0, &ocr);
+		if (!err) {
+			if (mmc_attach_mmc(host, ocr))
+				mmc_power_off(host);
+			goto out;
+		}

+		mmc_release_host(host);
+		mmc_power_off(host);
+	}
 out:
 	if (host->caps & MMC_CAP_NEEDS_POLL)
 		mmc_schedule_delayed_work(&host->detect, HZ);
diff -Nurp a/include/linux/mmc/host.h b/include/linux/mmc/host.h
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -119,6 +119,7 @@ struct mmc_host {
 	const struct mmc_host_ops *ops;
 	unsigned int		f_min;
 	unsigned int		f_max;
+	unsigned int		f_init;
 	u32			ocr_avail;

 #define MMC_VDD_165_195		0x00000080	/* VDD voltage 1.65 - 1.95 */


