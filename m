Return-Path: <linux-kernel-owner+w=401wt.eu-S1755237AbZDSAwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237AbZDSAwS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 20:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753280AbZDSAwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 20:52:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:45826 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762AbZDSAwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 20:52:06 -0400
Date: Sat, 18 Apr 2009 20:52:02 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2 v2] tracing/events: provide string with undefined
 size support
In-Reply-To: <20090418184222.GB6212@nowhere>
Message-ID: <alpine.DEB.2.00.0904182050210.1016@gandalf.stny.rr.com>
References: <1239912047-6282-1-git-send-email-fweisbec@gmail.com> <1239912812.23397.3432.camel@laptop> <c62985530904161328g299e8a67q2012a577e8a2f1a4@mail.gmail.com> <1239949360.23397.4065.camel@laptop> <c62985530904170159j6f3b5477g411a028e69fd93f6@mail.gmail.com>
 <1239960548.23397.4282.camel@laptop> <alpine.DEB.2.00.0904170552160.20429@gandalf.stny.rr.com> <alpine.DEB.2.00.0904170613370.20429@gandalf.stny.rr.com> <20090418184222.GB6212@nowhere>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 18 Apr 2009, Frederic Weisbecker wrote:
> > 
> > #undef __string
> > #define __string(str, param)	__str_loc_##str = _str_size_; \
> > 				_str_size_ += strlen(param) + 1;
> > 
> > #define TRACE_EVENT(...)
> > 	tstruct
> > 
> > #include the file again
> 
> 
> While I'm trying to implement this, I'm discovering that it's
> impossible, unless we have only one TRACE_EVENT in the file we are
> including, otherwise we would end up with interleaving functions:
> 
>  static void ftrace_raw_event_event1(proto)
>  {
>        struct ring_buffer_event *event;
>        struct ftrace_raw_event1 *entry;
>        unsigned long flags;
>        int pc;
>        int _str_size_ = 0;
> 
>        tstruct
> 
>  static void ftrace_raw_event_event2(proto)     
>  {      
>        struct ring_buffer_event *event;         
>        struct ftrace_raw_event2 *entry;   
>        unsigned long flags;                     
>        int pc;                                  
>        int _str_size_ = 0;                      
> 
>        tstruct

Ug, that's right.

> 
> 
> So we still need something inside the fast_assign to do the
> assignment job.
> 
> Something like the following macro will suffice:
> 
> #define	__assign_string(field, src)	\
> 	strcpy(entry->__ending_str + __str_loc_##field, src);
> 
> That's not a big deal, we just actually need this in TP__fast_assign()
> and then we are done.
> 
> And also:
> 
> 
> > The tstruct would do the assign for the user.
> > 
> > Then this is what a TRACE_EVENT would look like:
> > 
> > TRACE_EVENT(my_event,
> > 
> > 	TP_PROTO(char *str1, char *str2, char *str3),
> > 
> > 	TP_ARGS(str1, str2, str3),
> > 
> > 	TP_STRUCT__entry(
> > 		__string(str1, str1)
> > 		__string(str2, str2)
> > 		__string(str3, str3)
> > 	),
> > 
> > 	TP_fast_assign(
> > 		/* empty, strings are automated */
> > 	),
> > 
> > 	TP_printk("str1:%s str2:%s str3:%s\n",
> > 		__entry->__str_data__ + __entry->str1,
> > 		__entry->__str_data__ + __entry->str2,
> > 		__entry->__str_data__ + __entry->str3)
> 
> 
> 
> A simple macro here to simplify that for the users:
> 
> #define __get_str(item)		\
> 	__entry->__ending_str + __entry->__str_loc_#item
> 
> would be much more convenient.
> 
> Anyway, I'll submit it and will wait for your comments.

Sure, do what you think is needed. Make sure the change log has an 
example that includes multiple strings.

Thanks,

-- Steve
