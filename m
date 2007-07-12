Return-Path: <linux-kernel-owner+w=401wt.eu-S1763254AbXGLTKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763254AbXGLTKU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 15:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755283AbXGLTKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 15:10:07 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:35647
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755124AbXGLTKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 15:10:06 -0400
Date: Thu, 12 Jul 2007 12:03:58 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH 0/2] Kexec jump: The first step to
 =?iso-8859-1?q?kexec=09base=09hibernation?=
In-Reply-To: <200707121501.03016.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.64.0707121158300.25614@asgard.lang.hm>
References: <1184167831.12556.13.camel@caritas-dev.intel.com>
 <1184260683.9346.91.camel@caritas-dev.intel.com> <Pine.LNX.4.64.0707120247230.25614@asgard.lang.hm>
 <200707121501.03016.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jul 2007, Rafael J. Wysocki wrote:

> On Thursday, 12 July 2007 12:10, david@lang.hm wrote:
>> On Thu, 12 Jul 2007, Huang, Ying wrote:
>>
>>> On Thu, 2007-07-12 at 00:03 -0700, david@lang.hm wrote:
>>>>>
>>>>> The kexec jump is the first step, maybe the simplest step. There are
>>>>> many other issues to be resolved, at least the following ones.
>>>>>
>>>>> 1. Separate device suspend from device hibernate.
>>>>
>>>
>>> Maybe my usage of terminology has some problem. But, the "device
>>> hibernate" here means put device into quiescent state and save the
>>> device state, but do not put device into low power state.
>>
>> is there really enough savings (in time or otherwise) to make it worth
>> splitting this into two steps? for suspend-to-ram we definantly will need
>> to option to go all the way to a low power state, there's significant
>> extra complexity if you also have a state between normal operation and
>> this low power state.
>>
>> it may be worth doing if the low-power state is expensive (in time or
>> effort) to get to or from and the lesser state allows the computer overall
>> to save power (like the different cpu C states)
>>
>> but I suspect that the number of drivers where this is worth doing is
>> relativly small, and it may be a better approach to start off with just
>> putting everything into the low-power state until some drive shows up that
>> makes it worth adding the intermediate state to the system (and drivers
>> wouldn't have to change, if they only support one suspend state it's the
>> low-power one, if they support more then higher layers choose which ones
>> to move to)
>
> We've discussed that a lot on linux-pm and the conclusion is that devices
> should not be put into low power states before creating the hibernation
> image, because that leads to problems during the restore.

too bad, I was thinking that a driver in a low-power state could be 
initialized normally and we could avoid having different quiesce and 
low-power states

> In turn, during the restore, when the image has been loaded and the "old"
> kernel gets the control, it should reprobe devices and initialize them from
> scratch rather than doing something like "resume devices after suspend
> to RAM".

this makes sense.

>>>>> 6. Reduce the boot-up time of kexec kernel. Maybe the kexec kernel can
>>>>> be hibernate/resume by the normal kernel too. This way, a real
>>>>> kexec/boot-up is only needed for the first time.
>>>>
>>>> the hibernate kernel shouldn't need a lot of the features of the standard
>>>> kerneel (does it really need sound for example), and if tailored even
>>>> tighter could be configured to only have the drivers actually used for the
>>>> save and restore, makeing a _very_ minimal kernel (no USB, no network,
>>>> only simple video drivers, etc) greatly speeding up the boot
>>>
>>> There is no need for two kernel. Most drivers and optional features are
>>> compiled as modules, as that of most desktop distributions. So just
>>> "insmod" needed modules only in hibernate kernel is sufficient.
>>
>> actually, I think that while you may be able to get away with only one
>> kernel, you are probably better off with two. on the hibernate kernel you
>> can choose many 'embedded' options that don't make sense for the normal
>> kernel (no high mem, no SMP support, no SELinux, no network routing, not
>> netfilter, use SLOB not SLAB/SLUB, etc). also keep in mind that each
>> module that you load wastes apartial page of memory.
>>
>> remember people run complete linux systems in 8M of ram, a syspend system
>> for a simple 'write the ram image to partition X on this IDE drive' should
>> be aiming at 2-4M of memory.
>>
>> more complex setups may want more space, but let the distros bloat things
>> up, design and demo an optimized system :-)
>
> So if a user wants to install a kernel.org kernel on his system, (s)he'll have
> to compile and install two kernels with different options.

for now allow this option as it's the simplest to implement (it takes 
extra work to re-use the kernel)

also, the objections to the auto-config kernel requests have mostly been 
how it's impossible for the auto-config to get enough things right. in the 
case of a hibernate kernel I think it's such a minimal config that it 
should be possible to have an auto-config script that you tell 'I plan to 
suspend to partition X, give me a minimal kernel that can access ram, that 
partition, and the framebuffer (for status output)' and have it produce a 
tiny kernel with only thta support

> That doesn't sound good to me. :-)

on the other hand, booting a standard distro kernel that does hotplug 
detection for everything it can find on the system is far from optimal as 
well.

David Lang
