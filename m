Return-Path: <linux-kernel-owner+w=401wt.eu-S1755717AbYJWJ43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717AbYJWJ43 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 05:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbYJWJ4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 05:56:19 -0400
Received: from smtp-out.neti.ee ([194.126.126.37]:37340 "EHLO smtp-out.neti.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826AbYJWJ4S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 05:56:18 -0400
Message-ID: <49004A2E.7020701@liewenthal.ee>
Date: Thu, 23 Oct 2008 12:55:58 +0300
From: =?ISO-8859-1?Q?J=FCri_Reitel?= <juri.reitel@liewenthal.ee>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: linux-kernel@vger.kernel.org,
       Alessandro Zummo <alessandro.zummo@towertech.it>,
       rtc-linux@googlegroups.com
Subject: Re: [rtc-linux] Re: invalid default values in RTC chip
References: <48F45FA5.6040308@liewenthal.ee> <200810161522.26098.david-b@pacbell.net> <49002B3D.1020208@liewenthal.ee> <200810230204.46297.david-b@pacbell.net>
In-Reply-To: <200810230204.46297.david-b@pacbell.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell wrote:
> On Thursday 23 October 2008, Jüri Reitel wrote:
>   
>> I included patch that just removes the RTC time registers check, when i 
>> compiled the module and booted up with invalid values in RTC then system 
>> automatically set system time and RTC time to 1.1.2000 (this is nice 
>> because i dont have to use date and hwclock manually)
>>     
>
> I wouldn't rely on the initial time setting being valid;
> it's not guaranteed by specs for all the chips, as I recall.
>
>  
>   
>> i checked the rtc_valid_tm function and saw that it also checks for the 
>> year value among others but in ds1307_read_alarm (now this function is 
>> renamed to ds1337_read_alarm) year is set to -1 with some other fields 
>> so rtc_valid_tm function can not be used in ds1337_read_alarm function.
>>     
>
> Right.  I forget what alarm issues I was thinking of, but
> that wasn't it ... other code in the RTC framework handles
> morphing that time into a valid date.
>
>
>   
>> This patch removes rtc date time values check in probe function
>>     
>  
> Thanks.  This looks OK ... got a Signed-off-By for us?
>
>
>   
>> --- a/drivers/rtc/rtc-ds1307.c
>> +++ b/drivers/rtc/rtc-ds1307.c
>> @@ -298,7 +298,7 @@ static int ds1307_set_time(struct device *dev, 
>> struct rtc_time *t)
>>      return 0;
>>  }
>>  
>> -static int ds1307_read_alarm(struct device *dev, struct rtc_wkalrm *t)
>> +static int ds1337_read_alarm(struct device *dev, struct rtc_wkalrm *t)
>>  {
>>      struct i2c_client       *client = to_i2c_client(dev);
>>      struct ds1307        *ds1307 = i2c_get_clientdata(client);
>> @@ -353,7 +353,7 @@ static int ds1307_read_alarm(struct device *dev, 
>> struct rtc_wkalrm *t)
>>      return 0;
>>  }
>>  
>> -static int ds1307_set_alarm(struct device *dev, struct rtc_wkalrm *t)
>> +static int ds1337_set_alarm(struct device *dev, struct rtc_wkalrm *t)
>>  {
>>      struct i2c_client       *client = to_i2c_client(dev);
>>      struct ds1307        *ds1307 = i2c_get_clientdata(client);
>> @@ -475,8 +475,8 @@ static int ds1307_ioctl(struct device *dev, unsigned 
>> int cmd, unsigned long arg)
>>  static const struct rtc_class_ops ds13xx_rtc_ops = {
>>      .read_time    = ds1307_get_time,
>>      .set_time    = ds1307_set_time,
>> -    .read_alarm    = ds1307_read_alarm,
>> -    .set_alarm    = ds1307_set_alarm,
>> +    .read_alarm    = ds1337_read_alarm,
>> +    .set_alarm    = ds1337_set_alarm,
>>      .ioctl        = ds1307_ioctl,
>>  };
>>  
>> @@ -707,22 +707,6 @@ read_rtc:
>>          break;
>>      }
>>  
>> -    tmp = ds1307->regs[DS1307_REG_SECS];
>> -    tmp = bcd2bin(tmp & 0x7f);
>> -    if (tmp > 60)
>> -        goto exit_bad;
>> -    tmp = bcd2bin(ds1307->regs[DS1307_REG_MIN] & 0x7f);
>> -    if (tmp > 60)
>> -        goto exit_bad;
>> -
>> -    tmp = bcd2bin(ds1307->regs[DS1307_REG_MDAY] & 0x3f);
>> -    if (tmp == 0 || tmp > 31)
>> -        goto exit_bad;
>> -
>> -    tmp = bcd2bin(ds1307->regs[DS1307_REG_MONTH] & 0x1f);
>> -    if (tmp == 0 || tmp > 12)
>> -        goto exit_bad;
>> -
>>      tmp = ds1307->regs[DS1307_REG_HOUR];
>>      switch (ds1307->type) {
>>      case ds_1340:
>> @@ -779,13 +763,6 @@ read_rtc:
>>  
>>      return 0;
>>  
>> -exit_bad:
>> -    dev_dbg(&client->dev, "%s: %02x %02x %02x %02x %02x %02x %02x\n",
>> -            "bogus register",
>> -            ds1307->regs[0], ds1307->regs[1],
>> -            ds1307->regs[2], ds1307->regs[3],
>> -            ds1307->regs[4], ds1307->regs[5],
>> -            ds1307->regs[6]);
>>  exit_irq:
>>      if (ds1307->rtc)
>>          rtc_device_unregister(ds1307->rtc);
>>
>>     
>
>
>
>
>   
Thank you pointing to not rely on random values on RTC chip, i had luck 
when reinserted battery from/to RTC in random initial values (that gave 
me 1.1.2000).

Signed-off-by: Jüri Reitel <juri.reitel@liewenthal.ee>

JR

