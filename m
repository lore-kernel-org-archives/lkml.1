Return-Path: <linux-kernel-owner+w=401wt.eu-S1752229Ab0AZDIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229Ab0AZDIn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 22:08:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751795Ab0AZDIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 22:08:39 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54327 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751658Ab0AZDIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 22:08:38 -0500
Message-ID: <4B5E5C59.2080203@cn.fujitsu.com>
Date: Tue, 26 Jan 2010 11:07:05 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 5/6] tracing: reduce latency and remove percpu trace_seq
References: <4B55607E.8070403@cn.fujitsu.com> <20100120192225.GC6194@nowhere>
In-Reply-To: <20100120192225.GC6194@nowhere>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Tue, Jan 19, 2010 at 03:34:22PM +0800, Lai Jiangshan wrote:
>> __print_flags() and __print_symbolic() use percpu trace_seq:
>>
>> 1) Its memory is preallocated, it wastes memory when we don't use tracing.
>> 2) It wastes memory for multi-cpus system.
>> 3) It disables preemption when it executes its core routine
>>    "trace_seq_printf(s, "%s: ", #call);" and introduce latency
>>    for more important process.
>>
>> So we move this trace_seq to struct trace_iterator.
>>
>> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
>> ---
>> diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
>> index be9ece5..348500d 100644
>> --- a/include/linux/ftrace_event.h
>> +++ b/include/linux/ftrace_event.h
>> @@ -12,9 +12,6 @@ struct dentry;
>>  
>>  #define FTRACE_SEQ_BUFSIZE PAGE_SIZE
>>  
>> -DECLARE_PER_CPU(struct trace_seq, ftrace_event_seq);
>> -DECLARE_PER_CPU(unsigned char[FTRACE_SEQ_BUFSIZE], ftrace_event_buffer);
>> -
>>  struct trace_print_flags {
>>  	unsigned long		mask;
>>  	const char		*name;
>> @@ -60,6 +57,10 @@ struct trace_iterator {
>>  	struct trace_seq	seq;
>>  	unsigned char		buffer[FTRACE_SEQ_BUFSIZE];
>>  
>> +	/* trace_seq for __print_flags() and __print_symbolic() */
>> +	struct trace_seq	tmp_seq;
>> +	unsigned char 		tmp_buffer[FTRACE_SEQ_BUFSIZE];
> 
> 
> 
> 
> Well, I don't like much that because it's a temporary buffer
> in trace iter only used by few events.
> But the problem is indeed tricky.
> 
> May be should we use a kmalloc in raw_output?
> 

But we have to preallocate it before raw_output().
a kmalloc in raw_output make ftrace_dump() unhappy.

At real system, tracepoints are used more frequently,
So it is not "only used by few events."

But maybe FTRACE_SEQ_BUFSIZE is too large, 128 is enough.
