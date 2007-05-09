Return-Path: <linux-kernel-owner+w=401wt.eu-S1032704AbXEIAsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032704AbXEIAsR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 20:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754877AbXEIAsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 20:48:04 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:44914 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752055AbXEIAsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 20:48:03 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=JNkiulAzO1uTgcou6hIUgOocJ5xuzSR41t/gqhdrJ1emhz3Xw7a7PLiUixfzDg+Em4+zaSr4VcmAZC/znJMwFcIdNIml6nUzcGxu3TEUBQV3nNg4e+tVae1sV7HtZz2ozTS/9TSCT6QE0FbeZHAD/sa8tQDFAP1FXOYOJUJY4go=  ;
X-YMail-OSG: yt6KiC8VM1kmqHbtH2MLf6CidqOJnJVUej7de54WdGRivMzyQkTglRcfF5qT27DOZIoiDIS6HQ--
Message-ID: <46411A36.2050609@yahoo.com.au>
Date: Wed, 09 May 2007 10:47:50 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
CC: vatsa@in.ibm.com, Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       Nathan Lynch <nathanl@austin.ibm.com>,
       Joel Schopp <jschopp@austin.ibm.com>, Ashok Raj <ashok.raj@intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       paulmck@us.ibm.com
Subject: Re: [BUG] cpu-hotplug: Can't offline the CPU with naughty	realtime
 processes
References: <87bqgxrlky.wl%takeuchi_satoru@jp.fujitsu.com>	<1178545373.28438.7.camel@localhost.localdomain>	<877irkrq8a.wl%takeuchi_satoru@jp.fujitsu.com>	<1178593345.28438.29.camel@localhost.localdomain>	<874pmoro1c.wl%takeuchi_satoru@jp.fujitsu.com>	<20070508041033.GB25030@in.ibm.com>	<87irb3g4zt.wl%takeuchi_satoru@jp.fujitsu.com>	<20070508164850.GS7311@in.ibm.com> <87ejlqg77m.wl%takeuchi_satoru@jp.fujitsu.com>
In-Reply-To: <87ejlqg77m.wl%takeuchi_satoru@jp.fujitsu.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satoru Takeuchi wrote:
> At Tue, 8 May 2007 22:18:50 +0530,
> Srivatsa Vaddagiri wrote:
> 
>>On Tue, May 08, 2007 at 04:16:06PM +0900, Satoru Takeuchi wrote:
>>
>>>Sometimes I wonder at prio_array. It has 140 entries(from 0 to 139),
>>>and the meaning of each entry is as follows, I think.
>>>
>>>+-----------+-----------------------------------------------+
>>>| index     | usage                                         |
>>>+-----------+-----------------------------------------------+
>>>| 0 - 98    | RT processes are here. They are in the entry  |
>>>|           | whose index is 99 - sched_priority.           |
>>
>>>From sched.h:
>>
>>/*
>> * Priority of a process goes from 0..MAX_PRIO-1, valid RT
>> * priority is 0..MAX_RT_PRIO-1, and SCHED_NORMAL/SCHED_BATCH
>> * tasks are in the range MAX_RT_PRIO..MAX_PRIO-1.
>>
>>so shouldn't the index for RT processes be 0 - 99, given that
>>MAX_RT_PRIO = 100?
> 
> 
> However `man sched_priority' says...
> 
> 
>        Processes scheduled with SCHED_OTHER or SCHED_BATCH  must
>        be assigned the  static  priority  0. Processes  scheduled
>        under  SCHED_FIFO  or SCHED_RR can have a static priority
>        in the range 1 to 99. The  system calls
>        sched_get_priority_min() and sched_get_priority_max() can
>        be used to find out the valid priority range for a
>        scheduling policy in a portable way on all POSIX.1-2001
>        conforming systems.
> 
> 
> and see the kernel/sched.c ...
> 
> 
>   int sched_setscheduler(struct task_struct *p, int policy,
>                          struct sched_param *param)
>   {
>           ...
>           /*
>            * Valid priorities for SCHED_FIFO and SCHED_RR are
>            * 1..MAX_USER_RT_PRIO-1, valid priority for SCHED_NORMAL and
>            * SCHED_BATCH is 0.
>            */
>           if (param->sched_priority < 0 ||
>               (p->mm && param->sched_priority > MAX_USER_RT_PRIO-1) ||
>               (!p->mm && param->sched_priority > MAX_RT_PRIO-1))
>                   return -EINVAL;
>           if (is_rt_policy(policy) != (param->sched_priority != 0))
>                   return -EINVAL;
>           ...
>   }
> 
> 
> So, if I want to set the rt_prio of a kernel_thread, we can't use this
> entry unless set t->prio to 99 directly. I don't know whether we are
> allowed to write such code bipassing sched_setscheduler(). In addition,
> even if kernel_thread can use this index , I can't understand it's usage.
> It can only be used by kernel, but its priority is LOWER than any real
> time thread.
> 
> If the rule can be changed to the following...
> 
> +-----------+-----------------------------------------------+
> | index     | usage                                         |
> +-----------+-----------------------------------------------+
> | 0         | RT processes are here. Only kernel can use    |
> |           | this entry.                                   |
> +-----------+-----------------------------------------------+
> | 1 - 99    | RT processes are here. They are in the entry  |
> |           | whose index is 99 - sched_priority.           |
> +-----------+-----------------------------------------------+
> | 100 - 139 | Ordinally processes are here. They are in the |
> |           | entry whose index is (nice+120) +/- 5         |
> +-----------+-----------------------------------------------+
> 
> ... there will be an entry only used by kernel and its priority is HIGHER
> than any user process, and I'll get happy :-)

We've seen the same problem with other stop_machine_run sites in the kernel.
module remove was one.

Reserving the top priority slot for stop machine (and migration thread, I
guess) isn't a bad idea.

-- 
SUSE Labs, Novell Inc.
