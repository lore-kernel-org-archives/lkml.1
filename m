Return-Path: <linux-kernel-owner+w=401wt.eu-S1755856AbZD2GIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856AbZD2GIu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 02:08:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752548AbZD2GIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 02:08:37 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:40412 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045AbZD2GIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 02:08:37 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [PATCH] cpuacct: VIRT_CPU_ACCOUNTING don't prevent percpu cputime count
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       Balaji Rao <balajirrao@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       seto.hidetoshi@jp.fujitsu.com
In-Reply-To: <20090429054453.GA789@balbir.in.ibm.com>
References: <20090429111558.4B0B.A69D9226@jp.fujitsu.com> <20090429054453.GA789@balbir.in.ibm.com>
Message-Id: <20090429150116.4B1A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Wed, 29 Apr 2009 15:08:34 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > This will make the end result very off the real value due to large
> > > batch value per cpu. If we are going to go this route, we should
> > > probably consider using __percpu_counter_sum so that the batch value
> > > does not show data that is way off.
> > 
> > No problem.
> > 
> > end-user don't see cputime itself. they see converted time.
> > cpuacct_stats_show() use cputime64_to_clock_t. it mean
> > the value less than 10msec don't display.
> >
> 
> Yes, I know, I reviewed Bharata's patch and suggested converting to
> clock_t for consistency with other metrics.

Oh, sorry.
I didn't know this.


> > --------------------------------------------------------
> > static int cpuacct_stats_show(struct cgroup *cgrp, struct cftype *cft,
> >                 struct cgroup_map_cb *cb)
> > {
> >         struct cpuacct *ca = cgroup_ca(cgrp);
> >         int i;
> > 
> >         for (i = 0; i < CPUACCT_STAT_NSTATS; i++) {
> >                 s64 val = percpu_counter_read(&ca->cpustat[i]);
> 
> My point is, this should probably be percpu_counter_sum(), but that
> can be expensive and we were willing to tollerate some inaccuracy due
> to batch value, I think your patch adds to the inaccuracy even more,
> even though it fixes a genuine problem.

Not expensive.
cpuacct_stats_show() is only called when reading stat file.
it definitely slow-path.
I think we can use percpu_counter_sum().

However, I doubt its worth.

before my patch:
  VIRT_CPU_ACCOUNTING=y:  accuracy but slow
  VIRT_CPU_ACCOUNTING=n:  inaccuracy few tick but fast

my patch
  VIRT_CPU_ACCOUNTING=y:  inaccuracy few tick but fast
  VIRT_CPU_ACCOUNTING=n:  inaccuracy few tick but fast

if my inaccuracy is wrong, current code is also crap when VIRT_CPU_ACCOUNTING=n.
I only make const accuracy to VIRT_CPU_ACCOUNTING=y and n.

Thought?
Although you still think percpu_counter_sum() is better, I can do it.


> 
> 
> >                 val = cputime64_to_clock_t(val);
> >                 cb->fill(cb, cpuacct_stat_desc[i], val);
> >         }
> >         return 0;
> > }
> > --------------------------------------------------------


