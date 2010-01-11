Return-Path: <linux-kernel-owner+w=401wt.eu-S1752040Ab0AKDiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040Ab0AKDiR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 22:38:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751277Ab0AKDiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 22:38:17 -0500
Received: from rex.securecomputing.com ([203.24.151.4]:58600 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750879Ab0AKDiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 22:38:16 -0500
Message-ID: <4B4A9D29.7040907@snapgear.com>
Date: Mon, 11 Jan 2010 13:38:17 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: Steven King <sfking@fdwdc.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.33-rc1: hrtimers and tickless broken on m68knommu.
References: <200912181813.44220.sfking@fdwdc.com>	 <1f1b08da0912181844u4f7e66a7ue30287208d075327@mail.gmail.com>	 <200912181920.12905.sfking@fdwdc.com> <1261195463.4115.126.camel@localhost.localdomain>
In-Reply-To: <1261195463.4115.126.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

Sorry for no response on this, I have been away.


john stultz wrote:
> On Fri, 2009-12-18 at 19:20 -0800, Steven King wrote:
>> On Friday 18 December 2009 06:44:44 john stultz wrote:
>>> On Fri, Dec 18, 2009 at 6:13 PM, Steven King <sfking@fdwdc.com> wrote:
>>>> Attach is the .config; it works on v2.6.32 but fails to boot on .33-rc1;
>>>> but if I deselect hrtimers && tickless then it works.
>>> Sorry for the dup, forgot to cc lkml on my reply.
>>>
>>> Fails to boot all together? Or does it hang at some point in the dmesg
>>> that you can point out?
>> fails to boot all together; nothing on the serial console.
>>> Could you run the following so we can narrow down which clocksource your
>>> using? cat /sys/devices/system/clocksource/clocksource0/current_clocksource
>>> cat /sys/devices/system/clocksource/clocksource0/available_clocksource
>>>
>>> Then with the kernel that doesn't boot, go through the clocksources
>>> listed in available_clocksources and try booting w/
>>> "clocksource=<clock name>" and see if the behavior changes.
>> on the working .32 kernel:
>>
>> # cat /sys/devices/system/clocksource/clocksource0/current_clocksource
>> pit
>> # cat /sys/devices/system/clocksource/clocksource0/available_clocksource
>> pit
>>
>> just to be sure, I tried clocksource=pit on the .33-rc1 kernel.  It didnt make 
>> any difference.
> 
> 
> Hrmm.. So looking at the code in arch/m68knommu/platform/coldfire/pit.c,
> I'm a little confused on how this got marked as a continuous clocksource
> (CLOCK_SOURCE_IS_CONTINUOUS), especially as it seems it couldn't handle
> skipping an interrupt.
> 
> That said, I'm not sure how it worked in 2.6.32, as its been that way
> for awhile it seems.  Maybe my assumptions on how the PIT works is wrong
> (or just biased in how it works on x86)?
> 
> Greg, could you clarify how the PIT can be used as a clocksource if its
> also being used in oneshot mode?

Looks broken. As Steven noted we just seem to have gotten away
with it, with no obvious breakage so far.

I see from follow-ons to this that Andrew has picked it up.
So I'll just ack that and let him push it.

Thanks
Greg


> Steven, I assume the patch below avoids the issue (by disabling highres
> timers and nohz)?
> 
> thanks
> -john
> 
> 
> 
> The m68knommu coldfire pit clocksource looks like it was incorrectly
> marked as a continuous clocksource. From the looks of it, running with
> it marked as a continuous clocksource could cause hangs when the system
> switches to highres mode or enables nohz.  I have no idea why it worked
> in prior kernels, and I'm not 100% sure the following fix is really the
> right solution.
> 
> This patch removes the CLOCK_SOURCE_IS_CONTINUOUS flag on the coldfire
> pit clocksource. This will disallow systems using this clocksource from
> entering oneshot mode (disabling highres timers and nohz).
> 
> Signed-off-by: John Stultz <johnstul@us.ibm.com>
> 
> ---
> 
> diff --git a/arch/m68knommu/platform/coldfire/pit.c b/arch/m68knommu/platform/coldfire/pit.c
> index d8720ee..aebea19 100644
> --- a/arch/m68knommu/platform/coldfire/pit.c
> +++ b/arch/m68knommu/platform/coldfire/pit.c
> @@ -146,7 +146,6 @@ static struct clocksource pit_clk = {
>  	.read	= pit_read_clk,
>  	.shift	= 20,
>  	.mask	= CLOCKSOURCE_MASK(32),
> -	.flags	= CLOCK_SOURCE_IS_CONTINUOUS,
>  };
>  
>  /***************************************************************************/
> 
> 
> 


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
