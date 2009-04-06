Return-Path: <linux-kernel-owner+w=401wt.eu-S1756706AbZDFTcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706AbZDFTcX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 15:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753306AbZDFTcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 15:32:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:54683 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264AbZDFTcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 15:32:14 -0400
Subject: Re: [PATCH] rtc-ds1553: Drop IRQF_DISABLED
From: Peter Zijlstra <peterz@infradead.org>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1239036633-10032-2-git-send-email-anemo@mba.ocn.ne.jp>
References: <1239036633-10032-2-git-send-email-anemo@mba.ocn.ne.jp>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 06 Apr 2009 21:33:42 +0200
Message-Id: <1239046422.798.4803.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-07 at 01:50 +0900, Atsushi Nemoto wrote:
> IRQF_DISABLED should be be used with IRQF_SHARED.  Drop IRQF_DISABLED
> and add spin_lock_irqsave/spin_unlock_irqrestore to the interrupt
> handler.

I think you should use IRQF_DISABLED if at all possible. Only broken
hardware has an excuse not to.

NAK

> Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
> ---
>  drivers/rtc/rtc-ds1553.c |    9 +++++++--
>  1 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/rtc/rtc-ds1553.c b/drivers/rtc/rtc-ds1553.c
> index 38d472b..395f01b 100644
> --- a/drivers/rtc/rtc-ds1553.c
> +++ b/drivers/rtc/rtc-ds1553.c
> @@ -195,14 +195,19 @@ static irqreturn_t ds1553_rtc_interrupt(int irq, void *dev_id)
>  	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
>  	void __iomem *ioaddr = pdata->ioaddr;
>  	unsigned long events = RTC_IRQF;
> +	unsigned long flags;
>  
> +	spin_lock_irqsave(&pdata->rtc->irq_lock, flags);
>  	/* read and clear interrupt */
> -	if (!(readb(ioaddr + RTC_FLAGS) & RTC_FLAGS_AF))
> +	if (!(readb(ioaddr + RTC_FLAGS) & RTC_FLAGS_AF)) {
> +		spin_unlock_irqrestore(&pdata->rtc->irq_lock, flags);
>  		return IRQ_NONE;
> +	}
>  	if (readb(ioaddr + RTC_SECONDS_ALARM) & 0x80)
>  		events |= RTC_UF;
>  	else
>  		events |= RTC_AF;
> +	spin_unlock_irqrestore(&pdata->rtc->irq_lock, flags);
>  	rtc_update_irq(pdata->rtc, 1, events);
>  	return IRQ_HANDLED;
>  }
> @@ -329,7 +334,7 @@ static int __devinit ds1553_rtc_probe(struct platform_device *pdev)
>  	if (pdata->irq > 0) {
>  		writeb(0, ioaddr + RTC_INTERRUPTS);
>  		if (request_irq(pdata->irq, ds1553_rtc_interrupt,
> -				IRQF_DISABLED | IRQF_SHARED,
> +				IRQF_SHARED,
>  				pdev->name, pdev) < 0) {
>  			dev_warn(&pdev->dev, "interrupt not available.\n");
>  			pdata->irq = 0;
