Return-Path: <linux-kernel-owner+w=401wt.eu-S1767604AbXCJAE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767604AbXCJAE2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 19:04:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767659AbXCJAE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 19:04:28 -0500
Received: from lollipop.listbox.com ([208.210.124.78]:39648 "EHLO
	lollipop.listbox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767604AbXCJAE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 19:04:27 -0500
Date: Fri, 9 Mar 2007 17:58:59 -0600
From: Nathan Lynch <ntl@pobox.com>
To: Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] hotplug cpu: migrate a task within its cpuset
Message-ID: <20070309235859.GA20093@localdomain>
References: <20070309193925.B60891B8028@attica.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070309193925.B60891B8028@attica.americas.sgi.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello-

Cliff Wickman wrote:
> This patch would insert a preference to migrate such a task to a cpu within
> its cpuset (and set its cpus_allowed to its cpuset).
> 
> With this patch, migrate the task to:
>  1) to any cpu on the same node as the disabled cpu, which is both online
>     and among that task's cpus_allowed
>  2) to any online cpu within the task's cpuset
>  3) to any cpu which is both online and among that task's cpus_allowed

I think I disagree with this change.

The kernel shouldn't have to be any smarter than it already is about
moving tasks off an offlined cpu.  The only way case 2) can be reached
is if the user has changed a task's cpu affinity.  If the user is
sophisticated enough to manipulate tasks' cpu affinity then they can
arrange to migrate tasks as they see fit before offlining a cpu.

Furthermore:

> --- morton.070123.orig/kernel/sched.c
> +++ morton.070123/kernel/sched.c
> @@ -5170,6 +5170,12 @@ restart:
>  	if (dest_cpu == NR_CPUS)
>  		dest_cpu = any_online_cpu(p->cpus_allowed);
>  
> +	/* try to stay on the same cpuset */
> +	if (dest_cpu == NR_CPUS) {
> +		p->cpus_allowed = cpuset_cpus_allowed(p);
> +		dest_cpu = any_online_cpu(p->cpus_allowed);
> +	}

It's not okay to call cpuset_cpus_allowed in this context -- local
irqs are supposed to have been disabled by the caller of
move_task_off_dead_cpu and cpuset_cpus_allowed acquires a mutex.


