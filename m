Return-Path: <linux-kernel-owner+w=401wt.eu-S1753994AbZAaMvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbZAaMvo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 07:51:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbZAaMvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 07:51:37 -0500
Received: from ozlabs.org ([203.10.76.45]:38167 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746AbZAaMvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 07:51:36 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] sched_rt: don't use first_cpu on cpumask created with cpumask_and.
Date: Sat, 31 Jan 2009 23:21:24 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: linux-kernel@vger.kernel.org, Mike Travis <travis@sgi.com>,
       Steven Rostedt <rostedt@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901312321.25344.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, please apply to tip/urgent.

cpumask_and() only initializes nr_cpu_ids bits, so the (deprecated)
first_cpu() might find one of those uninitialized bits if nr_cpu_ids
is less than NR_CPUS (as it can be for CONFIG_CPUMASK_OFFSTACK).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 kernel/sched_rt.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -968,8 +968,8 @@ static inline int pick_optimal_cpu(int t
 	if ((this_cpu != -1) && cpu_isset(this_cpu, *mask))
 		return this_cpu;
 
-	first = first_cpu(*mask);
-	if (first != NR_CPUS)
+	first = cpumask_first(mask);
+	if (first < nr_cpu_ids)
 		return first;
 
 	return -1;
