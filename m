Return-Path: <linux-kernel-owner+w=401wt.eu-S1752102AbXLKJaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102AbXLKJaI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 04:30:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751186AbXLKJ34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 04:29:56 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:54375 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbXLKJ3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 04:29:54 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Huang, Ying" <ying.huang@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>, nigel@nigel.suspend2.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH 1/4 -mm] kexec based hibernation -v7 : kexec jump
References: <1197042810.24045.61.camel@caritas-dev.intel.com>
	<m1tzmq0xy0.fsf@ebiederm.dsl.xmission.com>
	<1197388219.11506.32.camel@caritas-dev.intel.com>
Date: Tue, 11 Dec 2007 02:27:44 -0700
In-Reply-To: <1197388219.11506.32.camel@caritas-dev.intel.com> (Ying Huang's
	message of "Tue, 11 Dec 2007 15:50:19 +0000")
Message-ID: <m163z51sz3.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Huang, Ying" <ying.huang@intel.com> writes:

> On Mon, 2007-12-10 at 19:25 -0700, Eric W. Biederman wrote:
>> "Huang, Ying" <ying.huang@intel.com> writes:
> [...]
>> >  /*
>> >   * Do not allocate memory (or fail in any way) in machine_kexec().
>> >   * We are past the point of no return, committed to rebooting now.
>> >   */
>> > -NORET_TYPE void machine_kexec(struct kimage *image)
>> > +int machine_kexec_vcall(struct kimage *image, unsigned long *ret,
>> > +			 unsigned int argc, va_list args)
>> >  {
>> 
>> Why do we need var arg support?
>> Can't we do that with a shim we load from user space?
>
> If all parameters are provided in user space, the usage model may be as
> follow:
>
> - sys_kexec_load() /* with executable/data/parameters(A) loaded */
> - sys_reboot(,,LINUX_REBOOT_CMD_KEXEC,) /* execute physical mode code with
> parameters(A)*/
> - /* jump back */
> - sys_kexec_load() /* with executable/data/parameters(B) loaded */
> - sys_reboot(,,LINUX_REBOOT_CMD_KEXEC,) /* execute physical mode code with
> parameters(B)*/
> - /* jump back */
>
> That is, the kexec image should be re-loaded if the parameters are
> different, and there can be no state reserved in kexec image. This is OK
> for original kexec implementation, because there is no jumping back.
> But, for kexec with jumping back, another usage model may be useful too.
>
> - sys_kexec_load() /* with executable/data loaded */
> - sys_reboot(,,LINUX_REBOOT_CMD_KEXEC,parameters(A)) /* execute physical mode
> code with parameters(A)*/
> - sys_reboot(,,LINUX_REBOOT_CMD_KEXEC,parameters(B)) /* execute physical mode
> code with parameters(B)*/
>
> This way the kexec image need not to be re-loaded, and the state of
> kexec image can be reserved across several invoking.

Interesting.  We wind up preserving the code in between invocations.

I don't know about your particular issue, but I can see that clearly
we need a way to read values back from our target image.

And if we can read everything back one way to proceed is to read
everything out modify it and then write it back.

Amending a kexec image that is already stored may also make sense.

I'm not convinced that the var arg parameters make sense, but you
added them because of a real need.

The kexec function is split into two separate calls so that we can
unmount the filesystem the kexec image comes from before actually
doing the kexec.

If extensive user space shutdown or startup is needed I will argue
that doing the work in the sys_reboot call is the wrong place to
do it.  Although if a jump back is happening we should not need
much restart.

Can you generate a minimal patch with just the minimal necessary
support to return from a kexec operation?

> Another usage model may be useful is invoking the kexec image (such as
> firmware) from kernel space.
>
> - kmalloc the needed memory and loaded the firmware image (if needed)
> - sys_kexec_load() with a fake image (one segment with size 0), the
> entry point of the fake image is the entry point of the firmware image.
> - kexec_call(fake_image, ...) /* maybe change entry point if needed */
>
> This way, some kernel code can invoke the firmware in physical mode just
> like invoking an ordinary function.

That certainly seems interesting.  But that doesn't justify the vararg
part of this.

> [...]
>> > -	/* The segment registers are funny things, they have both a
>> > -	 * visible and an invisible part.  Whenever the visible part is
>> > -	 * set to a specific selector, the invisible part is loaded
>> > -	 * with from a table in memory.  At no other time is the
>> > -	 * descriptor table in memory accessed.
>> > -	 *
>> > -	 * I take advantage of this here by force loading the
>> > -	 * segments, before I zap the gdt with an invalid value.
>> > -	 */
>> > -	load_segments();
>> > -	/* The gdt & idt are now invalid.
>> > -	 * If you want to load them you must set up your own idt & gdt.
>> > -	 */
>> > -	set_gdt(phys_to_virt(0),0);
>> > -	set_idt(phys_to_virt(0),0);
>> > +	if (image->preserve_cpu_ext) {
>> > +		/* The segment registers are funny things, they have
>> > +		 * both a visible and an invisible part.  Whenever the
>> > +		 * visible part is set to a specific selector, the
>> > +		 * invisible part is loaded with from a table in
>> > +		 * memory.  At no other time is the descriptor table
>> > +		 * in memory accessed.
>> > +		 *
>> > +		 * I take advantage of this here by force loading the
>> > +		 * segments, before I zap the gdt with an invalid
>> > +		 * value.
>> > +		 */
>> > +		load_segments();
>> > +		/* The gdt & idt are now invalid.  If you want to load
>> > +		 * them you must set up your own idt & gdt.
>> > +		 */
>> > +		set_gdt(phys_to_virt(0), 0);
>> > +		set_idt(phys_to_virt(0), 0);
>> > +	}
>> 
>> We can't keep the same idt and gdt as the pages they are on will be
>> overwritten/reused.  So explictily stomping on them sounds better
>> so they never work.  We can restore them on kernel reentry.
>
> The original idea about this code is:
>
> If the kexec image is claimed that it need not to "perserving extensive
> CPU state" (such as FPU/MMX/GDT/LDT/IDT/CS/DS/ES/FS/GS/SS etc), the
> IDT/GDT/CS/DS/ES/FS/GS/SS are not touched in kexec image code. So the
> segment registers need not to be set.
>
> But this is not clear. At least more description should be provided for
> each preserve flag.

yes.

>> >  	/* now call it */
>> > -	relocate_kernel((unsigned long)image->head, (unsigned long)page_list,
>> > -			image->start, cpu_has_pae);
>> > +	relocate_kernel_ptr((unsigned long)image->head,
>> > +			    (unsigned long)page_list,
>> > +			    image->start, cpu_has_pae);
>> 
>> Why rename relocate_kernel?
>> Ah.  I see.  You need to make it into a pointer again.  The crazy don't
>> stop the pgd support strikes again.  It used to be named rnk.
>
> You mean I should change the function pointer name to rnk to keep
> consistency? I find rnk in IA64 implementation.

You were changing something that used to be a pointer back to a pointer
and I found that confusing.    See the last one or two commits to
machine_kexec_32.c for when this happened.  I get the feeling that we
need to put the page table creation logic into machine_kexec_prepare,
instead of in assembly.

Eric
