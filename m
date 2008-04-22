Return-Path: <linux-kernel-owner+w=401wt.eu-S933380AbYDVXAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933380AbYDVXAA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 19:00:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753417AbYDVW7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 18:59:52 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50585 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755857AbYDVW7w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 18:59:52 -0400
Message-ID: <480E6DE5.6010103@garzik.org>
Date: Tue, 22 Apr 2008 18:59:49 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, rmk@arm.linux.org.uk
Subject: Re: [git patch] free_irq() fixes
References: <20080422221733.GA16260@havoc.gtf.org> <alpine.LFD.1.10.0804221518520.2779@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0804221518520.2779@woody.linux-foundation.org>
Content-Type: multipart/mixed;
 boundary="------------000608080303050308070604"
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000608080303050308070604
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Linus Torvalds wrote:
> Quite frankly, I'd actually prefer to just reinstate "dev" to the irq 
> registration instead.
> 
> Why? Because that field is how we are able to track multiple interrupt 
> registrations that share an IRQ. Now, the "request_irq()" logic has a 
> special rule that actually tests that NULL is a valid cookie if the 
> IRQF_SHARED bit isn't set, but isn't it a nice thing to double-check 
> regardless?
[...]
> This, in contrast, *really* sucks as a cookie. In fact, it's useless. If 
> there are multiple tp3780i instances on the same irq, they will always 
> have the same cookie.

AFAICS that will never happen for mwave hardware.

Nonetheless, it's a good point that NULL fails for disambiguation, so I 
created the attached, which should do what you want.  I'll push it after 
the compiler gives it a green light (unless it needs further revisions)

(note, for mwave I couldn't use pSettings, since that might fail the 
ambiguity test)

	Jeff




--------------000608080303050308070604
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"

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
index 37fe80d..35e1723 100644
--- a/drivers/char/mwave/tp3780i.c
+++ b/drivers/char/mwave/tp3780i.c
@@ -97,16 +97,17 @@ static void EnableSRAM(THINKPAD_BD_DATA * pBDData)
 
 static irqreturn_t UartInterrupt(int irq, void *dev_id)
 {
-	int irqno = (int)(unsigned long) dev_id;
+	unsigned short *irqno = dev_id;
 
 	PRINTK_3(TRACE_TP3780I,
-		"tp3780i::UartInterrupt entry irq %x dev_id %p\n", irqno, dev_id);
+		"tp3780i::UartInterrupt entry irq %hx dev_id %p\n",
+		*irqno, dev_id);
 	return IRQ_HANDLED;
 }
 
 static irqreturn_t DspInterrupt(int irq, void *dev_id)
 {
-	int irqno = (int)(unsigned long) dev_id;
+	unsigned short *irqno = dev_id;
 
 	pMWAVE_DEVICE_DATA pDrvData = &mwave_s_mdd;
 	DSP_3780I_CONFIG_SETTINGS *pSettings = &pDrvData->rBDData.rDspSettings;
@@ -114,7 +115,8 @@ static irqreturn_t DspInterrupt(int irq, void *dev_id)
 	unsigned short usIPCSource = 0, usIsolationMask, usPCNum;
 
 	PRINTK_3(TRACE_TP3780I,
-		"tp3780i::DspInterrupt entry irq %x dev_id %p\n", irqno, dev_id);
+		"tp3780i::DspInterrupt entry irq %hx dev_id %p\n",
+		*irqno, dev_id);
 
 	if (dsp3780I_GetIPCSource(usDspBaseIO, &usIPCSource) == 0) {
 		PRINTK_2(TRACE_TP3780I,
@@ -274,7 +276,7 @@ int tp3780I_ReleaseResources(THINKPAD_BD_DATA * pBDData)
 	release_region(pSettings->usDspBaseIO & (~3), 16);
 
 	if (pSettings->bInterruptClaimed) {
-		free_irq(pSettings->usDspIrq, NULL);
+		free_irq(pSettings->usDspIrq, &pSettings->usDspIrq);
 		pSettings->bInterruptClaimed = FALSE;
 	}
 
@@ -366,15 +368,15 @@ int tp3780I_EnableDSP(THINKPAD_BD_DATA * pBDData)
 	pSettings->usChipletEnable = TP_CFG_ChipletEnable;
 
 	if (request_irq(pSettings->usUartIrq, &UartInterrupt, 0, "mwave_uart",
-			(void *)(unsigned long) pSettings->usUartIrq)) {
+			&pSettings->usUartIrq)) {
 		PRINTK_ERROR(KERN_ERR_MWAVE "tp3780i::tp3780I_EnableDSP: Error: Could not get UART IRQ %x\n", pSettings->usUartIrq);
 		goto exit_cleanup;
 	} else {		/* no conflict just release */
-		free_irq(pSettings->usUartIrq, NULL);
+		free_irq(pSettings->usUartIrq, &pSettings->usUartIrq);
 	}
 
 	if (request_irq(pSettings->usDspIrq, &DspInterrupt, 0, "mwave_3780i",
-			(void *)(unsigned long) pSettings->usDspIrq)) {
+			&pSettings->usDspIrq)) {
 		PRINTK_ERROR("tp3780i::tp3780I_EnableDSP: Error: Could not get 3780i IRQ %x\n", pSettings->usDspIrq);
 		goto exit_cleanup;
 	} else {
@@ -411,7 +413,7 @@ exit_cleanup:
 	if (bDSPPoweredUp)
 		smapi_set_DSP_power_state(FALSE);
 	if (bInterruptAllocated) {
-		free_irq(pSettings->usDspIrq, NULL);
+		free_irq(pSettings->usDspIrq, &pSettings->usDspIrq);
 		pSettings->bInterruptClaimed = FALSE;
 	}
 	return -EIO;
@@ -428,7 +430,7 @@ int tp3780I_DisableDSP(THINKPAD_BD_DATA * pBDData)
 	if (pBDData->bDSPEnabled) {
 		dsp3780I_DisableDSP(&pBDData->rDspSettings);
 		if (pSettings->bInterruptClaimed) {
-			free_irq(pSettings->usDspIrq, NULL);
+			free_irq(pSettings->usDspIrq, &pSettings->usDspIrq);
 			pSettings->bInterruptClaimed = FALSE;
 		}
 		smapi_set_DSP_power_state(FALSE);

--------------000608080303050308070604--
