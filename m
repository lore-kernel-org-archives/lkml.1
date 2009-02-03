Return-Path: <linux-kernel-owner+w=401wt.eu-S1751675AbZBCJ1N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751675AbZBCJ1N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 04:27:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751314AbZBCJ04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 04:26:56 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59180 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753863AbZBCJ0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 04:26:55 -0500
Message-ID: <49880DB7.7020509@cn.fujitsu.com>
Date: Tue, 03 Feb 2009 17:26:15 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] cpuset: fix possible races in cpu/memory hotplug
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change to cpuset->cpus_allowed and cpuset->mems_allowed should be protected
by callback_mutex, otherwise the reader may read wrong cpus/mems. This is
cpuset's lock rule.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/cpuset.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index a856788..39f7d94 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2061,7 +2061,9 @@ static int cpuset_track_online_cpus(struct notifier_block *unused_nb,
 	}
 
 	cgroup_lock();
+	mutex_lock(&callback_mutex);
 	cpumask_copy(top_cpuset.cpus_allowed, cpu_online_mask);
+	mutex_unlock(&callback_mutex);
 	scan_for_empty_cpusets(&top_cpuset);
 	ndoms = generate_sched_domains(&doms, &attr);
 	cgroup_unlock();
@@ -2084,11 +2086,12 @@ static int cpuset_track_online_nodes(struct notifier_block *self,
 	cgroup_lock();
 	switch (action) {
 	case MEM_ONLINE:
-		top_cpuset.mems_allowed = node_states[N_HIGH_MEMORY];
-		break;
 	case MEM_OFFLINE:
+		mutex_lock(&callback_mutex);
 		top_cpuset.mems_allowed = node_states[N_HIGH_MEMORY];
-		scan_for_empty_cpusets(&top_cpuset);
+		mutex_unlock(&callback_mutex);
+		if (action == MEM_OFFLINE)
+			scan_for_empty_cpusets(&top_cpuset);
 		break;
 	default:
 		break;
-- 
1.5.4.rc3
