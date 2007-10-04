Return-Path: <linux-kernel-owner+w=401wt.eu-S1758818AbXJDJAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758818AbXJDJAQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 05:00:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754254AbXJDJAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 05:00:00 -0400
Received: from sacred.ru ([62.205.161.221]:58852 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753939AbXJDI77 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 04:59:59 -0400
Message-ID: <4704AAC5.2040701@openvz.org>
Date: Thu, 04 Oct 2007 12:56:37 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Andrew Morton <akpm@osdl.org>, Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org, Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 1/3] Introduce the dummy_pid
References: <4703A44F.9020402@openvz.org>	<4703A4D5.3000100@openvz.org> <20071003110610.08156d75.randy.dunlap@oracle.com>
In-Reply-To: <20071003110610.08156d75.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Thu, 04 Oct 2007 12:59:02 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Wed, 03 Oct 2007 18:19:01 +0400 Pavel Emelyanov wrote:
> 
>> This is a pid which is attached to tasks when they detach
>> their pids. This is done in detach_pid() and transfer_pid().
>> The pid_alive() check is changed to reflect this fact.
>>
>> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
>>
>> ---
>>
>> diff --git a/include/linux/sched.h b/include/linux/sched.h
>> index 4f21af1..e17b8f8 100644
>> --- a/include/linux/sched.h
>> +++ b/include/linux/sched.h
>> @@ -1286,9 +1286,11 @@ static inline pid_t task_ppid_nr_ns(stru
>>   * If pid_alive fails, then pointers within the task structure
>>   * can be stale and must not be dereferenced.
>>   */
>> +extern struct pid dummy_pid;
>> +
>>  static inline int pid_alive(struct task_struct *p)
>>  {
>> -	return p->pids[PIDTYPE_PID].pid != NULL;
>> +	return p->pids[PIDTYPE_PID].pid != &dummy_pid;
>>  }
>>  
>>  /**
>> diff --git a/kernel/pid.c b/kernel/pid.c
>> index d7388d7..b7a11cf 100644
>> --- a/kernel/pid.c
>> +++ b/kernel/pid.c
>> @@ -81,6 +81,17 @@ struct pid_namespace init_pid_ns = {
>>  };
>>  EXPORT_SYMBOL_GPL(init_pid_ns);
>>  
>> +struct pid dummy_pid = {
>> +	.count 		= ATOMIC_INIT(1),
>> +	.numbers	= { {
>> +		.nr		= 0,		/* this is what pid_nr will return
>> +						 * for tasks with no pids
>> +						 */
>> +		.ns		= &init_pid_ns,
>> +	}, }
>> +};
>> +EXPORT_SYMBOL(dummy_pid);
> 
> Why is the EXPORT_SYMBOL() needed?

Because pid_alive() uses it and is declared in sched.h, so
some module can use it.

> IOW, is some loadable module going to use this?

Right now - no modules use it. You're right - I will remove this export.

> ---
> ~Randy
> 

