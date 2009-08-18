Return-Path: <linux-kernel-owner+w=401wt.eu-S1752470AbZHRX6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470AbZHRX6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 19:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752434AbZHRX6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 19:58:17 -0400
Received: from smtp-out.google.com ([216.239.45.13]:10477 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242AbZHRX6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 19:58:17 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:subject:to:cc:date:message-id:user-agent:
	mime-version:content-type:content-transfer-encoding:x-system-of-record;
	b=uvOHhZHz+o4RlQZ1Zz96DtnESf4Z40wSGn7pLrU23ptZkP5SKzCy95gq/tdU2cM+K
	MUrdBx+US7uKJ90B7KYxw==
From: Paul Menage <menage@google.com>
Subject: [PATCH 0/8] CGroups: cgroup memberlist enhancements/fixes
To: akpm@linux-foundation.org, bblum@andrew.cmu.edu, lizf@cn.fujitsu.com
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Date: Tue, 18 Aug 2009 16:58:06 -0700
Message-ID: <20090818235059.22531.42618.stgit@menage.mtv.corp.google.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series adds a "cgroup.procs" file to each cgroup that
reports unique tgids rather than pids, and allows all threads in a
threadgroup to be atomically moved to a new cgroup.

The subsystem "attach" interface is modified to support attaching
whole threadgroups at a time, which could introduce potential problems
if any subsystem were to need to access the old cgroup of every thread
being moved. The attach interface may need to be revised if this
becomes the case.

Also added is functionality for read/write locking all CLONE_THREAD
fork()ing within a threadgroup, by means of an rwsem that lives in the
sighand_struct, for per-threadgroup-ness and also for sharing a
cacheline with the sighand's atomic count. This scheme should
introduce no extra overhead in the fork path when there's no
contention.

The final patch reveals potential for a race when forking before a
subsystem's attach function is called - one potential solution in case
any subsystem has this problem is to hang on to the group's fork mutex
through the attach() calls, though no subsystem yet demonstrates need
for an extended critical section.

---

Ben Blum (7):
      Adds ability to move all threads in a process to a new cgroup atomically
      Adds functionality to read/write lock CLONE_THREAD fork()ing per-threadgroup
      Lets ss->can_attach and ss->attach do whole threadgroups at a time
      Changes css_set freeing mechanism to be under RCU
      Use vmalloc for large cgroups pidlist allocations
      Ensures correct concurrent opening/reading of pidlists across pid namespaces
      Adds a read-only "procs" file similar to "tasks" that shows only unique tgids

Paul Menage (1):
      Revert commit 8827c288feb7810185aa7c2e37537202fc709869


 Documentation/cgroups/cgroups.txt |   25 +
 include/linux/cgroup.h            |   67 ++-
 include/linux/init_task.h         |    9 
 include/linux/sched.h             |   15 +
 kernel/cgroup.c                   |  948 +++++++++++++++++++++++++++++--------
 kernel/cgroup_freezer.c           |   15 +
 kernel/cpuset.c                   |   66 ++-
 kernel/fork.c                     |    9 
 kernel/ns_cgroup.c                |   16 +
 kernel/sched.c                    |   35 +
 mm/memcontrol.c                   |    3 
 security/device_cgroup.c          |    3 
 12 files changed, 974 insertions(+), 237 deletions(-)

