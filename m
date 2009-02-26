Return-Path: <linux-kernel-owner+w=401wt.eu-S1757031AbZBZNv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757031AbZBZNv4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 08:51:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754203AbZBZNvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 08:51:47 -0500
Received: from mtagate3.de.ibm.com ([195.212.29.152]:61913 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125AbZBZNvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 08:51:47 -0500
Message-ID: <49A69E3B.9070802@linux.vnet.ibm.com>
Date: Thu, 26 Feb 2009 14:50:51 +0100
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
       Li Wei <W.Li@Sun.COM>, Jeff Dike <jdike@addtoit.com>
Subject: [PATCH 0/4] gcov kernel support
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a resend of the gcov kernel support patchset (see further
below for an in-depth introduction). Patch base is 2.6.29-rc6.

This version fixes a few problems identified by Li Wei <W.Li@Sun.COM>:
* node->parent is always NULL, causing NULL-pointer dereference in
  remove_node()
* unsafe list traversing in reset_write() since remove_node may
  affect multiple list_heads
* . and .. in .gcda path strings are not handled correctly

Thanks to Li Wei for reporting these problems and proposing fixes!


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



