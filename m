Return-Path: <linux-kernel-owner+w=401wt.eu-S1756469AbXGXNoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756469AbXGXNoy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 09:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759387AbXGXNoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 09:44:39 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:53062 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758322AbXGXNoh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 09:44:37 -0400
Date: Tue, 24 Jul 2007 15:42:02 +0200
From: =?UTF-8?B?U8OpYmFzdGllbiBEdWd1w6k=?= <sebastien.dugue@bull.net>
To: Linux RT Users <linux-rt-users@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jean Pierre Dion <jean-pierre.dion@bull.net>,
       Darren Hart <dvhltc@us.ibm.com>, john stultz <johnstul@us.ibm.com>,
       Josh Triplett <josht@linux.vnet.ibm.com>
Subject: [PATCH RT] Fix RT balancing tasks pulling
Message-ID: <20070724154202.224f12e8@frecb000686.frec.bull.fr>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 24/07/2007 15:49:13,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 24/07/2007 15:49:13,
	Serialize complete at 24/07/2007 15:49:13
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



  Hi Ingo, Thomas,

  this one-liner fixes a bug in balance_rt_tasks() which sometimes manifests by
having a lower prio task being scheduled while a higher prio task is sitting
waiting on another runqueue.

  This is pretty hard to reproduce on low cpu count machines, for example, I
had to have sched_football run in a loop for ~38h before it failed on a dual HT
Xeon box.

  Sébastien.

---


  In the CPU loop in balance_rt_tasks(), the 'next' task pointer is only ever
updated if this_rq->lock has been dropped in double_lock_balance().

  This sometimes lead to 'this_cpu' pulling tasks that are only garanteed to
have a higher priority than the 'next' picked before the loop.

  Fix this to update 'next' to the last picked RT task.


Signed-off-by: Sébastien Dugué <sebastien.dugue@bull.net>

---
 kernel/sched.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux-2.6.22.1-rt6/kernel/sched.c
===================================================================
--- linux-2.6.22.1-rt6.orig/kernel/sched.c	2007-07-24 11:34:18.000000000 +0200
+++ linux-2.6.22.1-rt6/kernel/sched.c	2007-07-24 11:34:35.000000000 +0200
@@ -1499,6 +1499,14 @@ static void balance_rt_tasks(struct rq *
 			 * in another runqueue. (low likelyhood
 			 * but possible)
 			 */
+
+			/*
+			 * Update next so that we won't pick a task
+			 * on another cpu with a priority lower (or equal)
+			 * than the one we just picked.
+			 */
+			next = p;
+
 		}
 		spin_unlock(&src_rq->lock);
 	}
