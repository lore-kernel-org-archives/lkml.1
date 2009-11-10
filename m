Return-Path: <linux-kernel-owner+w=401wt.eu-S1757550AbZKJSeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757550AbZKJSeV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 13:34:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757540AbZKJSeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 13:34:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:38337 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755938AbZKJSeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 13:34:20 -0500
Message-ID: <4AF9B1FD.1010408@kernel.org>
Date: Wed, 11 Nov 2009 03:33:33 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT PULL] percpu fixes for 2.6.32-rc6
References: <4AF90254.40909@kernel.org> <alpine.LFD.2.01.0911100903370.31845@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0911100903370.31845@localhost.localdomain>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Linus Torvalds wrote:
>> +	if (old) {
>> +		spin_unlock_irqrestore(&pcpu_lock, *flags);
>> +		pcpu_mem_free(old, size);
>> +		spin_lock_irqsave(&pcpu_lock, *flags);
>> +	}
> 
> Routines that drop and then re-take the lock should be banned, as it's 
> almost always a bug waiting to happen. As it is this time:

Yeap, they usually are.  In this case, it's a little bit different.
There are two locks - pcpu_alloc_mutex and pcpu_lock.
pcpu_alloc_mutex protects the whole alloc and reclaim paths while
pcpu_lock protects the part used by free path - area maps in chunks
and pcpu_slot array pointing to chunks.

So, under pcpu_alloc_mutex which pcpu_extend_area_map() is called with
and never drops, the chunk never goes away nor can anything be
allocated from it.  Dropping pcpu_lock only allows free path to come
inbetween and mark areas in the area map of the chunk and maybe
relocate the chunk to another pcpu_slot according to new free area
size - both operations should be safe.  IOW, it's not really dropping
the main lock here.

At first, both alloc and free paths were protected by single mutex.
The original percpu allocator always assumed GFP_KERNEL allocation, so
I thought that should do it.  Unfortunately, I was forgetting about
the free path which was allowed to be called from atomic context, so
the lock was split into two so that the free path can be called from
atomic context.

The reason why this somewhat convoluted locking was chosen over making
both alloc and free paths irq-safe was partly because it was easier
but mostly because percpu allocator's dependence on vmalloc allocator.
All vmalloc area related lockings assume not to be called from irq
context which goes back to having to make cross cpu invalidate calls,
which make it difficult to make percpu allocator irqsafe as a whole.
So, the locking impedance matching was done in the percpu free path
and the temporary inner lock droppings in pcpu_extend_are_map() are
the byproducts.

Christoph Lameter has been saying that atomic percpu allocations would
be beneficial for certain callers.  Pushing the problem down to the
vmalloc layer where the problem originates and making percpu locking
more usual would be nice too.  I'm still not sure whether it would
justify the added complexity (it will probably require putting vmalloc
reclamation path to a workqueue) but that could be the ultimate right
thing to do here.

If I'm missing something, I'm sure you'll hammer it into me.

Thanks.

-- 
tejun
