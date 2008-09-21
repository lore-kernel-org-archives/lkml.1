Return-Path: <linux-kernel-owner+w=401wt.eu-S1753048AbYIUTnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048AbYIUTnu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 15:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752114AbYIUTni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 15:43:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:53355 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048AbYIUTnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 15:43:37 -0400
Date: Sun, 21 Sep 2008 12:43:32 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Johannes Berg <johannes@sipsolutions.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, ipw2100-devel@lists.sourceforge.net,
       linux-wireless@vger.kernel.org, yi.zhu@intel.com,
       reinette.chatre@intel.com, jgarzik@pobox.com, linville@tuxdriver.com,
       davem@davemloft.net
Subject: Re: Mark IPW2100 as BROKEN: Fatal interrupt. Scheduling firmware
 restart.
Message-ID: <20080921124332.67ddc13a@infradead.org>
In-Reply-To: <20080921193809.GA8735@2ka.mipt.ru>
References: <20080921172316.GA6306@2ka.mipt.ru>
	<20080921110422.1d010b96@infradead.org>
	<20080921182835.GA11473@2ka.mipt.ru>
	<20080921113513.16677c4e@infradead.org>
	<20080921190050.GA20484@2ka.mipt.ru>
	<1222024444.3023.53.camel@johannes.berg>
	<20080921193809.GA8735@2ka.mipt.ru>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Sep 2008 23:38:09 +0400
Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:

> 
> As I pointed, I can rewrite the whole driver's initialization process,
> so that it looked like init/wait/exit loop, which can be processed at
> the module load and when fatal interrupt fires. 

yes please do this.

> 
> I do hope this will result in a progress. Arjan, do you aggree to add
> this patch to the current tree?
> 
> diff --git a/drivers/net/wireless/ipw2100.c
> b/drivers/net/wireless/ipw2100.c index 19a401c..9a7b64c 100644
> --- a/drivers/net/wireless/ipw2100.c
> +++ b/drivers/net/wireless/ipw2100.c
> @@ -206,6 +206,8 @@ MODULE_PARM_DESC(disable, "manually disable the
> radio (default 0 [radio on])"); 
>  static u32 ipw2100_debug_level = IPW_DL_NONE;
>  
> +static int ipw2100_max_fatal_ints = 10;
> +
>  #ifdef CONFIG_IPW2100_DEBUG
>  #define IPW_DEBUG(level, message...) \
>  do { \
> @@ -3174,6 +3176,10 @@ static void ipw2100_irq_tasklet(struct
> ipw2100_priv *priv) if (inta & IPW2100_INTA_FATAL_ERROR) {
>  		printk(KERN_WARNING DRV_NAME
>  		       ": Fatal interrupt. Scheduling firmware
> restart.\n");
> +		WARN_ON(1);
> +
> +		BUG_ON(ipw2100_max_fatal_ints-- <= 0);

BUG_ON in interrupt context is just extremely hostile, since it means
the box is dead.

also I would suggest using WARN_ON_ONCE() 

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
