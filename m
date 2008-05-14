Return-Path: <linux-kernel-owner+w=401wt.eu-S1760909AbYENIh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760909AbYENIh3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 04:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753936AbYENIhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 04:37:21 -0400
Received: from fnoeppeil48.netpark.at ([217.175.205.176]:39869 "EHLO
	roarinelk.homelinux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612AbYENIhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 04:37:19 -0400
Date: Wed, 14 May 2008 10:37:16 +0200
From: Manuel Lauss <mano@roarinelk.homelinux.net>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] au1xmmc: remove db1x00 board-specific functions
	from driver
Message-ID: <20080514083716.GA10860@roarinelk.homelinux.net>
References: <20080508080040.GA24383@roarinelk.homelinux.net> <20080508080301.GD24383@roarinelk.homelinux.net> <48282BBE.4090409@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48282BBE.4090409@ru.mvista.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sergei,

>>  #include <asm/mach-au1x00/au1100_mmc.h>
>>   #include <au1xxx.h>
>> -#include "au1xmmc.h"
>>   
>   I think you should merge the header to the driver in a separate patch.

Okay...


>> @@ -174,8 +221,6 @@ static void au1xmmc_finish_request(struct au1xmmc_host 
>> *host)
>>   	host->status = HOST_S_IDLE;
>>  -	bcsr->disk_leds |= (1 << 8);
>> -
>>   
>   So, the LED support is gone with your patch? You should at least document 
> this...

Okay...


>>  	mmc_request_done(host->mmc, mrq);
>>  }
>>  @@ -663,7 +708,9 @@ static void au1xmmc_request(struct mmc_host* mmc, 
>> struct mmc_request* mrq)
>>  	host->mrq = mrq;
>>  	host->status = HOST_S_CMD;
>>  -	bcsr->disk_leds &= ~(1 << 8);
>> +	au_writel(0, HOST_STATUS(host));
>> +	au_sync();
>> +	FLUSH_FIFO(host);
>>   
>   Hm, not an obvious change...

Gone (leftovers from debugging MMC and other non-working cards)


>>   	if (mrq->data) {
>>  		FLUSH_FIFO(host);
>> @@ -749,118 +796,87 @@ static void au1xmmc_dma_callback(int irq, void 
>> *dev_id)
>>   static irqreturn_t au1xmmc_irq(int irq, void *dev_id)
>>  {
>> -
>> +	struct au1xmmc_host *host = dev_id;
>>  	u32 status;
>> -	int i, ret = 0;
>>  -	disable_irq(AU1100_SD_IRQ);
>> +	status = au_readl(HOST_STATUS(host));
>>  -	for(i = 0; i < AU1XMMC_CONTROLLER_COUNT; i++) {
>> -		struct au1xmmc_host * host = au1xmmc_hosts[i];
>> -		u32 handled = 1;
>> +	if (!(status & (1 << 15)))
>>   
>   Why not SD_STATUS_I?

Good point, I'll add named constants for other values as well.


>> +		//IRQ_OFF(host, SD_CONFIG_TH|SD_CONFIG_RA|SD_CONFIG_RF);
>>   
>   No C99 // comments please -- checkpatch.pl would have given you error 
> about them...

It did-- but since I was just shuffling code around I was hesitant to do
these changes as well in this particular patch (the i2c maintainer for
instance wants functional and cosmetic changes in separate patches;
and every maintainer has different preferences, so I left those lines
untouched to not add additional noise).


>> +	} else if (status & 0x203FBC70) {
>>   
>   I think the mask should be changed to 0x203F3C70 since you're handling 
> SD_STATUS_I but maybe I'm wrong...

Yes you're right (but this line never triggered while testing so it's
harmless).


>> -static void au1xmmc_init_dma(struct au1xmmc_host *host)
>> +static int au1xmmc_init_dma(struct au1xmmc_host *host)
>>   
>   I'd have called it au1xmmc_init_dbdma() instead since in Au1100 the 
> controller works with its "old-style" DMA... though maybe the difference 
> could be handled within this function via #ifdef...

I like the renamed function, but again, I was just shuffling code around
(more or less) so I didn't touch the name(s).
For the time being, I'll leave it as-is, and if someday Au1100 DMA is added
the functions can be renamed or beautified with tons of ifdefs.
What do you think?


>> @@ -878,116 +896,201 @@ static const struct mmc_host_ops au1xmmc_ops = {
>>  	.get_ro		= au1xmmc_card_readonly,
>>  };
>>  -static int __devinit au1xmmc_probe(struct platform_device *pdev)
>> +static void au1xmmc_poll_event(unsigned long arg)
>>  {
>> +	struct au1xmmc_host *host = (struct au1xmmc_host *)arg;
>>   
>   Don't need new line here...

Okay...


>>  -	int i, ret = 0;
>> +	int card = au1xmmc_card_inserted(host);
>> +        int controller = (host->flags & HOST_F_ACTIVE) ? 1 : 0;
>>   
>   Remove extra space please. And what does this variable actually mean?

Based on HOST_F_ACTIVE the driver determines if it is possible that there's
a card in the socket.  Again, I just did code shuffling here. 


>> +	host->iobase = (unsigned long)ioremap(r->start, 0xff);
>>   
>   You have the r->end specifying the resource end, why 0xff (well, actually 
> 0x3c is enough)

Okay...


>> @@ -1004,21 +1107,32 @@ static struct platform_driver au1xmmc_driver = {
>>   static int __init au1xmmc_init(void)
>>  {
>> +	if (dma) {
>> +		/* DSCR_CMD0_ALWAYS has a stride of 32 bits, we need a stride
>> +		 * of 8 bits.  And since devices are shared, we need to create
>> +		 * our own to avoid freaking out other devices
>>   
>   Missing period at end of statement.

Okay...


>> +		 */
>> +		if (!memid)
>>   
>   Hm, is there a chance that it won't be NULL?

Are global vars initialized to zero on module load?  Then it can go away of
course.


>> +			memid = au1xxx_ddma_add_device(&au1xmmc_mem_dbdev);
>> +		if (!memid) {
>> +			printk(KERN_ERR "au1xmmc: cannot add memory dma dev\n");
>> +			return -ENODEV;
>> +		}
>> +	}
>>  	return platform_driver_register(&au1xmmc_driver);
>>  }
> [...]
>> diff --git a/include/asm-mips/mach-au1x00/au1100_mmc.h 
>> b/include/asm-mips/mach-au1x00/au1100_mmc.h
>> index 9e0028f..6474fac 100644
>> --- a/include/asm-mips/mach-au1x00/au1100_mmc.h
>> +++ b/include/asm-mips/mach-au1x00/au1100_mmc.h
>> @@ -38,15 +38,46 @@
>>  #ifndef __ASM_AU1100_MMC_H
>>  #define __ASM_AU1100_MMC_H
>>    
> [...]
>> +struct au1xmmc_platdata {
>>   
>   I'd suggest au1xmmc_platform_data.

Too much to type for my taste, but okay, changed.


>> +	int(*cd_setup)(void *mmc_host, int on);
>> +	int(*card_inserted)(void *mmc_host);
>> +	int(*card_readonly)(void *mmc_host);
>> +	void(*set_power)(void *mmc_host, int state);
>> +};
>> +
>> +struct au1xmmc_host {
>> +	struct mmc_host *mmc;
>> +	struct mmc_request *mrq;
>> +
>> +	u32 id;
>> +
>> +	u32 flags;
>> +	u32 iobase;
>> +	u32 clock;
>> +
>> +	int status;
>> +
>> +	struct {
>> +		int len;
>> +		int dir;
>> +		u32 tx_chan;
>> +		u32 rx_chan;
>> +	} dma;
>> +
>> +	struct {
>> +		int index;
>> +		int offset;
>> +		int len;
>> +	} pio;
>> +
>> +	struct timer_list timer;
>> +	struct tasklet_struct finish_task;
>> +	struct tasklet_struct data_task;
>> +
>> +	struct platform_device *pdev;
>> +	struct au1xmmc_platdata *platdata;
>> +	int irq;
>> +};
>   Hm, do you need the above structure to be visible from the platform code?

The db1200 board stuff references the ->id member to determine which BCSR
bits it should pay attention to.  It can go into the driver code if you are
okay with adding platform data for every one of both SD controllers on the
PB1200 (which means lots of duplicated code which only differs in BCSR
constants).  I'm okay with eiher solution, which do you prefer?


> WBR, Sergei

Thanks for having a look!
	Manuel Lauss
