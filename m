Return-Path: <linux-kernel-owner+w=401wt.eu-S1751790AbZHYIbN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790AbZHYIbN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 04:31:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751156AbZHYIbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 04:31:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:45706 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbZHYIbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 04:31:12 -0400
Subject: Re: [PATCH 11/15] sched: Pass unlimited __cpu_power information to
 upper domain level groups
From: Peter Zijlstra <peterz@infradead.org>
To: balbir@linux.vnet.ibm.com
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Gautham Shenoy <ego@in.ibm.com>,
       "svaidy@linux.vnet.ibm.com" <svaidy@linux.vnet.ibm.com>
In-Reply-To: <20090825080433.GZ29572@balbir.in.ibm.com>
References: <20090820131243.GO29327@alberich.amd.com>
	 <20090820134155.GZ29327@alberich.amd.com> <1251127297.7538.291.camel@twins>
	 <20090824164452.GR29572@balbir.in.ibm.com>
	 <1251134810.7538.320.camel@twins>
	 <20090824181921.GT29572@balbir.in.ibm.com>
	 <1251184274.7538.1085.camel@twins>
	 <20090825080433.GZ29572@balbir.in.ibm.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 25 Aug 2009 10:30:17 +0200
Message-Id: <1251189017.7538.1114.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-25 at 13:34 +0530, Balbir Singh wrote:
> * Peter Zijlstra <peterz@infradead.org> [2009-08-25 09:11:14]:
> 
> > On Mon, 2009-08-24 at 23:49 +0530, Balbir Singh wrote:
> > 
> > > That reminds me, accounting is currently broken and should be based on
> > > APER/MPERF (Power gets it right - based on SPURR).
> > 
> > What accounting?
> > 
> 
> 
> We need scaled time accounting for x86 (see *timescaled). By scaled
> accounting I mean ratio of APERF/MPERF

Runtime accounting? I don't see why that would need to be scaled by a/m,
we're accounting wall-time, not a virtual time quantity that represents
work.

> > > > The trouble is that cpu_power is now abused for placement decisions too,
> > > > and that needs to be taken out.
> > > 
> > > OK.. so you propose extending the static cpu_power to dynamic
> > > cpu_power but based on current topology?
> > 
> > Right, so cpu_power is primarily used to normalize domain weight in the
> > load-balancer.
> > 
> > Suppose a 4 core machine with 1 unplugged core:
> > 
> >  0,1,3
> > 
> > 0,1  3
> > 
> > The sd-0,1 will have cpu_power 2048, while the sd-3 will have 1024, this
> > allowed find_busiest_group() for sd-0,1,3 to pick the one which is
> > relatively most overloaded.
> > 
> > Supposing 3, 2, 2 (nice0) tasks on these cores, the domain weight of
> > sd-0,1 is 5*1024 and sd-3 is 2*1024, normalized that becomes 5/2 and 2
> > resp. which clearly shows sd-0,1 to be the busiest of the pair.
> > 
> > Now back in the days Nick wrote all this, he did the cpu_power hack for
> > SMT which sets the combined cpu_power of 2 threads (that's all we had
> > back then) to 1024, because two threads share 1 core, and are roughly as
> > fast.
> > 
> > He then also used this to influence task placement, preferring to move
> > tasks to another sibling domain before getting the second thread active,
> > this worked.
> > 
> > Then multi-core with shared caches came along and people did the same
> > trick for mc power save in order to get that placement stuff, but that
> > horribly broke the load-balancer normalization.
> > 
> > Now comes multi-node, and people asking for more elaborate placement
> > strategies and all this starts creaking like a ghost house about to
> > collapse.
> > 
> > Therefore I want cpu_power back to load normalization only, and do the
> > placement stuff with something else.
> > 

> What do you have in mind for the something else? Aren't normalization
> and placement two sides of the same coin? My concern is that load
> normalization might give different recommendations from the placement
> stuff, then what do we do?

They are related but not the same. People have been asking for placement
policies that exceed the relation.

Also the current ties between them are already strained on multi-level
placement policies.

So what I'd like to see is move all placement decisions to SD_flags and
restore cpu_power to a straight sum of work capacity.
