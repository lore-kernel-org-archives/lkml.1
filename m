Return-Path: <linux-kernel-owner+w=401wt.eu-S1755712AbYKCN6E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712AbYKCN6E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 08:58:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753952AbYKCN5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 08:57:53 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:16381 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924AbYKCN5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 08:57:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=O4faYdOajInf+TQsSAeJueYhYK8+GbdHCXsNB86L0+INDpBu/5bcVZYJXdKZ6y7bnt
         fJBpt3xCqqc0NzmRR20MdwOwdL7x2Up0MxWkkJuPXDeUlRHwb1KP9RX51kTdz3skgpLF
         wjlAarTG87vLvAOS/4JPc/2rLweQmbBHVz/RU=
Message-ID: <490F035A.5070209@gmail.com>
Date: Mon, 03 Nov 2008 15:57:46 +0200
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Robert Richter <robert.richter@amd.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, srostedt@redhat.com,
       a.p.zijlstra@chello.nl, sandmann@daimi.au.dk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Identify which executable object the userspace address
 belongs to. Store thread group leader id, and use it to lookup the address
 in the process's map. We could have looked up the address on thread's map,
 but the thread might not exist by the time we are called. The process might
 not exist either, but if you are reading trace_pipe, that is unlikely.
References: <1225660694-19765-1-git-send-email-edwintorok@gmail.com> <1225660694-19765-2-git-send-email-edwintorok@gmail.com> <1225660694-19765-3-git-send-email-edwintorok@gmail.com> <20081103074754.GB13727@elte.hu> <490EB361.9090007@gmail.com> <20081103082932.GF28771@elte.hu>
In-Reply-To: <20081103082932.GF28771@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-11-03 10:29, Ingo Molnar wrote:
> * Török Edwin <edwintorok@gmail.com> wrote:
>
>   
>>> Your patches are a nice feature we want to have nevertheless - to 
>>> be able to see where a user-space app is running has been one of 
>>> the historically weak points of kernel instrumentation.
>>>       
>> Thanks.
>> It currently works for x86 only, but architecture porters can add
>> support for theirs quite easily, it just needs to modeled after how
>> oprofile does it for example.
>> BTW would it make sense to change oprofile and the sysprof tracer to use
>> save_stack_trace_user? It would eliminate some code duplication.
>>     
>
> that definitely sounds like the right direction. I've Cc:-ed Robert 
> Richter, the Oprofile maintainer - please Cc: him to code that touches 
> oprofile.
>
> note that NMI interaction of user-space stackframe walkers can be a 
> bit tricky: the basic problem is that if you fetch a user-space 
> stackframe that can create a fault

The code in trace_sysprof.c (which I used as a base for the
save_stack_trace_user) disables pagefaults
before reading the stackframe from userspace. Does it avoid this problem
then?

Note that due to its use from ftrace, the userstack walker can be called
from the pagefault handler itself, and if it is
allowed to fault it could lead to some form of deadlock. Are the ftrace
functions protected from recursively reentering themselves?

> , and the IRET at the end of the 
> fault handler will re-enable NMIs (violating the NMI code's 
> assumptions).
>   

Is this already a problem with oprofile's user-stack walker?

> there are patches on lkml written by Mathieu Desnoyers that solve this 
> by changing all the fault path to use RET instead of IRET. It might 
> make sense to dust them off - we carried them for a long time in -tip 
> and they were robust. (they just never had any really strong 
> justification and were rather complex - that changes now)
>
> Mathieu, what do you think?
>
>   
>> Would it make sense to add a script that post-processes the output 
>> to scripts/tracing?
>>
>> It would parse a trace log (from trace or latency_trace) and use 
>> addr2line to resolve the address to source:line, and if successful 
>> replace the relative address with that; and also group identical 
>> stack traces together.
>>     
>
> sure, please add it to scripts/tracing/.
>   

Ok, will do so in v3.

> The best approach would be if the kernel could output the best info by 
> default

The kernel could do some grouping and counting (as latencytop does), but
I don't see where it would fit in frace's infrastructure.

I think ftrace's one entry per event is useful in many situations
(debugging, latency measurements), but if the events occur too frequently
it could produce too much data, and it would be more efficient to do
some counting/grouping of similar info in-kernel before outputting to
userspace.
Perhaps as a layer on top of ftrace? What do you think?

>  - but that seems rather hard for addr2line functionality which 
> involves debuginfo processing, etc.
>   

yes it would be an overkill to try to do that from the kernel, when it
is so easy to do from userspace ;)

Best regards,
--Edwin
