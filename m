Return-Path: <linux-kernel-owner+w=401wt.eu-S1751650AbZLOFiL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650AbZLOFiL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 00:38:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751544AbZLOFiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 00:38:08 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:36273 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbZLOFiD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 00:38:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DhpwMLeuNq/l052NzGaIu0wQGKmuS/x8UnJ3+vpSv39SDK2kWN8Hjp3bxvg0T+Jn2p
         47lN5w3cHYql21eYpZmtV1CtVFKmXAAlCPPuyQYz1CWZd+FqJVPA1aujJzGoEyad60MB
         PvTcbN99oMNX2x+fIgdEQm93XfPkjlNl+O9aI=
MIME-Version: 1.0
In-Reply-To: <20091213221222.724bef54@hyperion.delvare>
References: <1259744920.25505.2.camel@eight.analog.com>
	 <20091213221222.724bef54@hyperion.delvare>
Date: Tue, 15 Dec 2009 13:38:03 +0800
Message-ID: <4e5ebad50912142138he6eea0bqd790313c72b69f7@mail.gmail.com>
Subject: Re: [PATCH] driver i2c-core: i2c bus should support PM entries in 
	struct dev_pm_ops.
From: Sonic Zhang <sonic.adi@gmail.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-i2c@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You changes to the patch work OK for me.


Sonic Zhang


On Mon, Dec 14, 2009 at 5:12 AM, Jean Delvare <khali@linux-fr.org> wrote:
> Hi Sonic,
>
> On Wed, 2 Dec 2009 17:08:40 +0800, sonic zhang wrote:
>> Struct dev_pm_ops is not configured in current i2c bus type. i2c drivers
>> only depends on suspend/resume entries in struct dev_pm_ops are not
>> informed of PM suspend and resume events by i2c framework.
>
> Good point. I was wondering some times ago what was the status of
> pm_ops. I seem to understand this is the future of power management,
> and "direct" .suspend and .resume callbacks will stop being supported
> at some point in the future? If so, what is the migration plan? I don't
> really want to support both forever.
>
> Your patch introduces the following warnings:
>
> drivers/i2c/i2c-core.c: In function ‘i2c_device_pm_suspend’:
> drivers/i2c/i2c-core.c:167: warning: assignment discards qualifiers from pointer target type
> drivers/i2c/i2c-core.c: In function ‘i2c_device_pm_resume’:
> drivers/i2c/i2c-core.c:181: warning: assignment discards qualifiers from pointer target type
>
> You will obviously have to fix them before I can accept your patch.
> Missing const...
>
>>
>> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
>> ---
>>  drivers/i2c/i2c-core.c |   39 +++++++++++++++++++++++++++++++++++++++
>>  1 files changed, 39 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
>> index 2965043..9713c0d 100644
>> --- a/drivers/i2c/i2c-core.c
>> +++ b/drivers/i2c/i2c-core.c
>> @@ -155,6 +155,39 @@ static void i2c_device_shutdown(struct device *dev)
>>               driver->shutdown(client);
>>  }
>>
>> +#ifdef CONFIG_SUSPEND
>> +static int i2c_device_pm_suspend(struct device *dev)
>> +{
>> +     struct i2c_driver *driver;
>> +     struct dev_pm_ops *pm;
>> +
>> +     if (!dev->driver)
>> +             return 0;
>> +     driver = to_i2c_driver(dev->driver);
>> +     pm = driver->driver.pm;
>
> This makes little sense, sorry. Why go from device_driver to i2c_driver
> and then again to device_driver? The following is equivalent and more
> efficient:
>
>        pm = dev->driver->pm;
>
>> +     if (!pm || !pm->suspend)
>> +             return 0;
>> +     return pm->suspend(dev);
>> +}
>> +
>> +static int i2c_device_pm_resume(struct device *dev)
>> +{
>> +     struct i2c_driver *driver;
>> +     struct dev_pm_ops *pm;
>> +
>> +     if (!dev->driver)
>> +             return 0;
>> +     driver = to_i2c_driver(dev->driver);
>> +     pm = driver->driver.pm;
>
> Same here.
>
>> +     if (!pm || !pm->resume)
>> +             return 0;
>> +     return pm->resume(dev);
>> +}
>> +#else
>> +# define i2c_device_pm_suspend       NULL
>> +# define i2c_device_pm_resume        NULL
>
> No space between "#" and "define", please.
>
>> +#endif
>> +
>>  static int i2c_device_suspend(struct device *dev, pm_message_t mesg)
>>  {
>>       struct i2c_client *client = i2c_verify_client(dev);
>> @@ -219,6 +252,11 @@ static const struct attribute_group *i2c_dev_attr_groups[] = {
>>       NULL
>>  };
>>
>> +static struct dev_pm_ops i2c_device_pm_ops = {
>
> Could be const.
>
>> +     .suspend = i2c_device_pm_suspend,
>> +     .resume = i2c_device_pm_resume,
>> +};
>> +
>>  struct bus_type i2c_bus_type = {
>>       .name           = "i2c",
>>       .match          = i2c_device_match,
>> @@ -227,6 +265,7 @@ struct bus_type i2c_bus_type = {
>>       .shutdown       = i2c_device_shutdown,
>>       .suspend        = i2c_device_suspend,
>>       .resume         = i2c_device_resume,
>> +     .pm             = &i2c_device_pm_ops,
>>  };
>>  EXPORT_SYMBOL_GPL(i2c_bus_type);
>>
>
> I've made all the changes above myself, it build OK but I can't test.
> Modified patch is here:
> ftp://ftp.kernel.org/pub/linux/kernel/people/jdelvare/linux-2.6/jdelvare-i2c/i2c-core-i2c-bus-should-support-pm-entries-in-struct-dev_pm_ops.patch
>
> Please test and report if anything's wrong.
>
> Thanks,
> --
> Jean Delvare
>
