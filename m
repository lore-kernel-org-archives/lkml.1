Return-Path: <linux-kernel-owner+w=401wt.eu-S1753338AbYJ1Alw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbYJ1Alw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 20:41:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752035AbYJ1Alo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 20:41:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58404 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751723AbYJ1Aln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 20:41:43 -0400
Date: Mon, 27 Oct 2008 17:41:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: menage@google.com, linux-kernel@vger.kernel.org
Subject: Re: [patch] oom: print triggering task's cpuset and mems allowed
Message-Id: <20081027174136.c97687c7.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.1.10.0810241714290.16902@chino.kir.corp.google.com>
References: <alpine.DEB.1.10.0810241704380.15988@chino.kir.corp.google.com>
	<alpine.DEB.1.10.0810241714290.16902@chino.kir.corp.google.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Oct 2008 17:15:32 -0700 (PDT)
David Rientjes <rientjes@google.com> wrote:

> +#ifdef CONFIG_CPUSETS
> +#define BUFFER_LEN	(256)
> +
> +static void print_task_cpuset(struct task_struct *p)
> +{
> +	char buffer[BUFFER_LEN];
> +
> +	if (cpuset_get_name(p, BUFFER_LEN, buffer) > 0) {
> +		char nodelist[BUFFER_LEN];
> +
> +		nodelist_scnprintf(nodelist, BUFFER_LEN, p->mems_allowed);
> +		printk(KERN_ERR "%s cpuset=%s mems_allowed=%s\n",
> +		       p->comm, buffer, nodelist);
> +	}
> +}
> +#else
> +static inline void print_task_cpuset(struct task_struct *p)
> +{
> +}
> +#endif
> +
>  /*
>   * Send SIGKILL to the selected  process irrespective of  CAP_SYS_RAW_IO
>   * flag though it's unlikely that  we select a process with CAP_SYS_RAW_IO
> @@ -391,6 +412,7 @@ static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
>  		printk(KERN_WARNING "%s invoked oom-killer: "
>  			"gfp_mask=0x%x, order=%d, oomkilladj=%d\n",
>  			current->comm, gfp_mask, order, current->oomkilladj);
> +		print_task_cpuset(current);
>  		dump_stack();
>  		show_mem();
>  		if (sysctl_oom_dump_tasks)

We can call the oom-killer at very very deep nesting levels, and adding
another 512 bytes of stack consuption to that call path is really
risky.  Perhaps use statically allocated buffers protected by a local
spinlock?

Also, 256 bytes might be overkill for storing the cpuset's name?

Also, it's Just Wrong that this code has to hardwire private knowledge
of the max possible length of a cpuset name and of the
nodelist_scnprintf() return string.  These things should be controlled
by a single #define in a shared header file.


