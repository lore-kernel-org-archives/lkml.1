Return-Path: <linux-kernel-owner+w=401wt.eu-S1753787AbZKVKxH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787AbZKVKxH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 05:53:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752965AbZKVKxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 05:53:06 -0500
Received: from mail-vw0-f192.google.com ([209.85.212.192]:52106 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726AbZKVKxF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 05:53:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=APHwND50/h1eCbG+NyPq6Igm+A0W2RXxNB34Y1RaQuLxVHgRSEGMJi2Bs3iJXhHlSt
         t8KTQms3vrurUH/GD+2qy2BiNu/919aQkqC96mlhTBAl2ENJ3AfOPk7rrQ+fseNKSgZH
         hc21qAbSlSrZPMIwau5tog6wzN1ECnm7r6BpI=
MIME-Version: 1.0
In-Reply-To: <84144f020911220117p5c4720e0g58587b97efdbb46b@mail.gmail.com>
References: <80d3c5c680300de7ebd41aba89723a5cf45396ed.1258783305.git.andre.goddard@gmail.com> 
	<84144f020911220117p5c4720e0g58587b97efdbb46b@mail.gmail.com>
From: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Date: Sun, 22 Nov 2009 08:52:50 -0200
Message-ID: <b8bf37780911220252j4c790fa0we739dcdc27dd6212@mail.gmail.com>
Subject: Re: [PATCH] pid: tighten pidmap_lock critical section
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Oleg Nesterov <oleg@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Pekka!

On Sun, Nov 22, 2009 at 7:17 AM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> Hi Andre,
>
> On Sat, Nov 21, 2009 at 8:04 AM, André Goddard Rosa
> <andre.goddard@gmail.com> wrote:
>> Avoid calling kfree() under pidmap_lock and doing unnecessary work.
>> It doesn't change behavior.
>>
>> It decreases code size by 16 bytes on my gcc 4.4.1 on Core 2:
>>   text    data     bss     dec     hex filename
>>   4314    2216       8    6538    198a kernel/pid.o-BEFORE
>>   4298    2216       8    6522    197a kernel/pid.o-AFTER
>>
>> Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
>
> This patch is doing a lot more than the changelog above says it does.
> What exactly is the purpose of this patch? What's the upside?

Purpose is to make the spinlock critical section tighter by removing
unnecessary instructions from under pidmap_lock.

I was getting to learn about pid.c and noticed a slightly decrease in
the amount of work done with the spinlock held by checking the
generated assembly before/after the changes.

So I had a question: while these are very small changes, they make the
code under the critical section smaller, coming at a slightly decrease
in legibility (initializing variables outside the lock), but still not
complex compared to other kernel code.

In all kernel code I can see postponing assignments until the time
it's really necessary to do it. So I thought that perhaps anticipating
the assignment to make it just outside of the critical section could
make a small improvement in the cases where code was contending for
that lock because the critical section would be smaller by a small
bit, but still.

>> ---
>>  kernel/pid.c |   16 ++++++++--------
>>  1 files changed, 8 insertions(+), 8 deletions(-)
>>
>> diff --git a/kernel/pid.c b/kernel/pid.c
>> index d3f722d..ec06912 100644
>> --- a/kernel/pid.c
>> +++ b/kernel/pid.c
>> @@ -141,11 +141,12 @@ static int alloc_pidmap(struct pid_namespace *pid_ns)
>>                         * installing it:
>>                         */
>>                        spin_lock_irq(&pidmap_lock);
>> -                       if (map->page)
>> -                               kfree(page);
>> -                       else
>> +                       if (!map->page) {
>>                                map->page = page;
>> +                               page = NULL;
>> +                       }
>>                        spin_unlock_irq(&pidmap_lock);
>> +                       kfree(page);
>
> OK, maybe. The upside seem rather small and the resulting code is IMHO
> slightly less readable.

Motivation is that normally I don't see many other places in the
kernel where allocation/release of memory is made under spinlocks.

In fact there's no need why that page is freed (somewhat complex
operation) under the spinlock, so I realized that it could be
postponed to just after releasing the lock, which seemed a good idea.

>>                        if (unlikely(!map->page))
>>                                break;
>>                }
>> @@ -225,11 +226,11 @@ static void delayed_put_pid(struct rcu_head *rhp)
>>  void free_pid(struct pid *pid)
>>  {
>>        /* We can be called with write_lock_irq(&tasklist_lock) held */
>> -       int i;
>> +       int i = 0;
>>        unsigned long flags;
>>
>>        spin_lock_irqsave(&pidmap_lock, flags);
>> -       for (i = 0; i <= pid->level; i++)
>> +       for ( ; i <= pid->level; i++)
>>                hlist_del_rcu(&pid->numbers[i].pid_chain);
>>        spin_unlock_irqrestore(&pidmap_lock, flags);
>
> This has nothing to do with kfree(). AFAICT, it just obfuscates the
> code as the initial assignment to zero is lost in the noise anyway.

See comments above.
If you really thinks so but agree with the other explanation, I can
remove this part.

>> @@ -268,12 +269,11 @@ struct pid *alloc_pid(struct pid_namespace *ns)
>>        for (type = 0; type < PIDTYPE_MAX; ++type)
>>                INIT_HLIST_HEAD(&pid->tasks[type]);
>>
>> +       upid = pid->numbers + ns->level;
>>        spin_lock_irq(&pidmap_lock);
>> -       for (i = ns->level; i >= 0; i--) {
>> -               upid = &pid->numbers[i];
>> +       for ( ; upid >= pid->numbers; --upid)
>>                hlist_add_head_rcu(&upid->pid_chain,
>>                                &pid_hash[pid_hashfn(upid->nr, upid->ns)]);
>> -       }
>>        spin_unlock_irq(&pidmap_lock);
>
> Again, this has nothing to do with kfree(). I suspect this is where
> most of the 16 byte text savings come from. I'm not convinced it's
> worth the hit in readability, though.

Yes, you're right, this is where the size reduction comes indeed.
As you can see, it's a trade-off, but while kernel keeps getting
bigger, there's still possibility to make it smaller sometimes.

Thanks for your feedback,
André
