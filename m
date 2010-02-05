Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933482Ab0BEAKP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 19:10:15 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45770 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933467Ab0BEAKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 19:10:13 -0500
Date: Thu, 4 Feb 2010 16:09:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-mmc@vger.kernel.org, Philip Langdale <philipl@overt.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jorg Schummer <ext-jorg.2.schummer@nokia.com>
Subject: Re: [PATCH] MMC: fix hang if card was removed during suspend and
 unsafe resume was enabled
Message-Id: <20100204160957.1c51cc1b.akpm@linux-foundation.org>
In-Reply-To: <1265325495-4220-1-git-send-email-maximlevitsky@gmail.com>
References: <1265219241.12549.8.camel@maxim-laptop>
	<1265325495-4220-1-git-send-email-maximlevitsky@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  5 Feb 2010 01:18:15 +0200 Maxim Levitsky <maximlevitsky@gmail.com> wrote:

> Currently removal of the card leads to del_disk called indirectly by mmc core.
> This function expects userspace to be running, which isn't when .resume is called
> 
> Fix that by removing the code that did that in mmc_resume_host. It is possible
> because card detection logic will kick it later and remove the card.

I don't really understand.  The above implies that to trigger this bug,
one needs to physically remove the card during a resume operation.  ie:
a human-vs-computer race.  Sounds unlikely?

So...  exactly what steps does the user need to take to trigger this
bug?

> Also make mtd workqueue freezeable, so it won't attempt to add/remove the card
> while userspace is frozen.
> 
> 
> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> index 30acd52..879d48d 100644
> --- a/drivers/mmc/core/core.c
> +++ b/drivers/mmc/core/core.c
> @@ -1257,7 +1257,6 @@ int mmc_suspend_host(struct mmc_host *host, pm_message_t state)
>  	if (host->caps & MMC_CAP_DISABLE)
>  		cancel_delayed_work(&host->disable);
>  	cancel_delayed_work(&host->detect);
> -	mmc_flush_scheduled_work();
>  
>  	mmc_bus_get(host);
>  	if (host->bus_ops && !host->bus_dead) {
> @@ -1300,15 +1299,11 @@ int mmc_resume_host(struct mmc_host *host)
>  		mmc_select_voltage(host, host->ocr);
>  		BUG_ON(!host->bus_ops->resume);
>  		err = host->bus_ops->resume(host);
> +
>  		if (err) {
>  			printk(KERN_WARNING "%s: error %d during resume "
>  					    "(card was removed?)\n",
>  					    mmc_hostname(host), err);
> -			if (host->bus_ops->remove)
> -				host->bus_ops->remove(host);
> -			mmc_claim_host(host);
> -			mmc_detach_bus(host);
> -			mmc_release_host(host);

afacit that code's been there since March 2009.  I'd have thought that
someone would have noticed "kernel hangs on resume" before now.

Do you think the patch should be backported into 2.6.32.x and eariler?

>  			/* no need to bother upper layers */
>  			err = 0;
>  		}
> @@ -1332,7 +1327,7 @@ static int __init mmc_init(void)
>  {
>  	int ret;
>  
> -	workqueue = create_singlethread_workqueue("kmmcd");
> +	workqueue = create_freezeable_workqueue("kmmcd");
>  	if (!workqueue)
>  		return -ENOMEM;
