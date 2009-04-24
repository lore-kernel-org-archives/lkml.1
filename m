Return-Path: <linux-kernel-owner+w=401wt.eu-S1758259AbZDXSBG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758259AbZDXSBG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 14:01:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753556AbZDXSAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 14:00:54 -0400
Received: from wa4ehsobe004.messaging.microsoft.com ([216.32.181.14]:40373
	"EHLO WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752651AbZDXSAx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 14:00:53 -0400
X-BigFish: VPS-13(zz98dR103dKzz1202hzzz2fh6bh61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
Message-ID: <49F1FE34.9060908@am.sony.com>
Date: Fri, 24 Apr 2009 11:00:20 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: =?UTF-8?B?VXdlIO+/vQ==?= <u.kleine-koenig@pengutronix.de>
CC: linux kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Russell King <rmk@arm.linux.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] Add function graph tracer support for ARM
References: <49F0AEA2.5010309@am.sony.com> <20090423183905.GA8383@pengutronix.de> <49F0E284.2080104@am.sony.com> <20090424064400.GB9502@pengutronix.de>
In-Reply-To: <20090424064400.GB9502@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-OriginalArrivalTime: 24 Apr 2009 18:00:21.0642 (UTC) FILETIME=[890A9EA0:01C9C506]
X-SEL-encryption-scan: scanned
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uwe � wrote:
>>>> --- a/arch/arm/kernel/entry-common.S
>>>> +++ b/arch/arm/kernel/entry-common.S
>>>> @@ -135,8 +135,16 @@ ENTRY(mcount)
>>>>  	adr r0, ftrace_stub
>>>>  	cmp r0, r2
>>>>  	bne trace
>>>> +
>>>> +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
>>>> +	ldr r1, =ftrace_graph_return
>>>> +	ldr r2, [r1]
>>>> +	cmp r0, r2		@ if *ftrace_graph_return != ftrace_stub
>>>> +	bne ftrace_graph_caller
>>>> +#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
>>>> +
>>>>  	ldr lr, [fp, #-4]			@ restore lr
>>>> -	ldmia sp!, {r0-r3, pc}
>>>> +	ldmia sp!, {r0-r3, pc}			@ return doing nothing
>>> If ftrace_trace_function != ftrace_stub then ftrace_graph_caller isn't
>>> called.  Is this correct?
...
> Yes, the comments are as good as the comments for ftrace_trace_function.
> What I meant is that with your code using both ftrace_trace_function and
> ftrace_graph_caller doesn't work, because if ftrace_trace_function !=
> ftrace_stub then the check for ftrace_trace_function is simply skipped.

OK - I understand now.  I didn't think of this case, but you
are correct.  This has the same behavior as the x86 case.
Whether that's good or not is hard to say.  I wouldn't want
to add extra tests (since this is very much a hot path), but
maybe this should be noted somewhere.  I'll test to see
how this impacts the user-visible operation of the tracers.
(I assume this means you would have to reset the function
tracer, if it was active, before invoking a function graph
tracer.)

Alternatively, maybe the logic of installing the function graph
tracer should automatically reset the function tracer?

Steve,

Should both a function trace and a function graph tracer
be allowed to be active at the same time?  I would think
not, but maybe there's a use case I'm missing.

> And I just noticed something else:  There is a 2nd implementation of
> mcount in arch/arm/kernel/entry-common.S for CONFIG_DYNAMIC_FTRACE
> (which is currently not selectable for ARM).  Maybe add a note to this
> mcount that it needs fixing for graph tracing when it is revived?

Good catch.  I'll put something in.

Thanks!!
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

