Return-Path: <linux-kernel-owner+w=401wt.eu-S1753353AbZGANip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbZGANip (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 09:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750888AbZGANii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 09:38:38 -0400
Received: from co203.xi-lite.net ([149.6.83.203]:57188 "EHLO co203.xi-lite.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782AbZGANii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 09:38:38 -0400
X-Greylist: delayed 1359 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Jul 2009 09:38:38 EDT
Message-ID: <4A4B6184.7000903@parrot.com>
Date: Wed, 1 Jul 2009 15:15:48 +0200
From: Matthieu CASTET <matthieu.castet@parrot.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: <sdhci-devel@lists.ossman.eu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       <pierre@ossman.eu>
Subject: sdhci can turn off irq up to 200 ms
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

sdhci code got tasklets (sdhci_tasklet_card and sdhci_tasklet_finish),
that does :
{
spin_lock_irqsave

if (cond) {
sdhci_reset
sdhci_reset
}

spin_unlock_irqrestore
}

The problem is that sdhci_reset [1] does busy pooling on a register up
to a timeout of 100 ms.
That's not low latency friendly.

On our system, we saw that sdhci_reset take 1 ms. That should be because
we enter in mdelay, even if the hardware clears the bit faster.
I wonder why there is an mdelay(1). Using cpu_relax and
time_is_after_jiffies should make sdhci_reset faster.


Matthieu

[1]
static void sdhci_reset(struct sdhci_host *host, u8 mask)
{
    unsigned long timeout;
    u32 uninitialized_var(ier);
[...]
    sdhci_writeb(host, mask, SDHCI_SOFTWARE_RESET);

    if (mask & SDHCI_RESET_ALL)
        host->clock = 0;

    /* Wait max 100 ms */
    timeout = 100;

    /* hw clears the bit when it's done */
    while (sdhci_readb(host, SDHCI_SOFTWARE_RESET) & mask) {
        if (timeout == 0) {
            printk(KERN_ERR "%s: Reset 0x%x never completed.\n",
                mmc_hostname(host->mmc), (int)mask);
            sdhci_dumpregs(host);
            return;
        }
        timeout--;
        mdelay(1);
    }
[...]
}
