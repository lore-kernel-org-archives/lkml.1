Return-Path: <linux-kernel-owner+w=401wt.eu-S1760215AbXGLGtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760215AbXGLGtk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 02:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753105AbXGLGtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 02:49:33 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:59640
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003AbXGLGtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 02:49:32 -0400
Date: Wed, 11 Jul 2007 23:43:39 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       "Huang, Ying" <ying.huang@intel.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH 0/2] Kexec jump: The first step to kexec base hibernation
In-Reply-To: <4695C096.5080400@goop.org>
Message-ID: <Pine.LNX.4.64.0707112319550.28090@asgard.lang.hm>
References: <1184167831.12556.13.camel@caritas-dev.intel.com>
 <20070711172243.ab44c4d4.akpm@linux-foundation.org> <4695C096.5080400@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2007, Jeremy Fitzhardinge wrote:

> Andrew Morton wrote:
>>  On Wed, 11 Jul 2007 15:30:31 +0000
>>  "Huang, Ying" <ying.huang@intel.com> wrote:
>> 
>> >  1. Boot a kernel A
>> >  2. Work under kernel A
>> >  3. Kexec another kernel B in kernel A
>> >  4. Work under kernel B
>> >  5. Jump from kernel B to kernel A
>> >  6. Continue work under kernel A
>> > 
>> >  This is the first step to implement kexec based hibernation. If the
>> >  memory image of kernel A is written to or read from a permanent media
>> >  in step 4, a preliminary version of kexec based hibernation can be
>> >  implemented.
>> > 
>> >  The kernel B is run as a crashdump kernel in reserved memory
>> >  region. This is the biggest constrains of the patch. It is planed to
>> >  be eliminated in the next version. That is, instead of reserving memory
>> >  region previously, the needed memory region is backuped before kexec
>> >  and restored after jumping back.
>> > 
>> >  Another constrains of the patch is that the CONFIG_ACPI must be turned
>> >  off to make kexec jump work. Because ACPI will put devices into low
>> >  power state, the kexeced kernel can not be booted properly under
>> >  it. This constrains can be eliminated by separating the suspend method
>> >  and hibernation method of the devices as proposed earlier in the LKML.
>> > 
>> >  The kexec jump is implemented in the framework of software suspend. In
>> >  fact, the kexec based hibernation can be seen as just implementing the
>> >  image writing and reading method of software suspend with a kexeced
>> >  Linux kernel.
>> > 
>
> I guess I'm (still) confused by the terminology here.  Do you mean that it 
> fits into suspend-to-disk as a disk-writing mechanism, or in suspend-to-ram 
> as a way of going to sleep?

Suspend-to-ram involves stopping the system and shutting down devices to 
go into low-power mode, then on wakeup restarting devices and resuming 
operation

so the steps would be.

1. stop userspace

2. walk the system device tree and put devices to sleep

3. go into the lowest power mode available and wait for a wakeup signal

later

4. walk the system device tree and wake up devices

5. resume userspace scheduling.

note that what devices get put to sleep could be configurable, potentially 
to the extreme of things like the OLPC (that have hardware designed for 
cheap sleeping) going into a light suspend-to-ram state between keystrokes 
if nothing else has a timer event scheduled before that.

Suspend-do-disk (Hibernate) involves stopping the system, makeing a 
snapshot of ram, writing the snapshot to somewhere and powering off the 
box. on wakeup (power-on) a helper kernel boots, loads the snapshot into 
ram and jumps to the kernel in the snapshot to resume operation.

as I understand the proposal the thought is to do the following

1. system kernel does suspend-to-ram to put the devices into a known safe 
state.

2. system kernel uses kexec to start hibernate kernel

3. hibernate kernel wakes up devices it needs as if it was doing a 
resume-from-ram

4. hibernate kernel copies ram image somewhere

5. hibernate kernel shuts down the box

later

6. hibernate kernel boots

7. hibernate kernel copies ram image from somewhere

8. hibernate kernel does syspend-to-ram to put the devices into a known 
safe state.

9. hibernate kernel uses kexec to start system kernel

10. system kernel wakes up devices it needs as if it was doing a 
resume-from-ram.

>> >  Now, only the i386 architecture is supported. The patch is based on
>> >  Linux kernel 2.6.22, and has been tested on my IBM T42.
>> > 
>>
>>  This sounds awesome.  Am I correct in expecting that ultimately the
>>  existing hibernation implementation just goes away and we reuse (and hence
>>  strengthen) the existing kexec (and kdump?) infrastructure?
>>
>>  And that we get hibernation support almost for free on all kexec (and
>>  relocatable-kernel?) capable architectures?
>>
>>  And that all the management of hibernation and resume happens in
>>  userspace?

this is the thought.

>>  I didn't understand the ACPI problem.  Does this mean that CONFIG_ACPI
>>  must
>>  be disabled in the to-be-hibernated kernel, or in the little transient
>>  kexec kernel?
>> 
>
> I think the point is that if kernel A says "I'm suspending" and calls the 
> suspend method on all its devices, then kernel B finds that it has no powered 
> on devices to work with.  But then couldn't it turn on the ones it wants 
> anyway?  And don't you want to suspend them, to make sure they're not still 
> DMAing memory while B is trying to shuffle everything off to disk?

I don't understand the ACPI problem so I can't try to clarify it.

> It does sound pretty cool.

re-useing existing components in new ways, making it so that particular 
problems only have to be solved once and that solution is used repeatedly. 
there's a lot to like about this approach.

very cool.

David Lang
