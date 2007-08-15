Return-Path: <linux-kernel-owner+w=401wt.eu-S1764105AbXHOOHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764105AbXHOOHw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 10:07:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755467AbXHOOHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 10:07:42 -0400
Received: from smtp2.actcom.co.il ([192.114.47.35]:54662 "EHLO
	smtp2.actcom.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755094AbXHOOHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 10:07:41 -0400
Message-ID: <46C3077D.4000307@compulab.co.il>
Date: Wed, 15 Aug 2007 17:02:37 +0300
From: Mike Rapoport <mike@compulab.co.il>
User-Agent: Thunderbird 2.0.0.4 (X11/20070715)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Rapha=EBl_Ass=E9nat?= <raph@8d.com>
CC: LKML <linux-kernel@vger.kernel.org>,
       Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [PATCH] RTC v3020 fixes
References: <46C292F2.1050401@compulab.co.il> <46C2F8C9.6020806@8d.com>
In-Reply-To: <46C2F8C9.6020806@8d.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Raphaël Assénat wrote:
> Mike Rapoport wrote:
>> Fix off-by-one in month calculations
>> Add delay for bus accesses to satisfy Tw > 500ns
>>
> *snip*
>> @@ -135,7 +140,7 @@ static int v3020_set_time(struct device *dev, 
>> struct rtc_time *dt)
>>      v3020_set_reg(chip, V3020_MINUTES,     BIN2BCD(dt->tm_min));
>>      v3020_set_reg(chip, V3020_HOURS,     BIN2BCD(dt->tm_hour));
>>      v3020_set_reg(chip, V3020_MONTH_DAY,    BIN2BCD(dt->tm_mday));
>> -    v3020_set_reg(chip, V3020_MONTH,     BIN2BCD(dt->tm_mon));
>> +    v3020_set_reg(chip, V3020_MONTH,     BIN2BCD(dt->tm_mon) + 1);
> 
> This should be BIN2BCD(dt->tm_mon + 1)) instead. Otherwise, in october 
> (month 9), the final value will be 0xa instead of 0x10.

Fixed.


> Other than that, the patch looks fine to me. You can add
> Acked-by: Raphael Assenat <raph@8d.com> to the updated patch.
> 
> Please add Alessandro Zummo <a.zummo@towertech.it> in the CC list to 
> make sure he sees it.
> 
> Best regards,
> Raphaël Assénat

Signed-off-by: Mike Rapoport <mike@compulab.co.il>
Acked-by: Raphael Assenat <raph@8d.com>

  drivers/rtc/rtc-v3020.c |    9 +++++++--
  1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-v3020.c b/drivers/rtc/rtc-v3020.c
index 3b58d3d..e96d667 100644
--- a/drivers/rtc/rtc-v3020.c
+++ b/drivers/rtc/rtc-v3020.c
@@ -26,6 +26,7 @@
  #include <linux/types.h>
  #include <linux/bcd.h>
  #include <linux/rtc-v3020.h>
+#include <linux/delay.h>

  #include <asm/io.h>

@@ -47,6 +48,7 @@ static void v3020_set_reg(struct v3020 *chip, unsigned char 
address,
  	for (i = 0; i < 4; i++) {
  		writel((tmp & 1) << chip->leftshift, chip->ioaddress);
  		tmp >>= 1;
+		udelay(1);
  	}

  	/* Commands dont have data */
@@ -54,6 +56,7 @@ static void v3020_set_reg(struct v3020 *chip, unsigned char 
address,
  		for (i = 0; i < 8; i++) {
  			writel((data & 1) << chip->leftshift, chip->ioaddress);
  			data >>= 1;
+			udelay(1);
  		}
  	}
  }
@@ -66,12 +69,14 @@ static unsigned char v3020_get_reg(struct v3020 *chip, 
unsigned char address)
  	for (i = 0; i < 4; i++) {
  		writel((address & 1) << chip->leftshift, chip->ioaddress);
  		address >>= 1;
+		udelay(1);
  	}

  	for (i = 0; i < 8; i++) {
  		data >>= 1;
  		if (readl(chip->ioaddress) & (1 << chip->leftshift))
  			data |= 0x80;
+		udelay(1);
  	}

  	return data;
@@ -95,7 +100,7 @@ static int v3020_read_time(struct device *dev, struct 
rtc_time *dt)
  	tmp = v3020_get_reg(chip, V3020_MONTH_DAY);
  	dt->tm_mday	= BCD2BIN(tmp);
  	tmp = v3020_get_reg(chip, V3020_MONTH);
-	dt->tm_mon	= BCD2BIN(tmp);
+	dt->tm_mon	= BCD2BIN(tmp) - 1;
  	tmp = v3020_get_reg(chip, V3020_WEEK_DAY);
  	dt->tm_wday	= BCD2BIN(tmp);
  	tmp = v3020_get_reg(chip, V3020_YEAR);
@@ -135,7 +140,7 @@ static int v3020_set_time(struct device *dev, struct 
rtc_time *dt)
  	v3020_set_reg(chip, V3020_MINUTES, 	BIN2BCD(dt->tm_min));
  	v3020_set_reg(chip, V3020_HOURS, 	BIN2BCD(dt->tm_hour));
  	v3020_set_reg(chip, V3020_MONTH_DAY,	BIN2BCD(dt->tm_mday));
-	v3020_set_reg(chip, V3020_MONTH, 	BIN2BCD(dt->tm_mon));
+	v3020_set_reg(chip, V3020_MONTH, 	BIN2BCD(dt->tm_mon + 1));
  	v3020_set_reg(chip, V3020_WEEK_DAY, 	BIN2BCD(dt->tm_wday));
  	v3020_set_reg(chip, V3020_YEAR, 	BIN2BCD(dt->tm_year % 100));



-- 
Sincerely yours,
Mike.

