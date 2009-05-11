Return-Path: <linux-kernel-owner+w=401wt.eu-S1754767AbZEKNkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbZEKNkb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 09:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751600AbZEKNkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 09:40:21 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:37991 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751531AbZEKNkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 09:40:20 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmQFAMrEB0pMQW1W/2dsb2JhbACBUMsdg34F
Date: Mon, 11 May 2009 09:40:19 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com,
       rostedt@goodmis.org, zhaolei@cn.fujitsu.com, laijs@cn.fujitsu.com,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH v3] ftrace: add a tracepoint for
	__raise_softirq_irqoff()
Message-ID: <20090511134019.GB10932@Krystal>
References: <49FFDF9C.7040505@cn.fujitsu.com> <20090505161604.GA15524@Krystal> <4A07D3B3.10605@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <4A07D3B3.10605@cn.fujitsu.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:38:36 up 72 days, 10:04,  3 users,  load average: 0.72, 1.34,
	1.56
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Xiao Guangrong (xiaoguangrong@cn.fujitsu.com) wrote:
> 
> 
> Mathieu Desnoyers wrote:
> > * Xiao Guangrong (xiaoguangrong@cn.fujitsu.com) wrote:
> >> From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> >>
> 
> >> +#ifdef CONFIG_TRACEPOINTS
> >> +extern void __raise_softirq_irqoff(unsigned int nr);
> >> +#else
> >>  #define __raise_softirq_irqoff(nr) do { or_softirq_pending(1UL << (nr)); } while (0)
> > 
> > Can you put the 
> > 	trace_irq_softirq_raise(nr);
> > 
> > directly in the define rather than adding this weird CONFIG_TRACEPOINTS?
> > (and change the define for a static inline), something like :
> > 
> > static inline void __raise_softirq_irqoff(unsigned int nr)
> > {
> > 	trace_irq_softirq_raise(nr);
> > 	or_softirq_pending(1UL << (nr);
> > }
> > 
> > This would ensure we don't add a function call on the
> > __raise_softirq_irqoff() fast-path.
> > 
> 
> We did this in v2, and we think it is better for same reason.
> But ...
> 
> > Beware of circular include dependencies though. The tracepoints are
> > meant not to have this kind of problems (I try to keep the dependencies
> > very minimalistic), but I wonder if Steven's TRACE_EVENT is now ok on
> > this aspect.
> > 
> 
> We encount this type of problem in v2.
> So we move to this version(v3).
> 
> > If TRACE_EVENT happens to pose problems with circular header
> > dependencies, then try moving to the DECLARE_TRACE/DEFINE_TRACE scheme
> > which has been more thoroughly tested as a first step.
> > 
> 
> IMHO, TRACE_EVENT framework is better for its more generic as ingo said,
> and it also provide ftrace support which means user can view tracepoint
> information from /debug/tracing/events.
> 
> Although this TRACE_EVENT happens to expose problems with circular header
> dependencies, we should not refuse using TRACE_EVENT, instead we should
> try to fix it for the whole TRACE_EVENT facility later.
> 

I partially agree with you :

Yes, we should try to fix TRACE_EVENT, but we should fix it _before_ we
start using it widely. Circular header dependencies is a real problem
with TRACE_EVENT right now.

Until we fix this, I will be tempted to stay with a known-good solution,
which is DECLARE/DEFINE_TRACE.

Mathieu

> Thanks
> 
> > Mathieu
> > 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
