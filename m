Return-Path: <linux-kernel-owner+w=401wt.eu-S1756840AbZDRVhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840AbZDRVhb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 17:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752388AbZDRVhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 17:37:22 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:55338 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655AbZDRVhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 17:37:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=kvDqargOtUjRG9rADHEA7eOC7/xaGeJkzt680Owkus9lk9epfBjLl2n4bfl9OooAFj
         hj9FfPvxXyf8Psa+KP5X4qin85NmCHKpUeTIJl7K3Cwnw1z4t733NxDZoTadTPFGtxnQ
         RYV2MIMkGr3DLhyXGoaZbammX4YfWhh4c9ais=
From: Andrea Righi <righi.andrea@gmail.com>
To: Paul Menage <menage@google.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, agk@sourceware.org,
       akpm@linux-foundation.org, axboe@kernel.dk, baramsori72@gmail.com,
       Carl Henrik Lunde <chlunde@ping.uio.no>, dave@linux.vnet.ibm.com,
       Divyesh Shah <dpshah@google.com>, eric.rannaud@gmail.com,
       fernando@oss.ntt.co.jp, Hirokazu Takahashi <taka@valinux.co.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, matt@bluehost.com,
       dradford@bluehost.com, ngupta@google.com, randy.dunlap@oracle.com,
       roberto@unbit.it, Ryo Tsuruta <ryov@valinux.co.jp>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, subrata@linux.vnet.ibm.com,
       yoshikawa.takuya@oss.ntt.co.jp, Nauman Rafique <nauman@google.com>,
       fchecconi@gmail.com, paolo.valente@unimore.it,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] cgroup: io-throttle controller (v14)
Date: Sat, 18 Apr 2009 23:37:09 +0200
Message-Id: <1240090636-898-1-git-send-email-righi.andrea@gmail.com>
X-Mailer: git-send-email 1.5.6.3
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

Please correct me or integrate if I missed someone or something. :)

Proposed solution
~~~~~~~~~~~~~~~~~
Respect to other priority/weight-based solutions the approach used by
this controller is to explicitly choke applications' requests that
directly or indirectly generate IO activity in the system (this
controller addresses both synchronous IO and writeback/buffered IO).

The bandwidth and iops limiting method has the advantage of improving
the performance predictability at the cost of reducing, in general, the
overall performance of the system in terms of throughput.

IO throttling and accounting is performed during the submission of IO
requests and it is independent of the particular IO scheduler.

Detailed informations about design, goal and usage are described in the
documentation (see [PATCH 1/7]).

Implementation
~~~~~~~~~~~~~~
Patchset against latest Linus' git:

  [PATCH 0/7] cgroup: block device IO controller (v14)
  [PATCH 1/7] io-throttle documentation
  [PATCH 2/7] res_counter: introduce ratelimiting attributes
  [PATCH 3/7] page_cgroup: provide a generic page tracking infrastructure
  [PATCH 4/7] io-throttle controller infrastructure
  [PATCH 5/7] kiothrottled: throttle buffered (writeback) IO
  [PATCH 6/7] io-throttle instrumentation
  [PATCH 7/7] export per-task io-throttle statistics to userspace

The v14 all-in-one patch, along with the previous versions, can be found at:
http://download.systemimager.org/~arighi/linux/patches/io-throttle/

What's new
~~~~~~~~~~
In this new version I've embedded the bio-cgroup code inside
io-throttle, providing the page_cgroup page tracking infrastructure.

This completely removes the complexity and the overhead of associating
multiple IO controllers (bio-cgroup groups and io-throttle groups) from
userspace, preserving the same tracking and throttling functionalities
for writeback IO. And it is also possibel to bind other cgroup
subsystems with io-throttle.

I've removed the tracking of IO generated by anonymous pages (swap), to
reduce the overhead of the page tracking functionality (and probably is
not a good idea to delay IO requests that come from swap-in/swap-out
operations).

I've also removed the ext3 specific patch to tag journal IO with
BIO_RW_META to never throttle such IO requests.

As suggested by Ted and Jens we need a more specific solution, where
filesystems inform the IO subsystem which IO requests come from tasks
that are holding filesystem exclusive resources (journal IO, metadata,
etc.). Then, the IO subsystem (both the IO scheduler and the IO
controller) will be able to dispatched those "special" requests at the
highest priority to avoid the classic priority inversion problems.

Changelog (v13 -> v14)
~~~~~~~~~~~~~~~~~~~~~~
* implemented the bio-cgroup functionality as pure infrastructure for page
  tracking capability
* removed the tracking and throttling of IO generated by anonymous pages (swap)
* updated documentation

Overall diffstat
~~~~~~~~~~~~~~~~
 Documentation/cgroups/io-throttle.txt |  417 +++++++++++++++++
 block/Makefile                        |    1 +
 block/blk-core.c                      |    8 +
 block/blk-io-throttle.c               |  822 +++++++++++++++++++++++++++++++++
 block/kiothrottled.c                  |  341 ++++++++++++++
 fs/aio.c                              |   12 +
 fs/buffer.c                           |    2 +
 fs/proc/base.c                        |   18 +
 include/linux/blk-io-throttle.h       |  144 ++++++
 include/linux/cgroup_subsys.h         |    6 +
 include/linux/memcontrol.h            |    6 +
 include/linux/mmzone.h                |    4 +-
 include/linux/page_cgroup.h           |   33 ++-
 include/linux/res_counter.h           |   69 ++-
 include/linux/sched.h                 |    7 +
 init/Kconfig                          |   16 +
 kernel/fork.c                         |    7 +
 kernel/res_counter.c                  |   72 +++
 mm/Makefile                           |    3 +-
 mm/bounce.c                           |    2 +
 mm/filemap.c                          |    2 +
 mm/memcontrol.c                       |    6 +
 mm/page-writeback.c                   |    2 +
 mm/page_cgroup.c                      |   95 ++++-
 mm/readahead.c                        |    3 +
 25 files changed, 2065 insertions(+), 33 deletions(-)

-Andrea
