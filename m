Return-Path: <linux-kernel-owner+w=401wt.eu-S1755791AbXD0M5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791AbXD0M5s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 08:57:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755789AbXD0M5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 08:57:48 -0400
Received: from atlrel6.hp.com ([156.153.255.205]:34680 "EHLO atlrel6.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755786AbXD0M5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 08:57:46 -0400
Message-ID: <4631F26D.7080404@hp.com>
Date: Fri, 27 Apr 2007 08:54:05 -0400
From: Peter Keilty <peter.keilty@hp.com>
User-Agent: Mozilla Thunderbird 1.0RC1 (X11/20041209)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
Cc: linux-ia64@vger.kernel.org, Eric Whitney <eric.whitney@hp.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] ia64: convert to use clocksource code
References: <20070426202632.23343.54944.sendpatchset@rambler.zko.hp.com> <1177622301.6031.16.camel@localhost.localdomain>
In-Reply-To: <1177622301.6031.16.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

john stultz wrote:

>On Thu, 2007-04-26 at 16:26 -0400, Peter Keilty wrote:
>  
>
>>From: Peter Keilty <peter.keilty@hp.com>
>>
>>Initial ia64 conversion to the generic timekeeping/clocksource code.
>>
>>Signed-off-by: Peter Keilty <peter.keilty@hp.com>
>>Signed-off-by: John Stultz <johnstul@us.ibm.com>
>>    
>>
>
>Peter,
>	Thanks so much for pushing this on! I suspect this patch needs to be
>updated a touch, as I'm not sure if it still compiles in light of recent
>changes...
>
>  
>
John,

You are correct, you need patch 3/3 for it to compile and run.
I did a patch to the orginal patch, thought that was correct thing to do.
But I can make a new patch 1 from the orginal of ours and my #3.
I would also make an update to the #2 patch from #3 for ntp correct change.
That would be just 2 patches then, the enable_ia64 and remove_interpolater.
What do you think?

>  
>
>>diff --git a/arch/ia64/kernel/cyclone.c b/arch/ia64/kernel/cyclone.c
>>index e00b215..280383b 100644
>>--- a/arch/ia64/kernel/cyclone.c
>>+++ b/arch/ia64/kernel/cyclone.c
>>@@ -3,6 +3,7 @@ #include <linux/smp.h>
>> #include <linux/time.h>
>> #include <linux/errno.h>
>> #include <linux/timex.h>
>>+#include <linux/clocksource.h>
>> #include <asm/io.h>
>>
>> /* IBM Summit (EXA) Cyclone counter code*/
>>@@ -18,13 +19,21 @@ void __init cyclone_setup(void)
>> 	use_cyclone = 1;
>> }
>>
>>+static void __iomem *cyclone_mc_ptr;
>>
>>-struct time_interpolator cyclone_interpolator = {
>>-	.source =	TIME_SOURCE_MMIO64,
>>-	.shift =	16,
>>-	.frequency =	CYCLONE_TIMER_FREQ,
>>-	.drift =	-100,
>>-	.mask =		(1LL << 40) - 1
>>+static cycle_t read_cyclone(void)
>>+{
>>+	return (cycle_t)readq((void __iomem *)cyclone_mc_ptr);
>>+}
>>+
>>+static struct clocksource clocksource_cyclone = {
>>+        .name           = "cyclone",
>>+        .rating         = 300,
>>+        .read           = read_cyclone,
>>+        .mask           = (1LL << 40) - 1,
>>    
>>
>
>Daniel Walker pointed out to me on IRC that CLOCKSOURCE_MASK() should
>probably be used here.
>
>  
>
>>+        .mult           = 0, /*to be caluclated*/
>>+        .shift          = 16,
>>+        .is_continuous  = 1,
>>    
>>
>
>.is_continuous no longer exists. 
>
>You want to use:
>.flags = CLOCK_SOURCE_IS_CONTINUOUS 
>
>This holds for all the clocksources introduced.
>
>
>thanks
>-john
>
>
>  
>
