Return-Path: <linux-kernel-owner+w=401wt.eu-S1755059AbZHTR0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059AbZHTR0b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 13:26:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755041AbZHTR0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 13:26:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6180 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754815AbZHTR0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 13:26:30 -0400
Message-ID: <4A8D8727.60406@redhat.com>
Date: Thu, 20 Aug 2009 10:25:59 -0700
From: Josh Stone <jistone@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@elte.hu,
       laijs@cn.fujitsu.com, rostedt@goodmis.org, peterz@infradead.org,
       mathieu.desnoyers@polymtl.ca, jiayingz@google.com, mbligh@google.com,
       lizf@cn.fujitsu.com
Subject: Re: [PATCH] tracing: Move tracepoint callbacks into DEFINE
References: <1250580227-24363-1-git-send-email-jistone@redhat.com> <20090819161324.GB2649@redhat.com>
In-Reply-To: <20090819161324.GB2649@redhat.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2009 09:13 AM, Jason Baron wrote:
> On Tue, Aug 18, 2009 at 12:23:47AM -0700, Josh Stone wrote:
>> --- a/kernel/tracepoint.c
>> +++ b/kernel/tracepoint.c
>> @@ -243,6 +243,11 @@ static void set_tracepoint(struct tracepoint_entry **entry,
>>  {
>>  	WARN_ON(strcmp((*entry)->name, elem->name) != 0);
>>  
>> +	if (elem->regfunc && !elem->state && active)
>> +		elem->regfunc();
>> +	else if (elem->unregfunc && elem->state && !active)
>> +		elem->unregfunc();
>> +
>>  	/*
>>  	 * rcu_assign_pointer has a smp_wmb() which makes sure that the new
>>  	 * probe callbacks array is consistent before setting a pointer to it.
>> @@ -262,6 +267,9 @@ static void set_tracepoint(struct tracepoint_entry **entry,
>>   */
>>  static void disable_tracepoint(struct tracepoint *elem)
>>  {
>> +	if (elem->unregfunc && elem->state)
>> +		elem->unregfunc();
>> +
>>  	elem->state = 0;
>>  	rcu_assign_pointer(elem->funcs, NULL);
>>  }
>> @@ -581,15 +589,13 @@ __initcall(init_tracepoints);
>>  
>>  #ifdef CONFIG_FTRACE_SYSCALLS
>>  
>> -static DEFINE_MUTEX(regfunc_mutex);
>> -static int sys_tracepoint_refcount;
>> +static int sys_tracepoint_refcount; /* guarded by tracepoints_mutex */
>>  
>>  void syscall_regfunc(void)
>>  {
>>  	unsigned long flags;
>>  	struct task_struct *g, *t;
>>  
>> -	mutex_lock(&regfunc_mutex);
>>  	if (!sys_tracepoint_refcount) {
>>  		read_lock_irqsave(&tasklist_lock, flags);
>>  		do_each_thread(g, t) {
>> @@ -598,7 +604,6 @@ void syscall_regfunc(void)
>>  		read_unlock_irqrestore(&tasklist_lock, flags);
>>  	}
>>  	sys_tracepoint_refcount++;
>> -	mutex_unlock(&regfunc_mutex);
>>  }
>>  
>>  void syscall_unregfunc(void)
>> @@ -606,7 +611,6 @@ void syscall_unregfunc(void)
>>  	unsigned long flags;
>>  	struct task_struct *g, *t;
>>  
>> -	mutex_lock(&regfunc_mutex);
>>  	sys_tracepoint_refcount--;
>>  	if (!sys_tracepoint_refcount) {
>>  		read_lock_irqsave(&tasklist_lock, flags);
>> @@ -615,6 +619,5 @@ void syscall_unregfunc(void)
>>  		} while_each_thread(g, t);
>>  		read_unlock_irqrestore(&tasklist_lock, flags);
>>  	}
>> -	mutex_unlock(&regfunc_mutex);
>>  }
>>  #endif
> 
> if we disable,  CONFIG_FTRACE_SYSCALLS, then we get undefined references
> to syscall_regfunc, and syscall_unregfunc. So, i think we just need to
> remove the 'CONFIG_FTRACE_SYSCALLS' ifdef here.

This CONFIG check was added by commit 60d970c2 to deal with missing
TIF_SYSCALL_FTRACE.  Perhaps the functions should just have their bodies
#ifdef'ed?

Josh
