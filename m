Return-Path: <linux-kernel-owner+w=401wt.eu-S932215AbZACO7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215AbZACO7s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 09:59:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758409AbZACO7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 09:59:40 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:38447 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752AbZACO7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 09:59:39 -0500
Message-ID: <495F7D5C.3060905@colorfullife.com>
Date: Sat, 03 Jan 2009 15:59:40 +0100
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       laijs@cn.fujitsu.com
Subject: Re: [RFC, PATCH] kernel/rcu: add kfree_rcu
References: <200901021159.n02BxDLg024728@mail.q-ag.de> <20090102185543.GE6842@linux.vnet.ibm.com>
In-Reply-To: <20090102185543.GE6842@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> I would suggest instead using the bottom bit to differentiate between
> these two cases, especially given that your approach makes it impossible
> for callback processing to notice a NULL function pointer.  In addition,
> this approach would allow different types of allocators to be specified
> should this later prove to be helpful.  You should not have to shift the
> offset because the rcu_head offset should always be a multiple of four
> (or eight on 64-bit architectures).
>   
We must be careful: rcu_head might be always aligned, but are function 
pointers always aligned?
The x86 hardware allows arbitrary function pointers, I'm not sure what 
gcc would do if '--falign-functions=0' is used.
Are there other codepaths that assume that the lowest bit of a function 
pointer is never set?

> And we really are running into bugs that are detected by RCU's seeing a
> null function pointer in the rcu_head structure at callback-invocation
> time.  So, whatever encoding you choose, please leave a function-pointer
> value of zero as an invalid value!
>   
Ok.

>> --- a/kernel/rcutree.c
>> +++ b/kernel/rcutree.c
>> @@ -901,7 +901,7 @@ static void rcu_do_batch(struct rcu_data *rdp)
>>  	while (list) {
>>  		next = list->next;
>>  		prefetch(next);
>> -		list->func(list);
>> +		rcu_docallback(list);
>>     
>
> Good, you got all three of them!  ;-)
>
>   
The patch was tested against rcutree ;-)

--
    Manfred
