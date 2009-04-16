Return-Path: <linux-kernel-owner+w=401wt.eu-S1757742AbZDPC3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757742AbZDPC3n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 22:29:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752905AbZDPC3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 22:29:32 -0400
Received: from tomts10.bellnexxia.net ([209.226.175.54]:39700 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751284AbZDPC3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 22:29:31 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsMFABc05klMQW1W/2dsb2JhbACBUc9Fg30G
Date: Wed, 15 Apr 2009 22:29:28 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Steven Rostedt <rostedt@goodmis.org>, Theodore Tso <tytso@mit.edu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Christoph Hellwig <hch@lst.de>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@elastic.org>, Tom Zanussi <tzanussi@gmail.com>,
       Jiaying Zhang <jiayingz@google.com>, Michael Rubin <mrubin@google.com>,
       Martin Bligh <mbligh@google.com>
Subject: Re: [PATCH 0/8] [GIT PULL] TRACE_EVENT for modules
Message-ID: <20090416022928.GB22378@Krystal>
References: <20090414172337.280621613@goodmis.org> <20090414210445.GM955@mit.edu> <49E504C1.9010401@goop.org> <alpine.DEB.2.00.0904141753500.31421@gandalf.stny.rr.com> <49E50F2F.5070507@goop.org> <20090415082931.GF18192@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090415082931.GF18192@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 22:26:50 up 46 days, 22:53,  1 user,  load average: 0.27, 0.28,
	0.31
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> 
> > Steven Rostedt wrote:
> >> On Tue, 14 Apr 2009, Jeremy Fitzhardinge wrote:
> >>
> >>   
> >>> Theodore Tso wrote:
> >>>     
> >>>> Any chance you could support something like this?
> >>>>
> >>>>         
> >>> I think that's already there.  I'm defining
> >>> arch/x86/include/asm/paravirt-trace.h with:
> >>>
> >>> #ifndef _ASM_X86_PARAVIRT_TRACE_H
> >>> #define _ASM_X86_PARAVIRT_TRACE_H
> >>>
> >>> #include <linux/tracepoint.h>
> >>> #include <asm/paravirt_types.h>
> >>>
> >>> #undef TRACE_SYSTEM
> >>> #define TRACE_SYSTEM pvops
> >>>
> >>> #define TRACE_INCLUDE_FILE	paravirt-trace
> >>> #define TRACE_INCLUDE_PATH	asm
> >>> [...]
> >>>
> >>>
> >>> Which ends up including <asm/paravirt-trace.h>
> >>>     
> >>
> >> Not quite. It ends up looking like
> >>
> >> #include "asm/paravirt-trace.h"
> >>
> >> As long as there is no "asm" directory in the include/trace directory, 
> >> I think that is fine.
> >
> > OK.
> >
> > I'm having a bit of trouble with paravirt-trace.h when I actually 
> > include it in paravirt.h.  asm/paravirt.h is itself included in 
> > lots of places, and so its fairly easy to end up with cyclic 
> > include dependencies which are fairly painful.  In this case I'm 
> > seeing asm/paravirt.h -> linux/tracepoint.h -> linux/rcupate.h -> 
> > {lots of stuff}, which gives errors like:
> 
> tracepoint.h should not include any complex headers like rcupdate.h.
> 
> > I'm wondering if there's much downside in making the code 
> > __DO_TRACE() out of line so that we can make tracepoint.h have 
> > absolutely minimal include dependencies?
> 
> yeah.
> 
> And besides, the rcu_read_lock_sched_notrace() there should probably 
> be a preempt_disable_notrace() / preempt_enable_notrace() variant. 
> (it's sligtly faster that way and we better be atomic and 
> self-sufficient in tracepoints anyway)
> 

Yes, rcu_read_(un)lock_sched_notrace maps directly to
preempt_(en/dis)able_notrace. But for RCU verifiability's sake, I made
sure to create rcu_read_lock versions of these primitives instead of
simply using preempt_disable. Maybe we should simply take those
low-level primitives out of rcupdate.h and put them in a simpler header?

Mathieu


> 	Ingo
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
