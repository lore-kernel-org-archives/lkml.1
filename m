Return-Path: <linux-kernel-owner+w=401wt.eu-S1751994Ab0ABWXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994Ab0ABWXk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 17:23:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212Ab0ABWXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 17:23:39 -0500
Received: from outbound.icp-qv1-irony-out5.iinet.net.au ([203.59.1.105]:35138
	"EHLO outbound.icp-qv1-irony-out5.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751064Ab0ABWXj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 17:23:39 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AusAANBWP0t8qNTn/2dsb2JhbAAI0U6EMQQ
X-IronPort-AV: E=Sophos;i="4.47,490,1257091200"; 
   d="scan'208";a="87589191"
Subject: [PATCH v3] mmc: Make ID freq configurable
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Ben Nizette <bn@niasdigital.com>
In-Reply-To: <20100102130809.121b7e10@mjolnir.ossman.eu>
Date: Sun, 3 Jan 2010 09:23:30 +1100
Cc: Hein_Tibosch <hein_tibosch@yahoo.es>,
       Sascha Hauer <s.hauer@pengutronix.de>,
       Adrian Hunter <adrian.hunter@nokia.com>, linux-mmc@vger.kernel.org,
       linux-kernel@vger.kernel.org, Matt Fleming <matt@console-pimps.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <AD8E15FA-A476-4275-A750-5EB587A93CEC@niasdigital.com>
References: <1246492196.2980.17.camel@linux-51e8.site> <20090702135849.21370282@hskinnemoen-d830> <1246537056.2980.60.camel@linux-51e8.site> <4B3E570C.2060602@yahoo.es> <63809451-ED1D-487A-AE63-F72B23D136D8@niasdigital.com> <4B3F019F.6010306@yahoo.es> <49985427-DCB9-40E1-815B-43C812B41DE3@niasdigital.com> <20100102130809.121b7e10@mjolnir.ossman.eu>
To: Pierre Ossman <pierre@ossman.eu>
X-Mailer: Apple Mail (2.1077)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 02/01/2010, at 11:08 PM, Pierre Ossman wrote:

> On Sat, 2 Jan 2010 20:07:01 +1100
> Ben Nizette <bn@niasdigital.com> wrote:
> 
>> 
>> Pierre, thoughts?  All my cards were borderline spec but Hein's got a mainstream, common card which seems to completely ignore the spec.  Can we just take the few-hundred-uS hit and allow initialization down at the bottom end, say 100kHz?
>> 
> 
> Broken cards seem to be all over the spectrum, so I wouldn't be
> suprised if you find ones that break if you go too low as well.

Yea good point, though given there might not even be a One Freq to Rule Them All, how about:

---8<---

From: Ben Nizette <bn@niasdigital.com>
Subject: [PATCH v3] mmc: Make ID freq configurable

While the SD spec specifies a range of frequencies for the ID phase from 100-400kHz, not all cards play by the rules.  This patch adds a Kconfig option to allow the user to tweak this to their card/host config, though the default of 250kHz should be fine for all spec-abiding cards and most others besides.

Signed-off-by: Ben Nizette <bn@niasdigital.com>

---
diff --git a/drivers/mmc/core/Kconfig b/drivers/mmc/core/Kconfig
index ab37a6d..a8e5003 100644
--- a/drivers/mmc/core/Kconfig
+++ b/drivers/mmc/core/Kconfig
@@ -14,3 +14,15 @@ config MMC_UNSAFE_RESUME
          This option is usually just for embedded systems which use
          a MMC/SD card for rootfs. Most people should say N here.
 
+config MMC_ID_FREQ
+       int "SD/MMC Card initialisation frequency (Hz)"
+       default 250000
+       help
+         The SD card specification allows for initialisation
+         frequencies from 100-400kHz however some broken cards are
+         known not to work across this whole range.
+
+         If you're having problems with a particular card not being
+         detected, you may try adjusting this frequency up or down
+         but for widest compatibility just leave it default.
+
diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 7dab2e5..2eab68f 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -891,12 +891,17 @@ static void mmc_power_up(struct mmc_host *host)
         */
        mmc_delay(10);
 
-       if (host->f_min > 400000) {
-               pr_warning("%s: Minimum clock frequency too high for "
-                               "identification mode\n", mmc_hostname(host));
+       /*
+        * CONFIG_MMC_ID_FREQ defaults to 250kHz which should be fine
+        * for most card/host combos.
+        */
+       if (host->f_min > CONFIG_MMC_ID_FREQ) {
+               pr_warning("%s: The host cannot reach the requested ID clock "
+                               "rate, identification may fail\n",
+                               mmc_hostname(host));
                host->ios.clock = host->f_min;
        } else
-               host->ios.clock = 400000;
+               host->ios.clock = CONFIG_MMC_ID_FREQ;
 
        host->ios.power_mode = MMC_POWER_ON;
        mmc_set_ios(host);

