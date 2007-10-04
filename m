Return-Path: <linux-kernel-owner+w=401wt.eu-S1760239AbXJDJyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760239AbXJDJyX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 05:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755141AbXJDJyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 05:54:10 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:55859 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758825AbXJDJyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 05:54:08 -0400
Date: Thu, 4 Oct 2007 02:53:55 -0700
From: Paul Jackson <pj@sgi.com>
To: Paul Menage <menage@google.com>
Cc: akpm@linuxfoundation.org, balbir@linux.vnet.ibm.com, serue@us.ibm.com,
       clg@fr.ibm.com, ebiederm@xmission.com, xemul@openvz.org,
       rientjes@google.com, svaidy@linux.vnet.ibm.com, nickpiggin@yahoo.com.au,
       a.p.zijlstra@chello.nl, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/33] task containersv11 make cpusets a client of
 containers
Message-Id: <20071004025355.4a096316.pj@sgi.com>
In-Reply-To: <20070917210427.888917000@menage.corp.google.com>
References: <20070917210307.116234000@menage.corp.google.com>
	<20070917210427.888917000@menage.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul M,

This snippet from the memory allocation hot path worries me a bit.

Once per memory page allocation, we go through here, needing to peak inside
the current tasks cpuset to see if it has changed (it's 'mems_generation'
value doesn't match the last seen value we have stashed in the task struct.)

@@ -653,20 +379,19 @@ void cpuset_update_task_memory_state(voi
 	struct task_struct *tsk = current;
 	struct cpuset *cs;
 
-	if (tsk->cpuset == &top_cpuset) {
+	if (task_cs(tsk) == &top_cpuset) {
 		/* Don't need rcu for top_cpuset.  It's never freed. */
 		my_cpusets_mem_gen = top_cpuset.mems_generation;
 	} else {
 		rcu_read_lock();
-		cs = rcu_dereference(tsk->cpuset);
-		my_cpusets_mem_gen = cs->mems_generation;
+		my_cpusets_mem_gen = task_cs(current)->mems_generation;
 		rcu_read_unlock();
 	}

With this new cgroup code, the task_cs macro was added, -twice-,
which deals with the fact that what used to be a single pointer
in the task struct directly to the tasks cpuset is now roughly
two more dereferences and an indexing away:

    static inline struct cpuset *task_cs(struct task_struct *task)
    {
	    return container_of(task_subsys_state(task, cpuset_subsys_id),
				struct cpuset, css);
    }

    static inline struct cgroup_subsys_state *task_subsys_state(
	    struct task_struct *task, int subsys_id)
    {
	    return rcu_dereference(task->cgroups->subsys[subsys_id]);
    }


At a minimum, could you change that last added line to use 'tsk'
instead of 'current'?   This should save one instruction, as 'tsk'
will likely already be in a register.

+		my_cpusets_mem_gen = task_cs(tsk)->mems_generation;

I guess the two, rather than one, invocations of task_cs() won't matter
much, as they are on the same address, so the second invocation will
hit cache lines just found on the first invocation.

I wonder if we can save any cache line hits on this, or if there is
someway to measure whether or not this has noticeable performance
impact.

... Probably this is all lost in the noise of the other stuff that
gets coded in the memory allocation hot path.  It would be nice to
think that it actually matters however.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
