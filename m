Return-Path: <linux-kernel-owner+w=401wt.eu-S1759123AbZE0IWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759123AbZE0IWs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 04:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755537AbZE0IWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 04:22:34 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62390 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754932AbZE0IWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 04:22:32 -0400
Message-ID: <4A1CF77E.20003@cn.fujitsu.com>
Date: Wed, 27 May 2009 16:19:10 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] tracing: create events only when configed
References: <4A167307.7020905@cn.fujitsu.com> <alpine.DEB.2.00.0905261227470.26705@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0905261227470.26705@gandalf.stny.rr.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Fri, 22 May 2009, Lai Jiangshan wrote:
> 
>> There some unneeded events in debugfs/tracing/ftrace/ when the
>> corresponding CONFIG_XXXX=n.
>>
>> And when CONFIG_ENABLE_EVENT_TRACING=n, various events
>> are still created.
>>
>> Now when CONFIG_ENABLE_EVENT_TRACING=n, various events are
>> not created, trace_export.c is compiled only for creating
>> TRACEPOINTs.
>>
>> [Impact:] cleanup
> 
> I have an issue with this patch. I purposely kept the 
> debugfs/tracing/ftrace events there since you may have a binary buffer 
> that you want to read that has those events but you are not running a 
> kernel that enabled them. But I guess the counter arguement for that is 
> then those events may not be the same offset as the kernel that ran it. 
> OK, maybe it would be fine to disable the events if the kernel does not 
> use them. 

All these offset/format/id(except TRACE_EVENT's id) are constant
when kernel built.

Could we GENERATE all these info when kernel built?

This info will be installed to system when we 'make modules_install',
and this info will be put into kernel-XXXXX.rpm by distributions
which enable ftrace.

This will highly help for reading a binary buffer which events
are not for current running kernel. (And this binary buffer is
maybe extracted a vmcore.)

> We should also put the same #ifdef's around the structs to make 
> sure no other trace uses them.

Maybe I miss something,  I have no idea around WHICH structs
we should also put the same #ifdef's. ^_^

> 
> Still seems a bit messy with all those ifdefs :-/
> 
> The second change with the CONFIG_ENABLE_EVENT_TRACER is something that we 
> are having issue with the make scripts. We want EVENT_TRACE enabled 
> anytime TRACING is enabled. We do _not_ want to disable it.
> 

Thank you for told me.

One other thing:

config EVENT_TRACING
	bool

config TRACING
	bool
	select DEBUG_FS
	select RING_BUFFER
	select STACKTRACE if STACKTRACE_SUPPORT
	select TRACEPOINTS
	select NOP_TRACER
	select BINARY_PRINTF
	select EVENT_TRACING

No other config slects EVENT_TRACING, it means TRACING and EVENT_TRACING are the same thing, can we covert all config EVENT_TRACING to config TRACING, and remove EVENT_TRACING? (or reverse)

Lai

