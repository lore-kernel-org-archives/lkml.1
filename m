Return-Path: <linux-kernel-owner+w=401wt.eu-S1756313AbYILNlH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756313AbYILNlH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 09:41:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751622AbYILNkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 09:40:55 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39709 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbYILNky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 09:40:54 -0400
Date: Fri, 12 Sep 2008 14:40:11 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Roland McGrath <roland@redhat.com>
Cc: linux-arch@vger.kernel.org, utrace-devel@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: CONFIG_HAVE_ARCH_TRACEHOOK and you
Message-ID: <20080912134011.GA7385@flint.arm.linux.org.uk>
Mail-Followup-To: Roland McGrath <roland@redhat.com>,
	linux-arch@vger.kernel.org, utrace-devel@redhat.com,
	linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ptrace_report_syscall
---------------------

What's the purpose of the PT_PTRACED check in there?  The current code
is setup such that you can only start tracing syscalls if the
__ptrace_may_access test succeeds, which will only succeed if PT_PTRACED
is already set.  TIF_SYSCALL_TRACE will be cleared before PT_PTRACED is
cleared when stopping ptracing.  So, TIF_SYSCALL_TRACE can only ever be
set if PT_PTRACED is already set, and hopefully arch code never tries
to call the syscall tracing hooks if TIF_SYSCALL_TRACE isn't set.  That
all means that the PT_PTRACED test seems redundant.

Also, shouldn't ptrace_report_syscall() be in linux/ptrace.h, since it's
just the guts of the existing syscall tracing hook irrespective of the
tracehook stuff?


syscall
-------

 * syscall_get_arguments - extract system call parameter values
 * @task:       task of interest, must be blocked
 * @regs:       task_pt_regs() of @task
 * @i:          argument index [0,5]
 * @n:          number of arguments; n+i must be [1,6].
 * @args:       array filled with argument values

This is all very well, but adds a lot of complexity for architectures
which isn't currently required.  This is fine if you have a sane ABI
where you can just pick the arguments straight out of the registers one
by one.

However, with ARM EABI, we have the situation where, for a syscall such
as:

	long sys_foo(int a, long long b, long long c, int d);

the register allocation ends up as:

	a => r0
	b => r2, r3
	c => r4, r5
	d => r6

whereas:

	long sys_foo(long long a, long long b, int c, int d);

the register allocation ends up as:

	a => r0, r1
	b => r2, r3
	c => r4
	d => r5

So, in order to know which register argument N is in, you need to know
all the types of the arguments which come before it.  That means
creating and maintaining a table of syscall arguments which sounds
really sucky.

I can think of why you want these interfaces - because you see it as
necessary for things like strace.  However, strace needs to know the
type information for each syscall argument in any case, so by putting
the requirement for arg N access into the kernel, you're causing that
type information to be placed not only in strace but also into the
kernel.

It also means that you can't randomly change the syscall number, since
changing the syscall number between those two examples means you need
to reshuffle the registers to make the arguments fit.

To me, this looks like a source of a large can of worms.  Is this really
necessary, or can we keep this functionality pushed to where it belongs -
in the very few userspace applications which require it?

I think the rest of syscall.h shouldn't be that much of a problem for ARM.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
