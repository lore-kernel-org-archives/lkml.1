Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991Ab0BLGcB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 01:32:01 -0500
Received: from smtp.nokia.com ([192.100.105.134]:16803 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716Ab0BLGb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 01:31:59 -0500
From: <samu.p.onkalo@nokia.com>
To: <eric.piel@tremplin-utc.net>
CC: <pavel@ucw.cz>, <daniel@caiaq.de>, <lm-sensors@lm-sensors.org>,
       <linux-kernel@vger.kernel.org>
Date: Fri, 12 Feb 2010 07:31:12 +0100
Subject: RE: [PATCH 0/6] lis3lv02d: Power management, click and threshold
 interrupts
Thread-Topic: [PATCH 0/6] lis3lv02d: Power management, click and threshold
 interrupts
Thread-Index: AcqrTuM0ukF7T2ozT7uBVntUlwsFtgAW9WsA
Message-ID: <62697B07E9803846BC582181BD6FB6B82661C5029E@NOK-EUMSG-02.mgdnok.nokia.com>
References: <1265271848-26559-1-git-send-email-samu.p.onkalo@nokia.com>
 <4B7457D0.4080507@tremplin-utc.net>
In-Reply-To: <4B7457D0.4080507@tremplin-utc.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginalArrivalTime: 12 Feb 2010 06:31:16.0350 (UTC) FILETIME=[FAC639E0:01CAABAC]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o1C6WpmE003432

>-----Original Message-----
>From: ext Ã‰ric Piel [mailto:eric.piel@tremplin-utc.net]
>Sent: 11 February, 2010 21:18
>To: Onkalo Samu.P (Nokia-D/Tampere)
>Cc: pavel@ucw.cz; daniel@caiaq.de; lm-sensors@lm-sensors.org; linux-
>kernel@vger.kernel.org
>Subject: Re: [PATCH 0/6] lis3lv02d: Power management, click and
>threshold interrupts
>
>Op 04-02-10 09:24, Samu Onkalo schreef:
>> Lis3 accelerometer chip family changes for power management,
>> click and threshold event handling.
>>
>> Patch set adds interrupt handlers for click/tap events and threshold
>> based events. Actual configuration which events are enabled
>> is done via platform data. All the features cannot be used in
>parallel.
>> Interrupts are implemented only for 8 bit device, since I'm not
>familiar
>> with other devices and I don't have suitable testing environment.
>>
>> Changes:
>>
>>   lis3: Add missing constants for 8bit device
>> This is quite clear. Some click feature related register definitions
>> were missing.
>>
>>   lis3: Separate configuration function for 8 bit device
>> Move platformdata based configurations for 8 bit device to
>> separate function to keep common part little bit more readable.
>>
>>   lis3: Introduce platform data for second ff / wu unit
>> 8 bit device has two freefall / wakeup detection blocks. Add
>possibility
>> to configure also the second unit. Change hipass filter configuration
>> to platform data. Change is compatible with existing platform data.
>>
>>   lis3: Power control for the chip
>> This kind of feature has been in the driver earlier. It was removed
>> because saving was so small in laptop environment. However, in smaller
>> devices, even a small saving need to be implemented. When driver
>detects
>> that no-one is really interested about the acceleration, chip is
>powered down.
>> Input device, freefall device and sysfs are controlling this. By
>default,
>> chip is powered on to keep functionality similar to current
>implementation.
>>
>>   lis3: Add skeletons for interrupt handlers
>> Interrupt handlers are added in two patches to keep changes cleaner.
>> This first patch adds two dummy threaded interrupt handlers for 8 bit
>device.
>>
>>   lis3: Interrupt handlers for 8bit wakeup and click events
>> This patch adds content to dummy handlers. Depending on the chip
>configuration,
>> either click or ff/wu handling is called. For click event, BTN input
>event is
>> sent separately for each axes. For threshold event, coordinates are
>updated
>> immediatelly to input device. This allows input device to be used
>either in
>> polled mode and / or interrupt driven mode. Polling can stopped from
>userspace
>> by via input device sysfs.
>>
>> Patch set applies to 2.6.33-RC6 tree.
>> Tested with 2.6.32 environment for omap3
>Hello,
>Sorry, I haven't had time to fully review the patches. Nevertheless,
>I've tested them on my HP laptop with a 12bit device, and can confirm
>it's all fine.
>
>The only hiccup is in patch 6: it declares the joystick with 3 buttons,
>although on this hardware it's impossible to have this feature. So, it
>would be nice if input_set_capability() could be conditionned.

I'll add configuration option to platform data or do you prefer some other
way to enable this?

>
>I also fully agree with the comments from others that it would be better
>if it could use the special runtime power-management framework from
>Rafael.

It looks like the corrent way to do that. However, I don't have suitable environment
to do that right now. I need to study this more if I can somehow verify it.

 BTW, what is exactly the usecase for the "active" sysfs
>attribute? To me, it looks like it just prevents userspace from using
>the position attribute, while the joystick interface is still
>accessible, so it is not very effective!

That is exactly what it does. Input and freefall interfaces control the chip state
separately. So, this is only for sysfs interface since driver doesn't know
if somebody is using sysfs interface.

So this is the logic:
- If application wants to use sysfs, it must set 'active' to 1 (which is the default to
maintain backward compatibility).
Otherwise chip state is controlled by the number of users in
input and freefall device handles.
When 'active' is 0, only input / freefall device handles controls
the chip state.

When active is 0 but chip is enabled via input / freefall entries,
position entry returns error code. This is done to prevent the case where
chip is suddenly powered down when input  / freefall devices are closed. 
So position entry is working only when it is separately  enabled.

When there are no users at all, chip is powered down. 

>
>So, for the first four patches, here is my
>Acked-by: Ã‰ric Piel <eric.piel@tremplin-utc.net>

Thanks,
Samu

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
