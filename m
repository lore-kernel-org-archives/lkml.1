Return-Path: <linux-kernel-owner+w=401wt.eu-S1763134AbXGMQrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763134AbXGMQrQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 12:47:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932191AbXGMQqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 12:46:42 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:35704 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760652AbXGMQqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 12:46:40 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Huang, Ying" <ying.huang@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH 0/2] Kexec jump: The first step to kexec base hibernation
References: <1184167831.12556.13.camel@caritas-dev.intel.com>
	<20070711172243.ab44c4d4.akpm@linux-foundation.org>
	<1184251423.9346.55.camel@caritas-dev.intel.com>
	<m14pk9fuqa.fsf@ebiederm.dsl.xmission.com>
	<1184368525.1069.68.camel@caritas-dev.intel.com>
Date: Fri, 13 Jul 2007 10:43:03 -0600
In-Reply-To: <1184368525.1069.68.camel@caritas-dev.intel.com> (Ying Huang's
	message of "Fri, 13 Jul 2007 23:15:25 +0000")
Message-ID: <m1k5t4dzl4.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Huang, Ying" <ying.huang@intel.com> writes:

> On Thu, 2007-07-12 at 10:32 -0600, Eric W. Biederman wrote:
>> >
>> > 1. Separate device suspend from device hibernate.
>> 
>> Actually in some very practical sense we already have two copies of
>> this in the kernel.  device_shutdown and the hotunplug/module
>> remove code.  So it is should be mostly a matter of using what we have.
>
> Maybe I misuse the terminology. The "device hibernate" here means put
> device into quiescent state and save the device state into memory for
> later restore.
>
> But, how to restore device state after jumping back from kexeced kernel
> if device_shutdown or hotplug/module removing code is used?

With device_shutdown there really isn't a path (although putting
the device into a quiescent state is exactly what that method does).

However with the module remove path you disassociate the pci device
and the pci device driver and then after restore you go through
the pci devices and you redo the association (as if the pci
device or the module had just been loaded).

For devices that have a really slow probe/initialization this might be
an issue but it will work, and generally it will work fairly quickly.

So in that sense restore may be the wrong concept for devices.
At least for prototypes.

>> Basically all this entails is to modify sys_reboot()
>> and adding a LINUX_REBOOT_CMD_KSPAWN and have that command
>> enter the kexec path with the appropriate set of calls.
>> I would be really surprised if this winds up with much
>> more code then the current kernel_kexec function.
>
> Yes, this is the right place to trigger kexec jump. Thank you for your
> valuable comments. It seems that just the device state
> quiesce/save/restore and CPU state save/restore code need to be
> added.

Yes.

For cpu state I'm fairly certain we don't need to do anything fancy.

At least for the first pass prototyping with a uniprocessor kernel
will remove that hurdle.


>> For prototyping I would:
>> - reserve a chunk of memory (possibly with the crashkernel= option)
>>   and run a relocatable kernel out of it.  
>> 
>>   By using the normal kexec you can boot a relocatable restore kernel
>>   in that reserved region. It is an extra step but it makes things
>>   work today.
>> 
>> - I would use the normal sys_kexec_load.
>> 
>> - I would debug/tweak the user space and the code to reenter the
>>   old kernel.  I.e. the device driver stop/start code.
>
> The above 3 steps are exactly what I have done in this patch. I reserve
> memory with crashkernel=, use sys_kexec_load (kexec -p ...) to load the
> kexec kernel and manage to jump back to normal kernel. But I should not
> mix the kexec jump trigger code with the software suspend code, that is,
> use "kexec -e", not "echo disk > /sys/power/state".

Right.  That caused all kinds of weirdness in your patch.


>> > 5. A smooth resume process. Maybe it is not needed to kexec a new kernel
>> > for resume. For example, in the first stage of kernel boot, just first
>> > 16M (or a little more) RAM is used, if the resume image is found, the
>> > saved kernel image is resumed; if the resume image is not found, turn on
>> > the remaining RAM. This will depends on 3.
>> 
>> Well I expect the resume will be load the resumed kernel into reserved
>> memory.  And kexec a very small assembly stub that will jump back
>> to the code in relocate_kernel.S which will call ret.
>> 
>> Then either hot add the rest of our memory or kexec to a kernel without
>> restrictions.
>
> Why a assembly stub is necessary? Is it not sufficient that just
> continue to complete a normal boot (hot add the reset of memory) or load
> the hibernated kernel (hibernated image) and jump to it?

I was thinking the assembly stub would be the small piece that jumps
to loaded hibernated kernel.  Quite possibly we could just get away
with providing no memory and just an entry point to kexec but it
makes sense to me to plan on running a couple of instructions.

Actually the way the kexec infrastructure it might be reasonable to
just use sys_kexec_load to load the entire hibernated image.  Except
for the fact that sys_kexec_load requires the source pages to be
in the processes memory image the code shouldn't have the 50% of
memory limitation already.

If we can get that going we don't even need to restrict the first
kernels memory.  So it might just require teaching sys_kexec_load
how to steal process pages.  Anyway something to think about.

>> Well just not loading drivers you aren't going to use and generally avoiding
>> long disk probing times will help here.  We control all of the code so
>> it should be relatively straight forward.
>
> Just not loading unnecessary drivers may be sufficient. But further
> optimization is also possible.
>
> The basic idea of optimization is:
>
> For first run:
>
> 1. boot the normal kernel A
> 2. kexec the hibernate kernel B
> 3. jump back to kernel A
> 4. Save the kernel B into a image
> 5. Work under kernel A.
>
> For normal use:
>
> 1. boot the normal kernel A
> 2. resume the image of kernel B
> 3. jump to kernel B
> 4. Save the kernel A into image

Yes.  That may help.  Cooperative multitasking between kernels.

Anyway all of that comes after we get something simple working.
Then we can see what really needs to be optimized, and what works
well enough.

Eric
