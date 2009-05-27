Return-Path: <linux-kernel-owner+w=401wt.eu-S1759252AbZE0KLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759252AbZE0KLd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 06:11:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756414AbZE0KLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 06:11:25 -0400
Received: from www.tglx.de ([62.245.132.106]:60676 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756297AbZE0KLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 06:11:25 -0400
Date: Wed, 27 May 2009 12:10:58 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
cc: mingo@elte.hu, LKML <linux-kernel@vger.kernel.org>,
       Zhaolei <zhaolei@cn.fujitsu.com>, kosaki.motohiro@jp.fujitsu.com,
       Steven Rostedt <rostedt@goodmis.org>, fweisbec@gmail.com
Subject: Re: [PATCH 1/3] ftrace: add tracepoint for timer
In-Reply-To: <4A1CED66.7030805@cn.fujitsu.com>
Message-ID: <alpine.LFD.2.00.0905271202260.3397@localhost.localdomain>
References: <4A167615.7050208@cn.fujitsu.com> <alpine.LFD.2.00.0905262334030.1762@localhost.localdomain> <4A1CED66.7030805@cn.fujitsu.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 May 2009, Xiao Guangrong wrote:
> >> +	TP_printk("timer=%p func=%pf expires=%lu cpu=%d", __entry->timer,
> >> +		  __entry->function, __entry->expires, __entry->cpu)
> >> +);
> > 
> >   How do we connect the trace to the jiffies value when the timer
> >   was started ?
> > 
> 
> ftrace already have time information in trace event's output, we can use it instead

  Hmm, I'm not sure whether we can see the jiffies value there, but ok. 
 
> >> @@ -547,6 +550,7 @@ void init_timer_key(struct timer_list *timer,
> >>  {
> >>  	debug_timer_init(timer);
> >>  	__init_timer(timer, name, key);
> >> +	trace_timer_init(timer);
> > 
> >   Can we please avoid to have two debug calls in one 2 line function ?
> > 
> 
> debug_timer_init() must call before object's init, but tracepoint have to call
> after object's init beacuse if we move the tracepoint to before object init, the
> object has no data yet.

  Err.

> >> + TRACE_EVENT(timer_init,
> >> +
> >> + TP_PROTO(struct timer_list *timer),
> >> +
> >> + TP_ARGS(timer),
> >> +
> >> + TP_STRUCT__entry(
> >> + __field( void *, timer )
> >> + ),
> >> +
> >> + TP_fast_assign(
> >> + __entry->timer = timer;
> >> + ),
> >> +
> >> + TP_printk("timer=%p", __entry->timer)
> >> +);

  Is timer different before and after the __init_timer call ?
 
> >>  }
> >>  EXPORT_SYMBOL(init_timer_key);
> >>  
> >> @@ -565,6 +569,7 @@ static inline void detach_timer(struct timer_list *timer,
> >>  	struct list_head *entry = &timer->entry;
> >>  
> >>  	debug_timer_deactivate(timer);
> >> +	trace_timer_cancel(timer);
> > 
> >   Ditto. Please create one debug entity which covers both.
> >
> 
> IMHO, we can't create one entity for init event, so we do better detach other event.

  See above.
 
Thanks,

	tglx
