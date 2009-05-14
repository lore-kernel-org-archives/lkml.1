Return-Path: <linux-kernel-owner+w=401wt.eu-S1756206AbZENVFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206AbZENVFi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 17:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752420AbZENVF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 17:05:28 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:45709 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388AbZENVF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 17:05:27 -0400
Subject: Re: Misleading OOM messages
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Mel Gorman <mel@csn.ul.ie>, Peter Ziljstra <a.p.ziljstra@chello.nl>,
       San Mehat <san@android.com>, Arve Hj?nnev?g <arve@android.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.0905141346030.28074@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0905101458430.18804@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.0905101503070.18804@chino.kir.corp.google.com>
	 <alpine.DEB.1.10.0905121708470.14226@qirst.com>
	 <20090514092909.GG1365@ucw.cz>
	 <alpine.DEB.1.10.0905141546040.1381@qirst.com>
	 <1242333519.15391.210.camel@nimitz>
	 <alpine.DEB.2.00.0905141346030.28074@chino.kir.corp.google.com>
Content-Type: text/plain
Date: Thu, 14 May 2009 14:05:20 -0700
Message-Id: <1242335120.15391.242.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-14 at 13:49 -0700, David Rientjes wrote:
> I think switching all the oom killer messages to be "no available memory" 
> as it is in the MPOL_BIND case would be the best alternative.  We 
> currently use "out of memory" even for cpusets, for example, when it 
> happens because it cannot accommodate any more hardwall allocations while 
> there may be an abundance of memory elsewhere that it cannot access.  I 
> also think "no available memory" makes more sense than "out of memory" 
> when describing situations where we're at or below the minimum watermarks 
> for all allowable zones.  Either that or "no allowable memory".

How about something like this to start?  We can "mv mm/oom_kill.c
mm/nam_kill.c" later. ;)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 92bcf1d..0ce0d59 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -409,7 +409,8 @@ static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 		return 0;
 	}
 
-	printk(KERN_ERR "%s: kill process %d (%s) score %li or a child\n",
+	printk(KERN_ERR "No available memory %s: "
+			"kill process %d (%s) score %li or a child\n",
 					message, task_pid_nr(p), p->comm, points);
 
 	/* Try to kill a child first */
@@ -438,7 +439,7 @@ retry:
 		p = current;
 
 	if (oom_kill_process(p, gfp_mask, 0, points, mem,
-				"Memory cgroup out of memory"))
+				"(memory cgroup)"))
 		goto retry;
 out:
 	read_unlock(&tasklist_lock);
@@ -519,7 +520,7 @@ static void __out_of_memory(gfp_t gfp_mask, int order)
 
 	if (sysctl_oom_kill_allocating_task)
 		if (!oom_kill_process(current, gfp_mask, order, 0, NULL,
-				"Out of memory (oom_kill_allocating_task)"))
+				"(oom_kill_allocating_task)"))
 			return;
 retry:
 	/*
@@ -537,8 +538,7 @@ retry:
 		panic("Out of memory and no killable processes...\n");
 	}
 
-	if (oom_kill_process(p, gfp_mask, order, points, NULL,
-			     "Out of memory"))
+	if (oom_kill_process(p, gfp_mask, order, points, NULL, ""))
 		goto retry;
 }
 
@@ -612,7 +612,7 @@ void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask, int order)
 	switch (constraint) {
 	case CONSTRAINT_MEMORY_POLICY:
 		oom_kill_process(current, gfp_mask, order, 0, NULL,
-				"No available memory (MPOL_BIND)");
+				"(MPOL_BIND)");
 		break;
 
 	case CONSTRAINT_NONE:


-- Dave

