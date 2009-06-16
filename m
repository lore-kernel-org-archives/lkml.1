Return-Path: <linux-kernel-owner+w=401wt.eu-S1755813AbZFPA1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813AbZFPA1n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 20:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751401AbZFPA1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 20:27:34 -0400
Received: from smtp.opengridcomputing.com ([209.198.142.2]:56533 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751179AbZFPA1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 20:27:33 -0400
Message-ID: <4A36E6F2.5050708@opengridcomputing.com>
Date: Mon, 15 Jun 2009 19:27:30 -0500
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: trivial@kernel.org, zygo.blaxell@xandros.com, linux-kernel@vger.kernel.org,
       Jes Sorensen <jes@trained-monkey.org>
Subject: Re: [PATCH] LIB: remove unmatched write_lock() in gen_pool_destroy
References: <E1MGFiZ-0006oN-UW@dactyl.ottawa.xandros.ca>	<alpine.LNX.2.00.0906152333080.7457@wotan.suse.de>	<20090615152608.7f4f6548.akpm@linux-foundation.org>	<4A36CB88.1080300@opengridcomputing.com> <20090615155424.14ad5c6a.akpm@linux-foundation.org>
In-Reply-To: <20090615155424.14ad5c6a.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 15 Jun 2009 17:30:32 -0500
> Steve Wise <swise@opengridcomputing.com> wrote:
>
>   
>> Andrew Morton wrote:
>>     
>>> On Mon, 15 Jun 2009 23:35:31 +0200 (CEST)
>>> Jiri Kosina <trivial@kernel.org> wrote:
>>>
>>>   
>>>       
>>>>> -	write_lock(&pool->lock);
>>>>>  	list_for_each_safe(_chunk, _next_chunk, &pool->chunks) {
>>>>>  		chunk = list_entry(_chunk, struct gen_pool_chunk, next_chunk);
>>>>>  		list_del(&chunk->next_chunk);
>>>>> -- 
>>>>> 1.5.6.5
>>>>>
>>>>>       
>>>>>           
>>>> Hi Zygo,
>>>>
>>>> this doesn't really qualify for trivial tree, as it introduces a 
>>>> significant code change. Adding some CCs.
>>>>     
>>>>         
>>> yep, I merged it, thanks.
>>>
>>> I wonder why drivers/infiniband/hw/cxgb3 users never noticed this.
>>>   
>>>       
>> I seem to remember trying to get this removed a few years ago and the 
>> owner didn't want it removed...
>>
>>     
>
> void gen_pool_destroy(struct gen_pool *pool)
> {
> 	struct list_head *_chunk, *_next_chunk;
> 	struct gen_pool_chunk *chunk;
> 	int order = pool->min_alloc_order;
> 	int bit, end_bit;
>
>
> 	write_lock(&pool->lock);
> 	list_for_each_safe(_chunk, _next_chunk, &pool->chunks) {
> 		chunk = list_entry(_chunk, struct gen_pool_chunk, next_chunk);
> 		list_del(&chunk->next_chunk);
>
> 		end_bit = (chunk->end_addr - chunk->start_addr) >> order;
> 		bit = find_next_bit(chunk->bits, end_bit, 0);
> 		BUG_ON(bit < end_bit);
>
> 		kfree(chunk);
> 	}
> 	kfree(pool);
> 	return;
> }
>
> The write_lock is unneeded and wrong.  Because if any other thread of
> control is concurrently playing with this pool, it will sometimes do a
> use-after-free.
>
> So no other thread of control should have access to this pool, so
> there's no need for the write_lock().
>   

Yup. 

My original patch adding gen_pool_destroy() didn't have the 
write_lock().  It was added as part of "reviewing" the patch. :)

Steve.

