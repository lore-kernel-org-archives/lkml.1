Return-Path: <linux-kernel-owner+w=401wt.eu-S1757548AbZGCPcD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548AbZGCPcD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 11:32:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755914AbZGCPbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 11:31:53 -0400
Received: from mail-pz0-f193.google.com ([209.85.222.193]:37845 "EHLO
	mail-pz0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756142AbZGCPbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 11:31:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=O8woN5XdJfuG7TqNKL8prIEeXQ+jARDQLzIaSC2+WeVfMMSe69sjllPlBYdwg6nThj
         MrFclc5LEBBmETMfcQtVwxP3AThKL4XTRHanSKGQSKX1jASj6tJJQR6UhzlTMsWymLxa
         vPPNtZdoyZVo+o2TdqBYTmQltTs3iRt6drPTo=
Subject: Re: [Bug #13663] suspend to ram regression (IDE related)
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Jeff Chua <jeff.chua.linux@gmail.com>,
       Etienne Basset <etienne.basset@numericable.fr>,
       David Miller <davem@davemloft.net>, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       linux-ide@vger.kernel.org
In-Reply-To: <200907031508.47891.bzolnier@gmail.com>
References: <etTXaRqGgAC.A.SaE.6iASKB@chimera>
	 <200907021813.57322.bzolnier@gmail.com> <1246593505.27828.187.camel@falcon>
	 <200907031508.47891.bzolnier@gmail.com>
Content-Type: text/plain
Organization: DSLab, Lanzhou University, China
Date: Fri, 03 Jul 2009 23:31:36 +0800
Message-Id: <1246635096.16890.6.camel@falcon>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> OK, I see another gotcha added by recent changes, we need to explicitly
> initialize rq_in_flight variables now.  Revised patch below..
> 

Sorry, STD also not work. if apply this patch, the same problem as not
apply it, it stopped at:

...
PM: Crete hibernation image:
PM: Need to copy ... pages
PM: Hibernation image created ...

I think it's better to revert this commit:
 a1317f714af7aed60ddc182d0122477cbe36ee9b ("ide: improve handling of
Power Management requests")

Regards,
Wu Zhangjin

> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] ide: make resume work again (for real)
> 
> It turns out that commit a1317f714af7aed60ddc182d0122477cbe36ee9b
> ("ide: improve handling of Power Management requests") needs to take
> into the account a new code added by the recent block layer changes
> in commit 8f6205cd572fece673da0255d74843680f67f879 ("ide: dequeue
> in-flight request") and prevent clearing of hwif->rq if the device
> is blocked.
> 
> Thanks to Etienne, Wu and Jeff for help in fixing the issue.
> 
> Reported-and-tested-by: Jeff Chua <jeff.chua.linux@gmail.com>
> Reported-and-tested-by: Etienne Basset <etienne.basset@numericable.fr>
> Reported-by: Wu Zhangjin <wuzhangjin@gmail.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
> Added patch description, no other changes.
> 
>  drivers/ide/ide-io.c |   19 ++++++++++++-------
>  1 file changed, 12 insertions(+), 7 deletions(-)
> 
> Index: b/drivers/ide/ide-io.c
> ===================================================================
> --- a/drivers/ide/ide-io.c
> +++ b/drivers/ide/ide-io.c
> @@ -532,7 +532,8 @@ repeat:
>  
>  		if (startstop == ide_stopped) {
>  			rq = hwif->rq;
> -			hwif->rq = NULL;
> +			if ((drive->dev_flags & IDE_DFLAG_BLOCKED) == 0)
> +				hwif->rq = NULL;
>  			goto repeat;
>  		}
>  	} else
> @@ -616,7 +617,7 @@ void ide_timer_expiry (unsigned long dat
>  	unsigned long	flags;
>  	int		wait = -1;
>  	int		plug_device = 0;
> -	struct request	*uninitialized_var(rq_in_flight);
> +	struct request	*rq_in_flight = NULL;
>  
>  	spin_lock_irqsave(&hwif->lock, flags);
>  
> @@ -679,8 +680,10 @@ void ide_timer_expiry (unsigned long dat
>  		spin_lock_irq(&hwif->lock);
>  		enable_irq(hwif->irq);
>  		if (startstop == ide_stopped && hwif->polling == 0) {
> -			rq_in_flight = hwif->rq;
> -			hwif->rq = NULL;
> +			if ((drive->dev_flags & IDE_DFLAG_BLOCKED) == 0) {
> +				rq_in_flight = hwif->rq;
> +				hwif->rq = NULL;
> +			}
>  			ide_unlock_port(hwif);
>  			plug_device = 1;
>  		}
> @@ -775,7 +778,7 @@ irqreturn_t ide_intr (int irq, void *dev
>  	ide_startstop_t startstop;
>  	irqreturn_t irq_ret = IRQ_NONE;
>  	int plug_device = 0;
> -	struct request *uninitialized_var(rq_in_flight);
> +	struct request *rq_in_flight = NULL;
>  
>  	if (host->host_flags & IDE_HFLAG_SERIALIZE) {
>  		if (hwif != host->cur_port)
> @@ -856,8 +859,10 @@ irqreturn_t ide_intr (int irq, void *dev
>  	 */
>  	if (startstop == ide_stopped && hwif->polling == 0) {
>  		BUG_ON(hwif->handler);
> -		rq_in_flight = hwif->rq;
> -		hwif->rq = NULL;
> +		if ((drive->dev_flags & IDE_DFLAG_BLOCKED) == 0) {
> +			rq_in_flight = hwif->rq;
> +			hwif->rq = NULL;
> +		}
>  		ide_unlock_port(hwif);
>  		plug_device = 1;
>  	}

