Return-Path: <linux-kernel-owner+w=401wt.eu-S1761547AbYDSCef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761547AbYDSCef (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 22:34:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753566AbYDSCe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 22:34:27 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:54226 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753092AbYDSCe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 22:34:26 -0400
Date: Fri, 18 Apr 2008 22:34:13 -0400
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH] atmel_lcdfb: fix negative check on unsigned
Message-ID: <20080418223413.2445b970@siona.local>
In-Reply-To: <4806D2A0.3080207@tiscali.nl>
References: <4806D2A0.3080207@tiscali.nl>
Organization: Atmel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc'ing the atmel_lcdfb maintainer...

On Thu, 17 Apr 2008 06:31:28 +0200
Roel Kluin <12o3l@tiscali.nl> wrote:

> No signed negative values will get noticed
> 
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
> ---
> diff --git a/drivers/video/atmel_lcdfb.c b/drivers/video/atmel_lcdfb.c
> index fc65c02..4b927da 100644
> --- a/drivers/video/atmel_lcdfb.c
> +++ b/drivers/video/atmel_lcdfb.c
> @@ -422,13 +422,13 @@ static int atmel_lcdfb_set_par(struct fb_info *info)
>  
>  	value = DIV_ROUND_UP(clk_value_khz, PICOS2KHZ(info->var.pixclock));
>  
> -	value = (value / 2) - 1;
> -	dev_dbg(info->device, "  * programming CLKVAL = 0x%08lx\n", value);
> -
> -	if (value <= 0) {
> +	if ((value / 2) <= 1) {
> +		dev_dbg(info->device, "  * programming CLKVAL = 0x%08lx\n", (value/2)-1);

Makes sense...although I think there's another patch in the queue that
fixes this as well.

>  		dev_notice(info->device, "Bypassing pixel clock divider\n");
>  		lcdc_writel(sinfo, ATMEL_LCDC_LCDCON1, ATMEL_LCDC_BYPASS);
>  	} else {
> +		value = (value / 2) - 1;
> +		dev_dbg(info->device, "  * programming CLKVAL = 0x%08lx\n", value);
>  		lcdc_writel(sinfo, ATMEL_LCDC_LCDCON1, value << ATMEL_LCDC_CLKVAL_OFFSET);
>  		info->var.pixclock = KHZ2PICOS(clk_value_khz / (2 * (value + 1)));
>  		dev_dbg(info->device, "  updated pixclk:     %lu KHz\n",

Haavard
