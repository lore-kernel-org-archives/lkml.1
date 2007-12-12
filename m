Return-Path: <linux-kernel-owner+w=401wt.eu-S1754781AbXLLG2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781AbXLLG2b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 01:28:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754919AbXLLG2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 01:28:05 -0500
Received: from mga02.intel.com ([134.134.136.20]:10617 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754564AbXLLG2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 01:28:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,155,1196668800"; 
   d="scan'208";a="294127305"
Subject: Re: [PATCH 1/4 -mm] kexec based hibernation -v7 : kexec jump
From: "Huang, Ying" <ying.huang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Machek <pavel@ucw.cz>, nigel@nigel.suspend2.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
In-Reply-To: <m163z51sz3.fsf@ebiederm.dsl.xmission.com>
References: <1197042810.24045.61.camel@caritas-dev.intel.com>
	 <m1tzmq0xy0.fsf@ebiederm.dsl.xmission.com>
	 <1197388219.11506.32.camel@caritas-dev.intel.com>
	 <m163z51sz3.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 12 Dec 2007 14:27:36 +0800
Message-Id: <1197440856.14443.53.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 12 Dec 2007 06:27:56.0474 (UTC) FILETIME=[220FD1A0:01C83C88]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-12-11 at 02:27 -0700, Eric W. Biederman wrote:
> "Huang, Ying" <ying.huang@intel.com> writes:
> 
> > On Mon, 2007-12-10 at 19:25 -0700, Eric W. Biederman wrote:
> >> "Huang, Ying" <ying.huang@intel.com> writes:
> > [...]
> >> >  /*
> >> >   * Do not allocate memory (or fail in any way) in machine_kexec().
> >> >   * We are past the point of no return, committed to rebooting now.
> >> >   */
> >> > -NORET_TYPE void machine_kexec(struct kimage *image)
> >> > +int machine_kexec_vcall(struct kimage *image, unsigned long *ret,
> >> > +			 unsigned int argc, va_list args)
> >> >  {
> >> 
> >> Why do we need var arg support?
> >> Can't we do that with a shim we load from user space?
> >
> > If all parameters are provided in user space, the usage model may be as
> > follow:
> >
> > - sys_kexec_load() /* with executable/data/parameters(A) loaded */
> > - sys_reboot(,,LINUX_REBOOT_CMD_KEXEC,) /* execute physical mode code with
> > parameters(A)*/
> > - /* jump back */
> > - sys_kexec_load() /* with executable/data/parameters(B) loaded */
> > - sys_reboot(,,LINUX_REBOOT_CMD_KEXEC,) /* execute physical mode code with
> > parameters(B)*/
> > - /* jump back */
> >
> > That is, the kexec image should be re-loaded if the parameters are
> > different, and there can be no state reserved in kexec image. This is OK
> > for original kexec implementation, because there is no jumping back.
> > But, for kexec with jumping back, another usage model may be useful too.
> >
> > - sys_kexec_load() /* with executable/data loaded */
> > - sys_reboot(,,LINUX_REBOOT_CMD_KEXEC,parameters(A)) /* execute physical mode
> > code with parameters(A)*/
> > - sys_reboot(,,LINUX_REBOOT_CMD_KEXEC,parameters(B)) /* execute physical mode
> > code with parameters(B)*/
> >
> > This way the kexec image need not to be re-loaded, and the state of
> > kexec image can be reserved across several invoking.
> 
> Interesting.  We wind up preserving the code in between invocations.
> 
> I don't know about your particular issue, but I can see that clearly
> we need a way to read values back from our target image.
> 
> And if we can read everything back one way to proceed is to read
> everything out modify it and then write it back.
> 
> Amending a kexec image that is already stored may also make sense.
> 
> I'm not convinced that the var arg parameters make sense, but you
> added them because of a real need.
> 
> The kexec function is split into two separate calls so that we can
> unmount the filesystem the kexec image comes from before actually
> doing the kexec.

Yes. Reading/Modifying the loaded kexec image is another way to do
necessary communication between the first kernel and the second kernel.
In fact, the patch [4/4] of this series with title:

[PATCH 4/4 -mm] kexec based hibernation -v7 : kimgcore

provide a ELF CORE file in /proc (/proc/kimgcore) to read the loaded
kexec image. The writing function can be added easily.

But I think communication between the first kernel and the second kernel
via reading/modifying the loaded kernel image is not very convenient
way. The usage mode may be as follow:

- sys_kexec_load() /* with executable/data loaded */
- modify the loaded kexec image to set the parameters (A)
- sys_reboot(,,LINUX_REBOOT_CMD_KEXEC,) /* execute physical mode code with parameters(A)*/
- In physical mode code, check the parameters A and executing accordingly
- modify the loaded kexec image to set the parameters (B)
- sys_reboot(,,LINUX_REBOOT_CMD_KEXEC,) /* execute physical mode code with parameters(B)*/
- In physical mode code, check the parameters B and executing accordingly

There are some issues with this usage model:

- Some parameters in kernel needed to be exported (such as the
kimage->head to let the second kernel to read the memory contents of
backupped memory).

- The physical mode code invoker (the first kernel) need to know where
to write the parameters. A common protocol or a protocol case by case
should be defined. For example, the memory address after the entry point
of kexec image is a good candidate. But for Linux kernel, there are two
types of entry point, the "jump back entry" or "purgatory". Maybe
different protocol should be defined for these two types of entry point.

- For the user space of the second kernel to get the parameters. A
interface (maybe a file in /proc or /sys) should be provided to export
the parameters to user space.

So I think the current parameters passing mechanism may be more simple
and convenient (defined in Document/i386/jump_back_protocol.txt in the
patch).

There is only one user of var args. But I think it is simple to be
implemented and may be used by others.

> If extensive user space shutdown or startup is needed I will argue
> that doing the work in the sys_reboot call is the wrong place to
> do it.  Although if a jump back is happening we should not need
> much restart.

Now, the user space is not shut down or started up across kexec/jump
back, just the sys_reboot call is used to trigger the kexec/jump back.
Maybe sys_reboot is not the right place to do this. Can you recommended
a more suitable place?

> Can you generate a minimal patch with just the minimal necessary
> support to return from a kexec operation?

I plan to reduce the KEXEC_PRESERVE_XXX flags into one
KEXEC_PRESERVE_CONTEXT. The var args part may be changed if we have the
consensus.

> > Another usage model may be useful is invoking the kexec image (such as
> > firmware) from kernel space.
> >
> > - kmalloc the needed memory and loaded the firmware image (if needed)
> > - sys_kexec_load() with a fake image (one segment with size 0), the
> > entry point of the fake image is the entry point of the firmware image.
> > - kexec_call(fake_image, ...) /* maybe change entry point if needed */
> >
> > This way, some kernel code can invoke the firmware in physical mode just
> > like invoking an ordinary function.
> 
> That certainly seems interesting.  But that doesn't justify the vararg
> part of this.
> 
> > [...]
> >> > -	/* The segment registers are funny things, they have both a
> >> > -	 * visible and an invisible part.  Whenever the visible part is
> >> > -	 * set to a specific selector, the invisible part is loaded
> >> > -	 * with from a table in memory.  At no other time is the
> >> > -	 * descriptor table in memory accessed.
> >> > -	 *
> >> > -	 * I take advantage of this here by force loading the
> >> > -	 * segments, before I zap the gdt with an invalid value.
> >> > -	 */
> >> > -	load_segments();
> >> > -	/* The gdt & idt are now invalid.
> >> > -	 * If you want to load them you must set up your own idt & gdt.
> >> > -	 */
> >> > -	set_gdt(phys_to_virt(0),0);
> >> > -	set_idt(phys_to_virt(0),0);
> >> > +	if (image->preserve_cpu_ext) {
> >> > +		/* The segment registers are funny things, they have
> >> > +		 * both a visible and an invisible part.  Whenever the
> >> > +		 * visible part is set to a specific selector, the
> >> > +		 * invisible part is loaded with from a table in
> >> > +		 * memory.  At no other time is the descriptor table
> >> > +		 * in memory accessed.
> >> > +		 *
> >> > +		 * I take advantage of this here by force loading the
> >> > +		 * segments, before I zap the gdt with an invalid
> >> > +		 * value.
> >> > +		 */
> >> > +		load_segments();
> >> > +		/* The gdt & idt are now invalid.  If you want to load
> >> > +		 * them you must set up your own idt & gdt.
> >> > +		 */
> >> > +		set_gdt(phys_to_virt(0), 0);
> >> > +		set_idt(phys_to_virt(0), 0);
> >> > +	}
> >> 
> >> We can't keep the same idt and gdt as the pages they are on will be
> >> overwritten/reused.  So explictily stomping on them sounds better
> >> so they never work.  We can restore them on kernel reentry.
> >
> > The original idea about this code is:
> >
> > If the kexec image is claimed that it need not to "perserving extensive
> > CPU state" (such as FPU/MMX/GDT/LDT/IDT/CS/DS/ES/FS/GS/SS etc), the
> > IDT/GDT/CS/DS/ES/FS/GS/SS are not touched in kexec image code. So the
> > segment registers need not to be set.
> >
> > But this is not clear. At least more description should be provided for
> > each preserve flag.
> 
> yes.
> 
> >> >  	/* now call it */
> >> > -	relocate_kernel((unsigned long)image->head, (unsigned long)page_list,
> >> > -			image->start, cpu_has_pae);
> >> > +	relocate_kernel_ptr((unsigned long)image->head,
> >> > +			    (unsigned long)page_list,
> >> > +			    image->start, cpu_has_pae);
> >> 
> >> Why rename relocate_kernel?
> >> Ah.  I see.  You need to make it into a pointer again.  The crazy don't
> >> stop the pgd support strikes again.  It used to be named rnk.
> >
> > You mean I should change the function pointer name to rnk to keep
> > consistency? I find rnk in IA64 implementation.
> 
> You were changing something that used to be a pointer back to a pointer
> and I found that confusing.    See the last one or two commits to
> machine_kexec_32.c for when this happened.

After checking the history of machine_kexec_32.c, I find the pointer is
removed because a specific PGD is used. My reason is a little different.
I need save some information (the preserving registers, some control
registers, swap page address etc) in control_page, it is more convenient
to execute on identity map of control_page. I think it is not a big
issue. In fact, my code can work without making relocate_kernel to
pointer with some changes.

> I get the feeling that we
> need to put the page table creation logic into machine_kexec_prepare,
> instead of in assembly.

Yes. I think this is a good idea, and the kexec_pgd, kexec_pmd0/1,
kexec_pte0/1 can be allocated in machine_kexec_prepare too to save the
static memory usage.

Best Regards,
Huang Ying
