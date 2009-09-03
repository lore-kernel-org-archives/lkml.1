Return-Path: <linux-kernel-owner+w=401wt.eu-S1756157AbZICTB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157AbZICTB1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 15:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755026AbZICTB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 15:01:26 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:63264 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754460AbZICTBZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 15:01:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=mU6yVpJu01y2XJEDp2tb6At689R23EB110fpDH6aJU6oEneoPT62ada1fpmAZHpD9e
         2Ux/hUNeAS1U1z8I3891MdKCdEthsxaCBhb+ADyoE//QpexYqGBlMn4UroucEr/Yo3Ij
         pe90od1U7EBYrQvx21yeUMycKrBiMIgEObwS4=
MIME-Version: 1.0
In-Reply-To: <4AA00400.1030005@gmail.com>
References: <c4e36d110908110542l3de51aaepcbd62c84b9848f2b@mail.gmail.com>
	 <4A9F1620.2080105@gmail.com>
	 <84144f020909022331x2b275aa5n428f88670e0ae8bc@mail.gmail.com>
	 <4A9F7283.1090306@gmail.com>
	 <alpine.DEB.1.10.0909031244230.27903@V090114053VZO-1>
	 <4A9FCDC6.3060003@gmail.com>
	 <alpine.DEB.1.10.0909031335430.29881@V090114053VZO-1>
	 <4A9FDA72.8060001@gmail.com>
	 <alpine.DEB.1.10.0909031414310.29881@V090114053VZO-1>
	 <4AA00400.1030005@gmail.com>
Date: Thu, 3 Sep 2009 22:00:04 +0300
X-Google-Sender-Auth: 74b4a59cee3eabdb
Message-ID: <84144f020909031200r13ecb8f4ka62094c306740b2e@mail.gmail.com>
Subject: Re: [PATCH] slub: fix slab_pad_check()
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Patrick McHardy <kaber@trash.net>, Robin Holt <holt@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesper Dangaard Brouer <hawk@comx.dk>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Netfilter Developers <netfilter-devel@vger.kernel.org>,
       paulmck@linux.vnet.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 3, 2009 at 8:59 PM, Eric Dumazet<eric.dumazet@gmail.com> wrote:
> Christoph Lameter a écrit :
>> On Thu, 3 Sep 2009, Eric Dumazet wrote:
>>
>>> Point is we cannot deal with RCU quietness before disposing the slab cache,
>>> (if SLAB_DESTROY_BY_RCU was set on the cache) since this disposing *will*
>>> make call_rcu() calls when a full slab is freed/purged.
>>
>> There is no need to do call_rcu calls for frees at that point since
>> objects are no longer in use. We could simply disable SLAB_DESTROY_BY_RCU
>> for the final clearing of caches.
>>
>>> And when RCU grace period is elapsed, the callback *will* need access to
>>> the cache we want to dismantle. Better to not have kfreed()/poisoned it...
>>
>> But going through the RCU period is pointless since no user of the cache
>> remains.
>>
>>> I believe you mix two RCU uses here.
>>>
>>> 1) The one we all know, is use normal caches (!SLAB_DESTROY_BY_RCU)
>>> (or kmalloc()), and use call_rcu(... kfree_something)
>>>
>>>    In this case, you are 100% right that the subsystem itself has
>>>    to call rcu_barrier() (or respect whatever self-synchro) itself,
>>>    before calling kmem_cache_destroy()
>>>
>>> 2) The SLAB_DESTROY_BY_RCU one.
>>>
>>>    Part of cache dismantle needs to call rcu_barrier() itself.
>>>    Caller doesnt have to use rcu_barrier(). It would be a waste of time,
>>>    as kmem_cache_destroy() will refill rcu wait queues with its own stuff.
>>
>> The dismantling does not need RCU since there are no operations on the
>> objects in progress. So simply switch DESTROY_BY_RCU off for close.
>>
>>
>> ---
>>  mm/slub.c |    4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> Index: linux-2.6/mm/slub.c
>> ===================================================================
>> --- linux-2.6.orig/mm/slub.c  2009-09-03 10:14:51.000000000 -0500
>> +++ linux-2.6/mm/slub.c       2009-09-03 10:18:32.000000000 -0500
>> @@ -2594,9 +2594,9 @@ static inline int kmem_cache_close(struc
>>   */
>>  void kmem_cache_destroy(struct kmem_cache *s)
>>  {
>> -     if (s->flags & SLAB_DESTROY_BY_RCU)
>> -             rcu_barrier();
>>       down_write(&slub_lock);
>> +     /* Stop deferring frees so that we can immediately free structures */
>> +     s->flags &= ~SLAB_DESTROY_BY_RCU;
>>       s->refcount--;
>>       if (!s->refcount) {
>>               list_del(&s->list);
>
> It seems very smart, but needs review of all callers to make sure no slabs
> are waiting for final freeing in call_rcu queue on some cpu.
>
> I suspect most of them will then have to use rcu_barrier() before calling
> kmem_cache_destroy(), so why not factorizing code in one place ?

[snip]

Can someone please explain what's the upside in Christoph's approach?
Performance? Correctness? Something else entirely? We're looking at a
tested bug fix here and I don't understand why I shouldn't just go
ahead and merge it. Hmm?

                        Pekka
