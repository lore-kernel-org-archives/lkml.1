Return-Path: <linux-kernel-owner+w=401wt.eu-S1755389AbYJWJFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389AbYJWJFA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 05:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752364AbYJWJEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 05:04:51 -0400
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:26044 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751275AbYJWJEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 05:04:50 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=o21wkrGjCzxtY/+eaEpk4XcJiSey85juitDSUfUJ6k29u4g6Y0tHdcBpxtHsQqzIQWetqf91iAikz9Xrm7dCxqgChHlWe8r8L0JRo5gqMQ89C5Q7tCTHmVMFJ0lPAGRc9kMBB12EKNXIVxVFCzlkAad4Dljq5y8Jbi7RtwJ4Q4Q=  ;
X-YMail-OSG: Tw9e7cIVM1nky9sEgRJuchLa8U4ivdM4cgo.kZXer4b36qfJohiIeQpQXBNOFYjSZn9fJYSuAz4Z6HwxI_zE92N27mU6RBYw4qnvX3LiDsT8rhL.URXBMgM3EKEwdTL0ZKw-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: =?iso-8859-1?q?J=FCri_Reitel?= <juri.reitel@liewenthal.ee>
Subject: Re: [rtc-linux] Re: invalid default values in RTC chip
Date: Thu, 23 Oct 2008 02:04:46 -0700
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org,
       Alessandro Zummo <alessandro.zummo@towertech.it>,
       rtc-linux@googlegroups.com
References: <48F45FA5.6040308@liewenthal.ee> <200810161522.26098.david-b@pacbell.net> <49002B3D.1020208@liewenthal.ee>
In-Reply-To: <49002B3D.1020208@liewenthal.ee>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200810230204.46297.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 October 2008, Jüri Reitel wrote:
> 
> I included patch that just removes the RTC time registers check, when i 
> compiled the module and booted up with invalid values in RTC then system 
> automatically set system time and RTC time to 1.1.2000 (this is nice 
> because i dont have to use date and hwclock manually)

I wouldn't rely on the initial time setting being valid;
it's not guaranteed by specs for all the chips, as I recall.

 
> i checked the rtc_valid_tm function and saw that it also checks for the 
> year value among others but in ds1307_read_alarm (now this function is 
> renamed to ds1337_read_alarm) year is set to -1 with some other fields 
> so rtc_valid_tm function can not be used in ds1337_read_alarm function.

Right.  I forget what alarm issues I was thinking of, but
that wasn't it ... other code in the RTC framework handles
morphing that time into a valid date.


> 
> This patch removes rtc date time values check in probe function
 
Thanks.  This looks OK ... got a Signed-off-By for us?


> --- a/drivers/rtc/rtc-ds1307.c
> +++ b/drivers/rtc/rtc-ds1307.c
> @@ -298,7 +298,7 @@ static int ds1307_set_time(struct device *dev, 
> struct rtc_time *t)
>      return 0;
>  }
>  
> -static int ds1307_read_alarm(struct device *dev, struct rtc_wkalrm *t)
> +static int ds1337_read_alarm(struct device *dev, struct rtc_wkalrm *t)
>  {
>      struct i2c_client       *client = to_i2c_client(dev);
>      struct ds1307        *ds1307 = i2c_get_clientdata(client);
> @@ -353,7 +353,7 @@ static int ds1307_read_alarm(struct device *dev, 
> struct rtc_wkalrm *t)
>      return 0;
>  }
>  
> -static int ds1307_set_alarm(struct device *dev, struct rtc_wkalrm *t)
> +static int ds1337_set_alarm(struct device *dev, struct rtc_wkalrm *t)
>  {
>      struct i2c_client       *client = to_i2c_client(dev);
>      struct ds1307        *ds1307 = i2c_get_clientdata(client);
> @@ -475,8 +475,8 @@ static int ds1307_ioctl(struct device *dev, unsigned 
> int cmd, unsigned long arg)
>  static const struct rtc_class_ops ds13xx_rtc_ops = {
>      .read_time    = ds1307_get_time,
>      .set_time    = ds1307_set_time,
> -    .read_alarm    = ds1307_read_alarm,
> -    .set_alarm    = ds1307_set_alarm,
> +    .read_alarm    = ds1337_read_alarm,
> +    .set_alarm    = ds1337_set_alarm,
>      .ioctl        = ds1307_ioctl,
>  };
>  
> @@ -707,22 +707,6 @@ read_rtc:
>          break;
>      }
>  
> -    tmp = ds1307->regs[DS1307_REG_SECS];
> -    tmp = bcd2bin(tmp & 0x7f);
> -    if (tmp > 60)
> -        goto exit_bad;
> -    tmp = bcd2bin(ds1307->regs[DS1307_REG_MIN] & 0x7f);
> -    if (tmp > 60)
> -        goto exit_bad;
> -
> -    tmp = bcd2bin(ds1307->regs[DS1307_REG_MDAY] & 0x3f);
> -    if (tmp == 0 || tmp > 31)
> -        goto exit_bad;
> -
> -    tmp = bcd2bin(ds1307->regs[DS1307_REG_MONTH] & 0x1f);
> -    if (tmp == 0 || tmp > 12)
> -        goto exit_bad;
> -
>      tmp = ds1307->regs[DS1307_REG_HOUR];
>      switch (ds1307->type) {
>      case ds_1340:
> @@ -779,13 +763,6 @@ read_rtc:
>  
>      return 0;
>  
> -exit_bad:
> -    dev_dbg(&client->dev, "%s: %02x %02x %02x %02x %02x %02x %02x\n",
> -            "bogus register",
> -            ds1307->regs[0], ds1307->regs[1],
> -            ds1307->regs[2], ds1307->regs[3],
> -            ds1307->regs[4], ds1307->regs[5],
> -            ds1307->regs[6]);
>  exit_irq:
>      if (ds1307->rtc)
>          rtc_device_unregister(ds1307->rtc);
> 


