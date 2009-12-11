Return-Path: <linux-kernel-owner+w=401wt.eu-S1762253AbZLKCmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762253AbZLKCmV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 21:42:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762223AbZLKCmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 21:42:20 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62348 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1762221AbZLKCmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 21:42:19 -0500
Message-ID: <4B21B172.2080500@cn.fujitsu.com>
Date: Fri, 11 Dec 2009 10:41:54 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Jason Baron <jbaron@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 07/10] trace_syscalls: init print_fmt
References: <4B1F4EA6.5080105@cn.fujitsu.com> <1260491698.2146.322.camel@gandalf.stny.rr.com>
In-Reply-To: <1260491698.2146.322.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Wed, 2009-12-09 at 15:15 +0800, Lai Jiangshan wrote:
>> Init print_fmt for trace_syscalls.
>> It will be used for replacing ->show_format().
> 
> This needs more explanation too.
> 
>> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
>> ---
>> diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
>> index 75289f3..dcd8699 100644
>> --- a/kernel/trace/trace_syscalls.c
>> +++ b/kernel/trace/trace_syscalls.c
>> @@ -191,6 +191,61 @@ int syscall_enter_format(struct ftrace_event_call *call, struct trace_seq *s)
>>  	return trace_seq_putc(s, '\n');
>>  }
>>  
>> +static
>> +int  __set_enter_print_fmt(struct syscall_metadata *entry, char *buf, int len)
>> +{
>> +	int i;
>> +	int pos = 0;
>> +
>> +	pos += snprintf(buf + pos, len > pos ? len - pos : 0, "\"");
>> +	for (i = 0; i < entry->nb_args; i++) {
>> +		pos += snprintf(buf + pos, len > pos ? len - pos : 0,
>> +				"%s: 0x%%0%zulx%s", entry->args[i],
>> +				sizeof(unsigned long),
>> +				i == entry->nb_args - 1 ? "" : ", ");
>> +	}
>> +	pos += snprintf(buf + pos, len > pos ? len - pos : 0, "\"");
>> +
>> +	for (i = 0; i < entry->nb_args; i++) {
>> +		pos += snprintf(buf + pos, len > pos ? len - pos : 0,
>> +				", ((unsigned long)(REC->%s))", entry->args[i]);
> 
> Yuck! 4 snprintf(buf + pos, len > pos ? len - pos: 0 ...
> 
> Please make a wrapper for that.

Do you mind if I use a macro?
Readability are still the same... 

static
int  __set_enter_print_fmt(struct syscall_metadata *entry, char *buf, int len)
{
	int i;
	int pos = 0;

#define BUF_PRINTF(fmt...)						\
do {									\
	pos += snprintf(buf + pos, len > pos ? len - pos : 0, fmt);	\
} while (0)

	BUF_PRINTF("\"");
	for (i = 0; i < entry->nb_args; i++) {
		BUF_PRINTF("%s: 0x%%0%zulx%s", entry->args[i],
				sizeof(unsigned long),
				i == entry->nb_args - 1 ? "\"" : ", ");
	}

	for (i = 0; i < entry->nb_args; i++)
		BUF_PRINTF(", ((unsigned long)(REC->%s))", entry->args[i]);

#under BUF_PRINTF

	/* return the length of print_fmt */
	return pos;
}

> 
> Actually, this could use the new trace_seq code if I separate the
> buffer. You would just need to do:
> 
> 	struct trace_seq s;

I think trace_seq can not help.
__set_enter_print_fmt() is called twice.
We calculate the length at the first time(don't write any thing),
then allocate memory and then really "snprintf" string into the buffer.

-- Lai

> 
> 	trace_seq_init(&s, buf, len);
> 
> 	trace_seq_putc(&s, '"');
> 	for (i = 0; i < entry->nb_args; i++)
> 		trace_seq_printf(&s, "%s: 0x%%0%zulx%s", entry->args[i],
> 				sizeof(unsigned long),
> 				i == entry->nb_args - 1 ? "" : ", ");
> 
> 	trace_seq_putc(&s, '"');
> 
> 	for (i = 0; i < entry->nb_args; i++)
> 		trace_seq_printf(&s, ", ((unsigned long)(REC->%s)",
> 				entry->args[i]);
> 
> 	return s.len;
> 
> 
> Looks much better, and less error prone.
> 
> -- Steve
> 
