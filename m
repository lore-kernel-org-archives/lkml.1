Return-Path: <linux-kernel-owner+w=401wt.eu-S964771AbXHVV4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964771AbXHVV4j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 17:56:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763063AbXHVV41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 17:56:27 -0400
Received: from www.osadl.org ([213.239.205.134]:36137 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758557AbXHVV40 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 17:56:26 -0400
Subject: [Announce] Unified x86 architecture, arch/x86 - V2
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain
Date: Wed, 22 Aug 2007 23:56:22 +0200
Message-Id: <1187819782.3316.8.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We are pleased to announce v2 of the unified arch/x86 project we are 
working on.

To recap: the core idea behind our project is simple to describe: we 
introduce a new arch/x86/ and include/asm-x86/ file hierarchy that 
includes all the existing 32-bit and 64-bit x86 code and allows the 
building of either a 32-bit (i386) kernel or a 64-bit (x86_64) kernel. 
No code is lost and almost no code is modified. We want the window 
for regressions and tree incompatibilities to be zero. (The full initial 
announcement can be found at http://lkml.org/lkml/2007/7/20/447)

The main technical request for improvement we received was the lack of a 
patch-series, and this v2 release does that, in form of a 600+ commits 
git tree:

 git://git.kernel.org/pub/scm/linux/kernel/git/tglx/linux-2.6-x86.git

One (large!) combo patch is available at:

 http://kernel.org/pub/linux/kernel/people/tglx/linux-x86.2.6.23-rc3-git-cb00e99c-combo.patch.bz2

The tree is fully bisectable and it does a finegrained, gradual 
move-over from arch/i386, arch/x86_64 into the unified arch/x86 tree, 
with a total effect of:

 1735 files changed, 167230 insertions(+), 170368 deletions(-)

On file level:

               mainline   arch/x86    delta
  Total             905        842     - 63  files

(see the full stats further below)

The tree (and the combo patch) is against commit 
cb00e99c0abd844b884c64c6b54aa3b7d345ebb1 of Linus's git tree.

More details about v2:

The patch series contains 9 steps of modifications:

1) Preparatory patches, which simplify the scripted conversion
   (Makefile cleanups, Kbuild infrastructure changes)

2) Scripted analysis of the i386 and the x86_64 source tree to
   identify source files, which exist in both trees with the same
   name. These files are checked, whether they are identical or simply
   include the corresponding source file from the other tree. If the
   files are different and do not include the other file, the file is
   renamed with a _32 resp. _64 extension and the Makefiles are fixed
   up. Makefiles in corresponding directories are renamed as well and
   a stub Makefile which selects the include of the _32 or the _64
   Makefile variants depending on the config option CONFIG_X86_32 is
   created.

3) Scripted move of the files on a per directory basis from arch/i386
   and arch/x86_64 to arch/x86. The files which are just providing an
   include of the corresponding source file in the other source tree
   are eliminated. In each step a fixup of the Makefiles is done to
   keep the tree intact.

   The only remaining files in arch/i386 and arch/x86_64 are the main
   Makefiles, Kconfig files and the defconfigs.

4) Scripted analysis of the exported headers in include/asm-i386 and
   include/asm-x86_64. This is similar to step 2). The identical
   header files are identified along with those, which just include
   the corresponding header file from the other include path. The
   header files which have the same name in both directories and which
   are different are renamed with a _32 resp. _64 extension and a stub
   header file which includes the 32 or the 64 bit version depending
   on the __i386__ define is created. The Kbuild files are updated.

5) Scripted analysis of the not exported headers in include/asm-i386
   and include/asm-x86_64. This is mostly the same as step 4). The
   stub file include switch depends on the config option
   CONFIG_X86_32.

6) Scripted move of all header files in include/asm-i386 and
   include/asm/x86_64 to include/asm-x86. Makefile references are
   fixed up automatically, the Kbuild file is unified and a patch to
   the build system is applied which fixes the header check and
   exports. After this step the header export is not longer a bi-arch
   export. All headers along with the stub files are exported in one
   go.

7) Scripted fixup of Makefile references. During the conversion cross
   tree references like "../../i386/kernel/" have been replaced by
   "../../x86/kernel". This script makes these references relative to
   the new unified source path.

8) Scripted analysis of _32 and _64 header files in include/asm-x86.
   The script replaces the defines and ifdefs, which protect from
   recursive includes, by a unified automatically generated version
   and removes white space damage from the files. After this the files
   are compared. If they are identical the newly created file is
   written instead of the _32 and _64 files. Otherwise the original
   files are left intact. After this commit a second commit is done
   which replaces the stub header file by the new unified variant and
   removes the _32 and _64 variants.

9) Semi scripted unification of _32 and _64 file variants. The script
   identified files which are not really different, e.g. white space
   damage, comment changes, small modifications. The result of the
   script is manually fixed up and patches are generated. These steps
   have been carefully verified. The unified files are header files,
   source files and Makefiles.

All 600+ bisection points have been build-tested (and a number of 
boot-tests were done too), the end-result was build and boot tested on 
x86-32 and x86-64 as well, and passes allyesconfig, allmodconfig and 
allnoconfig builds.

Some statistical information:

arch/i386          unique    files:    255
arch/x86_64        unique    files:     76
arch/x86_64        reused    files:     65 (Makefile ref to arch/i386/..)
       	           equal     files:      0
       	           included  files:      6
                   same name files:    124

include/asm-i386   unique    headers:  138
include/asm-x86_64 unique    headers:   45
include/asm-x86_64 orphaned  headers:    1 (deleted)
                   equal     headers:    7
                   included  headers:   14
                   same name headers:  254

Unified headerfiles by script:          21

Unified Makefiles (script aided)	 4
Unified header files (script aided)	59
Unified source files (script aided)	 3

               mainline   arch/x86    delta
--------------------------------------------------
Source i386         335          6     -329  files
Source x86_64       153          4     -149  files
Source x86            0        465     +465  files
Source total        488        475     - 13  files
Header i386         243          0     -243  files
Header x86_64       174          0     -174  files
Header x86            0        367     +367  files
Header total        417        367     - 50  files
--------------------------------------------------
Total               905        842     - 63  files

Source i386       97918       3420  - 94498  lines
Source x86_64     41309       2394  - 38915  lines
Source x86            0     133062  +133062  lines
Source total     139227     138876  -   351  lines
Header i386       22779          0  - 22779  lines
Header x86_64     14105          0  - 14105  lines
Header x86            0      34092  + 34092  lines
Header total      36884      34092  -  2792  lines
--------------------------------------------------
Total            176111     172968  -  3143  lines

As usual, comments and suggestions are welcome!

	Thomas, Ingo


