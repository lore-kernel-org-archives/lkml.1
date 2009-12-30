Return-Path: <linux-kernel-owner+w=401wt.eu-S1752996AbZL3OyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996AbZL3OyS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 09:54:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752975AbZL3OyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 09:54:17 -0500
Received: from mail.windriver.com ([147.11.1.11]:51698 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971AbZL3OyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 09:54:17 -0500
Message-ID: <4B3B657B.2070009@windriver.com>
Date: Wed, 30 Dec 2009 22:36:43 +0800
From: Wang Liming <liming.wang@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] perf_event: add check for group_list if the parent
 isn't counted
References: <1262172487-13694-1-git-send-email-liming.wang@windriver.com> <1262176125.7135.207.camel@laptop>
In-Reply-To: <1262176125.7135.207.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Dec 2009 14:53:39.0946 (UTC) FILETIME=[DF94F4A0:01CA895F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Wed, 2009-12-30 at 19:28 +0800, Liming Wang wrote:
>> If the parent has no entry in group_list, child_ctx will not be
>> allocated, which will lead dereference of a NULL child_ctx.
> 
> That changelog sucks.
Sorry the changelog is too simple.

> 
> Best I can make of it is that there is a race where the parent gets his
> context instantiated and we manage to get the mutex before the other
> thread manages to add the first event.
> 
> Then we observe parent_event_ctx but have an empty list.
> 
> Is that it?
I didn't find this case.
In my case, if I perf record a existing process with "--pid" and finish record,
and if later the recorded process forks a process, the condition will occur.

Liming Wang
> 
> In that case, would it not be better to change the if (inherited_all)
> condition to if (inherited_all && child_ctx) ?
> 
>> Signed-off-by: Liming Wang <liming.wang@windriver.com>
>> ---
>>  kernel/perf_event.c |    2 ++
>>  1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
>> index 5b987b4..3664c4b 100644
>> --- a/kernel/perf_event.c
>> +++ b/kernel/perf_event.c
>> @@ -5126,6 +5126,8 @@ int perf_event_init_task(struct task_struct *child)
>>  	 */
>>  	mutex_lock(&parent_ctx->mutex);
>>  
>> +	if (list_empty(&parent_ctx->group_list))
>> +		goto exit;
>>  	/*
>>  	 * We dont have to disable NMIs - we are only looking at
>>  	 * the list, not manipulating it:
> 
> 
> 

