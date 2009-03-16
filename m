Return-Path: <linux-kernel-owner+w=401wt.eu-S1759605AbZCPWNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759605AbZCPWNT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 18:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755945AbZCPWNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 18:13:04 -0400
Received: from smtp-out.google.com ([216.239.33.17]:58120 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117AbZCPWND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 18:13:03 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=MtjJYFKqORwx7trpQNsRYddm7R0gU4Rg3NUrxjgTZHl7zKzA6A7CBP6NcFiuLJXH4
	uLEhYPm7emOOc/WmIRHfA==
Date: Mon, 16 Mar 2009 15:11:38 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, balbir@in.ibm.com,
       menage@google.com, vatsa@linux.vnet.ibm.com,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpuset: fix cpuset vs PF_THREAD_BOUND weirdness
In-Reply-To: <1237029434.8939.68.camel@laptop>
Message-ID: <alpine.DEB.2.00.0903161457040.26565@chino.kir.corp.google.com>
References: <200903122251.n2CMpvpT014007@imap1.linux-foundation.org>  <alpine.DEB.2.00.0903121619540.19505@chino.kir.corp.google.com>  <20090313134635.GE17927@linux.vnet.ibm.com>  <alpine.DEB.2.00.0903131143040.17621@chino.kir.corp.google.com> 
 <20090314092345.GA3339@linux.vnet.ibm.com>  <alpine.DEB.2.00.0903140233510.457@chino.kir.corp.google.com> <1237029434.8939.68.camel@laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Mar 2009, Peter Zijlstra wrote:

> David, I'm not sure what you're arguing.
> 
> Letting a kernel thread in a subset, but then not letting it back out
> again seems really weird to me, esp. since PF_THREAD_BOUND is a fairly
> recent thing.
> 

The addition of PF_THREAD_BOUND impacted cpusets because, for the first 
time, it was possible that setting the new set of allowed cpus wouldn't 
succeed (cpusets already deals with the hotplug exception).

That introduced a new requirement: that set_cpus_allowed_ptr() succeeds 
for the attachment of a task to the cpuset changes.  The cpu affinity of 
a task is changed to match that of the cpuset anytime it is moved and then 
imposed a superset for subsequent sched_setaffinity() calls from 
userspace.  Your change would do the latter but neglect the former if it 
doesn't succeed; I'm not immediately opposed to that, but I wasn't 
satisfied with the additional inconsistency that the earlier patch added 
(i.e. changing a cpuset's cpumask that now is disjoint from threads with a 
bound cpu).  So to be clear, I'm not disagreeing with resolving a 
perceived inconsistency with cpuset movement, but I am disagreeing with an 
incomplete solution.

Your solution appears to be more complete, although I have not tested it.  
So thanks for looking at this particular issue.

Let me propose my own patch, however, that would be less intrusive and, if 
anything, more logical.  It would also not require a change to the cgroup 
interface for attachment callbacks.

This patch simply denies PF_THREAD_BOUND tasks from ever moving out of the 
root cpuset.  These kthreads do not require mempolicies that disallow 
access to certain nodes and their cpumask can never be changed; thus, 
cpusets isn't applicable to these threads.  They will forever reside in 
the root cpuset so the interface with userspace remains consistent (i.e. 
`cat tasks' for the root cpuset will still work).

Unless a use-case can be shown for a single PF_THREAD_BOUND task where 
manipulating its cpuset attachment or mempolicy matters, I think this is 
the most appropriate solution.

Signed-off-by: David Rientjes <rientjes@google.com>
---
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1360,12 +1360,16 @@ static int cpuset_can_attach(struct cgroup_subsys *ss,
 	if (cpumask_empty(cs->cpus_allowed) || nodes_empty(cs->mems_allowed))
 		return -ENOSPC;
 
-	if (tsk->flags & PF_THREAD_BOUND) {
-		mutex_lock(&callback_mutex);
-		if (!cpumask_equal(&tsk->cpus_allowed, cs->cpus_allowed))
-			ret = -EINVAL;
-		mutex_unlock(&callback_mutex);
-	}
+	/*
+	 * Kthreads bound to specific cpus cannot be moved to a new cpuset; we
+	 * cannot change their cpu affinity and isolating such threads by their
+	 * set of allowed nodes is unnecessary.  Thus, cpusets are not
+	 * applicable for such threads.  This prevents checking for success of
+	 * set_cpus_allowed_ptr() on all attached tasks before cpus_allowed may
+	 * be changed.
+	 */
+	if (tsk->flags & PF_THREAD_BOUND)
+		return -EINVAL;
 
 	return ret < 0 ? ret : security_task_setscheduler(tsk, 0, NULL);
 }
