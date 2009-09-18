Return-Path: <linux-kernel-owner+w=401wt.eu-S932129AbZIRUCO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129AbZIRUCO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 16:02:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758136AbZIRUCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 16:02:12 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:9318 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758124AbZIRUCG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 16:02:06 -0400
X-SpamScore: -27
X-BigFish: VPS-27(z5c5oz542N1432R98dN148cM9371Pzz1202hzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KQ6NL5-02-BZE-02
X-M-MSG: 
From: "Langsdorf, Mark" <mark.langsdorf@amd.com>
To: "'Ingo Molnar'" <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 18 Sep 2009 15:00:44 -0500
Subject: RE: [PATCH] Prevent immediate process rescheduling
Thread-Topic: [PATCH] Prevent immediate process rescheduling
Thread-Index: Aco4mfC/4nuCN9GpRwG0sRmwarh1JgAAC6Hw
Message-ID: <DDE95BDD51FB774B804A9C029E735EE10379BEDA2D@sausexmbp02.amd.com>
References: <200909181449.12311.mark.langsdorf@amd.com>
 <20090918195455.GC11726@elte.hu>
In-Reply-To: <20090918195455.GC11726@elte.hu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

> -----Original Message-----
> From: Ingo Molnar [mailto:mingo@elte.hu] 
> Sent: Friday, September 18, 2009 2:55 PM
> To: Langsdorf, Mark; Peter Zijlstra; Mike Galbraith
> Cc: linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] Prevent immediate process rescheduling
> 
> 
> (fixed the Cc: lines)
> 
> * Mark Langsdorf <mark.langsdorf@amd.com> wrote:
> 
> > Prevent the scheduler from immediately rescheduling a process
> > that just yielded if there is another process available.
> > 
> > Originally suggested by Mike Galbraith (efault@gmx.de).
> > 
> > Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>
> > ---
> >  kernel/sched_fair.c |   16 +++++++++++++++-
> >  1 files changed, 15 insertions(+), 1 deletions(-)
> > 
> > diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> > index 652e8bd..4fad08f 100644
> > --- a/kernel/sched_fair.c
> > +++ b/kernel/sched_fair.c
> > @@ -353,11 +353,25 @@ static void __dequeue_entity(struct 
> cfs_rq *cfs_rq, struct sched_entity *se)
> >  static struct sched_entity *__pick_next_entity(struct 
> cfs_rq *cfs_rq)
> >  {
> >  	struct rb_node *left = cfs_rq->rb_leftmost;
> > +	struct sched_entity *se, *curr;
> >  
> >  	if (!left)
> >  		return NULL;
> >  
> > -	return rb_entry(left, struct sched_entity, run_node);
> > +	se = rb_entry(left, struct sched_entity, run_node);
> > +	curr = &current->se;
> > +
> > +	/* 
> > +	 * Don't select the entity who just tried to schedule away
> > +	 * if there's another entity available.
> > +	 */
> > +	if (unlikely(se == curr && cfs_rq->nr_running > 1)) {
> > +		struct rb_node *next_node = rb_next(&curr->run_node);
> > +		if (next_node)
> > +			se = rb_entry(next_node, struct 
> sched_entity, run_node);
> > +	}
> > +
> > +	return se;
> >  }
> 
> I suspect some real workload is the motivation of this - what is that 
> workload?

Thanks for fixing the cc lines.

The next patch I submitted enables the Pause Filter feature
from the most recent AMD Operton processors.  Pause Filter
lets us detect when a KVM guest VCPU is spinning useless on
a contended lock because the lockholder VCPU isn't scheduled.
Ideally, we'd like to switch to that VCPU thread, but at a
minimum, we'd like to meaningful yield the contending VCPU.
This patch prevents schedule() from just rescheduling the
thread that is trying to yield, and didn't have any
performance regressions in my tests.

-Mark Langsdorf
Operating System Research Center
AMD
