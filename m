Return-Path: <linux-kernel-owner+w=401wt.eu-S933345AbXHASHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933345AbXHASHl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 14:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752795AbXHASHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 14:07:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41726 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752280AbXHASHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 14:07:31 -0400
Date: Wed, 1 Aug 2007 14:06:57 -0400
From: Ulrich Drepper <drepper@redhat.com>
Message-Id: <200708011806.l71I6v9N002535@devserv.devel.redhat.com>
To: linux-kernel@vger.kernel.org
Subject: More documentation: system call how-to
Cc: akpm@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

How about adding the attached text to the Documentation directory?  I
had to correct over the years to one or the other system call design
problems.  Other problems couldn't be corrected anymore and we have to
live with them.  Maybe spelling out the rules explicitly will help a bit.

I've added a few rules I could think of right now.  What should be
added as well is a rule for 64-bit parameters on 32-bit platforms.  I
leave this to the s390 people who have the biggest restrictions when
it comes to this.



Signed-off-by: Ulrich Drepper <drepper@redhat.com>

Rules for designing new system calls
------------------------------------

1. Do not use multiplexing system calls.

   A practical argument is that it invariably reduces the number of
   available parameters to the system call which will haunt people who
   have to care about architectures with a limited set of registers
   reserved for this purpose.

   Another aspect is that it is most likely slower.  The caller in
   most cases knows exactly which sub-function of the system call is
   needed.  If the decision about the sub-function is dynamic the
   computation of the code could just as well be a computation of a
   system call number.  The difference lies in the kernel where the
   multiplexing always has to happen, even if the required
   sub-function is known to the caller ahead of time.

   Adding new system calls is much cheaper: it is a word in a table.
   This is much less code and data than the switch statement or
   if-cascade needed to implement the multiplexer.

   Bad examples: sys_socketcall on x86, sys_futex, and several more


2. Use of ENOSYS:

   The runtime has to be able to distinguish non-existing system calls
   due to old kernel versions from error conditions in an implemented
   system call.  This means the ENOSYS error should never be used in
   an error condition once a system call is implemented.

   Example: In sys_fallocate, if the file system does not implement the
   fallocate operation, return EOPNOTSUPP and not ENOSYS.

   There is one exception to the rule: if rule #1 is violated and a
   multiplexer system call is used, invalid sub-function codes should
   be signaled using ENOSYS.

   Example: sys_futex


3. Choose parameters for growth

   It makes today no sense anymore to implement any system call which
   restricts even on 32-bit machines the size of values indicating
   file sizes or offsets to 32-bits.  64-bit values should be used
   throughout.

   Example: sys_fadvise64, which should have been defined from day 1
   like sys_fadvise64_64.

   Similarly, timeout granularity of seconds is not suitable anymore.
   Most interfaces use nano-second resolution and a often used way
   to specify such times and intervals is using the timespec structure.


4. 32-bit compatibility

   Kernels for architectures like x86-64 and PPC64 have to be able to
   execute 32-bit binaries as well.  The implementation of the actual
   system calls is of course shared.  The types for the system call
   parameters and return values on 32-bit and 64-bit systems can be
   different.  This is where compatibility wrappers come in.

   These functions, usually named compat_sys_XYZ for a system call
   sys_XYZ, are only needed in case the system call parameter is
   a pointer to a structure which has a different representation in
   32- and 64-bit mode.  Differences in size of integer or pointer
   arguments does not require a compatibility wrapper.

   Examples: compat_sys_utimensat, which has to convert a timespec
   structure from 32-bit to 64-bit.  See also rule #3.
