Return-Path: <linux-kernel-owner+w=401wt.eu-S1754201AbYJWHo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbYJWHo2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 03:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751993AbYJWHoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 03:44:20 -0400
Received: from smtp-out.neti.ee ([194.126.126.37]:35693 "EHLO smtp-out.neti.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149AbYJWHoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 03:44:19 -0400
Message-ID: <49002B3D.1020208@liewenthal.ee>
Date: Thu, 23 Oct 2008 10:43:57 +0300
From: =?ISO-8859-1?Q?J=FCri_Reitel?= <juri.reitel@liewenthal.ee>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: David Brownell <david-b@pacbell.net>,
       Alessandro Zummo <alessandro.zummo@towertech.it>,
       rtc-linux@googlegroups.com
Subject: Re: [rtc-linux] Re: invalid default values in RTC chip
References: <48F45FA5.6040308@liewenthal.ee> <20081016135846.8b06d9f8.akpm@linux-foundation.org> <20081016234108.1268f65c@i1501.lan.towertech.it> <200810161522.26098.david-b@pacbell.net>
In-Reply-To: <200810161522.26098.david-b@pacbell.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell wrote:
> On Thursday 16 October 2008, Alessandro Zummo wrote:
>   
>> On Tue, 14 Oct 2008 12:00:21 +0300
>> Jüri Reitel <juri.reitel@liewenthal.ee> wrote:
>>
>>     
>>>> My question relates to RTC driver linux/drivers/rtc/rtc-ds1307.c for 
>>>> device m41t00. Driver probe function will fail if some of the chip's 
>>>> registers contain invalid date time values i.e. if month register is 32 
>>>> or minutes is 61.
>>>>         
>
> This stuff?
>
>         tmp = ds1307->regs[DS1307_REG_SECS];
>         tmp = BCD2BIN(tmp & 0x7f);
>         if (tmp > 60)
>                 goto exit_bad;
>         tmp = BCD2BIN(ds1307->regs[DS1307_REG_MIN] & 0x7f);
>         if (tmp > 60)
>                 goto exit_bad;
>
>         tmp = BCD2BIN(ds1307->regs[DS1307_REG_MDAY] & 0x3f);
>         if (tmp == 0 || tmp > 31)
>                 goto exit_bad;
>
>         tmp = BCD2BIN(ds1307->regs[DS1307_REG_MONTH] & 0x1f);
>         if (tmp == 0 || tmp > 12)
>                 goto exit_bad;
>
>
>   
>>>> Is this correct behavior? Probe function's purpose is  
>>>> to check if the device is as was assumed (this time RTC and it is). The 
>>>> chip's values are incorrect but the chip works, even the m41t00 chip 
>>>> manual states that after initial powerup (RTC battery power applied) 
>>>> internal registers will contain random data.
>>>>
>>>> There are two solutions first is driver patch and another is i2c-dev and 
>>>> i2cset tool to use from user space during bootup. Whitch one should be used?
>>>>         
>>  Given we transitioned to the new i2c model, which mandates
>>  a platform device to be declared,
>>     
>
> Actually "i2c_board_info", not a "platform_device" ...
>
>
>   
>>  there's no more the need 
>>  to check for the device in the probing function.
>>
>>  this should be fixed in the driver.
>>     
>
> Right.  The code I snipped above dates from the old
> drivers/i2c/chips/ds1337.c code, as I recall, which
> was trying to defend against some random non-RTC chip
> sitting at the relevant address.  As pretty much all
> legacy I2C drivers needed to do.
>
> With "new style" I2C drivers, no guessing is needed
> and such defenses are superfluos.  It's fair to notice
> that no chip is actually present ... but if there's
> a chip there, it should be assumed to match the
> declaration Linux was given.
>
>
>   
>>  however, a driver may still return a failure when reading
>>  the time if there are inappropriate values in the registers.
>>     
>
> In this driver, ds1307_get_time() already has a
>
>         return rtc_valid_tm(t);
>
> But in the just-merged alarm support, ds1307_read_alarm()
> doesn't do that.  Actually that function should use a name
> like ds1337_read_alarm(), since the 1307 has no alarm!
>
>
>   
>>  the solution is to patch the driver for detection and then
>>  use a recent hwclock on bootup to write the time if required.
>>     
>
> Exactly.  Feel free to submit a patch removing those
> probe() checks, and fixing the code returning the alarm
> setting too.
>
>   
I included patch that just removes the RTC time registers check, when i 
compiled the module and booted up with invalid values in RTC then system 
automatically set system time and RTC time to 1.1.2000 (this is nice 
because i dont have to use date and hwclock manually)

i checked the rtc_valid_tm function and saw that it also checks for the 
year value among others but in ds1307_read_alarm (now this function is 
renamed to ds1337_read_alarm) year is set to -1 with some other fields 
so rtc_valid_tm function can not be used in ds1337_read_alarm function.
> - Dave
>
>
>   

This patch removes rtc date time values check in probe function

diff --git a/drivers/rtc/rtc-ds1307.c b/drivers/rtc/rtc-ds1307.c
index 162330b..2e87620 100644
--- a/drivers/rtc/rtc-ds1307.c
+++ b/drivers/rtc/rtc-ds1307.c
@@ -298,7 +298,7 @@ static int ds1307_set_time(struct device *dev, 
struct rtc_time *t)
     return 0;
 }
 
-static int ds1307_read_alarm(struct device *dev, struct rtc_wkalrm *t)
+static int ds1337_read_alarm(struct device *dev, struct rtc_wkalrm *t)
 {
     struct i2c_client       *client = to_i2c_client(dev);
     struct ds1307        *ds1307 = i2c_get_clientdata(client);
@@ -353,7 +353,7 @@ static int ds1307_read_alarm(struct device *dev, 
struct rtc_wkalrm *t)
     return 0;
 }
 
-static int ds1307_set_alarm(struct device *dev, struct rtc_wkalrm *t)
+static int ds1337_set_alarm(struct device *dev, struct rtc_wkalrm *t)
 {
     struct i2c_client       *client = to_i2c_client(dev);
     struct ds1307        *ds1307 = i2c_get_clientdata(client);
@@ -475,8 +475,8 @@ static int ds1307_ioctl(struct device *dev, unsigned 
int cmd, unsigned long arg)
 static const struct rtc_class_ops ds13xx_rtc_ops = {
     .read_time    = ds1307_get_time,
     .set_time    = ds1307_set_time,
-    .read_alarm    = ds1307_read_alarm,
-    .set_alarm    = ds1307_set_alarm,
+    .read_alarm    = ds1337_read_alarm,
+    .set_alarm    = ds1337_set_alarm,
     .ioctl        = ds1307_ioctl,
 };
 
@@ -707,22 +707,6 @@ read_rtc:
         break;
     }
 
-    tmp = ds1307->regs[DS1307_REG_SECS];
-    tmp = bcd2bin(tmp & 0x7f);
-    if (tmp > 60)
-        goto exit_bad;
-    tmp = bcd2bin(ds1307->regs[DS1307_REG_MIN] & 0x7f);
-    if (tmp > 60)
-        goto exit_bad;
-
-    tmp = bcd2bin(ds1307->regs[DS1307_REG_MDAY] & 0x3f);
-    if (tmp == 0 || tmp > 31)
-        goto exit_bad;
-
-    tmp = bcd2bin(ds1307->regs[DS1307_REG_MONTH] & 0x1f);
-    if (tmp == 0 || tmp > 12)
-        goto exit_bad;
-
     tmp = ds1307->regs[DS1307_REG_HOUR];
     switch (ds1307->type) {
     case ds_1340:
@@ -779,13 +763,6 @@ read_rtc:
 
     return 0;
 
-exit_bad:
-    dev_dbg(&client->dev, "%s: %02x %02x %02x %02x %02x %02x %02x\n",
-            "bogus register",
-            ds1307->regs[0], ds1307->regs[1],
-            ds1307->regs[2], ds1307->regs[3],
-            ds1307->regs[4], ds1307->regs[5],
-            ds1307->regs[6]);
 exit_irq:
     if (ds1307->rtc)
         rtc_device_unregister(ds1307->rtc);

