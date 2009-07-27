Return-Path: <linux-kernel-owner+w=401wt.eu-S1755499AbZG0JGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499AbZG0JGh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 05:06:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755258AbZG0JGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 05:06:36 -0400
Received: from smtp.nokia.com ([192.100.122.230]:49311 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539AbZG0JGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 05:06:35 -0400
Message-ID: <4A6D6E22.8000105@nokia.com>
Date: Mon, 27 Jul 2009 12:06:42 +0300
From: Adrian Hunter <adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "pierre@ossman.eu" <pierre@ossman.eu>,
       "Lavinen Jarkko (Nokia-D/Helsinki)" <jarkko.lavinen@nokia.com>,
       "Karpov Denis.2 (EXT-Teleca/Helsinki)" <ext-denis.2.karpov@nokia.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 26/32] omap_hsmmc: prevent races with irq handler
References: <20090710124004.1262.10422.sendpatchset@ahunter-tower>	<20090710124309.1262.22465.sendpatchset@ahunter-tower> <20090724155351.a99e30fd.akpm@linux-foundation.org>
In-Reply-To: <20090724155351.a99e30fd.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Jul 2009 09:06:08.0923 (UTC) FILETIME=[7AF656B0:01CA0E99]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 10 Jul 2009 15:43:09 +0300
> Adrian Hunter <adrian.hunter@nokia.com> wrote:
> 
>> >From 242fae6293adec671b14354f215217354f5076a0 Mon Sep 17 00:00:00 2001
>> From: Adrian Hunter <adrian.hunter@nokia.com>
>> Date: Sat, 16 May 2009 10:32:34 +0300
>> Subject: [PATCH] omap_hsmmc: prevent races with irq handler
>>
>> If an unexpected interrupt occurs while preparing the
>> next request, an oops can occur.
>>
>> For example, a new request is setting up DMA for data
>> transfer so host->data is not NULL.  An unexpected
>> transfer complete (TC) interrupt comes along and
>> the interrupt handler sets host->data to NULL.  Oops!
>>
>> Prevent that by disabling interrupts while setting up
>> a new request.
>>
>> Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
>> ---
>>  drivers/mmc/host/omap_hsmmc.c |   16 ++++++++++++++++
>>  1 files changed, 16 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
>> index 28563d6..38e1410 100644
>> --- a/drivers/mmc/host/omap_hsmmc.c
>> +++ b/drivers/mmc/host/omap_hsmmc.c
>> @@ -452,6 +452,13 @@ mmc_omap_start_command(struct mmc_omap_host *host, struct mmc_command *cmd,
>>  	if (host->use_dma)
>>  		cmdreg |= DMA_EN;
>>  
>> +	/*
>> +	 * In an interrupt context (i.e. STOP command), the interrupt is already
>> +	 * enabled, otherwise it is not (i.e. new request).
>> +	 */
>> +	if (!in_interrupt())
>> +		enable_irq(host->irq);
>> +
>>  	OMAP_HSMMC_WRITE(host->base, ARG, cmd->arg);
>>  	OMAP_HSMMC_WRITE(host->base, CMD, cmdreg);
>>  }
>> @@ -1011,6 +1018,13 @@ static void omap_mmc_request(struct mmc_host *mmc, struct mmc_request *req)
>>  	struct mmc_omap_host *host = mmc_priv(mmc);
>>  	int err;
>>  
>> +	/*
>> +	 * Prevent races with the interrupt handler because of unexpected
>> +	 * interrupts, but not if we are already in interrupt context i.e.
>> +	 * retries.
>> +	 */
>> +	if (!in_interrupt())
>> +		disable_irq(host->irq);
>>  	WARN_ON(host->mrq != NULL);
>>  	host->mrq = req;
>>  	err = mmc_omap_prepare_data(host, req);
>> @@ -1019,6 +1033,8 @@ static void omap_mmc_request(struct mmc_host *mmc, struct mmc_request *req)
>>  		if (req->data)
>>  			req->data->error = err;
>>  		host->mrq = NULL;
>> +		if (!in_interrupt())
>> +			enable_irq(host->irq);
>>  		mmc_request_done(mmc, req);
>>  		return;
>>  	}
> 
> That seems pretty crude.  Disabling an interrupt line can be expensive,
> and will shut off any other innocent devices which share the line.
> 
> The usual and superior way of fixing races such as this is
> spin_lock_irq[save]().
> 
> 

>From f54be3678907b85a00d9f51e3ce4c828fc21ee95 Mon Sep 17 00:00:00 2001
From: Adrian Hunter <adrian.hunter@nokia.com>
Date: Mon, 27 Jul 2009 12:00:17 +0300
Subject: [PATCH] omap_hsmmc: use spin_lock not disable_irq

Disabling an interrupt line can be expensive.  The usual and
superior way of fixing races such as this is spin_lock_irqsave.

Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
---
 drivers/mmc/host/omap_hsmmc.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 8900bae..9850280 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -146,6 +146,8 @@ struct omap_hsmmc_host {
 	struct	work_struct	mmc_carddetect_work;
 	void	__iomem		*base;
 	resource_size_t		mapbase;
+	spinlock_t		irq_lock;
+	unsigned long		flags;
 	unsigned int		id;
 	unsigned int		dma_len;
 	unsigned int		dma_sg_idx;
@@ -462,7 +464,7 @@ omap_hsmmc_start_command(struct omap_hsmmc_host *host, struct mmc_command *cmd,
 	 * enabled, otherwise it is not (i.e. new request).
 	 */
 	if (!in_interrupt())
-		enable_irq(host->irq);
+		spin_unlock_irqrestore(&host->irq_lock, host->flags);
 
 	OMAP_HSMMC_WRITE(host->base, ARG, cmd->arg);
 	OMAP_HSMMC_WRITE(host->base, CMD, cmdreg);
@@ -626,11 +628,14 @@ static irqreturn_t omap_hsmmc_irq(int irq, void *dev_id)
 	struct mmc_data *data;
 	int end_cmd = 0, end_trans = 0, status;
 
+	spin_lock(&host->irq_lock);
+
 	if (host->mrq == NULL) {
 		OMAP_HSMMC_WRITE(host->base, STAT,
 			OMAP_HSMMC_READ(host->base, STAT));
 		/* Flush posted write */
 		OMAP_HSMMC_READ(host->base, STAT);
+		spin_unlock(&host->irq_lock);
 		return IRQ_HANDLED;
 	}
 
@@ -696,6 +701,8 @@ static irqreturn_t omap_hsmmc_irq(int irq, void *dev_id)
 	if ((end_trans || (status & TC)) && host->mrq)
 		omap_hsmmc_xfer_done(host, data);
 
+	spin_unlock(&host->irq_lock);
+
 	return IRQ_HANDLED;
 }
 
@@ -1066,7 +1073,7 @@ static void omap_hsmmc_request(struct mmc_host *mmc, struct mmc_request *req)
 	 * retries.
 	 */
 	if (!in_interrupt()) {
-		disable_irq(host->irq);
+		spin_lock_irqsave(&host->irq_lock, host->flags);
 		/*
 		 * Protect the card from I/O if there is a possibility
 		 * it can be removed.
@@ -1085,7 +1092,7 @@ static void omap_hsmmc_request(struct mmc_host *mmc, struct mmc_request *req)
 			req->cmd->error = -EBADF;
 			if (req->data)
 				req->data->error = -EBADF;
-			enable_irq(host->irq);
+			spin_unlock_irqrestore(&host->irq_lock, host->flags);
 			mmc_request_done(mmc, req);
 			return;
 		} else if (host->reqs_blocked)
@@ -1100,7 +1107,7 @@ static void omap_hsmmc_request(struct mmc_host *mmc, struct mmc_request *req)
 			req->data->error = err;
 		host->mrq = NULL;
 		if (!in_interrupt())
-			enable_irq(host->irq);
+			spin_unlock_irqrestore(&host->irq_lock, host->flags);
 		mmc_request_done(mmc, req);
 		return;
 	}
@@ -1653,6 +1660,7 @@ static int __init omap_hsmmc_probe(struct platform_device *pdev)
 	mmc->f_max	= 52000000;
 
 	sema_init(&host->sem, 1);
+	spin_lock_init(&host->irq_lock);
 
 	host->iclk = clk_get(&pdev->dev, "ick");
 	if (IS_ERR(host->iclk)) {
-- 
1.5.6.3


