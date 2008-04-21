Return-Path: <linux-kernel-owner+w=401wt.eu-S1758065AbYDUMeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758065AbYDUMeU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 08:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755411AbYDUMeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 08:34:09 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:63013 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755288AbYDUMeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 08:34:08 -0400
Message-ID: <480C89BD.8080909@de.ibm.com>
Date: Mon, 21 Apr 2008 14:34:05 +0200
From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: ltp-list@lists.sourceforge.net, ltp-coverage@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC PATCH 0/8] gcov kernel support
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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


Patch overview:

[patch 1/8] kernel: call constructors
[patch 2/8] kbuild: let addtree result in absolute paths only
[patch 3/8] kbuild: convert include and source paths
[patch 4/8] module: add MODULE_STATE_GOING notifier call
[patch 5/8] module: add function to map address to containing module
[patch 6/8] seq_file: add function to write binary data
[patch 7/8] gcov: add gcov profiling infrastructure
[patch 8/8] gcov: architecture specific compile flag adjustments

Patches 1-6 introduce/change functionality required for gcov's
profiling mechanism to work. Patch 7 implements the actual gcov
support and debugfs interface. Patch 8 is required for architecture
specific adjustments.


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




