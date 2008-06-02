Return-Path: <linux-kernel-owner+w=401wt.eu-S1760834AbYFBNfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760834AbYFBNfY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 09:35:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753940AbYFBNfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 09:35:04 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:55978 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759323AbYFBNfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 09:35:03 -0400
Message-ID: <4843F6BF.9070409@de.ibm.com>
Date: Mon, 02 Jun 2008 15:33:51 +0200
From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: ltp-coverage@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Peter Oberparleiter <oberparleiter@googlemail.com>
Subject: [PATCH 0/6] gcov kernel support
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is version #3 of the gcov kernel support patch set (see further
below for an in-depth explanation). Patch base is 2.6.26-rc4.
Please replace the previous gcov patch set with this one.

Changes based on mailing list feedback:

 * removed patch "kbuild: make source and include paths absolute".
   Replaced by new approach (patch 5) which creates symbolic links
   in the build directory instead.
 * updated docs to match new approach
 * removed patch "kbuild: delay object file renaming during module
   versioning". No longer required.
 * gcov core code no longer creates symbolic links in debugfs
 * updated patch "gcov: architecture specific compile flag adjustments".
   Contains changes for powerpc.

Patch overview:

[PATCH 1/6] kernel: call constructors
[PATCH 2/6] kernel: introduce GCC_VERSION_LOWER macro
[PATCH 3/6] seq_file: add function to write binary data
[PATCH 4/6] gcov: add gcov profiling infrastructure
[PATCH 5/6] gcov: create links to .gcda files in build directory
[PATCH 6/6] gcov: architecture specific compile flag adjustments

===

gcov profiling kernel support enables the use of GCC's coverage testing
tool gcov [1] with the Linux kernel. Coverage data of a running kernel
is exported in gcov-compatible format via the "gcov "debugfs directory.

Example:

To get coverage data for file base.c in directory drivers/base, simply
change to the kernel build directory and run gcov with the -o option
(assumptions: kernel was built in /tmp/linux and debugfs is mounted at
/sys/kernel/debug):

# cd /tmp/linux
# gcov -o drivers/base/ bus.c

This will create source code files annotated with execution counts
in the current directory. In addition, graphical gcov front-ends such
as lcov [2] can be used to automate the process of collecting data
for the entire kernel and provide coverage overviews in HTML format.

Possible uses:

* debugging (has this line been executed at all?)
* test improvement (how do I change my test to cover these lines?)
* minimizing kernel configurations (do I need this option if the
  associated code is never executed?)


Known issues:

* some architecture specific problems: the patch has been tested
  successfully on s390 and i386. Known problems exist on x86_64 and
  arm (to be investigated)
* GCC's profiling mechanism together with optimization sometimes
  produces skewed data (see [1])
* GCC's profiling code assumes single-threaded execution
* gcov assumes that a program has finished when coverage data is
  analyzed

Despite these issues, the data which can be obtained has been proven
to be sufficiently accurate for most practical uses.


History:

Hubertus Franke <frankeh@us.ibm.com> wrote the first version of this
patch around 2002. Since then it has been adapted to new versions of
the kernel and GCC with contributions by several people (see file
kernel/gcov/fs.c, write me if I missed anyone). Due to regular
requests, I rewrote the gcov-kernel patch from scratch so that it
would (hopefully) be fit for inclusion into the upstream kernel.

--
[1] http://gcc.gnu.org/onlinedocs/gcc/Gcov.html
[2] http://ltp.sourceforge.net/coverage/lcov.php




