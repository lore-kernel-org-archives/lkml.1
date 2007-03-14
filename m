Return-Path: <linux-kernel-owner+w=401wt.eu-S933835AbXCNFNF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933835AbXCNFNF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 01:13:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933836AbXCNFMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 01:12:48 -0400
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:63669 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933835AbXCNFME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 01:12:04 -0400
Message-Id: <20070314050819.536207642@goodmis.org>
User-Agent: quilt/0.45-1
Date: Wed, 14 Mar 2007 01:08:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@muc.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: [PATCH 00/18] Make common x86 arch area for i386 and x86_64 - Take 2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Hopefully fixed email client to make it to the list this time]
[This series has changed by using git-diff -M]

Recently I've been doing some work that will affect both the i386 and x86_64
architectures.  So there will be common code for both, as well as code
that will be unique for the specific arch.  So I was looking into a way
to do this cleanly, and found that there is no clean way to share code
between x86_64 and i386.

What we have currently is a bunch of hacks.  Seems that people can't make
up their mind to what to do.

We have hack 1.
===============

Reference code from i386 in the x86_64 Makefiles.

Examples:

  therm_throt-y                   += ../../i386/kernel/cpu/mcheck/therm_throt.o
  bootflag-y                    += ../../i386/kernel/bootflag.o

[tabs screwed up, because the above can't be consistant on that either]


We have hack 2.
===============

Reference code from x86_64 in the i386 Makefiles.

Examples:

  k8-y                      += ../../x86_64/kernel/k8.o
  stacktrace-y            += ../../x86_64/kernel/stacktrace.o

[again the tabs too are messed up]
[--ok I'm sure I mess up the tabs too in my code--]

Now my favorite hacks!

We have hack 3.
===============

Make a sole file with just an include pointer to the i386 code.

  rostedt@bilbo:~/work/git/linus.git$ cat arch/x86_64/lib/msr-on-cpu.c
  #include "../../i386/lib/msr-on-cpu.c"
  rostedt@bilbo:~/work/git/linus.git$

We have hack 4.
===============

Make a sole file with just an include pointer to the x86_64 code.

  rostedt@bilbo:~/work/git/linus.git$ cat arch/i386/kernel/early_printk.c

  #include "../../x86_64/kernel/early_printk.c"
  rostedt@bilbo:~/work/git/linus.git$


So I spent last night hacking up something to try to make a common ground
for all code that is shared between x86_64 and i386.  I called this

   arch/x86


Seems appropriate, but I really don't care what it's called.  One thing about
this name, is that typing arch/x86<Tab> doesn't tab complete x86_64 anymore.
But if you can think of something better, I'd be happy to apply it.


So the following set of patches moves common code into the arch/x86 area
and updates the i386 and x86_64 files accordingly.  I separated the
patches into files that hold just Makefile changes, Kconfig changes, and
the actual moves of files.

The moves are now represted in its own patch, with one big rename patch,
using the git-diff -M format.

So the moves are simply renames, with the slight exception
of files that hold the speedstep-lib.h file.  This file was moved from the
arch/i386/kerne/cpu/cpufreq directory and put into the include/asm-i386
directory.  This was due to the fact that some of the moved files included
it, and some files that were not moved also included it. Instead of using
the #include "../../x86/" hack again, I just simply moved it to the global
i386 include directory.  Only the arch/x86 will use the include/asm-i386
change. But to make this change the move patches of the files that contain
this change also contain the changes to reference the change to locate this
file.


With this change of having a single repo that holds both the x86_64 files
as well as the i386 code, it becomes obvious of what files are being shared.
This way we don't have to worry about someone changing a file in either
x86_64 or i386 and having it break the other arch, because they didn't
realize it was being shared.


Note: I left out all the shared pci code.  It seems that this code is placed
special in the Makefiles for linking order or what not, and I don't want to
spend the time sorting that out without knowing if these changes are acceptible
or not.


-- Steve

PS. Sorry for the spam. I need to figure out how to tame quilt mail!


--
