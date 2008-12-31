Return-Path: <linux-kernel-owner+w=401wt.eu-S1755977AbYLaIgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977AbYLaIgY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 03:36:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755896AbYLaIgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 03:36:11 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60465 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752296AbYLaIgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 03:36:10 -0500
Message-ID: <495B2EC2.9090305@cn.fujitsu.com>
Date: Wed, 31 Dec 2008 16:35:14 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Mike Travis <travis@sgi.com>, Paul Menage <menage@google.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/6] cpuset: remove on stack cpumask_t in cpuset_sprintf_cpulist()
References: <495B2EA6.7010808@cn.fujitsu.com>
In-Reply-To: <495B2EA6.7010808@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: reduce stack usage

It's safe to call cpulist_scnprintf inside callback_mutex, and thus we
can just remove the cpumask_t and no need to allocate a cpumask_var_t.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/cpuset.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 6012e32..41c2343 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1486,13 +1486,13 @@ static int cpuset_write_resmask(struct cgroup *cgrp, struct cftype *cft,
 
 static int cpuset_sprintf_cpulist(char *page, struct cpuset *cs)
 {
-	cpumask_t mask;
+	int ret;
 
 	mutex_lock(&callback_mutex);
-	mask = cs->cpus_allowed;
+	ret = cpulist_scnprintf(page, PAGE_SIZE, &cs->cpus_allowed);
 	mutex_unlock(&callback_mutex);
 
-	return cpulist_scnprintf(page, PAGE_SIZE, &mask);
+	return ret;
 }
 
 static int cpuset_sprintf_memlist(char *page, struct cpuset *cs)
-- 
1.5.4.rc3


