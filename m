Return-Path: <linux-kernel-owner+w=401wt.eu-S1753751Ab0ADVI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751Ab0ADVI0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 16:08:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752823Ab0ADVIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 16:08:25 -0500
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1572 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751Ab0ADVIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 16:08:24 -0500
Message-ID: <4B425889.8010703@yahoo.es>
Date: Tue, 05 Jan 2010 05:07:21 +0800
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
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3-1-2010 07:38, Pierre Ossman wrote:
>
> <cut>
> We all use the same pool of cards so we
> should all be using the same init sequence. If there isn't a single
> frequency where all cards will work, then we'll have to make something
> more advanced where the kernel will try the init several times with
> different clocking.

On 4-1-2010 20:15, Sascha Hauer wrote:
> The problem was that in some setups the mxcmmc driver allows frequencies
> as low as a few Hz and the card initialization took ages. Increasing the
> frequency to 400kHz seemed sensible since it's the value the spec
> describes. 50kHz should be fine as well.
>

I tried out several main-stream sd-cards and with the Atmel (AP7) controller
they all initialize with F between 138 (=f_min) and 280 Khz.

Below a patch which tries mmc-initialization using several frequencies
from an array 400, 300, 200 and 100. When it comes to 200 Khz, it works.
The two failed attempts lasted about 10 ms together.

It looks like a hell-of-a-patch but that's because the indentation changes.

Note that the new mmc_host member f_init will be used later in power_restore
and resume. As power_up always comes first, it should have a descend value
by then.

But I still wonder, why not just keep using Sascha's patch, changing 400000
to 50000? Has anyone ever had problems with mmc-init on 50 Khz?


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





