Return-Path: <linux-kernel-owner+w=401wt.eu-S1751636Ab0ARNzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751636Ab0ARNzQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 08:55:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751253Ab0ARNzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 08:55:15 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52464 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190Ab0ARNzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 08:55:14 -0500
Subject: Re: [PATCH]  perf_events: improve x86 event scheduling (v5)
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
In-Reply-To: <20100118134324.GB10364@nowhere>
References: <4b5430c6.0f975e0a.1bf9.ffff85fe@mx.google.com>
	 <20100118134324.GB10364@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jan 2010 14:54:58 +0100
Message-ID: <1263822898.4283.558.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-18 at 14:43 +0100, Frederic Weisbecker wrote:
> 
> Shouldn't we actually use the core based pmu->enable(),disable()
> model called from kernel/perf_event.c:event_sched_in(),
> like every other events, where we can fill up the queue of hardware
> events to be scheduled, and then call a hw_check_constraints()
> when we finish a group scheduling? 

Well the thing that makes hw_perf_group_sched_in() useful is that you
can add a bunch of events and not have to reschedule for each one, but
instead do a single schedule pass.

That said you do have a point, maybe we can express this particular
thing differently.. maybe a pre and post group call like:

 void hw_perf_group_sched_in_begin(struct pmu *pmu)
 int  hw_perf_group_sched_in_end(struct pmu *pmu)

That way we know we need to track more state for rollback and can give
the pmu implementation leeway to delay scheduling/availablility tests.

Paul, would that work for you too?

Then there's still the question of having events of multiple hw pmus in
a single group, I'd be perfectly fine with saying that's not allowed,
what to others think?



