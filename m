Return-Path: <linux-kernel-owner+w=401wt.eu-S1764941AbYDONgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764941AbYDONgB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 09:36:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757257AbYDONfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 09:35:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:50525 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475AbYDONfw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 09:35:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@seznam.cz
Subject: Re: Microblaze Linux release
Date: Tue, 15 Apr 2008 15:32:10 +0200
User-Agent: KMail/1.9.9
Cc: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
       John Williams <john.williams@petalogix.com>, jwboyer@linux.vnet.ibm.com,
       benh@kernel.crashing.org, John Linn <John.Linn@xilinx.com>,
       git-dev@xilinx.com, Grant Likely <grant.likely@secretlab.ca>,
       git@xilinx.com, microblaze-uclinux@itee.uq.edu.au,
       linux-kernel@vger.kernel.org, paulus@samba.org
References: <48020A21.4000404@seznam.cz> <200804140801.57464.arnd@arndb.de> <4804A59B.5040909@seznam.cz>
In-Reply-To: <4804A59B.5040909@seznam.cz>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-Id: <200804151532.11619.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+IskoM1STHrxIubWCbuFjsevvrfC4gIQSqQHe
 A5BoxE4E5sj7QzoesPGKrYtbpQH0AAcJnOZwBQxfTFTaac6jWs
 D2TQkn/2JvWL5IqGJCH3A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 April 2008, Michal Simek wrote:

> > * Your device tree functions in of_device.c, of_platform.c, prom.c and
> > prom_parse.c are basically copies of the powerpc versions. This duplication
> > is not helpful, better merge that code into new files in drivers/of/
> > so that it can be shared.
> 
> These files are almost the same. There is small differences between them. I
> would like to avoid to merge this code with PowerPC because this generate a lot
> of mails in this steps.
> 
> BTW: OF code in powerpc have coding style violation.
> 
> Guys from PowerPC. Can you move these files around OF to drivers/of folder? or
> Can you propose easier way for me?
> 
> I think we can solve these files when we merge Microblaze to PowerPC branch.

I think the easiest way is to include those patches in your series
and ask for an Acked-by from paulus.

The order of the patches should be:

1. fix up any coding style issues you have found
2. move the files without further changes to drivers/of
3. add whatever code you need to make it work on both architectures

Be careful not to break sparc in the process, as they are already
sharing substantial parts of the OF code with powerpc.

> > * The semaphore implementation will be obsolete in 2.6.26
> 
> I don't know. Which cpu has correct implemetnation?

2.6.26 will have a common implementation in kernel/semaphore.c.
All you need is a one-line asm/semaphore.h to #include linux/semaphore.h.

> > * the consistent.c implementation looks strange. Is any of that code
> > even used anywhere? What is it good for, considering that you don't have
> > an mmu?
> 
> We have prepared MMU code. I hope that this code for FDT kernel comes soon.
> This code is written by John Williams. I have never changed it. I see that this
> code solves problems around ucached_shadows stuff.
> http://developer.petalogix.com/wiki/UserGuide/AdvancedTopics/EnablingUncachedShadow
> JW. Can you comment this?

>From what I can see, your consistent.c code is just wrong and uses an
obsolete interface. Since you currently don't use it, I'd suggest to
drop it from your current tree for the merge. We can discuss it again
when you add MMU support.
 
> > * I'm not sure if you really need something as sophisticated as the lmb
> > code, if you don't have a real firmware, or even an MMU. setup_memory
> > can probably work with something much simpler, and for the prom.c stuff,
> > you may get away with #defining them to bootmem_alloc etc.
> 
> LMB code cames with OF. You wrote that prom.c files and others are written for
> PowerPC and PowerPC uses lmb allocation. For me was simplier to add LMB code to
> Microblaze. As I wrote above. Microblaze have static (old configuration style)
> implementation for MMU. I think it will be improvident to redesign this code
> when I know that I will merge noMMU kernel with MMU.

LMB doesn't have much to do with an MMU, but more with the way certain IBM
machines extend the OF interfaces.

I'd recommend splitting prom.c into code that can be shared between powerpc
and microblaze and architecture specific code. Anything that deals with
LMB should go into powerpc, and you can simply use the alloc_bootmem
mechanism for your architecture.
 
> > * The following files:
> > atomic.h checksum.h io.h ioctl.h ioctls.h ipcbuf.h msgbuf.h param.h
> > poll.h posix_types.h sembuf.h shmbuf.h shmparam.h sigcontext.h signal.h
> > socket.h sockios.h stat.h termbits.h termios.h types.h ucontext.h
> > all look like verbatim copies of some other architecture. Please do
> > the next person to come up with a new architecture a favor and stick them
> > in include/asm-generic instead, including them from your own headers.
> 
> I'll look which files are the same with others arch.

That was not my point, although it would be a good idea as well.
The important bit is that your version of these files don't contain
any architecture specific code (no guarantees, my review may have
been sloppy). Even if every architecture so far has a different
version of them, but any of them would be ok for you, please throw
one of them into asm-generic and start using it.
All future architectures can simply use that copy as well, as long as
they have the same constraints (e.g. you atomic.h assumes there are
no atomic operations other than spinlock, iirc).

If you want to be really nice, look for the most common implementation
across the existing architectures and put that into asm-generic.
Also, please cc the linux-arch mailing list on any patch that adds
a file in asm-generic.

> > * You define a lot of __ARCH_WANT_SYS_ macros. Generally, these are
> > for the syscalls you don't want.
> 
> ARCH_WANT is defined for syscalls which I don't want. I don't understand this.
> 
> I think that I ARCH_WANT is for syscalls which I want and IGNORE for rest. Am I
> right?

Sorry, my comment was impossible to understand ;-).
What I meant is that a new architecture should not define these macros, because
only architectures with a need for backwards compatibility want the syscalls
they enable. If you find an exception and think you need one of them, please
tell us.

	Arnd <><
