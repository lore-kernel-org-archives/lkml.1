Return-Path: <linux-kernel-owner+w=401wt.eu-S1752412AbZGaRiE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412AbZGaRiE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 13:38:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751318AbZGaRiD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 13:38:03 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:39670 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbZGaRiC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 13:38:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dOa+xSXCp2D/cd4EWaEmWo8KycHKgummKRbybFvNBIff+H21FvkjVhRmkqKo4vXR1K
         Sc2E2fKIkSuHsc1VFtp7K3V7SjPmm14YnrGCjvUBBKyIjQ49mvHruQPyK0NO4v/97GTh
         6bKj51bWZRiqRZx1sCmYveqxTUWDdf6mumpI8=
MIME-Version: 1.0
In-Reply-To: <20090731172002.GA32578@rakim.wolfsonmicro.main>
References: <1249057189-11992-1-git-send-email-quadros.roger@gmail.com>
	 <20090731172002.GA32578@rakim.wolfsonmicro.main>
Date: Fri, 31 Jul 2009 19:38:00 +0200
Message-ID: <74d0deb30907311038w1b6cdd23iec3cfb2175fdedd0@mail.gmail.com>
Subject: Re: [PATCH v2] regulator: Add GPIO enable control to fixed voltage 
	regulator driver
From: pHilipp Zabel <philipp.zabel@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Roger Quadros <quadros.roger@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 31, 2009 at 7:20 PM, Mark
Brown<broonie@opensource.wolfsonmicro.com> wrote:
> On Fri, Jul 31, 2009 at 07:19:49PM +0300, Roger Quadros wrote:
>
>> Signed-off-by: Roger Quadros <ext-roger.quadros@nokia.com>
>> Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
>
> Err...  no, it isn't.  I reviewed a previous version of the patch but
> there were some issues that needed fixing.  I've not reviewed this
> version.
>
>>  static int fixed_voltage_is_enabled(struct regulator_dev *dev)
>>  {
>> -     return 1;
>> +     struct fixed_voltage_data *data = rdev_get_drvdata(dev);
>> +
>> +     if (data->gpio)
>> +             return data->is_enabled;
>
> Please use gpio_is_valid() as Phillip previously suggested.  For this
> particular use you could simplify the code marginally by just setting
> is_enabled at probe() time if there's no GPIO, not that it really
> matters.
>
>> +       if (data->gpio) {
>> +               gpio_set_value(data->gpio,
>> +                               data->enable_high ? 1 : 0);
>
> _cansleep(), please, as previously requested.
>
>> +             ret = gpio_get_value(config->gpio);
>
> Can this fail?  It returns an int...

No, gpio_get_value(_cansleep) return either zero or non-zero.
I think some I2C gpio chips just return zero when the read fails.
Also that's the return value if a gpiochip doesn't define the .get method.

Only problem: drivers/gpio/gpiolib.c contains this piece of wisdom:

/* Drivers MUST set GPIO direction before making get/set calls.  In
 * some cases this is done in early boot, before IRQs are enabled.
 [...]
 */

>> +             ret = gpio_direction_output(config->gpio, ret);
>> +             if (ret) {
>> +                     dev_err(&pdev->dev, "Could not configure "
>> +                             "enable GPIO %d direction: %d\n",
>> +                                             config->gpio, ret);
>> +                     goto err_gpio;
>
> As previously requested please don't split for log messages text over
> lines unless you have to.  It makes it easier to find the message from a
> kernel log - grep for 'configure enable GPIO' won't match this source
> file the way you've written it above.
>
>> +             }
>> +     } else
>> +             dev_warn(&pdev->dev, "Not using GPIO 0 for enable control\n");
>
> Probably better to soldier on and use the GPIO here but either way is
> fine; the warning is for the benefit of existing out of tree users to
> help them transition gracefully.
>

regards
Philipp
