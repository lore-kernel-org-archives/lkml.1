Return-Path: <linux-kernel-owner+w=401wt.eu-S1753458AbXLKAw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458AbXLKAw1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 19:52:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496AbXLKAwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 19:52:19 -0500
Received: from mga02.intel.com ([134.134.136.20]:65281 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343AbXLKAwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 19:52:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,149,1196668800"; 
   d="scan'208";a="292883615"
Subject: Re: [PATCH 1/4 -mm] kexec based hibernation -v7 : kexec jump
From: "Huang, Ying" <ying.huang@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071210195553.GB27124@redhat.com>
References: <1197042810.24045.61.camel@caritas-dev.intel.com>
	 <20071210195553.GB27124@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 11 Dec 2007 08:51:36 +0000
Message-Id: <1197363096.24045.92.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 11 Dec 2007 00:51:55.0574 (UTC) FILETIME=[06D0DD60:01C83B90]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-12-10 at 14:55 -0500, Vivek Goyal wrote:
> On Fri, Dec 07, 2007 at 03:53:30PM +0000, Huang, Ying wrote:
> > This patch implements the functionality of jumping between the kexeced
> > kernel and the original kernel.
> > 
> 
> Hi,
> 
> I am just going through your patches and trying to understand it. Don't
> understand many things. Asking is easy so here you go...
> 
> > To support jumping between two kernels, before jumping to (executing)
> > the new kernel and jumping back to the original kernel, the devices
> > are put into quiescent state, and the state of devices and CPU is
> > saved. After jumping back from kexeced kernel and jumping to the new
> > kernel, the state of devices and CPU are restored accordingly. The
> > devices/CPU state save/restore code of software suspend is called to
> > implement corresponding function.
> > 
> 
> I need jumping back to restore a already hibernated kernel image? Can
> you please tell little more about jumping back and why it is needed?

Now, the jumping back is used to implement "kexec based hibernation",
which uses kexec/kdump to save the memory image of hibernated kernel
during hibernating, and uses /dev/oldmem to restore the memory image of
hibernated kernel and jump back to the hibernated kernel to continue
run.

The other usage model maybe include:

- Dump the system memory image then continue to run, that is, get some
memory snapshot of system during system running.
- Cooperative multi-task of different OS. You can load another OS (B)
from current OS (A), and jump between the two OSes upon needed.
- Call some code (such as firmware, etc) in physical mode. 

> > To support jumping without reserving memory. One shadow backup page
> > (source page) is allocated for each page used by new (kexeced) kernel
> > (destination page). When do kexec_load, the image of new kernel is
> > loaded into source pages, and before executing, the destination pages
> > and the source pages are swapped, so the contents of destination pages
> > are backupped. Before jumping to the new (kexeced) kernel and after
> > jumping back to the original kernel, the destination pages and the
> > source pages are swapped too.
> > 
> 
> Ok, so due to swapping of source and destination pages first kernel's data
> is still preserved.  How do I get the dynamic memory required for second
> kernel boot (without writing first kernel's data)?

All dynamic memory required for second kernel should be "loaded" by
sys_kexec_load in first kernel. For example, not only the Linux kernel
should be loaded at 1M, the memory 0~16M (exclude kernel) should be
"loaded" (all zero) by /sbin/kexec via sys_kexec_load too.

> > A jump back protocol for kexec is defined and documented. It is an
> > extension to ordinary function calling protocol. So, the facility
> > provided by this patch can be used to call ordinary C function in real
> > mode.
> > 
> > A set of flags for sys_kexec_load are added to control which state are
> > saved/restored before/after real mode code executing. For example, you
> > can specify the device state and FPU state are saved/restored
> > before/after real mode code executing.
> > 
> > The states (exclude CPU state) save/restore code can be overridden
> > based on the "command" parameter of kexec jump. Because more states
> > need to be saved/restored by hibernating/resuming.
> > 
> > Signed-off-by: Huang Ying <ying.huang@intel.com>
> > 
> > ---
> >  Documentation/i386/jump_back_protocol.txt |  103 ++++++++++++++
> >  arch/powerpc/kernel/machine_kexec.c       |    2 
> >  arch/ppc/kernel/machine_kexec.c           |    2 
> >  arch/sh/kernel/machine_kexec.c            |    2 
> >  arch/x86/kernel/machine_kexec_32.c        |   88 +++++++++---
> >  arch/x86/kernel/machine_kexec_64.c        |    2 
> >  arch/x86/kernel/relocate_kernel_32.S      |  214 +++++++++++++++++++++++++++---
> >  include/asm-x86/kexec_32.h                |   39 ++++-
> >  include/linux/kexec.h                     |   40 +++++
> >  kernel/kexec.c                            |  188 ++++++++++++++++++++++++++
> >  kernel/power/Kconfig                      |    2 
> >  kernel/sys.c                              |   35 +++-
> >  12 files changed, 648 insertions(+), 69 deletions(-)
> > 
> > --- a/arch/x86/kernel/machine_kexec_32.c
> > +++ b/arch/x86/kernel/machine_kexec_32.c
> > @@ -20,6 +20,7 @@
> >  #include <asm/cpufeature.h>
> >  #include <asm/desc.h>
> >  #include <asm/system.h>
> > +#include <asm/cacheflush.h>
> >  
> >  #define PAGE_ALIGNED __attribute__ ((__aligned__(PAGE_SIZE)))
> >  static u32 kexec_pgd[1024] PAGE_ALIGNED;
> > @@ -83,10 +84,14 @@ static void load_segments(void)
> >   * reboot code buffer to allow us to avoid allocations
> >   * later.
> >   *
> > - * Currently nothing.
> > + * Turn off NX bit for control page.
> >   */
> >  int machine_kexec_prepare(struct kimage *image)
> >  {
> > +	if (nx_enabled) {
> > +		change_page_attr(image->control_code_page, 1, PAGE_KERNEL_EXEC);
> > +		global_flush_tlb();
> > +	}
> >  	return 0;
> >  }
> >  
> > @@ -96,25 +101,59 @@ int machine_kexec_prepare(struct kimage 
> >   */
> >  void machine_kexec_cleanup(struct kimage *image)
> >  {
> > +	if (nx_enabled) {
> > +		change_page_attr(image->control_code_page, 1, PAGE_KERNEL);
> > +		global_flush_tlb();
> > +	}
> > +}
> > +
> > +void machine_kexec(struct kimage *image)
> > +{
> > +	machine_kexec_call(image, NULL, 0);
> >  }
> >  
> >  /*
> >   * Do not allocate memory (or fail in any way) in machine_kexec().
> >   * We are past the point of no return, committed to rebooting now.
> >   */
> > -NORET_TYPE void machine_kexec(struct kimage *image)
> > +int machine_kexec_vcall(struct kimage *image, unsigned long *ret,
> > +			 unsigned int argc, va_list args)
> >  {
> >  	unsigned long page_list[PAGES_NR];
> >  	void *control_page;
> > +	asmlinkage NORET_TYPE void
> > +		(*relocate_kernel_ptr)(unsigned long indirection_page,
> > +				       unsigned long control_page,
> > +				       unsigned long start_address,
> > +				       unsigned int has_pae) ATTRIB_NORET;
> >  
> >  	/* Interrupts aren't acceptable while we reboot */
> >  	local_irq_disable();
> >  
> >  	control_page = page_address(image->control_code_page);
> > -	memcpy(control_page, relocate_kernel, PAGE_SIZE);
> > +	memcpy(control_page, relocate_page, PAGE_SIZE/2);
> > +	KCALL_MAGIC(control_page) = 0;
> >  
> 
> Is 2K sufficient for all the code in relocate_kernel_32.S? What's the
> current size?

The current size is 0x2d7 (727). I got it though objdump,
machine_crash_shutdown - relocate_page. I think we have enough space.

> > +	if (image->preserve_cpu) {
> > +		unsigned int i;
> > +		KCALL_MAGIC(control_page) = KCALL_MAGIC_NUMBER;
> > +		KCALL_ARGC(control_page) = argc;
> > +		for (i = 0; i < argc; i++)
> > +			KCALL_ARGS(control_page)[i] = \
> > +				va_arg(args, unsigned long);
> > +
> > +		if (kexec_call_save_cpu(control_page)) {
> > +			image->start = KCALL_ENTRY(control_page);
> 
> Who fills the entry point at offset 0x200?

The entry point is filled by assembler code in reloate_kernel_32.S upon
jumping back. You can find it by "grep ENTRY relocate_kernel_32.S".

> 
> [..]
> >  extern int machine_kexec_prepare(struct kimage *image);
> >  extern void machine_kexec_cleanup(struct kimage *image);
> >  extern asmlinkage long sys_kexec_load(unsigned long entry,
> >  					unsigned long nr_segments,
> >  					struct kexec_segment __user *segments,
> >  					unsigned long flags);
> > +extern int kexec_call(struct kimage *image, unsigned long *ret,
> > +		      unsigned int argc, ...);
> 
> Who is using kexec_call(). I can't seem to locate the caller of it.

There is no user of kexec_call() now. But I think it may be useful as a
physical mode caller for some firmware code.

Best Regards,
Huang Ying
