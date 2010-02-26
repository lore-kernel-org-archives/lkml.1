Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499Ab0BZUhY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 15:37:24 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:49406 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046Ab0BZUhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 15:37:23 -0500
X-Authority-Analysis: v=1.0 c=1 a=5NS3NZNjjBUA:10 a=7U3hwN5JcxgA:10 a=IcSoqQtsRum6hgAGHTEA:9 a=UyAT4n8N1_6YdOiosRcXt9Sl8WoA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH] ftrace: add tracing_thresh support to function_graph
 tracer (v3)
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Tim Bird <tim.bird@am.sony.com>
Cc: Steven Rostedt <srostedt@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       linux kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4B88187B.4020909@am.sony.com>
References: <4B87098B.4040308@am.sony.com>
	 <1267159075.6328.105.camel@gandalf.stny.rr.com>
	 <4B88187B.4020909@am.sony.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 26 Feb 2010 15:37:20 -0500
Message-ID: <1267216640.6328.135.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-26 at 10:52 -0800, Tim Bird wrote:

> > Now, your patch will have an impact if you do not enable DYNAMIC_FTRACE,
> > because then all callers to mcount can be traced. But then you have a
> > 13% overhead in the system.
> 
> Yes.  I have primarily been using this for bootup time tracing,
> on ARM (without DYNAMIC_FTRACE), and only during development.
> I wouldn't leave it on in a production system.
> 
> I'm fine with yanking that out of this patch, since I have other
> stuff I still have to patch to use it on ARM.

Still this change is off topic for this patch. Anyway, what you could
add is:

+#ifdef CONFIG_DYNAMIC_FTRACE
+# define init_notrace
+#else
+# define init_notrace notrace
+#endif

-#define __init              __section(.init.text) __cold notrace
+#define __init              __section(.init.text) __cold init_notrace

Would also need a comment that dynamic ftrace, for safety reasons does
not trace __init sections with or without notrace. Just make it always
notrace. But static ftrace can safely trace init sections, so keep them
on when dynamic ftrace is disabled.


> >> -	ret = trace_seq_printf(s, "}\n");
> >> +	if (tracing_thresh) {
> >> +		ret = trace_seq_printf(s, "} (%ps)\n", (void *)trace->func);
> > 
> > Ah, this isn't what I wanted. I wanted something a bit more complex ;-)
> 
> :-)
> 
> This is simpler than the EXIT_FUNC option I had earlier, but still
> not automatic as you describe below.
> > 
> > I was thinking of keeping a small stack per cpu that keeps track of
> > previous entries. If a exit is called that does not have a matching
> > entry (can easily check the depth parameter) then we should print out
> > the function name. This way, even without the tracing_thresh tracer, we
> > can see what dangling '}'s are. This happens now with the current
> > tracer.
> 
> This would be a nice addition.  I was a little worried about
> the checking tracing_thresh at output time (as opposed to trace time).
> A user could theoretically change the tracing_thresh after capture
> but before output, and get only the closing braces.
> 
> In my humble opinion, even when you've seen the opening braces,
> it can be useful to show the function name on the exit line.
> For example, right now you can't use grep on a big trace
> (just a regular function graph trace, not the one using
> tracing_thresh) to find the pattern of function durations
> for specific functions.

Then we should add an option to always show it as well. I've added
showing it before, and it does become a distraction in scanning it with
the human eye. But a grep is a reason to have the option.

> 
> > I can add this tomorrow. Then I can take this patch and cut out the
> > stuff not needed.
> Thanks.

Currently working on it.

-- Steve


