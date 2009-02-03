Return-Path: <linux-kernel-owner+w=401wt.eu-S1754684AbZBCMr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684AbZBCMr4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 07:47:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752951AbZBCMrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 07:47:36 -0500
Received: from mtagate2.de.ibm.com ([195.212.17.162]:51309 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbZBCMrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 07:47:35 -0500
Message-ID: <49883C93.3010001@linux.vnet.ibm.com>
Date: Tue, 03 Feb 2009 13:46:11 +0100
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
       Jeff Dike <jdike@addtoit.com>
Subject: [PATCH 0/4] gcov kernel support
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a resend of the gcov kernel support patchset (see further
below for an in-depth introduction). Patch base is 2.6.29-rc3.

A previous attempt to get this patchset included into the mainline
kernel stalled when a number of issues remained unfixed. This
version addresses all known issues:

User mode Linux conflicts in the constructor mechanism were resolved.
The current approach does no longer affect linking of .ctors sections
on UML.

Selecting option "Profile entire kernel" has triggered linker,
runtime or tool chain issues on some platforms (e.g. ppc, x86_64)
while it worked on others (s390, x86_32). To prevent breaking
"make allyesconfig" type tests, this option is now restricted to
architectures for which it has been tested and found working.
New architectures can be added by follow-on patches once positive
test feedback is available.


Patchset overview:

[PATCH 1/4] kernel: constructor support
[PATCH 2/4] seq_file: add function to write binary data
[PATCH 3/4] gcov: add gcov profiling infrastructure
[PATCH 4/4] gcov: enable GCOV_PROFILE_ALL for x86_64

===

Introduction:

This patch set enables the use of GCC's coverage testing tool gcov [1]
with the Linux kernel. Coverage data of a running kernel is exported
in gcov-compatible format via the "gcov" debugfs directory. To get
coverage data for a specific file, change to the kernel build
directory and use gcov with the -o option as follows (requires root):

# cd /tmp/linux-out
# gcov -o /sys/kernel/debug/gcov/tmp/linux-out/kernel spinlock.c

This will create source code files annotated with execution counts
in the current directory. In addition, graphical gcov front-ends such
as lcov [2] can be used to automate the process of collecting data
for the entire kernel and provide coverage overviews in HTML format.


Known issues:

* some architecture specific problems: the patch has been tested
  successfully on s390 and x86, the use of gcov profiling flags
  for the entire kernel needs to be tested per architecture before
  it can be enabled
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



