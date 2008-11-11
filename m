Return-Path: <linux-kernel-owner+w=401wt.eu-S1756383AbYKKMtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756383AbYKKMtu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 07:49:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755512AbYKKMtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 07:49:42 -0500
Received: from ms01.sssup.it ([193.205.80.99]:54425 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755403AbYKKMtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 07:49:41 -0500
Date: Tue, 11 Nov 2008 13:51:48 +0100
From: Fabio Checconi <fchecconi@gmail.com>
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, paolo.valente@unimore.it,
       fabio@gandalf.sssup.it
Subject: [PATCH 0/3] BFQ I/O Scheduler (second take)
Message-ID: <20081111125148.GD9508@gandalf.sssup.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens, hi all,

  this is an updated version of the patchset introducing the BFQ (Budget
Fair Queueing) I/O scheduler.  It is based on CFQ and it has been
developed trying to improve the predictability and the fairness of the
service prvided, without penalizing the aggregate throughput.

This new version hopefully addresses the issues pointed out after the
first submission[1]:

  1) it introduces a bitmap to notify priority changes to the bfq/cfq;
  2) it introduces a timeout to put an higher limit to the time a
      task can take to consume its budget;
  3) it supports hierarchical scheduling.

With the introduction of a budget timeout, each task is still assigned
a budget measured in number of sectors instead of amount of time,
but a budget is not served to its exhaustion if it's taking too much
to complete.  Budgets are still scheduled using a modified version
of WF2Q+.

Using huge values for max_budget turns the scheduler into a pure
time-domain proportional share one, and the timeout controls the duration
of the time quanta.

WRT the support for hierarchical scheduling, that is being discussed
so much in these days, this scheduler does not add anything new, it
supports proportional share distribution of disk bandwidth among
full cgroup hierarchies; the mapping from requests to cgroups is
correct only in case of synchronous reads.

The overall diffstat is the following:

 block/Kconfig.iosched         |   25 +
 block/Makefile                |    1 +
 block/bfq-cgroup.c            |  743 +++++++++++++++
 block/bfq-ioc.c               |  375 ++++++++
 block/bfq-iosched.c           | 2010 +++++++++++++++++++++++++++++++++++++++++
 block/bfq-sched.c             |  950 +++++++++++++++++++
 block/bfq.h                   |  514 +++++++++++
 block/blk-ioc.c               |   27 +-
 block/cfq-iosched.c           |   10 +-
 fs/ioprio.c                   |    9 +-
 include/linux/cgroup_subsys.h |    6 +
 include/linux/iocontext.h     |   18 +-
 12 files changed, 4669 insertions(+), 19 deletions(-)

For a complete description of the algorithm and of its properties
please refer to [2], (where extensive experiments on older hw can
also be found), and for some performance measurements and implementation
details, to [3].

[1] http://lkml.org/lkml/2008/4/1/234
[2] http://algo.ing.unimo.it/people/paolo/disk_sched/
[3] http://feanor.sssup.it/~fabio/linux/bfq/

As usual, any kind of feedback will be greatly appreciated, thanks
in advance.

Fabio Checconi, Paolo Valente
