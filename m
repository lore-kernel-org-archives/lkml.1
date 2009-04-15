Return-Path: <linux-kernel-owner+w=401wt.eu-S1759950AbZDOLh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759950AbZDOLh7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 07:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759428AbZDOLhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 07:37:50 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40658 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759340AbZDOLht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 07:37:49 -0400
Date: Wed, 15 Apr 2009 13:33:59 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Tom Zanussi <tzanussi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] ftrace: introduce workqueue_handler_exit
	tracepoint and rename workqueue_execution to workqueue_handler_entry
Message-ID: <20090415113359.GA5118@redhat.com>
References: <20090413125653.6E01.A69D9226@jp.fujitsu.com> <20090413145105.6E07.A69D9226@jp.fujitsu.com> <20090413145159.6E0A.A69D9226@jp.fujitsu.com> <20090413162534.GI5977@nowhere> <20090415102257.GA2617@redhat.com> <20090415110937.GA27727@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090415110937.GA27727@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15, Ingo Molnar wrote:
>
> * Oleg Nesterov <oleg@redhat.com> wrote:
>
> > > >  		lock_map_acquire(&lockdep_map);
> > > > +		trace_workqueue_handler_entry(cwq->thread, work);
> > > >  		f(work);
> > > > +		trace_workqueue_handler_exit(cwq->thread, work);
> >
> > This doesn't look right. We must not use "work" after f(work).
> > work->func() can kfree its work.
>
> We can use it as long as we use it as a 'cookie' - i.e. an
> identifier for visualization/statistics, but dont actually
> dereference it, right?

Yes sure.

I do not know whether this matters or not, but just in case...
Of course it is possible that, when trace_workqueue_handler_exit() runs,
this memory was already reused for another work even without kfree.
For example,

	void my_work_func(struct work_struct *work)
	{
		INIT_WORK(work, another_work_func);
		queue_work(another_workqueue, work);
	}

In this case another_workqueue can report trace_workqueue_handler_entry()
before my_work_func() returns.

This means that trace_workqueue_handler_exit() can't use the address
of work as a "key" to find some data recorded by _entry(). Unless this
data lives in cpu_workqueue_struct.

Not sure why I am trying to explain the things which are very obvious
to all ;) Just because I don't really understand what these patches do.

Oleg.

