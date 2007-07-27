Return-Path: <linux-kernel-owner+w=401wt.eu-S938459AbXG0XzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938459AbXG0XzX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 19:55:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934589AbXG0XzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 19:55:10 -0400
Received: from mga09.intel.com ([134.134.136.24]:7184 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762431AbXG0XzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 19:55:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,192,1183359600"; 
   d="scan'208";a="110801587"
Subject: Volanomark slows by 80% under CFS
From: Tim Chen <tim.c.chen@linux.intel.com>
Reply-To: tim.c.chen@linux.intel.com
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="=-SFFeNoP0kmgx3XwklKec"
Organization: Intel
Date: Fri, 27 Jul 2007 15:01:27 -0700
Message-Id: <1185573687.19777.44.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-8) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-SFFeNoP0kmgx3XwklKec
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Ingo,

Volanomark slows by 80% with CFS scheduler on 2.6.23-rc1.  
Benchmark was run on a 2 socket Core2 machine.

The change in scheduler treatment of sched_yield 
could play a part in changing Volanomark behavior.
In CFS, sched_yield is implemented
by dequeueing and requeueing a process .  The time a process 
has spent running probably reduced the the cpu time due it 
by only a bit. The process could get re-queued pretty close
to head of the queue, and may get scheduled again pretty
quickly if there is still a lot of cpu time due.  

It may make sense to queue the
yielding process a bit further behind in the queue. 
I made a slight change by zeroing out wait_runtime 
(i.e. have the process gives
up cpu time due for it to run) for experimentation. 
Let's put aside gripes that Volanomark should have used a 
better mechanism to coordinate threads instead sched_yield for 
a second.   Volanomark runs better
and is only 40% (instead of 80%) down from old scheduler 
without CFS.  

Of course we should not tune for Volanomark and this is
reference data. 
What are your view on how CFS's sched_yield should behave?

Regards,
Tim




--=-SFFeNoP0kmgx3XwklKec
Content-Disposition: attachment; filename=patch.sched_yield
Content-Type: text/plain; name=patch.sched_yield; charset=UTF-8
Content-Transfer-Encoding: 7bit

--- linux-2.6.23-rc1/kernel/sched_fair.c.orig	2007-07-27 09:39:11.000000000 -0700
+++ linux-2.6.23-rc1/kernel/sched_fair.c	2007-07-27 09:40:41.000000000 -0700
@@ -841,6 +841,7 @@
 	 * position within the tree:
 	 */
 	dequeue_entity(cfs_rq, &p->se, 0, now);
+    	p->se.wait_runtime = 0; 
 	enqueue_entity(cfs_rq, &p->se, 0, now);
 }
 

--=-SFFeNoP0kmgx3XwklKec--
