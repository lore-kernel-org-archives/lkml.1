Return-Path: <linux-kernel-owner+w=401wt.eu-S1752770AbXLaT1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbXLaT1U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 14:27:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751454AbXLaT1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 14:27:11 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56277 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393AbXLaT1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 14:27:10 -0500
Date: Mon, 31 Dec 2007 14:26:21 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3 -mm] kexec jump -v8
Message-ID: <20071231192621.GD27060@redhat.com>
References: <1198222399.1965.15.camel@caritas-dev.intel.com> <20071228213331.GB4560@redhat.com> <1198893644.17317.36.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1198893644.17317.36.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 29, 2007 at 10:00:44AM +0800, Huang, Ying wrote:
> On Fri, 2007-12-28 at 16:33 -0500, Vivek Goyal wrote:
> > On Fri, Dec 21, 2007 at 03:33:19PM +0800, Huang, Ying wrote:
> > > This patchset provides an enhancement to kexec/kdump. It implements
> > > the following features:
> > > 
> > > - Backup/restore memory used both by the original kernel and the
> > >   kexeced kernel.
> > > 
> > > - Jumping between the original kernel and the kexeced kernel.
> > > 
> > > - Read/write memory image of the kexeced kernel in the original kernel
> > >   and write memory image of the original kernel in the kexeced
> > >   kernel. This can be used as a communication method between the
> > >   kexeced kernel and the original kernel.
> > > 
> > > 
> > > The features of this patchset can be used as follow:
> > > 
> > > - Kernel/system debug through making system snapshot. You can make
> > >   system snapshot, jump back, do some thing and make another system
> > >   snapshot.
> > > 
> > 
> > How do you differentiate between whether a core is resumable or not.
> > IOW, how do you know the generated /proc/vmcore has been generated after
> > a real crash hence can't be resumed (using krestore) or it has been 
> > generated because of hibernation/debug purposes and can be resumed?
> > 
> > I think you might have to add an extra ELF NOTE to vmcore which can help
> > decide whether kernel memory snapshot is resumable or not.
> 
> The current solution is as follow:
> 
> 1. The original kernel will set %edi to jump back entry if resumable and
> set %edi to 0 if not.
> 
> 2. The purgatory of loaded kernel will check %edi, if it is not zero,
> the string "jump_back_entry=<jump_back_entry>" will be appended to
> kernel command line parameter.
> 
> 3. In kexeced kernel, if there is "jump_back_entry=<jump_back_entry>"
> in /proc/cmdline, the previous kernel is resumable, otherwise not.
> 

Ok. But If I copy the /proc/vmcore to disk. Then I reboot the system 
and boot back into a kernel which is supposed to resume the hibernated
image. This kernel will not have any command line option jump_back_entry.
I  need to resume using krestore tool. How will a krestore tool decide that
image one wants to restore is a core file or a hibernated image?

In this context I thought an PT_NOTE might be useful.

> As for ELF NOTE, in fact, the ELF NOTE does not work for resumable
> kernel. Because the contents of source page and destination page is
> swapped during kexec, and the kernel access the destination page
> directly during parsing ELF NOTE. All memory that is swapped need to be
> accessed via the backup pages map (image->head). I think these
> information can be exchanged between two kernels via kernel command line
> or /proc/kimgcore.
> 

Why should we exchange backup page map information between two kernels?
What data has been swapped and how to restore it back should be known
to the kernel who did it. I think the memory info and address of ELF
headers we can still pass to second kernel the same way we do for
/proc/vmcore. The only difference is that purgatory shall have to modify 
the command line to reflect the new address of ELF headers just before
jumping to new kernel (because of swapping).

We can also modify the actual ELF headers in purgatory to reflect the
right data (because of swapping) and new kernel will not have to know
anything about swapping.

So I thought of following sequence.

Lets say there is production kernel A and there is helper kernel B (B
will save the hibernated image of A).

- Boot into A.
- Load kernel B using --load-preserve-context.
- This load operation can also create the Elf headers.   
- Kexec -e will start hibernation of A. Pages shall be swapped. Control
  will be transferred to purgatory.
- Purgatory will readjust the ELF headers and command line based on 
  the swapping done and jump to new kernel.
- New kernel will retrieve the elf headers and export the memory of
  hibernated kernel through /proc/vmcore.

Hence there is no need to communicate swapped pages map between two
kernels.


> > [..]
> > > 2. Build an initramfs image contains kexec-tool, or download the
> > >    pre-built initramfs image, called rootfs.gz in following text.
> > > 
> > > 3. Boot kernel compiled in step 1.
> > > 
> > > 4. Load kernel compiled in step 1 with /sbin/kexec. If You want to use
> > >    "krestore" tool, the --elf64-core-headers should be specified in
> > >    command line of /sbin/kexec. The shell command line can be as
> > >    follow:
> > > 
> > >    /sbin/kexec --load-jump-back /boot/bzImage --mem-min=0x100000
> > >      --mem-max=0xffffff --elf64-core-headers --initrd=rootfs.gz
> > > 
> > 
> > How about a different name like "--load-preserve-context". This will
> > just mean that kexec need to preserve the context while kexeing to 
> > image being loaded. Combination of --load-jump-back and
> > --load-jump-back-helper is becoming little confusing.
> 
> Yes, this is better. I will change it.
> 
> > > 5. Boot the kexeced kernel with following shell command line:
> > > 
> > >    /sbin/kexec -e
> > > 
> > > 6. The kexeced kernel will boot as normal kexec. In kexeced kernel the
> > >    memory image of original kernel can read via /proc/vmcore or
> > >    /dev/oldmem, and can be written via /dev/oldmem. You can
> > >    save/restore/modify it as you want to.
> > > 
> > 
> > Restoring a hibernated image using /dev/oldmem should be easy and I 
> > think one should be able to launch it back using --load-jump-back-helper.
> 
> Yes. I think so too. The current implementation of krestore restoring
> the hibernated image using /dev/oldmem. And the hibernated image can be
> launched using --load-jump-back-helper.
> 
> > How do you restore already kexeced kernel? For example if I got two
> > kernels A and B. A is the one which will hibernate and B will be used
> > to store the hibernated kernel. I think as per the procedure one needs
> > to first boot into kernel B and then jump back to kernel A. This will
> > make image of B available in /proc/kimgcore. If I save /proc/kimgcore
> > to disk and want to jump back to it, how do I do it? I guess I need
> > to kexec again using --load-jump-back and not restore using krestore?
> 
> The image of B is made as you said. And it can be restored as follow:
> 
> /sbin/kexec -l --args-none --flags=0x2 <kimgecore>
> /sbin/kexec -e
> 
> That is, the image of B is loaded as a ordinary ELF file. A option
> to /sbin/kexec named --flags are added to specify the
> KEXEC_PRESERVE_CONTEXT flags for sys_kexec_load. This has been tested.

Shouldn't we be able to load this image using --load-preseve-context? Why
to create another otion --flags.

So there seems to be two different kind of load options for resuming
for two different kind of images.

- For /proc/vmcore kind of images use krestore (which will use
  --load-jump-back-helper)

- For /proc/kimgcore kind of images use normal kexec -l.

This is little confusing. How will one differentiate between two kind
of files? In fact the semantics between two kind of files are not very
clear. We need to do some kind of unification here and make the whole
thing somewhat simple.


> 
> > > 7. Prepare jumping back from kexeced kernel with following shell
> > >    command lines:
> > > 
> > >    jump_back_entry=`cat /proc/cmdline | tr ' ' '\n' | grep kexec_jump_back_entry | cut -d '='`
> > >    /sbin/kexec --load-jump-back-helper=$jump_back_entry
> > > 
> > 
> > How about decoupling entry point from --load-jump-back-helper. We can
> > introduce a separate option for entry point. Something like.
> > 
> > kexec --load-jump-back-helper --entry=$jump_back_entry
> > 
> > May be we can generalize the --entry so that a user can override the 
> > entry point of the normal kexec image using above.
> 
> Yes. This is better. I will change it.
> 
> > > 8. Jump back to the original kernel with following shell command line:
> > > 
> > >    /sbin/kexec -e
> > > 
> > > 9. Now, you are in the original kernel again. You can read/write the
> > >    memory image of kexeced kernel via /proc/kimgcore.
> > > 
> > > 10. You can jump between the original kernel and kexeced kernel as you
> > >     want to via the following shell command line:
> > > 
> > >     /sbin/kexec -e
> > > 
> > > 
> > > Known issues:
> > > 
> > > - The suspend/resume callback of device drivers are used to put
> > >   devices into quiescent state. This will unnecessarily (possibly
> > >   harmfully) put devices into low power state. This is intended to be
> > >   solved by separating device quiesce/unquiesce callback from the
> > >   device suspend/resume callback.
> > > 
> > > 
> > > ChangeLog:
> > > 
> > > v8:
> > > 
> > > - Split kexec jump patchset from kexec based hibernation patchset.
> > > 
> > > - Add writing support to kimgcore. This can be used as a communication
> > >   method between kexeced kernel and original kernel.
> > > 
> > 
> > What are we communicating between two kernels using kimgcore?
> 
> An example:
> 
> 1. kernel A kexec kernel B, provides vmcoreinfo in kernel command line.

I think vmcoreinfo is stored in a PT_NOTE and passed to second kernel
parses it while parsing all ELF headers? No separate ptr or anything
else is passed to second kernel on command line.

> 2. kernel B jump back to kernel A
> 3. in kernel A, the memory image of kernel B is saved via /proc/kimgcore
> 4. system reboot, kernel C is booted
> 5. kernel C load the memory image of kernel B, and jump back to kernel B
> 
> In step 5, the vmcoreinfo provided in step 1 is invalid, so a
> communication method is needed to tell kernel B the new one. This can be
> done via amending /proc/kimgcore. For example, change the memory of the
> kernel command line of kernel B.

I think modifying a kernel's data structures externally without kernel
knowing it is dangerous. 

I would think that initially we can keep it simple and not suppot
resuming. Resuming is little tough as you need to make sure kernel's
complete env has been restored back. But in this case, we are playing
with resume env, for example, changing of vmcoreinfo etc.

Capability to resume the already booted kernel (Kernel B here), creates
a coupling with the kernel it has booted with in the past (Kernel A) and
that's why you end up modifying various things once you swith to B 
from C. I think we should boot B fresh all the time to save the hibernated
image of kernel A or C (Though it will take more time for hibernation).
It keeps things simple.

If you still want to support resuming the kernel, then I would think that in
resume path kernel should re-initialize/re-construct /proc/vmcore
(parse vmcoreinfo again) etc, instead of modifying the image of loaded kernel
through /proc/kimgcore interface.

We can probably think of a setup page where all the needed data is put and
this page is used as a communication medium between two kernels (Something
like the way, a page of data is passed between boot-loader and kernel to
communicate the info like command line etc).

So in the above example, kernel C will pass some data to kernel B (on
setup page). This data will also include the pointer to new ELF headers
(which also includes vmcoreinfo PT_NOTE). Resume path of kernel B
will parse this data and re-initialize vmcore accordingly.

Thanks
Vivek
