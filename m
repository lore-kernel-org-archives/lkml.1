Return-Path: <linux-kernel-owner+w=401wt.eu-S1754004AbYKDOgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004AbYKDOgP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 09:36:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752182AbYKDOgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 09:36:00 -0500
Received: from casper.infradead.org ([85.118.1.10]:43047 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483AbYKDOf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 09:35:59 -0500
Subject: Re: RT sched: cpupri_vec lock contention with def_root_domain and
 no load balance
From: Peter Zijlstra <peterz@infradead.org>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Dimitri Sivanich <sivanich@sgi.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <49105D84.8070108@novell.com>
References: <20081103210748.GC9937@sgi.com>
	 <1225751603.7803.1640.camel@twins> <490FC735.1070405@novell.com>
	 <49105D84.8070108@novell.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 04 Nov 2008 15:36:33 +0100
Message-Id: <1225809393.7803.1669.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-11-04 at 09:34 -0500, Gregory Haskins wrote:
> Gregory Haskins wrote:
> > Peter Zijlstra wrote:
> >   
> >> On Mon, 2008-11-03 at 15:07 -0600, Dimitri Sivanich wrote:
> >>   
> >>     
> >>> When load balancing gets switched off for a set of cpus via the
> >>> sched_load_balance flag in cpusets, those cpus wind up with the
> >>> globally defined def_root_domain attached.  The def_root_domain is
> >>> attached when partition_sched_domains calls detach_destroy_domains().
> >>> A new root_domain is never allocated or attached as a sched domain
> >>> will never be attached by __build_sched_domains() for the non-load
> >>> balanced processors.
> >>>
> >>> The problem with this scenario is that on systems with a large number
> >>> of processors with load balancing switched off, we start to see the
> >>> cpupri->pri_to_cpu->lock in the def_root_domain becoming contended.
> >>> This starts to become much more apparent above 8 waking RT threads
> >>> (with each RT thread running on it's own cpu, blocking and waking up
> >>> continuously).
> >>>
> >>> I'm wondering if this is, in fact, the way things were meant to work,
> >>> or should we have a root domain allocated for each cpu that is not to
> >>> be part of a sched domain?  Note the the def_root_domain spans all of
> >>> the non-load-balanced cpus in this case.  Having it attached to cpus
> >>> that should not be load balancing doesn't quite make sense to me.
> >>>     
> >>>       
> >> It shouldn't be like that, each load-balance domain (in your case a
> >> single cpu) should get its own root domain. Gregory?
> >>   
> >>     
> >
> > Yeah, this sounds broken.  I know that the root-domain code was being
> > developed coincident to some upheaval with the cpuset code, so I suspect
> > something may have been broken from the original intent.  I will take a
> > look.
> >
> > -Greg
> >
> >   
> 
> After thinking about it some more, I am not quite sure what to do here. 
> The root-domain code was really designed to be 1:1 with a disjoint
> cpuset.  In this case, it sounds like all the non-balanced cpus are
> still in one default cpuset.  In that case, the code is correct to place
> all those cores in the singleton def_root_domain.  The question really
> is: How do we support the sched_load_balance flag better?
> 
> I suppose we could go through the scheduler code and have it check that
> flag before consulting the root-domain.  Another alternative is to have
> the sched_load_balance=false flag create a disjoint cpuset.  Any thoughts?

Hmm, but you cannot disable load-balance on a cpu without placing it in
an cpuset first, right?

Or are folks disabling load-balance bottom-up, instead of top-down?

In that case, I think we should dis-allow that.
