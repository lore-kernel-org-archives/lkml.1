Return-Path: <linux-kernel-owner+w=401wt.eu-S1755044AbYJGPFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044AbYJGPFf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 11:05:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752615AbYJGPFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 11:05:20 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:52944 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752961AbYJGPFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 11:05:18 -0400
Date: Tue, 7 Oct 2008 08:05:10 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, minyard@acm.org,
       Linux Kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       shemminger@vyatta.com
Subject: Re: [PATCH 3/3] Convert the UDP hash lock to RCU
Message-ID: <20081007150510.GF6384@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20081006185026.GA10383@minyard.local> <48EA8197.6080502@cosmosbay.com> <1223367480.26330.7.camel@lappy.programming.kicks-ass.net> <48EB2AE3.3080200@cosmosbay.com> <48EB6EE4.8030703@linux-foundation.org> <48EB7747.9060505@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <48EB7747.9060505@cosmosbay.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2008 at 04:50:47PM +0200, Eric Dumazet wrote:
> Christoph Lameter a écrit :
>> Eric Dumazet wrote:
>>>>> Or just add SLAB_DESTROY_BY_RCU to slab creation in proto_register()
>>>>> for "struct proto udp_prot/udpv6_prot" so that kmem_cache_free() done
>>>>> in sk_prot_free() can defer freeing to RCU...
>>>> Be careful!, SLAB_DESTROY_BY_RCU just means the slab page gets
>>>> RCU-freed, this means that slab object pointers stay pointing to valid
>>>> memory, but it does _NOT_ mean those slab objects themselves remain
>>>> valid.
>>>>
>>>> The slab allocator is free to re-use those objects at any time -
>>>> irrespective of the rcu-grace period. Therefore you will have to be able
>>>> to validate that the object you point to is indeed the object you
>>>> expect, otherwise strange and wonderful things will happen.
>>>>
>>> Thanks for this clarification. I guess we really need a rcu head then :)
>> No you just need to make sure that the object you located is still active
>> (f.e. refcount > 0) and that it is really a match (hash pointers may be
>> updated asynchronously and therefore point to the object that has been 
>> reused
>> for something else).
>> Generally it is advisable to use SLAB_DESTROY_BY_RCU because it preserves 
>> the
>> cache hot advantages of the objects. Regular RCU freeing will let the 
>> object
>> expire for a tick or so which will result in the cacheline cooling down.
>
> Seems really good to master this SLAB_DESTROY_BY_RCU thing (I see almost no 
> use of it in current kernel)

It is not the easiest thing to use...

> 1) Hum, do you know why "struct file" objects dont use SLAB_DESTROY_BY_RCU 
> then, since we noticed a performance regression for several workloads at 
> RCUification of file structures ?
>
> 2) What prevents an object to be *freed* (and deleted from a hash chain), 
> then re-allocated and inserted to another chain (different keys) ? (final 
> refcount=1)

Nothing prevents this from happening.  You either have to have some sort
of validation step based on object identity (e.g., a generation number
that is incremented on each allocation), or have an algorithm that
doesn't care if searches sometimes spuriously fail to find something
that really is in the list.

Which is one of the reasons that its use is rare.  But perhaps more
experience with it will show more/better ways to use it.

> If the lookup detects a key mismatch, how will it continue to the next 
> item, since 'next' pointer will have been reused for the new chain
> insertion...
>
> Me confused...

One way to approach this is to have a generation number that is
incremented each time the object is recycled along with a pointer to the
list header.  The list header contains the most recent generation number
of any element in the list.  Then if either the generation number of
a give element is greater than that of the header when you started the
search, or the element's pointer no longer references the list header
you started your search from, restart the search.  Read-side memory
barriers may also be required in some cases.

It may be possible to simplify this in some special cases.

There are probably better ways to approach this, but that is one way.

						Thanx, Paul
