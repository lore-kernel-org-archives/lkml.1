Return-Path: <linux-kernel-owner+w=401wt.eu-S1753851AbZIVE6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851AbZIVE6G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 00:58:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753574AbZIVE6D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 00:58:03 -0400
Received: from mail-yw0-f194.google.com ([209.85.211.194]:53730 "EHLO
	mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbZIVE6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 00:58:02 -0400
From: Nitin Gupta <ngupta@vflare.org>
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Marcin Slusarz <marcin.slusarz@gmail.com>, Ed Tomlinson <edt@aei.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, linux-mm-cc <linux-mm-cc@laptop.org>
Subject: [PATCH 0/3] compcache: in-memory compressed swapping v4
Date: Tue, 22 Sep 2009 10:26:51 +0530
Message-Id: <1253595414-2855-1-git-send-email-ngupta@vflare.org>
X-Mailer: git-send-email 1.6.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Project home: http://compcache.googlecode.com/

* Changelog: v4 vs v3
 - Remove swap notify callback and related bits. This make ramzswap
   contained entirely within drivers/staging/.
 - Above changes can cause ramzswap to work poorly since it cannot
   cleanup stale data from memory unless overwritten by some other data.
   (this will be fixed when swap notifer patches are accepted)
 - Some cleanups suggested by Marcin.

* Changelog: v3 vs v2
 - All cleanups as suggested by Pekka.
 - Move to staging (drivers/block/ramzswap/ -> drivers/staging/ramzswap/).
 - Remove swap discard hooks -- swap notify support makes these redundant.
 - Unify duplicate code between init_device() fail path and reset_device().
 - Fix zero-page accounting.
 - Do not accept backing swap with bad pages.

* Changelog: v2 vs initial revision
 - Use 'struct page' instead of 32-bit PFNs in ramzswap driver and xvmalloc.
   This is to make these 64-bit safe.
 - xvmalloc is no longer a separate module and does not export any symbols.
   Its compiled directly with ramzswap block driver. This is to avoid any
   last bit of confusion with any other allocator.
 - set_swap_free_notify() now accepts block_device as parameter instead of
   swp_entry_t (interface cleanup).
 - Fix: Make sure ramzswap disksize matches usable pages in backing swap file.
   This caused initialization error in case backing swap file had intra-page
   fragmentation.

It creates RAM based block devices which can be used (only) as swap disks.
Pages swapped to these disks are compressed and stored in memory itself. This
is a big win over swapping to slow hard-disk which are typically used as swap
disk. For flash, these suffer from wear-leveling issues when used as swap disk
- so again its helpful. For swapless systems, it allows more apps to run for a
given amount of memory.

It can create multiple ramzswap devices (/dev/ramzswapX, X = 0, 1, 2, ...).
Each of these devices can have separate backing swap (file or disk partition)
which is used when incompressible page is found or memory limit for device is
reached.

A separate userspace utility called rzscontrol is used to manage individual
ramzswap devices.

* Testing notes

Tested on x86, x64, ARM
ARM:
 - Cortex-A8 (Beagleboard)
 - ARM11 (Android G1)
 - OMAP2420 (Nokia N810)

* Performance

All performance numbers/plots can be found at:
http://code.google.com/p/compcache/wiki/Performance

Below is a summary of this data:

General:
 - Swap R/W times are reduced from milliseconds (in case of hard disks)
down to microseconds.

Positive cases:
 - Shows 33% improvement in 'scan' benchmark which allocates given amount
of memory and linearly reads/writes to this region. This benchmark also
exposes bottlenecks in ramzswap code (global mutex) due to which this gain
is so small.
 - On Linux thin clients, it gives the effect of nearly doubling the amount of
memory.

Negative cases:
Any workload that has active working set w.r.t. filesystem cache that is
nearly equal to amount of RAM while has minimal anonymous memory requirement,
is expected to suffer maximum loss in performance with ramzswap enabled.

Iozone filesystem benchmark can simulate exactly this kind of workload.
As expected, this test shows performance loss of ~25% with ramzswap.

 drivers/staging/Kconfig                   |    2 +
 drivers/staging/Makefile                  |    1 +
 drivers/staging/ramzswap/Kconfig          |   21 +
 drivers/staging/ramzswap/Makefile         |    3 +
 drivers/staging/ramzswap/ramzswap.txt     |   51 +
 drivers/staging/ramzswap/ramzswap_drv.c   | 1462 +++++++++++++++++++++++++++++
 drivers/staging/ramzswap/ramzswap_drv.h   |  173 ++++
 drivers/staging/ramzswap/ramzswap_ioctl.h |   50 +
 drivers/staging/ramzswap/xvmalloc.c       |  533 +++++++++++
 drivers/staging/ramzswap/xvmalloc.h       |   30 +
 drivers/staging/ramzswap/xvmalloc_int.h   |   86 ++
 include/linux/swap.h                      |    5 +
 mm/swapfile.c                             |   34 +
 13 files changed, 2451 insertions(+), 0 deletions(-)
