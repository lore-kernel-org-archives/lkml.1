Return-Path: <linux-kernel-owner+w=401wt.eu-S1753525AbZCCIIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525AbZCCIIh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 03:08:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758886AbZCCII0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 03:08:26 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:32893 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752842AbZCCIIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 03:08:25 -0500
Date: Tue, 3 Mar 2009 09:07:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] Allow cpusets to be configured/built on non-SMP systems
Message-ID: <20090303080734.GB11484@elte.hu>
References: <20090303013432.11211.18662.stgit@menage.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090303013432.11211.18662.stgit@menage.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Menage <menage@google.com> wrote:

> Allow cpusets to be configured/built on non-SMP systems
> 
> Currently it's impossible to build cpusets under UML on x86-64, since
> cpusets depends on SMP and x86-64 UML doesn't support SMP.
> 
> There's code in cpusets that doesn't depend on SMP.  This patch
> surrounds the minimum amount of cpusets code with #ifdef CONFIG_SMP in
> order to allow cpusets to build/run on UP systems (for testing
> purposes under UML).
> 
> Signed-off-by: Paul Menage <menage@google.com>
> 
> ---
> 
>  init/Kconfig    |    2 +-
>  kernel/cpuset.c |   14 ++++++++++++++
>  2 files changed, 15 insertions(+), 1 deletions(-)
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index 92d2c64..3f20aa2 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -477,7 +477,7 @@ config CGROUP_DEVICE
>  
>  config CPUSETS
>  	bool "Cpuset support"
> -	depends on SMP && CGROUPS
> +	depends on CGROUPS
>  	help
>  	  This option will let you create and manage CPUSETs which
>  	  allow dynamically partitioning a system into sets of CPUs and
> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> index a46d693..b4d12d8 100644
> --- a/kernel/cpuset.c
> +++ b/kernel/cpuset.c
>
> @@ -517,6 +517,8 @@ static int validate_change(const struct cpuset *cur, const struct cpuset *trial)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_SMP
> +
>  /*
>   * Helper routine for generate_sched_domains().
>   * Do cpusets a, b have overlapping cpus_allowed masks?
> @@ -811,6 +813,16 @@ static void do_rebuild_sched_domains(struct work_struct *unused)
>  
>  	put_online_cpus();
>  }
> +#else

Please use:

> +#else /* !CONFIG_SMP: */

to show that it's the UP branch - even if the #ifdef itself has 
scrolled off from screen already.

> +static void do_rebuild_sched_domains(struct work_struct *unused)
> +{
> +}
> +
> +static int generate_sched_domains(struct cpumask **domains,
> +			struct sched_domain_attr **attributes)
> +{
> +}
> +#endif // CONFIG_SMP

Please dont use C++ comments.

Looks good otherwise. (Btw., please try to Cc: PeterZ and me to 
cpusets patches in the future, especially when it affects the 
scheduler.)

	Ingo
