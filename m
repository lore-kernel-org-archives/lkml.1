Return-Path: <linux-kernel-owner+w=401wt.eu-S1758034AbZDOK0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758034AbZDOK0y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 06:26:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752702AbZDOK0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 06:26:45 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45807 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911AbZDOK0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 06:26:44 -0400
Date: Wed, 15 Apr 2009 12:22:57 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Tom Zanussi <tzanussi@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] ftrace: introduce workqueue_handler_exit
	tracepoint and rename workqueue_execution to workqueue_handler_entry
Message-ID: <20090415102257.GA2617@redhat.com>
References: <20090413125653.6E01.A69D9226@jp.fujitsu.com> <20090413145105.6E07.A69D9226@jp.fujitsu.com> <20090413145159.6E0A.A69D9226@jp.fujitsu.com> <20090413162534.GI5977@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090413162534.GI5977@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am very sorry for delay. I am going to study these patches later.

Just one note,

> On Mon, Apr 13, 2009 at 02:53:01PM +0900, KOSAKI Motohiro wrote:
>
> > Subject: [PATCH] ftrace: introduce workqueue_handler_exit tracepoint and rename workqueue_execution to workqueue_handler_entry
> >
> > Entry/exit handler pair is useful common tracepoint technique. it can mesure handler consumption time.
...
> >  static void run_workqueue(struct cpu_workqueue_struct *cwq)
> >  {
> > @@ -282,7 +283,6 @@ static void run_workqueue(struct cpu_wor
> >  		 */
> >  		struct lockdep_map lockdep_map = work->lockdep_map;
> >  #endif
> > -		trace_workqueue_execution(cwq->thread, work);
> >  		cwq->current_work = work;
> >  		list_del_init(cwq->worklist.next);
> >  		spin_unlock_irq(&cwq->lock);
> > @@ -291,7 +291,9 @@ static void run_workqueue(struct cpu_wor
> >  		work_clear_pending(work);
> >  		lock_map_acquire(&cwq->wq->lockdep_map);
> >  		lock_map_acquire(&lockdep_map);
> > +		trace_workqueue_handler_entry(cwq->thread, work);
> >  		f(work);
> > +		trace_workqueue_handler_exit(cwq->thread, work);

This doesn't look right. We must not use "work" after f(work). work->func()
can kfree its work.

That is why we copy lockdep_map beforehand. Perhaps ftrace should do
something similar.

Oleg.

