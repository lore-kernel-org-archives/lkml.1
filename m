Return-Path: <linux-kernel-owner+w=401wt.eu-S1753975AbZK3DE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbZK3DE3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 22:04:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753590AbZK3DEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 22:04:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20962 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753466AbZK3DAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 22:00:46 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, vgoyal@redhat.com,
       czoccolo@gmail.com, Alan.Brunelle@hp.com
Subject: Block IO Controller V4
Date: Sun, 29 Nov 2009 21:59:07 -0500
Message-Id: <1259549968-10369-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

This is V4 of the Block IO controller patches on top of "for-2.6.33" branch
of block tree.

A consolidated patch can be found here:

http://people.redhat.com/vgoyal/io-controller/blkio-controller/blkio-controller-v4.patch


Changed from V3:
- Removed group_idle tunable and introduced group_isolation tunable. Thanks
  to corrodo for the idea and thanks to Alan for testing and reporting
  performance issues with random reads.

  Generally if random reads are put in separate groups, these groups get
  exclusive access to disk and we drive lower queue depth and performance
  drops. So by default now random queues are moved to root group hence
  performance drop due to idling on each group's sync-noidle tree is less. 

  If one wants stronger isolation/fairness for random IO, he needs to set
  group_isolation=1 and that will also result in performance drop if group
  does not have enough IO going on to keep disk busy.

- Got rid of wait_busy() function in select_queue(). Now I increase the
  slice length of a queue by one slice_idle period to give it a chance
  to get busy before it gets expired so that group does not lose share. This
  has simplified the logic a bit. Thanks again to corrodo for the idea.

- Introduced a macro "for_each_cfqg_st" to travese through all the service
  trees of a group.
  
- Now async workload share is calculated based on system wide busy queues
  and not just based on queues in root group.

- allow async queue preemption in root group by sync queues in other groups.
  
Changed from V2:
- Made group target latency calculations in proportion to group weight
  instead of evenly dividing the slice among all the groups.

- Modified cfq_rb_first() to check "count" and return NULL if service tree
  is empty.

- Did some reshuffling in patch order. Moved Documentation patch to the end.
  Also moved group idling patch down the order.

- Fixed the "slice_end" issue raised by Gui during slice usage calculation.
  
Changes from V1:

- Rebased the patches for "for-2.6.33" branch. 
- Currently dropped the support for priority class of groups. For the time
  being only BE class groups are supported.
 
After the discussions at IO minisummit at Tokyo, Japan, it was agreed that
one single IO control policy at either leaf nodes or at higher level nodes
does not meet all the requirements and we need something so that we have
the capability to support more than one IO control policy (like proportional
weight division and max bandwidth control) and also have capability to
implement some of these policies at higher level logical devices.

It was agreed that CFQ is the right place to implement time based proportional
weight division policy. Other policies like max bandwidth control/throttling
will make more sense at higher level logical devices.

This patch introduces blkio cgroup controller. It provides the management
interface for the block IO control. The idea is that keep the interface
common and in the background we should be able to switch policies based on
user options. Hence user can control the IO throughout the IO stack with
a single cgroup interface.

Apart from blkio cgroup interface, this patchset also modifies CFQ to implement
time based proportional weight division of disk. CFQ already does it in flat
mode. It has been modified to do group IO scheduling also.

IO control is a huge problem and the moment we start addressing all the
issues in one patchset, it bloats to unmanageable proportions and then nothing
gets inside the kernel. So at io mini summit we agreed that lets take small
steps and once a piece of code is inside the kernel and stablized, take the
next step. So this is the first step.

Some parts of the code are based on BFQ patches posted by Paolo and Fabio.

Your feedback is welcome.

TODO
====
- Direct random writers seem to be very fickle in terms of workload
  classification. They seem to be switching between sync-idle and sync-noidle
  workload type in a little unpredictable manner. Debug and fix it.

- Support async IO control (buffered writes).

 Buffered writes is a beast and requires changes at many a places to solve the
 problem and patchset becomes huge. Hence first we plan to support only sync
 IO in control then work on async IO too.

 Some of the work items identified are.

	- Per memory cgroup dirty ratio
	- Possibly modification of writeback to force writeback from a
	  particular cgroup.
	- Implement IO tracking support so that a bio can be mapped to a cgroup.
	- Per group request descriptor infrastructure in block layer.
	- At CFQ level, implement per cfq_group async queues.	

  In this patchset, all the async IO goes in system wide queues and there are
  no per group async queues. That means we will see service differentiation
  only for sync IO only. Async IO willl be handled later.

- Support for higher level policies like max BW controller.
- Support groups of RT class also.

Thanks
Vivek

 Documentation/cgroups/blkio-controller.txt |  135 +++++
 block/Kconfig                              |   22 +
 block/Kconfig.iosched                      |   17 +
 block/Makefile                             |    1 +
 block/blk-cgroup.c                         |  312 ++++++++++
 block/blk-cgroup.h                         |   90 +++
 block/cfq-iosched.c                        |  901 +++++++++++++++++++++++++---
 include/linux/cgroup_subsys.h              |    6 +
 include/linux/iocontext.h                  |    4 +
 9 files changed, 1401 insertions(+), 87 deletions(-)
