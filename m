Return-Path: <linux-kernel-owner+w=401wt.eu-S1754721AbZEJTi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721AbZEJTi4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 15:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751690AbZEJTir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 15:38:47 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:22682 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbZEJTiq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 15:38:46 -0400
MIME-Version: 1.0
In-Reply-To: <4A06E344.4060901@rsk.demon.co.uk>
References: <alpine.DEB.2.00.0905100336130.27219@ubuntu-desktop>
	 <4A06E344.4060901@rsk.demon.co.uk>
Date: Sun, 10 May 2009 12:38:46 -0700
Message-ID: <a24804730905101238m3f561ea9p3bdadf151de53b71@mail.gmail.com>
Subject: Re: [PATCH] use round_jiffies() for slow work thread pool's 5 second 
	cull timer
From: Chris Peterson <cpeterso@cpeterso.com>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, you are correct. I misread how round_jiffies_relative() worked.

chris


On Sun, May 10, 2009 at 7:23 AM, Richard Kennedy
<richard@rsk.demon.co.uk> wrote:
> Chris Peterson wrote:
>> The slow work thread pool culls its idle threads after 5 seconds without any work requests. Also, the slow work thread pool waits 5 seconds before starting new threads after OOM.
>>
>> This patch uses round_jiffies() to round these 5 second timers to whole seconds. In this case, the actual timer wait would be between 4.75 and 5.75 seconds (because round_jiffies() rounds < 0.25 seconds down and > 0.25 seconds up). This patch also refactors the mod_timer() logic into a separate helper function.
>>
>> Signed-off-by: Chris Peterson <cpeterso@cpeterso.com>
>> ---
>> diff --git a/kernel/slow-work.c b/kernel/slow-work.c
>> index b28d191..9bfcb53 100644
>> --- a/kernel/slow-work.c
>> +++ b/kernel/slow-work.c
>> @@ -318,6 +318,12 @@ cant_get_ref:
>>  }
>>  EXPORT_SYMBOL(slow_work_enqueue);
>>
>> +static void slow_work_defer_cull_time(void)
>> +{
>> +     mod_timer(&slow_work_cull_timer,
>> +                       round_jiffies_relative(SLOW_WORK_CULL_TIMEOUT));
>> +}
>> +
> Hi Chris,
>
> Doesn't mod_timer take an absolute time not a relative one?
>
> So I think this should be
>
>        mod_timer(&timer,round_jiffies(jiffies + TIMEOUT) );
>
> regards
>
> Richard
>
>
