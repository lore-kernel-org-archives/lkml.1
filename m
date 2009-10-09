Return-Path: <linux-kernel-owner+w=401wt.eu-S933666AbZJIP5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933666AbZJIP5W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 11:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932947AbZJIP5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 11:57:22 -0400
Received: from smtp.nokia.com ([192.100.105.134]:52887 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932688AbZJIP5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 11:57:21 -0400
Message-ID: <4ACF5CD7.8050306@nokia.com>
Date: Fri, 09 Oct 2009 18:55:03 +0300
From: Roger Quadros <ext-roger.quadros@nokia.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
CC: ext Roger Quadros <quadros.roger@gmail.com>,
       "tony@atomide.com" <tony@atomide.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>,
       Felipe Contreras <felipe.contreras@gmail.com>, jouni.hogander@nokia.com
Subject: Re: [PATCH v2] twl4030: Fix boot with twl4030 usb transceiver enabled
References: <1254385536-26912-1-git-send-email-ext-roger.quadros@nokia.com> <b90c0690910090532y60cced09j2c805a5a04dbcbb7@mail.gmail.com>
In-Reply-To: <b90c0690910090532y60cced09j2c805a5a04dbcbb7@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Oct 2009 15:55:43.0378 (UTC) FILETIME=[F50C1720:01CA48F8]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just observed that this patch does not work as intended with 2.6.31.3

It seems that twl4030_usb_probe() and hence twl4030_usb_ldo_init() is called 
before the required regulators have been 'linked' to the device in 
twl4030-core.c, thus causing regulator_get(twl->dev, "usb3v1"); to fail, and the 
boot lockup

Isn't there a better way to avoid such a situation?

cheers,
-roger

ext Roger Quadros wrote:
> Hi Samuel,
> 
> What is the status of this patch?
> Without this patch we are unable to boot on systems using musb usb controller.
> 
> cheers,
> -roger.
> 
> On Thu, Oct 1, 2009 at 11:25 AM, Roger Quadros
> <ext-roger.quadros@nokia.com> wrote:
>> The usb regulator supplies (usb1v5, usb1v8 & usb3v1) must be available
>> before adding the twl4030_usb child, else twl4030_usb_ldo_init() will
>> always fail thus causing boot lock-up.
>>
>> This patch fixes boot on OMAP systems using the twl4030 usb transceiver.
>> CONFIG_TWL4030_USB=y
>>
>> Signed-off-by: Roger Quadros <ext-roger.quadros@nokia.com>
>> ---
>>  drivers/mfd/twl4030-core.c |   89 ++++++++++++++++++++++---------------------
>>  1 files changed, 46 insertions(+), 43 deletions(-)
>>
>> diff --git a/drivers/mfd/twl4030-core.c b/drivers/mfd/twl4030-core.c
>> index e424cf6..e832e97 100644
>> --- a/drivers/mfd/twl4030-core.c
>> +++ b/drivers/mfd/twl4030-core.c
>> @@ -480,7 +480,6 @@ static int
>>  add_children(struct twl4030_platform_data *pdata, unsigned long features)
>>  {
>>        struct device   *child;
>> -       struct device   *usb_transceiver = NULL;
>>
>>        if (twl_has_bci() && pdata->bci && !(features & TPS_SUBSET)) {
>>                child = add_child(3, "twl4030_bci",
>> @@ -532,16 +531,61 @@ add_children(struct twl4030_platform_data *pdata, unsigned long features)
>>        }
>>
>>        if (twl_has_usb() && pdata->usb) {
>> +
>> +               static struct regulator_consumer_supply usb1v5 = {
>> +                       .supply =       "usb1v5",
>> +               };
>> +               static struct regulator_consumer_supply usb1v8 = {
>> +                       .supply =       "usb1v8",
>> +               };
>> +               static struct regulator_consumer_supply usb3v1 = {
>> +                       .supply =       "usb3v1",
>> +               };
>> +
>> +       /* First add the regulators so that they can be used by transceiver */
>> +               if (twl_has_regulator()) {
>> +                       /* this is a template that gets copied */
>> +                       struct regulator_init_data usb_fixed = {
>> +                               .constraints.valid_modes_mask =
>> +                                       REGULATOR_MODE_NORMAL
>> +                                       | REGULATOR_MODE_STANDBY,
>> +                               .constraints.valid_ops_mask =
>> +                                       REGULATOR_CHANGE_MODE
>> +                                       | REGULATOR_CHANGE_STATUS,
>> +                       };
>> +
>> +                       child = add_regulator_linked(TWL4030_REG_VUSB1V5,
>> +                                                     &usb_fixed, &usb1v5, 1);
>> +                       if (IS_ERR(child))
>> +                               return PTR_ERR(child);
>> +
>> +                       child = add_regulator_linked(TWL4030_REG_VUSB1V8,
>> +                                                     &usb_fixed, &usb1v8, 1);
>> +                       if (IS_ERR(child))
>> +                               return PTR_ERR(child);
>> +
>> +                       child = add_regulator_linked(TWL4030_REG_VUSB3V1,
>> +                                                     &usb_fixed, &usb3v1, 1);
>> +                       if (IS_ERR(child))
>> +                               return PTR_ERR(child);
>> +
>> +               }
>> +
>>                child = add_child(0, "twl4030_usb",
>>                                pdata->usb, sizeof(*pdata->usb),
>>                                true,
>>                                /* irq0 = USB_PRES, irq1 = USB */
>>                                pdata->irq_base + 8 + 2, pdata->irq_base + 4);
>> +
>>                if (IS_ERR(child))
>>                        return PTR_ERR(child);
>>
>>                /* we need to connect regulators to this transceiver */
>> -               usb_transceiver = child;
>> +               if (twl_has_regulator() && child) {
>> +                       usb1v5.dev = child;
>> +                       usb1v8.dev = child;
>> +                       usb3v1.dev = child;
>> +               }
>>        }
>>
>>        if (twl_has_watchdog()) {
>> @@ -580,47 +624,6 @@ add_children(struct twl4030_platform_data *pdata, unsigned long features)
>>                        return PTR_ERR(child);
>>        }
>>
>> -       if (twl_has_regulator() && usb_transceiver) {
>> -               static struct regulator_consumer_supply usb1v5 = {
>> -                       .supply =       "usb1v5",
>> -               };
>> -               static struct regulator_consumer_supply usb1v8 = {
>> -                       .supply =       "usb1v8",
>> -               };
>> -               static struct regulator_consumer_supply usb3v1 = {
>> -                       .supply =       "usb3v1",
>> -               };
>> -
>> -               /* this is a template that gets copied */
>> -               struct regulator_init_data usb_fixed = {
>> -                       .constraints.valid_modes_mask =
>> -                                 REGULATOR_MODE_NORMAL
>> -                               | REGULATOR_MODE_STANDBY,
>> -                       .constraints.valid_ops_mask =
>> -                                 REGULATOR_CHANGE_MODE
>> -                               | REGULATOR_CHANGE_STATUS,
>> -               };
>> -
>> -               usb1v5.dev = usb_transceiver;
>> -               usb1v8.dev = usb_transceiver;
>> -               usb3v1.dev = usb_transceiver;
>> -
>> -               child = add_regulator_linked(TWL4030_REG_VUSB1V5, &usb_fixed,
>> -                               &usb1v5, 1);
>> -               if (IS_ERR(child))
>> -                       return PTR_ERR(child);
>> -
>> -               child = add_regulator_linked(TWL4030_REG_VUSB1V8, &usb_fixed,
>> -                               &usb1v8, 1);
>> -               if (IS_ERR(child))
>> -                       return PTR_ERR(child);
>> -
>> -               child = add_regulator_linked(TWL4030_REG_VUSB3V1, &usb_fixed,
>> -                               &usb3v1, 1);
>> -               if (IS_ERR(child))
>> -                       return PTR_ERR(child);
>> -       }
>> -
>>        /* maybe add LDOs that are omitted on cost-reduced parts */
>>        if (twl_has_regulator() && !(features & TPS_SUBSET)) {
>>                child = add_regulator(TWL4030_REG_VPLL2, pdata->vpll2);
>> --
>> 1.6.0.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

