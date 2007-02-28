Return-Path: <linux-kernel-owner+w=401wt.eu-S1752042AbXB1VZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042AbXB1VZW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 16:25:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752037AbXB1VZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 16:25:22 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38822 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752017AbXB1VZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 16:25:20 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: eranian@hpl.hp.com, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org, ak@suse.de, tony.luck@intel.com
Cc: William Cohen <wcohen@redhat.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: debug registers and fork
In-Reply-To: Andrew Morton's message of  Tuesday, 27 February 2007 12:24:27 -0800 <20070227122427.bf23af2f.akpm@linux-foundation.org>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20070228212510.1E213180067@magilla.sf.frob.com>
Date: Wed, 28 Feb 2007 13:25:10 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It is true that debug registers are inherited by fork and clone.
I am 99% sure that this was never specifically intended, but it
has been this way for a long time (since 2.4 at least).  It's an
implicit consequence of the do_fork implementation style, which
does a blind copy of the whole task_struct and then explicitly
reinitializes some individual fields.  I suppose this has some
benefit or other, but it is very prone to new pieces of state
getting implicitly copied without the person adding that new state
ever consciously deciding what its inheritance semantics should be.

Alan Stern is working on a revamp of the x86 debug register
support.  This is a fine opportunity to clean this area up and
decide positively what the semantics ought to be.  When his stuff
gets ported to other machines, that will be a natural way to make
the analogous stuff coherent and sensible on all machines that
have debug-feature CPU state.

AFAIK, gdb expects this behavior but not in the positive sense.
Rather, it finds the kernel's semantics here unhelpful, and has to
work around them.  If it has watchpoints on a thread that might
fork, it has to catch the child just to clear the debug registers
even if it never really wanted to be tracing that child.
Otherwise, the fork/clone child that was never ptrace'd at all
(and its children!)  might get a spurious SIGTRAP later and dump
core for no apparent reason; at least exec does clear the debug
registers (flush_thread).  Since the debugger interface is the
only way to set the debug registers, this kernel behavior seems
rather insane on the face of it.  OTOH, there is always the
argument to leave existing behavior as it is for compatibility's
sake.  (I won't be shocked to find some loony application that
uses ptrace on its own threads to set debug registers with the
expectation of running a SIGTRAP handler; such things have been
seen out there, though we no longer allow exactly that with NPTL
threads.)  I'm pretty sure gdb won't mind if the inheritance goes
away, though we should check with gdb people to be sure before
changing any semantics.

Personally, I don't care whether the semantics of fork when the
debug registers were previously set by ptrace change.  Existing
applications already have to cope with the lossage to work now,
and won't be able to go without those workarounds later anyway if
they want to support older kernels.  With Alan's stuff, particular
facilities cooperate coherently on maintaining this thread state,
and inheritance semantics for each particular use will be
specified explicitly how that use wants it.  Eventually I think
all "raw" use of the debug registers (as by the current ptrace
interfaces) will be obsolete anyway.

It is true that %dr7 is not cleared when switching to a task where
it's logically 0, but that is intentional and not a problem AFAIK.
The trap handler (arch/{i386,x86_64}/kernel/traps.c:do_debug)
first checks if %dr7 is logically 0 in the current task, and if so
it swallows the trap and clears %dr7 in hardware.  This also has
been this way for a very long time.  I assume that whenever it was
first implemented, someone found reason to think that clearing
%dr7 was more costly overall than the possibility of a spurious
trap (relatively quite unlikely compared to 100% of context switches).
(I have no idea what the overhead is on current or older hardware.)
I have no reason to think there is anything wrong with how this behaves.


Thanks,
Roland
