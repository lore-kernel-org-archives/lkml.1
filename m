Return-Path: <linux-kernel-owner+w=401wt.eu-S1756691AbYKUSgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691AbYKUSgs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 13:36:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751445AbYKUSgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 13:36:40 -0500
Received: from smtp-out.google.com ([216.239.45.13]:17926 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbYKUSgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 13:36:39 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=aKNxDgpoQEyrk1nsf4VqXC5S61nChQgvBGRpdJxaR5BEhcdMXyYY+mNi6ZmETON5b
	UTpsIMURdilx202/CQJxQ==
MIME-Version: 1.0
In-Reply-To: <49267621.2070706@cn.fujitsu.com>
References: <49267621.2070706@cn.fujitsu.com>
Date: Fri, 21 Nov 2008 10:36:37 -0800
Message-ID: <6599ad830811211036k419ff716h6068d532c9942d73@mail.gmail.com>
Subject: Re: [PATCH] cpuset: rcu_read_lock() to protect task_cs()
From: Paul Menage <menage@google.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2008 at 12:49 AM, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
>
> task_cs() calls cgroup_subsys_state().

You mean it calls task_subsys_state().

>
> we must use rcu_read_lock() to protect cgroup_subsys_state().
>
> it's correct that top_cpuset is never freed, but cgroup_subsys_state()
> accesses css_set, this css_set maybe freed when task_cs() called.

It would be nice to have an RCU debug mode where rcu_dereference()
does a WARN() if it's invoked not under rcu_read_lock().

>
> we use use rcu_read_lock() to protect it.
>
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> index 3e00526..e0e087e 100644
> --- a/kernel/cpuset.c
> +++ b/kernel/cpuset.c
> @@ -363,14 +363,9 @@ void cpuset_update_task_memory_state(void)
>        struct task_struct *tsk = current;
>        struct cpuset *cs;
>
> -       if (task_cs(tsk) == &top_cpuset) {
> -               /* Don't need rcu for top_cpuset.  It's never freed. */
> -               my_cpusets_mem_gen = top_cpuset.mems_generation;
> -       } else {
> -               rcu_read_lock();
> -               my_cpusets_mem_gen = task_cs(tsk)->mems_generation;
> -               rcu_read_unlock();
> -       }
> +       rcu_read_lock();
> +       my_cpusets_mem_gen = task_cs(tsk)->mems_generation;
> +       rcu_read_unlock();

Yes, I guess this old cpusets assumption is no longer valid in cgroups.

Acked-by: Paul Menage <menage@google.com>

Thanks

Paul
