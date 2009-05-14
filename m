Return-Path: <linux-kernel-owner+w=401wt.eu-S1761828AbZENGKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761828AbZENGKl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 02:10:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbZENGKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 02:10:31 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49552 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751058AbZENGKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 02:10:31 -0400
Message-ID: <4A0BB4EA.60203@cn.fujitsu.com>
Date: Thu, 14 May 2009 14:06:34 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com,
       rostedt@goodmis.org, zhaolei@cn.fujitsu.com,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH v3] ftrace: add a tracepoint for	__raise_softirq_irqoff()
References: <49FFDF9C.7040505@cn.fujitsu.com> <20090505161604.GA15524@Krystal> <4A07D3B3.10605@cn.fujitsu.com> <20090511134019.GB10932@Krystal> <4A0B859B.8070801@cn.fujitsu.com> <20090514035037.GA8159@Krystal>
In-Reply-To: <20090514035037.GA8159@Krystal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> * Lai Jiangshan (laijs@cn.fujitsu.com) wrote:
>> Mathieu Desnoyers wrote:
>>> I partially agree with you :
>>>
>>> Yes, we should try to fix TRACE_EVENT, but we should fix it _before_ we
>>> start using it widely. Circular header dependencies is a real problem
>>> with TRACE_EVENT right now.
>>>
>>> Until we fix this, I will be tempted to stay with a known-good solution,
>>> which is DECLARE/DEFINE_TRACE.
>>>
>>>
>> I partially agree with you:
>>
>> Yes, Circular header dependencies is a real problem with TRACE_EVENT
>> right now. It is also a problem with DECLARE_TRACE. It's a stubborn
>> disease with C-Language (for complex headers). Can we fix C-Language?
>>
>> o Macros in header (!CREATE_TRACE_POINTS)
>>
>> When CREATE_TRACE_POINTS is not defined, TRACE_EVENT is definitely
>> the same as DECLARE_TRACE. Actually, TRACE_EVENT is:
>>
>> #define TRACE_EVENT(name, proto, args, struct, assign, print)	\
>> 	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
>>
>> So TRACE_EVENT and DECLARE_TRACE are the same in header files.
>> And so TRACE_EVENT and DECLARE_TRACE have the same advantages and
>> disadvantages. More TRACE_EVENT equals to a known-good solution.
>>
>> o Macros in c-file
>>
>> tracepoint uses DEFINE_TRACE only.
>>
>> ftrace uses CREATE_TRACE_POINTS + TRACE_EVENT:
>> 	#define CREATE_TRACE_POINTS
>> 	#include <trace/events/sched.h> (which uses TRACE_EVENT)
>>
>> ftrace generates more code which uses the tracepoints.
>>
>>> Then add a forward declaration of
>>>
>>> struct softirqaction;
>>>
>>> At the top of trace/irq.h. I did it in quite a few places in the LTTng
>>> tree. TP_PROTO just needs a forward declaration, not the full structure
>>> declaration.
>>>
>> Thank you for your valuable suggestions.
>>
>> You are the father of tracepoint and LTTng, your experience in
>> LTTng is very useful for ftrace.
>>
>> I'm glad for your suggestions.
>>
>>
>> Xiao Guangrong, could you add forward declarations of
>>
>> struct irqaction;
>> struct softirq_action;
>>
>> at the top of trace/irq.h as Mathieu's suggestions.
>> (and remove "#include <linux/interrupt.h>")
>>
> 
> You will probably still need something like :
> 
> #ifdef CREATE_TRACE_POINTS
> #include <linux/interrupt.h>
> #else
> struct irqaction;
> struct softirq_action;
> #endif
> 

It's not needed for trace/events/irq.h

Yes, it's a solution.

But I don't think we have to do this, CREATE_TRACE_POINTS is
needed only _once_ for every <trace/events/xxxx.h>

The .c file which defines CREATE_TRACE_POINTS can provide
(had provided likely) things like "#include <linux/interrupt.h>"

See kernel/softirq.c:
#include <linux/interrupt.h>
......
......
#define CREATE_TRACE_POINTS
#include <trace/events/irq.h>

I don't think it's a problem, CREATE_TRACE_POINTS is defined only
once for a <trace/events/xxxx.h>.

Lai.

