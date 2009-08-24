Return-Path: <linux-kernel-owner+w=401wt.eu-S1751440AbZHXEiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751440AbZHXEiK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 00:38:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751352AbZHXEiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 00:38:09 -0400
Received: from mail-pz0-f194.google.com ([209.85.222.194]:49708 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbZHXEiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 00:38:09 -0400
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
To: akpm@linux-foundation.org
Subject: [PATCH 0/4] compcache: compressed in-memory swapping
Date: Mon, 24 Aug 2009 10:07:33 +0530
User-Agent: KMail/1.11.4 (Linux/2.6.29.6-217.2.8.fc11.x86_64; KDE/4.2.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-mm-cc@laptop.org
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200908241007.33844.ngupta@vflare.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Project home: http://compcache.googlecode.com/

It creates RAM based block devices which can be used (only) as swap disks.
Pages swapped to this device are compressed and stored in memory itself. This
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
exposes *bottlenecks* in ramzswap code (global mutex) due to which this gain
is so small.
 - On Linux thin clients, it gives the effect of nearly doubling the amount of
memory.

Negative cases:
Any workload that has active working set w.r.t. filesystem cache that is
nearly equal to amount of RAM while has minimal anonymous memory requirement,
is expected to suffer maximum loss in performance with ramzswap enabled.

Iozone filesystem benchmark can simulate exactly this kind of workload.
As expected, this test shows performance loss of ~25% with ramzswap.


(Sorry for long patch[2/4] but its now very hard to split it up).

 Documentation/blockdev/00-INDEX       |    2 +
 Documentation/blockdev/ramzswap.txt   |   52 ++
 drivers/block/Kconfig                 |   22 +
 drivers/block/Makefile                |    1 +
 drivers/block/ramzswap/Makefile       |    2 +
 drivers/block/ramzswap/ramzswap.c     | 1511 +++++++++++++++++++++++++++++++++
 drivers/block/ramzswap/ramzswap.h     |  182 ++++
 drivers/block/ramzswap/xvmalloc.c     |  556 ++++++++++++
 drivers/block/ramzswap/xvmalloc.h     |   30 +
 drivers/block/ramzswap/xvmalloc_int.h |   86 ++
 include/linux/ramzswap_ioctl.h        |   51 ++
 include/linux/swap.h                  |    5 +
 mm/swapfile.c                         |   33 +
 13 files changed, 2533 insertions(+), 0 deletions(-)
