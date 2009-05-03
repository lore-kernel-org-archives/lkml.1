Return-Path: <linux-kernel-owner+w=401wt.eu-S1755557AbZECLgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557AbZECLgs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 07:36:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753786AbZECLgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 07:36:37 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:54143 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397AbZECLgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 07:36:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=T7yWFKXp9BKdLmw/oIpEcKJAdgVFLRjPlTOLVvIeF6ZuOnmmdl1p73lYlcEtlk7vuG
         5jIPjvSUSYeXzXG4/71fG5OQq8mokxixz47FI/ptAJhPopYrzpWxKdVZdIIf6csNQKA7
         tTxhLbPXTJwVDjhYIXSLIwsKPjJ7DuLccP3zo=
From: Andrea Righi <righi.andrea@gmail.com>
To: Paul Menage <menage@google.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, agk@sourceware.org,
       akpm@linux-foundation.org, axboe@kernel.dk, tytso@mit.edu,
       baramsori72@gmail.com, Carl Henrik Lunde <chlunde@ping.uio.no>,
       dave@linux.vnet.ibm.com, Divyesh Shah <dpshah@google.com>,
       eric.rannaud@gmail.com, fernando@oss.ntt.co.jp,
       Hirokazu Takahashi <taka@valinux.co.jp>, Li Zefan <lizf@cn.fujitsu.com>,
       matt@bluehost.com, dradford@bluehost.com, ngupta@google.com,
       randy.dunlap@oracle.com, roberto@unbit.it,
       Ryo Tsuruta <ryov@valinux.co.jp>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, subrata@linux.vnet.ibm.com,
       yoshikawa.takuya@oss.ntt.co.jp, Nauman Rafique <nauman@google.com>,
       fchecconi@gmail.com, paolo.valente@unimore.it, m-ikeda@ds.jp.nec.com,
       paulmck@linux.vnet.ibm.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] cgroup: io-throttle controller (v16)
Date: Sun,  3 May 2009 13:36:16 +0200
Message-Id: <1241350583-9871-1-git-send-email-righi.andrea@gmail.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Objective
~~~~~~~~~
The objective of the io-throttle controller is to improve IO performance
predictability of different cgroups that share the same block devices.

State of the art (quick overview)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
A recent work made by Vivek propose a weighted BW solution introducing
fair queuing support in the elevator layer and modifying the existent IO
schedulers to use that functionality
(https://lists.linux-foundation.org/pipermail/containers/2009-March/016129.html).

For the fair queuing part Vivek's IO controller makes use of the BFQ
code as posted by Paolo and Fabio (http://lkml.org/lkml/2008/11/11/148).

The dm-ioband controller by the valinux guys is also proposing a
proportional ticket-based solution fully implemented at the device
mapper level (http://people.valinux.co.jp/~ryov/dm-ioband/).

The bio-cgroup patch (http://people.valinux.co.jp/~ryov/bio-cgroup/) is
a BIO tracking mechanism for cgroups, implemented in the cgroup memory
subsystem. It is maintained by Ryo and it allows dm-ioband to track
writeback requests issued by kernel threads (pdflush).

Another work by Satoshi implements the cgroup awareness in CFQ, mapping
per-cgroup priority to CFQ IO priorities and this also provide only the
proportional BW support (http://lwn.net/Articles/306772/).

Proposed solution
~~~~~~~~~~~~~~~~~
Respect to other proposed solutions the approach used by this controller
is to explicitly choke applications' requests that directly or
indirectly generate IO activity in the system (this controller addresses
both synchronous IO and writeback/buffered IO).

The bandwidth and iops limiting method has the advantage of improving
the performance predictability at the cost of reducing, in general, the
overall performance of the system in terms of throughput.

IO throttling and accounting is performed during the submission of IO
requests and it is independent of the particular IO scheduler.

Detailed informations about design, goal and usage are described in the
documentation (see [PATCH 1/7]).

What's new
~~~~~~~~~~
The most important change in this patchset (v16) is the IO throttling
water mark.

A new file blockio.watermark is now available in the cgroupfs. This file
allows to define a water mark in percentage of the consumed disk I/O
bandwidth to start/stop I/O throttling: throttling will begin only when
the percentage of the consumed disk bandwidth hits the watermark. If
watermark is 0 (default) throttling is applied immediately and the BW
limits are considered hard limits (that is in practice the old
io-throttle behaviour).

This allows to always use the whole physical disk bandwidth and maintain
at the same time a different level of service according to the cgroup
bandwidth limits.

In practice, with the throttling water mark we can decide to not
throttle IO requests if the disk is not congested enough.

Implementation
~~~~~~~~~~~~~~
Patchset against latest Linus' git:

  [PATCH 0/7] cgroup: block device IO controller (v16)
  [PATCH 1/7] io-throttle documentation
  [PATCH 2/7] res_counter: introduce ratelimiting attributes
  [PATCH 3/7] page_cgroup: provide a generic page tracking infrastructure
  [PATCH 4/7] io-throttle controller infrastructure
  [PATCH 5/7] kiothrottled: throttle buffered (writeback) IO
  [PATCH 6/7] io-throttle instrumentation
  [PATCH 7/7] io-throttle: export per-task statistics to userspace

The v16 all-in-one patch, along with the previous versions, can be found at:
http://download.systemimager.org/~arighi/linux/patches/io-throttle/

Changelog (v15 -> v16)
~~~~~~~~~~~~~~~~~~~~~~
* added a water mark in percentage of the consumed disk bandwidth to
  start/stop IO throttling
* reduce the size of res_counter for ratelimited resources
* fix a bug for O_DIRECT reads that are correctly accounted but
  incorrectly throttled

Experimental results
~~~~~~~~~~~~~~~~~~~~
Following some results to compare few different BW limiting
configurations and the new throttling water mark feature.

The testcase consists of two simple parallel write streams (dd), one
running in cgrp1 and the other in cgrp2; writeback-io and direct-io
characterize the type of IO workload (buffered in the page cache or with
O_DIRECT).

In addition to the IO bandwidth as seen by the single applications we
also measure the consumed overall disk bandwidth.

The following cases have been tested:

 1) unlimited-bw (writeback-io)
 2) unlimited-bw (direct-io)
 3) cgrp1=4MB/s, cgrp2=2MB/s (writeback-io)
 4) cgrp1=4MB/s, cgrp2=2MB/s (direct-io)
 5) cgrp1=4MB/s, cgrp2=2MB/s, watermark=90% (writeback-io)
 6) cgrp1=4MB/s, cgrp2=2MB/s, watermark=90% (direct-io)
 7) cgrp1=4MB/s, cgrp2=2MB/s, watermark=100% (writeback-io)
 8) cgrp1=4MB/s, cgrp2=2MB/s, watermark=100% (direct-io)

Experimental results:

 1) unlimited-bw (writeback-io)

 $ dd if=/dev/zero bs=1M count=256 of=cgrp1
 256+0 records in
 256+0 records out
 268435456 bytes (268 MB) copied, 13.6276 s, 19.7 MB/s

 $ dd if=/dev/zero bs=1M count=256 of=cgrp2
 256+0 records in
 256+0 records out
 268435456 bytes (268 MB) copied, 12.7431 s, 21.1 MB/s

 --dsk/sda--
  read  writ
    0    22M
    0    19M
    0    20M
    0    14M
    0    17M
    0    16M
    0    16M
    0    16M
    0    18M
 ...

 2) unlimited-bw (direct-io)

 $ dd if=/dev/zero bs=1M count=256 of=cgrp1 oflag=direct
 256+0 records in
 256+0 records out
 268435456 bytes (268 MB) copied, 22.3939 s, 12.0 MB/s

 $ dd if=/dev/zero bs=1M count=256 of=cgrp2 oflag=direct
 256+0 records in
 256+0 records out
 268435456 bytes (268 MB) copied, 22.9544 s, 11.7 MB/s

 --dsk/sda--
  read  writ
    0    23M
    0    18M
    0    21M
    0    21M
    0    14M
    0    13M
    0    15M
    0    19M
    0    23M
    0    22M
 ...

 3) cgrp1=4MB/s, cgrp2=2MB/s (writeback-io)

 $ dd if=/dev/zero bs=1M count=256 of=cgrp1
 256+0 records in
 256+0 records out
 268435456 bytes (268 MB) copied, 42.4277 s, 6.3 MB/s

 $ dd if=/dev/zero bs=1M count=256 of=cgrp2
 256+0 records in
 256+0 records out
 268435456 bytes (268 MB) copied, 111.628 s, 2.4 MB/s

 --dsk/sda--
  read  writ
    0  6144k
    0  6176k
    0  6172k
    0  6172k
    0  6176k
    0  6180k
    0  6176k
    0  6176k
    0  6180k
    0  6172k
 ...

 4) cgrp1=4MB/s, cgrp2=2MB/s (direct-io)

 $ dd if=/dev/zero bs=1M count=256 of=cgrp1 oflag=direct
 256+0 records in
 256+0 records out
 268435456 bytes (268 MB) copied, 64.2583 s, 4.2 MB/s

 $ dd if=/dev/zero bs=1M count=256 of=cgrp2 oflag=direct
 256+0 records in
 256+0 records out
 268435456 bytes (268 MB) copied, 128.28 s, 2.1 MB/s

 --dsk/sda--
  read  writ
    0  6136k
    0  6108k
    0  6108k
    0  6176k
    0  6104k
    0  6016k
    0  6144k
    0  6272k
    0  6016k
    0  6148k
 ...

 5) cgrp1=4MB/s, cgrp2=2MB/s, watermark=90% (writeback-io)

 $ dd if=/dev/zero bs=1M count=256 of=cgrp1
 256+0 records in
 256+0 records out
 268435456 bytes (268 MB) copied, 8.39187 s, 32.0 MB/s

 $ dd if=/dev/zero bs=1M count=256 of=cgrp2
 256+0 records in
 256+0 records out
 268435456 bytes (268 MB) copied, 12.5449 s, 21.4 MB/s

 --dsk/sda--
  read  writ
    0    21M
    0    18M
    0    19M
    0    18M
    0    15M
    0    12M
    0    15M
    0    15M
    0    19M
    0    17M
 ...

 6) cgrp1=4MB/s, cgrp2=2MB/s, watermark=90% (direct-io)

 $ dd if=/dev/zero bs=1M count=256 of=cgrp1 oflag=direct
 256+0 records in
 256+0 records out
 268435456 bytes (268 MB) copied, 19.1814 s, 14.0 MB/s

 $ dd if=/dev/zero bs=1M count=256 of=cgrp2 oflag=direct
 256+0 records in
 256+0 records out
 268435456 bytes (268 MB) copied, 24.35 s, 11.0 MB/s

 --dsk/sda--
  read  writ
    0    18M
    0    20M
    0    12M
    0    14M
    0    19M
    0    20M
    0    24M
    0    22M
    0    23M
    0    24M
 ...

 7) cgrp1=4MB/s, cgrp2=2MB/s, watermark=100% (writeback-io)

 $ dd if=/dev/zero bs=1M count=256 of=cgrp1
 256+0 records in
 256+0 records out
 268435456 bytes (268 MB) copied, 9.51788 s, 28.2 MB/s

 $ dd if=/dev/zero bs=1M count=256 of=cgrp2
 256+0 records in
 256+0 records out
 268435456 bytes (268 MB) copied, 11.4759 s, 23.4 MB/s

 --dsk/sda--
  read  writ
    0    21M
    0    19M
    0    18M
    0    16M
    0    15M
    0    13M
    0    15M
    0    13M
    0    21M
    0    21M
 ...

 8) cgrp1=4MB/s, cgrp2=2MB/s, watermark=100% (direct-io)

 $ dd if=/dev/zero bs=1M count=256 of=cgrp1 oflag=direct
 256+0 records in
 256+0 records out
 268435456 bytes (268 MB) copied, 18.7106 s, 14.3 MB/s

 $ dd if=/dev/zero bs=1M count=256 of=cgrp2 oflag=direct
 256+0 records in
 256+0 records out
 268435456 bytes (268 MB) copied, 23.0093 s, 11.7 MB/s

 --dsk/sda--
  read  writ
    0    18M
    0    18M
    0    23M
    0    18M
    0    14M
    0    11M
    0    16M
    0    21M
    0    25M
    0    20M
 ...

The results above show the effectiveness of the water mark throttling.
Water mark throttling allows to use the whole physical disk bandwidth
and maintain at the same time a different level of service according to
the cgroup bandwidth limits defined by the user.

If we want to provide a best-effort quality of service without wasting
the available IO bandwidth with static partitioning, dynamic bandwidth
partitioning can be a profitable solution.

OTOH absolute limiting rules do not fully exploit the whole physical BW,
but offer an immediate action on policy enforcement, that can be useful
in environments where certain critical/low-latency applications must
respect strict timing constraints.

The io-throttle controller now provides both limiting solutions.

Overall diffstat
~~~~~~~~~~~~~~~~
 Documentation/cgroups/io-throttle.txt |  443 ++++++++++++++++
 block/Makefile                        |    1 +
 block/blk-core.c                      |    8 +
 block/blk-io-throttle.c               |  928 +++++++++++++++++++++++++++++++++
 block/kiothrottled.c                  |  341 ++++++++++++
 fs/aio.c                              |   12 +
 fs/block_dev.c                        |    3 +
 fs/buffer.c                           |    2 +
 fs/direct-io.c                        |    3 +
 fs/proc/base.c                        |   18 +
 include/linux/blk-io-throttle.h       |  168 ++++++
 include/linux/cgroup.h                |    1 +
 include/linux/cgroup_subsys.h         |    6 +
 include/linux/fs.h                    |    4 +
 include/linux/memcontrol.h            |    6 +
 include/linux/mmzone.h                |    4 +-
 include/linux/page_cgroup.h           |   33 ++-
 include/linux/res_counter.h           |   81 +++-
 include/linux/sched.h                 |    8 +
 init/Kconfig                          |   16 +
 kernel/cgroup.c                       |    9 +
 kernel/fork.c                         |    8 +
 kernel/res_counter.c                  |   62 +++
 mm/Makefile                           |    3 +-
 mm/bounce.c                           |    2 +
 mm/filemap.c                          |    2 +
 mm/memcontrol.c                       |    6 +
 mm/page-writeback.c                   |   13 +
 mm/page_cgroup.c                      |   96 +++-
 mm/readahead.c                        |    3 +
 30 files changed, 2255 insertions(+), 35 deletions(-)

-Andrea
