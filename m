Return-Path: <linux-kernel-owner+w=401wt.eu-S1755235AbYCNIFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235AbYCNIFq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 04:05:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752001AbYCNIF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 04:05:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:35152 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672AbYCNIFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 04:05:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,500,1199692800"; 
   d="scan'208";a="306178272"
Subject: Re: [PATCH -mm] kexec jump -v9
From: "Huang, Ying" <ying.huang@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Machek <pavel@ucw.cz>, nigel@nigel.suspend2.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
In-Reply-To: <20080312193740.GE13549@redhat.com>
References: <1204773188.4707.109.camel@caritas-dev.intel.com>
	 <20080311211004.GA30164@redhat.com>
	 <1205286326.29069.16.camel@caritas-dev.intel.com>
	 <m1abl4znw6.fsf@ebiederm.dsl.xmission.com>
	 <20080312193740.GE13549@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 14 Mar 2008 16:03:28 +0800
Message-Id: <1205481808.867.0.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
X-OriginalArrivalTime: 14 Mar 2008 08:01:05.0475 (UTC) FILETIME=[8DC87130:01C885A9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-03-12 at 15:37 -0400, Vivek Goyal wrote:
> On Tue, Mar 11, 2008 at 08:17:45PM -0600, Eric W. Biederman wrote:
> > "Huang, Ying" <ying.huang@intel.com> writes:
> > 
> > > Yes. The entry point should be saved in dump.elf itself, this can be
> > > done via a user-space tool such as "makedumpfile". Because
> > > "makedumpfile" is also used to exclude free pages from disk image, it
> > > needs a communication method between two kernels (to get backup pages
> > > map or something like that from kernel A). We have talked about this
> > > before.
> > >
> > > - Your opinion is to communicate via the purgatory. (But I don't know
> > > how to communicate between kernel A and purgatory).
> > 
> > How about the return address on the stack?
> > 
> 
> I think he needs to pass on much more data than just return address. 
> 
> IIUC, he needs to pass backup pages map to new kernel, so that any
> user space tool can use backup pages map to reconstruct/rearrange the
> first kernel's memory core and tools like makedumpfile can do filtering
> before hibernated images is saved.
> 
> This brings me to a random thought. Can we break the process of loading
> a hibernation kernel in two steps.
> 
> - In first step just do the memory reservation for running second kernel.
>   (kexec -l <dummpy-file-for-reserving-memory>)
> 
> - This memory map of reserved pages is exported to user space.
> 
> - Use this memory map and regenerate the hibernation kernel initrd
>   (rootfs.gz) and put the memory map there. This memory map can be used
>   by makedumpfile in second kernel for filtering.
> 
> This way it will user space to user space communication of information 
> which gets fixed at kernel loading time.

Doing kexec load in two steps is a possible solution. Although this is a
little complex, we can wrap the two steps into one /sbin/kexec invoking.
That is, When do /sbin/kexec --load-preserve-context
<kernel-image>, /sbin/kexec first call sys_kexec_load() to load the
kernel image and reserving memory, then amend the memory image of loaded
kernel (B) according to the new information available such as return
address and backup pages map. For this solution, something still need to
be solved is how to pass some information back from kernel B
(hibernating kernel) to kernel A (original kernel) and how to pass some
information from kernel C (resuming kernel) to kernel A (original
kernel).

-----------------------------------------------------------------

Another possible solution to pass information between kernels (in user
space): needed information from kernel are passed in stack, and a
special ELF_NOTES is used to access the information in peer kernel.
Details is as follow:

1. Possible information need to be passed:

1.1 From user space (known before sys_kexec_load):

a. ELF core header
b. vmcoreinfo (pointer only)

1.2 From kernel space (known after sys_kexec_load):

a. jump back entry (return address)
b. backup pages map


2. When jumping from kernel A to kernel B:

2.1 In /sbin/kexec --load-preserve-context <kernel-image>, /sbin/kexec
allocate a special ELF_NOTES (ELF NOTES kernel) for information from
kernel space.

2.2 When doing sys_reboot(REBOOT_CMD_KEXEC), kernel put needed
information and physical address of ELF core header onto stack just
before jump to purgatory.

2.3 After jumping to purgatory, purgatory fills "ELF NOTES kernel" with
corresponding address in stack.

2.4 When kernel B is booted, /proc/vmcore is created and the information
form ELF NOTES kernel is available too.


3. When jumping back from kernel B to kernel A and jumping from kernel C
to kernel A:

3.1 Same as 2.1

3.2 Same as 2.2, but there is no purgatory in kernel A, so when
information are put on stack, jump to "jump back entry" of kernel A
directly.

3.3 The code on jump back entry of kernel A will work as a purgatory to
fill "ELF NOTES kernel" with corresponding address in stack.
Then /proc/vmcore reset code is called again to (re-)construct
the /proc/vmcore with new information.


Best Regards,
Huang Ying

