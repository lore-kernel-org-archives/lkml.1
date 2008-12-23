Return-Path: <linux-kernel-owner+w=401wt.eu-S1755567AbYLWIhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567AbYLWIhZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 03:37:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbYLWIhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 03:37:12 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:56623 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751755AbYLWIhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 03:37:11 -0500
Message-ID: <4950A2D0.80905@cn.fujitsu.com>
Date: Tue, 23 Dec 2008 16:35:28 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>, Andrew Morton <akpm@linux-foundation.org>
CC: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH] cpusets: set task's cpu_allowed to cpu_possible_map
 when attaching it into top cpuset
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found a bug on my dual-cpu box. I created a sub cpuset in top cpuset and
assign 1 to its cpus. And then we attach some tasks into this sub cpuset.
After this, we offline CPU1. Now, the tasks in this new cpuset are moved into
top cpuset automatically because there is no cpu in sub cpuset. Then we
online CPU1, we find all the tasks which doesn't belong to top cpuset originally
just run on CPU0.

We fix this bug by setting task's cpu_allowed to cpu_possible_map when attaching
it into top cpuset. This method needn't modify the current behavior of cpusets on
CPU hotplug, and all of tasks in top cpuset use cpu_possible_map to initialize
their cpu_allowed.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>

---
 kernel/cpuset.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 96c0ba1..e087b72 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1332,10 +1332,14 @@ static void cpuset_attach(struct cgroup_subsys *ss,
 	struct cpuset *oldcs = cgroup_cs(oldcont);
 	int err;
 
-	mutex_lock(&callback_mutex);
-	guarantee_online_cpus(cs, &cpus);
+	if (cs == &top_cpuset) {
+		cpus = cpu_possible_map;
+	} else {
+		mutex_lock(&callback_mutex);
+		guarantee_online_cpus(cs, &cpus);
+		mutex_unlock(&callback_mutex);
+	}
 	err = set_cpus_allowed_ptr(tsk, &cpus);
-	mutex_unlock(&callback_mutex);
 	if (err)
 		return;
 
-- 1.5.4.rc3 

