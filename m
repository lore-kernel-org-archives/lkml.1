Return-Path: <linux-kernel-owner+w=401wt.eu-S1757410AbZBXNCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410AbZBXNCB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 08:02:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754961AbZBXNBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 08:01:50 -0500
Received: from smtp.nokia.com ([192.100.122.233]:34145 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754850AbZBXNBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 08:01:49 -0500
Message-ID: <49A3EF96.3090603@nokia.com>
Date: Tue, 24 Feb 2009 15:01:10 +0200
From: Adrian Hunter <ext-adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: Kyungmin Park <kyungmin.park@samsung.com>, Kim Kyuwon <chammoru@gmail.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "drzeus-mmc@drzeus.cx" <drzeus-mmc@drzeus.cx>,
       =?x-windows-949?Q?=B1=E8=B1=D4?= =?x-windows-949?Q?=BF=F8?= 
	<q1.kim@samsung.com>,
       "Lavinen Jarkko (Nokia-D/Helsinki)" <jarkko.lavinen@nokia.com>
Subject: Re: [PATCH] OMAP: HSMMC: Initialize hsmmc controller registers when
 resuming
References: <4d34a0a70902200400s252f48ddvfd6e0d83e91fa291@mail.gmail.com> <9c9fda240902230426s2003d208xebeb6630c61b3bec@mail.gmail.com> <49A2A8ED.20208@nokia.com> <200902231023.49653.david-b@pacbell.net>
In-Reply-To: <200902231023.49653.david-b@pacbell.net>
Content-Type: text/plain; charset=ks_c_5601-1987; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Feb 2009 13:01:29.0788 (UTC) FILETIME=[027397C0:01C99680]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell wrote:
> On Monday 23 February 2009, Adrian Hunter wrote:
>> Also, you will need the following patch if you actually want the power
>> to go off.
> 
> Current GIT already has a patch supporting power-off for
> MMC2; tested on SDP and some custom hardware.  So this
> patch won't apply.

Sorry, hadn't noticed that.

> Are you sure that's needed for MMC1?  The led showing MMC1
> power did go off correctly (when using MMC2 for root), and
> the MMC1 regulator entry in sysfs agreed MMC1 was off.  So
> I thought this was only an issue for MMC2 (and presumably
> MMC3, though I don't have a board using it.)

Yes, if you never switch to 1.8V, then MMC1 is not affected.

However, for dual-voltage cards, if the MMC1 voltage is
switched to 1.8V, then the offending code will leave the
power on, when it should be off i.e. omap_mmc_switch_opcond()
turns the power on, but we are trying to power off.

If you initialise correctly (as Kim Kyuwon's patch does)
then the offending code is not necessary, so it should
just be removed.

I would still like the other two issues I raised considered.
They were:
	1.  'host' can be NULL in omap_mmc_suspend() / omap_mmc_resume()
	2. wait for SDBP bit

> I agree that code removed by this patch is ugly and worth
> removing if it's not actually needed for MMC1.

Here is a patch against current OMAP tree.

From: Adrian Hunter <ext-adrian.hunter@nokia.com>
Date: Tue, 24 Feb 2009 14:48:16 +0200
Subject: [PATCH] OMAP: HSMMC: do not re-power when powering off MMC

Remove code that turns MMC1 power back on after it
has been powered off (when the voltage is 1.8V).

The offending code is not necessary because the
host controller bus voltage is initialized to
3V when probing or resuming.  Note that MMC powers up
with the highest voltage available (see mmc_power_up())
which will be 3V also.

Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
---
 drivers/mmc/host/omap_hsmmc.c |   17 -----------------
 1 files changed, 0 insertions(+), 17 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index c0d5420..43cec98 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -486,9 +486,6 @@ static int omap_mmc_switch_opcond(struct mmc_omap_host *host, int vdd)
 	u32 reg_val = 0;
 	int ret;
 
-	if (host->id != OMAP_MMC1_DEVID)
-		return 0;
-
 	/* Disable the clocks */
 	clk_disable(host->fclk);
 	clk_disable(host->iclk);
@@ -787,20 +784,6 @@ static void omap_mmc_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 	switch (ios->power_mode) {
 	case MMC_POWER_OFF:
 		mmc_slot(host).set_power(host->dev, host->slot_id, 0, 0);
-		/*
-		 * Reset interface voltage to 3V if it's 1.8V now;
-		 * only relevant on MMC-1, the others always use 1.8V.
-		 *
-		 * REVISIT: If we are able to detect cards after unplugging
-		 * a 1.8V card, this code should not be needed.
-		 */
-		if (host->id != OMAP_MMC1_DEVID)
-			break;
-		if (!(OMAP_HSMMC_READ(host->base, HCTL) & SDVSDET)) {
-			int vdd = fls(host->mmc->ocr_avail) - 1;
-			if (omap_mmc_switch_opcond(host, vdd) != 0)
-				host->mmc->ios.vdd = vdd;
-		}
 		break;
 	case MMC_POWER_UP:
 		mmc_slot(host).set_power(host->dev, host->slot_id, 1, ios->vdd);
-- 
1.5.6.3
