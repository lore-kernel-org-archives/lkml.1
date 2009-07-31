Return-Path: <linux-kernel-owner+w=401wt.eu-S1751866AbZGaBvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866AbZGaBvq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 21:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751268AbZGaBvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 21:51:45 -0400
Received: from smtp-out.google.com ([216.239.33.17]:19943 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbZGaBvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 21:51:45 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:subject:to:date:message-id:user-agent:mime-version:
	content-type:content-transfer-encoding;
	b=ZSsU7jlGRbhlFwvSY365eJ5Nygx5cp6F4w6JPKMA9x+f/EszM2nK5jI/6bPbbdaQ2
	yKqpA8W7FymyIZDRXtMIg==
From: Ben Blum <bblum@google.com>
Subject: [PATCH v2 0/6] CGroups: cgroup memberlist enhancement+fix
To: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       akpm@linux-foundation.org, serue@us.ibm.com, lizf@cn.fujitsu.com,
       menage@google.com, bblum@google.com
Date: Thu, 30 Jul 2009 18:51:23 -0700
Message-ID: <20090731012908.27908.62208.stgit@hastromil.mtv.corp.google.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(This patch series is a revision of http://lkml.org/lkml/2009/7/23/330 .)

The following series adds a "cgroup.procs" file to each cgroup that reports
unique tgids rather than pids, which can also be written to for moving all
threads in a threadgroup at once.

Patch #5 modifies the subsystem attach interface to be able to attach whole
threadgroups at a time, which could introduce potential problems if any
subsystem were to need the old cgroup of every thread being moved.

Patch #6 introduces a new rwsem (per threadgroup) that's taken for reading in
the fork() path, and reveals potential for a race when forking before a
subsystem's attach() function is called - one potential solution in case any
subsystem has this problem is to hang on to the group's fork mutex through the
attach() calls.

This patch series was written at the same time as Li Zefan's pid namespace
bugfix patch (from http://lkml.org/lkml/2009/7/1/559 ), and contains a similar
but finer-grained fix for the same bug. These patches can either be rewritten
to be applied on top of Li's patch, or be applied as they are with Li's patch
reversed.

---

Ben Blum (6):
      Makes procs file writable to move all threads by tgid at once
      Lets ss->can_attach and ss->attach do whole threadgroups at a time
      Changes css_set freeing mechanism to be under RCU
      Quick vmalloc vs kmalloc fix to the case where array size is too large
      Ensures correct concurrent opening/reading of pidlists across pid namespaces
      Adds a read-only "procs" file similar to "tasks" that shows only unique tgids


 Documentation/cgroups/cgroups.txt |   12 +
 include/linux/cgroup.h            |   68 ++-
 include/linux/init_task.h         |    9 
 include/linux/sched.h             |    2 
 kernel/cgroup.c                   |  810 ++++++++++++++++++++++++++++++-------
 kernel/cgroup_freezer.c           |   15 +
 kernel/cpuset.c                   |   65 ++-
 kernel/fork.c                     |    6 
 kernel/ns_cgroup.c                |   16 +
 kernel/sched.c                    |   37 ++
 mm/memcontrol.c                   |    3 
 security/device_cgroup.c          |    3 
 12 files changed, 855 insertions(+), 191 deletions(-)

