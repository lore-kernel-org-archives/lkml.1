Return-Path: <linux-kernel-owner+w=401wt.eu-S1759264AbZGIK2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759264AbZGIK2Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 06:28:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756779AbZGIK2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 06:28:15 -0400
Received: from co203.xi-lite.net ([149.6.83.203]:53517 "EHLO co203.xi-lite.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752033AbZGIK2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 06:28:14 -0400
Message-ID: <4A55C631.7030103@parrot.com>
Date: Thu, 9 Jul 2009 12:28:01 +0200
From: Matthieu CASTET <matthieu.castet@parrot.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: <pierre@ossman.eu>
CC: <sdhci-devel@lists.ossman.eu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: sdhci can turn off irq up to 200 ms
References: <4A4B6184.7000903@parrot.com>
In-Reply-To: <4A4B6184.7000903@parrot.com>
X-Enigmail-Version: 0.95.0
Content-Type: multipart/mixed;
	boundary="------------080408050900030800000604"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------080408050900030800000604
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit

Matthieu CASTET a écrit :
> Hi,
> 
> sdhci code got tasklets (sdhci_tasklet_card and sdhci_tasklet_finish),
> that does :
> {
> spin_lock_irqsave
> 
> if (cond) {
> sdhci_reset
> sdhci_reset
> }
> 
> spin_unlock_irqrestore
> }
> 
> The problem is that sdhci_reset [1] does busy pooling on a register up
> to a timeout of 100 ms.
> That's not low latency friendly.
> 
> On our system, we saw that sdhci_reset take 1 ms. That should be because
> we enter in mdelay, even if the hardware clears the bit faster.
> I wonder why there is an mdelay(1). Using cpu_relax and
> time_is_after_jiffies should make sdhci_reset faster.
> 
In case somebody cares, here a patch that reduce on our hardware
sdhci_reset from 1 ms to 30 us.


Matthieu

--------------080408050900030800000604
Content-Type: text/x-diff; name="sdhci.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="sdhci.diff"

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 6779b4e..3e199b6 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -156,18 +156,17 @@ static void sdhci_reset(struct sdhci_host *host, u8 mask)
 		host->clock = 0;
 
 	/* Wait max 100 ms */
-	timeout = 100;
+	timeout = jiffies + msecs_to_jiffies(100);
 
 	/* hw clears the bit when it's done */
 	while (sdhci_readb(host, SDHCI_SOFTWARE_RESET) & mask) {
-		if (timeout == 0) {
+		if (time_is_before_jiffies(timeout)) {
 			printk(KERN_ERR "%s: Reset 0x%x never completed.\n",
 				mmc_hostname(host->mmc), (int)mask);
 			sdhci_dumpregs(host);
 			return;
 		}
-		timeout--;
-		mdelay(1);
+		cpu_relax();
 	}
 
 	if (host->quirks & SDHCI_QUIRK_RESTORE_IRQS_AFTER_RESET)

--------------080408050900030800000604--
