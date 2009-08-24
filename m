Return-Path: <linux-kernel-owner+w=401wt.eu-S1752969AbZHXSTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969AbZHXSTZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 14:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752630AbZHXSTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 14:19:25 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:55935 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbZHXSTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 14:19:24 -0400
Date: Mon, 24 Aug 2009 23:49:21 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Gautham Shenoy <ego@in.ibm.com>,
       "svaidy@linux.vnet.ibm.com" <svaidy@linux.vnet.ibm.com>
Subject: Re: [PATCH 11/15] sched: Pass unlimited __cpu_power information to
	upper domain level groups
Message-ID: <20090824181921.GT29572@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090820131243.GO29327@alberich.amd.com> <20090820134155.GZ29327@alberich.amd.com> <1251127297.7538.291.camel@twins> <20090824164452.GR29572@balbir.in.ibm.com> <1251134810.7538.320.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1251134810.7538.320.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2009-08-24 19:26:50]:

> On Mon, 2009-08-24 at 22:14 +0530, Balbir Singh wrote:
> > * Peter Zijlstra <peterz@infradead.org> [2009-08-24 17:21:37]:
> > 
> > > On Thu, 2009-08-20 at 15:41 +0200, Andreas Herrmann wrote:
> > > > For performance reasons __cpu_power in a sched_group might be limited
> > > > such that the group can handle only one task. To correctly calculate
> > > > the capacity in upper domain level groups the unlimited power
> > > > information is required. This patch stores unlimited __cpu_power
> > > > information in sched_groups.orig_power and uses this when calculating
> > > > __cpu_power in upper domain level groups.
> > > 
> > > OK, so this tries to fix the cpu_power wreckage?
> > > 
> > > ok, so let me try this with an example:
> > > 
> > > 
> > > Suppose we have a dual-core with shared cache and SMT
> > > 
> > >   0-3     MC
> > > 0-1 2-3   SMT
> > > 
> > > Then both levels fancy setting SHARED_RESOURCES and both levels end up
> > > normalizing the cpu_power to 1, so when we unplug cpu 2, load-balancing
> > > gets all screwy because the whole system doesn't get normalized
> > > properly.
> > > 
> > > What you propose here is every time we muck with cpu_power we keep the
> > > real stuff in orig_power and use that to compute the level above.
> > > 
> > > Except you don't use it in the load-balancer proper, so normalization is
> > > still hosed.
> > > 
> > > Its a creative solution, but I'd rather see cpu_power returned to a
> > > straight sum of actual power to normalize the inter-cpu runqueue weights
> > > and do the placement decision using something else.
> > 
> > The real solution is to find a way to solve asymmetric load balancing,
> > I suppose. The asymmetry might be due to cores being hot-plugged for
> > example
> 
> No, the solution is to not use cpu_power for placement and use it for
> normalization of the weight only. That would make the asym work by
> definition.
> 
> The real fun comes when we then introduce dynamic cpu_power based on
> feedback from things like aperf/mperf ratios for SMT and feedback from
> the RT scheduler.
>

That reminds me, accounting is currently broken and should be based on
APER/MPERF (Power gets it right - based on SPURR).
 
> The trouble is that cpu_power is now abused for placement decisions too,
> and that needs to be taken out.

OK.. so you propose extending the static cpu_power to dynamic
cpu_power but based on current topology?

-- 
	Balbir
