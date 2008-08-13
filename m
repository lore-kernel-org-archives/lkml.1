Return-Path: <linux-kernel-owner+w=401wt.eu-S1756923AbYHMUBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923AbYHMUBr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 16:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751871AbYHMUBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 16:01:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752021AbYHMUBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 16:01:38 -0400
Message-ID: <48A33D65.4020802@redhat.com>
Date: Wed, 13 Aug 2008 16:00:37 -0400
From: Steven Rostedt <srostedt@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
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
References: <20080813191926.GB15547@Krystal>
In-Reply-To: <20080813191926.GB15547@Krystal>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[
  Thanks to Mathieu Desnoyers who forward this to me. Currently my ISP 
for goodmis.org is having issues:
  https://help.domaindirect.com/index.php?_m=news&_a=viewnews&newsid=104
]
> ----- Forwarded message from Andi Kleen <andi@firstfloor.org> -----
>
>   
>> So microbenchmarking this way will probably make some things look 
>> unrealistically good. 
>>     
>
> Must be careful to miss the big picture here.
>
> We have two assumptions here in this thread:
>
> - Normal alternative() nops are relatively infrequent, typically
> in points with enough pipeline bubbles anyways, and it likely doesn't
> matter how they are encode. And also they don't have an issue
> with mult part instructions anyways because they're not patched
> at runtime, so always the best known can be used.
>
> - The one case where nops are very frequent and matter and multipart
> is a problem is with ftrace noping out the call to mcount at runtime 
> because that happens on every function entry.
> Even there the overhead is not that big, but at least measurable 
> in kernel builds.
>   

The problem is not ftrace noping out the call at runtime. The problem is 
ftrace changing the nops back to calls to mcount.

The nop part is simple, straight forward and not an issue that we are 
talking here. The issue is which kind of nop to use. The bug with the 
multi-part nop happens when we _enable_ tracing. That is, when someone 
runs the tracer. The issue with the multi-part nop is that a task could 
have been preempted after it executed the first nop and before the 
second part. Then we enable tracing, and when the task is scheduled back 
in, it now will execute half the call to the mcount function.

I want this point very clear. If you never run tracing, this bug will 
not happen. And the bug only happens on enabling the tracer, not on the 
disabling part. Not to mention that the bug itself will only happen 1 in 
a billion.

> Now the numbers have shown that just by not using frame pointer (
> -pg right now implies frame pointer) you can get more benefit 
> than what you lose from using non optimal nops.
>   

No, I can easily make a patch that does not use frame pointers but still 
uses -pg. We just can not print the parent function in the trace. This 
can easily be added to a config, as well as easily implemented.
> So for me the best strategy would be to get rid of the frame pointer
> and ignore the nops. This unfortunately would require going away
> from -pg and instead post process gcc output to insert "call mcount"
> manually. But the nice advantage of that is that you could actually 
> set up a custom table of callers built in a ELF section and with
> that you don't actually need the runtime patching (which is only
> done currently because there's no global table of mcount calls),
> but could do everything in stop_machine(). Without
> runtime patching you also don't need single part nops. 
>
>   

I'm totally confused here.  How do you enable function tracing?  How do 
we make a call to the code that will trace a function was hit?

> I think that would be the best option. I especially like it because
> it would prevent forcing frame pointer which seems to be costlier
> than any kinds of nosp.

As I stated, the frame pointer part is only to record the parent 
function in tracing. ie:

             ls-4866  [00] 177596.041275: _spin_unlock <-journal_stop


Here we see that the function _spin_unlock was called by the function 
journal_stop. We can easily turn off parent tracing now, with:

# echo noprint-parent > /debug/tracing/iter_ctrl

which gives us just:

             ls-4866  [00] 177596.041275: _spin_unlock


If we disable frame pointers, the noprint-parent option would be forced. 
Not that devastating, but it gives the option to still have function 
tracing to the user without the requirement of having frame pointers.

I would still require that the irqsoff tracer add frame pointers, just 
because knowing that the long latency of interrupts disabled happened at 
local_irq_save doesn't cut it ;-)

Anyway, who would want to run with frame pointers disabled? If you ever 
get a bug crash, the stack trace is pretty much useless.

-- Steve

