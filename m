Return-Path: <linux-kernel-owner+w=401wt.eu-S1755714AbZIPS4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714AbZIPS4x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 14:56:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754528AbZIPS4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 14:56:49 -0400
Received: from mail-yx0-f171.google.com ([209.85.210.171]:35836 "EHLO
	mail-yx0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363AbZIPS4s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 14:56:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=P+3/VbM/siUX8dzZvi0OFxvryBfWWHggETGgQIyd98v0W3mPa1GUr9gy3rRmU4jHRw
         UmCJgzlsbkM6BxmEndo0kjREPJn6QRSDJ8kCdx38z6HEzx2fEmQbEf3v1Q6BHF9rw8af
         mCmbq7IQh4nJd4xXzcSdH9lwEKfjFH/TLYdoE=
MIME-Version: 1.0
In-Reply-To: <1253095348.25791.6.camel@eight.analog.com>
References: <1253095348.25791.6.camel@eight.analog.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 16 Sep 2009 14:56:29 -0400
Message-ID: <8bd0f97a0909161156x3cf83b51tb01f6c890abf8594@mail.gmail.com>
Subject: Re: [PATCH][uart] fit blackfin uart over sport driver into common 
	uart inftrastructure (v2)
To: sonic zhang <sonic.adi@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Serial <linux-serial@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 06:02, sonic zhang wrote:
> 3. Move most platform data into arch specific board files.

might as well do it right now since you've done most of it already.
i.e. all of the peripheral logic should be in the boards, not the
driver.  so the bfin_uart_pin_req_sportx lists should get moved to the
platform resources as well as the SPORT base addresses.

then we get proper device bindings between ttySS# and SPORT# by using
the .id field.  ttySS0 should always be SPORT0, ttySS1 should always
be SPORT1, etc...

> Signed-off-by: Michael Frysinger <michael.frysinger@analog.com>

you shouldnt add s-o-b tags for people who didnt opt for them ... i
was sleeping when you wrote, committed, and e-mailed out these
changes.  i also handt posted these changes yet because i knew there
were still issues to be worked out.

> --- a/drivers/serial/bfin_sport_uart.c
> +++ b/drivers/serial/bfin_sport_uart.c
> +#define DRV_NAME "bfin-sport-uart"
> +#define DEVICE_NAME    "ttySS"

should really use the dev_* functions for output rather than the pr_*
ones, but if you dont do that, you should add before the #include's:
#define pr_fmt(fmt) DRV_NAME ": " fmt

>        tclkdiv = sclk/(2 * baud_rate) - 1;
> -       tfsdiv = 12;
> -       rclkdiv = sclk/(2 * baud_rate * 3) - 1;
> +       rclkdiv = sclk/(2 * baud_rate * 2) - 1;

missing space around the "/"

> -static int sport_uart_suspend(struct platform_device *dev, pm_message_t state)
> +#ifdef CONFIG_PM
> +static int sport_uart_suspend(struct platform_device *pdev, pm_message_t state)
>  {
> -       struct sport_uart_port *sport = platform_get_drvdata(dev);
> +       struct sport_uart_port *sport = platform_get_drvdata(pdev);
>
> -       pr_debug("%s enter\n", __func__);
> +       dev_dbg(&pdev->dev, "%s enter\n", __func__);
>        if (sport)
>                uart_suspend_port(&sport_uart_reg, &sport->port);
>
>        return 0;
>  }
>
> -static int sport_uart_resume(struct platform_device *dev)
> +static int sport_uart_resume(struct platform_device *pdev)
>  {
> -       struct sport_uart_port *sport = platform_get_drvdata(dev);
> +       struct sport_uart_port *sport = platform_get_drvdata(pdev);
>
> -       pr_debug("%s enter\n", __func__);
> +       dev_dbg(&pdev->dev, "%s enter\n", __func__);
>        if (sport)
>                uart_resume_port(&sport_uart_reg, &sport->port);
>
>        return 0;
>  }

these need updating to the new dev_pm_opts structure.  see the changes
i just did to the adp558-keys driver for a simple example.

> --- a/drivers/serial/bfin_sport_uart.h
> +++ b/drivers/serial/bfin_sport_uart.h

while you're in here, you might as well add the proper #ifndef header protection
-mike
