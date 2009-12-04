Return-Path: <linux-kernel-owner+w=401wt.eu-S1756850AbZLDQKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850AbZLDQKm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 11:10:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752755AbZLDQKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 11:10:41 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:35714 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbZLDQKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 11:10:41 -0500
Subject: Re: [RFC v4 PATCH 2/7] sched: Bandwidth initialization for fair
 task groups
From: Peter Zijlstra <peterz@infradead.org>
To: bharata@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
       Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
       Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
       Mike Waychison <mikew@google.com>
In-Reply-To: <20091117143439.GM17335@in.ibm.com>
References: <20091117143306.GK17335@in.ibm.com>
	 <20091117143439.GM17335@in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Dec 2009 17:09:54 +0100
Message-ID: <1259942994.17907.894.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-17 at 20:04 +0530, Bharata B Rao wrote:

> +++ b/kernel/sched.c
> @@ -237,6 +237,15 @@ static DEFINE_MUTEX(sched_domains_mutex);
>  
>  #include <linux/cgroup.h>
>  
> +#if defined(CONFIG_FAIR_GROUP_SCHED) && defined(CONFIG_CFS_HARD_LIMITS)
> +struct cfs_bandwidth {
> +	spinlock_t		cfs_runtime_lock;
> +	ktime_t			cfs_period;
> +	u64			cfs_runtime;
> +	struct hrtimer		cfs_period_timer;
> +};
> +#endif
> +
>  struct cfs_rq;
>  
>  static LIST_HEAD(task_groups);

So what's wrong with using struct rt_bandwidth, aside from the name?

> @@ -445,6 +457,19 @@ struct cfs_rq {
>  	unsigned long rq_weight;
>  #endif
>  #endif
> +#ifdef CONFIG_CFS_HARD_LIMITS
> +	/* set when the group is throttled  on this cpu */
> +	int cfs_throttled;
> +
> +	/* runtime currently consumed by the group on this rq */
> +	u64 cfs_time;
> +
> +	/* runtime available to the group on this rq */
> +	u64 cfs_runtime;
> +
> +	/* Protects the cfs runtime related fields of this cfs_rq */
> +	spinlock_t cfs_runtime_lock;
> +#endif
>  };

If you put these 4 in a new struct, say rq_bandwidth, and also use that
for rt_rq, then I bet you can write patch 6 with a lot less copy/paste
action.

