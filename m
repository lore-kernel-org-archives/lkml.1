Return-Path: <linux-kernel-owner+w=401wt.eu-S1757334AbYCMUh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334AbYCMUh4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 16:37:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754540AbYCMUhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 16:37:48 -0400
Received: from smtp112.sbc.mail.mud.yahoo.com ([68.142.198.211]:42147 "HELO
	smtp112.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754532AbYCMUhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 16:37:47 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Q/MZNnLQ1aPIiCHlzUCQBLSfMRtbvyYvkd+B+fDrpvlTIlPWaDbcYL70cFwEJvlGZHlLKjHDUimsBJZm91ggnXLguBlERUNJMIpxBPXuvdZFLvkepBbVbtE/oCS95J/OTPmFh36qdvlxgPtupfRL4/5fjScD6i0RldmgoLbWqEA=  ;
X-YMail-OSG: n6o7wmAVM1km9iOv3kevYDRL5xZRQicM.pkzHI4Wckc5Hy0M_ActKp6cGg3TScezZMgSXbD3bQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: [PATCH 02/10] atmel_serial: Fix build on avr32 with CONFIG_PM enabled
Date: Thu, 13 Mar 2008 12:37:40 -0800
User-Agent: KMail/1.9.6
Cc: kernel@avr32linux.org, linux-kernel@vger.kernel.org
References: <> <1205419185-26395-2-git-send-email-hskinnemoen@atmel.com> <1205419185-26395-3-git-send-email-hskinnemoen@atmel.com>
In-Reply-To: <1205419185-26395-3-git-send-email-hskinnemoen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803131337.41337.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 March 2008, Haavard Skinnemoen wrote:
> AVR32 doesn't have at91_suspend_entering_slow_clock(). Just assume the
> clock will keep running for now.

Well, it should acquire the clk_must_disable() or somesuch... :)

By the way, I noticed a goof in this driver's clock management.
It should leave the clock off whenever the device isn't open.
As it is, it wastes power both at runtime and during suspend.

- Dave


> Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
> ---
>  drivers/serial/atmel_serial.c |   11 ++++++++++-
>  1 files changed, 10 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/serial/atmel_serial.c b/drivers/serial/atmel_serial.c
> index d57bf3e..2efbdf6 100644
> --- a/drivers/serial/atmel_serial.c
> +++ b/drivers/serial/atmel_serial.c
> @@ -1428,6 +1428,15 @@ static struct uart_driver atmel_uart = {
>  };
>  
>  #ifdef CONFIG_PM
> +static bool atmel_serial_clk_will_stop(void)
> +{
> +#ifdef CONFIG_ARCH_AT91
> +	return at91_suspend_entering_slow_clock();
> +#else
> +	return false;
> +#endif
> +}
> +
>  static int atmel_serial_suspend(struct platform_device *pdev,
>  				pm_message_t state)
>  {
> @@ -1435,7 +1444,7 @@ static int atmel_serial_suspend(struct platform_device *pdev,
>  	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
>  
>  	if (device_may_wakeup(&pdev->dev)
> -	    && !at91_suspend_entering_slow_clock())
> +	    && !atmel_serial_clk_will_stop())
>  		enable_irq_wake(port->irq);
>  	else {
>  		uart_suspend_port(&atmel_uart, port);
> -- 
> 1.5.4.3
> 


