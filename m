Return-Path: <linux-kernel-owner+w=401wt.eu-S1753466AbZK3Vc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466AbZK3Vc5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 16:32:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752778AbZK3Vc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 16:32:56 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:51709 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200AbZK3Vcz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 16:32:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=V1mfWleeDO1PVnjeXpe5UBeHKccxIDqs/dYw+nSC6JbkHRQ9Xdi1oebnzziai2anPW
         K49+i6KAvBODFcNJcuhg0CKRpF/ia2r5V58zj8Rqes3eEjRtcygF75bztfTa71uLJ+La
         WYFDP6fuxkmO+jRojv2aAF4KMY55iwAsZqdtw=
MIME-Version: 1.0
In-Reply-To: <012301ca71ed$449cb930$544ff780@am.dhcp.ti.com>
References: <1259333060-24277-1-git-send-email-notasas@gmail.com>
	 <012301ca71ed$449cb930$544ff780@am.dhcp.ti.com>
Date: Mon, 30 Nov 2009 23:33:00 +0200
Message-ID: <6ed0b2680911301333p19b14d5dxac81f976d0c35c61@mail.gmail.com>
Subject: Re: [PATCH] power_supply: Add driver for TWL4030/TPS65950 BCI charger
From: Grazvydas Ignotas <notasas@gmail.com>
To: Madhusudhan <madhu.cr@ti.com>
Cc: linux-kernel@vger.kernel.org, Anton Vorontsov <avorontsov@ru.mvista.com>,
       linux-omap@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 30, 2009 at 8:45 PM, Madhusudhan <madhu.cr@ti.com> wrote:
>
>
>> -----Original Message-----
>> From: Grazvydas Ignotas [mailto:notasas@gmail.com]
>> Sent: Friday, November 27, 2009 8:44 AM
>> To: linux-kernel@vger.kernel.org
>> Cc: Anton Vorontsov; Madhusudhan Chikkature; linux-omap@vger.kernel.org;
>> Grazvydas Ignotas
>> Subject: [PATCH] power_supply: Add driver for TWL4030/TPS65950 BCI charger
>>
>> TWL4030/TPS65950 is a multi-function device with integrated charger,
>> which allows charging from AC or USB. This driver enables the
>> charger and provides several monitoring functions.
>>
>> Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
>> ---
>> For this driver to work, TWL4030-core needs to be patched to use
>> correct macros so that it registers twl4030_bci platform_device.
>> I'll send patches for this later.
>>
>>  drivers/power/Kconfig           |    7 +
>>  drivers/power/Makefile          |    1 +
>>  drivers/power/twl4030_charger.c |  499
>
> Is the file name changed from twl4030_bci_battery.c to twl4030_charger.c because it mainly supports voltage monitoring only while charging? If yes, potentially we can add support for monitoring also in discharge state. Do we intend to change the file name then?

Does the hardware support any monitoring in discharge state? I'm
unable to get any readings, only frozen values (that never update)
from what it had when it was charging. Here is TI confirmation that at
least temperature monitoring won't work while discharging:
http://e2e.ti.com/forums/p/8202/31818.aspx#31818

For this reason I consider BCI a charger.

> Also adding the tested-on info could be helpful here.

ok

<snip>

>> +     case POWER_SUPPLY_PROP_VOLTAGE_NOW:
>> +             /* charging must be active for meaningful result */
>> +             if (!is_charging) {
>
> How about putting a kern_info here?

That would potentially flood dmesg, will just return -EINVAL like
Anton suggests.

>> +                     val->intval = 0;
>> +                     break;
>> +             }
>> +             ret = twl4030_get_voltage(voltage_reg);
>> +             if (ret < 0)
>> +                     return ret;
>> +             val->intval = ret;
>> +             break;
>> +     case POWER_SUPPLY_PROP_CURRENT_NOW:
>> +             if (!is_charging) {
>> +                     val->intval = 0;
> Ditto
>> +                     break;
>> +             }
>> +             /* current measurement is shared between AC and USB */
>> +             ret = twl4030_charger_get_current();
>> +             if (ret < 0)
>> +                     return ret;
>> +             val->intval = ret;
>> +             break;
>> +     case POWER_SUPPLY_PROP_ONLINE:
> Does this indicate the source of charging like USB or AC??

There are 2 charging devices registered now, AC and USB, each returns
it's state. This is what most other drivers do.

I'll send v2 later, it will also have more accurate voltage formulas I
got from TI.
