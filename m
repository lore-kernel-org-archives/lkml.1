Return-Path: <linux-kernel-owner+w=401wt.eu-S1753277Ab0AROdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab0AROdb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 09:33:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752890Ab0AROda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 09:33:30 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:41057 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850Ab0AROda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 09:33:30 -0500
Subject: Re: [PATCH] perf_events: improve x86 event scheduling (v5)
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
In-Reply-To: <bd4cb8901001180612g29369150h9db09470fa6000af@mail.gmail.com>
References: <4b5430c6.0f975e0a.1bf9.ffff85fe@mx.google.com>
	 <20100118134324.GB10364@nowhere> <1263822898.4283.558.camel@laptop>
	 <bd4cb8901001180612g29369150h9db09470fa6000af@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jan 2010 15:33:03 +0100
Message-ID: <1263825183.4283.593.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-18 at 15:12 +0100, Stephane Eranian wrote:
> > That said you do have a point, maybe we can express this particular
> > thing differently.. maybe a pre and post group call like:
> >
> >  void hw_perf_group_sched_in_begin(struct pmu *pmu)
> >  int  hw_perf_group_sched_in_end(struct pmu *pmu)
> >
> The issue with hw_perf_group_sched_in() is that because we do not know
> when we are done scheduling, we have to defer actual activation until
> hw_perf_enable(). But  we have to still mark the events as ACTIVE,
> otherwise things go wrong in the generic layer and for non-PMU events.
> That leads to partial duplication of event_sched_in()/event_sched_out()
> in the PMU specific layer.
> 
> As Frederic pointed out, the more natural way would be to simply rely
> on event_sched_in()/event_sched_out() and the rollback logic and just
> drop hw_perf_group_sched_in() which is there as an optimization and
> not for correctness. Scheduling can be done incrementally from the
> event_sched_in() function.
> 
> > That way we know we need to track more state for rollback and can give
> > the pmu implementation leeway to delay scheduling/availablility tests.
> >
> Rollback would still be handled by the generic code, wouldn't it?

I'm not sure I understand your reply. Sure dropping
hw_perf_group_sched_in() is still correct, but its also less optimal,
since we have to determine schedulability for each incremental event.



