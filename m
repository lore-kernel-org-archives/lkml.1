Return-Path: <linux-kernel-owner+w=401wt.eu-S1756013AbXJBUXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013AbXJBUXR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 16:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753472AbXJBUXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 16:23:06 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:39258 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509AbXJBUXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 16:23:05 -0400
Date: Tue, 2 Oct 2007 13:22:14 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Paul Jackson <pj@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, nickpiggin@yahoo.com.au,
       Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       Dinakar Guniguntala <dino@in.ibm.com>, cpw@sgi.com,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] cpuset and sched domains: sched_load_balance flag
Message-Id: <20071002132214.330ae2ca.randy.dunlap@oracle.com>
In-Reply-To: <20070930104403.24828.48263.sendpatchset@jackhammer.engr.sgi.com>
References: <20070930104403.24828.48263.sendpatchset@jackhammer.engr.sgi.com>
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

On Sun, 30 Sep 2007 03:44:03 -0700 Paul Jackson wrote:

> From: Paul Jackson <pj@sgi.com>
> 
...
> 
> Acked-by: Paul Jackson <pj@sgi.com>

Are there some attributions missing, else S-O-B ?

> ---
> 
> Andrew - this patch goes right after your *-mm patch:
>   task-containers-enable-containers-by-default-in-some-configs.patch
> and before "add-containerstats-v3.patch"
> 
>  Documentation/cpusets.txt |  141 +++++++++++++++++++++++++
>  include/linux/sched.h     |    2 
>  kernel/cpuset.c           |  254 +++++++++++++++++++++++++++++++++++++++++++++-
>  kernel/sched.c            |   72 ++++++++++---
>  4 files changed, 450 insertions(+), 19 deletions(-)

> --- 2.6.23-rc8-mm1.orig/kernel/cpuset.c	2007-09-29 23:56:40.987962675 -0700
> +++ 2.6.23-rc8-mm1/kernel/cpuset.c	2007-09-29 23:57:51.148979999 -0700

>  /*
> + * Helper routine for rebuild_sched_domains().
> + * Do cpusets a, b have overlapping cpus_allowed masks?
> + */
> +
> +static int cpusets_overlap(struct cpuset *a, struct cpuset *b)

inline ?

> +{
> +	return cpus_intersects(a->cpus_allowed, b->cpus_allowed);
> +}
> +
...
> +
> +static void rebuild_sched_domains(void)
> +{
> +	struct kfifo *q;	/* queue of cpusets to be scanned */
> +	struct cpuset *cp;	/* scans q */
> +	struct cpuset **csa;	/* array of all cpuset ptrs */
> +	int csn;		/* how many cpuset ptrs in csa so far */
> +	int i, j, k;		/* indices for partition finding loops */
> +	cpumask_t *doms;	/* resulting partition; i.e. sched domains */
> +	int ndoms;		/* number of sched domains in result */
> +	int nslot;		/* next empty doms[] cpumask_t slot */
> +
> +	q = NULL; csa = NULL; doms = NULL;

That's not kernel style.  Use either (Andrew would say the second one):

	q = csa = doms = NULL;

or
	q = NULL;
	csa = NULL;
	doms = NULL;

> +
> +	/* Special case for the 99% of systems with one, full, sched domain */
> +	if (is_sched_load_balance(&top_cpuset)) {
> +		ndoms = 1;
> +		doms = kmalloc(sizeof(cpumask_t), GFP_KERNEL);
> +		*doms = top_cpuset.cpus_allowed;
> +		goto rebuild;
> +	}
> +
...

> +
> +rebuild:
> +	/* Have scheduler rebuild sched domains */
> +	lock_cpu_hotplug();
> +	partition_sched_domains(ndoms, doms);
> +	unlock_cpu_hotplug();
> +
> +done:
> +	if (q && !IS_ERR(q))
> +		kfree(q);
> +	if (csa)

Don't need the conditional: kfree(NULL) is OK.

> +		kfree(csa);
> +	/* Don't kfree(doms) -- partition_sched_domains() does that. */
> +}
> +
> +/*
>   * Call with manage_mutex held.  May take callback_mutex during call.
>   */

---
~Randy
