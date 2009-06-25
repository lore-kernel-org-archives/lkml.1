Return-Path: <linux-kernel-owner+w=401wt.eu-S1758707AbZFYErd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758707AbZFYErd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 00:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751192AbZFYErZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 00:47:25 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:39830 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbZFYErY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 00:47:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lJMCFd4BpPUUWm1krEQS2tToYa0Qo6anceSMCoU29bl0Jq4PhSFrN3FF6qBKdvpoRC
         idscNbTYBabTgAWQUDjUHMtyUS43SCUIjuQFPMyKAYgB3fro1WAwA/+93/IRkAt6TNlV
         8xOsocO93mkd5gS+AzzIYlqoCS5blK+vpi8Io=
Date: Thu, 25 Jun 2009 06:47:23 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       peterz@infradead.org, mathieu.desnoyers@polymtl.ca, jiayingz@google.com,
       mbligh@google.com, roland@redhat.com, fche@redhat.com
Subject: Re: [PATCH 3/7] V2 add syscall tracepoints
Message-ID: <20090625044722.GA6071@nowhere>
References: <cover.1245770664.git.jbaron@redhat.com> <df45ccb4905bff0e49d11386b44b0eb23034e83c.1245770664.git.jbaron@redhat.com> <4A42DEF9.4020506@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A42DEF9.4020506@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 25, 2009 at 10:20:41AM +0800, Li Zefan wrote:
> > -#define DECLARE_TRACE(name, proto, args)				\
> > +#define DECLARE_TRACE_WITH_CALLBACK(name, proto, args, reg, unreg)	\
> >  	extern struct tracepoint __tracepoint_##name;			\
> >  	static inline void trace_##name(proto)				\
> >  	{								\
> > @@ -71,13 +73,29 @@ struct tracepoint {
> >  	}								\
> >  	static inline int register_trace_##name(void (*probe)(proto))	\
> >  	{								\
> > -		return tracepoint_probe_register(#name, (void *)probe);	\
> > +		int ret;						\
> > +		void (*func)(void) = (void (*)(void))reg;		\
> 
> The explicit cast seems unnecessary.


It seems even dangerous.
That might hide unmatching callback types passed in macro
arguments.

Frederic.


 
> > +									\
> > +		ret = tracepoint_probe_register(#name, (void *)probe);	\
> > +		if (func && !ret)					\
> > +			func();						\
> > +		return ret;						\
> >  	}								\
> >  	static inline int unregister_trace_##name(void (*probe)(proto))	\
> >  	{								\
> > -		return tracepoint_probe_unregister(#name, (void *)probe);\
> > +		int ret;						\
> > +		void (*func)(void) = (void (*)(void))unreg;		\
> > +									\
> > +		ret = tracepoint_probe_unregister(#name, (void *)probe);\
> > +		if (func && !ret)					\
> > +			func();						\
> > +		return ret;						\
> >  	}
> >  
> > +
> > +#define DECLARE_TRACE(name, proto, args)		\
> > +	DECLARE_TRACE_WITH_CALLBACK(name, TP_PROTO(proto), TP_ARGS(args), 0, 0);
> 
> I think DECLARE_TRACE_WITH_CALLBACK(..., NULL, NULL) is better.
> 
> > +
> >  #define DEFINE_TRACE(name)						\
> >  	static const char __tpstrtab_##name[]				\
> >  	__attribute__((section("__tracepoints_strings"))) = #name;	\
> > @@ -94,7 +112,7 @@ extern void tracepoint_update_probe_range(struct tracepoint *begin,
> >  	struct tracepoint *end);
> >  
> >  #else /* !CONFIG_TRACEPOINTS */
> > -#define DECLARE_TRACE(name, proto, args)				\
> > +#define DECLARE_TRACE_WITH_CALLBACK(name, proto, args, reg, unreg)	\
> >  	static inline void _do_trace_##name(struct tracepoint *tp, proto) \
> >  	{ }								\
> >  	static inline void trace_##name(proto)				\
> > @@ -108,6 +126,9 @@ extern void tracepoint_update_probe_range(struct tracepoint *begin,
> >  		return -ENOSYS;						\
> >  	}
> >  
> > +#define DECLARE_TRACE(name, proto, args)                \
> > +	DECLARE_TRACE_WITH_CALLBACK(name, TP_PROTO(proto), TP_ARGS(args), 0, 0);
> 
> ditto
> 
> > +
> >  #define DEFINE_TRACE(name)
> >  #define EXPORT_TRACEPOINT_SYMBOL_GPL(name)
> >  #define EXPORT_TRACEPOINT_SYMBOL(name)
> 
> 

