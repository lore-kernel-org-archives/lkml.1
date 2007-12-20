Return-Path: <linux-kernel-owner+w=401wt.eu-S1759913AbXLTLwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759913AbXLTLwl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 06:52:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757926AbXLTLwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 06:52:33 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35522 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757909AbXLTLwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 06:52:31 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [PATCH -mm 00/43] user_regset framework -- arch maintainers take note!
Message-Id: <20071220115200.C767E26F98A@magilla.localdomain>
Date: Thu, 20 Dec 2007 03:52:00 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a large series of patches, but there are only a couple
that you need to read in detail to know how to get started on
cleaning up your arch code (1, 4, 6).

user_regset is a new kernel-internal interface into the arch
code for accessing the user-space view of machine-specific
state (registers et al--everything machine-specific that is
visible via ptrace and the like, or should be).  The idea is
that arch code will have just one place it has to support
fetching and changing the user-visible machine state of a
user thread.  This same interface can be used for writing
core dumps, to underlie the implementation of PTRACE_GETREGS,
PTRACE_SETREGS, and the like, and by any new set of debugging
facilities that might come along.

Why you should like this if you are an arch maintainer:
1. One place to maintain the guts of extracting thread state, get
   rid of ELF_CORE_* macros, ugly ptrace implementation bits.
2. Easier way to support 32-on-64 compat for core dump formats.
3. Clean up your arch ptrace code, have less magic to maintain.
   Also see http://lwn.net/Articles/259841/ to adapt your arch
   support for single-step into the generic entry points so you
   can use the arch-independent ptrace code to do more dirty work.
4. When a new CPU variant comes along with a new set of registers
   (new FPUs and vector units, etc), just one place to add support
   and one format for the data, automatically covers core dumps and
   later debugging interfaces.
5. When new core kernel changes come along for better debugging
   facilities, you won't have to do anything to have them supported
   on your arch.  When you provide user_regset data structures and
   entry points, you've done your part.

Why you should like this if you don't touch arch code:
1. One place to consolidate all you needed to know about whatever
   arch, just check its user_regset formats to see what people
   versed in this arch think userland needs to have access to.
2. Without something like it, new and better facilities for user
   process debugging are intractable to implement and you won't get any.

I've settled on the machine-specific data formats used in ELF core
dump files as the standard for the data layouts intended to be seen by
userland.  My logic is as follows.  There should be a single canonical
user format for each kind of machine state (general registers, FPU
registers, etc.)--that's just common sense.  There are two current
precedents for formats already known to userland for these things,
being the ELF core dump formats and the ptrace formats, and one of
those is a pile of crap.  So, user_regset data formats are, by
definition, "note" data formats for ELF core dumps, and they're
distinguished by the n_type codes (NT_* constants); regset 0 has to be
elf_gregset_t, which is embedded in the NT_PRSTATUS note.  All other
regset notes are nothing but the contents of the regset, the machine
state of the thread (e.g. NT_PRFPREG).  You can define user_regset
flavors that don't set an n_type code if you want to.  But it's
worthwhile to let the debugger examine some chunk of thread state,
then it's also worthwhile to have it in a dump for examination after
the fact, so you might as well just add a new NT_<CPU>_* constant.
(Picking the constant and flipping a switch is all it takes to cause
a new user_regset flavor to appear in core dumps.)

Patches 1 through 9 affect only machine-independent code.
These add the infrastructure that revamped arch code uses.
The new code has no effect on any arch that does not change
its code to define some new macros or use some new functions.

Patches 10 through 25 affect only arch/powerpc code.  I have
also CC'd these to linux-arch to give an example of what the
arch code looks like when you clean things up to work via the
user_regset interfaces.  The powerpc code was already pretty
clean, so the changes are fairly easy to understand even if
you aren't familiar with powerpc.

Patches 26 through 43 affect only arch/x86 code.  I have not
CC'd these ones to linux-arch.  They include a bunch of
cleanup that is specific to the idiosyncracies of the x86
code and isn't interesting as an example for what another
arch would do.

I'd be glad to help anyone interested in adapting more arch code
to the user_regset style with the details.


Thanks,
Roland
