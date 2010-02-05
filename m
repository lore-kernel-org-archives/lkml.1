Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933184Ab0BEOai (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 09:30:38 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:39300 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932268Ab0BEOaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 09:30:35 -0500
Subject: Re: [PATCH 03/11] tracing: Inject lock_class_init events on
 registration
From: Peter Zijlstra <peterz@infradead.org>
To: rostedt@goodmis.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <1265379199.24386.26.camel@gandalf.stny.rr.com>
References: <1265188475-23509-1-git-send-regression-fweisbec@gmail.com>
	 <1265188475-23509-4-git-send-regression-fweisbec@gmail.com>
	 <1265379199.24386.26.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Feb 2010 15:30:07 +0100
Message-ID: <1265380207.22001.654.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-05 at 09:13 -0500, Steven Rostedt wrote:
> On Wed, 2010-02-03 at 10:14 +0100, Frederic Weisbecker wrote:
> 
> >  static inline void lockdep_off(void)
> > diff --git a/include/trace/events/lock.h b/include/trace/events/lock.h
> > index 90af03c..6999f16 100644
> > --- a/include/trace/events/lock.h
> > +++ b/include/trace/events/lock.h
> > @@ -9,7 +9,7 @@
> >  
> >  #ifdef CONFIG_LOCKDEP
> >  
> > -TRACE_EVENT(lock_class_init,
> > +TRACE_EVENT_INJECT(lock_class_init,
> >  
> >  	TP_PROTO(struct lock_class *class),
> >  
> > @@ -30,7 +30,14 @@ TRACE_EVENT(lock_class_init,
> >  		__entry->class_id = (void *)class->name;
> >  	),
> >  
> > -	TP_printk("%p %s", __entry->class_id, __get_str(class_name))
> > +	TP_printk("%p %s", __entry->class_id, __get_str(class_name)),
> > +
> > +	/*
> > +	 * On activation, we want to send an event for each lock
> > +	 * classes that have been recorded by lockdep, so that we
> > +	 * catch up with the existing class:name mappings.
> > +	 */
> > +	lock_class_init_inject_events
> >  );
> >  
> 
> I also suggested this type of registering:
> 
> register_event_callback("event", "command", command_func, 
> 		command_enable_func,
> 		command_disable_func);
> 
> Where command_func, command_enable_func and command_disable_func can all
> be a function pointer or NULL.
> 
> command_func gets called every time the event is hit while enabled.
> 
> command_enable_func gets called when the event is enabled
> 
> command_disable_func gets called when the event is disabled.

Well, that will solve johill's polling thing, but not work nicely with
the proposed collection iteration stuff.

