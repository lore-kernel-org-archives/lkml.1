Return-Path: <linux-kernel-owner+w=401wt.eu-S1753169Ab0AYSG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab0AYSG2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 13:06:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754528Ab0AYSG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 13:06:27 -0500
Received: from cantor.suse.de ([195.135.220.2]:34429 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754437Ab0AYSG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 13:06:26 -0500
Date: Mon, 25 Jan 2010 10:04:43 -0800
From: Greg KH <gregkh@suse.de>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Paul Mackerras <paulus@samba.org>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [28/29] perf events: Dont report side-band
 events on each cpu for per-task-per-cpu events
Message-ID: <20100125180443.GA18650@suse.de>
References: <20100123001113.778789298@mini.kroah.org>
 <4B5ADFC1.6030909@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B5ADFC1.6030909@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 23, 2010 at 12:38:41PM +0100, Stefan Bader wrote:
> Greg KH wrote:
> > 2.6.32-stable review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> > 
> > From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > 
> > commit 5d27c23df09b702868d9a3bff86ec6abd22963ac upstream.
> > 
> > Acme noticed that his FORK/MMAP numbers were inflated by about
> > the same factor as his cpu-count.
> > 
> > This led to the discovery of a few more sites that need to
> > respect the event->cpu filter.
> > 
> > Reported-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Paul Mackerras <paulus@samba.org>
> > LKML-Reference: <20091217121830.215333434@chello.nl>
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > 
> > ---
> >  kernel/perf_event.c |   20 ++++++++++++++++++--
> >  1 file changed, 18 insertions(+), 2 deletions(-)
> > 
> > --- a/kernel/perf_event.c
> > +++ b/kernel/perf_event.c
> > @@ -1359,6 +1359,9 @@ static void perf_ctx_adjust_freq(struct 
> >  		if (event->state != PERF_EVENT_STATE_ACTIVE)
> >  			continue;
> >  
> > +		if (event->cpu != -1 && event->cpu != smp_processor_id())
> > +			continue;
> > +
> >  		hwc = &event->hw;
> >  
> >  		interrupts = hwc->interrupts;
> > @@ -3226,6 +3229,9 @@ static void perf_event_task_output(struc
> >  
> >  static int perf_event_task_match(struct perf_event *event)
> >  {
> > +	if (event->cpu != -1 && event->cpu != smp_processor_id())
> > +		return 0;
> > +
> >  	if (event->attr.comm || event->attr.mmap || event->attr.task)
> >  		return 1;
> >  
> 
> > @@ -3262,6 +3268,7 @@ static void perf_event_task_event(struct
> >  		ctx = rcu_dereference(task_event->task->perf_event_ctxp);
> >  	if (ctx)
> >  		perf_event_task_ctx(ctx, task_event);
> > +	put_cpu_var(perf_cpu_context);
> >  	rcu_read_unlock();
> >  }
> 
> I believe this hunk drops the move of put_cpu_var. The upstream hunk looks like
> this:
> 
> @ -3290,12 +3296,11 @@ static void perf_event_task_event(struct perf_task_event
>         rcu_read_lock();
>         cpuctx = &get_cpu_var(perf_cpu_context);
>         perf_event_task_ctx(&cpuctx->ctx, task_event);
> -       put_cpu_var(perf_cpu_context);
> -
>         if (!ctx)
>                 ctx = rcu_dereference(task_event->task->perf_event_ctxp);
>         if (ctx)
>                 perf_event_task_ctx(ctx, task_event);
> +       put_cpu_var(perf_cpu_context);
>         rcu_read_unlock();
>  }

All fixed up now, thanks again for the review.

greg k-h
