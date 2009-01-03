Return-Path: <linux-kernel-owner+w=401wt.eu-S1760434AbZACXrM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760434AbZACXrM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 18:47:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755841AbZACXq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 18:46:57 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:38883 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904AbZACXq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 18:46:56 -0500
Date: Sat, 3 Jan 2009 15:46:37 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       laijs@cn.fujitsu.com
Subject: Re: [RFC, PATCH] kernel/rcu: add kfree_rcu
Message-ID: <20090103234637.GD6958@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <200901021159.n02BxDLg024728@mail.q-ag.de> <20090102185543.GE6842@linux.vnet.ibm.com> <495F7D5C.3060905@colorfullife.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <495F7D5C.3060905@colorfullife.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 03, 2009 at 03:59:40PM +0100, Manfred Spraul wrote:
> Paul E. McKenney wrote:
>> I would suggest instead using the bottom bit to differentiate between
>> these two cases, especially given that your approach makes it impossible
>> for callback processing to notice a NULL function pointer.  In addition,
>> this approach would allow different types of allocators to be specified
>> should this later prove to be helpful.  You should not have to shift the
>> offset because the rcu_head offset should always be a multiple of four
>> (or eight on 64-bit architectures).
>>   
> We must be careful: rcu_head might be always aligned, but are function 
> pointers always aligned?
> The x86 hardware allows arbitrary function pointers, I'm not sure what gcc 
> would do if '--falign-functions=0' is used.
> Are there other codepaths that assume that the lowest bit of a function 
> pointer is never set?

Good point.  I guess that we will have to worry about expandability when
and if the need arises.  I see a couple of ways of doing it, but they
are pretty ugly...

>> And we really are running into bugs that are detected by RCU's seeing a
>> null function pointer in the rcu_head structure at callback-invocation
>> time.  So, whatever encoding you choose, please leave a function-pointer
>> value of zero as an invalid value!
>>   
> Ok.
>
>>> --- a/kernel/rcutree.c
>>> +++ b/kernel/rcutree.c
>>> @@ -901,7 +901,7 @@ static void rcu_do_batch(struct rcu_data *rdp)
>>>  	while (list) {
>>>  		next = list->next;
>>>  		prefetch(next);
>>> -		list->func(list);
>>> +		rcu_docallback(list);
>>>     
>>
>> Good, you got all three of them!  ;-)
>>
>>   
> The patch was tested against rcutree ;-)

;-)

							Thanx, Paul
