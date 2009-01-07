Return-Path: <linux-kernel-owner+w=401wt.eu-S1756688AbZAGQjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688AbZAGQjy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 11:39:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752485AbZAGQjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 11:39:45 -0500
Received: from smtp-out.google.com ([216.239.45.13]:18845 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618AbZAGQjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 11:39:44 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:
	x-gmailtapped-by:x-gmailtapped;
	b=UgQHpXXgi/ug2U3JNbOauRYgkTp14RS7ybcTP3b7vbRtORAoowqTXdU4nSmC52YVf
	Q3mlu6emcA8OXdtReSFKQ==
MIME-Version: 1.0
In-Reply-To: <4961C919.6040404@cn.fujitsu.com>
References: <495B2EA6.7010808@cn.fujitsu.com> <495B2EC2.9090305@cn.fujitsu.com>
	 <495B2EE7.4040406@cn.fujitsu.com> <495B2EFB.302@cn.fujitsu.com>
	 <20090104233856.8c72eb58.akpm@linux-foundation.org>
	 <4961C919.6040404@cn.fujitsu.com>
Date: Wed, 7 Jan 2009 08:39:39 -0800
Message-ID: <6599ad830901070839x4c631d5drd16d118a95ff3d0c@mail.gmail.com>
Subject: Re: [PATCH 3/6] cpuset: convert cpuset_attach() to use cpumask_var_t
From: Paul Menage <menage@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.25.146.38
X-GMailtapped: menage
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 5, 2009 at 12:47 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>
> [PATCH 3/6] cpuset: convert cpuset_attach() to use cpumask_var_t
>
> Allocate a global cpumask_var_t at boot, and use it in cpuset_attach(), so
> we won't fail cpuset_attach().
>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> Acked-by: Mike Travis <travis@sgi.com>

OK, this version looks fine.

Acked-by: Paul Menage <menage@google.com>

> ---
>  kernel/cpuset.c |   14 +++++++++-----
>  1 files changed, 9 insertions(+), 5 deletions(-)
>
> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> index afa29cf..1e32e6b 100644
> --- a/kernel/cpuset.c
> +++ b/kernel/cpuset.c
> @@ -1306,6 +1306,9 @@ static int fmeter_getrate(struct fmeter *fmp)
>        return val;
>  }
>
> +/* Protected by cgroup_lock */
> +static cpumask_var_t cpus_attach;
> +
>  /* Called by cgroups to determine if a cpuset is usable; cgroup_mutex held */
>  static int cpuset_can_attach(struct cgroup_subsys *ss,
>                             struct cgroup *cont, struct task_struct *tsk)
> @@ -1330,7 +1333,6 @@ static void cpuset_attach(struct cgroup_subsys *ss,
>                          struct cgroup *cont, struct cgroup *oldcont,
>                          struct task_struct *tsk)
>  {
> -       cpumask_t cpus;
>        nodemask_t from, to;
>        struct mm_struct *mm;
>        struct cpuset *cs = cgroup_cs(cont);
> @@ -1338,13 +1340,13 @@ static void cpuset_attach(struct cgroup_subsys *ss,
>        int err;
>
>        if (cs == &top_cpuset) {
> -               cpus = cpu_possible_map;
> +               cpumask_copy(cpus_attach, cpu_possible_mask);
>        } else {
>                mutex_lock(&callback_mutex);
> -               guarantee_online_cpus(cs, &cpus);
> +               guarantee_online_cpus(cs, cpus_attach);
>                mutex_unlock(&callback_mutex);
>        }
> -       err = set_cpus_allowed_ptr(tsk, &cpus);
> +       err = set_cpus_allowed_ptr(tsk, cpus_attach);
>        if (err)
>                return;
>
> @@ -1357,7 +1359,6 @@ static void cpuset_attach(struct cgroup_subsys *ss,
>                        cpuset_migrate_mm(mm, &from, &to);
>                mmput(mm);
>        }
> -
>  }
>
>  /* The various types of files and directories in a cpuset file system */
> @@ -1838,6 +1839,9 @@ int __init cpuset_init(void)
>        if (err < 0)
>                return err;
>
> +       if (!alloc_cpumask_var(&cpus_attach, GFP_KERNEL))
> +               BUG();
> +
>        number_of_cpusets = 1;
>        return 0;
>  }
> --
> 1.5.4.rc3
>
>
>
