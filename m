Return-Path: <linux-kernel-owner+w=401wt.eu-S1765879AbXHASiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765879AbXHASiT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 14:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758939AbXHASiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 14:38:10 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47035 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757286AbXHASiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 14:38:09 -0400
Date: Thu, 2 Aug 2007 00:20:24 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Ulrich Drepper <drepper@redhat.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: More documentation: system call how-to
In-Reply-To: <200708011806.l71I6v9N002535@devserv.devel.redhat.com>
Message-ID: <alpine.LFD.0.999.0708020004170.7288@enigma.security.iitk.ac.in>
References: <200708011806.l71I6v9N002535@devserv.devel.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ulrich,


On Wed, 1 Aug 2007, Ulrich Drepper wrote:

> How about adding the attached text to the Documentation directory?  I
> had to correct over the years to one or the other system call design
> problems.  Other problems couldn't be corrected anymore and we have to
> live with them.  Maybe spelling out the rules explicitly will help a bit.

Most definitely, but going through the list below, I could think of
maybe several more little things that people tend to forget when actually
/implementing/ the system call (and not necessarily the abstract level
design decisions such as argument(s) and sizes).


> I've added a few rules I could think of right now.  What should be
> added as well is a rule for 64-bit parameters on 32-bit platforms.  I
> leave this to the s390 people who have the biggest restrictions when
> it comes to this.

Yes, that must definitely be spelt out clearly, probably with examples
of how to do it right.

Another thing that's a must when designing a syscall would be thinking
of any security implications that it brings about and clearly spelling
out expected behaviour in all cases -- security could mean different
things for different syscalls, but just getting that word in here would
mean people don't make basic mistakes like introducing "xxx_set_xxx"
kind of syscalls that go ahead and modify kernel/global structures
without authors having even thought of how and why that's wrong.

Other than that, as I said above, probably what we also need is a
"system call implementation checklist" of some sort, which lists out the
basic things (copying buffers from/to userspace, various security checks,
other things I'm not recollecting currently) and how to get them right.


> Signed-off-by: Ulrich Drepper <drepper@redhat.com>
> 
> Rules for designing new system calls
> ------------------------------------
> 
> 1. Do not use multiplexing system calls.
> 
>    A practical argument is that it invariably reduces the number of
>    available parameters to the system call which will haunt people who
>    have to care about architectures with a limited set of registers
>    reserved for this purpose.
> 
>    Another aspect is that it is most likely slower.  The caller in
>    most cases knows exactly which sub-function of the system call is
>    needed.  If the decision about the sub-function is dynamic the
>    computation of the code could just as well be a computation of a
>    system call number.  The difference lies in the kernel where the
>    multiplexing always has to happen, even if the required
>    sub-function is known to the caller ahead of time.
> 
>    Adding new system calls is much cheaper: it is a word in a table.
>    This is much less code and data than the switch statement or
>    if-cascade needed to implement the multiplexer.
> 
>    Bad examples: sys_socketcall on x86, sys_futex, and several more
> 
> 
> 2. Use of ENOSYS:
> 
>    The runtime has to be able to distinguish non-existing system calls
>    due to old kernel versions from error conditions in an implemented
>    system call.  This means the ENOSYS error should never be used in
>    an error condition once a system call is implemented.
> 
>    Example: In sys_fallocate, if the file system does not implement the
>    fallocate operation, return EOPNOTSUPP and not ENOSYS.
> 
>    There is one exception to the rule: if rule #1 is violated and a
>    multiplexer system call is used, invalid sub-function codes should
>    be signaled using ENOSYS.
> 
>    Example: sys_futex
  ^^^

Probably makes sense to prefix "sad" or "unfortunate" here.

> 3. Choose parameters for growth
> 
>    It makes today no sense anymore to implement any system call which
>    restricts even on 32-bit machines the size of values indicating
>    file sizes or offsets to 32-bits.  64-bit values should be used
>    throughout.
> 
>    Example: sys_fadvise64, which should have been defined from day 1
>    like sys_fadvise64_64.

Again, this is a "bad" example.

>    Similarly, timeout granularity of seconds is not suitable anymore.
>    Most interfaces use nano-second resolution and a often used way
>    to specify such times and intervals is using the timespec structure.


Satyam
