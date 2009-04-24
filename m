Return-Path: <linux-kernel-owner+w=401wt.eu-S1757566AbZDXGoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566AbZDXGoS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 02:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755190AbZDXGoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 02:44:04 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59073 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867AbZDXGoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 02:44:03 -0400
Date: Fri, 24 Apr 2009 08:44:00 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Tim Bird <tim.bird@am.sony.com>
Cc: linux kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Russell King <rmk@arm.linux.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] Add function graph tracer support for ARM
Message-ID: <20090424064400.GB9502@pengutronix.de>
References: <49F0AEA2.5010309@am.sony.com> <20090423183905.GA8383@pengutronix.de> <49F0E284.2080104@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49F0E284.2080104@am.sony.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Apr 23, 2009 at 02:49:56PM -0700, Tim Bird wrote:
> >> @@ -23,6 +23,7 @@ obj-$(CONFIG_ISA_DMA)		+= dma-isa.o
> >>  obj-$(CONFIG_PCI)		+= bios32.o isa.o
> >>  obj-$(CONFIG_SMP)		+= smp.o
> >>  obj-$(CONFIG_DYNAMIC_FTRACE)	+= ftrace.o
> >> +obj-$(CONFIG_FUNCTION_GRAPH_TRACER)	+= ftrace.o
> > I there a reason that CONFIG_DYNAMIC_FTRACE and
> > CONFIG_FUNCTION_GRAPH_TRACER share the same source file?
> ftrace.c has stuff from both, so you want it "turned on"
> if one or the other (or both) are configed on.
I got this ...
> 
> I'll look at whether it makes sense to split these two into
> separate files.  This issue may be resolved by the code
> movement that Frederic Weisbecker mentioned in his e-mail.
... and this was my intention.
 
> >> --- a/arch/arm/kernel/entry-common.S
> >> +++ b/arch/arm/kernel/entry-common.S
> >> @@ -135,8 +135,16 @@ ENTRY(mcount)
> >>  	adr r0, ftrace_stub
> >>  	cmp r0, r2
> >>  	bne trace
> >> +
> >> +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
> >> +	ldr r1, =ftrace_graph_return
> >> +	ldr r2, [r1]
> >> +	cmp r0, r2		@ if *ftrace_graph_return != ftrace_stub
> >> +	bne ftrace_graph_caller
> >> +#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
> >> +
> >>  	ldr lr, [fp, #-4]			@ restore lr
> >> -	ldmia sp!, {r0-r3, pc}
> >> +	ldmia sp!, {r0-r3, pc}			@ return doing nothing
> > If ftrace_trace_function != ftrace_stub then ftrace_graph_caller isn't
> > called.  Is this correct?
> My comment is possibly misleading here.  The sense of the
> '!=' includes the 'n' portion of the 'bne' on the following line.
> So the logic is:
> if *ftrace_graph_return != ftrace stub, branch to ftrace_graph_caller
> or in other words
> if *ftrace_graph_return == ftrace_stub, return doing nothing
> 
> Maybe I should just remove the comment and let the code
> speak for itself?  (or maybe move the comment down one line?)
Yes, the comments are as good as the comments for ftrace_trace_function.
What I meant is that with your code using both ftrace_trace_function and
ftrace_graph_caller doesn't work, because if ftrace_trace_function !=
ftrace_stub then the check for ftrace_trace_function is simply skipped.

And I just noticed something else:  There is a 2nd implementation of
mcount in arch/arm/kernel/entry-common.S for CONFIG_DYNAMIC_FTRACE
(which is currently not selectable for ARM).  Maybe add a note to this
mcount that it needs fixing for graph tracing when it is revived?
 
Best regards
Uwe 

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
