Return-Path: <linux-kernel-owner+w=401wt.eu-S1758008AbYDXMlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758008AbYDXMlh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 08:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752854AbYDXMl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 08:41:28 -0400
Received: from havoc.gtf.org ([69.61.125.42]:58190 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752848AbYDXMl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 08:41:27 -0400
Date: Thu, 24 Apr 2008 08:41:26 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, rmk@arm.linux.org.uk
Subject: [git patch] fixes for irq cleanups
Message-ID: <20080424124126.GA22206@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'irq-fixes-2' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git irq-fixes-2

to receive the following updates:

 arch/arm/mach-integrator/time.c |    5 ++++-
 drivers/char/mwave/tp3780i.c    |   14 ++++----------
 2 files changed, 8 insertions(+), 11 deletions(-)

Jeff Garzik (1):
    arm/mach-integrator/time.c, mwave: revert portions of recent irq cleanups
    
    The recent irq cleanups for arch/arm/mach-integrator/time.c and
    drivers/char/mwave/tp3780i.c changed the request_irq() dev_id
    parameter, but neglected to change the matching free_irq() parameter,
    thus creating a bug upon irq de-registration.
    
    Given that the impetus for the changes is not yet accepted upstream,
    it is best to revert the irq cleanups.
    
    Mostly.  A comment is added to time.c to reduce future confusion,
    of type that led to my time.c cleanup in the first place.
    
    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>


diff --git a/arch/arm/mach-integrator/time.c b/arch/arm/mach-integrator/time.c
index 5235f64..8508a0d 100644
--- a/arch/arm/mach-integrator/time.c
+++ b/arch/arm/mach-integrator/time.c
@@ -124,8 +124,11 @@ static int rtc_probe(struct amba_device *dev, void *id)
 
 	xtime.tv_sec = __raw_readl(rtc_base + RTC_DR);
 
+	/* note that 'dev' is merely used for irq disambiguation;
+	 * it is not actually referenced in the irq handler
+	 */
 	ret = request_irq(dev->irq[0], arm_rtc_interrupt, IRQF_DISABLED,
-			  "rtc-pl030", NULL);
+			  "rtc-pl030", dev);
 	if (ret)
 		goto map_out;
 
diff --git a/drivers/char/mwave/tp3780i.c b/drivers/char/mwave/tp3780i.c
index 37fe80d..f282976 100644
--- a/drivers/char/mwave/tp3780i.c
+++ b/drivers/char/mwave/tp3780i.c
@@ -97,24 +97,20 @@ static void EnableSRAM(THINKPAD_BD_DATA * pBDData)
 
 static irqreturn_t UartInterrupt(int irq, void *dev_id)
 {
-	int irqno = (int)(unsigned long) dev_id;
-
 	PRINTK_3(TRACE_TP3780I,
-		"tp3780i::UartInterrupt entry irq %x dev_id %p\n", irqno, dev_id);
+		"tp3780i::UartInterrupt entry irq %x dev_id %p\n", irq, dev_id);
 	return IRQ_HANDLED;
 }
 
 static irqreturn_t DspInterrupt(int irq, void *dev_id)
 {
-	int irqno = (int)(unsigned long) dev_id;
-
 	pMWAVE_DEVICE_DATA pDrvData = &mwave_s_mdd;
 	DSP_3780I_CONFIG_SETTINGS *pSettings = &pDrvData->rBDData.rDspSettings;
 	unsigned short usDspBaseIO = pSettings->usDspBaseIO;
 	unsigned short usIPCSource = 0, usIsolationMask, usPCNum;
 
 	PRINTK_3(TRACE_TP3780I,
-		"tp3780i::DspInterrupt entry irq %x dev_id %p\n", irqno, dev_id);
+		"tp3780i::DspInterrupt entry irq %x dev_id %p\n", irq, dev_id);
 
 	if (dsp3780I_GetIPCSource(usDspBaseIO, &usIPCSource) == 0) {
 		PRINTK_2(TRACE_TP3780I,
@@ -365,16 +361,14 @@ int tp3780I_EnableDSP(THINKPAD_BD_DATA * pBDData)
 	pSettings->bPllBypass = TP_CFG_PllBypass;
 	pSettings->usChipletEnable = TP_CFG_ChipletEnable;
 
-	if (request_irq(pSettings->usUartIrq, &UartInterrupt, 0, "mwave_uart",
-			(void *)(unsigned long) pSettings->usUartIrq)) {
+	if (request_irq(pSettings->usUartIrq, &UartInterrupt, 0, "mwave_uart", NULL)) {
 		PRINTK_ERROR(KERN_ERR_MWAVE "tp3780i::tp3780I_EnableDSP: Error: Could not get UART IRQ %x\n", pSettings->usUartIrq);
 		goto exit_cleanup;
 	} else {		/* no conflict just release */
 		free_irq(pSettings->usUartIrq, NULL);
 	}
 
-	if (request_irq(pSettings->usDspIrq, &DspInterrupt, 0, "mwave_3780i",
-			(void *)(unsigned long) pSettings->usDspIrq)) {
+	if (request_irq(pSettings->usDspIrq, &DspInterrupt, 0, "mwave_3780i", NULL)) {
 		PRINTK_ERROR("tp3780i::tp3780I_EnableDSP: Error: Could not get 3780i IRQ %x\n", pSettings->usDspIrq);
 		goto exit_cleanup;
 	} else {
