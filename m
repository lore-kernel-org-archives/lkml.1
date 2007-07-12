Return-Path: <linux-kernel-owner+w=401wt.eu-S935371AbXGLQg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935371AbXGLQg5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 12:36:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759799AbXGLQgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 12:36:46 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:54658 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756938AbXGLQgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 12:36:44 -0400
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
Date: Thu, 12 Jul 2007 10:32:45 -0600
In-Reply-To: <1184251423.9346.55.camel@caritas-dev.intel.com> (Ying Huang's
	message of "Thu, 12 Jul 2007 14:43:43 +0000")
Message-ID: <m14pk9fuqa.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I like the concept, but I completely disagree with your current
implementation.

I think it will be much easier if you start with a completely
independent code path and then just reuse the pieces of the
existing code path that you need.  

More details below.

"Huang, Ying" <ying.huang@intel.com> writes:

> On Wed, 2007-07-11 at 17:22 -0700, Andrew Morton wrote:
>> This sounds awesome.  Am I correct in expecting that ultimately the
>> existing hibernation implementation just goes away and we reuse (and hence
>> strengthen) the existing kexec (and kdump?) infrastructure?
>> And that we get hibernation support almost for free on all kexec (and
>> relocatable-kernel?) capable architectures?
>> And that all the management of hibernation and resume happens in userspace?
>
> Yes. Ultimately, most of the hibernation code such as process freezer,
> memory shrinking, memory snapshot (atomic copy), image reading/writing
> can go away, because kexec based hibernation doesn't depend on them.
> Just the device/CPU state quiescent/save/restore is necessary to remain.
> And, the management of hibernation and resume will happen in userspace.
>
>> I didn't understand the ACPI problem.  Does this mean that CONFIG_ACPI must
>> be disabled in the to-be-hibernated kernel, or in the little transient
>> kexec kernel?
>
> Under current implementation of device state quiescent/save/restore, the
> CONFIG_ACPI must be turned off both in to-be-hibernated kernel and
> transient kexec kernel.
>
> But the hibernation people are going to separate the device suspend from
> device hibernate. The device hibernate will put device in quiescent
> state but not in low power state. When this is done, it is not necessary
> to disable CONFIG_ACPI at all. It is just a workaround for current
> implementation that disabling CONFIG_ACPI.
>
>> How close do you think all this is to being a viable thing?
>
> The kexec jump is the first step, maybe the simplest step. There are
> many other issues to be resolved, at least the following ones.
>
> 1. Separate device suspend from device hibernate.

Actually in some very practical sense we already have two copies of
this in the kernel.  device_shutdown and the hotunplug/module
remove code.  So it is should be mostly a matter of using what we have.

Basically all this entails is to modify sys_reboot()
and adding a LINUX_REBOOT_CMD_KSPAWN and have that command
enter the kexec path with the appropriate set of calls.
I would be really surprised if this winds up with much
more code then the current kernel_kexec function.

This might wind up exactly the same as the current
LINUX_REBOOT_CMD_KEXEC but at least until we have a working
prototype it makes sense to allow for differences.

This should allow the kexec based implementation to coincide
with the existing software suspend to disk code until it is proven out
and then we can just remove all of the software suspend code to
disk code.

> 2. Do not reserve memory for kexec kernel. That is, backup needed memory
> before kexec and restore them after kexec.
> 3. Support the in-place kexec? The relocatable kernel is not necessary
> if this can be implemented.

It sounds like what you really want is the normal kexec path enhanced
so that you can return to the kernel you started with.

The normal kexec path already knows how to do the memory shuffle so
it can do on demand memory allocation.  That code just needs to
enhanced slightly so that you allocate an extra page, setup an inverse
scatter gather list for restoring the pages, and teach relocate_kernel.S
to preserve it's destination pages by using the inverse scatter gather
list.

The normal kexec path already calls device_shutdown and the like to
stop devices from running.  Although again that code path is not
prepared to restore the devices.

...

For prototyping I would:
- reserve a chunk of memory (possibly with the crashkernel= option)
  and run a relocatable kernel out of it.  

  By using the normal kexec you can boot a relocatable restore kernel
  in that reserved region. It is an extra step but it makes things
  work today.

- I would use the normal sys_kexec_load.

- I would debug/tweak the user space and the code to reenter the
  old kernel.  I.e. the device driver stop/start code.

  Once it was basically working I would the update normal kexec
  memory copy code in relocate.S to preserve the destination pages.

> 4. Image writing/reading. (Only user space application is needed).

And possibly a few fixes to /dev/mem.  This is pretty much the same
process as generating a core dump so there should be some synergy with that.

We probably want to use something like the ELF header the crashdump
path uses to communicate to the kernel saving memory which memory
regions need to be saved.  Which probably means that we you can use the
exact same method as the kexec on panic kernel uses to save memory.

> 5. A smooth resume process. Maybe it is not needed to kexec a new kernel
> for resume. For example, in the first stage of kernel boot, just first
> 16M (or a little more) RAM is used, if the resume image is found, the
> saved kernel image is resumed; if the resume image is not found, turn on
> the remaining RAM. This will depends on 3.

Well I expect the resume will be load the resumed kernel into reserved
memory.  And kexec a very small assembly stub that will jump back
to the code in relocate_kernel.S which will call ret.

Then either hot add the rest of our memory or kexec to a kernel without
restrictions.

> 6. Reduce the boot-up time of kexec kernel. Maybe the kexec kernel can
> be hibernate/resume by the normal kernel too. This way, a real
> kexec/boot-up is only needed for the first time.

Well just not loading drivers you aren't going to use and generally avoiding
long disk probing times will help here.  We control all of the code so
it should be relatively straight forward.

Eric
