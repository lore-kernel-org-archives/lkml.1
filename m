Return-Path: <linux-kernel-owner+w=401wt.eu-S1760280AbZD2NS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760280AbZD2NS2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 09:18:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760094AbZD2NLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 09:11:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:36776 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760063AbZD2NLw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 09:11:52 -0400
Date: Wed, 29 Apr 2009 13:09:19 GMT
From: tip-bot for Eric Dumazet <dada1@cosmosbay.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, schwidefsky@de.ibm.com, dada1@cosmosbay.com,
       benh@kernel.crashing.org, gallatin@myri.com, akpm@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
       dada1@cosmosbay.com, benh@kernel.crashing.org, gallatin@myri.com,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49F84BC1.7080602@cosmosbay.com>
References: <49F84BC1.7080602@cosmosbay.com>
Subject: [tip:sched/urgent] sched: account system time properly
Message-ID: <tip-f5f293a4e3d0a0c52cec31de6762c95050156516@git.kernel.org>
Git-Commit-ID: f5f293a4e3d0a0c52cec31de6762c95050156516
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 29 Apr 2009 13:09:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f5f293a4e3d0a0c52cec31de6762c95050156516
Gitweb:     http://git.kernel.org/tip/f5f293a4e3d0a0c52cec31de6762c95050156516
Author:     Eric Dumazet <dada1@cosmosbay.com>
AuthorDate: Wed, 29 Apr 2009 14:44:49 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 29 Apr 2009 15:02:28 +0200

sched: account system time properly

Andrew Gallatin reported that IRQ and SOFTIRQ times were
sometime not reported correctly on recent kernels, and even
bisected to commit 457533a7d3402d1d91fbc125c8bd1bd16dcd3cd4
([PATCH] fix scaled & unscaled cputime accounting) as the first
bad commit.

Further analysis pointed that commit
79741dd35713ff4f6fd0eafd59fa94e8a4ba922d ([PATCH] idle cputime
accounting) was the real cause of the problem.

account_process_tick() was not taking into account timer IRQ
interrupting the idle task servicing a hard or soft irq.

On mostly idle cpu, irqs were thus not accounted and top or
mpstat could tell user/admin that cpu was 100 % idle, 0.00 %
irq, 0.00 % softirq, while it was not.

[ Impact: fix occasionally incorrect CPU statistics in top/mpstat ]

Reported-by: Andrew Gallatin <gallatin@myri.com>
Re-reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: rick.jones2@hp.com
Cc: brice@myri.com
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
LKML-Reference: <49F84BC1.7080602@cosmosbay.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index b902e58..26efa47 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4732,7 +4732,7 @@ void account_process_tick(struct task_struct *p, int user_tick)
 
 	if (user_tick)
 		account_user_time(p, one_jiffy, one_jiffy_scaled);
-	else if (p != rq->idle)
+	else if ((p != rq->idle) || (irq_count() != HARDIRQ_OFFSET))
 		account_system_time(p, HARDIRQ_OFFSET, one_jiffy,
 				    one_jiffy_scaled);
 	else
