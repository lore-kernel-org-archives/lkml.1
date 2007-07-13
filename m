Return-Path: <linux-kernel-owner+w=401wt.eu-S936366AbXGMPQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936366AbXGMPQW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 11:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761514AbXGMPQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 11:16:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:31669 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759381AbXGMPQN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 11:16:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,537,1175497200"; 
   d="scan'208";a="105946076"
Subject: Re: [PATCH 0/2] Kexec jump: The first step to kexec base
	hibernation
From: "Huang, Ying" <ying.huang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
In-Reply-To: <m14pk9fuqa.fsf@ebiederm.dsl.xmission.com>
References: <1184167831.12556.13.camel@caritas-dev.intel.com>
	 <20070711172243.ab44c4d4.akpm@linux-foundation.org>
	 <1184251423.9346.55.camel@caritas-dev.intel.com>
	 <m14pk9fuqa.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 13 Jul 2007 23:15:25 +0000
Message-Id: <1184368525.1069.68.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-OriginalArrivalTime: 13 Jul 2007 15:16:08.0579 (UTC) FILETIME=[BD3D4530:01C7C560]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-12 at 10:32 -0600, Eric W. Biederman wrote:
> >
> > 1. Separate device suspend from device hibernate.
> 
> Actually in some very practical sense we already have two copies of
> this in the kernel.  device_shutdown and the hotunplug/module
> remove code.  So it is should be mostly a matter of using what we have.

Maybe I misuse the terminology. The "device hibernate" here means put
device into quiescent state and save the device state into memory for
later restore.

But, how to restore device state after jumping back from kexeced kernel
if device_shutdown or hotplug/module removing code is used?

> Basically all this entails is to modify sys_reboot()
> and adding a LINUX_REBOOT_CMD_KSPAWN and have that command
> enter the kexec path with the appropriate set of calls.
> I would be really surprised if this winds up with much
> more code then the current kernel_kexec function.

Yes, this is the right place to trigger kexec jump. Thank you for your
valuable comments. It seems that just the device state
quiesce/save/restore and CPU state save/restore code need to be added.

> This might wind up exactly the same as the current
> LINUX_REBOOT_CMD_KEXEC but at least until we have a working
> prototype it makes sense to allow for differences.
> 
> This should allow the kexec based implementation to coincide
> with the existing software suspend to disk code until it is proven out
> and then we can just remove all of the software suspend code to
> disk code.
> 
> > 2. Do not reserve memory for kexec kernel. That is, backup needed memory
> > before kexec and restore them after kexec.
> > 3. Support the in-place kexec? The relocatable kernel is not necessary
> > if this can be implemented.
> 
> It sounds like what you really want is the normal kexec path enhanced
> so that you can return to the kernel you started with.

Yes

> The normal kexec path already knows how to do the memory shuffle so
> it can do on demand memory allocation.  That code just needs to
> enhanced slightly so that you allocate an extra page, setup an inverse
> scatter gather list for restoring the pages, and teach relocate_kernel.S
> to preserve it's destination pages by using the inverse scatter gather
> list.

Yes, I have seen that code. The framework of current kexec memory
copying can be used for memory backup before kexec.

> The normal kexec path already calls device_shutdown and the like to
> stop devices from running.  Although again that code path is not
> prepared to restore the devices.

Yes, the device state quiesce/save/restore and CPU state save/restore
code should be added.

> For prototyping I would:
> - reserve a chunk of memory (possibly with the crashkernel= option)
>   and run a relocatable kernel out of it.  
> 
>   By using the normal kexec you can boot a relocatable restore kernel
>   in that reserved region. It is an extra step but it makes things
>   work today.
> 
> - I would use the normal sys_kexec_load.
> 
> - I would debug/tweak the user space and the code to reenter the
>   old kernel.  I.e. the device driver stop/start code.

The above 3 steps are exactly what I have done in this patch. I reserve
memory with crashkernel=, use sys_kexec_load (kexec -p ...) to load the
kexec kernel and manage to jump back to normal kernel. But I should not
mix the kexec jump trigger code with the software suspend code, that is,
use "kexec -e", not "echo disk > /sys/power/state".

>   Once it was basically working I would the update normal kexec
>   memory copy code in relocate.S to preserve the destination pages.

This is what I plan to do.

> > 4. Image writing/reading. (Only user space application is needed).
> 
> And possibly a few fixes to /dev/mem.  This is pretty much the same
> process as generating a core dump so there should be some synergy with that.
> 
> We probably want to use something like the ELF header the crashdump
> path uses to communicate to the kernel saving memory which memory
> regions need to be saved.  Which probably means that we you can use the
> exact same method as the kexec on panic kernel uses to save memory.

This sound good. The information in ELF header can be used to locate
necessary information for image writing.

> > 5. A smooth resume process. Maybe it is not needed to kexec a new kernel
> > for resume. For example, in the first stage of kernel boot, just first
> > 16M (or a little more) RAM is used, if the resume image is found, the
> > saved kernel image is resumed; if the resume image is not found, turn on
> > the remaining RAM. This will depends on 3.
> 
> Well I expect the resume will be load the resumed kernel into reserved
> memory.  And kexec a very small assembly stub that will jump back
> to the code in relocate_kernel.S which will call ret.
> 
> Then either hot add the rest of our memory or kexec to a kernel without
> restrictions.

Why a assembly stub is necessary? Is it not sufficient that just
continue to complete a normal boot (hot add the reset of memory) or load
the hibernated kernel (hibernated image) and jump to it?

> > 6. Reduce the boot-up time of kexec kernel. Maybe the kexec kernel can
> > be hibernate/resume by the normal kernel too. This way, a real
> > kexec/boot-up is only needed for the first time.
> 
> Well just not loading drivers you aren't going to use and generally avoiding
> long disk probing times will help here.  We control all of the code so
> it should be relatively straight forward.

Just not loading unnecessary drivers may be sufficient. But further
optimization is also possible.

The basic idea of optimization is:

For first run:

1. boot the normal kernel A
2. kexec the hibernate kernel B
3. jump back to kernel A
4. Save the kernel B into a image
5. Work under kernel A.

For normal use:

1. boot the normal kernel A
2. resume the image of kernel B
3. jump to kernel B
4. Save the kernel A into image

Best Regards,
Huang Ying
