Return-Path: <linux-kernel-owner+w=401wt.eu-S1756228AbYFWFhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228AbYFWFhv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 01:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751822AbYFWFhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 01:37:43 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51783 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751540AbYFWFhn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 01:37:43 -0400
Message-ID: <485F3638.5010305@cn.fujitsu.com>
Date: Mon, 23 Jun 2008 13:35:52 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Luis Carlos Cobo <luisca@cozybit.com>,
       Steve Whitehouse <SteveW@acm.org>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       torvalds@linux-foundation.org
Subject: Re: [PATCH]rcu,inet,fib_trie,route,radix-tree,DECnet,mac80211: fix
 meaningless rcu_dereference(local_var)
References: <485CCFC9.2070007@cn.fujitsu.com> <200806231236.51341.nickpiggin@yahoo.com.au>
In-Reply-To: <200806231236.51341.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add CC: Linus Torvalds

Nick Piggin wrote:
> On Saturday 21 June 2008 19:54, Lai Jiangshan wrote:
> 
>> diff --git a/lib/radix-tree.c b/lib/radix-tree.c
>> index 169a2f8..bfae4e2 100644
>> --- a/lib/radix-tree.c
>> +++ b/lib/radix-tree.c
>> @@ -703,9 +703,9 @@ __lookup(struct radix_tree_node *slot, void **results,
>> unsigned long index, for (i = index & RADIX_TREE_MAP_MASK; i <
>> RADIX_TREE_MAP_SIZE; i++) { struct radix_tree_node *node;
>>  		index++;
>> -		node = slot->slots[i];
>> +		node = rcu_dereference(slot->slots[i]);
>>  		if (node) {
>> -			results[nr_found++] = rcu_dereference(node);
>> +			results[nr_found++] = node;
>>  			if (nr_found == max_items)
>>  				goto out;
>>  		}
>> @@ -815,7 +815,7 @@ __lookup_tag(struct radix_tree_node *slot, void
>> **results, unsigned long index, index++;
>>  				if (!tag_get(slot, tag, j))
>>  					continue;
>> -				node = slot->slots[j];
>> +				node = rcu_dereference(slot->slots[j]);
>>  				/*
>>  				 * Even though the tag was found set, we need to
>>  				 * recheck that we have a non-NULL node, because
>> @@ -827,7 +827,6 @@ __lookup_tag(struct radix_tree_node *slot, void
>> **results, unsigned long index, * rely on its value remaining the same).
>>  				 */
>>  				if (node) {
>> -					node = rcu_dereference(node);
>>  					results[nr_found++] = node;
>>  					if (nr_found == max_items)
>>  						goto out;
> 
> This was done like this IIRC to avoid the barrier when possible.
> 
> 
> 
This(http://lkml.org/lkml/2008/4/20/217) shows why rcu_dereference(local_var)
is meaningless. And why not use smp_read_barrier_depends() here?

I guessed somebody use rcu_dereference(local_var) in if-statements to avoid the
barrier when possible, and I made this patch(http://lkml.org/lkml/2008/6/21/29),
but it is incorrect.

