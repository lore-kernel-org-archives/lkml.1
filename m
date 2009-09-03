Return-Path: <linux-kernel-owner+w=401wt.eu-S932417AbZICWJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932417AbZICWJ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 18:09:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932368AbZICWJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 18:09:27 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:49980 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932302AbZICWJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 18:09:26 -0400
Message-ID: <4AA03E6A.7070800@gmail.com>
Date: Fri, 04 Sep 2009 00:08:42 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Patrick McHardy <kaber@trash.net>, Robin Holt <holt@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesper Dangaard Brouer <hawk@comx.dk>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Netfilter Developers <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH] slub: fix slab_pad_check()
References: <4A9EEF07.5070800@gmail.com> <c4e36d110909021531v324a9ce2x3ff2c93b7c5a57de@mail.gmail.com> <4A9F1620.2080105@gmail.com> <84144f020909022331x2b275aa5n428f88670e0ae8bc@mail.gmail.com> <4A9F7283.1090306@gmail.com> <alpine.DEB.1.10.0909031244230.27903@V090114053VZO-1> <4A9FCDC6.3060003@gmail.com> <alpine.DEB.1.10.0909031335430.29881@V090114053VZO-1> <4A9FDA72.8060001@gmail.com> <alpine.DEB.1.10.0909031414310.29881@V090114053VZO-1> <20090903174435.GF6761@linux.vnet.ibm.com> <alpine.DEB.1.10.0909031736340.24199@V090114053VZO-1>
In-Reply-To: <alpine.DEB.1.10.0909031736340.24199@V090114053VZO-1>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Fri, 04 Sep 2009 00:08:44 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter a écrit :
> On Thu, 3 Sep 2009, Paul E. McKenney wrote:
> 
>> 2.	CPU 0 discovers that the slab cache can now be destroyed.
>>
>> 	It determines that there are no users, and has guaranteed
>> 	that there will be no future users.  So it knows that it
>> 	can safely do kmem_cache_destroy().
>>
>> 3.	In absence of rcu_barrier(), kmem_cache_destroy() would
>> 	immediately tear down the slab data structures.
> 
> Of course. This has been discussed before.
> 
> You need to ensure that no objects are in use before destroying a slab. In
> case of DESTROY_BY_RCU you must ensure that there are no potential
> readers. So use a suitable rcu barrier or something else like a
> synchronize_rcu...
> 
>>> But going through the RCU period is pointless since no user of the cache
>>> remains.
>> Which is irrelevant.  The outstanding RCU callback was posted by the
>> slab cache itself, -not- by the user of the slab cache.
> 
> There will be no rcu callbacks generated at kmem_cache_destroy with the
> patch I posted.
> 
>>> The dismantling does not need RCU since there are no operations on the
>>> objects in progress. So simply switch DESTROY_BY_RCU off for close.
>> Unless I am missing something, this patch re-introduces the bug that
>> the rcu_barrier() was added to prevent.  So, in absence of a better
>> explanation of what I am missing:
> 
> The "fix" was ill advised. Slab users must ensure that no objects are in
> use before destroying a slab. Only the slab users know how the objects
> are being used. The slab allocator itself cannot know how to ensure that
> there are no pending references. Putting a rcu_barrier in there creates an
> inconsistency in the operation of kmem_cache_destroy() and an expectation
> of functionality that the function cannot provide.
> 



Problem is not _objects_ Christoph, but _slabs_, and your patch is not working.

Its true that when User calls kmem_cache_destroy(), all _objects_ were previously freed.
This is mandatory, with or withou SLAB_DESTROY_BY_RCU thing

Problem is that slub has some internal state, including some to-be-freed _slabs_,
that User have no control at all on it.

User cannot "know" slabs are freed, inuse, or whatever state in cache or call_rcu queues.

Face it, SLAB_DESTROY_BY_RCU is internal affair (to slub/slab/... allocators)

We absolutely need a rcu_barrier() somewhere, believe it or not. You can argue that it should
be done *before*, but it gives no speedup, only potential bugs.

Only case User should do its rcu_barrier() itself is if it knows some call_rcu() are pending
and are delaying _objects_ freeing (typical !SLAB_DESTROY_RCU usage in RCU algos).

I dont even understand why you care so much about kmem_cache_destroy(SLAB_DESTROY_BY_RCU),
given that almost nobody use it. We took almost one month to find out what the bug was in first
place...
