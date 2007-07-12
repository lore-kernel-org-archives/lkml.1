Return-Path: <linux-kernel-owner+w=401wt.eu-S1763991AbXGLKQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763991AbXGLKQY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 06:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753031AbXGLKQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 06:16:17 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:47072
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbXGLKQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 06:16:16 -0400
Date: Thu, 12 Jul 2007 03:10:54 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "Huang, Ying" <ying.huang@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH 0/2] Kexec jump: The first step to kexec	base	hibernation
In-Reply-To: <1184260683.9346.91.camel@caritas-dev.intel.com>
Message-ID: <Pine.LNX.4.64.0707120247230.25614@asgard.lang.hm>
References: <1184167831.12556.13.camel@caritas-dev.intel.com> 
 <20070711172243.ab44c4d4.akpm@linux-foundation.org> 
 <1184251423.9346.55.camel@caritas-dev.intel.com> 
 <Pine.LNX.4.64.0707112345250.28090@asgard.lang.hm>
 <1184260683.9346.91.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jul 2007, Huang, Ying wrote:

> On Thu, 2007-07-12 at 00:03 -0700, david@lang.hm wrote:
>>>
>>> The kexec jump is the first step, maybe the simplest step. There are
>>> many other issues to be resolved, at least the following ones.
>>>
>>> 1. Separate device suspend from device hibernate.
>>
>
> Maybe my usage of terminology has some problem. But, the "device
> hibernate" here means put device into quiescent state and save the
> device state, but do not put device into low power state.

is there really enough savings (in time or otherwise) to make it worth 
splitting this into two steps? for suspend-to-ram we definantly will need 
to option to go all the way to a low power state, there's significant 
extra complexity if you also have a state between normal operation and 
this low power state.

it may be worth doing if the low-power state is expensive (in time or 
effort) to get to or from and the lesser state allows the computer overall 
to save power (like the different cpu C states)

but I suspect that the number of drivers where this is worth doing is 
relativly small, and it may be a better approach to start off with just 
putting everything into the low-power state until some drive shows up that 
makes it worth adding the intermediate state to the system (and drivers 
wouldn't have to change, if they only support one suspend state it's the 
low-power one, if they support more then higher layers choose which ones 
to move to)

>>> 6. Reduce the boot-up time of kexec kernel. Maybe the kexec kernel can
>>> be hibernate/resume by the normal kernel too. This way, a real
>>> kexec/boot-up is only needed for the first time.
>>
>> the hibernate kernel shouldn't need a lot of the features of the standard
>> kerneel (does it really need sound for example), and if tailored even
>> tighter could be configured to only have the drivers actually used for the
>> save and restore, makeing a _very_ minimal kernel (no USB, no network,
>> only simple video drivers, etc) greatly speeding up the boot
>
> There is no need for two kernel. Most drivers and optional features are
> compiled as modules, as that of most desktop distributions. So just
> "insmod" needed modules only in hibernate kernel is sufficient.

actually, I think that while you may be able to get away with only one 
kernel, you are probably better off with two. on the hibernate kernel you 
can choose many 'embedded' options that don't make sense for the normal 
kernel (no high mem, no SMP support, no SELinux, no network routing, not 
netfilter, use SLOB not SLAB/SLUB, etc). also keep in mind that each 
module that you load wastes apartial page of memory.

remember people run complete linux systems in 8M of ram, a syspend system 
for a simple 'write the ram image to partition X on this IDE drive' should 
be aiming at 2-4M of memory.

more complex setups may want more space, but let the distros bloat things 
up, design and demo an optimized system :-)

David Lang
