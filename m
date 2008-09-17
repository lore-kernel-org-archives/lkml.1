Return-Path: <linux-kernel-owner+w=401wt.eu-S1753450AbYIQLFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450AbYIQLFv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 07:05:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752399AbYIQLFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 07:05:41 -0400
Received: from qb-out-0506.google.com ([72.14.204.228]:29149 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362AbYIQLFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 07:05:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=TCtZQB7faCKXMX4vOttebK4Fzmgfprq4TA303TWOvG+CehOWVE0fpYqPsRP7ef+zl0
         MQDSiydB5sc/Yhn31cdr8w7FaJzbcFNCw7eN6X/BlX7qKt3EYgrIrLwx76oZObHCyldi
         ill6sCu+0WWvTfSyqroWyIRE16wAv0614gR5o=
From: Andrea Righi <righi.andrea@gmail.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>, Paul Menage <menage@google.com>
Cc: agk@sourceware.org, akpm@linux-foundation.org, axboe@kernel.dk,
       baramsori72@gmail.com, Carl Henrik Lunde <chlunde@ping.uio.no>,
       dave@linux.vnet.ibm.com, Divyesh Shah <dpshah@google.com>,
       eric.rannaud@gmail.com, fernando@oss.ntt.co.jp,
       Hirokazu Takahashi <taka@valinux.co.jp>, Li Zefan <lizf@cn.fujitsu.com>,
       Marco Innocenti <m.innocenti@cineca.it>, matt@bluehost.com,
       ngupta@google.com, randy.dunlap@oracle.com, roberto@unbit.it,
       Ryo Tsuruta <ryov@valinux.co.jp>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, subrata@linux.vnet.ibm.com,
       yoshikawa.takuya@oss.ntt.co.jp, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH -mm 0/6] cgroup: block device i/o controller (v10)
Date: Wed, 17 Sep 2008 13:05:22 +0200
Message-Id: <1221649528-8519-1-git-send-email-righi.andrea@gmail.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The objective of the i/o controller is to improve i/o performance
predictability of different cgroups sharing the same block devices.

Respect to other priority/weight-based solutions the approach used by this
controller is to explicitly choke applications' requests that directly (or
indirectly) generate i/o activity in the system.

The direct bandwidth and/or iops limiting method has the advantage of improving
the performance predictability at the cost of reducing, in general, the overall
performance of the system (in terms of throughput).

Detailed informations about design, its goal and usage are described in the
documentation.

Tested against 2.6.27-rc5-mm1.

The all-in-one patch (and previous versions) can be found at:
http://download.systemimager.org/~arighi/linux/patches/io-throttle/

Changelog: (v9 -> v10)
* fix a bug to correctly throttle small direct-IO writes
* fix: do not add a new limiting rule if the limit is 0 (unlimited)
* do not report time values directly in jiffies, always use clock_t
* remove a spinlock in struct iothrottle (we always hold cgroup_lock() when
  using it for RCU update, so an additional spinlock is not needed)
* use page_cgroup functionality provided by memory cgroup controller to charge
  the right cgroup of asynchronous i/o activity (e.g. pdflush writebacks)
* code simplification in cgroup_io_throttle()
* removed a lot of experimental stuff introduced in the previous version
* update documentation

TODO:
* Implement a rbtree per request queue; all the requests queued to the I/O
  subsystem first will go in this rbtree. Then based on cgroup grouping and
  control policy dispatch the requests and pass them to the elevator associated
  with the queue. This would allow to provide both bandwidth limiting and
  proportional bandwidth functionalities using a quite generic approach
  (suggested by Vivek Goyal)

* Improve fair throttling: distribute the time to sleep among all the tasks of
  a cgroup that exceeded the I/O limits, depending of the amount of IO activity
  previously generated in the past by each task (see task_io_accounting)

* Try to reduce the cost of calling cgroup_io_throttle() on every submit_bio();
  this is not too much expensive, but the call of task_subsys_state() has
  surely a cost. A possible solution could be to temporarily account I/O in the
  current task_struct and call cgroup_io_throttle() only on each X MB of I/O.
  Or on each Y number of I/O requests as well. Better if both X and/or Y can be
  tuned at runtime by a userspace tool

* Think an alternative design for general purpose usage; special purpose usage
  right now is restricted to improve I/O performance predictability and
  evaluate more precise response timings for applications doing I/O. To a large
  degree the block I/O bandwidth controller should implement a more complex
  logic to better evaluate real I/O operations cost, depending also on the
  particular block device profile (i.e. USB stick, optical drive, hard disk,
  etc.). This would also allow to appropriately account I/O cost for seeky
  workloads, respect to large stream workloads. Instead of looking at the
  request stream and try to predict how expensive the I/O cost will be, a
  totally different approach could be to collect request timings (start time /
  elapsed time) and based on collected informations, try to estimate the I/O
  cost and usage

-Andrea
