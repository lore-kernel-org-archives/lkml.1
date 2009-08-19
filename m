Return-Path: <linux-kernel-owner+w=401wt.eu-S1751705AbZHSCeH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751705AbZHSCeH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 22:34:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751639AbZHSCeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 22:34:06 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62451 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751596AbZHSCeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 22:34:06 -0400
Message-ID: <4A8B6481.7040906@cn.fujitsu.com>
Date: Wed, 19 Aug 2009 10:33:37 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing, sched: mark preempt_schedule() notrace
References: <4A8A5FF5.8080609@cn.fujitsu.com> <20090818103853.GB5231@nowhere>
In-Reply-To: <20090818103853.GB5231@nowhere>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Tue, Aug 18, 2009 at 04:01:57PM +0800, Lai Jiangshan wrote:
>> Current preempt_schedule() is not marked notrace. It may be
>> infinite recursion in __trace_graph_return().
>>
>> preempt_schedule()
>>   __trace_graph_return()
>>     ftrace_preempt_disable() (!!return false!!)
>>     ftrace_preempt_enable()
>>       preempt_enable_notrace()
>>          preempt_schedule() (need_resched() may be true again)
> 
> 
> 
> It would happen in __trace_graph_return() , when preempt_schedule()
> has finished its job. It's very unlikely the TIF_NEED_RESCHED is
> set just after (because it has just been cleared).

It hardly happen ...
This doesn't mean it'll never happen.

> But why not. In that case, preempt_schedule() is called again but it's
> not a real tracing recursion.
> 
> That seems like a normal behaviour actually.
> 
> 

It's not normal behavior, preempt_schedule() will not call
preempt_schedule() recursively in any situation when trace is off.

Here, preempt_schedule() is called from __trace_graph_return()
when trace_function_graph is on.

preempt_schedule()
  __trace_graph_return()
    preempt_schedule()
      __trace_graph_return()
        ....

So, it's a real tracing recursion.
It hurts the stack.







