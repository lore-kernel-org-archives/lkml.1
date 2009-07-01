Return-Path: <linux-kernel-owner+w=401wt.eu-S1755874AbZGACaO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874AbZGACaO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 22:30:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753750AbZGACaD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 22:30:03 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57247 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753055AbZGACaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 22:30:01 -0400
Message-ID: <4A4ACA67.8000002@cn.fujitsu.com>
Date: Wed, 01 Jul 2009 10:31:03 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing: use hash table to simulate the sparse array
References: <4A3F2E38.7030604@cn.fujitsu.com> <4A49D12A.9040901@cn.fujitsu.com> <20090630115949.GB5249@nowhere>
In-Reply-To: <20090630115949.GB5249@nowhere>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Tue, Jun 30, 2009 at 04:47:38PM +0800, Lai Jiangshan wrote:
>> Lai Jiangshan wrote:
>>> Subject: [PATCH] tracing: rewrite trace_save_cmdline()
>>>
>>> I found the sparse array map_pid_to_cmdline[PID_MAX_DEFAULT+1]
>>> wastes too much memory, so I remove it.
>>>
>>> The old FIFO algorithm is replaced with a new one:
>>> Open address hash table with double hash + tick-LRU.
>>>
>>> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
>>> ---
>> This patch reduces the memory usage.(save 128K memory in kernel)
>> But it's too complicated, and it changes the original algorithm.
>>
>> This new patch does NOT change the original algorithm,
>> but it uses a hash table to simulate the sparse array.
>>
>> ---------------
>>
>> Subject: [PATCH] tracing: use hash table to simulate the sparse array
>>
>> I found the sparse array map_pid_to_cmdline[PID_MAX_DEFAULT+1]
>> wastes too much memory, so I remove it.
>>
>> A hash table is added to simulate the sparse array. And
>> map_pid_to_cmdline and map_cmdline_to_pid become light functions.
>>
>> map_pid_to_cmdline[pid] ==> map_pid_to_cmdline(pid)
>> map_cmdline_to_pid[idx] ==> map_cmdline_to_pid(idx)
>>
>> [Impact: save about 127k memory]
>>
>> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
>> ---
>> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
>> index 3aa0a0d..3526b9c 100644
>> --- a/kernel/trace/trace.c
>> +++ b/kernel/trace/trace.c
>> @@ -36,6 +36,7 @@
>>  #include <linux/poll.h>
>>  #include <linux/gfp.h>
>>  #include <linux/fs.h>
>> +#include <linux/hash.h>
>>  
>>  #include "trace.h"
>>  #include "trace_output.h"
>> @@ -648,10 +649,47 @@ void tracing_reset_current_online_cpus(void)
>>  	tracing_reset_online_cpus(&global_trace);
>>  }
>>  
>> -#define SAVED_CMDLINES 128
>> +#define SAVED_CMDLINES_SHIFT 7
>> +#define SAVED_CMDLINES (1 << 7)
>>  #define NO_CMDLINE_MAP UINT_MAX
>> -static unsigned map_pid_to_cmdline[PID_MAX_DEFAULT+1];
>> -static unsigned map_cmdline_to_pid[SAVED_CMDLINES];
>> +
>> +struct cmdline_index {
>> +	struct hlist_node node;
>> +	unsigned int pid;
>> +};
>> +
>> +struct hlist_head map_head[SAVED_CMDLINES];
>> +struct cmdline_index indexes[SAVED_CMDLINES];
>> +
>> +static unsigned int map_pid_to_cmdline(unsigned int pid)
>> +{
>> +	struct cmdline_index *index;
>> +	struct hlist_node *n;
>> +	unsigned int hash = hash_32(pid, SAVED_CMDLINES_SHIFT);
>> +
>> +	hlist_for_each_entry(index, n, &map_head[hash], node) {
>> +		if (index->pid == pid)
>> +			return index - indexes;
>> +	}
>> +
>> +	return NO_CMDLINE_MAP;
>> +}
>> +
>> +static unsigned int map_cmdline_to_pid(unsigned int idx)
>> +{
>> +	return indexes[idx].pid;
>> +}
>> +
>> +static void do_map_cmdline_index(unsigned int idx, unsigned int pid)
>> +{
>> +	unsigned int hash = hash_32(pid, SAVED_CMDLINES_SHIFT);
>> +
>> +	if (map_cmdline_to_pid(idx) != NO_CMDLINE_MAP)
>> +		hlist_del(&indexes[idx].node);
>> +	indexes[idx].pid = pid;
>> +	hlist_add_head(&indexes[idx].node, &map_head[hash]);
>> +}
> 
> 
> 
> If I understand well, you won't ever have more than one
> entry per map_head[x]

The hash value of a pid determines which map_head[hash] is used.
There are maybe 2 pids with the same hash value. They will use
the same head map_head[hash] (but with different idx).

Then this map_head[hash] has more than one entry.

> 
> So why are you using a hashlist that supports more than one
> entry (the use of hlist_head op).
> 
> You could use a simple hashlist with only one entry on each
> index to map the pid.
> 
> But the background idea of your patch looks good indeed.
> 
> Thanks.
>

