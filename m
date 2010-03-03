Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404Ab0CCQhp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 11:37:45 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:47280 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348Ab0CCQho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 11:37:44 -0500
Subject: Re: [RFC][PATCH 2/3] perf: Take a hot regs snapshot for trace
 events
From: Peter Zijlstra <peterz@infradead.org>
To: rostedt@goodmis.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <1267632387.10871.59.camel@gandalf.stny.rr.com>
References: <1267599302-2886-1-git-send-regression-fweisbec@gmail.com>
	 <1267599302-2886-3-git-send-regression-fweisbec@gmail.com>
	 <1267632387.10871.59.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Mar 2010 17:37:38 +0100
Message-ID: <1267634258.25158.88.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-03 at 11:06 -0500, Steven Rostedt wrote:
> On Wed, 2010-03-03 at 07:55 +0100, Frederic Weisbecker wrote:
> 
> > +/*
> >   * Output
> >   */
> >  static bool perf_output_space(struct perf_mmap_data *data, unsigned long tail,
> > @@ -4337,6 +4347,8 @@ static const struct pmu perf_ops_task_clock = {
> >  void perf_tp_event(int event_id, u64 addr, u64 count, void *record,
> >  			  int entry_size)
> >  {
> > +	struct pt_regs regs;
> > +
> >  	struct perf_raw_record raw = {
> >  		.size = entry_size,
> >  		.data = record,
> > @@ -4347,14 +4359,11 @@ void perf_tp_event(int event_id, u64 addr, u64 count, void *record,
> >  		.raw = &raw,
> >  	};
> >  
> > -	struct pt_regs *regs = get_irq_regs();
> > -
> > -	if (!regs)
> > -		regs = task_pt_regs(current);
> > +	PERF_SAVE_REGS(&regs);
> >  
> >  	/* Trace events already protected against recursion */
> >  	do_perf_sw_event(PERF_TYPE_TRACEPOINT, event_id, count, 1,
> > -				&data, regs);
> > +				&data, &regs);
> 
> Off-topic: Why is the above a perf sw event? Couldn't that also be a
> normal TRACE_EVENT()?

Well, no, this is the stuff that transforms TRACE_EVENT() into perf
software events ;-)

