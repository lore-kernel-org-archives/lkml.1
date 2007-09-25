Return-Path: <linux-kernel-owner+w=401wt.eu-S1760632AbXIYQ1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760632AbXIYQ1V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 12:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753194AbXIYQ1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 12:27:13 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:33304 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbXIYQ1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 12:27:13 -0400
Date: Tue, 25 Sep 2007 22:07:47 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/3] Fix other possible sources of latency issues
Message-ID: <20070925163747.GD3231@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20070925144443.GA17858@elte.hu> <20070925162502.GA3231@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070925162502.GA3231@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There is a possibility that because of task of a group moving from one
cpu to another, it may gain more cpu time that desired. See 
http://marc.info/?l=linux-kernel&m=119073197730334 for details.

This is an attempt to fix that problem. Basically it simulates dequeue
of higher level entities as if they are going to sleep. Similarly it
simulate wakeup of higher level entities as if they are waking up from
sleep.

Signed-off-by : Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>

---
 kernel/sched_fair.c |    2 ++
 1 files changed, 2 insertions(+)

Index: current/kernel/sched_fair.c
===================================================================
--- current.orig/kernel/sched_fair.c
+++ current/kernel/sched_fair.c
@@ -715,6 +715,7 @@ static void enqueue_task_fair(struct rq 
 			break;
 		cfs_rq = cfs_rq_of(se);
 		enqueue_entity(cfs_rq, se, wakeup);
+		wakeup = 1;
 	}
 }
 
@@ -734,6 +735,7 @@ static void dequeue_task_fair(struct rq 
 		/* Don't dequeue parent if it has other entities besides us */
 		if (cfs_rq->load.weight)
 			break;
+		sleep = 1;
 	}
 }
 
-- 
Regards,
vatsa
