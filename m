Return-Path: <linux-kernel-owner+w=401wt.eu-S1760265AbYELLoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760265AbYELLoU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 07:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758821AbYELLoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 07:44:05 -0400
Received: from smtp04.mtu.ru ([62.5.255.51]:61042 "EHLO smtp04.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751685AbYELLoC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 07:44:02 -0400
X-Greylist: delayed 444 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 May 2008 07:44:01 EDT
Message-ID: <48282BBE.4090409@ru.mvista.com>
Date: Mon, 12 May 2008 15:36:30 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Manuel Lauss <mano@roarinelk.homelinux.net>
CC: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] au1xmmc: remove db1x00 board-specific functions from
 driver
References: <20080508080040.GA24383@roarinelk.homelinux.net> <20080508080301.GD24383@roarinelk.homelinux.net>
In-Reply-To: <20080508080301.GD24383@roarinelk.homelinux.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-DCC-STREAM-Metrics: smtp04.mtu.ru 10001; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Manuel Lauss wrote:
> From 47ecf116465ed850d2202880f7795fcee4826184 Mon Sep 17 00:00:00 2001
> From: Manuel Lauss <mlau@msc-ge.com>
> Date: Wed, 7 May 2008 14:57:01 +0200
> Subject: [PATCH] au1xmmc: remove db1x00 board-specific functions from driver
>
> Remove the DB1200 board-specific functions (card present, read-only
> methods) and instead add platform data which is passed to the driver.
> This allows for platforms to implement other carddetect schemes
> (e.g. dedicated irq) without having to pollute the driver code.
> The poll timer (used for pb1200) is kept for compatibility.
>
> With the board-specific stuff gone, the driver no longer needs to know
> how many physical controllers the silicon actually has; every device
> can be registered as needed, update the code to reflect that.
>
> Signed-off-by: Manuel Lauss <mano@roarinelk.homelinux.net>
>   
[...]
> diff --git a/drivers/mmc/host/au1xmmc.c b/drivers/mmc/host/au1xmmc.c
> index cc5f7bc..8660f86 100644
> --- a/drivers/mmc/host/au1xmmc.c
> +++ b/drivers/mmc/host/au1xmmc.c
> @@ -49,7 +49,6 @@
>  #include <asm/mach-au1x00/au1100_mmc.h>
>  
>  #include <au1xxx.h>
> -#include "au1xmmc.h"
>   
   I think you should merge the header to the driver in a separate patch.
> @@ -174,8 +221,6 @@ static void au1xmmc_finish_request(struct au1xmmc_host *host)
>  
>  	host->status = HOST_S_IDLE;
>  
> -	bcsr->disk_leds |= (1 << 8);
> -
>   
   So, the LED support is gone with your patch? You should at least 
document this...
>  	mmc_request_done(host->mmc, mrq);
>  }
>  
> @@ -663,7 +708,9 @@ static void au1xmmc_request(struct mmc_host* mmc, struct mmc_request* mrq)
>  	host->mrq = mrq;
>  	host->status = HOST_S_CMD;
>  
> -	bcsr->disk_leds &= ~(1 << 8);
> +	au_writel(0, HOST_STATUS(host));
> +	au_sync();
> +	FLUSH_FIFO(host);
>   
   Hm, not an obvious change...
>  
>  	if (mrq->data) {
>  		FLUSH_FIFO(host);
> @@ -749,118 +796,87 @@ static void au1xmmc_dma_callback(int irq, void *dev_id)
>  
>  static irqreturn_t au1xmmc_irq(int irq, void *dev_id)
>  {
> -
> +	struct au1xmmc_host *host = dev_id;
>  	u32 status;
> -	int i, ret = 0;
>  
> -	disable_irq(AU1100_SD_IRQ);
> +	status = au_readl(HOST_STATUS(host));
>  
> -	for(i = 0; i < AU1XMMC_CONTROLLER_COUNT; i++) {
> -		struct au1xmmc_host * host = au1xmmc_hosts[i];
> -		u32 handled = 1;
> +	if (!(status & (1 << 15)))
>   
   Why not SD_STATUS_I?
> +		//IRQ_OFF(host, SD_CONFIG_TH|SD_CONFIG_RA|SD_CONFIG_RF);
>   
   No C99 // comments please -- checkpatch.pl would have given you error 
about them...
> +	} else if (status & 0x203FBC70) {
>   
   I think the mask should be changed to 0x203F3C70 since you're 
handling SD_STATUS_I but maybe I'm wrong...
> -static void au1xmmc_init_dma(struct au1xmmc_host *host)
> +static int au1xmmc_init_dma(struct au1xmmc_host *host)
>   
   I'd have called it au1xmmc_init_dbdma() instead since in Au1100 the 
controller works with its "old-style" DMA... though maybe the difference 
could be handled within this function via #ifdef...
> @@ -878,116 +896,201 @@ static const struct mmc_host_ops au1xmmc_ops = {
>  	.get_ro		= au1xmmc_card_readonly,
>  };
>  
> -static int __devinit au1xmmc_probe(struct platform_device *pdev)
> +static void au1xmmc_poll_event(unsigned long arg)
>  {
> +	struct au1xmmc_host *host = (struct au1xmmc_host *)arg;
>   
   Don't need new line here...
>  
> -	int i, ret = 0;
> +	int card = au1xmmc_card_inserted(host);
> +        int controller = (host->flags & HOST_F_ACTIVE) ? 1 : 0;
>   
   Remove extra space please. And what does this variable actually mean?
> +	host->iobase = (unsigned long)ioremap(r->start, 0xff);
>   
   You have the r->end specifying the resource end, why 0xff (well, 
actually 0x3c is enough)
> @@ -1004,21 +1107,32 @@ static struct platform_driver au1xmmc_driver = {
>  
>  static int __init au1xmmc_init(void)
>  {
> +	if (dma) {
> +		/* DSCR_CMD0_ALWAYS has a stride of 32 bits, we need a stride
> +		 * of 8 bits.  And since devices are shared, we need to create
> +		 * our own to avoid freaking out other devices
>   
   Missing period at end of statement.
> +		 */
> +		if (!memid)
>   
   Hm, is there a chance that it won't be NULL?
> +			memid = au1xxx_ddma_add_device(&au1xmmc_mem_dbdev);
> +		if (!memid) {
> +			printk(KERN_ERR "au1xmmc: cannot add memory dma dev\n");
> +			return -ENODEV;
> +		}
> +	}
>  	return platform_driver_register(&au1xmmc_driver);
>  }
[...]
> diff --git a/include/asm-mips/mach-au1x00/au1100_mmc.h b/include/asm-mips/mach-au1x00/au1100_mmc.h
> index 9e0028f..6474fac 100644
> --- a/include/asm-mips/mach-au1x00/au1100_mmc.h
> +++ b/include/asm-mips/mach-au1x00/au1100_mmc.h
> @@ -38,15 +38,46 @@
>  #ifndef __ASM_AU1100_MMC_H
>  #define __ASM_AU1100_MMC_H
>  
>   
[...]
> +struct au1xmmc_platdata {
>   
   I'd suggest au1xmmc_platform_data.
> +	int(*cd_setup)(void *mmc_host, int on);
> +	int(*card_inserted)(void *mmc_host);
> +	int(*card_readonly)(void *mmc_host);
> +	void(*set_power)(void *mmc_host, int state);
> +};
> +
> +struct au1xmmc_host {
> +	struct mmc_host *mmc;
> +	struct mmc_request *mrq;
> +
> +	u32 id;
> +
> +	u32 flags;
> +	u32 iobase;
> +	u32 clock;
> +
> +	int status;
> +
> +	struct {
> +		int len;
> +		int dir;
> +		u32 tx_chan;
> +		u32 rx_chan;
> +	} dma;
> +
> +	struct {
> +		int index;
> +		int offset;
> +		int len;
> +	} pio;
> +
> +	struct timer_list timer;
> +	struct tasklet_struct finish_task;
> +	struct tasklet_struct data_task;
> +
> +	struct platform_device *pdev;
> +	struct au1xmmc_platdata *platdata;
> +	int irq;
> +};
   Hm, do you need the above structure to be visible from the platform code?

WBR, Sergei


