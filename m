Return-Path: <linux-kernel-owner+w=401wt.eu-S1759017AbXJCSLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759017AbXJCSLm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 14:11:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757699AbXJCSLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 14:11:25 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:40722 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757493AbXJCSLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 14:11:24 -0400
Date: Wed, 3 Oct 2007 11:06:10 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Andrew Morton <akpm@osdl.org>, Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org, Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 1/3] Introduce the dummy_pid
Message-Id: <20071003110610.08156d75.randy.dunlap@oracle.com>
In-Reply-To: <4703A4D5.3000100@openvz.org>
References: <4703A44F.9020402@openvz.org>
	<4703A4D5.3000100@openvz.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Oct 2007 18:19:01 +0400 Pavel Emelyanov wrote:

> This is a pid which is attached to tasks when they detach
> their pids. This is done in detach_pid() and transfer_pid().
> The pid_alive() check is changed to reflect this fact.
> 
> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
> 
> ---
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 4f21af1..e17b8f8 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1286,9 +1286,11 @@ static inline pid_t task_ppid_nr_ns(stru
>   * If pid_alive fails, then pointers within the task structure
>   * can be stale and must not be dereferenced.
>   */
> +extern struct pid dummy_pid;
> +
>  static inline int pid_alive(struct task_struct *p)
>  {
> -	return p->pids[PIDTYPE_PID].pid != NULL;
> +	return p->pids[PIDTYPE_PID].pid != &dummy_pid;
>  }
>  
>  /**
> diff --git a/kernel/pid.c b/kernel/pid.c
> index d7388d7..b7a11cf 100644
> --- a/kernel/pid.c
> +++ b/kernel/pid.c
> @@ -81,6 +81,17 @@ struct pid_namespace init_pid_ns = {
>  };
>  EXPORT_SYMBOL_GPL(init_pid_ns);
>  
> +struct pid dummy_pid = {
> +	.count 		= ATOMIC_INIT(1),
> +	.numbers	= { {
> +		.nr		= 0,		/* this is what pid_nr will return
> +						 * for tasks with no pids
> +						 */
> +		.ns		= &init_pid_ns,
> +	}, }
> +};
> +EXPORT_SYMBOL(dummy_pid);

Why is the EXPORT_SYMBOL() needed?
IOW, is some loadable module going to use this?

---
~Randy
