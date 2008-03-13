Return-Path: <linux-kernel-owner+w=401wt.eu-S1757185AbYCMUTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757185AbYCMUTP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 16:19:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753792AbYCMUS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 16:18:59 -0400
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:27909 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754035AbYCMUS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 16:18:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=WbS5NYtGUrNueN4OS3uoBBKa6Vz2WkHMSNSvME3wRA2q7eYn304oAuTXsGGfGKEsnAnOlCrZV01LWrDmD0tKDU4ns5AC8teHv92DJ1xLRBfIxzdbdou+9npOSa8Zg1SvuyRe4mULa7/QVaAr0T9GY0CmIYw5LDdM8O8ee01WYsw=  ;
X-YMail-OSG: ErDxcD8VM1m_cqGVoqb4t2r3g6VAL2_oPU_abknXigFtJlqXM4EwFzAc_Ypkv02A77ZQwZ7Jag--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: [PATCH 07/10] macb: Basic suspend/resume support
Date: Thu, 13 Mar 2008 12:18:56 -0800
User-Agent: KMail/1.9.6
Cc: kernel@avr32linux.org, linux-kernel@vger.kernel.org
References: <> <1205419185-26395-7-git-send-email-hskinnemoen@atmel.com> <1205419185-26395-8-git-send-email-hskinnemoen@atmel.com>
In-Reply-To: <1205419185-26395-8-git-send-email-hskinnemoen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803131318.56769.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 March 2008, Haavard Skinnemoen wrote:
> ---
>  drivers/net/macb.c |   37 +++++++++++++++++++++++++++++++++++++
>  1 files changed, 37 insertions(+), 0 deletions(-)

Shouldn't this look more like the suspend/resume support
in drivers/net/arm/at91_ether.c ?  I don't see calls to
netif_stop_queue()/netif_start_queue(), among other things.

The fact that this driver leaves the peripheral clocked
when it's not open is a minor PM goof; ditto not using
the PHY irq to track connect/disconnect.  But that's just
general PM stuff, not specific to suspend/resume support.

- Dave


> diff --git a/drivers/net/macb.c b/drivers/net/macb.c
> index 1d210ed..94bf2ba 100644
> --- a/drivers/net/macb.c
> +++ b/drivers/net/macb.c
> @@ -1275,8 +1275,45 @@ static int __exit macb_remove(struct platform_device *pdev)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_PM
> +static int macb_suspend(struct platform_device *pdev, pm_message_t state)
> +{
> +	struct net_device *netdev = platform_get_drvdata(pdev);
> +	struct macb *bp = netdev_priv(netdev);
> +
> +	netif_device_detach(netdev);
> +
> +#ifndef CONFIG_ARCH_AT91
> +	clk_disable(bp->hclk);
> +#endif
> +	clk_disable(bp->pclk);
> +
> +	return 0;
> +}
> +
> +static int macb_resume(struct platform_device *pdev)
> +{
> +	struct net_device *netdev = platform_get_drvdata(pdev);
> +	struct macb *bp = netdev_priv(netdev);
> +
> +	clk_enable(bp->pclk);
> +#ifndef CONFIG_ARCH_AT91
> +	clk_enable(bp->hclk);
> +#endif
> +
> +	netif_device_attach(netdev);
> +
> +	return 0;
> +}
> +#else
> +#define macb_suspend	NULL
> +#define macb_resume	NULL
> +#endif
> +
>  static struct platform_driver macb_driver = {
>  	.remove		= __exit_p(macb_remove),
> +	.suspend	= macb_suspend,
> +	.resume		= macb_resume,
>  	.driver		= {
>  		.name		= "macb",
>  	},
> -- 
> 1.5.4.3
> 


