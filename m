Return-Path: <linux-kernel-owner+w=401wt.eu-S1756798AbZLOJfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798AbZLOJfn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 04:35:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751099AbZLOJfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 04:35:42 -0500
Received: from ozlabs.org ([203.10.76.45]:56158 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750902AbZLOJfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 04:35:39 -0500
Date: Tue, 15 Dec 2009 19:40:32 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Michael Neuling <mikey@neuling.org>
Subject: [PATCH 1/2] perf_event: Fix incorrect range check on cpu number
Message-ID: <20091215084032.GA18661@brick.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is quite legitimate for CPUs to be numbered sparsely, meaning that
it possible for an online CPU to have a number which is greater than
the total count of possible CPUs.

Currently find_get_context() has a sanity check on the cpu number
where it checks it against num_possible_cpus().  This test can fail
for a legitimate cpu number if the cpu_possible_mask is sparsely
populated.

This fixes the problem by checking the CPU number against
nr_cpumask_bits instead, since that is the appropriate check to ensure
that the cpu number is same to pass to cpu_isset() subsequently.

Reported-by: Michael Neuling <mikey@neuling.org>
Tested-by: Michael Neuling <mikey@neuling.org>
Cc: stable@kernel.org
Signed-off-by: Paul Mackerras <paulus@samba.org>
---
 kernel/perf_event.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 6b7ddba..78551b3 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1604,7 +1604,7 @@ static struct perf_event_context *find_get_context(pid_t pid, int cpu)
 		if (perf_paranoid_cpu() && !capable(CAP_SYS_ADMIN))
 			return ERR_PTR(-EACCES);
 
-		if (cpu < 0 || cpu > num_possible_cpus())
+		if (cpu < 0 || cpu >= nr_cpumask_bits)
 			return ERR_PTR(-EINVAL);
 
 		/*
