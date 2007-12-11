Return-Path: <linux-kernel-owner+w=401wt.eu-S1753314AbXLKHuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314AbXLKHuu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 02:50:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751984AbXLKHun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 02:50:43 -0500
Received: from mga01.intel.com ([192.55.52.88]:29428 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751915AbXLKHum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 02:50:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,150,1196668800"; 
   d="scan'208";a="431695429"
Subject: Re: [PATCH 1/4 -mm] kexec based hibernation -v7 : kexec jump
From: "Huang, Ying" <ying.huang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Machek <pavel@ucw.cz>, nigel@nigel.suspend2.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
In-Reply-To: <m1tzmq0xy0.fsf@ebiederm.dsl.xmission.com>
References: <1197042810.24045.61.camel@caritas-dev.intel.com>
	 <m1tzmq0xy0.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 11 Dec 2007 15:50:19 +0000
Message-Id: <1197388219.11506.32.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 11 Dec 2007 07:50:38.0163 (UTC) FILETIME=[850BBA30:01C83BCA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-12-10 at 19:25 -0700, Eric W. Biederman wrote:
> "Huang, Ying" <ying.huang@intel.com> writes:
[...]
> >  /*
> >   * Do not allocate memory (or fail in any way) in machine_kexec().
> >   * We are past the point of no return, committed to rebooting now.
> >   */
> > -NORET_TYPE void machine_kexec(struct kimage *image)
> > +int machine_kexec_vcall(struct kimage *image, unsigned long *ret,
> > +			 unsigned int argc, va_list args)
> >  {
> 
> Why do we need var arg support?
> Can't we do that with a shim we load from user space?

If all parameters are provided in user space, the usage model may be as
follow:

- sys_kexec_load() /* with executable/data/parameters(A) loaded */
- sys_reboot(,,LINUX_REBOOT_CMD_KEXEC,) /* execute physical mode code with parameters(A)*/
- /* jump back */
- sys_kexec_load() /* with executable/data/parameters(B) loaded */
- sys_reboot(,,LINUX_REBOOT_CMD_KEXEC,) /* execute physical mode code with parameters(B)*/
- /* jump back */

That is, the kexec image should be re-loaded if the parameters are
different, and there can be no state reserved in kexec image. This is OK
for original kexec implementation, because there is no jumping back.
But, for kexec with jumping back, another usage model may be useful too.

- sys_kexec_load() /* with executable/data loaded */
- sys_reboot(,,LINUX_REBOOT_CMD_KEXEC,parameters(A)) /* execute physical mode code with parameters(A)*/
- sys_reboot(,,LINUX_REBOOT_CMD_KEXEC,parameters(B)) /* execute physical mode code with parameters(B)*/

This way the kexec image need not to be re-loaded, and the state of
kexec image can be reserved across several invoking.


Another usage model may be useful is invoking the kexec image (such as
firmware) from kernel space.

- kmalloc the needed memory and loaded the firmware image (if needed)
- sys_kexec_load() with a fake image (one segment with size 0), the
entry point of the fake image is the entry point of the firmware image.
- kexec_call(fake_image, ...) /* maybe change entry point if needed */

This way, some kernel code can invoke the firmware in physical mode just
like invoking an ordinary function.

[...]
> > -	/* The segment registers are funny things, they have both a
> > -	 * visible and an invisible part.  Whenever the visible part is
> > -	 * set to a specific selector, the invisible part is loaded
> > -	 * with from a table in memory.  At no other time is the
> > -	 * descriptor table in memory accessed.
> > -	 *
> > -	 * I take advantage of this here by force loading the
> > -	 * segments, before I zap the gdt with an invalid value.
> > -	 */
> > -	load_segments();
> > -	/* The gdt & idt are now invalid.
> > -	 * If you want to load them you must set up your own idt & gdt.
> > -	 */
> > -	set_gdt(phys_to_virt(0),0);
> > -	set_idt(phys_to_virt(0),0);
> > +	if (image->preserve_cpu_ext) {
> > +		/* The segment registers are funny things, they have
> > +		 * both a visible and an invisible part.  Whenever the
> > +		 * visible part is set to a specific selector, the
> > +		 * invisible part is loaded with from a table in
> > +		 * memory.  At no other time is the descriptor table
> > +		 * in memory accessed.
> > +		 *
> > +		 * I take advantage of this here by force loading the
> > +		 * segments, before I zap the gdt with an invalid
> > +		 * value.
> > +		 */
> > +		load_segments();
> > +		/* The gdt & idt are now invalid.  If you want to load
> > +		 * them you must set up your own idt & gdt.
> > +		 */
> > +		set_gdt(phys_to_virt(0), 0);
> > +		set_idt(phys_to_virt(0), 0);
> > +	}
> 
> We can't keep the same idt and gdt as the pages they are on will be
> overwritten/reused.  So explictily stomping on them sounds better
> so they never work.  We can restore them on kernel reentry.

The original idea about this code is:

If the kexec image is claimed that it need not to "perserving extensive
CPU state" (such as FPU/MMX/GDT/LDT/IDT/CS/DS/ES/FS/GS/SS etc), the
IDT/GDT/CS/DS/ES/FS/GS/SS are not touched in kexec image code. So the
segment registers need not to be set.

But this is not clear. At least more description should be provided for
each preserve flag.

> >  	/* now call it */
> > -	relocate_kernel((unsigned long)image->head, (unsigned long)page_list,
> > -			image->start, cpu_has_pae);
> > +	relocate_kernel_ptr((unsigned long)image->head,
> > +			    (unsigned long)page_list,
> > +			    image->start, cpu_has_pae);
> 
> Why rename relocate_kernel?
> Ah.  I see.  You need to make it into a pointer again.  The crazy don't
> stop the pgd support strikes again.  It used to be named rnk.

You mean I should change the function pointer name to rnk to keep
consistency? I find rnk in IA64 implementation.

Best Regards,
Huang Ying
