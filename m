Return-Path: <linux-kernel-owner+w=401wt.eu-S1758276AbZJNJ1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758276AbZJNJ1R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 05:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756008AbZJNJ1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 05:27:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:50995 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755922AbZJNJ1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 05:27:15 -0400
Subject: Re: [PATCH RFC] sched: add notifier for process migration
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Avi Kivity <avi@redhat.com>,
       Ingo Molnar <mingo@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jason Baron <jbaron@redhat.com>
In-Reply-To: <20091014070508.GI784@elte.hu>
References: <4ACFA4C5.4020607@goop.org> <1255125738.7439.17.camel@laptop>
	 <4ACFBC98.4070701@goop.org> <1255158863.7866.25.camel@twins>
	 <4AD04E50.7060001@redhat.com> <1255166662.7866.28.camel@twins>
	 <4AD055B3.8070705@goop.org> <1255169528.7521.3.camel@laptop>
	 <4AD4F02C.9060203@goop.org>  <20091014070508.GI784@elte.hu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 14 Oct 2009 11:26:10 +0200
Message-Id: <1255512370.8392.373.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-14 at 09:05 +0200, Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> 
> > @@ -1981,6 +1989,12 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
> >  #endif
> >  		perf_swcounter_event(PERF_COUNT_SW_CPU_MIGRATIONS,
> >  				     1, 1, NULL, 0);
> > +
> > +		tmn.task = p;
> > +		tmn.from_cpu = old_cpu;
> > +		tmn.to_cpu = new_cpu;
> > +
> > +		atomic_notifier_call_chain(&task_migration_notifier, 0, &tmn);
> 
> We already have one event notifier there - look at the 
> perf_swcounter_event() callback. Why add a second one for essentially 
> the same thing?
> 
> We should only put a single callback there - a tracepoint defined via 
> TRACE_EVENT() - and any secondary users can register a callback to the 
> tracepoint itself.
> 
> There's many similar places in the kernel - with notifier chains and 
> also with a need to get tracepoints there. The fastest (and most 
> consistent) solution is to add just a single event callback facility.

But that would basically mandate tracepoints to be always enabled, do we
want to go there?

I don't think the overhead of tracepoints is understood well enough,
Jason you poked at that, do you have anything solid on that?

Also, I can imagine the embedded people to not want that.

I really like perf and tracepoints to not become co-dependent until
tracepoint become mandatory for all configurations.
