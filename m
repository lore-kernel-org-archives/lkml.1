Return-Path: <linux-kernel-owner+w=401wt.eu-S932764AbXJPGYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932764AbXJPGYz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 02:24:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760337AbXJPGYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 02:24:47 -0400
Received: from smtp-out.google.com ([216.239.45.13]:56806 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760074AbXJPGYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 02:24:46 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=K42c/UreqJar/qD5Q5Yraut4KdX6jAKytYvbvPc8ojwitevtBGzm3YHNcbID3XJ2f
	mlmRMCdlG94XwzSSz4dCw==
Date: Mon, 15 Oct 2007 23:21:08 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: menage@google.com, nickpiggin@yahoo.com.au, a.p.zijlstra@chello.nl,
       balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, clg@fr.ibm.com,
       ebiederm@xmission.com, containers@lists.osdl.org, serue@us.ibm.com,
       svaidy@linux.vnet.ibm.com, akpm@linux-foundation.org, xemul@openvz.org
Subject: Re: [RFC] cpuset update_cgroup_cpus_allowed
In-Reply-To: <20071015230729.53fcbaf7.pj@sgi.com>
Message-ID: <alpine.DEB.0.9999.0710152311180.22383@chino.kir.corp.google.com>
References: <20071015071115.16057.72116.sendpatchset@jackhammer.engr.sgi.com> <alpine.DEB.0.9999.0710151135150.24837@chino.kir.corp.google.com> <20071015230729.53fcbaf7.pj@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2007, Paul Jackson wrote:

> My solution may be worse than that.  Because set_cpus_allowed() will
> fail if asked to set a non-overlapping cpumask, my solution could never
> terminate.  If asked to set a cpusets cpus to something that went off
> line right then, this I'd guess this code could keep looping forever,
> looking for cpumasks that didn't match, and then not noticing that it
> was failing to set them so as they would match.
> 

Why can't you just add a helper function to sched.c:

	void set_hotcpus_allowed(struct task_struct *task,
				 cpumask_t cpumask)
	{
		mutex_lock(&sched_hotcpu_mutex);
		set_cpus_allowed(task, cpumask);
		mutex_unlock(&sched_hotcpu_mutex);
	}

And then change each task's cpus_allowed via that function instead of 
set_cpus_allowed() directly?

You don't need to worry about making the task->cpuset->cpus_allowed 
assignment a critical section because common_cpu_mem_hotplug_unplug() will 
remove any hot-unplugged cpus from each cpuset's cpus_allowed in the 
hierarchy.

Your loop will still need to be reworked so that cgroup_iter_{start,end}() 
are not reinvoked unnecessarily and you rely only on cgroup_iter_next() 
returning NULL to determine when you've gone through the entire list.  
There's no need to go back and check the cpus_allowed of tasks you've 
already called set_cpus_allowed() on either directly or indirectly via my 
helper function above.

		David
