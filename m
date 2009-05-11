Return-Path: <linux-kernel-owner+w=401wt.eu-S1756148AbZEKO14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148AbZEKO14 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 10:27:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752954AbZEKO1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 10:27:47 -0400
Received: from tomts16.bellnexxia.net ([209.226.175.4]:43935 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752782AbZEKO1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 10:27:47 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmQFAJPSB0pMQW1W/2dsb2JhbACBUMsog34F
Date: Mon, 11 May 2009 10:27:34 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com,
       zhaolei@cn.fujitsu.com, laijs@cn.fujitsu.com,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH v3] ftrace: add a tracepoint for
	__raise_softirq_irqoff()
Message-ID: <20090511142734.GA12722@Krystal>
References: <49FFDF9C.7040505@cn.fujitsu.com> <20090505161604.GA15524@Krystal> <4A07D3B3.10605@cn.fujitsu.com> <20090511134019.GB10932@Krystal> <alpine.DEB.2.00.0905111003280.14976@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0905111003280.14976@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:18:49 up 72 days, 10:45,  4 users,  load average: 0.19, 0.32,
	0.62
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> On Mon, 11 May 2009, Mathieu Desnoyers wrote:
> > 
> > Yes, we should try to fix TRACE_EVENT, but we should fix it _before_ we
> > start using it widely. Circular header dependencies is a real problem
> > with TRACE_EVENT right now.
> > 
> > Until we fix this, I will be tempted to stay with a known-good solution,
> > which is DECLARE/DEFINE_TRACE.
> 
> The majority of tracepoints happen is C files. Those few cases where they 
> are used in headers is where the issues arise.
> 
> But...
> 
> I did not want to uglify all trace event headers with:
> 
> #ifdef CREATE_FOO_TRACE_POINTS
> #undef CREATE_FOO_TRACE_POINTS
> #include <trace/define_trace.h>
> #endif
> 
> We would only need to do that for those trace points that need to be 
> included in header files. Then the declaration C file would need to define 
> both CREATE_FOO_TRACE_POINTS and CREATE_TRACE_POINTS
> 
> #define CREATE_FOO_TRACE_POINTS
> #define CRATE_TRACE_POINTS
> #include <trace/events/foo.h>
> 
> 
> But this is pretty trivial to solve, and I do not consider it a show 
> stopper or a major header dependency problem.
> 
> -- Steve
> 

Hrm, is there any way to solve it elegantly ?

What we really need is to see the cases where TRACE_EVENT() is used as a
declaration vs the case where it expands
TP_STRUCT__entry/TP_fast_assign/TP_printk as having different
dependencies. The problem comes when we bring the include dependencies
of the TP_fast_assign part into the tracepoint header and it becomes
a dependency of the TRACE_EVENT() declaration-only part.

Can we do the following ?

All tracepoint headers could surround the include dependencies by :

#ifdef BUILD_EVENTS
#include <veryannoyingheaderdependency.h>
#endif

And then we follow this by the TRACE_EVENT() declarations.

BUILD_EVENTS would only be defined in kernel/trace/events.c.

I think it should work, but it looks a bit too simple, so I may have
missed something... ?

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
