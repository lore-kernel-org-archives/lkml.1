Return-Path: <linux-kernel-owner+w=401wt.eu-S1753699AbZKVLKL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699AbZKVLKL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 06:10:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751659AbZKVLKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 06:10:10 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:42494 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbZKVLKJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 06:10:09 -0500
X-Greylist: delayed 377 seconds by postgrey-1.27 at vger.kernel.org; Sun, 22 Nov 2009 06:10:08 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=WGljB/0PdJMw4uIOYqU99MSBsPRbp+JacNGaqE0GGgKCTI9GRNZLDXp2J95CkIz6B3
         wWQ7ghMRZVp81IV1lyr1BM8Iam1ca9JMusIgoHjiLxsm+hw/6GTnkoSM6ssnkY7D4O0S
         svD9cpvDJT4FBgr5CMHPZohQMtaBvon/57dfU=
MIME-Version: 1.0
In-Reply-To: <b8bf37780911220252j4c790fa0we739dcdc27dd6212@mail.gmail.com>
References: <80d3c5c680300de7ebd41aba89723a5cf45396ed.1258783305.git.andre.goddard@gmail.com>
	 <84144f020911220117p5c4720e0g58587b97efdbb46b@mail.gmail.com>
	 <b8bf37780911220252j4c790fa0we739dcdc27dd6212@mail.gmail.com>
Date: Sun, 22 Nov 2009 13:03:56 +0200
X-Google-Sender-Auth: fe6cc9d4ed4a55be
Message-ID: <84144f020911220303r3b2d72cgdcd0caa096c47c9f@mail.gmail.com>
Subject: Re: [PATCH] pid: tighten pidmap_lock critical section
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Oleg Nesterov <oleg@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andre,

On Sun, Nov 22, 2009 at 12:52 PM, André Goddard Rosa
<andre.goddard@gmail.com> wrote:
> Hi, Pekka!
>
> On Sun, Nov 22, 2009 at 7:17 AM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
>> Hi Andre,
>>
>> On Sat, Nov 21, 2009 at 8:04 AM, André Goddard Rosa
>> <andre.goddard@gmail.com> wrote:
>>> Avoid calling kfree() under pidmap_lock and doing unnecessary work.
>>> It doesn't change behavior.
>>>
>>> It decreases code size by 16 bytes on my gcc 4.4.1 on Core 2:
>>>   text    data     bss     dec     hex filename
>>>   4314    2216       8    6538    198a kernel/pid.o-BEFORE
>>>   4298    2216       8    6522    197a kernel/pid.o-AFTER
>>>
>>> Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
>>
>> This patch is doing a lot more than the changelog above says it does.
>> What exactly is the purpose of this patch? What's the upside?
>
> Purpose is to make the spinlock critical section tighter by removing
> unnecessary instructions from under pidmap_lock.
>
> I was getting to learn about pid.c and noticed a slightly decrease in
> the amount of work done with the spinlock held by checking the
> generated assembly before/after the changes.
>
> So I had a question: while these are very small changes, they make the
> code under the critical section smaller, coming at a slightly decrease
> in legibility (initializing variables outside the lock), but still not
> complex compared to other kernel code.
>
> In all kernel code I can see postponing assignments until the time
> it's really necessary to do it. So I thought that perhaps anticipating
> the assignment to make it just outside of the critical section could
> make a small improvement in the cases where code was contending for
> that lock because the critical section would be smaller by a small
> bit, but still.
>
>>> ---
>>>  kernel/pid.c |   16 ++++++++--------
>>>  1 files changed, 8 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/kernel/pid.c b/kernel/pid.c
>>> index d3f722d..ec06912 100644
>>> --- a/kernel/pid.c
>>> +++ b/kernel/pid.c
>>> @@ -141,11 +141,12 @@ static int alloc_pidmap(struct pid_namespace *pid_ns)
>>>                         * installing it:
>>>                         */
>>>                        spin_lock_irq(&pidmap_lock);
>>> -                       if (map->page)
>>> -                               kfree(page);
>>> -                       else
>>> +                       if (!map->page) {
>>>                                map->page = page;
>>> +                               page = NULL;
>>> +                       }
>>>                        spin_unlock_irq(&pidmap_lock);
>>> +                       kfree(page);
>>
>> OK, maybe. The upside seem rather small and the resulting code is IMHO
>> slightly less readable.
>
> Motivation is that normally I don't see many other places in the
> kernel where allocation/release of memory is made under spinlocks.
>
> In fact there's no need why that page is freed (somewhat complex
> operation) under the spinlock, so I realized that it could be
> postponed to just after releasing the lock, which seemed a good idea.

Actually, the kfree() above will not result in a page free most of the
time with any of the current slab allocators. Instead the kfree()'d
object is put back in the cache which is pretty fast operation. But
anyway, I don't have huge objections to the above hunk as long as it's
a standalone patch.

>>>                        if (unlikely(!map->page))
>>>                                break;
>>>                }
>>> @@ -225,11 +226,11 @@ static void delayed_put_pid(struct rcu_head *rhp)
>>>  void free_pid(struct pid *pid)
>>>  {
>>>        /* We can be called with write_lock_irq(&tasklist_lock) held */
>>> -       int i;
>>> +       int i = 0;
>>>        unsigned long flags;
>>>
>>>        spin_lock_irqsave(&pidmap_lock, flags);
>>> -       for (i = 0; i <= pid->level; i++)
>>> +       for ( ; i <= pid->level; i++)
>>>                hlist_del_rcu(&pid->numbers[i].pid_chain);
>>>        spin_unlock_irqrestore(&pidmap_lock, flags);
>>
>> This has nothing to do with kfree(). AFAICT, it just obfuscates the
>> code as the initial assignment to zero is lost in the noise anyway.
>
> See comments above.
> If you really thinks so but agree with the other explanation, I can
> remove this part.

I think this part needs to go away completely.

>>> @@ -268,12 +269,11 @@ struct pid *alloc_pid(struct pid_namespace *ns)
>>>        for (type = 0; type < PIDTYPE_MAX; ++type)
>>>                INIT_HLIST_HEAD(&pid->tasks[type]);
>>>
>>> +       upid = pid->numbers + ns->level;
>>>        spin_lock_irq(&pidmap_lock);
>>> -       for (i = ns->level; i >= 0; i--) {
>>> -               upid = &pid->numbers[i];
>>> +       for ( ; upid >= pid->numbers; --upid)
>>>                hlist_add_head_rcu(&upid->pid_chain,
>>>                                &pid_hash[pid_hashfn(upid->nr, upid->ns)]);
>>> -       }
>>>        spin_unlock_irq(&pidmap_lock);
>>
>> Again, this has nothing to do with kfree(). I suspect this is where
>> most of the 16 byte text savings come from. I'm not convinced it's
>> worth the hit in readability, though.
>
> Yes, you're right, this is where the size reduction comes indeed.
> As you can see, it's a trade-off, but while kernel keeps getting
> bigger, there's still possibility to make it smaller sometimes.

Yeah, put this in a separate patch and lets see if Andrew picks it up.

                          Pekka
