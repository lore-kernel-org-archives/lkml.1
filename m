Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366Ab0BEKRm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 05:17:42 -0500
Received: from smtp.nokia.com ([192.100.122.230]:57498 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab0BEKRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 05:17:40 -0500
Message-ID: <4B6BF02A.2080501@nokia.com>
Date: Fri, 05 Feb 2010 12:17:14 +0200
From: Adrian Hunter <adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Maxim Levitsky <maximlevitsky@gmail.com>,
       "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
       Philip Langdale <philipl@overt.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Schummer Jorg.2 (EXT-Tieto/Espoo)" <ext-jorg.2.schummer@nokia.com>,
       nico@fluxnic.net, nico@marvell.com
Subject: Re: [PATCH] MMC: fix hang if card was removed during suspend and
 unsafe resume was enabled
References: <1265219241.12549.8.camel@maxim-laptop>	<1265325495-4220-1-git-send-email-maximlevitsky@gmail.com> <20100204160957.1c51cc1b.akpm@linux-foundation.org>
In-Reply-To: <20100204160957.1c51cc1b.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Feb 2010 10:17:16.0222 (UTC) FILETIME=[64323DE0:01CAA64C]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ext Andrew Morton wrote:
> On Fri,  5 Feb 2010 01:18:15 +0200 Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> 
>> Currently removal of the card leads to del_disk called indirectly by mmc core.
>> This function expects userspace to be running, which isn't when .resume is called
>>
>> Fix that by removing the code that did that in mmc_resume_host. It is possible
>> because card detection logic will kick it later and remove the card.
> 
> I don't really understand.  The above implies that to trigger this bug,
> one needs to physically remove the card during a resume operation.  ie:
> a human-vs-computer race.  Sounds unlikely?
> 
> So...  exactly what steps does the user need to take to trigger this
> bug?
> 
>> Also make mtd workqueue freezeable, so it won't attempt to add/remove the card
>> while userspace is frozen.
>>
>>
>> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
>> index 30acd52..879d48d 100644
>> --- a/drivers/mmc/core/core.c
>> +++ b/drivers/mmc/core/core.c
>> @@ -1257,7 +1257,6 @@ int mmc_suspend_host(struct mmc_host *host, pm_message_t state)
>>  	if (host->caps & MMC_CAP_DISABLE)
>>  		cancel_delayed_work(&host->disable);
>>  	cancel_delayed_work(&host->detect);
>> -	mmc_flush_scheduled_work();
>>  
>>  	mmc_bus_get(host);
>>  	if (host->bus_ops && !host->bus_dead) {
>> @@ -1300,15 +1299,11 @@ int mmc_resume_host(struct mmc_host *host)
>>  		mmc_select_voltage(host, host->ocr);
>>  		BUG_ON(!host->bus_ops->resume);
>>  		err = host->bus_ops->resume(host);
>> +
>>  		if (err) {
>>  			printk(KERN_WARNING "%s: error %d during resume "
>>  					    "(card was removed?)\n",
>>  					    mmc_hostname(host), err);
>> -			if (host->bus_ops->remove)
>> -				host->bus_ops->remove(host);
>> -			mmc_claim_host(host);
>> -			mmc_detach_bus(host);
>> -			mmc_release_host(host);
> 
> afacit that code's been there since March 2009.  I'd have thought that
> someone would have noticed "kernel hangs on resume" before now.
> 
> Do you think the patch should be backported into 2.6.32.x and eariler?

It looks like the code was introduced in 2.6.32.x by commit

95cdfb72b9bc568803f395c266152c71b034b461

cc'ing the author Nicolas Pitre

> 
>>  			/* no need to bother upper layers */
>>  			err = 0;
>>  		}
>> @@ -1332,7 +1327,7 @@ static int __init mmc_init(void)
>>  {
>>  	int ret;
>>  
>> -	workqueue = create_singlethread_workqueue("kmmcd");
>> +	workqueue = create_freezeable_workqueue("kmmcd");
>>  	if (!workqueue)
>>  		return -ENOMEM;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

