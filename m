Return-Path: <linux-kernel-owner+w=401wt.eu-S1762346AbXKAXTD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762346AbXKAXTD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 19:19:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762207AbXKAXSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 19:18:16 -0400
Received: from mailgw2.3essentials.com ([66.179.153.59]:3674 "EHLO
	mailgw2.3essentials.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762332AbXKAXSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 19:18:14 -0400
Message-ID: <472A5EBC.7030907@antonello.org>
Date: Fri, 02 Nov 2007 00:18:20 +0100
From: jack@antonello.org
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: linux-kernel@vger.kernel.org, rpurdie@rpsys.net
Subject: Re: [PATCH] backlight dimmer
References: <4724B48D.6090405@antonello.org> <20071030144838.GD7742@ucw.cz>
In-Reply-To: <20071030144838.GD7742@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Sun 2007-10-28 17:10:53, jack@antonello.org wrote:
>> Hello,
>> this patch implements a macbook like backlight dimmer on 
>> top of backlight.c.
>>
>> The dimmer is entirely in kernelspace and is suitable 
>> for an embedded context in order to avoid the overhead 
>> of a daemon controlling the backlight. Implementing this 
>> functionality in userspace has other advantages and is a 
>> perfectly reasonable alternative, so this patch is
>> not the definitive solution.
>>
>> activate dimmer:
>> echo 1 > /sys/devices/virtual/backlight/*/dimmer_control
>>
>> other attributes (britness levels & timeout):
>> /sys/devices/virtual/backlight/*/dimmer_high_level
>> /sys/devices/virtual/backlight/*/dimmer_low_level
>> /sys/devices/virtual/backlight/*/dimmer_timeout
> 
> I'd say that userspace makes sense here. I'd want backlight to go down
> slowly, for example.
> 
> But... maybe undimming should be done in kernel, so it keeps
> low,latency?
> 
> Hmm, maybe existing screen blanking infrastructure can be reused?
> 
>> --- linux-2.6.23.1/include/linux/backlight.h 2007-10-12 
>> 18:43:44.000000000 +0200
>> +++ b/include/linux/backlight.h	2007-10-28 
>> 13:45:21.000000000 +0100
>> @@ -11,6 +11,7 @@
>> #include <linux/device.h>
>> #include <linux/mutex.h>
>> #include <linux/notifier.h>
>> +#include <linux/timeout.h>
>>
>> /* Notes on locking:
> 
> Your mail client damages patches?
> 

Hi,
incremental dimming can be easily implemented on top of this patch. 
It's just about posting the timeout repeatedly. I will post something 
in the near future :).

I believe the userspace vs kernelspace argument is very arbitrary.

As i said, the dimmer can be completely coded in userspace. There are 
good reasons for that. Userspace apps can work out better than the 
kernel what the user is doing. If the user is watching a movie for 
instance, the dimmer should be stopped.

However, the patch is just a light addition to backlight.c. If the 
dimmer is stopped/unused, just a few pointers and some code are wasted.

Userspace apps can start, stop and change the timeout value for the 
dimmer on the fly, as if they were doing the dimming themselves. In 
this case, userspace only notifies the kernel to stop the dimmer 
whenever such action is deemed right. Instead when the dimmer is on, 
which is most of the time, no kernespace/userspace switch is necessary.

Changing the brightness might occur every 10 seconds or so. IMHO this 
is more of a realtime (and thus kernelspace) requirement rather than 
userspace. This also saves us from having a whole (heavyweight) 
dedicated process managing such a basic functionality.

Finally, implementing the dimmer in kernelspace delivers this 
functionality everywhere provided Linux is used. No additional 
software is necessary. This latter would usually have to be tailored 
to different audiences such as desktop, embedded, whatever.

I don't think thunderbird is breaking the patch, since i was able to 
apply it from my previous posts. However here is a web location for 
it, just in case: http://www.antonello.org/dimmer/. Please let me know 
if you can't test it!

jacopo

