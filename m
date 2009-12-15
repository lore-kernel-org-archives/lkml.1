Return-Path: <linux-kernel-owner+w=401wt.eu-S1760113AbZLOMNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760113AbZLOMNf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 07:13:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760105AbZLOMNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 07:13:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:51261 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760104AbZLOMNa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 07:13:30 -0500
Date: Tue, 15 Dec 2009 12:12:46 GMT
From: tip-bot for Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, peterz@infradead.org, stable@kernel.org,
       tglx@linutronix.de, mingo@elte.hu, mikey@neuling.org
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, peterz@infradead.org, stable@kernel.org,
       tglx@linutronix.de, mingo@elte.hu, mikey@neuling.org
In-Reply-To: <20091215084032.GA18661@brick.ozlabs.ibm.com>
References: <20091215084032.GA18661@brick.ozlabs.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf_event: Fix incorrect range check on cpu number
Message-ID: <tip-0f624e7e5625f4c30c836b7a5decfe2553582391@git.kernel.org>
Git-Commit-ID: 0f624e7e5625f4c30c836b7a5decfe2553582391
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0f624e7e5625f4c30c836b7a5decfe2553582391
Gitweb:     http://git.kernel.org/tip/0f624e7e5625f4c30c836b7a5decfe2553582391
Author:     Paul Mackerras <paulus@samba.org>
AuthorDate: Tue, 15 Dec 2009 19:40:32 +1100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 15 Dec 2009 13:09:55 +0100

perf_event: Fix incorrect range check on cpu number

It is quite legitimate for CPUs to be numbered sparsely, meaning
that it possible for an online CPU to have a number which is
greater than the total count of possible CPUs.

Currently find_get_context() has a sanity check on the cpu
number where it checks it against num_possible_cpus().  This
test can fail for a legitimate cpu number if the
cpu_possible_mask is sparsely populated.

This fixes the problem by checking the CPU number against
nr_cpumask_bits instead, since that is the appropriate check to
ensure that the cpu number is same to pass to cpu_isset()
subsequently.

Reported-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: Paul Mackerras <paulus@samba.org>
Tested-by: Michael Neuling <mikey@neuling.org>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: <stable@kernel.org>
LKML-Reference: <20091215084032.GA18661@brick.ozlabs.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index d891ec4..8823b08 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1603,7 +1603,7 @@ static struct perf_event_context *find_get_context(pid_t pid, int cpu)
 		if (perf_paranoid_cpu() && !capable(CAP_SYS_ADMIN))
 			return ERR_PTR(-EACCES);
 
-		if (cpu < 0 || cpu > num_possible_cpus())
+		if (cpu < 0 || cpu >= nr_cpumask_bits)
 			return ERR_PTR(-EINVAL);
 
 		/*
