Return-Path: <linux-kernel-owner+w=401wt.eu-S1758486AbYDNGFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758486AbYDNGFZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 02:05:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753667AbYDNGFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 02:05:15 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:57541 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626AbYDNGFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 02:05:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@seznam.cz
Subject: Re: Microblaze Linux release
Date: Mon, 14 Apr 2008 08:01:55 +0200
User-Agent: KMail/1.9.9
Cc: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
       John Williams <john.williams@petalogix.com>, jwboyer@linux.vnet.ibm.com,
       benh@kernel.crashing.org, John Linn <John.Linn@xilinx.com>,
       git-dev@xilinx.com, Grant Likely <grant.likely@secretlab.ca>,
       git@xilinx.com, microblaze-uclinux@itee.uq.edu.au,
       linux-kernel@vger.kernel.org, paulus@samba.org
References: <48020A21.4000404@seznam.cz> <200804140538.30268.arnd@arndb.de>
In-Reply-To: <200804140538.30268.arnd@arndb.de>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804140801.57464.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18izZGQdxyAosSwPSJ/luR+z+ArVd0quFJXXwx
 DOqOptSYT0Zzf1sYe/Nyh2XUT4oFe68Hb1fCDlTqc+nqqSXhgA
 qPwHWvFzmAwL7vHeeCQWA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 April 2008, Arnd Bergmann wrote:

> I'm certainly willing to help review it, but I think the timing is too short
> for asking for a 2.6.26 merge. Judging from experience, a new architecture
> review takes a few weeks to sort out all the issues you want resolved before
> merging, so posting them now would put you in a much more comfortable position
> when targeting a 2.6.27 merge.

I've just looked at your git tree, and it confirmed my point that we need
a little more time. Please don't hesitate to submit patches to the mailing
list though. You may have misunderstood the idea of the merge window: The
patches can go in during that time if they have been reviewed before, so
it is not the time to post patches for review.

More to the point, here are a few things that I noticed on a brief
review:

* Your arch code in general looks nice and clean, don't worry too much
about the coding style right now.

* The code level is 2.6.24-rc8, while the current head is at 2.6.25-rc9.
You should really upgrade the kernel level, because a number of changes
have gone in that directly affect your code. Your best bet is probably
now to have a patch against the linux-next tree, which also has the changes
that will go into 2.6.26.

* Your syscall ABI is largely obsolete. A third of the syscalls you
define should not even be there in the first place as they have been
replaced by newer versions. E.g. you have select, _newselect and pselect6,
where just pselect6 would be sufficient -- you don't need to worry about
backwards compatibility if you don't have existing code. A good start
would be to take the arch/blackfin syscall list and further reduce it
from there. Further examples are:
- replace socketcall with separate syscall entry points
- replace ipc with a separate entry points
- remove all the legacy signal handling from arch/microblaze/kernel/signal.c
- remove sys_mmap, sys_olduname and sys_vfork
- finally define a generic sys_mmap2 and sys_uname in kernel/ so you don't
  need another copy in arch/microblaze/kernel
- Use 64 bit off_t, and 32 bit uid_t, gid_t etc.

* Your device tree functions in of_device.c, of_platform.c, prom.c and
prom_parse.c are basically copies of the powerpc versions. This duplication
is not helpful, better merge that code into new files in drivers/of/
so that it can be shared.

* The semaphore implementation will be obsolete in 2.6.26

* The EXPORT_SYMBOL definitions for csum_partial etc should be in
arch/microblaze/lib/checksum.c, not in microblaze_ksyms.c, same
for memcpy/memmove/memset.

* The platform directory is noticably empty. You can probably judge better
how much platform specific code there will be in the future, but I would
suspect that you're better off with a flat platform directory instead
of subdirectories below that.

* the consistent.c implementation looks strange. Is any of that code
even used anywhere? What is it good for, considering that you don't have
an mmu?

* Your dma_mapping.h does BUG() for almost everything. I suspect you could
easily replace it with a trivial implementation, like the x86_32 one.

* I'm not sure if you really need something as sophisticated as the lmb
code, if you don't have a real firmware, or even an MMU. setup_memory
can probably work with something much simpler, and for the prom.c stuff,
you may get away with #defining them to bootmem_alloc etc.

* You don't seem to have any code for PCI, so the pci.h and pci-bridge.h
files don't make much sense.

* The following files:
atomic.h checksum.h io.h ioctl.h ioctls.h ipcbuf.h msgbuf.h param.h
poll.h posix_types.h sembuf.h shmbuf.h shmparam.h sigcontext.h signal.h
socket.h sockios.h stat.h termbits.h termios.h types.h ucontext.h
all look like verbatim copies of some other architecture. Please do
the next person to come up with a new architecture a favor and stick them
in include/asm-generic instead, including them from your own headers.

* You unistd.h contains _syscall* macros. These were removed some time
ago from all other architectures.

* You define a lot of __ARCH_WANT_SYS_ macros. Generally, these are
for the syscalls you don't want.

* You are missing a include/asm-microblaze/Kbuild file that lists all
the header files you want to export to user space.

	Arnd <><
