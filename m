Return-Path: <linux-kernel-owner+w=401wt.eu-S1760525AbXJPJQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760525AbXJPJQl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 05:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754498AbXJPJQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 05:16:34 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:47343 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753894AbXJPJQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 05:16:33 -0400
Date: Tue, 16 Oct 2007 02:16:26 -0700
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: menage@google.com, nickpiggin@yahoo.com.au, a.p.zijlstra@chello.nl,
       balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, clg@fr.ibm.com,
       ebiederm@xmission.com, containers@lists.osdl.org, serue@us.ibm.com,
       svaidy@linux.vnet.ibm.com, akpm@linux-foundation.org, xemul@openvz.org
Subject: Re: [RFC] cpuset update_cgroup_cpus_allowed
Message-Id: <20071016021626.15b94649.pj@sgi.com>
In-Reply-To: <alpine.DEB.0.9999.0710152311180.22383@chino.kir.corp.google.com>
References: <20071015071115.16057.72116.sendpatchset@jackhammer.engr.sgi.com>
	<alpine.DEB.0.9999.0710151135150.24837@chino.kir.corp.google.com>
	<20071015230729.53fcbaf7.pj@sgi.com>
	<alpine.DEB.0.9999.0710152311180.22383@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David wrote:
> Why can't you just add a helper function to sched.c:
> 
> 	void set_hotcpus_allowed(struct task_struct *task,
> 				 cpumask_t cpumask)
> 	{
> 		mutex_lock(&sched_hotcpu_mutex);
> 		set_cpus_allowed(task, cpumask);
> 		mutex_unlock(&sched_hotcpu_mutex);
> 	}
> 
> And then change each task's cpus_allowed via that function instead of 
> set_cpus_allowed() directly?

I guess this would avoid race conditions within the set_cpus_allowed()
routine, between its code to read the cpu_online_map and set the tasks
cpus_allowed ... though if that's useful, don't we really need to add
locking/unlocking on sched_hotcpu_mutex right inside the
set_cpus_allowed() routine, for all users of set_cpus_allowed ??

But I don't see where the above code helps at all deal with the
races I considered in my previous message:

> My solution may be worse than that.  Because set_cpus_allowed() will
> fail if asked to set a non-overlapping cpumask, my solution could never
> terminate.  If asked to set a cpusets cpus to something that went off
> line right then, this I'd guess this code could keep looping forever,
> looking for cpumasks that didn't match, and then not noticing that it
> was failing to set them so as they would match.

These races involve reading the tasks cpuset cpus_allowed mask, reading
the online map, and both reading and writing the tasks task_struct
cpus_allowed.  Unless one holds the relevant lock for the entire
interval surrounding the critical accesses to these values, it won't do
any good that I can see.  Just briefly holding a lock around each
separate access is useless.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
