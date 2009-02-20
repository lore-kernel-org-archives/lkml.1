Return-Path: <linux-kernel-owner+w=401wt.eu-S1758165AbZBTO55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758165AbZBTO55 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 09:57:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752456AbZBTO5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 09:57:48 -0500
Received: from fk-out-0910.google.com ([209.85.128.186]:65322 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198AbZBTO5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 09:57:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=l+nyvTNnKadM9bhdnOdCkEO7Go0qFOT+XdJ+bXgZIcFgryz5znpXPcQABr+l7Bl+Dg
         uCA8rGejjbCpqB9PCAiVa728vu7pnHpXa8FZ4ytNy8uINGc7Jr/RjfWHab+d4Nz4sWZH
         a/gTpdO2IkmshRkH3ZEVNvXRJEqHp8F7piM4E=
MIME-Version: 1.0
In-Reply-To: <20090220140157.GA12799@elte.hu>
References: <20090220134121.GA19575@damson.getinternet.no>
	 <20090220135000.GA9616@elte.hu> <20090220140157.GA12799@elte.hu>
Date: Fri, 20 Feb 2009 15:51:28 +0100
Message-ID: <19f34abd0902200651k7e86aebay5398ef5ac0578561@mail.gmail.com>
Subject: Re: [PATCH] mm: fix lazy vmap purging (use-after-free error)
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: stable@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/2/20 Ingo Molnar <mingo@elte.hu>:
>
> * Ingo Molnar <mingo@elte.hu> wrote:
>
>> ah, indeed:
>>
>>         list_del_rcu(&va->list);
>>
>> i suspect it could be hit big time in a workload that opens
>> more than 512 files, as expand_files() uses a
>> vmalloc()+vfree() pair in that case.
>
> hm, perhaps it's not a problem after all. The freeing is done
> via rcu, and list_del_rcu() leaves the forward pointer intact.

Well, it's not the particular line that you posted, in any case.
That's &va->list, but the traversed list is &va->purge_list.

I thought it would be the line:

        call_rcu(&va->rcu_head, rcu_free_va);

(which does kfree() in the callback) that was the problem.

>
> So how did it happen that the entry got kfree()d before the loop
> was done? We are in a spinlocked section so the CPU should not
> have entered rcu processing.

I added some printks to __free_vmap_area() and rcu_free_va(), and it
shows that the kfree() is being called immediately (inside the list
traversal). So the call_rcu() is happening immediately (or almost
immediately).

If I've understood correctly, the RCU processing can happen inside a
spinlock, as long as interrupts are enabled. (Won't the timer IRQ
trigger softirq processing, which triggers RCU callback processing,
for example?)

And interrupts are enabled when this happens: EFLAGS: 00000292

Please correct me if I am wrong!


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
