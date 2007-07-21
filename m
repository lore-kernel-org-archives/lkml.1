Return-Path: <linux-kernel-owner+w=401wt.eu-S938877AbXGUAgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938877AbXGUAgh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 20:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755824AbXGUAga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 20:36:30 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:55847 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755005AbXGUAga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 20:36:30 -0400
Date: Sat, 21 Jul 2007 02:36:10 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] MMC updates
Message-ID: <20070721023610.661bd9a3@poseidon.drzeus.cx>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

        git://git.kernel.org/pub/scm/linux/kernel/git/drzeus/mmc.git for-linus

to receive the following updates:

 MAINTAINERS                 |    7 ++++++-
 drivers/mmc/host/at91_mci.c |   13 ++++++++++++-
 drivers/mmc/host/sdhci.c    |    2 ++
 drivers/mmc/host/sdhci.h    |    1 +
 4 files changed, 21 insertions(+), 2 deletions(-)

Marc Pignat (1):
      mmc: at91_mci: wakeup on card insertion (or removal)

Pierre Ossman (2):
      mmc: add maintainer for at91
      sdhci: make sure to clear the error interrupt

diff --git a/MAINTAINERS b/MAINTAINERS
index fbe0dca..c9fab2b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -645,7 +645,12 @@ W: http://linux-atm.sourceforge.net
 S:     Maintained
 
 ATMEL AT91 MCI DRIVER
-S:     Orphan
+P:     Nicolas Ferre
+M:     nicolas.ferre@rfo.atmel.com
+L:     linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+W:     http://www.atmel.com/products/AT91/
+W:     http://www.at91.com/
+S:     Maintained
 
 ATMEL MACB ETHERNET DRIVER
 P:     Haavard Skinnemoen
diff --git a/drivers/mmc/host/at91_mci.c b/drivers/mmc/host/at91_mci.c
index 28c8818..15aab37 100644
--- a/drivers/mmc/host/at91_mci.c
+++ b/drivers/mmc/host/at91_mci.c
@@ -903,8 +903,10 @@ static int __init at91_mci_probe(struct platform_device *pdev)
        /*
         * Add host to MMC layer
         */
-       if (host->board->det_pin)
+       if (host->board->det_pin) {
                host->present = !at91_get_gpio_value(host->board->det_pin);
+               device_init_wakeup(&pdev->dev, 1);
+       }
        else
                host->present = -1;
 
@@ -940,6 +942,7 @@ static int __exit at91_mci_remove(struct platform_device *pdev)
        host = mmc_priv(mmc);
 
        if (host->present != -1) {
+               device_init_wakeup(&pdev->dev, 0);
                free_irq(host->board->det_pin, host);
                cancel_delayed_work(&host->mmc->detect);
        }
@@ -966,8 +969,12 @@ static int __exit at91_mci_remove(struct platform_device *pdev)
 static int at91_mci_suspend(struct platform_device *pdev, pm_message_t state)
 {
        struct mmc_host *mmc = platform_get_drvdata(pdev);
+       struct at91mci_host *host = mmc_priv(mmc);
        int ret = 0;
 
+       if (device_may_wakeup(&pdev->dev))
+               enable_irq_wake(host->board->det_pin);
+
        if (mmc)
                ret = mmc_suspend_host(mmc, state);
 
@@ -977,8 +984,12 @@ static int at91_mci_suspend(struct platform_device *pdev, pm_message_t state)
 static int at91_mci_resume(struct platform_device *pdev)
 {
        struct mmc_host *mmc = platform_get_drvdata(pdev);
+       struct at91mci_host *host = mmc_priv(mmc);
        int ret = 0;
 
+       if (device_may_wakeup(&pdev->dev))
+               disable_irq_wake(host->board->det_pin);
+
        if (mmc)
                ret = mmc_resume_host(mmc);
 
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 10d15c3..4a24db0 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1024,6 +1024,8 @@ static irqreturn_t sdhci_irq(int irq, void *dev_id)
 
        intmask &= ~(SDHCI_INT_CMD_MASK | SDHCI_INT_DATA_MASK);
 
+       intmask &= ~SDHCI_INT_ERROR;
+
        if (intmask & SDHCI_INT_BUS_POWER) {
                printk(KERN_ERR "%s: Card is consuming too much power!\n",
                        mmc_hostname(host->mmc));
diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
index 7400f4b..a6c8704 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -107,6 +107,7 @@
 #define  SDHCI_INT_CARD_INSERT 0x00000040
 #define  SDHCI_INT_CARD_REMOVE 0x00000080
 #define  SDHCI_INT_CARD_INT    0x00000100
+#define  SDHCI_INT_ERROR       0x00008000
 #define  SDHCI_INT_TIMEOUT     0x00010000
 #define  SDHCI_INT_CRC         0x00020000
 #define  SDHCI_INT_END_BIT     0x00040000


-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
