Return-Path: <linux-kernel-owner+w=401wt.eu-S1752034AbZGXDVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034AbZGXDVu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 23:21:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751415AbZGXDVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 23:21:50 -0400
Received: from smtp-out.google.com ([216.239.45.13]:59710 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbZGXDVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 23:21:49 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:subject:to:date:message-id:user-agent:mime-version:
	content-type:content-transfer-encoding;
	b=ObSnY9l+NGa6UYfJ7+F3oNlFwjD2KSFmB9WfoZUKL5Pgu3IAP9mooar6bz9J0xBs9
	idwfsSnn5z4qpn5Kgx4/Q==
From: Ben Blum <bblum@google.com>
Subject: [PATCH 0/6] CGroups: cgroup memberlist enhancement+fix
To: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       akpm@linux-foundation.org, serue@us.ibm.com, lizf@cn.fujitsu.com,
       menage@google.com, bblum@google.com
Date: Thu, 23 Jul 2009 20:21:35 -0700
Message-ID: <20090724032033.2463.79256.stgit@hastromil.mtv.corp.google.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(This patch series contains revisions of the patches from
http://lkml.org/lkml/2009/7/10/396 and a few more.)

The following series adds a "cgroup.procs" file to each cgroup that reports
unique tgids rather than pids, which can also be written to for moving all
threads in a threadgroup at once.

Patch #5 introduces a new rwsem that must be taken for reading in the fork()
path, and patch #6 reveals potential for a race when forking in certain
subsystems before the subsystem's attach() function is called, the naive
solution to which would be holding on to the fork rwsem until after the attach
loop. Suggestions for alternative approaches or tweaks to the current approach
are welcome; one potential fix is to make the fork rwsem per-threadgroup,
which will involve adding a field to task_struct, thereby drastically reducing
contention when a write to the procs file is in progress.

This patch series was written at the same time as Li Zefan's pid namespace
bugfix patch (from http://lkml.org/lkml/2009/7/1/559 ), and contains a similar
but finer-grained fix for the same bug. These patches can either be rewritten
to be applied on top of Li's patch, or be applied as they are with Li's patch
reversed.

---

Ben Blum (6):
      Lets ss->can_attach and ss->attach do whole threadgroups at a time
      Makes procs file writable to move all threads by tgid at once
      Changes css_set freeing mechanism to be under RCU
      Quick vmalloc vs kmalloc fix to the case where array size is too large
      Ensures correct concurrent opening/reading of pidlists across pid namespaces
      Adds a read-only "procs" file similar to "tasks" that shows only unique tgids


 Documentation/cgroups/cgroups.txt |   12 -
 include/linux/cgroup.h            |   58 ++-
 kernel/cgroup.c                   |  816 ++++++++++++++++++++++++++++++-------
 kernel/cgroup_freezer.c           |   15 +
 kernel/cpuset.c                   |   65 ++-
 kernel/fork.c                     |    2 
 kernel/ns_cgroup.c                |   16 +
 kernel/sched.c                    |   37 ++
 mm/memcontrol.c                   |    3 
 security/device_cgroup.c          |    3 
 10 files changed, 843 insertions(+), 184 deletions(-)

