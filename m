Return-Path: <linux-kernel-owner+w=401wt.eu-S1756909AbYACImI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909AbYACImI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 03:42:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754164AbYACIl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 03:41:56 -0500
Received: from mga03.intel.com ([143.182.124.21]:56063 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754063AbYACIly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 03:41:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,238,1196668800"; 
   d="scan'208";a="356470418"
Subject: Re: [PATCH 0/3 -mm] kexec jump -v8
From: "Huang, Ying" <ying.huang@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071231192621.GD27060@redhat.com>
References: <1198222399.1965.15.camel@caritas-dev.intel.com>
	 <20071228213331.GB4560@redhat.com>
	 <1198893644.17317.36.camel@caritas-dev.intel.com>
	 <20071231192621.GD27060@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 03 Jan 2008 16:42:26 +0800
Message-Id: <1199349746.6288.119.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 03 Jan 2008 08:41:50.0660 (UTC) FILETIME=[7BE5D040:01C84DE4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-12-31 at 14:26 -0500, Vivek Goyal wrote:
[...]
> Ok. But If I copy the /proc/vmcore to disk. Then I reboot the system 
> and boot back into a kernel which is supposed to resume the hibernated
> image. This kernel will not have any command line option jump_back_entry.
> I  need to resume using krestore tool. How will a krestore tool decide that
> image one wants to restore is a core file or a hibernated image?
> 
> In this context I thought an PT_NOTE might be useful.

In current implementation, when saving the memory image of hibernated
kernel in hibernating kernel, the jump back entry from kernel command
line should be saved at the same time, or the jump back entry from
kernel command line can be saved as entry point of ELF hibernated image
file by a modified makedumpfile. That is, 

- method 1:

jbe=`cat /proc/cmdline | tr -d ' ' '\n' | grep kexec_jump_back_entry | cut -d '=' -f 2`
cp /proc/vmcore .
echo $jbe > kexec_jump_back_entry

- method 2:

jbe=`cat /proc/cmdline | tr -d ' ' '\n' | grep kexec_jump_back_entry | cut -d '=' -f 2`
makedumpfile <other options> -j $jbe /proc/vmcore <image file>


Method 2 is better, because "jump back entry" is the very entry point of
the hibernated image. The vmcore implementation can be changed to set
entry point of /proc/vmcore if "kexec_jump_back_entry" kernel command
line option is present. I did not add this to kernel because it can be
done by user space tool "makedumpfile", and one of the guideline is to
keep kernel part as simple as possible.

With method 2, the ordinary "core file" and "hibernated image" can be
distinguished by the "entry point".


The "jump back entry" can be saved with PT_NOTE too. And more
information can be saved with PT_NOTE. I have ever defined another
mechanism to pass information between two kernels too. I will describe
it later in this mail.

> > As for ELF NOTE, in fact, the ELF NOTE does not work for resumable
> > kernel. Because the contents of source page and destination page is
> > swapped during kexec, and the kernel access the destination page
> > directly during parsing ELF NOTE. All memory that is swapped need to be
> > accessed via the backup pages map (image->head). I think these
> > information can be exchanged between two kernels via kernel command line
> > or /proc/kimgcore.
> > 
> 
> Why should we exchange backup page map information between two kernels?
> What data has been swapped and how to restore it back should be known
> to the kernel who did it. I think the memory info and address of ELF
> headers we can still pass to second kernel the same way we do for
> /proc/vmcore. The only difference is that purgatory shall have to modify 
> the command line to reflect the new address of ELF headers just before
> jumping to new kernel (because of swapping).
> 
> We can also modify the actual ELF headers in purgatory to reflect the
> right data (because of swapping) and new kernel will not have to know
> anything about swapping.
> 
> So I thought of following sequence.
> 
> Lets say there is production kernel A and there is helper kernel B (B
> will save the hibernated image of A).
> 
> - Boot into A.
> - Load kernel B using --load-preserve-context.
> - This load operation can also create the Elf headers.   
> - Kexec -e will start hibernation of A. Pages shall be swapped. Control
>   will be transferred to purgatory.
> - Purgatory will readjust the ELF headers and command line based on 
>   the swapping done and jump to new kernel.
> - New kernel will retrieve the elf headers and export the memory of
>   hibernated kernel through /proc/vmcore.
> 
> Hence there is no need to communicate swapped pages map between two
> kernels.

One original page will map to one backup page (the contents of original
page and backup page will be swapped). It is possible that the entries
number of map equals the number of backup pages.

If the helper kernel B uses 16M memory, there will be 4096 backup pages.
One PT_LOAD header is needed for each backup page to record the map
between the original page to the backup page. So, the memory needed for
PT_LOAD headers will be 32 * 4k = 128k.

If the size of PT_LOAD headers and the "readability" of headers
information of /proc/vmcore is not a big issue, I think this is a good
idea.

In addition to revising the ELF headers in purgatory, the /proc/kimgcore
interface can also be used to revise the ELF headers in kernel A. But
this needs to export backup pages map information to user space (another
sysfs/procfs file?).

[...]
> > The image of B is made as you said. And it can be restored as
> follow:
> > 
> > /sbin/kexec -l --args-none --flags=0x2 <kimgecore>
> > /sbin/kexec -e
> > 
> > That is, the image of B is loaded as a ordinary ELF file. A option
> > to /sbin/kexec named --flags are added to specify the
> > KEXEC_PRESERVE_CONTEXT flags for sys_kexec_load. This has been tested.
> 
> Shouldn't we be able to load this image using --load-preseve-context? Why
> to create another otion --flags.

Yes. This seems better. I will change it.

> So there seems to be two different kind of load options for resuming
> for two different kind of images.
> 
> - For /proc/vmcore kind of images use krestore (which will use
>   --load-jump-back-helper)
> 
> - For /proc/kimgcore kind of images use normal kexec -l.
> 
> This is little confusing. How will one differentiate between two kind
> of files? In fact the semantics between two kind of files are not very
> clear. We need to do some kind of unification here and make the whole
> thing somewhat simple.

I think there may be no difference between two kinds of files. Nothing
prevents hibernated image produced through /proc/vmcore loaded with
normal kexec -l. I have just tested it. This means we need not use
krestore to resume the hibernated kernel after enhancing /sbin/kexec
(because it uses too much anonymous memory). And, the resuming process
will be more smooth.

For completion (although may be not a big issue now):

Whether using "krestore" or normal "kexec -l" depends on the memory used
by current kernel (/proc/iomem) and memory in image file (PT_LOAD
headers). If all memory in image file is outside memory used by current
kernel, "krestore" should be used. If all memory in image file is inside
memory used by current kernel, normal "kexec -l" should be used. If
there is intersection set between memory in image file and memory of
current kernel, the image file can not be loaded.

> > 
> > An example:
> > 
> > 1. kernel A kexec kernel B, provides vmcoreinfo in kernel command line.
> 
> I think vmcoreinfo is stored in a PT_NOTE and passed to second kernel
> parses it while parsing all ELF headers? No separate ptr or anything
> else is passed to second kernel on command line.

In current implementation, the PT_NOTE does not work, so a kernel
command line can be used to pass the information. And it can be changed
for each resuming. easier than changing PT_NOTE.

> > 2. kernel B jump back to kernel A
> > 3. in kernel A, the memory image of kernel B is saved via /proc/kimgcore
> > 4. system reboot, kernel C is booted
> > 5. kernel C load the memory image of kernel B, and jump back to kernel B
> > 
> > In step 5, the vmcoreinfo provided in step 1 is invalid, so a
> > communication method is needed to tell kernel B the new one. This can be
> > done via amending /proc/kimgcore. For example, change the memory of the
> > kernel command line of kernel B.
> 
> I think modifying a kernel's data structures externally without kernel
> knowing it is dangerous. 

Yes. It is dangerous. This is not a good example. But, I think it is a
useful feature. For example, the "setup page" you proposed later can be
setup via amending /proc/kimgcore.

And, it is more useful for "invoking some code in physical mode". The
procedure is something as follow:

1. load some code executing in physical mode via kexec --load-preserve-context.
2. setup the parameters via amending /proc/kimgcore
3. execute the code in physical mode via kexec -e
4. get the result via reading /proc/kimgcore
5. setup another groups of parameters via amending /proc/kimgcore
...

> I would think that initially we can keep it simple and not suppot
> resuming. Resuming is little tough as you need to make sure kernel's
> complete env has been restored back. But in this case, we are playing
> with resume env, for example, changing of vmcoreinfo etc.
> 
> Capability to resume the already booted kernel (Kernel B here), creates
> a coupling with the kernel it has booted with in the past (Kernel A) and
> that's why you end up modifying various things once you swith to B 
> from C. I think we should boot B fresh all the time to save the hibernated
> image of kernel A or C (Though it will take more time for hibernation).
> It keeps things simple.
> 
> If you still want to support resuming the kernel, then I would think that in
> resume path kernel should re-initialize/re-construct /proc/vmcore
> (parse vmcoreinfo again) etc, instead of modifying the image of loaded kernel
> through /proc/kimgcore interface.
> 
> We can probably think of a setup page where all the needed data is put and
> this page is used as a communication medium between two kernels (Something
> like the way, a page of data is passed between boot-loader and kernel to
> communicate the info like command line etc).
> 
> So in the above example, kernel C will pass some data to kernel B (on
> setup page). This data will also include the pointer to new ELF headers
> (which also includes vmcoreinfo PT_NOTE). Resume path of kernel B
> will parse this data and re-initialize vmcore accordingly.

Yes. A communication mechanism is needed between two kernels. The "setup
page" and "PT_NOTE" earlier you proposed are two such mechanisms. It
seems that the "setup page" is more powerful. I have defined a mechanism
like "setup page" in my previous version. It is as follow:

1. The second half of "control page" is used as the "setup page". That
is, jump_back_entry + 0x800.
2. A magic number is provided in "setup page" to let krestore to
distinguish between "normal executable" and "hibernated iamge" by check
the magic number.
3. Other information such as vmcoreinfo can be added to "setup page".
4. Before one kernel jump to another kernel, the parameters are prepared
by current kernel.
5. One kernel can check the parameters of another kernel by
reading /proc/vmcore or /proc/kimgcore.
6. When memory image is saved in file. The parameters of hibernated
kernel can be check by reading memory location jump_back_entry + 0x800.

You can check the details of this mechanism in my previous patch with
title:

[PATCH 1/4 -mm] kexec based hibernation -v7 : kexec jump

The main issue of this mechanism is that: it is a kernel-to-kernel
communication mechanism, while Eric Biederman thinks we should use only
user-to-user communication mechanism. And he is not persuaded now.

Because kernel operations such as re-initialize/re-construct
the /proc/vmcore, etc are needed for kexec jump or resuming. I think a
"kernel-to-kernel" mechanism may be needed. But I don't know if Eric
Biederman will agree with this.

Best Regards,
Huang Ying

