Return-Path: <linux-kernel-owner+w=401wt.eu-S1752771AbZH0OjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771AbZH0OjI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 10:39:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751452AbZH0OjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 10:39:07 -0400
Received: from tomts13.bellnexxia.net ([209.226.175.34]:43853 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751027AbZH0OjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 10:39:03 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvQEAM80lkpMROOX/2dsb2JhbACBU8cyCI9QgkQIgU0F
Date: Thu, 27 Aug 2009 10:39:02 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/profile: Fix profile_disable vs module_unload
Message-ID: <20090827143902.GA3552@Krystal>
References: <1251270092.7538.1226.camel@twins> <4A94DFF4.5030301@cn.fujitsu.com> <alpine.DEB.2.00.0908261012020.23885@gandalf.stny.rr.com> <20090826164624.GA21456@Krystal> <alpine.DEB.2.00.0908261343010.11291@gandalf.stny.rr.com> <20090826180114.GA29130@Krystal> <20090826181758.GA30248@Krystal> <alpine.DEB.2.00.0908261544590.11291@gandalf.stny.rr.com> <4A95E737.5080805@cn.fujitsu.com> <alpine.DEB.2.00.0908262209460.18923@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0908262209460.18923@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 10:38:00 up 9 days,  1:27,  2 users,  load average: 0.23, 0.33,
	0.26
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> On Thu, 27 Aug 2009, Li Zefan wrote:
> 
> > > Peter is correct that he should not need to worry about modules, he 
> > > doesn't build kernels with them ;-)
> > > 
> > > Here's another patch that moves the module ref count administration to the 
> > > trace events themselves. This should satisfy both you and Peter.
> > > 
> > 
> > In fact I had this patch in my mind, but I thought Peter insist
> > on fixing it in tracepoint. So I'm fine with this. :)
> 
> Tracepoints I consider a more low level API. Using them takes more hand 
> work and the user needs to know what they are doing and thus, must take 
> into account modules.
> 
> This code is automatic, and a much higher level API. The user shoud not 
> need to worry about modules, thus the protection belongs here.
> 
> If we try to make it so a module can not have register itself, then that 
> will just complicate the TRACE_EVENT macros even more. And those are 
> complex enough.
> 
> > 
> > > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > > 
> > > diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> > > index 1b1f742..3f7c5dc 100644
> > > --- a/include/trace/ftrace.h
> > > +++ b/include/trace/ftrace.h
> > > @@ -390,6 +390,20 @@ static inline int ftrace_get_offsets_##call(				\
> > >   *
> > >   */
> > >  
> > > +#ifdef MODULE
> > > +# define event_trace_up_ref()					\
> > > +	do {							\
> > > +		if (!try_module_get(THIS_MODULE)) {		\
> > > +			atomic_dec(&event_call->profile_count);	\
> > > +			return -1;				\
> > 
> > Should return -1 or -errno like -ENOENT?
> 
> Thanks, I was being lazy and really did not know what to have it return. 
> I'll commit it with a -ENOENT.
> 

Looks good. Just don't forget to eventually add the "synchronize" calls
between tracepoint unregistration and the removal of their module. There
is a race condition in the way you do it currently.

Thanks,

Mathieu

> -- Steve
> 
> > 
> > > +		}						\
> > > +	} while (0)
> > > +# define event_trace_down_ref() module_put(THIS_MODULE)
> > > +#else
> > > +# define event_trace_up_ref() do { } while (0)
> > > +# define event_trace_down_ref() do { } while (0)
> > > +#endif
> > > +		
> > >  #undef TRACE_EVENT
> > >  #define TRACE_EVENT(call, proto, args, tstruct, assign, print)		\
> > >  									\
> > > @@ -399,16 +413,20 @@ static int ftrace_profile_enable_##call(struct ftrace_event_call *event_call) \
> > >  {									\
> > >  	int ret = 0;							\
> > >  									\
> > > -	if (!atomic_inc_return(&event_call->profile_count))		\
> > > +	if (!atomic_inc_return(&event_call->profile_count)) {		\
> > > +		event_trace_up_ref();					\
> > >  		ret = register_trace_##call(ftrace_profile_##call);	\
> > > +	}								\
> > >  									\
> > >  	return ret;							\
> > >  }									\
> > >  									\
> > >  static void ftrace_profile_disable_##call(struct ftrace_event_call *event_call)\
> > >  {									\
> > > -	if (atomic_add_negative(-1, &event_call->profile_count))	\
> > > +	if (atomic_add_negative(-1, &event_call->profile_count)) {	\
> > >  		unregister_trace_##call(ftrace_profile_##call);		\
> > > +		event_trace_down_ref();					\
> > > +	}								\
> > >  }
> > >  
> > >  #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
> > > 
> > > 
> > 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
