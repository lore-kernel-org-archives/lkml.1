Return-Path: <linux-kernel-owner+w=401wt.eu-S936907AbXGTWdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936907AbXGTWdX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 18:33:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbXGTWdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 18:33:05 -0400
Received: from www.osadl.org ([213.239.205.134]:41957 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751533AbXGTWdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 18:33:03 -0400
Subject: [RFC, Announce] Unified x86 architecture, arch/x86
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain
Date: Sat, 21 Jul 2007 00:32:59 +0200
Message-Id: <1184970779.4012.38.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We are pleased to announce a project we've been working on for some 
time: the unified x86 architecture tree, or "arch/x86" - and we'd like 
to solicit feedback about it.

What is this about?
-------------------

The topic of sharing more x86 code has been discussed on LKML a number 
of times. Various approaches were discussed and we decided to advance 
the discussion by implementing a full solution that brings the 
transition to a shared tree to completion.

Warning: our approach is quite a bit more extreme than what has been
suggested before.

The core idea behind our project is simple to describe: we introduce a 
new arch/x86/ and include/asm-x86/ file hierarchy that includes all the 
existing 32-bit and 64-bit x86 code and allows the building of either a 
32-bit (i386) kernel or a 64-bit (x86_64) kernel.

In this initial implementation the old arch/i386 and arch/x86_64 trees 
are removed _immediately_, in the same commit, and all future x86 
development goes on in the new, shared tree. So the transition right now 
is one atomic operation.

As a next step we plan to generate a gradual, fully bisectable, fully
working switchover from the current code to the fully populated
arch/x86 tree. It will result in about 1000-2000 commits. We are
releasing our current solution because it 100% represents the finally
resulting arch/x86 source tree already, and we first wanted to make
sure that the new architecture layout works fine and folks are happy
before we go and do the (even more complex) fine-grained work.

A git tree is available from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tglx/linux-2.6-x86.git

One (large!) combo patch is available at:

   http://kernel.org/pub/linux/kernel/people/tglx/linux-x86.2.6.22-git-ede13d.combo.patch.bz2

the patch is against this upstream -git head:

  commit ede13d81b4dda409a6d271b34b8e2ec9383e255d

It makes little sense to apply this patch to anything else because
these architectures are such a fast-moving target.


Why do we want to do this?
--------------------------

We believe that the whole x86 CPU family is very much related and should 
be supported in a single architecture tree. All 64-bit CPUs implement 
the ability to execute pure 32-bit kernels, and will probably do so for 
the next couple of decades. So it's not like it will ever be possible to 
get rid of our legacies: for example even the latest 64-bit CPUs 
implement the legacy "A20 line" feature that was already a weird 
outdated hack in the days of 16-bit x8086 CPUs.

So what can we do? We should learn to live better with our legacies, and 
we should avoid reinventing the wheel in 64-bit code. Today there's 
already some limited code sharing between the i386 and x86_64 trees, but 
it's quite non-obvious: it's either done via a placeholder file that 
#include's an out-of-arch file, or a Makefile rule that uses an
out-of-arch file. These 'cross-tree' file uses are not visible at the 
target point, and people sometimes break "the other arch" if they modify 
the file, because they are not aware of there being code sharing.

Furthermore, the separate i386 and x86_64 trees often cause kernel 
writers to (unconsciously) think in either 32-bit or in 64-bit terms, 
instead of thinking about the two things in one way. It also happened 
numerous times that code that was originally copied from arch/i386 gets 
64-bit-only additions in arch/x86_64, and if a bug is fixed in the 
32-bit code, that fix is not applied to the x86_64 tree. Or some 
function is cleaned up and improved in the x86_64 tree, but that 
improvement is not easily adaptable to arch/i386, because the x86_64 
code became 64-bit only already.

All in one: the two architecture trees are "way too far apart" from each 
other, which causes the source code to diverge not only physically but 
structurally as well. The whole setup works _against_ sharing code, 
instead of working _for_ sharing code. This causes double maintenance 
even for functionality that is conceptually the same for the 32-bit and 
the 64-bit tree. (such as support for standard PC platform architecture 
devices)


How did we do it?
-----------------

As an initial matter, we made it painstakingly sure that the resulting 
.o files in a 32-bit build are bit for bit equal. (at least in terms of 
.text, small .data differences are there due to the namespace changes). 
We also made it sure that you can pick up _any_ existing 32-bit .config, 
stick it into our new arch/x86 tree and build a fully working 32-bit 
kernel. Same is the goal for any existing 64-bit .config as well.

The shared x86 tree is _not_ "merge the 32-bit legacy code into the 
x86_64 tree". It is _not_ "create a x86_64 tree that can run on modern 
32-bit hardware too, leave arch/i386 around for ancient stuff". It is a 
unification between equals, all legacies and all new code is unified 
into one shared tree. Nothing is left behind.

A key component of our change is that only a very small portion of the 
conversion was done 'manually' - the overwhelming majority of file 
movement happened in an automated fashion. We did this to reduce the 
chance of human errors in the process of moving and rearranging more 
than a 1000 files.

We also made the change fully bisectable: you can bisect 'across' the
big arch/x86 commit and the .config's will be picked up correctly. The
git-history of all previously existing files has also been preserved
via the use of git's file-movement feature. The more fine-grained
multiple commits approach which we are ready to do is also providing a
fully bisectable and history preserving solution.

How is the new arch/x86 and include/asm-x86 namespace layed out? Our 
foremost concern was to enable a 100% smooth transition to the new, 
shared architecture, while still enabling much more fine-grained future 
unification of the source code. To do this we consciously aimed for the 
strictest possible unification strategy: we only 'unified' those source 
files that are already bit for bit equal between the two architectures 
today. For all other files we used the following rule: if a file came 
from arch/i386/foo/bar.c, it gets moved to arch/x86/foo/bar_32.c, if it 
came from arch/x86_64/foo/bar.c it gets moved to arch/x86/foo/bar_64.c. 
We also generated arch/x86/foo/bar.c that simply #include's those two 
files (depending on whether we do a 32-bit or a 64-bit built). If a file 
only existed in only one of the architectures, it's moved to 
arch/x86/foo/bar.c straight away. (take a look at our git repository to 
see how this works out in practice.)

Include files are handles similarly in include/asm-x86, with the 
exception of include files that are exported to user-space: for those, 
to preserve the source code API towards user-space, Kbuild creates 
symlinks from the _32.h or _64.h files to the .h file, instead of a stub 
.h file. In the future the number of such symlinks can be reduced 
significantly by unifying the files.

The arch/i386 and arch/x86_64 trees are removed completely, except for a 
small Kconfig and kbuild stub to ease bisection and to ease the import 
(and export) of .configs into the new, shared x86 architecture.

And we are serious about no-compromises compatibility of the transition: 
we built and booted an arch/x86 kernel on a real i386 DX CPU. (Yes, an 
old 33 MHz one. No, the CPU did not melt, Linux booted up fine!) We also 
built and booted a 64-bit kernel on a quad-core 64-bit CPU from the 
shared tree. (and on a number of other x86 systems.)


What will happen to arch/x86 in the future?
-------------------------------------------

Future, fine-grained unification is the main idea behind the new layout: 
'unifying' a 32-bit and a 64-bit source code file will be a matter of 
creating a single .c file from a _32.c and _64.c file. Those patches 
will be easy to review and will be straightforward to create. We chose 
not to do any of those unifications in this initial work yet, even if 
they were easy to do, to be able to guarantee the bit-for-bit 
equivalency of the new tree to the old trees.


When should this go upstream?
-----------------------------

We actually think that the sooner we get over with this, the better.

Once the precise method is agreed upon, the best period of the
transition is when other larger-scale changes are done typically:
right at the end of a merge window, when most of the architecture
flux has flown into the tree already (so that the transition does not
cause hickup in merge activities), but when we still have a maximum
amount of time left to fix up any effects of the unification.

This tree cannot really be carried in -mm or in other devel trees
due to its size and intrusiveness.

This is also true for the fine-grained solution, which should be done
in one go as well. We do not believe that a "Chinese 5 year transition
plan" is something useful. When we switch in one go we have two
advantages:

1) it is a single synchronization point for folks with patches against
   that code

2) it is more likely that people tackle the unification of file_32.c
   and file_64.c which are in the same source directory than the
   unification of arch/i386/..../file.c and arch/x86_64/..../file.c

As usual, comments and suggestions are welcome!

	Thomas, Ingo


