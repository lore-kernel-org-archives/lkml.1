Return-Path: <linux-kernel-owner+w=401wt.eu-S1754526AbZGOMFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526AbZGOMFU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 08:05:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754104AbZGOMFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 08:05:20 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:57891 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752973AbZGOMFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 08:05:19 -0400
Date: Wed, 15 Jul 2009 13:05:12 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: John Williams <jwilliams@itee.uq.edu.au>, monstr@monstr.eu,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       LTP <ltp-list@lists.sourceforge.net>
Subject: Re: access_ok macor
Message-ID: <20090715120512.GA2752@linux-mips.org>
References: <4A5C8068.6020203@monstr.eu> <200907141843.05629.arnd@arndb.de> <9e6f3dfd0907141811p512b4edp3f9dd0fdeae1123e@mail.gmail.com> <200907151214.52369.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907151214.52369.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 15, 2009 at 12:14:52PM +0200, Arnd Bergmann wrote:

> On Wednesday 15 July 2009, John Williams wrote:
> > On Wed, Jul 15, 2009 at 2:43 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> > > The solution then is to handle fixups from the unaligned exception handler
> > > if you come from the kernel. That should fix the three text cases.
> > >
> > > I don't fully understand your exception handling there, but I think you
> > > also need to add code checking for __range_ok() to your unaligned handler,
> > > to prevent malicious user space code from accessing the kernel through
> > > unaligned pointers.
> > 
> > 
> > Just to try to clarify - are there any alignment rules in the ABI on
> > user-space pointers (which end up going to get/put_user)?
> 
> The kernel normally expects aligned input from user space, but I guess
> it can't hurt to handle it anyway. arch/mips/kernel/alignment.c seems
> to handle that case. Maybe Ralf can give some more insight.

It's arch/arm/mm/alignment.c rsp. arch/mips/kernel/unaliged.c.

> > It seems the failure path is like this:
> > 
> > 1. userspace passes unaligned pointer
> > 2. get_user attempts to access
> > 3. CPU raises unaligned exception (if only it would raise the segfault as
> > higher priority, before the unaligned!)
> > 4. unaligned exception handler attempts to simulate the unaligned access
> > with multiple partial read/write ops
> > 5. CPU raises MMU exception on the read/write by the unaligned handler
> > 6. kernel segfault handler looks up faulting address, it is in the unaligned
> > exception handler, which has no fixup.
> > 7. no fixup -> failure
> 
> Right.
> 
> > So, I suppose the question is - where in the sequence is the true failure?
> 
> I think in step 4. AFIACT, the kernel must do a number of checks on accesses
> to random pointers.

Yes; but the checks that unaligned.c does on MIPS are no different from
any other get_user(), that is it ensures that the entire 8/16/32/64-bit
access is in userspace.  That's done using access_ok().

> > Clearly LTP thinks it's ok to pass unaligned pointers to the kernel,
> > suggesting (1) is fine - thus my question about alignment rules in the ABI.
> 
> No, LTP thinks it should get a -EFAULT error code for that access. It does
> specify whether it expects this because of an unaligned address or because
> of an invalid page.
> 
> > Do we need fixups on the unaligned handler itself? This will be ugly ugly
> > ugly. 
> 
> That's what ARM does. You don't have to do it from assembly though,
> implementing it in C is probably easier.

The MIPS psABI of which the Linux/MIPS ABI is sort of derived doesn't
specify any alignment-specific behaviour for syscalls.  That is they're not
treated any different than any random piece of library code.  I don't
know of any other standards documents (POSIX, single UNIX etc.) that
would have anything relevant either.

There are several historic precedents for why Linux handles miss-alignment
this way:

  o The networking stack where some cards may align the header in memory
    such that IP addresses are always on an address that is aligned to a
    16-bit but not a 32-bit boundary.  The tulip cards do that for example.
    It was considered a better solution to emulate the access or copy the
    entire rx packet before further processing than hacking up the
    networking stack to handle with ill-designed hardware.

  o Another in-kernel case was the MS-DOS partition table parsing.

  o The were also a bunch of historic Linux applications originally written
    for x86 which were relativly hard to port, so generally handling
    exceptions, was the by far easiest thing to do and probably for most
    architectures where this is relevant it's the easiest to handle all
    miss-alignment cases, not just selectively userland and maybe IP and
    MS-DOS partition table parsing.

We've moved on.  Handling miss-alignment is no longer a very relavent part
of the syscall interface.  So I think for the definition of the Linux
ABI this should just be left as implementation defined behaviour but
whatever an architecture does, it should be done consistently for all
system interfaces.

  Ralf
