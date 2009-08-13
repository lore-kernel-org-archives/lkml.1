Return-Path: <linux-kernel-owner+w=401wt.eu-S1754803AbZHMP3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbZHMP3R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 11:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752479AbZHMP3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 11:29:16 -0400
Received: from www.lumino.de ([85.159.12.10]:45622 "HELO imap.lumino.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752175AbZHMP3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 11:29:16 -0400
X-Greylist: delayed 1561 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Aug 2009 11:29:15 EDT
Message-ID: <4A842B32.5030401@lumino.de>
Date: Thu, 13 Aug 2009 17:03:14 +0200
From: Michael Schnell <mschnell@lumino.de>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: implementing Futex
X-Enigmail-Version: 0.95.7
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi experts,

I am planning to implement a Futex on the upcoming MMU-enabled NIOS
architecture.

I do know that the pure user-space part of the Futex is done in gLibC,
so that pthread_mutex...() automatically uses Futex, if same is
available in the underlying arch, and use some system call it it is not.
But for my first tests, I will not recompile gLibC but I do have a
working (on x86) Futex user code implementation, inspired by Ulrich
Drepper: "Futexes Are Tricky".

One of the tasks is to provide the appropriate atomic user-space
operations for the Futex implementation. I was able to successfully do
this for the x86 user space code and we have been discussing, how to do
 this with other archs.

Now in the Kernel code in "linux-2.6/arch/x86/include/asm/futex.h" there
are two different implementations for some atomic operations for the  Futex:

"futex_atomic_op_inuser()"    and
"futex_atomic_cmpxhg__inatomic()"


"futex_atomic_op_inuser()" seemingly accesses user space data while
being run in Kernel space (doing the .section __ex_table trick).

Questions:

Is this correct ?

In a non-SMP environment do we need to use really atomic code here, or
does futex_atomic_op_inuser() run with interrupt disabled, anyway?

When we are doing futex_atomic_op_inuser(), is this Kernel code running
in system mode so that we can disable the interrupt do protect the
atomic code in a non-SMP System ?

>From reading the code (futex_atomic_op_inuser() seems only to be called
once (in futex.c) ), it seems that futex_atomic_op_inuser() is not
really used at all. It seems that it'd only called for futex_wake, and
here the "Operation" is derived from the last parameter of the system
call, which the man page says is ignored.  So, are all the operations
implemented there really necessary or just "nice to have" ?


I see that futex_atomic_cmpxhg__inatomic() really is used by futex.c

"futex_atomic_cmpxhg__inatomic()" accesses the Futex without doing the
user-space-access-trick, so here, the MMU seems to be in User mode
configuration. So how does the Kernel use it ? (in the CPU's "user mode"
or "System mode", with interrupts enabled or disabled (protected against
concurrent SMP accesses by a spinlock) )

Any pointers ?

Thanks for all answers,
-Michael
