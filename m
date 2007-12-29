Return-Path: <linux-kernel-owner+w=401wt.eu-S1755814AbXL2CAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814AbXL2CAi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 21:00:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753445AbXL2CAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 21:00:31 -0500
Received: from mga01.intel.com ([192.55.52.88]:40652 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753332AbXL2CA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 21:00:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,218,1196668800"; 
   d="scan'208";a="468513964"
Subject: Re: [PATCH 0/3 -mm] kexec jump -v8
From: "Huang, Ying" <ying.huang@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071228213331.GB4560@redhat.com>
References: <1198222399.1965.15.camel@caritas-dev.intel.com>
	 <20071228213331.GB4560@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sat, 29 Dec 2007 10:00:44 +0800
Message-Id: <1198893644.17317.36.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 29 Dec 2007 02:00:22.0144 (UTC) FILETIME=[91F53800:01C849BE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-12-28 at 16:33 -0500, Vivek Goyal wrote:
> On Fri, Dec 21, 2007 at 03:33:19PM +0800, Huang, Ying wrote:
> > This patchset provides an enhancement to kexec/kdump. It implements
> > the following features:
> > 
> > - Backup/restore memory used both by the original kernel and the
> >   kexeced kernel.
> > 
> > - Jumping between the original kernel and the kexeced kernel.
> > 
> > - Read/write memory image of the kexeced kernel in the original kernel
> >   and write memory image of the original kernel in the kexeced
> >   kernel. This can be used as a communication method between the
> >   kexeced kernel and the original kernel.
> > 
> > 
> > The features of this patchset can be used as follow:
> > 
> > - Kernel/system debug through making system snapshot. You can make
> >   system snapshot, jump back, do some thing and make another system
> >   snapshot.
> > 
> 
> How do you differentiate between whether a core is resumable or not.
> IOW, how do you know the generated /proc/vmcore has been generated after
> a real crash hence can't be resumed (using krestore) or it has been 
> generated because of hibernation/debug purposes and can be resumed?
> 
> I think you might have to add an extra ELF NOTE to vmcore which can help
> decide whether kernel memory snapshot is resumable or not.

The current solution is as follow:

1. The original kernel will set %edi to jump back entry if resumable and
set %edi to 0 if not.

2. The purgatory of loaded kernel will check %edi, if it is not zero,
the string "jump_back_entry=<jump_back_entry>" will be appended to
kernel command line parameter.

3. In kexeced kernel, if there is "jump_back_entry=<jump_back_entry>"
in /proc/cmdline, the previous kernel is resumable, otherwise not.

As for ELF NOTE, in fact, the ELF NOTE does not work for resumable
kernel. Because the contents of source page and destination page is
swapped during kexec, and the kernel access the destination page
directly during parsing ELF NOTE. All memory that is swapped need to be
accessed via the backup pages map (image->head). I think these
information can be exchanged between two kernels via kernel command line
or /proc/kimgcore.

> [..]
> > 2. Build an initramfs image contains kexec-tool, or download the
> >    pre-built initramfs image, called rootfs.gz in following text.
> > 
> > 3. Boot kernel compiled in step 1.
> > 
> > 4. Load kernel compiled in step 1 with /sbin/kexec. If You want to use
> >    "krestore" tool, the --elf64-core-headers should be specified in
> >    command line of /sbin/kexec. The shell command line can be as
> >    follow:
> > 
> >    /sbin/kexec --load-jump-back /boot/bzImage --mem-min=0x100000
> >      --mem-max=0xffffff --elf64-core-headers --initrd=rootfs.gz
> > 
> 
> How about a different name like "--load-preserve-context". This will
> just mean that kexec need to preserve the context while kexeing to 
> image being loaded. Combination of --load-jump-back and
> --load-jump-back-helper is becoming little confusing.

Yes, this is better. I will change it.

> > 5. Boot the kexeced kernel with following shell command line:
> > 
> >    /sbin/kexec -e
> > 
> > 6. The kexeced kernel will boot as normal kexec. In kexeced kernel the
> >    memory image of original kernel can read via /proc/vmcore or
> >    /dev/oldmem, and can be written via /dev/oldmem. You can
> >    save/restore/modify it as you want to.
> > 
> 
> Restoring a hibernated image using /dev/oldmem should be easy and I 
> think one should be able to launch it back using --load-jump-back-helper.

Yes. I think so too. The current implementation of krestore restoring
the hibernated image using /dev/oldmem. And the hibernated image can be
launched using --load-jump-back-helper.

> How do you restore already kexeced kernel? For example if I got two
> kernels A and B. A is the one which will hibernate and B will be used
> to store the hibernated kernel. I think as per the procedure one needs
> to first boot into kernel B and then jump back to kernel A. This will
> make image of B available in /proc/kimgcore. If I save /proc/kimgcore
> to disk and want to jump back to it, how do I do it? I guess I need
> to kexec again using --load-jump-back and not restore using krestore?

The image of B is made as you said. And it can be restored as follow:

/sbin/kexec -l --args-none --flags=0x2 <kimgecore>
/sbin/kexec -e

That is, the image of B is loaded as a ordinary ELF file. A option
to /sbin/kexec named --flags are added to specify the
KEXEC_PRESERVE_CONTEXT flags for sys_kexec_load. This has been tested.

> > 7. Prepare jumping back from kexeced kernel with following shell
> >    command lines:
> > 
> >    jump_back_entry=`cat /proc/cmdline | tr ' ' '\n' | grep kexec_jump_back_entry | cut -d '='`
> >    /sbin/kexec --load-jump-back-helper=$jump_back_entry
> > 
> 
> How about decoupling entry point from --load-jump-back-helper. We can
> introduce a separate option for entry point. Something like.
> 
> kexec --load-jump-back-helper --entry=$jump_back_entry
> 
> May be we can generalize the --entry so that a user can override the 
> entry point of the normal kexec image using above.

Yes. This is better. I will change it.

> > 8. Jump back to the original kernel with following shell command line:
> > 
> >    /sbin/kexec -e
> > 
> > 9. Now, you are in the original kernel again. You can read/write the
> >    memory image of kexeced kernel via /proc/kimgcore.
> > 
> > 10. You can jump between the original kernel and kexeced kernel as you
> >     want to via the following shell command line:
> > 
> >     /sbin/kexec -e
> > 
> > 
> > Known issues:
> > 
> > - The suspend/resume callback of device drivers are used to put
> >   devices into quiescent state. This will unnecessarily (possibly
> >   harmfully) put devices into low power state. This is intended to be
> >   solved by separating device quiesce/unquiesce callback from the
> >   device suspend/resume callback.
> > 
> > 
> > ChangeLog:
> > 
> > v8:
> > 
> > - Split kexec jump patchset from kexec based hibernation patchset.
> > 
> > - Add writing support to kimgcore. This can be used as a communication
> >   method between kexeced kernel and original kernel.
> > 
> 
> What are we communicating between two kernels using kimgcore?

An example:

1. kernel A kexec kernel B, provides vmcoreinfo in kernel command line.
2. kernel B jump back to kernel A
3. in kernel A, the memory image of kernel B is saved via /proc/kimgcore
4. system reboot, kernel C is booted
5. kernel C load the memory image of kernel B, and jump back to kernel B

In step 5, the vmcoreinfo provided in step 1 is invalid, so a
communication method is needed to tell kernel B the new one. This can be
done via amending /proc/kimgcore. For example, change the memory of the
kernel command line of kernel B.

Best Regards,
Huang Ying

