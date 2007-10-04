Return-Path: <linux-kernel-owner+w=401wt.eu-S1758565AbXJDPQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758565AbXJDPQ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 11:16:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756129AbXJDPQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 11:16:49 -0400
Received: from smtp-out.google.com ([216.239.33.17]:1287 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754697AbXJDPQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 11:16:48 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=OpcdorUEx6qthRjbdeQLxWhZDnjytaORESEnoO6z8HUXiegc1DOGF2TzwOnAR+/wk
	P7VHcJ1pFDKzC+iycQq6g==
Message-ID: <6599ad830710040816p63108ab1vb8547b9600b9e659@mail.gmail.com>
Date: Thu, 4 Oct 2007 08:16:34 -0700
From: "Paul Menage" <menage@google.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: [PATCH 11/33] task containersv11 make cpusets a client of containers
Cc: akpm@linuxfoundation.org, balbir@linux.vnet.ibm.com, serue@us.ibm.com,
       clg@fr.ibm.com, ebiederm@xmission.com, xemul@openvz.org,
       rientjes@google.com, svaidy@linux.vnet.ibm.com, nickpiggin@yahoo.com.au,
       a.p.zijlstra@chello.nl, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071004025355.4a096316.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070917210307.116234000@menage.corp.google.com>
	 <20070917210427.888917000@menage.corp.google.com>
	 <20071004025355.4a096316.pj@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/4/07, Paul Jackson <pj@sgi.com> wrote:
> Paul M,
>
> This snippet from the memory allocation hot path worries me a bit.
>
> Once per memory page allocation, we go through here, needing to peak inside
> the current tasks cpuset to see if it has changed (it's 'mems_generation'
> value doesn't match the last seen value we have stashed in the task struct.)
>
> @@ -653,20 +379,19 @@ void cpuset_update_task_memory_state(voi
>         struct task_struct *tsk = current;
>         struct cpuset *cs;
>
> -       if (tsk->cpuset == &top_cpuset) {
> +       if (task_cs(tsk) == &top_cpuset) {
>                 /* Don't need rcu for top_cpuset.  It's never freed. */
>                 my_cpusets_mem_gen = top_cpuset.mems_generation;
>         } else {
>                 rcu_read_lock();
> -               cs = rcu_dereference(tsk->cpuset);
> -               my_cpusets_mem_gen = cs->mems_generation;
> +               my_cpusets_mem_gen = task_cs(current)->mems_generation;
>                 rcu_read_unlock();
>         }
>
> With this new cgroup code, the task_cs macro was added, -twice-,
> which deals with the fact that what used to be a single pointer
> in the task struct directly to the tasks cpuset is now roughly
> two more dereferences and an indexing away:

It's two constant-indexed dereferences *in total*, compared to a
single constant-indexed dereference in the pre-cgroup case.

The cpuset pointer is found at
task->cgroups->subsys[cpuset_subsys_id], where cpuset_subsys_id is a
compile-time constant.

>
> At a minimum, could you change that last added line to use 'tsk'
> instead of 'current'?   This should save one instruction, as 'tsk'
> will likely already be in a register.

Sounds reasonable.

>
> I wonder if we can save any cache line hits on this, or if there is
> someway to measure whether or not this has noticeable performance
> impact.

I didn't notice any performance hit on a pure allocate/free memory
benchmark relative to non-cgroup cpusets. (There was a small
performance hit relative to not using cpusets at all, but that was to
be expected).

Paul
