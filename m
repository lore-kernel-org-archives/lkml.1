Return-Path: <linux-kernel-owner+w=401wt.eu-S1752943AbZLWTEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943AbZLWTEg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 14:04:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752534AbZLWTEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 14:04:35 -0500
Received: from mail.windriver.com ([147.11.1.11]:59949 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbZLWTEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 14:04:34 -0500
Message-ID: <4B3269BB.5020406@windriver.com>
Date: Wed, 23 Dec 2009 13:04:27 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Clemens Ladisch <clemens@ladisch.de>
CC: David Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] drm_fb_helper: fix regression in pixclock check
References: <1261092303-4570-1-git-send-email-jason.wessel@windriver.com> <4B2B2D47.8050700@ladisch.de>
In-Reply-To: <4B2B2D47.8050700@ladisch.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Dec 2009 19:04:27.0624 (UTC) FILETIME=[BFCE2680:01CA8402]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clemens Ladisch wrote:
> Jason Wessel wrote:
>   
>> Commit 5349ef3127c77075ff70b2014f17ae0fbcaaf199 changed pixclock to be
>> initialized to zero instead of -1.
>>     
>
> Zero meaning "there is no pixel clock value".  When I wrote the patch,
> the FB (helper) code did not use this value at all, so zero was the only
> value that could possibly be used.
>
>   
>> The validation routine always returns -EINVAL for a valid pixclock
>>     
>
> It declares that the only valid pixclock value is "none".  This was
> required to make the userspace API work, since the GET ioctls return
> this value, and all programs expect to be able to PUT this value back.
>
>   
>> which prevents atomic kernel mode setting from working correctly.
>> ...
>> @@ -602,7 +602,7 @@ int drm_fb_helper_check_var(struct fb_var_screeninfo *var,
>>  
>> -	if (var->pixclock != 0)
>> +	if (!var->pixclock)
>>  		return -EINVAL;
>>     
>
> This change breaks the userspace API again, unless the other parts of
> the code have been changed to always return a valid pixclock value when
> reading the current mode settings.
>
> If we want to accept both zero and non-zero values for pixclock, this
> check should be dropped altogether.
>
> In drm_fb_helper_set_par(), there is a corresponding check that must be
> kept in sync with this one.
>
>   

Fair enough.  We'll make a special case for when the kernel debugger is
active.

Looks to me like it worked by luck during the 2.6.32 kernel cycle for
the atomic kernel mode setting.  I have changed it in the next version
of this patch to always return -EINVAL while the kernel debugger is
active.  This restores the atomic kernel mode setting back to the
working state, until we can find a better solution.

Thanks,
Jason.

