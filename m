Return-Path: <linux-kernel-owner+w=401wt.eu-S1756682AbZHGNj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682AbZHGNj3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 09:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756182AbZHGNj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 09:39:28 -0400
Received: from mail-fx0-f228.google.com ([209.85.220.228]:44438 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674AbZHGNj1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 09:39:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RG8BIJokB/RdjhsIq6iuGc2xBGaXXTCRXb+e45zDmwpWbdeSOXc9/JReEmbRNK1chz
         jfScVyHOkEjNg/6pjNoRFWMElQ2hLyKm8Rhvow47BHgLgsQ56UrvuHwCTq6YM//gy8mG
         GnZ+ws42A/kEeZEOhUhxoiBcUOtVxPuGYgX+o=
MIME-Version: 1.0
In-Reply-To: <200908061719.44068.rjw@sisk.pl>
References: <1249496971-9019-1-git-send-email-daniel@caiaq.de>
	 <200908060251.55157.rjw@sisk.pl>
	 <20090806125909.GJ19257@buzzloop.caiaq.de>
	 <200908061719.44068.rjw@sisk.pl>
Date: Fri, 7 Aug 2009 15:39:26 +0200
Message-ID: <74d0deb30908070639y6e949d0dr9ebf2f6144130208@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 4/5] input: gpio-keys: switch to new dev_pm_ops
From: pHilipp Zabel <philipp.zabel@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Daniel Mack <daniel@caiaq.de>, linux-pm@lists.linux-foundation.org,
       Phil Blundell <pb@handhelds.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 6, 2009 at 5:19 PM, Rafael J. Wysocki<rjw@sisk.pl> wrote:
> On Thursday 06 August 2009, Daniel Mack wrote:
>> On Thu, Aug 06, 2009 at 02:51:55AM +0200, Rafael J. Wysocki wrote:
>> > On Thursday 06 August 2009, Daniel Mack wrote:
>> > > On Wed, Aug 05, 2009 at 10:15:52PM +0200, pHilipp Zabel wrote:
>> > > > On Wed, Aug 5, 2009 at 8:29 PM, Daniel Mack<daniel@caiaq.de> wrote:
>> > > > > -static int gpio_keys_resume(struct platform_device *pdev)
>> > > > > +static int gpio_keys_resume(struct device *dev)
>> > > > >  {
>> > > > > -       struct gpio_keys_platform_data *pdata = pdev->dev.platform_data;
>> > > > > +       struct gpio_keys_platform_data *pdata = dev->platform_data;
>> > > > >        int i;
>> > > > >
>> > > > > -       if (device_may_wakeup(&pdev->dev)) {
>> > > > > +       if (device_may_wakeup(dev)) {
>> > > > >                for (i = 0; i < pdata->nbuttons; i++) {
>> > > > >                        struct gpio_keys_button *button = &pdata->buttons[i];
>> > > > >                        if (button->wakeup) {
>> > > > > @@ -251,19 +251,27 @@ static int gpio_keys_resume(struct platform_device *pdev)
>> > > > >
>> > > > >        return 0;
>> > > > >  }
>> > > > > +
>> > > > > +static struct dev_pm_ops gpio_keys_pm_ops = {
>> > > > > +       .suspend        = gpio_keys_suspend,
>> > > > > +       .freeze         = gpio_keys_suspend,
>> > > > > +       .resume         = gpio_keys_resume,
>> > > > > +       .thaw           = gpio_keys_resume,
>> > > >
>> > > > I'm not sure I understand hibernation correctly, but isn't
>> > > > .freeze/.thaw about saving state and halting/resuming the device
>> > > > operation only?
>> >
>> > It is.
>> >
>> > > > It seems to me that enabling system wakeup functionality should go
>> > > > into .poweroff. (See <linux/pm.h>)
>> >
>> > That's correct.
>> >
>> > And .restore() plays the role of ".resume() from hibernation".
>>
>> Hence, In case of this driver which only calls disable_irq/enable_irq,
>> setting .poweroff and .restore seems to suffice?
>
> I'll have a look at the driver.  Still, it seems .suspend and .resume should be
> set too, shouldn't they?

.suspend/.resume need to be set. But I think .restore is not needed,
as the effects of calling enable_irq_wake in .poweroff are already
completely reverted by rebooting the system and restoring the memory
image that was captured before .poweroff was called.

>> From afa35cebccf49a24613e711afb8009fb6aadce0e Mon Sep 17 00:00:00 2001
>> From: Daniel Mack <daniel@caiaq.de>
>> Date: Wed, 5 Aug 2009 15:28:54 +0200
>> Subject: [PATCH 3/3] input: gpio-keys: switch to new dev_pm_ops
>>
>> The callbacks for the implemented functions are .poweroff and .restore,
>> as they only care for {dis,en}able_irq(). Renamed the functions
>> to reflect that.
>>
>> Signed-off-by: Daniel Mack <daniel@caiaq.de>
>> Cc: Phil Blundell <pb@handhelds.org>
>> Cc: linux-input@vger.kernel.org
>> ---
>>  drivers/input/keyboard/gpio_keys.c |   26 ++++++++++++++++----------
>>  1 files changed, 16 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/input/keyboard/gpio_keys.c b/drivers/input/keyboard/gpio_keys.c
>> index efed0c9..8e670d4 100644
>> --- a/drivers/input/keyboard/gpio_keys.c
>> +++ b/drivers/input/keyboard/gpio_keys.c
>> @@ -216,12 +216,12 @@ static int __devexit gpio_keys_remove(struct platform_device *pdev)
>>
>>
>>  #ifdef CONFIG_PM
>> -static int gpio_keys_suspend(struct platform_device *pdev, pm_message_t state)
>> +static int gpio_keys_poweroff(struct device *dev)
>>  {
>> -     struct gpio_keys_platform_data *pdata = pdev->dev.platform_data;
>> +     struct gpio_keys_platform_data *pdata = dev->platform_data;
>>       int i;
>>
>> -     if (device_may_wakeup(&pdev->dev)) {
>> +     if (device_may_wakeup(dev)) {
>>               for (i = 0; i < pdata->nbuttons; i++) {
>>                       struct gpio_keys_button *button = &pdata->buttons[i];
>>                       if (button->wakeup) {
>> @@ -234,12 +234,12 @@ static int gpio_keys_suspend(struct platform_device *pdev, pm_message_t state)
>>       return 0;
>>  }
>>
>> -static int gpio_keys_resume(struct platform_device *pdev)
>> +static int gpio_keys_restore(struct device *dev)
>>  {
>> -     struct gpio_keys_platform_data *pdata = pdev->dev.platform_data;
>> +     struct gpio_keys_platform_data *pdata = dev->platform_data;
>>       int i;
>>
>> -     if (device_may_wakeup(&pdev->dev)) {
>> +     if (device_may_wakeup(dev)) {
>>               for (i = 0; i < pdata->nbuttons; i++) {
>>                       struct gpio_keys_button *button = &pdata->buttons[i];
>>                       if (button->wakeup) {
>> @@ -251,19 +251,25 @@ static int gpio_keys_resume(struct platform_device *pdev)
>>
>>       return 0;
>>  }
>> +
>> +static struct dev_pm_ops gpio_keys_pm_ops = {
>> +     .poweroff       = gpio_keys_poweroff,
>> +     .restore        = gpio_keys_restore,
>
> Should .suspend and .resume really be NULL?
>
>> +};
>> +
>> +#define GPIO_KEYS_PM_OPS (&gpio_keys_pm_ops)
>> +
>>  #else
>> -#define gpio_keys_suspend    NULL
>> -#define gpio_keys_resume     NULL
>> +#define GPIO_KEYS_PM_OPS NULL
>>  #endif
>>
>>  static struct platform_driver gpio_keys_device_driver = {
>>       .probe          = gpio_keys_probe,
>>       .remove         = __devexit_p(gpio_keys_remove),
>> -     .suspend        = gpio_keys_suspend,
>> -     .resume         = gpio_keys_resume,
>>       .driver         = {
>>               .name   = "gpio-keys",
>>               .owner  = THIS_MODULE,
>> +             .pm     = GPIO_KEYS_PM_OPS,
>>       }
>>  };
>
> Thanks,
> Rafael
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

regards
Philipp
