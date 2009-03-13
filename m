Return-Path: <linux-kernel-owner+w=401wt.eu-S1757992AbZCMD3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757992AbZCMD3T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 23:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753027AbZCMD3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 23:29:00 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:57740 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbZCMD27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 23:28:59 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 08/16] tracing: have event_trace_printk use static tracer
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <alpine.DEB.2.00.0903122311160.18396@gandalf.stny.rr.com>
References: <20090313120855.43E8.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.0903122311160.18396@gandalf.stny.rr.com>
Message-Id: <20090313122235.43EB.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Fri, 13 Mar 2009 12:28:55 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > +#define event_trace_printk(ip, fmt, args...)				\
> > > +do {									\
> > > +	__trace_printk_check_format(fmt, ##args);			\
> > > +	tracing_record_cmdline(current);				\
> > > +	if (__builtin_constant_p(fmt)) {				\
> > > +		static const char *trace_printk_fmt			\
> > > +		  __attribute__((section("__trace_printk_fmt"))) =	\
> > > +			__builtin_constant_p(fmt) ? fmt : NULL;		\
> > 
> > Why __builtin_constant_p(fmt) evaluate twice?
> 
> It's explained in another patch. But this was a real PITA. We first tried 
> this with just the "if (__builtin_return_p(fmt))" but the way gcc works, 
> it handles the global data assignments before optimizing out condition 
> logic. Thus we ended up getting errors about can not initialize static 
> variable with a non constant.
> 
> But the ? : operation of the assignment is optimized before the assignment
> is made. Thus, if fmt is not constant, then we avoid this warning. Then
> during the conditional optimization, gcc will remove that part of the code 
> altogether.
> 
> Thus the double __builtin_constant_p(fmt) is needed twice. Try taking out 
> one of them and see what happens with:
> 
> myfunc(const char *fmt) {
> 
>   event_trace_printk(fmt);
> 
> }
> 
> Of course the way this is made, we may not call it that way, but I wanted 
> to be safe.

Thanks for kindful explain.
So, I guess many developer feel it's strange. 
adding comment is better?


