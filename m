Return-Path: <linux-kernel-owner+w=401wt.eu-S1422943AbXCGS2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422943AbXCGS2e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 13:28:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422972AbXCGS2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 13:28:34 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:51216 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422975AbXCGS2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 13:28:31 -0500
Date: Wed, 7 Mar 2007 10:25:22 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: cpw@sgi.com (Cliff Wickman)
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] hotplug cpu: migrate a task within its cpuset
Message-Id: <20070307102522.98b40c81.randy.dunlap@oracle.com>
In-Reply-To: <45EECB2C.mailxEK515UYJW@eag09.americas.sgi.com>
References: <45EECB2C.mailxEK515UYJW@eag09.americas.sgi.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 Mar 2007 08:24:44 -0600 Cliff Wickman wrote:

> 
> From: Cliff Wickman <cpw@sgi.com>
> 
> When a cpu is disabled, move_task_off_dead_cpu() is called for tasks
> that have been running on that cpu.
> 
> Currently, such a task is migrated:
>  1) to any cpu on the same node as the disabled cpu, which is both online
>     and among that task's cpus_allowed
>  2) to any cpu which is both online and among that task's cpus_allowed
> 
> But the task's cpus_allowed may have been a single cpu.
> 
> This patch would insert a preference to migrate such a task to a cpu within
> its cpuset (and set its cpus_allowed to its cpuset).
> 
> With this patch, migrate the task to:
>  1) to any cpu on the same node as the disabled cpu, which is both online
>     and among that task's cpus_allowed
>  2) to any online cpu within the task's cpuset
>  3) to any cpu which is both online and among that task's cpus_allowed
> 
> 
> Diffed against 2.6.16.37

Wow.  Why?
or did you want this applied only to the 2.6.16.* stable kernel?


|--- linux.orig/kernel/sched.c
|+++ linux/kernel/sched.c
--------------------------
Patching file kernel/sched.c using Plan A...
Hunk #1 succeeded at 5032 with fuzz 2 (offset 430 lines).
Hmm...  Ignoring the trailing garbage.
done


<me checks>

I'm surprised that none of Documentation/SubmittingPatches or
The Perfect Patch (http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt)
or Jeff Garzik's patch-format page (http://linux.yyz.us/patch-format.html)
(AFAICT) mention that patches should be made against "current" or
"recent" or "head of tree" or some such words.

I'll "fix" Doc/SubmittingPatches... and/or Doc/SubmitChecklist.



> Signed-off-by: Cliff Wickman <cpw@sgi.com>
> 
> ---
>  kernel/sched.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> Index: linux/kernel/sched.c
> ===================================================================
> --- linux.orig/kernel/sched.c
> +++ linux/kernel/sched.c
> @@ -4602,6 +4602,12 @@ static void move_task_off_dead_cpu(int d
>  	if (dest_cpu == NR_CPUS)
>  		dest_cpu = any_online_cpu(tsk->cpus_allowed);
>  
> +	/* try to stay on the same cpuset */
> +	if (dest_cpu == NR_CPUS) {
> +		tsk->cpus_allowed = cpuset_cpus_allowed(tsk);
> +		dest_cpu = any_online_cpu(tsk->cpus_allowed);
> +	}
> +
>  	/* No more Mr. Nice Guy. */
>  	if (dest_cpu == NR_CPUS) {
>  		cpus_setall(tsk->cpus_allowed);
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
