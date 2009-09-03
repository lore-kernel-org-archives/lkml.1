Return-Path: <linux-kernel-owner+w=401wt.eu-S1753212AbZICHj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212AbZICHj1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 03:39:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752590AbZICHj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 03:39:26 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:51918 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbZICHjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 03:39:25 -0400
Message-ID: <4A9F7283.1090306@gmail.com>
Date: Thu, 03 Sep 2009 09:38:43 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Patrick McHardy <kaber@trash.net>,
       Christoph Lameter <cl@linux-foundation.org>, Robin Holt <holt@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesper Dangaard Brouer <hawk@comx.dk>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Netfilter Developers <netfilter-devel@vger.kernel.org>,
       paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH] slub: fix slab_pad_check() and SLAB_DESTROY_BY_RCU
References: <c4e36d110908110542l3de51aaepcbd62c84b9848f2b@mail.gmail.com>	 <alpine.DEB.1.10.0908121820410.3257@gentwo.org>	 <c4e36d110908131009l78b29bffvb4d41b90f9b83288@mail.gmail.com>	 <c4e36d110908140233v59421ba6y82192b858210370d@mail.gmail.com>	 <4A87CE60.4020506@gmail.com> <4A896324.3040104@trash.net>	 <c4e36d110909021445l5f44183es9e338437dfbbd195@mail.gmail.com>	 <4A9EEF07.5070800@gmail.com>	 <c4e36d110909021531v324a9ce2x3ff2c93b7c5a57de@mail.gmail.com>	 <4A9F1620.2080105@gmail.com> <84144f020909022331x2b275aa5n428f88670e0ae8bc@mail.gmail.com>
In-Reply-To: <84144f020909022331x2b275aa5n428f88670e0ae8bc@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 03 Sep 2009 09:38:43 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg a écrit :
> On Thu, Sep 3, 2009 at 4:04 AM, Eric Dumazet<eric.dumazet@gmail.com> wrote:
>> Zdenek Kabelac a écrit :
>>> Well I'm not noticing any ill behavior - also note - rcu_barrier() is
>>> there before the cache is destroyed.
>>> But as I said - it's just my shot into the dark - which seems to work for me...
>>>
>> Reading again your traces, I do believe there are two bugs in slub
>>
>> Maybe not explaining your problem, but worth to fix !
>>
>> Thank you
>>
>> [PATCH] slub: fix slab_pad_check() and SLAB_DESTROY_BY_RCU
>>
>> When SLAB_POISON is used and slab_pad_check() finds an overwrite of the
>> slab padding, we call restore_bytes() on the whole slab, not only
>> on the padding.
>>
>> kmem_cache_destroy() should call rcu_barrier() *after* kmem_cache_close()
>> and *before* sysfs_slab_remove() or risk rcu_free_slab()
>> being called after kmem_cache is deleted (kfreed).
>>
>> rmmod nf_conntrack can crash the machine because it has to
>> kmem_cache_destroy() a SLAB_DESTROY_BY_RCU enabled cache.
>>
>> Reported-by: Zdenek Kabelac <zdenek.kabelac@gmail.com>
>> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
>> ---
>> diff --git a/mm/slub.c b/mm/slub.c
>> index b9f1491..0ac839f 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -646,7 +646,7 @@ static int slab_pad_check(struct kmem_cache *s, struct page *page)
>>        slab_err(s, page, "Padding overwritten. 0x%p-0x%p", fault, end - 1);
>>        print_section("Padding", end - remainder, remainder);
>>
>> -       restore_bytes(s, "slab padding", POISON_INUSE, start, end);
>> +       restore_bytes(s, "slab padding", POISON_INUSE, end - remainder, end);
> 
> OK, makes sense.
> 
>>        return 0;
>>  }
>>
>> @@ -2594,8 +2594,6 @@ static inline int kmem_cache_close(struct kmem_cache *s)
>>  */
>>  void kmem_cache_destroy(struct kmem_cache *s)
>>  {
>> -       if (s->flags & SLAB_DESTROY_BY_RCU)
>> -               rcu_barrier();
>>        down_write(&slub_lock);
>>        s->refcount--;
>>        if (!s->refcount) {
>> @@ -2606,6 +2604,8 @@ void kmem_cache_destroy(struct kmem_cache *s)
>>                                "still has objects.\n", s->name, __func__);
>>                        dump_stack();
>>                }
>> +               if (s->flags & SLAB_DESTROY_BY_RCU)
>> +                       rcu_barrier();
>>                sysfs_slab_remove(s);
>>        } else
>>                up_write(&slub_lock);
> 
> The rcu_barrier() call was added by this commit:
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=7ed9f7e5db58c6e8c2b4b738a75d5dcd8e17aad5
> 
> I guess we should CC Paul as well.

Sure !

rcu_barrier() is definitly better than synchronize_rcu() in 
kmem_cache_destroy()

But its location was not really right (for SLUB at least)

SLAB_DESTROY_BY_RCU means subsystem will call kfree(elems) without waiting RCU
grace period.

By the time subsystem calls kmem_cache_destroy(), all previously allocated
elems must have already be kfreed() by this subsystem.

We must however wait that all slabs, queued for freeing by rcu_free_slab(),
are indeed freed, since this freeing needs access to kmem_cache pointer.

As kmem_cache_close() might clean/purge the cache and call rcu_free_slab(),
we must call rcu_barrier() *after* kmem_cache_close(), and before kfree(kmem_cache *s)

Alternatively we could delay this final kfree(s) (with call_rcu()) but would
have to copy s->name in kmem_cache_create() instead of keeping a pointer to
 a string that might be in a module, and freed at rmmod time.

Given that there is few uses in current tree that call kmem_cache_destroy()
on a SLAB_DESTROY_BY_RCU cache, there is no need to try to optimize this
rcu_barrier() call, unless we want superfast reboot/halt sequences...

