Return-Path: <linux-kernel-owner+w=401wt.eu-S1756882AbZJ2XWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882AbZJ2XWw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 19:22:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756803AbZJ2XWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 19:22:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44390 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756744AbZJ2XWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 19:22:51 -0400
Message-ID: <4AEA23AB.9020605@redhat.com>
Date: Thu, 29 Oct 2009 19:22:19 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       "David S. Miller" <davem@davemloft.net>,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: [PATCH 0/3][RFC] tracing/kprobes: prevent jprobes from crashing
 function graph tracer
References: <20091029205151.852744305@goodmis.org>	 <4AEA10EC.8000103@redhat.com> <1256854653.26028.3255.camel@gandalf.stny.rr.com>
In-Reply-To: <1256854653.26028.3255.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Thu, 2009-10-29 at 18:02 -0400, Masami Hiramatsu wrote:\
>>> The solution I am proposing with this patch set is to add a call in
>>> ftrace that lets other code in the kernel permanently disable functions from
>>> being traced by the function and function graph tracer. As a probe function
>>> is registered with jprobes, it calls this new function and that entry
>>> will be removed from being traced.
>>>
>>> I tested this with this patch series and it does solve the problem.
>>>
>>> Some issues though:
>>>
>>> 1) this only works when DYNAMIC_FTRACE is enabled. We can prevent
>>> function graph tracing with jprobes when DYNAMIC_FTRACE is not
>>> enabled through Kconfig dependencies. Or have the registering of
>>> a jprobe permanently disable function graph tracing.
>>
>> IMHO, those *probe handler should be tagged as __kprobes and notrace.
> 
> Yeah, I agree. But how do you guarantee that it does. If one forgets,
> than we still have the issue. We can perhaps test to make sure the
> function is in the kprobes section. But that does not mean they will not
> be notraced. The __kprobes and notrace are no longer in the same set.
> 
>>
>>> 2) This also prevents the function tracer from being able to trace a
>>> function probe, even though the function tracer is not at issue
>>> with this bug.
>>
>> I think we can skip those user handlers, because those are irregular
>> functions and user can control (enable/disable) it.
> 
> True, but it may be nice to still trace them.

Hm, in that case, I think we can change jprobe_return() to call
f-g-tracer's return handler if needed as below;
---
static inline jprobe_return(void)
{
	implicit_function_return();	/* This executes f-g-tracer prologue */
	__jprobe_return();	/* This should be notraced */
}
---

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

