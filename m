Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650Ab0BLMVV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 07:21:21 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:31323 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929Ab0BLMVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 07:21:19 -0500
X-Spam-Flag: NO
X-Spam-Score: -12.589
Message-ID: <4B7547BB.1020900@tremplin-utc.net>
Date: Fri, 12 Feb 2010 13:21:15 +0100
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <Eric.Piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090319 Mandriva/2.0.0.21-1mdv2009.1 (2009.1) Thunderbird/2.0.0.21 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: samu.p.onkalo@nokia.com
CC: pavel@ucw.cz, daniel@caiaq.de, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] lis3lv02d: Power management, click and threshold
 interrupts
References: <1265271848-26559-1-git-send-email-samu.p.onkalo@nokia.com> <4B7457D0.4080507@tremplin-utc.net> <62697B07E9803846BC582181BD6FB6B82661C5029E@NOK-EUMSG-02.mgdnok.nokia.com>
In-Reply-To: <62697B07E9803846BC582181BD6FB6B82661C5029E@NOK-EUMSG-02.mgdnok.nokia.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 12-02-10 07:31, samu.p.onkalo@nokia.com schreef:
>> The only hiccup is in patch 6: it declares the joystick with 3 buttons,
>> although on this hardware it's impossible to have this feature. So, it
>> would be nice if input_set_capability() could be conditionned.
> 
> I'll add configuration option to platform data or do you prefer some other
> way to enable this?

> You obviously meant that enable those only for 8 bit device, since
> 12 bit doesn't have click detection. I can do that.
> 
Perfect!

>> I also fully agree with the comments from others that it would be better
>> if it could use the special runtime power-management framework from
>> Rafael.
> 
> It looks like the corrent way to do that. However, I don't have suitable environment
> to do that right now. I need to study this more if I can somehow verify it.
That would be great :-)

>  BTW, what is exactly the usecase for the "active" sysfs
>> attribute? To me, it looks like it just prevents userspace from using
>> the position attribute, while the joystick interface is still
>> accessible, so it is not very effective!
> 
> That is exactly what it does. Input and freefall interfaces control the chip state
> separately. So, this is only for sysfs interface since driver doesn't know
> if somebody is using sysfs interface.
> 
> So this is the logic:
> - If application wants to use sysfs, it must set 'active' to 1 (which is the default to
> maintain backward compatibility).
> Otherwise chip state is controlled by the number of users in
> input and freefall device handles.
> When 'active' is 0, only input / freefall device handles controls
> the chip state.
> 
> When active is 0 but chip is enabled via input / freefall entries,
> position entry returns error code. This is done to prevent the case where
> chip is suddenly powered down when input  / freefall devices are closed. 
> So position entry is working only when it is separately  enabled.
> 
> When there are no users at all, chip is powered down. 
> 
I understand. The main problem is that powering up and down the chip
every time someone opens the sysfs position attribute is very expensive.

Having an explicit attribute to turn on/off the powersaving means that
the userspace must be aware of it. This is a burden, and especially if
you run your userspace application as a normal user, while the active
attribute obviously requires root level.

Previously, when I implemented the auto power down feature, I had put a
timer after 30s of usage to work around this. It's obviously not
optimal, but it has the advantage of hiding completely the powersaving
feature from userspace. Do you think it would be fine it implement it
this way?

See you,
Eric
