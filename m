Return-Path: <linux-kernel-owner+w=401wt.eu-S1755160AbYKTLao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160AbYKTLao (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 06:30:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754078AbYKTLae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 06:30:34 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:47317 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753613AbYKTLad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 06:30:33 -0500
Subject: [PATCH 2.6.28-rc5 00/11] Kernel memory leak detector (updated)
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Thu, 20 Nov 2008 11:30:28 +0000
Message-ID: <20081120112903.16607.68902.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.14.3.286.g8983
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Nov 2008 11:30:28.0759 (UTC) FILETIME=[63C4B270:01C94B03]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kmemleak (visible) activity has been pretty quite for the past
year. I've actually been working on implementing some of the comments
received, adding support for slob and slub allocators and trying it on
various kernel versions. I found myself spending significant amount of
time on identifying false positives caused by pointer
aliasing. Because of that, I decided to track incoming pointers to any
location inside an allocated block rather than just the aliases,
leading to cleaner code and without many annotations for false
positives.

Kmemleak can also be found in a branh on this git tree:

git://linux-arm.org/linux-2.6.git kmemleak

The main changes (for those who remember the original features):

- it now uses a priority search tree to make it easier for looking up
  intervals rather than just fixed values (the initial implementation
  was with radix tree and changed to hash array because of
  kmem_cache_alloc calls in the former)
- internal memory allocator to avoid recursive calls into
  kmemleak. This is a simple lock-free, per-cpu allocator using
  pages. The number of pages allocated is bounded, though there could
  be (very unlikely) situations on SMP systems where page occupation
  isn't optimal
- support for all three memory allocators - slab, slob and slub
- finer-grained locking - there is no global lock held during memory
  scanning
- more information reported for leaked objects - current task's
  command line and pid, jiffies and the stack trace

Things still to be done:

- kernel thread to scan and report leaked objects periodically
  (currently done only when reading the /sys/kernel/debug/memleak
  file)
- run-time and boot-time configuration like task stacks scanning,
  disabling kmemleak, enabling/disabling the automatic scanning

An improvement in scanning time and false negatives would be to only
scan locations containing outgoing pointers. I did some tests (not
finished yet) to automatically ignore, in subsequent scans, areas of
memory that were found not to contain pointer-like values (or NULL)
during a first scan.

Thanks for your comments.


Catalin Marinas (11):
      kmemleak: Add the corresponding MAINTAINERS entry
      kmemleak: Simple testing module for kmemleak
      kmemleak: Keep the __init functions after initialization
      kmemleak: Enable the building of the memory leak detector
      kmemleak: Remove some of the kmemleak false positives
      kmemleak: Add support for ARM
      kmemleak: Add support for i386
      kmemleak: Add modules support
      kmemleak: Add the memory allocation/freeing hooks
      kmemleak: Add documentation on the memory leak detector
      kmemleak: Add the base support


 Documentation/kmemleak.txt       |  125 +++++
 MAINTAINERS                      |    6 
 arch/arm/kernel/vmlinux.lds.S    |    2 
 arch/x86/kernel/vmlinux_32.lds.S |    1 
 drivers/char/vt.c                |    5 
 include/linux/init.h             |    6 
 include/linux/memleak.h          |   60 ++
 include/linux/percpu.h           |    5 
 init/main.c                      |    4 
 kernel/module.c                  |   50 ++
 lib/Kconfig.debug                |   46 ++
 mm/Makefile                      |    2 
 mm/memleak-test.c                |  102 ++++
 mm/memleak.c                     | 1012 ++++++++++++++++++++++++++++++++++++++
 mm/page_alloc.c                  |    3 
 mm/slab.c                        |    9 
 mm/slob.c                        |   15 -
 mm/slub.c                        |    3 
 mm/vmalloc.c                     |   25 +
 19 files changed, 1473 insertions(+), 8 deletions(-)
 create mode 100644 Documentation/kmemleak.txt
 create mode 100644 include/linux/memleak.h
 create mode 100644 mm/memleak-test.c
 create mode 100644 mm/memleak.c

-- 
Catalin
