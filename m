Return-Path: <linux-kernel-owner+w=401wt.eu-S933235AbYAaTNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933235AbYAaTNY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 14:13:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761407AbYAaTNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 14:13:09 -0500
Received: from numenor.qualcomm.com ([129.46.51.58]:36065 "EHLO
	numenor.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761474AbYAaTNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 14:13:07 -0500
Message-ID: <47A21DC0.7030202@qualcomm.com>
Date: Thu, 31 Jan 2008 11:13:04 -0800
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Mark Hounschell <dmarkh@cfl.rr.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [CPUISOL] CPU isolation extensions
References: <1201493382-29804-1-git-send-email-maxk@qualcomm.com> <47A1BC0D.3040404@cfl.rr.com>
In-Reply-To: <47A1BC0D.3040404@cfl.rr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,
> maxk@qualcomm.com wrote:
>> Following patch series extends CPU isolation support. Yes, most people want to virtuallize 
>> CPUs these days and I want to isolate them :).
>> The primary idea here is to be able to use some CPU cores as dedicated engines for running
>> user-space code with minimal kernel overhead/intervention, think of it as an SPE in the 
>> Cell processor.
>>
>> We've had scheduler support for CPU isolation ever since O(1) scheduler went it. 
>> I'd like to extend it further to avoid kernel activity on those CPUs as much as possible.
>> In fact that the primary distinction that I'm making between say "CPU sets" and 
>> "CPU isolation". "CPU sets" let you manage user-space load while "CPU isolation" provides
>> a way to isolate a CPU as much as possible (including kernel activities).
>>
>> I'm personally using this for hard realtime purposes. With CPU isolation it's very easy to 
>> achieve single digit usec worst case and around 200 nsec average response times on off-the-shelf
>> multi- processor/core systems under exteme system load. I'm working with legal folks on releasing 
>> hard RT user-space framework for that.
>> I can also see other application like simulators and stuff that can benefit from this.
>>
>> I've been maintaining this stuff since around 2.6.18 and it's been running in production
>> environment for a couple of years now. It's been tested on all kinds of machines, from NUMA
>> boxes like HP xw9300/9400 to tiny uTCA boards like Mercury AXA110.
>> The messiest part used to be SLAB garbage collector changes. With the new SLUB all that mess 
>> goes away (ie no changes necessary). Also CFS seems to handle CPU hotplug much better than O(1) 
>> did (ie domains are recomputed dynamically) so that isolation can be done at any time (via sysfs). 
>> So this seems like a good time to merge. 
>>
>> Anyway. The patchset consist of 5 patches. First three are very simple and non-controversial.
>> They simply make "CPU isolation" a configurable feature, export cpu_isolated_map and provide
>> some helper functions to access it (just like cpu_online() and friends).
>> Last two patches add support for isolating CPUs from running workqueus and stop machine.
>> More details in the individual patch descriptions.
>>
>> Ideally I'd like all of this to go in during this merge window. If people think it's acceptable 
>> Linus or Andrew (or whoever is more appropriate Ingo maybe) can pull this patch set from
>> 	git://git.kernel.org/pub/scm/linux/kernel/git/maxk/cpuisol-2.6.git
>>
> 
> It's good to see hear from someone else that thinks a multi-processor
> box _should_ be able to run a CPU intensive (%100) RT app on one of the
> processors without adversely affecting or being affected by the others.
> I have had issues that were _traced_ back to the fact that I am doing
> just that. All I got was, you can't do that or we don't support that
> kind of thing in the Linux kernel.
> 
> One example,  Andrew Mortons feedback to the LKML thread "floppy.c soft lockup"
> 
> Good luck with this. I hope this gets someones attention.
Thanks for the support. I do the best I can because just like you I believe that it's
a perfectly valid workload and there a lot of interesting applications that will benefit
from mainline support.

> BTW, I have tried your patches against a vanilla 2.6.24 kernel but am
> not successful.
> 
> # echo '1' > /sys/devices/system/cpu/cpu1/isolated
> bash: echo: write error: Device or resource busy
You have to bring it offline first.
In other words:
echo 0 > /sys/devices/system/cpu/cpu1/online
echo 1 > /sys/devices/system/cpu/cpu1/isolated
echo 1 > /sys/devices/system/cpu/cpu1/online

> The cpuisol=1 cmdline option yields:
> 
> harley:# cat /sys/devices/system/cpu/cpu1/isolated
> 0
> 
> harley:# cat /proc/cmdline
> root=/dev/sda3 vga=normal apm=off selinux=0 noresume splash=silent
> kmalloc=192M cpuisol=1
Sorry my bad. I had a typo in the patch description the option is "isolcpus=N".
We've had that option for awhile now. I mean it's not even part of my patch.

Thanx
Max
