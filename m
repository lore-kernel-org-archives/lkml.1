Return-Path: <linux-kernel-owner+w=401wt.eu-S1756855AbYESInR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855AbYESInR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 04:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752683AbYESIm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 04:42:59 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:48365 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbYESIm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 04:42:58 -0400
Message-ID: <48313D8E.7020109@de.ibm.com>
Date: Mon, 19 May 2008 10:42:54 +0200
From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: ltp-coverage@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Peter Oberparleiter <oberparleiter@googlemail.com>
Subject: [PATCH 0/7] gcov kernel support
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is version #2 of the gcov kernel support patch set (see further
below for an in-depth explanation). Patch base is 2.6.26-rc3.

Changes are mostly based on mailing list feedback:

 * added more documentation
 * moved gcov config menu to general setup
 * renamed some structures and variables (removed _t, lowercase ctors)
 * split mod versioning change into separate patch (3)
 * split GCC_VERSION_LOWER into separate patch (2)
 * split gcov core patch into two patches (5+6) for better readability
 * absolute paths only used when CONFIG_GCOV_PROFILE is set
 * fixed compile problem with CONFIG_MODULES=n
 * fixed memory leak in gcov fs code
 * more style changes

Patch overview:

[PATCH 1/7] kernel: call constructors
[PATCH 2/7] kernel: introduce GCC_VERSION_LOWER macro
[PATCH 3/7] kbuild: delay object file renaming during module versioning
[PATCH 4/7] seq_file: add function to write binary data
[PATCH 5/7] gcov: add gcov profiling infrastructure
[PATCH 6/7] kbuild: make source and include paths absolute
[PATCH 7/7] gcov: architecture specific compile flag adjustments

===

This set of patches enables the use of GCC's coverage testing tool
gcov [1] with kernel 2.6.25. Coverage data for the running kernel is
exported via debugfs in a gcov-compatible format. To get coverage
data for a specific file, simply use gcov with the -o option:

# gcov -o /sys/kernel/debug/gcov/tmp/linux-2.6.25/kernel spinlock.c

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







