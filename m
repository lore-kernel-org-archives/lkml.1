Return-Path: <linux-kernel-owner+w=401wt.eu-S1753118Ab0AZDdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118Ab0AZDdR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 22:33:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113Ab0AZDdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 22:33:16 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62874 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752004Ab0AZDdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 22:33:16 -0500
Message-ID: <4B5E622E.9090106@cn.fujitsu.com>
Date: Tue, 26 Jan 2010 11:31:58 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/6] : bug fix, remove partial zero out
References: <4B556064.7080700@cn.fujitsu.com> <20100120175205.GA5017@nowhere>
In-Reply-To: <20100120175205.GA5017@nowhere>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Tue, Jan 19, 2010 at 03:33:56PM +0800, Lai Jiangshan wrote:
>> partial-zero-out a struct is very dangerous, we should zero out
>> field by field directly when need.
>>
>> partial-zero-out for struct trace_iterator exists when ftrace
>> was first introduced into mainline kernel. But in this few years,
>> the code of ftrace is changed a lot, and:
>>
>> 1) partial-zero-out for struct trace_iterator has a bug now,
>>    cpumask_var_t started should not be zeroed out.
>>
>> 2) I viewed the codes and found that fields below
>>    "/* The below is zeroed out in pipe_read */"
>>    don't need to be zeroed out or initialized now.
>>
>> So, we remove the code of "partial zero out"
>>
>> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
>> ---
>> diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
>> index 3ca9485..c6d0e1a 100644
>> --- a/include/linux/ftrace_event.h
>> +++ b/include/linux/ftrace_event.h
>> @@ -54,7 +54,6 @@ struct trace_iterator {
>>  	struct ring_buffer_iter	*buffer_iter[NR_CPUS];
>>  	unsigned long		iter_flags;
>>  
>> -	/* The below is zeroed out in pipe_read */
>>  	struct trace_seq	seq;
>>  	struct trace_entry	*ent;
>>  	int			leftover;
>> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
>> index 5314c90..27fecf8 100644
>> --- a/kernel/trace/trace.c
>> +++ b/kernel/trace/trace.c
>> @@ -3124,12 +3124,6 @@ waitagain:
>>  	if (cnt >= PAGE_SIZE)
>>  		cnt = PAGE_SIZE - 1;
>>  
>> -	/* reset all but tr, trace, and overruns */
>> -	memset(&iter->seq, 0,
>> -	       sizeof(struct trace_iterator) -
>> -	       offsetof(struct trace_iterator, seq));
>> -	iter->pos = -1;
>> -
> 
> 
> 
> I'm not sure exaclty why we needed to zero the seq here.
> We already reset it in trace_seq_init().
> 
> We might do it again on waitagain. I lost track how we could
> ever need to goto waitagain. It was about a tricky bug to fix
> but I'm don't remember exactly the details.
> 
> That said, if trace_seq_to_user returns -EBUSY, we
> re-init the seq buffer, so it should be fine I guess.

Yes, -EBUSY is strange here.
but any way, trace_seq_init() is called.

> 
> But concerning the need of setting iter->pos to -1, I'm not
> sure we need to remove it. Shouldn't it be set to 0 btw?
> 

->pos is not used here, ->idx is just increased here,
so we don't need to initialize them.

 
