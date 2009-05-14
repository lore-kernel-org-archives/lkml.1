Return-Path: <linux-kernel-owner+w=401wt.eu-S932140AbZENDut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932140AbZENDut (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 23:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754664AbZENDuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 23:50:39 -0400
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:43691 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754646AbZENDui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 23:50:38 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: As8EAKUsC0pMQW1W/2dsb2JhbACBUMxVhAIF
Date: Wed, 13 May 2009 23:50:37 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com,
       rostedt@goodmis.org, zhaolei@cn.fujitsu.com,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH v3] ftrace: add a tracepoint for
	__raise_softirq_irqoff()
Message-ID: <20090514035037.GA8159@Krystal>
References: <49FFDF9C.7040505@cn.fujitsu.com> <20090505161604.GA15524@Krystal> <4A07D3B3.10605@cn.fujitsu.com> <20090511134019.GB10932@Krystal> <4A0B859B.8070801@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <4A0B859B.8070801@cn.fujitsu.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 23:49:15 up 75 days, 15 min,  5 users,  load average: 0.27, 0.31,
	0.33
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Lai Jiangshan (laijs@cn.fujitsu.com) wrote:
> Mathieu Desnoyers wrote:
> > 
> > I partially agree with you :
> > 
> > Yes, we should try to fix TRACE_EVENT, but we should fix it _before_ we
> > start using it widely. Circular header dependencies is a real problem
> > with TRACE_EVENT right now.
> > 
> > Until we fix this, I will be tempted to stay with a known-good solution,
> > which is DECLARE/DEFINE_TRACE.
> > 
> > 
> 
> I partially agree with you:
> 
> Yes, Circular header dependencies is a real problem with TRACE_EVENT
> right now. It is also a problem with DECLARE_TRACE. It's a stubborn
> disease with C-Language (for complex headers). Can we fix C-Language?
> 
> o Macros in header (!CREATE_TRACE_POINTS)
> 
> When CREATE_TRACE_POINTS is not defined, TRACE_EVENT is definitely
> the same as DECLARE_TRACE. Actually, TRACE_EVENT is:
> 
> #define TRACE_EVENT(name, proto, args, struct, assign, print)	\
> 	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
> 
> So TRACE_EVENT and DECLARE_TRACE are the same in header files.
> And so TRACE_EVENT and DECLARE_TRACE have the same advantages and
> disadvantages. More TRACE_EVENT equals to a known-good solution.
> 
> o Macros in c-file
> 
> tracepoint uses DEFINE_TRACE only.
> 
> ftrace uses CREATE_TRACE_POINTS + TRACE_EVENT:
> 	#define CREATE_TRACE_POINTS
> 	#include <trace/events/sched.h> (which uses TRACE_EVENT)
> 
> ftrace generates more code which uses the tracepoints.
> 
> > 
> > Then add a forward declaration of
> > 
> > struct softirqaction;
> > 
> > At the top of trace/irq.h. I did it in quite a few places in the LTTng
> > tree. TP_PROTO just needs a forward declaration, not the full structure
> > declaration.
> > 
> 
> Thank you for your valuable suggestions.
> 
> You are the father of tracepoint and LTTng, your experience in
> LTTng is very useful for ftrace.
> 
> I'm glad for your suggestions.
> 
> 
> Xiao Guangrong, could you add forward declarations of
> 
> struct irqaction;
> struct softirq_action;
> 
> at the top of trace/irq.h as Mathieu's suggestions.
> (and remove "#include <linux/interrupt.h>")
> 

You will probably still need something like :

#ifdef CREATE_TRACE_POINTS
#include <linux/interrupt.h>
#else
struct irqaction;
struct softirq_action;
#endif

So that FTRACE has the header dependencies it needs to build.

Mathieu

> Lai
> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
