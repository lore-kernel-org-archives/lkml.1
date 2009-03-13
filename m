Return-Path: <linux-kernel-owner+w=401wt.eu-S1757250AbZCMEFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250AbZCMEFu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 00:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755239AbZCMEF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 00:05:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:34444 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756146AbZCMEF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 00:05:27 -0400
Date: Fri, 13 Mar 2009 04:03:57 GMT
From: Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, lizf@cn.fujitsu.com, menage@google.com,
       balbir@linux.vnet.ibm.com, bharata@linux.vnet.ibm.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, a.p.zijlstra@chello.nl, menage@google.com,
       balbir@linux.vnet.ibm.com, bharata@linux.vnet.ibm.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49B863F5.2060400@cn.fujitsu.com>
References: <49B863F5.2060400@cn.fujitsu.com>
Subject: [tip:core/percpu] cpuacct: reduce one NULL check in fast-path
Message-ID: <tip-7a46c594bf7f1f2eeb1e12d4b857d5f581957a92@git.kernel.org>
Git-Commit-ID: 7a46c594bf7f1f2eeb1e12d4b857d5f581957a92
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 13 Mar 2009 04:03:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7a46c594bf7f1f2eeb1e12d4b857d5f581957a92
Gitweb:     http://git.kernel.org/tip/7a46c594bf7f1f2eeb1e12d4b857d5f581957a92
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Thu, 12 Mar 2009 09:23:01 +0800
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 13 Mar 2009 04:54:58 +0100

cpuacct: reduce one NULL check in fast-path

Impact: micro-optimization

In cpuacct_charge(), task_ca() will never return NULL, so change
for(...) to do { } while(...) to save one NULL check.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Menage <menage@google.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>
LKML-Reference: <49B863F5.2060400@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 0a76d0b..61e6356 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9599,10 +9599,11 @@ static void cpuacct_charge(struct task_struct *tsk, u64 cputime)
 	cpu = task_cpu(tsk);
 	ca = task_ca(tsk);
 
-	for (; ca; ca = ca->parent) {
+	do {
 		u64 *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
 		*cpuusage += cputime;
-	}
+		ca = ca->parent;
+	} while (ca);
 }
 
 struct cgroup_subsys cpuacct_subsys = {
