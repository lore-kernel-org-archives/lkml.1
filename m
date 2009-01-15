Return-Path: <linux-kernel-owner+w=401wt.eu-S1756159AbZAOLlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159AbZAOLlk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 06:41:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753276AbZAOLlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 06:41:31 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44559 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244AbZAOLlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 06:41:31 -0500
Subject: Re: [BUG] How to get real-time priority using idle priority
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mike Galbraith <efault@gmx.de>
Cc: Brian Rogers <brian@xyzw.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1232019428.5720.8.camel@marge.simson.net>
References: <4969D0D7.2060401@xyzw.org>
	 <1231736941.6003.7.camel@marge.simson.net>
	 <1231765433.5789.35.camel@marge.simson.net> <20090112131406.GB670@elte.hu>
	 <496BE8F6.1040308@xyzw.org>  <1232011723.26761.36.camel@marge.simson.net>
	 <1232014456.8870.26.camel@laptop>
	 <1232015423.13856.5.camel@marge.simson.net>
	 <1232019428.5720.8.camel@marge.simson.net>
Content-Type: text/plain
Date: Thu, 15 Jan 2009 12:41:26 +0100
Message-Id: <1232019686.8870.45.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-15 at 12:37 +0100, Mike Galbraith wrote:
> On Thu, 2009-01-15 at 11:30 +0100, Mike Galbraith wrote:
> > On Thu, 2009-01-15 at 11:14 +0100, Peter Zijlstra wrote:
> > >
> > > Which leads me to suggest the following
> > > 
> > > ---
> > > diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> > > index 8e1352c..f2d2d94 100644
> > > --- a/kernel/sched_fair.c
> > > +++ b/kernel/sched_fair.c
> > > @@ -283,7 +283,7 @@ static void update_min_vruntime(struct cfs_rq
> > > *cfs_rq)
> > >  						   struct sched_entity,
> > >  						   run_node);
> > >  
> > > -		if (vruntime == cfs_rq->min_vruntime)
> > > +		if (!cfs_rq->curr)
> > >  			vruntime = se->vruntime;
> > >  		else
> > >  			vruntime = min_vruntime(vruntime, se->vruntime);
> > 
> > Aha.  Yeah, I'll re-test with that instead.
> 
> Works a treat.

*cheer* lets get this merged asap, and CC -stable as well.

> > > The below can be split into 3 patches:
> > > 
> > >  - the idle weight change (do we really need that? why?)
> > 
> > I saw idle tasks slamming extremely far.  I'll verify, less is more.
> 
> time advanced in 100ms
> weight=2
> 64765.988352
> 67012.881408
> 88501.412352
> 
> weight=3
> 35496.181411
> 34130.971298
> 35497.411573
> 
> Measured from an RT shell doing..
>    while sleep .1; do cat /proc/sched_debug >> /debug; done
> ...for a pinned chew.  Not necessarily gnats-arse accurate, but good
> enough to see the margin of error is pretty high with weight=2.
> 
> Your call.

Right, 3 does look more stable, ok lets go with that.

Thanks Mike!

