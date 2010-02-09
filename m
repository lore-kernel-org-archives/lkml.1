Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853Ab0BIJvA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 04:51:00 -0500
Received: from mail-pz0-f201.google.com ([209.85.222.201]:49849 "EHLO
	mail-pz0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075Ab0BIJu6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 04:50:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FsOTp6a6z7YCGt2KuVcxxE8o1QvSxzVG/tAa7GRnLm+DItWWMUpl3GiUzJR7YwkEVO
         kWz0g97/fhEYTL1HC5WXm1NU3cHzgQ2jnvjmsPKj1+l0rUPO+I8wABVJXy9j8ZQYB1/E
         vMUWNnIwHHdplgxtqTBn2eeCZMn4BbFfj57a8=
MIME-Version: 1.0
In-Reply-To: <20100209091408.29971.63921.sendpatchset@localhost.localdomain>
References: <20100209091408.29971.63921.sendpatchset@localhost.localdomain>
Date: Tue, 9 Feb 2010 17:23:11 +0800
Message-ID: <7b6bb4a51002090123v2bdf1582ua0b78bc99dceeb81@mail.gmail.com>
Subject: Re: [Patch] cpufreq: fix a deadlock during shutting down
From: Xiaotian Feng <xtfeng@gmail.com>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Dave Jones <davej@redhat.com>, cpufreq@vger.kernel.org,
       Prarit Bhargava <prarit@redhat.com>, Thomas Renninger <trenn@suse.de>,
       akpm@linux-foundation.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 9, 2010 at 5:10 PM, Amerigo Wang <amwang@redhat.com> wrote:
>
> Benjamin reported that, the machine deadlocks right after printing the
> following when doing a shutdown:
>
> halt/4071 is trying to acquire lock:
>  (s_active){++++.+}, at: [<c0000000001ef868>] .sysfs_addrm_finish+0x58/0xc0
>
> but task is already holding lock:
>  (&per_cpu(cpu_policy_rwsem, cpu)){+.+.+.}, at: [<c0000000004cd6ac>] .lock_policy_rwsem_write+0x84/0xf4
>
> which lock already depends on the new lock.
>
> the existing dependency chain (in reverse order) is:
>
> <nothing else ... machine deadlocked here>
>
>
> This is because we are trying to kobject_put() a kobject while
> we are holding cpu policy rwsem. So just move kobject_put()
> down after releasing the rwsem.
>
> Totally untested.
>
> Reported-by: Xiaotian Feng <xtfeng@gmail.com>
> Reported-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Signed-off-by: WANG Cong <amwang@redhat.com>
> Cc: Dave Jones <davej@redhat.com>
> Cc: Thomas Renninger <trenn@suse.de>
> Cc: Prarit Bhargava <prarit@redhat.com>
> Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
>
> ---
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 67bc2ec..222b35f 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -1113,6 +1113,7 @@ static int __cpufreq_remove_dev(struct sys_device *sys_dev)
>        unsigned int cpu = sys_dev->id;
>        unsigned long flags;
>        struct cpufreq_policy *data;
> +       struct kobject *kobj;
>  #ifdef CONFIG_SMP
>        struct sys_device *cpu_sys_dev;
>        unsigned int j;
> @@ -1192,7 +1193,7 @@ static int __cpufreq_remove_dev(struct sys_device *sys_dev)
>        if (cpufreq_driver->target)
>                __cpufreq_governor(data, CPUFREQ_GOV_STOP);
>
> -       kobject_put(&data->kobj);
> +       kobj = &data->kobj;
>
>        /* we need to make sure that the underlying kobj is actually
>         * not referenced anymore by anybody before we proceed with

Then kernel will wait_for_completion(&data->kobj_unregister); forever.....

> @@ -1207,6 +1208,7 @@ static int __cpufreq_remove_dev(struct sys_device *sys_dev)
>
>        unlock_policy_rwsem_write(cpu);
>
> +       kobject_put(kobj);
>        free_cpumask_var(data->related_cpus);
>        free_cpumask_var(data->cpus);
>        kfree(data);
>
