Return-Path: <linux-kernel-owner+w=401wt.eu-S1752059AbZIRFAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059AbZIRFAI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 01:00:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751967AbZIRFAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 01:00:07 -0400
Received: from mail-yw0-f175.google.com ([209.85.211.175]:46785 "EHLO
	mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbZIRFAF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 01:00:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Dnpq79fz5zWD9dkgcyEewLS8+YmNeY28sJvrbyGE7ciL1W4ec8MWB9KJKj22jAv07I
         RnT2tJVokEOxlKiCe9cYYNr2LzUiIeyJ0Ty+db/lJO9WzUcKO0cS2BcaZQ0c4Gq6X7rp
         bC25oJ3bffaotlRDkUIyGif4zbo3zLpkL6QmI=
MIME-Version: 1.0
In-Reply-To: <8bd0f97a0909161156x3cf83b51tb01f6c890abf8594@mail.gmail.com>
References: <1253095348.25791.6.camel@eight.analog.com>
	 <8bd0f97a0909161156x3cf83b51tb01f6c890abf8594@mail.gmail.com>
Date: Fri, 18 Sep 2009 12:54:29 +0800
Message-ID: <4e5ebad50909172154m3c6450f2u7512f20ee3f1951e@mail.gmail.com>
Subject: Re: [PATCH][uart] fit blackfin uart over sport driver into common 
	uart inftrastructure (v2)
From: Sonic Zhang <sonic.adi@gmail.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Serial <linux-serial@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 2:56 AM, Mike Frysinger <vapier.adi@gmail.com> wrote:
> On Wed, Sep 16, 2009 at 06:02, sonic zhang wrote:
>> 3. Move most platform data into arch specific board files.
>
> might as well do it right now since you've done most of it already.
> i.e. all of the peripheral logic should be in the boards, not the
> driver.  so the bfin_uart_pin_req_sportx lists should get moved to the
> platform resources as well as the SPORT base addresses.

No. You can't. Because the console is registered and running much
earlier than the platform data is initialized. You have to know the
peripheral lists and base address before registering the console.


>
> then we get proper device bindings between ttySS# and SPORT# by using
> the .id field.  ttySS0 should always be SPORT0, ttySS1 should always
> be SPORT1, etc...

You can't either. Because the index of tty devices is increased
automatically when you successfully register a uart port.  If sport0
is used for devices other than uart, uart over sport1 is always bond
to ttySS0.


>
>> Signed-off-by: Michael Frysinger <michael.frysinger@analog.com>
>
> you shouldnt add s-o-b tags for people who didnt opt for them ... i
> was sleeping when you wrote, committed, and e-mailed out these
> changes.  i also handt posted these changes yet because i knew there
> were still issues to be worked out.

OK. I mean you also did some cleanup to this patch.

>
>> --- a/drivers/serial/bfin_sport_uart.c
>> +++ b/drivers/serial/bfin_sport_uart.c
>> +#define DRV_NAME "bfin-sport-uart"
>> +#define DEVICE_NAME    "ttySS"
>
> should really use the dev_* functions for output rather than the pr_*
> ones, but if you dont do that, you should add before the #include's:
> #define pr_fmt(fmt) DRV_NAME ": " fmt
>
>>        tclkdiv = sclk/(2 * baud_rate) - 1;
>> -       tfsdiv = 12;
>> -       rclkdiv = sclk/(2 * baud_rate * 3) - 1;
>> +       rclkdiv = sclk/(2 * baud_rate * 2) - 1;
>
> missing space around the "/"
>

OK.

>> -static int sport_uart_suspend(struct platform_device *dev, pm_message_t state)
>> +#ifdef CONFIG_PM
>> +static int sport_uart_suspend(struct platform_device *pdev, pm_message_t state)
>>  {
>> -       struct sport_uart_port *sport = platform_get_drvdata(dev);
>> +       struct sport_uart_port *sport = platform_get_drvdata(pdev);
>>
>> -       pr_debug("%s enter\n", __func__);
>> +       dev_dbg(&pdev->dev, "%s enter\n", __func__);
>>        if (sport)
>>                uart_suspend_port(&sport_uart_reg, &sport->port);
>>
>>        return 0;
>>  }
>>
>> -static int sport_uart_resume(struct platform_device *dev)
>> +static int sport_uart_resume(struct platform_device *pdev)
>>  {
>> -       struct sport_uart_port *sport = platform_get_drvdata(dev);
>> +       struct sport_uart_port *sport = platform_get_drvdata(pdev);
>>
>> -       pr_debug("%s enter\n", __func__);
>> +       dev_dbg(&pdev->dev, "%s enter\n", __func__);
>>        if (sport)
>>                uart_resume_port(&sport_uart_reg, &sport->port);
>>
>>        return 0;
>>  }
>
> these need updating to the new dev_pm_opts structure.  see the changes
> i just did to the adp558-keys driver for a simple example.

OK.

>
>> --- a/drivers/serial/bfin_sport_uart.h
>> +++ b/drivers/serial/bfin_sport_uart.h
>
> while you're in here, you might as well add the proper #ifndef header protection
> -mike
>

OK.

Sonic Zhang
