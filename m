Return-Path: <linux-kernel-owner+w=401wt.eu-S1754550AbXLTTnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550AbXLTTnU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 14:43:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbXLTTnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 14:43:08 -0500
Received: from mga03.intel.com ([143.182.124.21]:62396 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953AbXLTTnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 14:43:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,191,1196668800"; 
   d="scan'208";a="346309744"
Message-ID: <476AC105.9090206@intel.com>
Date: Thu, 20 Dec 2007 11:22:45 -0800
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071125)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Stephen Hemminger <shemminger@linux-foundation.org>,
       parag.warudkar@gmail.com, netdev@vger.kernel.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sky2: Use deferrable timer for watchdog
References: <Pine.LNX.4.64.0712182008160.3616@mini.warudkars.net>	<20071220091603.0d69b045@deepthought>	<823114761-1198171803-cardhu_decombobulator_blackberry.rim.net-937108990-@bxe019.bisx.prod.on.blackberry> <20071220095121.7859c023@deepthought> <476ABDDF.8080607@intel.com> <476ABE7D.60901@linux.intel.com>
In-Reply-To: <476ABE7D.60901@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Dec 2007 19:23:23.0458 (UTC) FILETIME=[C99C2A20:01C8433D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> 
>>>> My interpretation of the api is:
>>>>    * round_jiffies()  - timer wants to wakeup but isn't precise
>>>> about when so schedule
>>>>                         on next second when system will wake up anyway;
>>>>                         e.g why meetings are usually scheduled on
>>>> the hour
>>>>
>>>>    * deferrable       - timer doesn't have to really wakeup but
>>>> wants to happen near
>>>>                         a particular time. e.g. "I'll meet you at
>>>> the pub around 8pm"
> 
> this is not correct.
> 
> deferrable means "if you're busy wake me up at this time. But if not,
> don't bother waking up for me, get to it
> later".
> 
> The "later" can be a LONG time later, several seconds easily, if not more.
> (timers are on a per cpu bases, and you may end up with a several-core
> system where the common timers are all on another cpu
> than this one)
> 
> 
> 
>>> If this is the case then the whole usage of round_jiffies() is bogus.
>>> All users of round_jiffies()
>>> should just be converted to deferrable??  I am a bit concerned that
>>> if deferrable gets used everywhere
>>> then a strange situation would occur where all timers were waiting
>>> for some other timer to finally
>>> happen, kind of a wierd timelock situation. Like the old chip/dale
>>> cartoon:
>>>  "you first, no you first, after you mister chip, no after you mister
>>> dale,..."
>>
>>
>>
>> that's a dangerous situation indeed and I'd really like to know what
>> the limits
>> are for deferring deferrable timers.... Arjan, do you know? Anyone?
> 
> there is NO limit to deferring a timer. Do NOT use a deferrable timer if
> you can't afford the timer to not happen
> within.. 10 to 100 seconds! (or more)
> They are really meant for things where you CAN afford for it to not
> happen when you're idle....

ok, that's just bad and if there's no user-defineable limit to the deferral I
definately don't like this change.

Can I safely assume that any irq will cause all deferred timers to run?

If this is the case then for e1000 this patch is still OK since the watchdog needs
to run (1) after a link up/down interrupt or (2) to update statistics. Those
statistics won't increase if there is no traffic of course...

Auke
