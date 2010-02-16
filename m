Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933401Ab0BPVxB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 16:53:01 -0500
Received: from smtp-out.google.com ([216.239.44.51]:16376 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933341Ab0BPVxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 16:53:00 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=pJzGKwQo3Ji8HFlrdnLkmdLx1NKQueeBMQur9xlzU7DrOZuBZPQSsBMFUyC1Gws9U
	8MHHAI8wJFlYIzKzVHnxg==
Date: Tue, 16 Feb 2010 13:52:53 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 3/7 -mm] oom: select task from tasklist for mempolicy
 ooms
In-Reply-To: <20100216135240.72EC.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1002161343070.23037@chino.kir.corp.google.com>
References: <20100215120924.7281.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1002151407000.26927@chino.kir.corp.google.com> <20100216135240.72EC.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Feb 2010, KOSAKI Motohiro wrote:

> > We need to get a refcount on the mempolicy to ensure it doesn't get freed 
> > from under us, tsk is not necessarily current.
> 
> Hm.
> if you explanation is correct, I think your patch have following race.
> 
> 
>  CPU0                            CPU1
> ----------------------------------------------
> mempolicy_nodemask_intersects()
> mempolicy = tsk->mempolicy;
>                                  do_exit()
>                                  mpol_put(tsk_mempolicy)
> mpol_get(mempolicy);
> 

True, good point.  It looks like we'll need to include mempolicy 
detachment in exit_mm() while under task_lock() and then synchronize with 
that.  It's a legitimate place to do it since no memory allocation will be 
done after its mm is detached, anyway.

> > For MPOL_F_LOCAL, we need to check whether the task's cpu is on a node 
> > that is allowed by the zonelist passed to the page allocator.  In the 
> > second revision of this patchset, this was changed to
> > 
> > 	node_isset(cpu_to_node(task_cpu(tsk)), *mask)
> > 
> > to check.  It would be possible for no memory to have been allocated on 
> > that node and it just happens that the tsk is running on it momentarily, 
> > but it's the best indication we have given the mempolicy of whether 
> > killing a task may lead to future memory freeing.
> 
> This calculation is still broken. In general, running cpu and allocation node
> is not bound.

Not sure what you mean, MPOL_F_LOCAL means that allocations will happen on 
the node of the cpu on which it is running.  The cpu-to-node mapping 
doesn't change, only the cpu on which it is running may change.  That may 
be restricted by sched_setaffinity() or cpusets, however, so this task may 
never allocate on any other node (i.e. it may run on another cpu, but 
always one local to a specific node).  That's enough of an indication that 
it should be a candidate for kill: we're trying to eliminate tasks that 
may never allocate on current's nodemask from consideration.  In other 
words, it would be unfair for two tasks that are isolated to their own 
cpus on different physical nodes using MPOL_F_LOCAL for NUMA optimizations 
to have the other needlessly killed when current can't allocate there 
anyway.
