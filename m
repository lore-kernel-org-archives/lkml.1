Return-Path: <linux-kernel-owner+w=401wt.eu-S1755079AbZELNOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079AbZELNOs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 09:14:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752229AbZELNOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 09:14:38 -0400
Received: from tomts22.bellnexxia.net ([209.226.175.184]:43905 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751911AbZELNOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 09:14:38 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhMJADcPCUpMQW1W/2dsb2JhbACBUIEwyVuEAgU
Date: Tue, 12 May 2009 09:14:36 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, fweisbec@gmail.com, zhaolei@cn.fujitsu.com,
       laijs@cn.fujitsu.com, Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH v3] ftrace: add a tracepoint for
	__raise_softirq_irqoff()
Message-ID: <20090512131435.GA13712@Krystal>
References: <49FFDF9C.7040505@cn.fujitsu.com> <20090505161604.GA15524@Krystal> <4A07D3B3.10605@cn.fujitsu.com> <20090511134019.GB10932@Krystal> <alpine.DEB.2.00.0905111003280.14976@gandalf.stny.rr.com> <20090511142734.GA12722@Krystal> <alpine.DEB.2.00.0905111039470.2492@gandalf.stny.rr.com> <20090511151353.GA14391@Krystal> <4A094677.5090900@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <4A094677.5090900@cn.fujitsu.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:07:14 up 73 days,  9:33,  3 users,  load average: 0.18, 0.21,
	0.15
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Xiao Guangrong (xiaoguangrong@cn.fujitsu.com) wrote:
> 
> 
> Mathieu Desnoyers wrote:
> > * Steven Rostedt (rostedt@goodmis.org) wrote:
> >>
> >>
> >> On Mon, 11 May 2009, Mathieu Desnoyers wrote:
> >>
> >>> * Steven Rostedt (rostedt@goodmis.org) wrote:
> >>>> On Mon, 11 May 2009, Mathieu Desnoyers wrote:
> >>>>> Yes, we should try to fix TRACE_EVENT, but we should fix it _before_ we
> >>>>> start using it widely. Circular header dependencies is a real problem
> >>>>> with TRACE_EVENT right now.
> 
> > Yes, but this would solve most of the include dependency problems at
> > once. We would only have dependency on preempt.h left, which alone is
> > easier to deal with. And if headers don't need to include any annoying
> > headers, they don't need to use the ifdef BUILDING_EVENTS. But my point
> > is that when it's needed (and we already see two cases where it's
> > needed, with pvops instrumentation and softirq instrumentation, and I
> > guess we'll see much more), it's good to have this infrastructure in
> > place, so people don't end up trying to do hacks to the kernel code
> > changing inlines for function calls to try to deal with the circular
> > include issue.
> > 
> > I think it's
> > 
> > a) needed
> > b) it does not hurt anyone who does not need it.
> > 
> > So I would definitely recommend adding such define.
> > 
> 
> Sorry for my poor English.
> Problem is not only in TP_printk, but also in TP_PROTO if we add a
> tracer in header file.
> So, it can't be solved only by "get rid of including ftrace parts"
> 
> Take v2 patch for example: 
> (it is at: http://marc.info/?l=linux-kernel&m=124081169727739&w=2) 
> 
> In order to trace __raise_softirq_irqoff(), we should add 
> a trace function in  __raise_softirq_irqoff() and include 
> <include/trace/irq.h> in interrupte.h. 
> If we put <include/trace/irq.h> on top of linux/irq.h,
> we will see a warning of "struct softirq_action declared
> inside parameter list" in compile. It is because struct irqaction's
> definition is bypasswd before TP_PROTO.
> 

Then add a forward declaration of

struct softirqaction;

At the top of trace/irq.h. I did it in quite a few places in the LTTng
tree. TP_PROTO just needs a forward declaration, not the full structure
declaration.

Only the ftrace-specific parts will need the #include <linux/irq.h>,
which we should put in a #ifdef :

sched.c:
#include linux/interrupt.h
        |
        |-->include <trace/irq.h>
            #ifdef BUILDING_EVENTS
            /*
             * Includes needed by TP_fast_assign, TP_printk, and
             * TP_STRUCT__entry :
             */
            # include <linux/interrupt.h>
            #else
	    /* Forward declarations for TP_PROTO */
            struct softirq_action;
            #endif

            TRACE_EVENT(......);
            |-->TP_PROTO(int irq, struct irqaction *action),
                (but struct softirq_action is not declared before,
                 it raise a compile warning:struct softirq_action declared
                 inside parameter list.
            |-> ......

Mathieu

> 	
> I can't see the solvent for this in your discuss or I understand wrong? 
> 
> Xiao
> 
> > Mathieu
> > 
> >> -- Steve
> >>
> >>> I think it should work, but it looks a bit too simple, so I may have
> >>> missed something... ?
> >>>
> >>> Mathieu
> >>>
> >>>
> >>> -- 
> >>> Mathieu Desnoyers
> >>> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> >>>
> > 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
