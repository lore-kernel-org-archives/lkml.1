Return-Path: <linux-kernel-owner+w=401wt.eu-S1755240AbYKUIR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240AbYKUIR7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 03:17:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752621AbYKUIRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 03:17:48 -0500
Received: from mail.windriver.com ([147.11.1.11]:57759 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752439AbYKUIRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 03:17:48 -0500
Message-ID: <49266DA2.3060705@windriver.com>
Date: Fri, 21 Nov 2008 16:13:22 +0800
From: Wang Liming <liming.wang@windriver.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] function tracing: fix wrong position computing of
 stack_trace
References: <1227236418-6023-1-git-send-email-liming.wang@windriver.com> <1227236418-6023-2-git-send-email-liming.wang@windriver.com> <20081121075256.GA16242@elte.hu>
In-Reply-To: <20081121075256.GA16242@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Nov 2008 08:17:33.0689 (UTC) FILETIME=[9AE6EE90:01C94BB1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Liming Wang <liming.wang@windriver.com> wrote:
> 
>> Impact: make output of stack_trace complete if buffer overflow
>>
>> When read buffer overflows, the output of stack_trace isn't 
>> complete.
>>
>> When printing records with seq_printf in t_show, if the read buffer 
>> has overflowed by the current record, then this record won't be 
>> printed to user space through read buffer, it will just be dropped 
>> in this printing.
>>
>> When next printing, t_start should return the "*pos"th record, which 
>> is the one dropped by previous printing, but it just returns 
>> (m->private + *pos)th record.
>>
>> Here we use a more sane method to implement seq_operations which can 
>> be found in kernel code. Thus we needn't initialize m->private.
>>
>> About testing, it's not easy to overflow read buffer, but we can use 
>> seq_printf to print more padding bytes in t_show, then it's easy to 
>> check whether or not records are lost.
>>
>> This commit has been tested on both condition of overflow and non 
>> overflow.
>>
>> Signed-off-by: Liming Wang <liming.wang@windriver.com>
>> ---
>>  kernel/trace/trace_stack.c |   24 +++++++++++++++---------
>>  1 files changed, 15 insertions(+), 9 deletions(-)
> 
> applied to tip/tracing/urgent, thanks!
> 
> Note, i changed 'buffer overflow' to 'buffer overrun'. (buffer 
> overflow is a term typically used in a security context)
OK.

> 
>> -	i++;
>> +	if (v == SEQ_START_TOKEN )
>> +		i = 0;
>> +	else {
>> +		i = *(long *)v;
>> +		i++;
>> +	}
> 
> i also fixed these two minor style problems pointed out by 
> scripts/checkpatch.pl:
> 
> | ERROR: space prohibited before that close parenthesis ')'
> | #47: FILE: kernel/trace/trace_stack.c:187:
> | +	if (v == SEQ_START_TOKEN )
> |
> | ERROR: space prohibited before that close parenthesis ')'
> | #82: FILE: kernel/trace/trace_stack.c:245:
> | +	if (v == SEQ_START_TOKEN ) {
> |
> | total: 2 errors, 0 warnings, 0 checks, 64 lines checked
It's my fault, thanks a lot!

walimis
> 
> 	Ingo
> 

