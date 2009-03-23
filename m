Return-Path: <linux-kernel-owner+w=401wt.eu-S1756213AbZCWGgF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213AbZCWGgF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 02:36:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755005AbZCWGfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 02:35:51 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:34321 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754473AbZCWGfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 02:35:50 -0400
Date: Mon, 23 Mar 2009 12:06:03 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Balaji Rao <balajirrao@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH -tip] cpuacct: per-cgroup utime/stime statistics - v4
Message-ID: <20090323063603.GA15360@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20090323043538.GB3306@in.ibm.com> <20090323135528.ddf795f6.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090323135528.ddf795f6.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 23, 2009 at 01:55:28PM +0900, KAMEZAWA Hiroyuki wrote:
> On Mon, 23 Mar 2009 10:05:38 +0530
> Bharata B Rao <bharata@linux.vnet.ibm.com> wrote:
> 
> > Hi Ingo,
> > 
> > Here is the v4 of the cpuacct statistics patch to obtain per-cgroup
> > system and user times  with appropriate tags and complete changelog.
> > This applies against the latest -tip plus the cpuacct hierarchy fix v2
> > which I posted just now. Could you please include this in -tip ?
> > 
> > Changelog:
> > 
> > v4
> > - Remove comments in cpuacct_update_stats() which explained why rcu_read_lock()
> >   was needed (as per Peter Zijlstra's review comments).
> > - Don't say that percpu_counter_read() is broken in Documentation/cpuacct.txt
> >   as per KAMEZAWA Hiroyuki's review comments.
> > 
> Broken -> isn't safe ? no difference ;)

>From your comment last time, I thought you meant calling it broken would
be harsh.

> Can't this help you ?
> 
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
> Index: mmotm-2.6.29-Mar21/include/linux/percpu_counter.h
> ===================================================================
> --- mmotm-2.6.29-Mar21.orig/include/linux/percpu_counter.h
> +++ mmotm-2.6.29-Mar21/include/linux/percpu_counter.h
> @@ -62,6 +62,16 @@ static inline s64 percpu_counter_read(st
>  	return fbc->count;
>  }
> 
> +static inline s64 percpu_counter_read_safe(struct percpu_counter *fbc)
> +{
> +	s64 ret;
> +
> +	spin_lock(&fbc->lock);
> +	ret = fbc->count;
> +	spin_unlock(&fbc->lock);
> +	return ret;
> +}
> +
>  /*
>   * It is possible for the percpu_counter_read() to return a small negative
>   * number for some counter which should never be negative.
> @@ -114,6 +124,11 @@ static inline s64 percpu_counter_read(st
>  	return fbc->count;
>  }
> 
> +static inline s64 percpu_counter_read_safe(struct percpu_counter *fbc)
> +{
> +	return fbc->count;
> +}
> +
>  static inline s64 percpu_counter_read_positive(struct percpu_counter *fbc)
>  {
>  	return fbc->count;

Yes it helps, but for the records, let me note that it makes the readside
~20% slower.

[I measured time spent by cpuacct_stats_show(), which is part of
the read routine for cpuacct.stat by using kretprobe and for 100 reads
(or 100 executions of cpuacct_stats_show()), I get the following numbers:
percpu_counter_read() - 3166367 ns
percpu_counter_read_safe() - 3793546 ns which is ~20% slower. ]

I would prefer that this patch should be included in its current form
and we could separately fix percpu_counter_read() given that there
has been an attempt in the past to fix this (http://lkml.org/lkml/2008/8/27/303)

Moreover, I don't know how much acceptable it is to work around the problem
in percpu_counter_read() by introducing another variant
percpu_counter_read_safe().

Regards,
Bharata.
