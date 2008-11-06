Return-Path: <linux-kernel-owner+w=401wt.eu-S1752089AbYKFTkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089AbYKFTkn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 14:40:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750909AbYKFTkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 14:40:32 -0500
Received: from smtp-out.google.com ([216.239.45.13]:55015 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbYKFTkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 14:40:31 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:date:message-id:subject:from:to:cc:
	content-type:content-transfer-encoding;
	b=PfXZdixdsHf17w4PoK5f/m9Arp3B8HBeAKfOUOdi+gfEiGwyzlFa++FHXG/z133xE
	eAeTv4tg1pXG6q+rcsxaw==
MIME-Version: 1.0
Date: Thu, 6 Nov 2008 11:40:28 -0800
Message-ID: <b040c32a0811061140u27093e4er70a43041564617f1@mail.gmail.com>
Subject: [patch] restore sched_exec load balance heuristics
From: Ken Chen <kenchen@google.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've seen long standing performance regression on sys_execve for several
upstream kernels, largely on workload that does heavy execve.  The main
reason for the regression was due to a change in sched_exec load balance
heuristics.  For example, on 2.6.11 kernel, the "exec" task will run on
the same cpu if that is the only task running.  However, 2.6.13 and onward
kernels will go around the sched-domain looking for most idle CPU (which
doesn't treat task exec'ing as an idle CPU).  Thus bouncing the exec'ing
task all over the place which leads to poor CPU cache and numa locality.
(The workload happens to share common data between subsequent exec program).

This execve heuristic was removed in upstream kernel by this git commit:

commit 68767a0ae428801649d510d9a65bb71feed44dd1
Author: Nick Piggin <nickpiggin@yahoo.com.au>
Date:   Sat Jun 25 14:57:20 2005 -0700

[PATCH] sched: schedstats update for balance on fork
Add SCHEDSTAT statistics for sched-balance-fork.

>From the commit description, it appears that deleting the heuristics
was an accident, as the commit is supposedly just for schedstats.

So, restore the sched-exec load balancing if exec'ing task is the only
task running on that specific CPU.  The logic make sense: newly exec
program should continue to run on current CPU as it doesn't change any
load imbalance nor does it help anything by bouncing to another idle
CPU. By keeping on the same CPU, it preserves cache and numa locality.

Signed-off-by: Ken Chen <kenchen@google.com>

diff --git a/kernel/sched.c b/kernel/sched.c
index e8819bc..4ad1907 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2873,7 +2873,12 @@ out:
  */
 void sched_exec(void)
 {
-	int new_cpu, this_cpu = get_cpu();
+	int new_cpu, this_cpu;
+
+	if (this_rq()->nr_running <= 1)
+		return;
+
+	this_cpu = get_cpu();
 	new_cpu = sched_balance_self(this_cpu, SD_BALANCE_EXEC);
 	put_cpu();
 	if (new_cpu != this_cpu)
