Return-Path: <linux-kernel-owner+w=401wt.eu-S1753661AbZIKOdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661AbZIKOdZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 10:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752821AbZIKOdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 10:33:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:47734 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbZIKOdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 10:33:24 -0400
Subject: Re: [PATCH 2/3] tracing/profile: add ref count for registering
 profile events
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>
In-Reply-To: <1252678183.7126.34.camel@laptop>
References: <20090911135452.866274568@goodmis.org>
	 <20090911135626.421489476@goodmis.org>  <1252677861.7126.32.camel@laptop>
	 <1252678183.7126.34.camel@laptop>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Fri, 11 Sep 2009 10:33:26 -0400
Message-Id: <1252679606.18996.681.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-11 at 16:09 +0200, Peter Zijlstra wrote:
> On Fri, 2009-09-11 at 16:04 +0200, Peter Zijlstra wrote:
> > On Fri, 2009-09-11 at 09:54 -0400, Steven Rostedt wrote:
> > 
> > > +#ifdef MODULE
> > > +# define event_trace_up_ref()					\
> > > +	do {							\
> > > +		if (!try_module_get(THIS_MODULE)) {		\
> > > +			atomic_dec(&event_call->profile_count);	\
> > > +			return -ENOENT;				\
> > > +		}						\
> > > +	} while (0)
> > > +# define event_trace_down_ref() module_put(THIS_MODULE)
> > > +#else
> > > +# define event_trace_up_ref() do { } while (0)
> > > +# define event_trace_down_ref() do { } while (0)
> > > +#endif
> > 
> > That's like truely gruesomely ugly.
> > 
> > At the very least write it like:
> > 
> > int event_trace_up_ref(struct ftrace_event_call *call)
> > {
> > 	if (!try_module_get(THIS_MODULE)) {
> > 		atomic_dev(&call->profile_count);
> > 		return -ENOENT;
> > 	}
> > 	return 0;
> > }
> 
> Or we can go with Li's original patch, that was less ugly.

I can go back to Li's original patch, but the talk on that was
"fragile". If you no longer feel that way, then I'll use his instead.

For now, I'll pull out this patch altogether, and resubmit the pull
request without it. I'd like the other changes to not be held up by
this.

> 
> I still think tracepoints/markers should sort this out, because we now
> have a sematic difference between the two wrt modules.

I originally tried to do it in the tracepoint logic, but that broke a
lot of assumptions about tracepoints that Mathieu pointed out. This is
not a normal use of tracepoints. It is expected that if you register a
probe in a module, you will unregister it before exiting.

I can't remember all the details, but at the end, it seemed that the fix
belonged at the ftrace level.

-- Steve


