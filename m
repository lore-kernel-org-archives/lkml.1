Return-Path: <linux-kernel-owner+w=401wt.eu-S1757029AbZCMDRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029AbZCMDRe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 23:17:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751375AbZCMDRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 23:17:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:33868 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbZCMDRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 23:17:24 -0400
Date: Thu, 12 Mar 2009 23:17:21 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 08/16] tracing: have event_trace_printk use static
 tracer
In-Reply-To: <20090313120855.43E8.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0903122311160.18396@gandalf.stny.rr.com>
References: <20090313023704.971438367@goodmis.org> <20090313023826.503765882@goodmis.org> <20090313120855.43E8.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 13 Mar 2009, KOSAKI Motohiro wrote:

> > +#define event_trace_printk(ip, fmt, args...)				\
> > +do {									\
> > +	__trace_printk_check_format(fmt, ##args);			\
> > +	tracing_record_cmdline(current);				\
> > +	if (__builtin_constant_p(fmt)) {				\
> > +		static const char *trace_printk_fmt			\
> > +		  __attribute__((section("__trace_printk_fmt"))) =	\
> > +			__builtin_constant_p(fmt) ? fmt : NULL;		\
> 
> Why __builtin_constant_p(fmt) evaluate twice?

It's explained in another patch. But this was a real PITA. We first tried 
this with just the "if (__builtin_return_p(fmt))" but the way gcc works, 
it handles the global data assignments before optimizing out condition 
logic. Thus we ended up getting errors about can not initialize static 
variable with a non constant.

But the ? : operation of the assignment is optimized before the assignment
is made. Thus, if fmt is not constant, then we avoid this warning. Then
during the conditional optimization, gcc will remove that part of the code 
altogether.

Thus the double __builtin_constant_p(fmt) is needed twice. Try taking out 
one of them and see what happens with:

myfunc(const char *fmt) {

  event_trace_printk(fmt);

}

Of course the way this is made, we may not call it that way, but I wanted 
to be safe.

-- Steve

> 
> 
> > +									\
> > +		__trace_bprintk(ip, trace_printk_fmt, ##args);		\
> > +	} else								\
> > +		__trace_printk(ip, fmt, ##args);			\
> > +} while (0)
> 
> 
> 
