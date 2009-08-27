Return-Path: <linux-kernel-owner+w=401wt.eu-S1751902AbZH0PEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902AbZH0PEf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 11:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751712AbZH0PEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 11:04:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47855 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661AbZH0PEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 11:04:33 -0400
Message-ID: <4A96A137.50904@redhat.com>
Date: Thu, 27 Aug 2009 11:07:35 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Avi Kivity <avi@redhat.com>, Andi Kleen <ak@linux.intel.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       =?UTF-8?B?UHJ6ZW15c8WCYXcgUGF3ZcWCY3p5aw==?= 
	<przemyslaw@pawelczyk.it>,
       Roland McGrath <roland@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [PATCH 06/18] tracing: Ftrace dynamic ftrace_event_call support
References: <1251340337-5640-1-git-send-email-fweisbec@gmail.com> <1251340337-5640-7-git-send-email-fweisbec@gmail.com> <4A95F3BC.3080502@cn.fujitsu.com> <20090827025612.GF6759@nowhere>
In-Reply-To: <20090827025612.GF6759@nowhere>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Thu, Aug 27, 2009 at 10:47:24AM +0800, Li Zefan wrote:
>>> -int trace_define_field(struct ftrace_event_call *call, const char *type,
>>> -		       const char *name, int offset, int size, int is_signed,
>>> +int trace_define_field(struct ftrace_event_call *call, char *type,
>>> +		       char *name, int offset, int size, int is_signed,
>>>   		       int filter_type)
>>
>> I don't see why you remove "const"?
>
>
>
> Because kprobes uses dynamically allocated strings as names.
> That said, I should turn it back to const, it's indeed more sane.
> I don't remember exactly the reason of this. I had to resolve several
> conflicts between Masami's patchset and tracing/core, but I did
> wrong in this part, indeed.

Ah, it should be a regression. My patches were based on an old ftrace
which used char * instead of const char *, before Li enhanced it.

Thank you for pointing it out!

>
>
>
>>>   {
>>>   	struct ftrace_event_field *field;
>>> @@ -92,9 +92,7 @@ int trace_define_common_fields(struct ftrace_event_call *call)
>>>   }
>>>   EXPORT_SYMBOL_GPL(trace_define_common_fields);
>>
>> ...
>>
>>>   	for (i = 0; i<  meta->nb_args; i++) {
>>> -		ret = trace_define_field(call, meta->types[i],
>>> -					 meta->args[i], offset,
>>> +		ret = trace_define_field(call, (char *)meta->types[i],
>>> +					 (char *)meta->args[i], offset,
>>
>> This is not good..
>
>
> Yeah.
>
>
>>
>>>   					sizeof(unsigned long), 0,
>>>   					 FILTER_OTHER);
>>>   		offset += sizeof(unsigned long);
>>> @@ -277,13 +277,13 @@ void ftrace_syscall_exit(struct pt_regs *regs, long ret)
>>>   		trace_current_buffer_unlock_commit(event, 0, 0);
>>>   }
>>
>> ...
>>
>>> -int reg_event_syscall_exit(void *ptr)
>>> +int reg_event_syscall_exit(struct ftrace_event_call *call)
>>>   {
>>>   	int ret = 0;
>>>   	int num;
>>>   	char *name;
>>>
>>> -	name = (char *)ptr;
>>> +	name = (char *)call->data;
>>
>> nitpick: implicit cast is fine.
>>
>>>   	num = syscall_name_to_nr(name);
>>>   	if (num<  0 || num>= FTRACE_SYSCALL_MAX)
>>>   		return -ENOSYS;
>>> @@ -342,12 +342,12 @@ int reg_event_syscall_exit(void *ptr)
>>>   	return ret;
>>>   }
>>>
>>> -void unreg_event_syscall_exit(void *ptr)
>>> +void unreg_event_syscall_exit(struct ftrace_event_call *call)
>>>   {
>>>   	int num;
>>>   	char *name;
>>>
>>> -	name = (char *)ptr;
>>> +	name = (char *)call->data;
>>
>> ditto
>
>
> Ok, I'll send a delta patch to fix these.
>
> Thanks.
>
>
>>
>>>   	num = syscall_name_to_nr(name);
>>>   	if (num<  0 || num>= FTRACE_SYSCALL_MAX)
>>>   		return;
>

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

