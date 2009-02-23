Return-Path: <linux-kernel-owner+w=401wt.eu-S1755247AbZBWNdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247AbZBWNdX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 08:33:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754036AbZBWNdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 08:33:12 -0500
Received: from smtp.nokia.com ([192.100.122.233]:37339 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561AbZBWNdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 08:33:11 -0500
Message-ID: <49A2A8ED.20208@nokia.com>
Date: Mon, 23 Feb 2009 15:47:25 +0200
From: Adrian Hunter <ext-adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Kyungmin Park <kyungmin.park@samsung.com>
CC: Kim Kyuwon <chammoru@gmail.com>, David Brownell <david-b@pacbell.net>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "drzeus-mmc@drzeus.cx" <drzeus-mmc@drzeus.cx>,
       =?EUC-KR?B?seix1L/4?= <q1.kim@samsung.com>,
       "Lavinen Jarkko (Nokia-M/Helsinki)" <jarkko.lavinen@nokia.com>
Subject: Re: [PATCH] OMAP: HSMMC: Initialize hsmmc controller registers when
 	resuming
References: <4d34a0a70902200400s252f48ddvfd6e0d83e91fa291@mail.gmail.com>	 <200902201311.44056.david-b@pacbell.net>	 <4d34a0a70902222141y345a7bc3g314e6de5df156f2d@mail.gmail.com>	 <49A258A2.2020408@nokia.com> <9c9fda240902230426s2003d208xebeb6630c61b3bec@mail.gmail.com>
In-Reply-To: <9c9fda240902230426s2003d208xebeb6630c61b3bec@mail.gmail.com>
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Feb 2009 13:32:52.0693 (UTC) FILETIME=[3A565850:01C995BB]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyungmin Park wrote:
> Hi,
> 
> On Mon, Feb 23, 2009 at 5:04 PM, Adrian Hunter
> <ext-adrian.hunter@nokia.com> wrote:
>> ext Kim Kyuwon wrote:
>>> Hi,
>>>
>>> On Sat, Feb 21, 2009 at 6:11 AM, David Brownell <david-b@pacbell.net> wrote:
>>>> On Friday 20 February 2009, Kim Kyuwon wrote:
>>>>> +static void omap_hsmmc_init(struct mmc_omap_host *host)
>>>>> +{
>>>>> +       u32 hctl, capa, value;
>>>>> +
>>>>> +       /* Only MMC1 supports 3.0V */
>>>>> +       if (host->id == OMAP_MMC1_DEVID) {
>>>>> +               hctl = SDVS30;
>>>> Shouldn't it be remembering what voltage it was using,
>>>> and then restore that, instead of always making MMC1
>>>> restart at a 3.0V level?  That's pretty awkward to test
>>>> unless you have a 1.8V-capable card in MMC1...
>>> You are somewhat right, thank you.
>>> But remebering what voltage it was using doesn't feasible to me,
>>> because the card can be changed while in 'Sleep' state. I should have
>>> inserted a function that detect the right voltage after intializing. I
>>> will resend the patch later.
>> Doesn't it already do that? Can you explain more?
>>
>> Although I have not tested it, I very much doubt
>> dual-voltage cards work.  That is because VMMC1_185V
>> is zero, which has the side-effect of turning the
>> regulator off (see arch/arm/mach-omap2/mmc-twl4030.c)
> 
> It's also to difficult to test in our H/W since it's configured only
> support 3.0V.
> 
> How about to separate it two phases, first fix the mmc suspend/resume
> works again, and then verify dual voltage if there are these hardware
> 
> How to you think?

Yes certainly.

The original code assumes that 'host' may be NULL in omap_mmc_suspend ()
and omap_mmc_resume(), whereas the patch assumes 'host' is never NULL.
I suggest:

static int omap_mmc_suspend(struct platform_device *pdev, pm_message_t state)
{
	int ret = 0;
	struct mmc_omap_host *host = platform_get_drvdata(pdev);

-	if (host && host->suspended)
+	if (!host || host->suspended)
		return 0;


and

static int omap_mmc_resume(struct platform_device *pdev)
{
	int ret = 0;
	struct mmc_omap_host *host = platform_get_drvdata(pdev);

-	if (host && !host->suspended)
+	if (!host || !host->suspended)
		return 0;


Also the patch does not wait for the bus voltage (SDBP bit) to
initialise.  For the sake of correctness, I would add something
like:

	OMAP_HSMMC_WRITE(host->base, HCTL, value | SDBP);
+	for (i = 0; i < loops_per_jiffy; i++) {
+		if (OMAP_HSMMC_READ(host->base, HCTL) & SDBP)
+			break;
+		cpu_relax();
+	}


Also, you will need the following patch if you actually want the power
to go off.


From: Adrian Hunter <ext-adrian.hunter@nokia.com>
Date: Fri, 30 Jan 2009 11:58:13 +0200
Subject: [PATCH] OMAP: HSMMC: do not power up after powering off

The power is configured when probing and when resuming
so the bus voltage does not need changing after power
off.

Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
---
 drivers/mmc/host/omap_hsmmc.c |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 1e4a2e0..04e5a0c 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -859,16 +859,6 @@ static void omap_mmc_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 	switch (ios->power_mode) {
 	case MMC_POWER_OFF:
 		mmc_slot(host).set_power(host->dev, host->slot_id, 0, 0);
-		/*
-		 * Reset bus voltage to 3V if it got set to 1.8V earlier.
-		 * REVISIT: If we are able to detect cards after unplugging
-		 * a 1.8V card, this code should not be needed.
-		 */
-		if (!(OMAP_HSMMC_READ(host->base, HCTL) & SDVSDET)) {
-			int vdd = fls(host->mmc->ocr_avail) - 1;
-			if (omap_mmc_switch_opcond(host, vdd) != 0)
-				host->mmc->ios.vdd = vdd;
-		}
 		break;
 	case MMC_POWER_UP:
 		mmc_slot(host).set_power(host->dev, host->slot_id, 1, ios->vdd);
-- 
1.5.4.3
