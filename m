Return-Path: <linux-kernel-owner+w=401wt.eu-S1755901AbZGGIX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901AbZGGIX5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 04:23:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754371AbZGGIXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 04:23:43 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52978 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753689AbZGGIXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 04:23:41 -0400
Message-ID: <4A53060C.5010605@cn.fujitsu.com>
Date: Tue, 07 Jul 2009 16:23:40 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] trace_workqueue: add refcnt to struct	cpu_workqueue_stats
References: <4A51B16F.6010608@cn.fujitsu.com> <4A52E627.10507@cn.fujitsu.com> <20090707080755.GC6173@nowhere>
In-Reply-To: <20090707080755.GC6173@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Tue, Jul 07, 2009 at 02:07:35PM +0800, Li Zefan wrote:
>>> The stat entries can be freed when the stat file is being read.
>>> The worse is, the ptr can be freed immediately after it's returned
>>> from workqueue_stat_start/next().
>>>
>>> Add a refcnt to struct cpu_workqueue_stats to avoid use-after-free.
>>>
>>> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
>>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
>>> ---
>> ...
>>> @@ -175,11 +184,14 @@ static void *workqueue_stat_next(void *prev, int idx)
>>>  				return NULL;
>>>  		} while (!(ret = workqueue_stat_start_cpu(cpu)));
>>>  		return ret;
>>> +	} else {
>>> +		ret = list_entry(prev_cws->list.next,
>>> +				 struct cpu_workqueue_stats, list);
>> I just realized accessing prev_cws->list.next can be invalid!
>>
>> We can fix it by using list_del_init() to delete cws->list in
>> probe_workqueue_destruction(), but then if the race happened,
>> the next time stat_next() is called, NULL will be returned.
>> I guess this is Ok, since the race is rare.
> 
> 
> If you ensure the kref_get/put are under the
> workqueue_cpu_stat(cpu)->lock, it should be fine, right?
> 

Unfortunately no.

It's safe to dereference prev_cws, but not safe to retreive
prevw_cws->list.next.

Suppose: head->n1->n2

T1                      T2
---------------         -------------------
stat_start()
  -> return n1
                        list_del(n1)
                          -> n1->list->next = LIST_POISON1;
stat_next()
  -> prev = n1
    -> list_entry(prev->list.next) !!!

You see why it's not safe..

>  
>> (I never like the design of trace_stat..Fortunately we'll
>> probably switch to perfcounter for this kind of statistics
>> reporting)
> 
> 
> I don't like its design either. I wrote it specifically for
> the branch tracer and didn't think about free-able events :-/
> 

Yeah, for free-able events it's buggy to use trace_stat.
Similar bug exists in ksym_tracer.

Another way to fix it is not use trace_stat but use seq_file
directly. They don't need to be sorted anyway.


