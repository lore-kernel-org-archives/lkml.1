Return-Path: <linux-kernel-owner+w=401wt.eu-S1759422AbZAGCFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759422AbZAGCFQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 21:05:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759263AbZAGCE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 21:04:58 -0500
Received: from ozlabs.org ([203.10.76.45]:55870 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759257AbZAGCE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 21:04:57 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/6] cpuset: convert cpuset_attach() to use cpumask_var_t
Date: Wed, 7 Jan 2009 12:34:50 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Mike Travis <travis@sgi.com>, Paul Menage <menage@google.com>,
       LKML <linux-kernel@vger.kernel.org>
References: <495B2EA6.7010808@cn.fujitsu.com> <4961C919.6040404@cn.fujitsu.com> <20090105010147.bc42b655.akpm@linux-foundation.org>
In-Reply-To: <20090105010147.bc42b655.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901071234.51646.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 January 2009 19:31:47 Andrew Morton wrote:
> On Mon, 05 Jan 2009 16:47:21 +0800 Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
> > Allocate a global cpumask_var_t at boot, and use it in cpuset_attach(), so
> > we won't fail cpuset_attach().
> > 
> > Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> > Acked-by: Mike Travis <travis@sgi.com>
> > ---
> >  kernel/cpuset.c |   14 +++++++++-----
> >  1 files changed, 9 insertions(+), 5 deletions(-)
> > 
> > diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> > index afa29cf..1e32e6b 100644
> > --- a/kernel/cpuset.c
> > +++ b/kernel/cpuset.c
> > @@ -1306,6 +1306,9 @@ static int fmeter_getrate(struct fmeter *fmp)
> >  	return val;
> >  }
> >  
> > +/* Protected by cgroup_lock */
> > +static cpumask_var_t cpus_attach;
> > +
> >  /* Called by cgroups to determine if a cpuset is usable; cgroup_mutex held */
> >  static int cpuset_can_attach(struct cgroup_subsys *ss,
> >  			     struct cgroup *cont, struct task_struct *tsk)
> > @@ -1330,7 +1333,6 @@ static void cpuset_attach(struct cgroup_subsys *ss,
> >  			  struct cgroup *cont, struct cgroup *oldcont,
> >  			  struct task_struct *tsk)
> >  {
> > -	cpumask_t cpus;
> >  	nodemask_t from, to;
> >  	struct mm_struct *mm;
> >  	struct cpuset *cs = cgroup_cs(cont);
> > @@ -1338,13 +1340,13 @@ static void cpuset_attach(struct cgroup_subsys *ss,
> >  	int err;
> >  
> >  	if (cs == &top_cpuset) {
> > -		cpus = cpu_possible_map;
> > +		cpumask_copy(cpus_attach, cpu_possible_mask);
> >  	} else {
> >  		mutex_lock(&callback_mutex);
> > -		guarantee_online_cpus(cs, &cpus);
> > +		guarantee_online_cpus(cs, cpus_attach);
> >  		mutex_unlock(&callback_mutex);
> >  	}
> > -	err = set_cpus_allowed_ptr(tsk, &cpus);
> > +	err = set_cpus_allowed_ptr(tsk, cpus_attach);
> >  	if (err)
> >  		return;
> >  
> > @@ -1357,7 +1359,6 @@ static void cpuset_attach(struct cgroup_subsys *ss,
> >  			cpuset_migrate_mm(mm, &from, &to);
> >  		mmput(mm);
> >  	}
> > -
> >  }
> >  
> >  /* The various types of files and directories in a cpuset file system */
> > @@ -1838,6 +1839,9 @@ int __init cpuset_init(void)
> >  	if (err < 0)
> >  		return err;
> >  
> > +	if (!alloc_cpumask_var(&cpus_attach, GFP_KERNEL))
> > +		BUG();
> > +
> >  	number_of_cpusets = 1;
> >  	return 0;
> >  }
> 
> OK, that works.
> 
> Do we need to dynamically allocate cpus_attach?  Can we just do
> 
> static cpumask_t cpus_attach;

Well, (1) we're deprecating the typedef, (2) we really want the NR_CPUS=16384
and nr_cpu_ids=4 case not to suck and this sets a bad example, but moreover
(3) struct cpumask won't be defined eventually when CONFIG_CPUMASKS_OFFSTACK=y
so that won't compile.

Cheers,
Rusty.
