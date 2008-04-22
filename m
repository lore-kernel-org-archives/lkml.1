Return-Path: <linux-kernel-owner+w=401wt.eu-S1762957AbYDVWRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762957AbYDVWRp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 18:17:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755309AbYDVWRh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 18:17:37 -0400
Received: from havoc.gtf.org ([69.61.125.42]:40155 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753343AbYDVWRg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 18:17:36 -0400
Date: Tue, 22 Apr 2008 18:17:33 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, rmk@arm.linux.org.uk
Subject: [git patch] free_irq() fixes
Message-ID: <20080422221733.GA16260@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'irq-fixes' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git irq-fixes

to receive the following updates:

 arch/arm/mach-integrator/time.c |    4 ++--
 drivers/char/mwave/tp3780i.c    |   13 +++++++++----
 2 files changed, 11 insertions(+), 6 deletions(-)

Jeff Garzik (1):
      arm/mach-integrator, char/mwave: fix request_irq/free_irq mismatch

diff --git a/arch/arm/mach-integrator/time.c b/arch/arm/mach-integrator/time.c
index 5235f64..28726ee 100644
--- a/arch/arm/mach-integrator/time.c
+++ b/arch/arm/mach-integrator/time.c
@@ -137,7 +137,7 @@ static int rtc_probe(struct amba_device *dev, void *id)
 	return 0;
 
  irq_out:
-	free_irq(dev->irq[0], dev);
+	free_irq(dev->irq[0], NULL);
  map_out:
 	iounmap(rtc_base);
 	rtc_base = NULL;
@@ -153,7 +153,7 @@ static int rtc_remove(struct amba_device *dev)
 
 	writel(0, rtc_base + RTC_CR);
 
-	free_irq(dev->irq[0], dev);
+	free_irq(dev->irq[0], NULL);
 	unregister_rtc(&rtc_ops);
 
 	iounmap(rtc_base);
diff --git a/drivers/char/mwave/tp3780i.c b/drivers/char/mwave/tp3780i.c
index 37fe80d..5681c01 100644
--- a/drivers/char/mwave/tp3780i.c
+++ b/drivers/char/mwave/tp3780i.c
@@ -274,7 +274,8 @@ int tp3780I_ReleaseResources(THINKPAD_BD_DATA * pBDData)
 	release_region(pSettings->usDspBaseIO & (~3), 16);
 
 	if (pSettings->bInterruptClaimed) {
-		free_irq(pSettings->usDspIrq, NULL);
+		free_irq(pSettings->usDspIrq,
+			 (void *)(unsigned long) pSettings->usDspIrq);
 		pSettings->bInterruptClaimed = FALSE;
 	}
 
@@ -365,12 +366,14 @@ int tp3780I_EnableDSP(THINKPAD_BD_DATA * pBDData)
 	pSettings->bPllBypass = TP_CFG_PllBypass;
 	pSettings->usChipletEnable = TP_CFG_ChipletEnable;
 
+	/* FIXME: this is a racy way to verify irq conflict does not exist */
 	if (request_irq(pSettings->usUartIrq, &UartInterrupt, 0, "mwave_uart",
 			(void *)(unsigned long) pSettings->usUartIrq)) {
 		PRINTK_ERROR(KERN_ERR_MWAVE "tp3780i::tp3780I_EnableDSP: Error: Could not get UART IRQ %x\n", pSettings->usUartIrq);
 		goto exit_cleanup;
 	} else {		/* no conflict just release */
-		free_irq(pSettings->usUartIrq, NULL);
+		free_irq(pSettings->usUartIrq,
+			 (void *)(unsigned long) pSettings->usUartIrq);
 	}
 
 	if (request_irq(pSettings->usDspIrq, &DspInterrupt, 0, "mwave_3780i",
@@ -411,7 +414,8 @@ exit_cleanup:
 	if (bDSPPoweredUp)
 		smapi_set_DSP_power_state(FALSE);
 	if (bInterruptAllocated) {
-		free_irq(pSettings->usDspIrq, NULL);
+		free_irq(pSettings->usDspIrq,
+			 (void *)(unsigned long) pSettings->usDspIrq);
 		pSettings->bInterruptClaimed = FALSE;
 	}
 	return -EIO;
@@ -428,7 +432,8 @@ int tp3780I_DisableDSP(THINKPAD_BD_DATA * pBDData)
 	if (pBDData->bDSPEnabled) {
 		dsp3780I_DisableDSP(&pBDData->rDspSettings);
 		if (pSettings->bInterruptClaimed) {
-			free_irq(pSettings->usDspIrq, NULL);
+			free_irq(pSettings->usDspIrq,
+				 (void *)(unsigned long) pSettings->usDspIrq);
 			pSettings->bInterruptClaimed = FALSE;
 		}
 		smapi_set_DSP_power_state(FALSE);
