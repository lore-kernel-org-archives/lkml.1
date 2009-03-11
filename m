Return-Path: <linux-kernel-owner+w=401wt.eu-S1752552AbZCKCPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552AbZCKCPZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 22:15:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751438AbZCKCPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 22:15:12 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65484 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751162AbZCKCPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 22:15:11 -0400
Message-ID: <49B71EB5.1030608@cn.fujitsu.com>
Date: Wed, 11 Mar 2009 10:15:17 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Menage <menage@google.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] cpuacct: reduce one NULL check in fast-path
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In cpuacct_charge(), task_ca() will never return NULL, so change
for(...) to do{}while(...) to save one NULL check.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/sched.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 9bb6d24..bc8a91e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9768,10 +9768,11 @@ static void cpuacct_charge(struct task_struct *tsk, u64 cputime)
 	cpu = task_cpu(tsk);
 	ca = task_ca(tsk);
 
-	for (; ca; ca = ca->parent) {
+	do {
 		u64 *cpuusage = percpu_ptr(ca->cpuusage, cpu);
 		*cpuusage += cputime;
-	}
+		ca = ca->parent;
+	} while (ca);
 }
 
 struct cgroup_subsys cpuacct_subsys = {
-- 
1.5.4.rc3



