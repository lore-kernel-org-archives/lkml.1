Return-Path: <linux-kernel-owner+w=401wt.eu-S1754566AbZHYIEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbZHYIEj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 04:04:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753989AbZHYIEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 04:04:38 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:56618 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776AbZHYIEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 04:04:36 -0400
Date: Tue, 25 Aug 2009 13:34:33 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Gautham Shenoy <ego@in.ibm.com>,
       "svaidy@linux.vnet.ibm.com" <svaidy@linux.vnet.ibm.com>
Subject: Re: [PATCH 11/15] sched: Pass unlimited __cpu_power information to
	upper domain level groups
Message-ID: <20090825080433.GZ29572@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090820131243.GO29327@alberich.amd.com> <20090820134155.GZ29327@alberich.amd.com> <1251127297.7538.291.camel@twins> <20090824164452.GR29572@balbir.in.ibm.com> <1251134810.7538.320.camel@twins> <20090824181921.GT29572@balbir.in.ibm.com> <1251184274.7538.1085.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1251184274.7538.1085.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2009-08-25 09:11:14]:

> On Mon, 2009-08-24 at 23:49 +0530, Balbir Singh wrote:
> 
> > That reminds me, accounting is currently broken and should be based on
> > APER/MPERF (Power gets it right - based on SPURR).
> 
> What accounting?
> 


We need scaled time accounting for x86 (see *timescaled). By scaled
accounting I mean ratio of APERF/MPERF

> > > The trouble is that cpu_power is now abused for placement decisions too,
> > > and that needs to be taken out.
> > 
> > OK.. so you propose extending the static cpu_power to dynamic
> > cpu_power but based on current topology?
> 
> Right, so cpu_power is primarily used to normalize domain weight in the
> load-balancer.
> 
> Suppose a 4 core machine with 1 unplugged core:
> 
>  0,1,3
> 
> 0,1  3
> 
> The sd-0,1 will have cpu_power 2048, while the sd-3 will have 1024, this
> allowed find_busiest_group() for sd-0,1,3 to pick the one which is
> relatively most overloaded.
> 
> Supposing 3, 2, 2 (nice0) tasks on these cores, the domain weight of
> sd-0,1 is 5*1024 and sd-3 is 2*1024, normalized that becomes 5/2 and 2
> resp. which clearly shows sd-0,1 to be the busiest of the pair.
> 
> Now back in the days Nick wrote all this, he did the cpu_power hack for
> SMT which sets the combined cpu_power of 2 threads (that's all we had
> back then) to 1024, because two threads share 1 core, and are roughly as
> fast.
> 
> He then also used this to influence task placement, preferring to move
> tasks to another sibling domain before getting the second thread active,
> this worked.
> 
> Then multi-core with shared caches came along and people did the same
> trick for mc power save in order to get that placement stuff, but that
> horribly broke the load-balancer normalization.
> 
> Now comes multi-node, and people asking for more elaborate placement
> strategies and all this starts creaking like a ghost house about to
> collapse.
> 
> Therefore I want cpu_power back to load normalization only, and do the
> placement stuff with something else.
> 


What do you have in mind for the something else? Aren't normalization
and placement two sides of the same coin? My concern is that load
normalization might give different recommendations from the placement
stuff, then what do we do?

> Once cpu_power is pure again, we can start making it dynamic, for SMT we
> can utilize APERF/MPERF to guesstimate the actual work capacity of
> threads, and scaling cpu_power back based on RT time used on the cpu.
> 
> Then when we walk the domain tree for load-balancing we re-do the
> cpu_power sum, etc..
> 
> 

-- 
	Balbir
