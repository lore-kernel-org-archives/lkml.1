Return-Path: <linux-kernel-owner+w=401wt.eu-S1757918AbYHMUOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757918AbYHMUOe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 16:14:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757494AbYHMUOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 16:14:17 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57763 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757471AbYHMUOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 16:14:16 -0400
Date: Wed, 13 Aug 2008 22:15:32 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Steven Rostedt <srostedt@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Roland McGrath <roland@redhat.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>
Subject: Re: Efficient x86 and x86_64 NOP microbenchmarks
Message-ID: <20080813201532.GR1366@one.firstfloor.org>
References: <20080813191926.GB15547@Krystal> <48A33D65.4020802@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48A33D65.4020802@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2008 at 04:00:37PM -0400, Steven Rostedt wrote:
> >Now the numbers have shown that just by not using frame pointer (
> >-pg right now implies frame pointer) you can get more benefit 
> >than what you lose from using non optimal nops.
> >  
> 
> No, I can easily make a patch that does not use frame pointers but still 

Not without patching gcc. Try it. The patch is not very difficult and i did
it here, but it needs a patch. 

> If we disable frame pointers, the noprint-parent option would be forced. 

Actually you can get the parent without frame pointer if you just
force gcc to emit mcount before touching the stack frame (and manual
insertion pass would do that). Then parent is at 4(%esp)/8(%rsp)   
Again teaching gcc that is not very difficult, but it needs a patch.

> I would still require that the irqsoff tracer add frame pointers, just 
> because knowing that the long latency of interrupts disabled happened at 
> local_irq_save doesn't cut it ;-)

Nope.
> 
> Anyway, who would want to run with frame pointers disabled? If you ever 
> get a bug crash, the stack trace is pretty much useless.

First that's not true (remember most production kernels run
without frame pointers, also e.g. crash or systemtap know how to do proper 
unwinding without slow frame pointers) and if you want it runtime also you 
can always add the dwarf2 unwinder (like the opensuse kernel does) and get 
better backtraces than you could ever get with frame pointers (that is 
because e.g.  most assembler code doesn't even bother to set up frame 
pointers, but it is all dwarf2 annotated) 

Also I must say the whole ftrace noping exercise is pretty pointless without
avoiding frame pointers because it does save less than what you lose
unconditionally from the "select FRAME_POINTER"

-Andi
