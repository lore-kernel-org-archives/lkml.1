Return-Path: <linux-kernel-owner+w=401wt.eu-S1761672AbXGLTCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761672AbXGLTCz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 15:02:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755382AbXGLTCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 15:02:47 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:42166
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755124AbXGLTCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 15:02:47 -0400
Date: Thu, 12 Jul 2007 11:57:36 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH 0/2] Kexec jump: The first step to kexec base hibernation
In-Reply-To: <200707121453.49616.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.64.0707121150460.25614@asgard.lang.hm>
References: <1184167831.12556.13.camel@caritas-dev.intel.com>
 <20070711172243.ab44c4d4.akpm@linux-foundation.org>
 <1184251423.9346.55.camel@caritas-dev.intel.com> <200707121453.49616.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jul 2007, Rafael J. Wysocki wrote:

>>> I didn't understand the ACPI problem.  Does this mean that CONFIG_ACPI must
>>> be disabled in the to-be-hibernated kernel, or in the little transient
>>> kexec kernel?
>>
>> Under current implementation of device state quiescent/save/restore, the
>> CONFIG_ACPI must be turned off both in to-be-hibernated kernel and
>> transient kexec kernel.
>>
>> But the hibernation people are going to separate the device suspend from
>> device hibernate. The device hibernate will put device in quiescent
>> state but not in low power state. When this is done, it is not necessary
>> to disable CONFIG_ACPI at all. It is just a workaround for current
>> implementation that disabling CONFIG_ACPI.
>>
>>> How close do you think all this is to being a viable thing?
>>
>> The kexec jump is the first step, maybe the simplest step. There are
>> many other issues to be resolved, at least the following ones.
>>
>> 1. Separate device suspend from device hibernate.
>
> Step 0, I'd say. :-)

is there more involved then just start ignoreing device hibernate and just 
useing the device suspend? (although if there is not a workable device 
suspend for a driver, that would answer my question :-)

>> 2. Do not reserve memory for kexec kernel. That is, backup needed memory
>> before kexec and restore them after kexec.
>
> I don't think this is very important initially.

I agree, a stipped down hibernate kernel can be very small, not allocating 
this memory until it's needed is a step for the final polishing.

>> 3. Support the in-place kexec? The relocatable kernel is not necessary
>> if this can be implemented.
>> 4. Image writing/reading. (Only user space application is needed).
>
> And a kernel interface for that application.

I do't understand this statement, this application is just useing the 
standard kernel interfaces (block devices to read/write to disk, network 
devices to read/write to a server, etc). no new interfaces needed.

>> 5. A smooth resume process. Maybe it is not needed to kexec a new kernel
>> for resume. For example, in the first stage of kernel boot, just first
>> 16M (or a little more) RAM is used, if the resume image is found, the
>> saved kernel image is resumed; if the resume image is not found, turn on
>> the remaining RAM. This will depends on 3.
>
> I think that this is the most difficult part of the whole thing.

don't try to get too fancy right now. stick with a simple 'boot hibernate 
kernel, it's userspace looks for an image to resume, and if it doesn't 
find one reboot to the normal system'

I don't know how to do this with grub, but it would be a trivial shell 
script with lilo

>> 6. Reduce the boot-up time of kexec kernel. Maybe the kexec kernel can
>> be hibernate/resume by the normal kernel too. This way, a real
>> kexec/boot-up is only needed for the first time.
>
> I'm not sure what you mean.

he's trying to get fancy again, the best way to speed up the boot of the 
kexec kernel is make it smaller and avoid probing for devices (hotplug 
should NOT be used for normal suspend situations)

David Lang
