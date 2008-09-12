Return-Path: <linux-kernel-owner+w=401wt.eu-S1756499AbYILC5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499AbYILC5s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 22:57:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755034AbYILC5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 22:57:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33867 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754993AbYILC5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 22:57:38 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: linux-arch@vger.kernel.org
Cc: utrace-devel@redhat.com, linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: CONFIG_HAVE_ARCH_TRACEHOOK and you
X-Zippy-Says: Didn't KIERKEGAARD wear out his TIRES in VIENNA during a SNOWSTORM
    of FREUD's unpaid DENTAL BILLS?
Message-Id: <20080912025733.E55F415420D@magilla.localdomain>
Date: Thu, 11 Sep 2008 19:57:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, linux-arch!  I'd like to tell you about CONFIG_HAVE_ARCH_TRACEHOOK
and what each arch's maintainers will want to do about it.

In the current tree (since 2.6.27-rc1), arch/Kconfig defines the
internal config item HAVE_ARCH_TRACEHOOK.  The idea is to set a new
baseline of what an arch has to implement to support tracing/debugging
of user tasks.  After you do these things, then new kinds of tracing
features, new replacements for ptrace, or drastic changes to the
implementation details of ptrace, can come along later and just work on
your arch without every arch maintainer having to worry about the
details of new features or new non-arch implementation details.  When
your arch is ready, adding "select HAVE_ARCH_TRACEHOOK" somewhere in an
arch-specific Kconfig file makes known that your arch is compatible with
new code.  New features and options will "require HAVE_ARCH_TRACEHOOK".

In 2.6.27 (as of rc6), powerpc{,64} and sparc{,64} have complete support
and do "select HAVE_ARCH_TRACEHOOK".  In 2.6.28, x86 will have it (that
work is already done and waiting in the tip/x86/tracehook branch), and I
believe s390 is also already on track to have it done in 2.6.28.  Since
2.6.27-rc1, everything mentioned here has been in place in the generic
code, so you can start the changes for your arch as soon as you like.

If there is interest, I can run an informal session at the Kernel Summit
and/or Linux Plumbers Conference next week to walk arch hackers through
each work item.  (I don't have any presentation to give or anything, all
the info is in this posting and/or documented in the source code.  But
we can work through it all in detail in person for as long as you'd like.)
Let me know ASAP if folks want this, so we can get it scheduled.

It has been suggested that we set a deadline to require every arch to be
compatible and set HAVE_ARCH_TRACEHOOK.  If your arch hadn't been
updated after that deadline, then your kernel build might break, or it
might still build but suddenly fail to support the ptrace system call.
I'm not especially suggesting this myself, and I really don't know when
that deadline might be set.  But it's possible that in a few releases,
you'd be sorry if you just ignore this stuff now and let it slide.

Of course more arch-specific work is liable to come along in the future
for some fancy new tracing features.  I won't try to promise that by
doing this now you won't ever have to think about ptrace and its ilk
again.  But it should be enough for a good number of possible new
features and reorganizations to come along and work on your arch without
you having to think about them, or at least not too much.

I did most of this work myself for x86 and powerpc.  I found it
advantageous to do it in a large number of tiny incremental patches.
There are many little items, but most are very quick to do (trivial).
With a few exceptions, this is pretty much just renaming and juggling code
you already have.  (The user_regset parts are most of the work.)  I'll be
glad to help with any specific questions about your arch code, or to
review your arch patches if you CC me.

All of the interfaces are subject to change if the current definitions
make life really hard for some arch.  So don't worry about bending over
backward, just pipe up if you see a problem.

The comment in arch/Kconfig lists the items:

#	task_pt_regs()		in asm/processor.h or asm/ptrace.h
#	arch_has_single_step()	if there is hardware single-step support
#	arch_has_block_step()	if there is hardware block-step support
#	arch_ptrace()		and not #define __ARCH_SYS_PTRACE
#	compat_arch_ptrace()	and #define __ARCH_WANT_COMPAT_SYS_PTRACE
#	asm/syscall.h		supplying asm-generic/syscall.h interface
#	linux/regset.h		user_regset interfaces
#	CORE_DUMP_USE_REGSET	#define'd in linux/elf.h
#	TIF_SYSCALL_TRACE	calls tracehook_report_syscall_{entry,exit}
#	TIF_NOTIFY_RESUME	calls tracehook_notify_resume()
#	signal delivery		calls tracehook_signal_handler()

The various kerneldoc comments in linux/ptrace.h, linux/tracehook.h,
asm-generic/syscall.h, and linux/regset.h give full details about the
new calls (some calls to make, some calls to define).

There is a little more verbiage you can find from:
	http://sourceware.org/systemtap/wiki/utrace/arch
Feel free to edit that wiki, or move the contents someplace else you
like better.  (It mentions utrace, but all the substance there is about
HAVE_ARCH_TRACEHOOK and not dependent on utrace, which is not in the kernel.)

Maybe it's useful for more text about this to go into some Documentation/
file (please go right ahead and write one).

Here's the text that's on that wiki:

    1. task_pt_regs()

          * Define this inline function in asm/processor.h or asm/ptrace.h.

    2. arch_has_single_step(), arch_has_block_step()

          * If your hardware has single-step and/or block-step support, then
            define these macros and related functions.

            See the kerneldoc comments in linux/ptrace.h for details.

    3. arch_ptrace()

          * You must define arch_ptrace() and not #define __ARCH_SYS_PTRACE.

    4. compat_arch_ptrace()

          * If your arch uses CONFIG_COMPAT, you must define
            compat_arch_ptrace() and #define __ARCH_WANT_COMPAT_SYS_PTRACE.

    5. linux/regset.h

          * You must define user_regset structures and calls for your
            machine, and define task_user_regset_view(). The formats must
            match those used for core dumps, and have appropriate
            .core_note_type fields. See linux/regset.h for details.

    6. CORE_DUMP_USE_REGSET

          * You must #define CORE_DUMP_USE_REGSET in asm/elf.h and test that
            core dumps work via the user_regset interfaces and produce
            correct results.

    7. asm/syscall.h

          * You must supply asm/syscall.h for your arch, with all the
            functions (usually inlines) described in asm-generic/syscall.h.

    8. TIF_SYSCALL_TRACE

          * Setting TIF_SYSCALL_TRACE must cause calls from arch code to
            tracehook_report_syscall_entry() and
            tracehook_report_syscall_exit() instead of the old ptrace
            behavior. Note that the calling arch code should handle the
            return value from tracehook_report_syscall_entry(), which is
            behavior that was not required for the old ptrace
            support. This needs to implement some form of safe abort of
            the syscall. See the kerneldoc comments for the exact details.

    9. TIF_NOTIFY_RESUME

          * You must define the TIF_NOTIFY_RESUME bit. This should behave in
            the arch code like TIF_SIGPENDING, i.e. checked when returning to
            user mode so you can never miss one. But when TIF_NOTIFY_RESUME
            is set, the arch code must do:

                 clear_thread_flag(TIF_NOTIFY_RESUME);
                 tracehook_notify_resume(regs);

            where regs is the same as task_pt_regs(current). (That is the
            only effect of TIF_NOTIFY_RESUME, and it does not affect waits et
            al like TIF_SIGPENDING does.) This code path should not
            unconditionally go into the signals code, i.e. at some point you
            should check TIF_SIGPENDING independently and not enter a
            do_signal() path when only TIF_NOTIFY_RESUME is set; this avoids
            debugged threads serializing on their shared siglock.

   10. tracehook_signal_handler()

          * Your signal handling code should call tracehook_signal_handler()
            after doing handler setup. This happens after all the signal
            magic (sa_mask handling et al), usually the last thing before
            returning from do_signal() or a similar function in the arch
            code. See linux/tracehook.h for the parameters to pass it.


Thanks,
Roland
