Return-Path: <linux-kernel-owner+w=401wt.eu-S1756321AbYKCQzO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756321AbYKCQzO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 11:55:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755969AbYKCQy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 11:54:58 -0500
Received: from ppsw-0.csi.cam.ac.uk ([131.111.8.130]:51274 "EHLO
	ppsw-0.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755347AbYKCQy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 11:54:57 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <490F2CE1.8070707@gmail.com>
Date: Mon, 03 Nov 2008 16:54:57 +0000
From: Jonathan Cameron <Jonathan.Cameron@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080801)
MIME-Version: 1.0
To: avorontsov@ru.mvista.com
CC: Dmitry Baryshkov <dbaryshkov@gmail.com>, linux-kernel@vger.kernel.org,
       cbou@mail.ru, Andrew Morton <akpm@linux-foundation.org>,
       Marek Vasut <marek.vasut@gmail.com>
Subject: Re: [PATCH] power_supply: change the way how wm97xx-bat driver is
 registered
References: <1225271050-21171-1-git-send-email-dbaryshkov@gmail.com> <1225271050-21171-2-git-send-email-dbaryshkov@gmail.com> <20081103151151.GB23466@oksana.dev.rtsoft.ru>
In-Reply-To: <20081103151151.GB23466@oksana.dev.rtsoft.ru>
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anton Vorontsov wrote:
> On Wed, Oct 29, 2008 at 12:04:10PM +0300, Dmitry Baryshkov wrote:
>> Do register the driver from wm97xx_bat_set_pdata instead of module init.
>> This has several positive outcome points:
>> 1) This driver for wm97xx-battery is now registered on demand, thus allowing
>>   other driver (e.g. tosa-battery) to claim the battery.
>> 2) After dropping __init from wm97xx_bat_set_pdata(), the wm97xx_bat driver
>>   can be correctly built as a module. Then one can request it and set the
>>   battery data.
>>
>> Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
>> Cc: Marek Vasut <marek.vasut@gmail.com>
>> ---
>>  drivers/power/Kconfig          |    4 ++--
>>  drivers/power/wm97xx_battery.c |   12 +++++-------
>>  include/linux/wm97xx_batt.h    |    7 +++++--
>>  3 files changed, 12 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
>> index 8e0c2b4..053f20b 100644
>> --- a/drivers/power/Kconfig
>> +++ b/drivers/power/Kconfig
>> @@ -57,8 +57,8 @@ config BATTERY_TOSA
>>  	  SL-6000 (tosa) models.
>>  
>>  config BATTERY_WM97XX
>> -	bool "WM97xx generic battery driver"
>> -	depends on TOUCHSCREEN_WM97XX=y
>> +	tristate "WM97xx generic battery driver"
>> +	depends on TOUCHSCREEN_WM97XX
>>  	help
>>  	  Say Y to enable support for battery measured by WM97xx aux port.
>>  
>> diff --git a/drivers/power/wm97xx_battery.c b/drivers/power/wm97xx_battery.c
>> index 8bde921..94727dc 100644
>> --- a/drivers/power/wm97xx_battery.c
>> +++ b/drivers/power/wm97xx_battery.c
>> @@ -248,23 +248,21 @@ static struct platform_driver wm97xx_bat_driver = {
>>  	.resume		= wm97xx_bat_resume,
>>  };
>>  
>> -static int __init wm97xx_bat_init(void)
>> -{
>> -	return platform_driver_register(&wm97xx_bat_driver);
>> -}
>> -
>>  static void __exit wm97xx_bat_exit(void)
>>  {
>>  	platform_driver_unregister(&wm97xx_bat_driver);
>>  }
>>  
>> -void __init wm97xx_bat_set_pdata(struct wm97xx_batt_info *data)
>> +int wm97xx_bat_set_pdata(struct wm97xx_batt_info *data)
>>  {
>> +	if (pdata)
>> +		return -EEXIST;
>> +
>>  	pdata = data;
>> +	return platform_driver_register(&wm97xx_bat_driver);
>>  }
>>  EXPORT_SYMBOL_GPL(wm97xx_bat_set_pdata);
>>  
>> -module_init(wm97xx_bat_init);
>>  module_exit(wm97xx_bat_exit);
>>  
>>  MODULE_LICENSE("GPL");
>> diff --git a/include/linux/wm97xx_batt.h b/include/linux/wm97xx_batt.h
>> index 9681d1a..3e42526 100644
>> --- a/include/linux/wm97xx_batt.h
>> +++ b/include/linux/wm97xx_batt.h
>> @@ -18,9 +18,12 @@ struct wm97xx_batt_info {
>>  };
>>  
>>  #ifdef CONFIG_BATTERY_WM97XX
>> -void __init wm97xx_bat_set_pdata(struct wm97xx_batt_info *data);
>> +int wm97xx_bat_set_pdata(struct wm97xx_batt_info *data);
>>  #else
>> -static inline void wm97xx_bat_set_pdata(struct wm97xx_batt_info *data) {}
>> +static inline int wm97xx_bat_set_pdata(struct wm97xx_batt_info *data)
>> +{
>> +	return -ENODEV;
>> +}
>>  #endif
> 
> How that supposed to work when BATTERY_WM97XX is a module?
> #ifdef CONFIG_BATTERY_WM97XX will evaluate to false, and you'll have
> dummy wm97xx_bat_set_pdata() that returns -ENODEV...
> 
> The whole wm97xx stuff is broken wrt device-driver model... Yeah,
> I know why -- we don't have the ADC API/Subsystem. It would be great
> if somebody could find time to forward-port the subsystem from the
> handhelds.org tree...
> 
> I don't know what happened to the industrialio subsystem though
> (http://lkml.org/lkml/2008/7/23/163), but it looked needlessly
> complicated, and probably Jonathan gave up on it... :-/
> 
It is needlessly complex for this sort of thing, but that's not it's
purpose.  (though that's not to say it won't be able to do this sort
of thing).  It's gotten a smigeon delayed due to a change of my own
requirements for what it does.  As a reminder, the purpose of that
subsystem was at least partly to provide reasonably high performance
data capture facilities (ring buffers, triggered sampling etc alongside
suitably powerful userspace interfaces.)  Possibly my apps are somewhat
unusual, but the complexity is absolutely necessary for what I'm doing
(annoyingly!)

The complexity is partly due to trying to elegantly allow much reduced
functionality such as this sort of app requires.   (leads to a lot
of fiddly testing!)

Anyhow, definitely not given up on it.  The intermediate versions are
getting a fair bit of testing, but isn't ready (in my view) to go
towards mainline yet.

Jonathan


