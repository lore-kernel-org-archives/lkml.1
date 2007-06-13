Return-Path: <linux-kernel-owner+w=401wt.eu-S1759832AbXFMRXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759832AbXFMRXb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 13:23:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759180AbXFMRXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 13:23:22 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:44497 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759112AbXFMRXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 13:23:21 -0400
Message-ID: <4670285C.6070505@drzeus.cx>
Date: Wed, 13 Jun 2007 19:24:44 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] MMC updates
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

        git://git.kernel.org/pub/scm/linux/kernel/git/drzeus/mmc.git for-linus

to receive the following updates:

 drivers/mmc/core/sd.c   |   15 +++++++++++++++
 drivers/mmc/host/omap.c |   24 +++---------------------
 2 files changed, 18 insertions(+), 21 deletions(-)

Pierre Ossman (1):
      mmc: get back read-only switch function

Ragner Magalhaes (1):
      mmc-omap: fix sd response type 6 vs. 1

diff --git a/drivers/mmc/core/sd.c b/drivers/mmc/core/sd.c
index 41bfb5d..918477c 100644
--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -427,6 +427,21 @@ static int mmc_sd_init_card(struct mmc_host *host, u32 ocr,
                mmc_set_bus_width(host, MMC_BUS_WIDTH_4);
        }

+       /*
+        * Check if read-only switch is active.
+        */
+       if (!oldcard) {
+               if (!host->ops->get_ro) {
+                       printk(KERN_WARNING "%s: host does not "
+                               "support reading read-only "
+                               "switch. assuming write-enable.\n",
+                               mmc_hostname(host));
+               } else {
+                       if (host->ops->get_ro(host))
+                               mmc_card_set_readonly(card);
+               }
+       }
+
        if (!oldcard)
                host->card = card;

diff --git a/drivers/mmc/host/omap.c b/drivers/mmc/host/omap.c
index 1914e65..b0824a3 100644
--- a/drivers/mmc/host/omap.c
+++ b/drivers/mmc/host/omap.c
@@ -522,28 +522,10 @@ static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
                }

                if (status & OMAP_MMC_STAT_CARD_ERR) {
-                       if (host->cmd && host->cmd->opcode ==
MMC_STOP_TRANSMISSION) {
-                               u32 response = OMAP_MMC_READ(host, RSP6)
-                                       | (OMAP_MMC_READ(host, RSP7) << 16);
-                               /* STOP sometimes sets must-ignore bits */
-                               if (!(response & (R1_CC_ERROR
-                                                               | R1_ILLEGAL_COMMAND
-                                                               |
R1_COM_CRC_ERROR))) {
-                                       end_command = 1;
-                                       continue;
-                               }
-                       }
-
-                       dev_dbg(mmc_dev(host->mmc), "card status error (CMD%d)\n",
+                       dev_dbg(mmc_dev(host->mmc),
+                               "ignoring card status error (CMD%d)\n",
                                host->cmd->opcode);
-                       if (host->cmd) {
-                               host->cmd->error = MMC_ERR_FAILED;
-                               end_command = 1;
-                       }
-                       if (host->data) {
-                               host->data->error = MMC_ERR_FAILED;
-                               transfer_error = 1;
-                       }
+                       end_command = 1;
                }

                /*

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
