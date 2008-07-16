Return-Path: <linux-kernel-owner+w=401wt.eu-S1759449AbYGPDof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759449AbYGPDof (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 23:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754382AbYGPDoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 23:44:12 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65156 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752493AbYGPDoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 23:44:11 -0400
Message-ID: <487D6E49.7070805@cn.fujitsu.com>
Date: Wed, 16 Jul 2008 11:43:05 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Jackson <pj@sgi.com>, Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] cpuset: Don't pass empty cpumasks to partition_sched_domains()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i create a lots of empty cpusets(empty cpumasks) and
turn off the "sched_load_balance" in top cpuset.

And i found that all these empty cpumasks are passed to
partition_sched_domains() in rebuild_sched_domains(),
it's very time-consuming for partition_sched_domains()
and it's not need.

It also reduce memory consumed and some works in
rebuild_sched_domains() too.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 798b3ab..1fbd52c 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -609,8 +609,13 @@ static void rebuild_sched_domains(void)
 	while (__kfifo_get(q, (void *)&cp, sizeof(cp))) {
 		struct cgroup *cont;
 		struct cpuset *child;   /* scans child cpusets of cp */
+
+		if (cpus_empty(cp->cpus_allowed))
+			continue;
+
 		if (is_sched_load_balance(cp))
 			csa[csn++] = cp;
+
 		list_for_each_entry(cont, &cp->css.cgroup->children, sibling) {
 			child = cgroup_cs(cont);
 			__kfifo_put(q, (void *)&child, sizeof(cp));






