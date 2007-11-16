Return-Path: <linux-kernel-owner+w=401wt.eu-S1763665AbXKPBws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763665AbXKPBws (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 20:52:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756157AbXKPBwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 20:52:41 -0500
Received: from dpc691978010.direcpc.com ([69.19.78.10]:41359 "EHLO
	third-harmonic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754476AbXKPBwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 20:52:40 -0500
Message-ID: <473CF8A5.9030101@third-harmonic.com>
Date: Thu, 15 Nov 2007 20:55:49 -0500
From: john cooper <john.cooper@third-harmonic.com>
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Tim Bird <tim.bird@am.sony.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>,
       john cooper <john.cooper@third-harmonic.com>
Subject: Re: MIPS RT debug support
References: <473B8F91.20704@am.sony.com> <alpine.LFD.0.9999.0711150143220.3265@localhost.localdomain> <473BADD4.5030400@third-harmonic.com> <473CD6E1.1060607@am.sony.com> <Pine.LNX.4.58.0711151956430.30058@gandalf.stny.rr.com>
In-Reply-To: <Pine.LNX.4.58.0711151956430.30058@gandalf.stny.rr.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Thu, 15 Nov 2007, Tim Bird wrote:
> 
>> john cooper wrote:
>>> The more daunting problem stems from limitations in the MIPS
>>> ABI which makes the latency trace support problematic.
>>> Rather than rehash the issue:
>>>
>>>     http://lists.linuxcoding.com/kernel/2005-q4/msg10163.html
>>>
>>> Until we have a usable instrumentation solution in place,
>>> characterization, debug, and support of PREEMPT_RT for MIPS
>>> is going to be a challenge.
>> Agreed.  I have been using KFT (Kernel Function Trace)
>> on MIPS, and it has decent support for function traceback
>> reporting, but it's not currently integrated with latency-trace
>> at all.   We should discuss if this could possibly be
>> used to debug RT-preempt.  It is much heavier weight than
>> the mcount stuff, but uses similar (but not identical)
>> gcc profiling instrumentation.  I'm not sure if the
>> two can be turned on together, or how hard it would
>> be to move latency-trace onto -finstrument_functions.
> 
> I'm not familiar with the KFT but I'm sure it would be easy to port
> latency_trace to it. Really, all the mcount does is make a wrapper to pass
> to the trace calls.

It isn't an issue of getting a hook into the FUNCTION_PROLOGUE
(mcount() here) but rather of emulating the CALLER_ADDR[0123]
defs which map onto the gcc internal __builtin_return_address().
Doing so using the affectionately dubbed "Three Stooges Algorithm"
called out in the MIPS ABI is both complex and nondeterministic.

The entry FUNCTION_PROLOGUE hook provides a means to log the path
traveled thus far.  __builtin_return_address() gives a way to
snapshot a stub of the stack invocation. Together they provide
somewhat complimentary but useful debug information.

We could log the stack invocation progress in the latency
instrumentation itself by noting a new invocation in the
FUNCTION_PROLOGUE and unwind of the same in the currently
unused FUNCTION_EPILOGUE hook.  So we're just shadowing the
actual runtime stack in effect with a data structure which
can be traversed far more easily.

-john

-- 
john.cooper@third-harmonic.com
