Return-Path: <linux-kernel-owner+w=401wt.eu-S1755428AbYJJFdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428AbYJJFdO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 01:33:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752495AbYJJFc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 01:32:58 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59652 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750870AbYJJFc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 01:32:58 -0400
Message-ID: <48EEE86B.6090509@cn.fujitsu.com>
Date: Fri, 10 Oct 2008 13:30:19 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH] markers: bit-field is not thread-safe nor smp-safe
References: <48EEC6AD.4010606@cn.fujitsu.com> <20081010132354.B35F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20081010132354.B35F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> Hi Lai-san,
> 
>> bit-field is not thread-safe nor smp-safe.
>>
>> struct marker_entry.rcu_pending is not protected by any lock
>> in rcu-callback free_old_closure().
>> so we must turn it into a safe type.
> 
> hmmm
> however, char also doesn't smp-safe because some architecture doesn't have
> any byte load/store instruction.
> 
> It seems bogus solution to me ;)

Hi, KOSAKI-san,

	Thank you very much!

	char also doesn't smp-safe if the architecture doesn't have
any byte load/store instruction.

	We must use int, is it right?

Lai

> 
> 
>> detail:
>>
>> I suppose rcu_pending and ptype are store in struct marker_entry.tmp1
>>
>> free_old_closure() side:           change ptype side:
>>
>>                                 |  load struct marker_entry.tmp1
>> --------------------------------|--------------------------------
>>                                 |  change ptype bit in tmp1
>> load struct marker_entry.tmp1   |
>> change rcu_pending bit in tmp1  |
>> store tmp1                      |
>> --------------------------------|--------------------------------
>>                                 |  store tmp1
>>
>> now this result equals that free_old_closure() do not change rcu_pending bit, bug.
>>
>> see also: http://en.wikipedia.org/wiki/Bit_field
>>
>> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
>> ---
>> diff --git a/kernel/marker.c b/kernel/marker.c
>> index 7d1faec..4777218 100644
>> --- a/kernel/marker.c
>> +++ b/kernel/marker.c
>> @@ -62,7 +62,7 @@ struct marker_entry {
>>  	int refcount;	/* Number of times armed. 0 if disarmed. */
>>  	struct rcu_head rcu;
>>  	void *oldptr;
>> -	unsigned char rcu_pending:1;
>> +	unsigned char rcu_pending;
>>  	unsigned char ptype:1;
>>  	char name[0];	/* Contains name'\0'format'\0' */
>>  };
> 
> 
> 
> 
> 
> 


