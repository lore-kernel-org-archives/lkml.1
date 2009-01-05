Return-Path: <linux-kernel-owner+w=401wt.eu-S1753050AbZAEIsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050AbZAEIsb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 03:48:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751728AbZAEIsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 03:48:23 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49673 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751632AbZAEIsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 03:48:22 -0500
Message-ID: <4961C919.6040404@cn.fujitsu.com>
Date: Mon, 05 Jan 2009 16:47:21 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Mike Travis <travis@sgi.com>, Paul Menage <menage@google.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/6] cpuset: convert cpuset_attach() to use cpumask_var_t
References: <495B2EA6.7010808@cn.fujitsu.com>	<495B2EC2.9090305@cn.fujitsu.com>	<495B2EE7.4040406@cn.fujitsu.com>	<495B2EFB.302@cn.fujitsu.com> <20090104233856.8c72eb58.akpm@linux-foundation.org>
In-Reply-To: <20090104233856.8c72eb58.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 31 Dec 2008 16:36:11 +0800 Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
>> Impact: reduce stack usage
>>
>> Allocate a cpumask_var_t in cpuset_can_attach() and then use it in
>> cpuset_attach(), so we won't fail cpuset_attach().
>>
>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
>> ---
>>  kernel/cpuset.c |   31 +++++++++++++++++++++++++------
>>  1 files changed, 25 insertions(+), 6 deletions(-)
>>
>> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
>> index afa29cf..b4c36d5 100644
>> --- a/kernel/cpuset.c
>> +++ b/kernel/cpuset.c
>> @@ -1306,6 +1306,14 @@ static int fmeter_getrate(struct fmeter *fmp)
>>  	return val;
>>  }
>>  
>> +/*
>> + * Since cpuset_attach() can't fail, we allocate a cpumask_var_t in
>> + * cpuset_can_attach() and then use it in cpuset_attach().
>> + *
>> + * Protected by cgroup_lock.
> 
> OK, but it's a bit fragile.
> 
> How are we to ensure that all calls to cpuset_can_attach() are followed
> by a call to cpuset_attach()

my fault :(

> and how are we to ensure that both calls
> are protected by the same taking of the lock?  For all time?
> 

It's insured by cgroup. The 2 functions are callbacks that will be called
by cgroup core only.

> In fact, it's broken right now, isn't it?  If cgroup_attach_task()'s
> call to find_css_set() fails, we leak the result of cpuset_can_attach()'s
> alloc_cpumask_var()?
> 

Below is a replacement:

=================

[PATCH 3/6] cpuset: convert cpuset_attach() to use cpumask_var_t

Allocate a global cpumask_var_t at boot, and use it in cpuset_attach(), so
we won't fail cpuset_attach().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Mike Travis <travis@sgi.com>
---
 kernel/cpuset.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index afa29cf..1e32e6b 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1306,6 +1306,9 @@ static int fmeter_getrate(struct fmeter *fmp)
 	return val;
 }
 
+/* Protected by cgroup_lock */
+static cpumask_var_t cpus_attach;
+
 /* Called by cgroups to determine if a cpuset is usable; cgroup_mutex held */
 static int cpuset_can_attach(struct cgroup_subsys *ss,
 			     struct cgroup *cont, struct task_struct *tsk)
@@ -1330,7 +1333,6 @@ static void cpuset_attach(struct cgroup_subsys *ss,
 			  struct cgroup *cont, struct cgroup *oldcont,
 			  struct task_struct *tsk)
 {
-	cpumask_t cpus;
 	nodemask_t from, to;
 	struct mm_struct *mm;
 	struct cpuset *cs = cgroup_cs(cont);
@@ -1338,13 +1340,13 @@ static void cpuset_attach(struct cgroup_subsys *ss,
 	int err;
 
 	if (cs == &top_cpuset) {
-		cpus = cpu_possible_map;
+		cpumask_copy(cpus_attach, cpu_possible_mask);
 	} else {
 		mutex_lock(&callback_mutex);
-		guarantee_online_cpus(cs, &cpus);
+		guarantee_online_cpus(cs, cpus_attach);
 		mutex_unlock(&callback_mutex);
 	}
-	err = set_cpus_allowed_ptr(tsk, &cpus);
+	err = set_cpus_allowed_ptr(tsk, cpus_attach);
 	if (err)
 		return;
 
@@ -1357,7 +1359,6 @@ static void cpuset_attach(struct cgroup_subsys *ss,
 			cpuset_migrate_mm(mm, &from, &to);
 		mmput(mm);
 	}
-
 }
 
 /* The various types of files and directories in a cpuset file system */
@@ -1838,6 +1839,9 @@ int __init cpuset_init(void)
 	if (err < 0)
 		return err;
 
+	if (!alloc_cpumask_var(&cpus_attach, GFP_KERNEL))
+		BUG();
+
 	number_of_cpusets = 1;
 	return 0;
 }
-- 
1.5.4.rc3


