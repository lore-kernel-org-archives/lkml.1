Return-Path: <linux-kernel-owner+w=401wt.eu-S1760205AbYDOMxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760205AbYDOMxq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 08:53:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752655AbYDOMxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 08:53:37 -0400
Received: from service2.sh.cvut.cz ([147.32.127.218]:55174 "EHLO
	service2.sh.cvut.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225AbYDOMxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 08:53:36 -0400
Message-ID: <4804A59B.5040909@seznam.cz>
Date: Tue, 15 Apr 2008 14:54:51 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
       John Williams <john.williams@petalogix.com>, jwboyer@linux.vnet.ibm.com,
       benh@kernel.crashing.org, John Linn <John.Linn@xilinx.com>,
       git-dev@xilinx.com, Grant Likely <grant.likely@secretlab.ca>,
       git@xilinx.com, microblaze-uclinux@itee.uq.edu.au,
       linux-kernel@vger.kernel.org, paulus@samba.org
Subject: Re: Microblaze Linux release
References: <48020A21.4000404@seznam.cz> <200804140538.30268.arnd@arndb.de> <200804140801.57464.arnd@arndb.de>
In-Reply-To: <200804140801.57464.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

>> I'm certainly willing to help review it, but I think the timing is too short
>> for asking for a 2.6.26 merge. Judging from experience, a new architecture
>> review takes a few weeks to sort out all the issues you want resolved before
>> merging, so posting them now would put you in a much more comfortable position
>> when targeting a 2.6.27 merge.
> 
> I've just looked at your git tree, and it confirmed my point that we need
> a little more time. Please don't hesitate to submit patches to the mailing
> list though. You may have misunderstood the idea of the merge window: The
> patches can go in during that time if they have been reviewed before, so
> it is not the time to post patches for review.
>
> More to the point, here are a few things that I noticed on a brief
> review:
> 
> * Your arch code in general looks nice and clean, don't worry too much
> about the coding style right now.

I think so. I spent a lot of time to clean the code.

> * The code level is 2.6.24-rc8, while the current head is at 2.6.25-rc9.
> You should really upgrade the kernel level, because a number of changes
> have gone in that directly affect your code. Your best bet is probably
> now to have a patch against the linux-next tree, which also has the changes
> that will go into 2.6.26.

I am working on 2.6.25-rc9 Microblaze version. I am solving issue about
CONFIG_HZ and new syscall timerfd_... . There are new 3 syscalls. And I think
that these syscalls bring up failure to MB code.

> * Your syscall ABI is largely obsolete. A third of the syscalls you
> define should not even be there in the first place as they have been
> replaced by newer versions. E.g. you have select, _newselect and pselect6,
> where just pselect6 would be sufficient -- you don't need to worry about
> backwards compatibility if you don't have existing code. A good start
> would be to take the arch/blackfin syscall list and further reduce it
> from there. Further examples are:
> - replace socketcall with separate syscall entry points
> - replace ipc with a separate entry points
> - remove all the legacy signal handling from arch/microblaze/kernel/signal.c
> - remove sys_mmap, sys_olduname and sys_vfork
> - finally define a generic sys_mmap2 and sys_uname in kernel/ so you don't
>   need another copy in arch/microblaze/kernel
> - Use 64 bit off_t, and 32 bit uid_t, gid_t etc.

This kernel don't need to keep backward compatibility. No one will port to
previous version. I'll look at your points and I'll send you what I do.

> * Your device tree functions in of_device.c, of_platform.c, prom.c and
> prom_parse.c are basically copies of the powerpc versions. This duplication
> is not helpful, better merge that code into new files in drivers/of/
> so that it can be shared.

These files are almost the same. There is small differences between them. I
would like to avoid to merge this code with PowerPC because this generate a lot
of mails in this steps.

BTW: OF code in powerpc have coding style violation.

Guys from PowerPC. Can you move these files around OF to drivers/of folder? or
Can you propose easier way for me?

I think we can solve these files when we merge Microblaze to PowerPC branch.

> * The semaphore implementation will be obsolete in 2.6.26

I don't know. Which cpu has correct implemetnation?

> * The EXPORT_SYMBOL definitions for csum_partial etc should be in
> arch/microblaze/lib/checksum.c, not in microblaze_ksyms.c, same
> for memcpy/memmove/memset.

OK. I fixed it.

> * The platform directory is noticably empty. You can probably judge better
> how much platform specific code there will be in the future, but I would
> suspect that you're better off with a flat platform directory instead
> of subdirectories below that.

I consult this with John Williams and this was result of our meeting. This
structure is more comfortable for adding new platform inside distribution. I
would like to keep this for now. We'll see if is good or not in future.

> * the consistent.c implementation looks strange. Is any of that code
> even used anywhere? What is it good for, considering that you don't have
> an mmu?

We have prepared MMU code. I hope that this code for FDT kernel comes soon.
This code is written by John Williams. I have never changed it. I see that this
code solves problems around ucached_shadows stuff.
http://developer.petalogix.com/wiki/UserGuide/AdvancedTopics/EnablingUncachedShadow
JW. Can you comment this?

> * Your dma_mapping.h does BUG() for almost everything. I suspect you could
> easily replace it with a trivial implementation, like the x86_32 one.

OK. I'll synchronize this.

> * I'm not sure if you really need something as sophisticated as the lmb
> code, if you don't have a real firmware, or even an MMU. setup_memory
> can probably work with something much simpler, and for the prom.c stuff,
> you may get away with #defining them to bootmem_alloc etc.

LMB code cames with OF. You wrote that prom.c files and others are written for
PowerPC and PowerPC uses lmb allocation. For me was simplier to add LMB code to
Microblaze. As I wrote above. Microblaze have static (old configuration style)
implementation for MMU. I think it will be improvident to redesign this code
when I know that I will merge noMMU kernel with MMU.

> * You don't seem to have any code for PCI, so the pci.h and pci-bridge.h
> files don't make much sense.

Yes you are right. I don't have any PCI code but I think that this code for MB
exists. Steve or John: Do you have any code for PCI?

> * The following files:
> atomic.h checksum.h io.h ioctl.h ioctls.h ipcbuf.h msgbuf.h param.h
> poll.h posix_types.h sembuf.h shmbuf.h shmparam.h sigcontext.h signal.h
> socket.h sockios.h stat.h termbits.h termios.h types.h ucontext.h
> all look like verbatim copies of some other architecture. Please do
> the next person to come up with a new architecture a favor and stick them
> in include/asm-generic instead, including them from your own headers.

I'll look which files are the same with others arch.

> * You unistd.h contains _syscall* macros. These were removed some time
> ago from all other architectures.

I removed it.

> * You define a lot of __ARCH_WANT_SYS_ macros. Generally, these are
> for the syscalls you don't want.

ARCH_WANT is defined for syscalls which I don't want. I don't understand this.

I think that I ARCH_WANT is for syscalls which I want and IGNORE for rest. Am I
right?

> * You are missing a include/asm-microblaze/Kbuild file that lists all
> the header files you want to export to user space.


I add it. This files comes from PowerPC.

> 	Arnd <><

Thanks for your review,

Michal Simek
www.monstr.eu




