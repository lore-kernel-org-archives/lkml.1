Return-Path: <linux-kernel-owner+w=401wt.eu-S1756400AbZEKOmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400AbZEKOmj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 10:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755430AbZEKOmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 10:42:06 -0400
Received: from mail37.messagelabs.com ([216.82.241.83]:64054 "EHLO
	mail37.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbZEKOmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 10:42:02 -0400
X-VirusChecked: Checked
X-Env-Sender: Luis.Galdos@digi.com
X-Msg-Ref: server-12.tower-37.messagelabs.com!1242052916!22589305!1
X-StarScan-Version: 6.0.0; banners=-,-,-
X-Originating-IP: [66.77.174.13]
Message-ID: <4A08392F.70108@digi.com>
Date: Mon, 11 May 2009 16:41:51 +0200
From: Luis Galdos <luis.galdos@digi.com>
User-Agent: Icedove 1.5.0.14eol (X11/20090105)
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
Subject: [LIBERTAS-SDIO]  Support for single transfer blocks?
Content-Type: text/plain; charset="ISO-8859-15"; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-8.0.0.1285-5.600.1016-16514.002
X-TM-AS-Result: No--15.621700-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I have one question concerning to the Libertas-driver: Does this driver works with 
SDIO-hosts that only support single transfer blocks? I ask cause I have seen two problems 
with a SDIO-port that doesn't support multiple blocks:

* The firmware installation successes only with a modification of the block size (see 
below patch)

* The transfer of Ethernet-frames works only if the "complete" frame is smaller than the 
block size of the SDIO-host. By larger packages, the SD8686 doesn't generate the expected 
IRQ (cause it expected a multiple transfer) and the driver detects a timeout.

Do you know something about this? Thanks in advance,


PS: Sorry for the possible wrong format of this email (my first one)


diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
index b54e2ea..f88a4da 100644
--- a/drivers/net/wireless/libertas/if_sdio.c
+++ b/drivers/net/wireless/libertas/if_sdio.c
@@ -33,6 +33,7 @@
  #include <linux/mmc/card.h>
  #include <linux/mmc/sdio_func.h>
  #include <linux/mmc/sdio_ids.h>
+#include <linux/mmc/host.h>

  #include "host.h"
  #include "decl.h"
@@ -507,6 +508,8 @@ static int if_sdio_prog_real(struct if_sdio_card *card)
         u32 chunk_size;
         const u8 *firmware;
         size_t size, req_size;
+       struct mmc_host *host;
+       int max_blksize = 0;

         lbs_deb_enter(LBS_DEB_SDIO);

@@ -524,7 +527,19 @@ static int if_sdio_prog_real(struct if_sdio_card *card)

         sdio_claim_host(card->func);

-       ret = sdio_set_block_size(card->func, 32);
+       /*
+        * If the host doesn't support multi-blocks, then use the the maximal block
+        * size for the transfers. Otherwise the firmware installation will fail.
+        */
+       host = card->func->card->host;
+       if (host->max_blk_count == 1) {
+               lbs_pr_info("Setting block size to %u\n", host->max_blk_size);
+               max_blksize = card->func->max_blksize;
+               card->func->max_blksize = host->max_blk_size;
+               ret = sdio_set_block_size(card->func, host->max_blk_size);
+       } else
+               ret = sdio_set_block_size(card->func, 32);
+
         if (ret)
                 goto release;

@@ -593,6 +608,10 @@ static int if_sdio_prog_real(struct if_sdio_card *card)

         ret = 0;

+        /* Restore the original block size if it was changed before */
+        if (max_blksize)
+                card->func->max_blksize = max_blksize;
+
         lbs_deb_sdio("waiting for firmware to boot...\n");

         /* wait for the firmware to boot */


-- 
Luis Galdos
