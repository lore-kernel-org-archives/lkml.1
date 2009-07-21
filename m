Return-Path: <linux-kernel-owner+w=401wt.eu-S1752254AbZGUFMO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254AbZGUFMO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 01:12:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751512AbZGUFMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 01:12:13 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:62349 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbZGUFMN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 01:12:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fkSN0u8V0dtrBAVAtJaGqHUGsYTDcPjSyh06aCNXR1tuSG1oX5dk0OSZbzPdVKFQLs
         +g6IJpHaJdp4DOfE2dkpe+efsAXO+yGGsdHk5O2eNhzySaSXAeWFAyeHnAPQ01vcueg2
         35FMFQzMW8D8n6qg+HVXDOh9doWoG7FYcienA=
MIME-Version: 1.0
In-Reply-To: <200907202200.39288.elendil@planet.nl>
References: <1248115882-20221-1-git-send-email-manuel.lauss@gmail.com>
	 <200907202200.39288.elendil@planet.nl>
Date: Tue, 21 Jul 2009 07:12:11 +0200
Message-ID: <f861ec6f0907202212h4b28982fjcb9787a3915d7ee7@mail.gmail.com>
Subject: Re: [PATCH] au1xmmc: dev_pm_ops conversion
From: Manuel Lauss <manuel.lauss@googlemail.com>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
       manuel.lauss@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good Morning Frans,

On Mon, Jul 20, 2009 at 10:00 PM, Frans Pop<elendil@planet.nl> wrote:
>> Signed-off-by: Manuel Lauss <manuel.lauss@gmail.com>
>> ---
>> Run-tested on Au1200.
>>
>>  drivers/mmc/host/au1xmmc.c |   23 +++++++++++------------
>>  1 files changed, 11 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/mmc/host/au1xmmc.c b/drivers/mmc/host/au1xmmc.c
>> index d3f5561..70509c9 100644
>> --- a/drivers/mmc/host/au1xmmc.c
>> +++ b/drivers/mmc/host/au1xmmc.c
>> @@ -1131,13 +1131,12 @@ static int __devexit au1xmmc_remove(struct
>> platform_device *pdev) return 0;
>>  }
>>
>> -#ifdef CONFIG_PM
>
> Won't the removal of this test cause a build failure if CONFIG_PM is not
> set? If the removal of the test is safe, this should IMHO at least be
> explained in the commit message.

No, it builds just fine without CONFIG_PM; it was there to shave off a
few bytes from the kernel image.  But not everyone tests this driver
with CONFIG_PM=y, because apparently noone really needed PM on
this platform (Alchemy), and a full build of most of the boards using this
driver fails with PM enabled.

This way the PM methods at least get a compile-test in the non-pm case.


>> -static int au1xmmc_suspend(struct platform_device *pdev, pm_message_t
>> state) +static int au1xmmc_suspend(struct device *dev)
>>  {
>> -       struct au1xmmc_host *host = platform_get_drvdata(pdev);
>> +       struct au1xmmc_host *host = dev_get_drvdata(dev);
>>         int ret;
>>
>> -       ret = mmc_suspend_host(host->mmc, state);
>> +       ret = mmc_suspend_host(host->mmc, PMSG_SUSPEND);
>>         if (ret)
>>                 return ret;
>>
>> @@ -1150,27 +1149,27 @@ static int au1xmmc_suspend(struct
>> platform_device *pdev, pm_message_t state) return 0;
>>  }
>>
>> -static int au1xmmc_resume(struct platform_device *pdev)
>> +static int au1xmmc_resume(struct device *dev)
>>  {
>> -       struct au1xmmc_host *host = platform_get_drvdata(pdev);
>> +       struct au1xmmc_host *host = dev_get_drvdata(dev);
>>
>>         au1xmmc_reset_controller(host);
>>
>>         return mmc_resume_host(host->mmc);
>>  }
>> -#else
>> -#define au1xmmc_suspend NULL
>> -#define au1xmmc_resume NULL
>
> ... drop the 3 lines above (as you did) ...
>
>> -#endif
>
> ... move this #endif to after the new struct below ...
>
>> +
>> +static struct dev_pm_ops au1xmmc_pmops = {
>> +       .resume         = au1xmmc_resume,
>> +       .suspend        = au1xmmc_suspend,
>> +};
>>
>>  static struct platform_driver au1xmmc_driver = {
>>         .probe         = au1xmmc_probe,
>>         .remove        = au1xmmc_remove,
>> -       .suspend       = au1xmmc_suspend,
>> -       .resume        = au1xmmc_resume,
>>         .driver        = {
>>                 .name  = DRIVER_NAME,
>>                 .owner = THIS_MODULE,
>> +               .pm    = &au1xmmc_pmops,

I like what Magnus Damm did for some of the SuperH drivers:

#ifdef CONFIG_PM
[...]
#define DRIVER_PM_OPS (&driver_pm_ops)
#else
#define DRIVER_PM_OPS NULL
#endif

...
      .driver = {
...
             .pm = DRIVER_PM_OPS,
      }
...

I'd like to keep the pm stuff enabled at all times since it doesn't hurt
in the non-pm case and if kernel size becomes a problem I can add the
#defines back.

What do you think?

Thank you!
      Manuel Lauss
